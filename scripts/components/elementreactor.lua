local SourceModifierList = require("util/sourcemodifierlist")
local easing = require("easing")

local default_exclude_tags = {
    "FX", "NOCLICK", "DECOR", "INLIMBO", "noauradamage"
}

local player_attacker_exclude_tags = {
    "FX", "NOCLICK", "DECOR", "INLIMBO", "player", "playerghost", "companion", "noauradamage"
}

local genshin_monster_attacker_exclude_tags = {
    "FX", "NOCLICK", "DECOR", "INLIMBO", "genshin_monster", "noauradamage"
}

local function MinShield(ents)
    local min = nil
    local mintime = 100
    for k, v in pairs(ents) do
        if v.components.timer:GetTimeLeft("disappear") < mintime then
            min = v
            mintime = v.components.timer:GetTimeLeft("disappear")
        end
    end
    return min
end

local function OldestBomb(ents)
    local max = nil
    local maxtime = 0
    for k, v in pairs(ents) do
        if v:GetTimeLeft() > maxtime then
            max = v
            maxtime = v:GetTimeLeft()
        end
    end
    return max
end

local function OnIsRaining(inst, israining)
    if israining then --下雨开始更新呢
        inst:StartUpdatingComponent(inst.components.elementreactor)
    end
end

local function OnMoistureDelta(inst, data)
    if data.new > 0 then --潮湿开始更新
        inst:StartUpdatingComponent(inst.components.elementreactor)
    end
end

local function OnIgnite(inst)
    inst:StartUpdatingComponent(inst.components.elementreactor)
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------


local ElementReactor = Class(function(self, inst)
    self.inst = inst

    self.element_stack = 
    {
        --采用LRU算法判断元素攻击者先后次序
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
        { value = 0, attacker = nil, priority = 0 },
    }

    self.persist_element = 0  --完全保持的元素，比如元素怪
    self.half_persist_element = 0  --暂时保持的元素，比如下雨的水附着

    self.reaction_scale = 1
    self.reaction_add = 0

    ----------------------------------------------
    --攻击别人时的元素反应的倍率呢
    --增幅反应：蒸发融化从0开始，加算
    self.attack_melt_bonus_modifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.attack_vaporize_bonus_modifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    --特殊反应：超激化蔓激化
    self.attack_aggravate_bonus_modifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    self.attack_spread_bonus_modifier = SourceModifierList(self.inst, 0, SourceModifierList.additive)
    --下面是聚变反应
    --超导
    self.attack_superconduct_bonus = 1
    self.attack_superconduct_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    --超载
    self.attack_overload_bonus = 1
    self.attack_overload_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    --感电
    self.attack_electrocharged_bonus = 1
    self.attack_electrocharged_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    --扩散
    self.attack_swirl_bonus = 1
    self.attack_swirl_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    --碎冰
    self.attack_shattered_bonus = 1
    self.attack_shattered_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    --绽放，烈绽放，超绽放
    self.attack_bloom_bonus = 1
    self.attack_bloom_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    self.attack_burgeon_bonus = 1
    self.attack_burgeon_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
    self.attack_hyperbloom_bonus = 1
    self.attack_hyperbloom_bonus_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)

    ----------------------------------------------

    self.cooling = {   --不同元素附着单独计算CD
        false,
        false,
        false,
        false,
        false,
        false,
        false
    }
    self.cooling_task = {
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        nil
    }

    self.electrodamage_task = nil

    if TUNING.ELEMENTINDICATOR_ENABLED and not self.inst:HasTag("wall") then
        self.indicator = SpawnPrefab("element_indicator")
    else
        self.indicator = nil
    end

    if self.inst:HasTag("noupdateanim") then
        self.inst:RemoveTag("noupdateanim")
    end

    if not self.inst:HasTag("player") and TUNING.ENABLE_ENVIRONMENT_ELEMENT then
        --沾水或者烧起来，重新开始更新
        self.inst:WatchWorldState("israining", OnIsRaining)
        self.inst:ListenForEvent("moisturedelta", OnMoistureDelta)
        self.inst:ListenForEvent("onignite", OnIgnite)
    end

    self.inst:StartUpdatingComponent(self)
