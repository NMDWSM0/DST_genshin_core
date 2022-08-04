local SourceModifierList = require("util/sourcemodifierlist")

local function onmaxlevel(self, maxlevel)
    self.inst.replica.talents._maxlevel:set(maxlevel)
end

local function onlevel_talent1(self, level)
    self.inst.replica.talents._level_talent1:set(level)
end

local function onlevel_talent2(self, level)
    self.inst.replica.talents._level_talent2:set(level)
end

local function onlevel_talent3(self, level)
    self.inst.replica.talents._level_talent3:set(level)
end

local function onextension_update(self, extension)
    self.inst.replica.talents._level_talent3_extension:set(extension % 10)
    self.inst.replica.talents._level_talent2_extension:set((math.floor(extension/10)) % 10)
    self.inst.replica.talents._level_talent1_extension:set(math.floor(extension/100))
end

local Talents = Class(function(self, inst)
    self.inst = inst

    self.maxlevel = 10  --默认最大10级

    self.level_talent1 = 1  --普攻    范围1~10
    self.level_talent2 = 1  --元素战技
    self.level_talent3 = 1  --元素爆发

    --不要直接调用！！！ 调用self:SetExtensionModifier(talent, source, m, key)
    --DO NOT call this directly!!! Use "self:SetExtensionModifier(talent, source, m, key)" instead
    self.level_talent1_extension = SourceModifierList(self.inst, 0, SourceModifierList.additive)  --三个天赋的附加，比如命座之类的
    self.level_talent2_extension = SourceModifierList(self.inst, 0, SourceModifierList.additive)  --范围0~5
    self.level_talent3_extension = SourceModifierList(self.inst, 0, SourceModifierList.additive)

    self.extension_update = 0
    --数字为三位数，代表三个技能的extension数值
    
    self.inst:ListenForEvent("ms_playerreroll", function() 
        self:ReturnIngridents()
    end)
end,
nil,
{
    maxlevel = onmaxlevel,
    level_talent1 = onlevel_talent1,
    level_talent2 = onlevel_talent2,
    level_talent3 = onlevel_talent3,
    extension_update = onextension_update,
})

function Talents:SetTalentLevel(talent, level)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return
    end
    if level == nil or level < 1 then
        level = 1
    elseif level > self.maxlevel then
        level = self.maxlevel
    end

    self["level_talent"..talent] = level
    self.inst:PushEvent("talentsleveldirty")
end

function Talents:SetExtensionModifier(talent, source, m, key)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return
    end
    if self["level_talent"..talent.."_extension"]:Get() + m - self["level_talent"..talent.."_extension"]:CalculateModifierFromSource(source, key) > 5 then
        return
    end

    self["level_talent"..talent.."_extension"]:SetModifier(source, m, key)
    self.inst:PushEvent("talentsleveldirty")
    self.extension_update = 100 * self.level_talent1_extension:Get() + 10 * self.level_talent2_extension:Get() + self.level_talent3_extension:Get()
end

function Talents:GetTalentLevel(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return 1
    end
    return self["level_talent"..talent] + self["level_talent"..talent.."_extension"]:Get()
end

function Talents:GetBaseTalentLevel(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return 1
    end
    return self["level_talent"..talent]
end

function Talents:CanUpgradeTalent(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return false
    end
    return self["level_talent"..talent] < self.maxlevel
end

function Talents:IsWithExtension(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return false
    end
    return self["level_talent"..talent.."_extension"]:Get() > 0
end

function Talents:UpgradeTalent(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return
    end
    self:SetTalentLevel(talent, self["level_talent"..talent] + 1)
end

function Talents:OnSave()
    local data = {}
    data.level_talent1 = self.level_talent1
    data.level_talent2 = self.level_talent2
    data.level_talent3 = self.level_talent3
    return data
end

function Talents:OnLoad(data)
    if data ~= nil then
		self.level_talent1 = data.level_talent1
        self.level_talent2 = data.level_talent2
        self.level_talent3 = data.level_talent3
	end
    self.inst:PushEvent("talentsleveldirty")
end

function Talents:ReturnIngridents()
    local inst = self.inst
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.talents_ingredients == nil then
        return
    end
	
    local return_ingredients = {}
    for t = 1, 3 do
        local level = self:GetBaseTalentLevel(t)
        if level >= 2 then
            for i = 1, level - 1 do
                local ingredients = inst.talents_ingredients[i]
                if ingredients ~= nil then
                    for i, v in ipairs(ingredients) do
                        if return_ingredients[v.type] == nil then
                            return_ingredients[v.type] = v.amount
                        else
                            return_ingredients[v.type] = v.amount + return_ingredients[v.type]
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(return_ingredients) do
        local remain_number = v
        while remain_number > 0 do
            local inv = SpawnPrefab(k)
            if inv ~= nil then
                if inv.components.stackable ~= nil then
                    local maxsize = inv.components.stackable.maxsize
                    if maxsize >= remain_number then
                        inv.components.stackable:SetStackSize(remain_number)
                        remain_number = 0
                    else
                        inv.components.stackable:SetStackSize(maxsize)
                        remain_number = remain_number - maxsize
                    end
                else
                    remain_number = remain_number - 1
                end
                if inv.Physics ~= nil then
                    local speed = 2 + math.random()
                    local angle = math.random() * 2 * PI
                    inv.Physics:Teleport(x, y + 1, z)
                    inv.Physics:SetVel(speed * math.cos(angle), speed * 3, speed * math.sin(angle))
                else
                    inv.Transform:SetPosition(x, y, z)
                end
            else
                break   --to break spawning this invalid ingredient
            end
        end
    end
end

return Talents