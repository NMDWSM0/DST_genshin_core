local SourceModifierList = require("util/sourcemodifierlist")

local function onmax(self, max)
    self.inst.replica.energyrecharge:SetMax(max)
end

local function oncurrent(self, current)
    self.inst.replica.energyrecharge:SetCurrent(current)
end

local EnergyRecharge = Class(function(self, inst)
	self.inst = inst 
	self.max = 100
    self.current = 0

    --元素充能效率
    self.recharge = 1
	--不要直接调用！！！ 调用self:SetModifier(source, m, key) 和 self:RemoveModifier(source, key)
    --DO NOT call this directly!!! Use "self:SetModifier(source, m, key)" and "self:RemoveModifier(source, key)" instead
    self.external_recharge_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
end,
nil,
{
	max = onmax,
    current = oncurrent,
})

function EnergyRecharge:SetMax(max)
    self.max = max or 100
	self:DoDelta(0)
	self.inst:PushEvent("maxenergydirty")
end

function EnergyRecharge:SetCurrent(current)
    if current > self.max then
	    self.current = self.max
	elseif current < 0 then
	    self.current = 0 
	else
	    self.current = current
	end
	self.inst:PushEvent("currentenergydirty")
end

function EnergyRecharge:SetPercent(percent)
    self:SetCurrent(percent * self.max)
end

function EnergyRecharge:GetMax()
    return self.max
end

function EnergyRecharge:GetCurrent()
    return self.current
end

function EnergyRecharge:GetPercent()
    return self.max ~= 0 and self.current/self.max or 0
end

function EnergyRecharge:DoDelta(delta)
    self:SetCurrent(self.current + delta)
	self.inst:PushEvent("energy_delta", {current = self.current, delta = delta})
end

function EnergyRecharge:GainEnergy(value)
    local rate = self.recharge + self.external_recharge_multipliers:Get()
	self.inst:PushEvent("elemental_orbs_get", {value = value, recharge = rate})
	TheWorld:PushEvent("elemental_orbs_get", {value = value, recharge = rate})
	--print(self.recharge, self.external_recharge_multipliers:Get(), value, rate*value)
    self:DoDelta(rate * value)
end

function EnergyRecharge:SetModifier(source, m, key)
    self.external_recharge_multipliers:SetModifier(source, m, key)
	self.inst:PushEvent("energyrecharge_change")
end

function EnergyRecharge:RemoveModifier(source, key)
    self.external_recharge_multipliers:RemoveModifier(source, key)
	self.inst:PushEvent("energyrecharge_change")
end

function EnergyRecharge:SetBaseRecharge(value)
    self.recharge = value or 1
	self.inst:PushEvent("energyrecharge_change")
end

function EnergyRecharge:GetEnergyRecharge()
    return self.recharge + self.external_recharge_multipliers:Get()
end

function EnergyRecharge:OnSave()
	return {
		current = self.current,
		--max = self.max
	}
end

function EnergyRecharge:OnLoad(data)
	if data then
		self.current = data.current
		--self.max = data.max
	end
	self:DoDelta(0)
end

return EnergyRecharge