end,
nil,
{
   
})

function ElementReactor:CalcReaction()
    local rate = self.reaction_scale
    local addnumber = self.reaction_add
    self.reaction_scale = 1
    self.reaction_add = 0
    return rate, addnumber
end

function ElementReactor:Push()
    if self.indicator == nil then
        return
    end
    --self.indicator:SetTrackingTarget(self.inst)
    self.inst:PushEvent("element_updated")
end

function ElementReactor:NumberofElement()
    local x = 0
    for i = 1, 7 do
        if self.element_stack[i].value > 0 then
            x = x + 1
        end
    end
    return x
end

function ElementReactor:HasElement()
    for i = 1, 7 do
        if self.element_stack[i].value > 0 then
            return true
        end
    end
    return false
end

function ElementReactor:NewElement(stimuli, value, attacker, ignorecd)
    if stimuli == nil or stimuli == 8 then
        return
    end
    if stimuli == "electric" then
		stimuli = 4
    elseif stimuli == "fire" then
		stimuli = 1
    end

    --被附加元素，重新开始更新
    self.inst:StartUpdatingComponent(self)

    --元素附着CD
    if (not ignorecd) and self.cooling[stimuli] then
        return
    end

    --冷却
    self.cooling[stimuli] = true
    if self.cooling_task[stimuli] ~= nil then
        self.cooling_task[stimuli]:Cancel()
    end
    self.cooling_task[stimuli] = self.inst:DoTaskInTime(1.5, function(inst)
        inst.components.elementreactor.cooling[stimuli] = false 
    end)

    --在处理元素附着之前，先看一下待附着元素的特效能否触发
    if stimuli == 2 or stimuli == 3 then
    --冰.水元素特效，能熄灭火焰
        if self.inst.components.burnable and (self.inst.components.burnable:IsBurning() or self.inst.components.burnable:IsSmoldering()) then
            self.inst.components.burnable:Extinguish()
        end
    end

    self.element_stack[stimuli].value = self.element_stack[stimuli].value + value
    self.element_stack[stimuli].attacker = attacker
    self.element_stack[stimuli].priority = 0
    for i = 1, 7 do
        if i ~= stimuli and self.element_stack[i].value > 0 then
            self.element_stack[i].priority = self.element_stack[i].priority + 1
        end
    end
    self:UpdateReaction()
end

function ElementReactor:ConsumeElement(ele_x, ele_y)    
    local rate = {
    --    火          冰          水          雷          风          岩          草
        {{nil, nil}, {1  , 2  }, {2  , 1  }, {1  , 1  }, {1  , 1  }, {1  , 1  }, {1  , 1  }},  --火
        {{2  , 1  }, {nil, nil}, {1  , 1  }, {1  , 1  }, {1  , 1  }, {1  , 1  }, {nil, nil}},  --冰
        {{1  , 2  }, {1  , 1  }, {nil, nil}, {nil, nil}, {1  , 1  }, {1  , 1  }, {2  , 1  }},  --水
        {{1  , 1  }, {1  , 1  }, {nil, nil}, {nil, nil}, {1  , 1  }, {1  , 1  }, {1  , 1  }},  --雷
        {{1  , 1  }, {1  , 1  }, {1  , 1  }, {1  , 1  }, {nil, nil}, {nil, nil}, {nil, nil}},  --风
        {{1  , 1  }, {1  , 1  }, {1  , 1  }, {1  , 1  }, {nil, nil}, {nil, nil}, {nil, nil}},  --岩
        {{1  , 1  }, {nil, nil}, {1  , 2  }, {1  , 1  }, {nil, nil}, {nil, nil}, {nil, nil}},  --草 
    }
    if rate[ele_x][ele_y][1] == nil or rate[ele_x][ele_y][2] == nil then
        return
    end
    local value = math.min(self.element_stack[ele_x].value / rate[ele_x][ele_y][1], self.element_stack[ele_y].value / rate[ele_x][ele_y][2])
    self.element_stack[ele_x].value = self.element_stack[ele_x].value - rate[ele_x][ele_y][1] * value 
    self.element_stack[ele_y].value = self.element_stack[ele_y].value - rate[ele_x][ele_y][2] * value 
