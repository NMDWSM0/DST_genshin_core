local skills = 
{
    "elementalskill",
    "elementalburst",
}

local function onelementalskill(self, elementalskill)
    self.inst.replica.elementalcaster._elementalskill:set(elementalskill)
end

local function onelementalburst(self, elementalburst)
    self.inst.replica.elementalcaster._elementalburst:set(elementalburst)
end

local function onCDTime(self, CDTime)
    self.inst.replica.elementalcaster._CDTime:set(CDTime)
end

---------------------------------------------------------

local ElementalCaster = Class(function(self, inst)
	self.inst = inst 
	
    self.elementalskill = 0
	self.elementalburst = 0
	self.CDTime = GetTime()
    
    self.cd = {
        elementalskill = 10,
        elementalburst = 20,
    }

    self.energy = {
        elementalskill = 0,
        elementalburst = 60,
    }

    self.inst:StartUpdatingComponent(self)
end,
nil,
{
	elementalskill = onelementalskill,
    elementalburst = onelementalburst,
    CDTime = onCDTime,
})

function ElementalCaster:SetElementalSkill(cd)
    self.cd.elementalskill = cd
end

function ElementalCaster:SetElementalBurst(cd, energy)
    self.cd.elementalburst = cd
    self.energy.elementalburst = energy
end

function ElementalCaster:HasEnergy(val)
	if val == nil then
		return true
	end

    if self.inst.components.energyrecharge == nil or self.inst.components.energyrecharge:GetCurrent() < val then
	    return false
	end
	
	self.inst.components.energyrecharge:DoDelta(-val)
	return true
end

--是否已经完成冷却
function ElementalCaster:outofcooldown(skill)
    if self.inst.sg:HasStateTag("knockout") or self.inst.sg:HasStateTag("sleeping") or self.inst.sg.currentstate == "death" then
		return false
	end 
	
	if GetTime() - self[skill] < self.cd[skill] then
	    return false
	end
	
	if not self:HasEnergy(self.energy[skill]) then
	    return false
    end

	self[skill] = GetTime()
	return true
end

function ElementalCaster:LeftTimeDelta(skill, dt)
    self[skill] = self[skill] - dt
end

function ElementalCaster:OnUpdate(dt)  --卡到爆炸你知道吗
    if GetTime() - self.CDTime < TUNING.CDBADGE_REFRESH_TIME then
        return
    end
    if (GetTime() - self.elementalskill > self.cd.elementalskill + TUNING.CDBADGE_REFRESH_TIME) and (GetTime() - self.elementalburst > self.cd.elementalburst + TUNING.CDBADGE_REFRESH_TIME) then
        return
    end
    self.CDTime = GetTime()
end

function ElementalCaster:OnSave()
    local data = {}
    for k,v in pairs(skills) do
		data[v] = self.CDTime - self[v] 
	end
    return data
end

function ElementalCaster:OnLoad(data)
    self.CDTime = GetTime()
    if data ~= nil then
		for k,v in pairs(skills) do
			if data[v] ~= nil then
				self[v] = self.CDTime - data[v]
			end
		end
    else
        self.elementalskill = self.CDTime - self.cd.elementalskill
	    self.elementalburst = self.CDTime - self.cd.elementalburst
	end
end

return ElementalCaster