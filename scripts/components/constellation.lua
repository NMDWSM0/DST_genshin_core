local function onlevel(self, level)
    self.inst.replica.constellation._level:set(level)
end

local Constellation = Class(function(self, inst)
    self.inst = inst

    self.level = 0

    self.lvfunc = {}
    
    self.inst:ListenForEvent("ms_playerreroll", function() 
        self:ReturnIngridents()
    end)
end,
nil,
{
    level = onlevel,
})

function Constellation:SetLevelFunc(level, func)
    if level >= 1 and level <= 6 then
        self.lvfunc[level] = func
        if self.level >= level then
            self.lvfunc[level](self.inst)
        end
    end
end

function Constellation:Unlock(level)
    if level ~= self.level + 1 then
        return
    end
    self.level = level
    if self.lvfunc[level] ~= nil then
        self.lvfunc[level](self.inst)
    end
    self.inst:PushEvent("constellationleveldirty")
end

function Constellation:CanUnlockLevel(level)
    return level == self.level + 1
end

function Constellation:GetActivatedLevel()
    return self.level
end

function Constellation:OnSave()
    local data = {}
    data.level = self.level
    return data
end

function Constellation:OnLoad(data)
    if data ~= nil then
		self.level = data.level
	end
    for i = 1, self.level do
        if self.lvfunc[i] ~= nil then
            self.lvfunc[i](self.inst)
        end
    end
    self.inst:PushEvent("constellationleveldirty")
end

function Constellation:ReturnIngridents()
    local inst = self.inst
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst.constellation_starname == nil then
        return
    end
	
    if self.level > 0 then
        for i = 1, self.level do
            local star = SpawnPrefab(inst.constellation_starname)
            if star ~= nil then
                if star.Physics ~= nil then
                    local speed = 2 + math.random()
                    local angle = math.random() * 2 * PI
                    star.Physics:Teleport(x, y + 1, z)
                    star.Physics:SetVel(speed * math.cos(angle), speed * 3, speed * math.sin(angle))
                else
                    star.Transform:SetPosition(x, y, z)
                end
            end
        end
    end
end

return Constellation