end

function ElementReactor:CutOffElement(first)
    self.element_stack[5].value = 0
    self.element_stack[6].value = 0
    if first then
        return 
    end

    local remained = {}
    local index = 0
    for i = 1, 7 do
        if self.element_stack[i].value > 0 then
            index = index + 1
            remained[index] = i
        end
    end
    -- for i = 1, index do
    --     for j = i + 1, index do
    --         if j <= index then
    --             if self.element_stack[remained[i]].priority > self.element_stack[remained[j]].priority then
    --                 local temp = remained[i]
    --                 remained[i] = remained[j]
    --                 remained[j] = temp
    --             end
    --         end
    --     end
    -- end

    if index == 1 then
        local ele = remained[1]
        if self.element_stack[ele].priority == 0 then
            self.element_stack[ele].value = 0
        end
    end

    for i = 1, 7 do
        self.element_stack[i].value = math.min(2.5, self.element_stack[i].value)
    end
end

function ElementReactor:NewElementFromPersist()
    --但是我还是感觉一直把ignorecd设为true服务器会有很大压力，1.5秒内直接给满配合元素保持机制基本可以一样的效果
    if self.persist_element ~= 0 then
        self:NewElement(self.persist_element, 2.5, nil, false)  --加满
        return
    elseif self.half_persist_element ~= 0 then
        self:NewElement(self.half_persist_element, 2.5, nil, false)  --加满
        return
    end
    --只能同时有一种元素保持生效（否则会自动触发反应吧）（下雨天冰史莱姆也不会因为潮湿一直挂水冻结？）
    --元素全保持优先级高于元素半保持，如果有元素全保持，则元素半保持失效
end

function ElementReactor:UpdateReaction()
    --我们先排除基类元素为0的情况，此时直接将水火冰雷草攻击元素附着，而风岩没有附着效果
    if not self:HasElement() or self:NumberofElement() == 1 then
        self:CutOffElement(true)
        --绘画元素附着图标
        self:Push()
        return
    end

    --绘画元素附着图标
    self:Push()

    --水冰 > 水草 > 水雷 > 雷草
    local i_order = {3, 4, 7, 1, 2, 5, 6}
    local j_order = {
        { 2 },  --火
        {  },   --冰
        { 2, 7, 4, 1 },  --水
        { 7, 1, 2 },     --雷
        { 1, 4, 3, 2 },  --风
        { 1, 4, 3, 2 },  --岩
        { 1 }   --草
    }

    local elefns = {
        {nil, self.Melt, self.Vaporize, self.Overloaded, self.Swirl, self.Crystallize, self.Burn},
        {self.Melt, nil, self.Frozen, self.Superconduct, self.Swirl, self.Crystallize, nil},
        {self.Vaporize, self.Frozen, nil, self.ElectroCharged, self.Swirl, self.Crystallize, self.Bloom},
        {self.Overloaded, self.Superconduct, self.ElectroCharged, nil, self.Swirl, self.Crystallize, self.Quicken},
        {self.Swirl, self.Swirl, self.Swirl, self.Swirl, nil, nil, nil},
        {self.Crystallize, self.Crystallize, self.Crystallize, self.Crystallize, nil, nil, nil},
        {self.Burn, nil, self.Bloom, self.Quicken, nil, nil, nil}
    }

    local canreact = true
    while canreact do
        canreact = false
        for i = 1, 7 do
            local ele_x = i_order[i]
            if self.element_stack[ele_x].value > 0 and #(j_order[ele_x]) > 0 then
                for j = 1, #(j_order[ele_x]) do
                    local ele_y = j_order[ele_x][j]
                    if self.element_stack[ele_y].value > 0 then

                        if ele_x == 3 and ele_y == 4 and self.electrodamage_task ~= nil then
                            canreact = false
                        elseif ele_x == 4 and ele_y == 7 and self.inst:HasTag("Quciken") then
                            canreact = false
                            local new_element = ele_x
                            local attached_element = ele_y
                            local new_attacker = self.element_stack[ele_x].attacker
                            if self.element_stack[ele_x].priority > self.element_stack[ele_y].priority then
                                new_element = ele_y
                                attached_element = ele_x
                                new_attacker = self.element_stack[ele_y].attacker
                            end
                            if self.element_stack[new_element].priority == 0 then
                                self:QuickenRelatedReaction(new_element, new_attacker)
                            end
                        else
                            canreact = true
                            
                            local new_element = ele_x
                            local attached_element = ele_y
                            local new_attacker = self.element_stack[ele_x].attacker
                            if self.element_stack[ele_x].priority > self.element_stack[ele_y].priority then
                                new_element = ele_y
                                attached_element = ele_x
                                new_attacker = self.element_stack[ele_y].attacker
                            end

                            --触发反应
                            if elefns[ele_x][ele_y] ~= nil then
                                elefns[ele_x][ele_y](self, new_element, new_attacker, attached_element)
                            end
                            --消耗元素量
                            self:ConsumeElement(ele_x, ele_y)
                        end
                        
                    end
                end
            end
        end
    end

    self:CutOffElement()

    self.inst:AddTag("noupdateanim")
    self.inst:DoTaskInTime(0.25, function(inst)  
        self:Push()
        inst:RemoveTag("noupdateanim") 
    end)
end

--以下是增幅反应函数

function ElementReactor:Melt(new_element, new_attacker, attached_element)
    local mastery_rate = 0
    if new_attacker ~= nil and new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(1)
    end
    local basescale = new_element == 1 and 2 or 1.5
    self.reaction_scale = (basescale + (new_attacker and new_attacker.components.elementreactor and new_attacker.components.elementreactor.attack_melt_bonus_modifier:Get() or 0)) * (1 + mastery_rate)
    self.inst:PushEvent("elementreaction", {reaction = 5})
    if new_attacker ~= nil then
        new_attacker:PushEvent("melttarget", {target = self.inst})
    end
end

function ElementReactor:Vaporize(new_element, new_attacker, attached_element)
    local mastery_rate = 0
    if new_attacker ~= nil and new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(1)
    end
    local basescale = new_element == 1 and 1.5 or 2
    self.reaction_scale = (basescale + (new_attacker and new_attacker.components.elementreactor and new_attacker.components.elementreactor.attack_vaporize_bonus_modifier:Get() or 0)) * (1 + mastery_rate)
    self.inst:PushEvent("elementreaction", {reaction = 4})
    if new_attacker ~= nil then
        new_attacker:PushEvent("vaporizetarget", {target = self.inst})
    end
end

--冻结燃烧反应

function ElementReactor:Burn(new_element, new_attacker, attached_element)
    if self.inst.components.burnable and not self.inst.components.burnable:IsBurning() and new_attacker ~= nil then --着火给的火元素不能继续让它着火
        if self.inst.components.burnable.canlight or self.inst.components.combat ~= nil then
            self.inst.components.burnable:Ignite(true)
            self.inst:PushEvent("elementreaction", {reaction = 9})
            if new_attacker ~= nil then
                new_attacker:PushEvent("burntarget", {target = self.inst})
            end
        end
    end
end

function ElementReactor:Frozen(new_element, new_attacker, attached_element)
    if self.inst.components.freezable then
    --延迟触发，不然直接被打碎了
        self.inst:DoTaskInTime(FRAMES, function(inst)
            inst.components.freezable:AddColdness(8, 1)
        end)
    end
    self.inst:PushEvent("elementreaction", {reaction = 6})
    if new_attacker ~= nil then
        new_attacker:PushEvent("frozentarget", {target = self.inst})
    end
end

--以下是激化相关函数

function ElementReactor:Quicken(new_element, new_attacker, attached_element)
    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发激化反应
    end
    self.inst:AddTag("Quciken")
    self.inst:DoTaskInTime(7, function(inst)
        self.inst:RemoveTag("Quciken")
    end)
    self.inst:PushEvent("elementreaction", {reaction = 11})
    if new_attacker ~= nil then
        new_attacker:PushEvent("quickentarget", {target = self.inst})
    end
end

function ElementReactor:QuickenRelatedReaction(new_element, new_attacker)
    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发激化反应
    end

    local mastery_rate = 0
    if new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(3)
    end
    local base_addnumber = 28.93
    local bonus = 1
    if new_element == 4 then  --超激化
        bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_aggravate_bonus_modifier:Get()) or 1
        self.inst:PushEvent("elementreaction", {reaction = 12})
        if new_attacker ~= nil then
            new_attacker:PushEvent("aggravatetarget", {target = self.inst})
        end
    else                           --蔓激化
        bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_spread_bonus_modifier:Get()) or 1
        self.inst:PushEvent("elementreaction", {reaction = 13})
        if new_attacker ~= nil then
            new_attacker:PushEvent("spreadtarget", {target = self.inst})
        end
    end

    self.reaction_add = base_addnumber * (1 + mastery_rate) * bonus
end

--以下是剧变反应函数

function ElementReactor:Swirl(new_element, new_attacker, attached_element)
    --扩散，范围伤害
    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end
    local EXCLUDE_TAGS = default_exclude_tags
    if new_attacker:HasTag("player") then
        EXCLUDE_TAGS = player_attacker_exclude_tags
    elseif new_attacker:HasTag("genshin_monster") then
        EXCLUDE_TAGS = genshin_monster_attacker_exclude_tags
    end

    local mastery_rate = 0
    if new_attacker ~= nil and new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(4)
    end
    local base_damage = 8.68
    local bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_swirl_bonus * new_attacker.components.elementreactor.attack_swirl_bonus_modifier:Get()) or 1

    local element_swirled = attached_element
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 4, {"_combat"}, EXCLUDE_TAGS)
    self.inst.components.combat:GetAttacked(new_attacker, base_damage * (1 + mastery_rate) * bonus, nil, element_swirled, 0, "elementreaction")   --自身受到无元素量的伤害
    for k, v in pairs (ents) do
        if v ~= self.inst and v ~= new_attacker then --不攻击自己
            v.components.combat:GetAttacked(new_attacker, base_damage * (1 + mastery_rate) * bonus, nil, element_swirled, 2.2, "elementreaction")  --其他单位受到有元素量的伤害
        end
    end

    local fx = SpawnPrefab("swirl_fx")
    fx.Transform:SetPosition(x,y,z)
    fx.element_swirled = element_swirled

    self.inst:PushEvent("elementreaction", {reaction = 7})
    if new_attacker ~= nil then  --这个是给风套提供的接口
        new_attacker:PushEvent("swirltarget", {element_swirled = element_swirled, target = self.inst})
    end
end

function ElementReactor:Crystallize(new_element, new_attacker, attached_element)
    --结晶，无伤害
    if new_attacker == nil or not new_attacker:HasTag("player") then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end

    local mastery_rate = 0
    if new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(2)
    end
    local base_absorption = 18.51
    
    --检查一下近距离有几个没捡起来的护盾，如果有三个及以上就删除剩余时间最短的
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, {"crystal_shield"}, {"noauradamage"})
    local number = #(ents)
    while number >= 3 do
        local minshield = MinShield(ents)
        minshield:Remove()
        number = number - 1
    end

    local element_crystallized = attached_element
    local shield = SpawnPrefab("crystal_shield")
    shield.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    shield.components.health:SetMaxHealth(base_absorption * (1 + mastery_rate))
    shield:SetElement(element_crystallized)

    local fx = SpawnPrefab("crystallize_fx")
    fx.Transform:SetPosition(x,y,z)
    fx.element_crystallized = element_crystallized

    self.inst:PushEvent("elementreaction", {reaction = 8})
    if new_attacker ~= nil then
        new_attacker:PushEvent("crystallizetarget", {element_crystallized = element_crystallized, target = self.inst})
    end
end

function ElementReactor:Overloaded(new_element, new_attacker, attached_element)
    --超载，范围伤害
    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end
    local EXCLUDE_TAGS = default_exclude_tags
    if new_attacker:HasTag("player") then
        EXCLUDE_TAGS = player_attacker_exclude_tags
    elseif new_attacker:HasTag("genshin_monster") then
        EXCLUDE_TAGS = genshin_monster_attacker_exclude_tags
    end

    local mastery_rate = 0
    if new_attacker ~= nil and new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(4)
    end
    local base_damage = 28.93
    local bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_overload_bonus * new_attacker.components.elementreactor.attack_overload_bonus_modifier:Get()) or 1
    
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, {"_combat"}, EXCLUDE_TAGS)
    for k, v in pairs (ents) do
        if v ~= new_attacker then
            v.components.combat:GetAttacked(new_attacker, base_damage * (1 + mastery_rate) * bonus, nil, 1, 0, "elementreaction")  --超载是火伤
            --炸飞小体积单位
            --没做
        end
    end

    local fx = SpawnPrefab("overload_fx")
    fx.Transform:SetPosition(x,y,z)

    self.inst:PushEvent("elementreaction", {reaction = 2})
    if new_attacker ~= nil then
        new_attacker:PushEvent("overloadtarget", {target = self.inst})
    end
end

function ElementReactor:Superconduct(new_element, new_attacker, attached_element)
    --超导，范围伤害
    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end
    local EXCLUDE_TAGS = default_exclude_tags
    if new_attacker:HasTag("player") then
        EXCLUDE_TAGS = player_attacker_exclude_tags
    elseif new_attacker:HasTag("genshin_monster") then
        EXCLUDE_TAGS = genshin_monster_attacker_exclude_tags
    end

    local mastery_rate = 0
    if new_attacker ~= nil and new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(4)
    end
    local base_damage = 7.23
    local bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_superconduct_bonus * new_attacker.components.elementreactor.attack_superconduct_bonus_modifier:Get()) or 1

    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2, {"_combat"}, EXCLUDE_TAGS)
    for k, v in pairs (ents) do
        if v ~= new_attacker then
            v.components.combat:GetAttacked(new_attacker, base_damage * (1 + mastery_rate) * bonus, nil, 2, 0, "elementreaction")  --超导是冰伤
            --减物理抗性40%, 持续8秒
            v.components.combat.external_physical_res_multipliers:SetModifier("superconduction", -0.4)
            if not v:HasTag("superconduction") then
                v:AddTag("superconduction")
                v:DoTaskInTime(8, function(v)
                    v.components.combat.external_physical_res_multipliers:RemoveModifier("superconduction")
                    v:RemoveTag("superconduction")
                end)
            end
        end
    end

    local fx = SpawnPrefab("superconduct_fx")
    fx.Transform:SetPosition(x,y,z)

    self.inst:PushEvent("elementreaction", {reaction = 3})
    if new_attacker ~= nil then
        new_attacker:PushEvent("superconducttarget", {target = self.inst})
    end
end

function ElementReactor:ElectroChargedDamage()
    --先检查暂停标志
    while (self.inst:HasTag("electrocharged_wait")) do
        --print("electrification paused for the third element to react")
    end
    if not(self.element_stack[3].value > 0 and self.element_stack[4].value > 0) then
        --已经不是水雷的反应了？
        if self.electrodamage_task ~= nil then
            self.electrodamage_task:Cancel()
        end
        self.electrodamage_task = nil
        self:Push()
        return
    end
    
    local new_attacker = self.element_stack[3].attacker
    if self.element_stack[4].attacker ~= nil and self.element_stack[4].priority < self.element_stack[3].priority then
        new_attacker = self.element_stack[4].attacker
    end

    if new_attacker == nil then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end

    local EXCLUDE_TAGS = default_exclude_tags
    if new_attacker:HasTag("player") then
        EXCLUDE_TAGS = player_attacker_exclude_tags
    elseif new_attacker:HasTag("genshin_monster") then
        EXCLUDE_TAGS = genshin_monster_attacker_exclude_tags
    end

    self.element_stack[3].value = self.element_stack[3].value - 0.4
    self.element_stack[4].value = self.element_stack[4].value - 0.4
    --消耗先后手元素各0.4点元素值反应
    local mastery_rate = 0
    if new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(4)
    end
    local base_damage = 17.36
    local bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_electrocharged_bonus * new_attacker.components.elementreactor.attack_electrocharged_bonus_modifier:Get()) or 1

    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 2.5, {"_combat"}, EXCLUDE_TAGS)
    for k,v in pairs(ents) do
        if v ~= new_attacker and ((v.components.elementreactor and v.components.elementreactor.element_stack[3].value > 0) or v == self.inst) then
            v.components.combat:GetAttacked(new_attacker, base_damage * (1 + mastery_rate) * bonus, nil, 4, 0, "elementreaction")  --感电是雷伤
        end
    end

    local fx = SpawnPrefab("electrocharged_fx")
    self.inst:AddChild(fx)

    self.inst:PushEvent("elementreaction", {reaction = 1})
    if new_attacker ~= nil then
        new_attacker:PushEvent("electrochargedtarget", {target = self.inst})
    end
    self:Push()
end

function ElementReactor:ElectroCharged(new_element, new_attacker, attached_element)
    --感电，单体伤害
    if self.electrodamage_task ~= nil then
        self.electrodamage_task:Cancel()
    end
    self.electrodamage_task = self.inst:DoPeriodicTask(0.9, function() self:ElectroChargedDamage() end)
end

function ElementReactor:Bloom(new_element, new_attacker, attached_element)
    --绽放，生成蘑菇
    if new_attacker == nil or not new_attacker:HasTag("player") then
        return  --没有攻击者？那这个元素可能是环境给予的，不触发剧变反应
    end
    local EXCLUDE_TAGS = default_exclude_tags
    local ATTACKER_TAGS = {"_combat"}
    if new_attacker:HasTag("player") then
        EXCLUDE_TAGS = player_attacker_exclude_tags
        ATTACKER_TAGS = {"_combat", "player"}
    elseif new_attacker:HasTag("genshin_monster") then
        EXCLUDE_TAGS = genshin_monster_attacker_exclude_tags
        ATTACKER_TAGS = {"_combat", "genshin_monster"}
    end

    local mastery_rate = 0
    if new_attacker.components.combat then
        mastery_rate = new_attacker.components.combat:CalcMasteryAddition(4)
    end
    local base_dmg = 28.93 
    local bonus = new_attacker.components.elementreactor and (new_attacker.components.elementreactor.attack_bloom_bonus * new_attacker.components.elementreactor.attack_bloom_bonus_modifier:Get()) or 1
    
    --检查一下近距离有几个炸弹，如果有五个及以上就炸掉最早放出来的
    local x, y, z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, {"bloombomb"}, {"isexploding"})
    local number = #(ents)
    while number >= 5 do
        local oldestbomb = OldestBomb(ents)
        oldestbomb:Explode(false)
        number = number - 1
    end

    local projectile = SpawnPrefab("bloombomb_projectile")
    projectile.Transform:SetPosition(x, y, z)
    projectile:SetBaseDMG(base_dmg, mastery_rate, bonus)
    projectile:SetAttackMode(new_attacker, ATTACKER_TAGS, EXCLUDE_TAGS)
    local angle = math.random() * 360
    local range = math.random() * 0.8 + 1.5
    local targetpos = Vector3(x + math.cos(angle) * range, y, z + math.sin(angle) * range)
    local rangesq = range * range
    local maxrange = 15
    local bigNum = 15 -- 13 + (math.random()*4)
    local speed = easing.linear(rangesq, bigNum, 3, maxrange * maxrange)
    projectile.components.complexprojectile:SetHorizontalSpeed(speed)
    projectile.components.complexprojectile:Launch(targetpos, new_attacker, new_attacker)

    self.inst:PushEvent("elementreaction", {reaction = 10})
    if new_attacker ~= nil then
        new_attacker:PushEvent("bloomtarget", {target = self.inst})
    end
end

function ElementReactor:OnUpdate(dt)
    local updateanim = false
    --self.indicator:SetTrackingTarget(self.inst)

    --------------------------------------------------------------------
    --添加元素状态

    --下雨和水中附着水元素拥有半保持机制（仅低于元素怪的全保持优先度）
    if TUNING.ENABLE_ENVIRONMENT_ELEMENT then
        --
        local iswet = false
        if self.inst.components.moisture ~= nil then  --有潮湿度按照潮湿度，无潮湿度按照下雨/水中直接判断
            if self.inst.components.moisture:GetMoisturePercent() > 0 then 
                iswet = true
            end
        elseif TheWorld.state.israining or TheWorld.Map:IsVisualGroundAtPoint(self.inst:GetPosition():Get()) == false then
            iswet = true
        end
        if iswet then
            self.half_persist_element = 3 --水元素半保持
        else
            self.half_persist_element = 0 --取消水元素半保持
        end

        --被烧时的火元素就没有保持机制
        if self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
            self:NewElement(1, 1, nil, false)  --一直尝试添加火元素附着，每个1.5秒附着1点火元素
        end
    --
    end

    self:NewElementFromPersist() --从元素保持状态附加元素

    --------------------------------------------------------------------
    --检查当前元素状态并更新

    local previous_number = self:NumberofElement()
    for i = 1, 7 do
        if self.element_stack[i].value > 0 then
            self.element_stack[i].value = math.max(self.element_stack[i].value - 0.13 * dt, 0)
        end
    end
    if previous_number ~= self:NumberofElement() then
        updateanim = true
    end

    if self.inst.components.locomotor then
        if self.element_stack[2].value > 0 and self.element_stack[2].attacker ~= nil and self.element_stack[2].attacker ~= self.inst then
            self.inst.components.locomotor:SetExternalSpeedMultiplier(self.inst, "cryo_attached", 0.85)
        else
            self.inst.components.locomotor:RemoveExternalSpeedMultiplier(self.inst, "cryo_attached")
        end
    end

    --self.inst:PushEvent("element_updated")
    if updateanim and not self.inst:HasTag("noupdateanim") and self.indicator ~= nil then
        self:Push()
    end

    if not self.inst:HasTag("player") and TheWorld.Map:IsVisualGroundAtPoint(self.inst:GetPosition():Get()) and not self:HasElement() and self.persist_element == 0 and self.half_persist_element == 0 then
        self.inst:StopUpdatingComponent(self)
    end
end

--ElementReactor.LongUpdate = ElementReactor.OnUpdate

return ElementReactor