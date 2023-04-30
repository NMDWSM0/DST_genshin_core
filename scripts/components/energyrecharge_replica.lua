local EnergyRecharge = Class(function(self, inst)
	self.inst = inst 
	self._current = net_ushortint(inst.GUID, "energyrecharge._current", "currentenergydirty")  --byte即可，0-255够了，而且UI上只显整数
    self._max = net_ushortint(inst.GUID, "energyrecharge._max", "maxenergydirty")
end)

function EnergyRecharge:SetMax(max)
	self._max:set(max)
end

function EnergyRecharge:SetCurrent(current)
	if current > self._max:value() then
	    self._current:set(self._max:value())
	elseif current < 0 then
	    self._current:set(0) 
	else
	    self._current:set(current) 
	end
end

function EnergyRecharge:SetPercent(percent)
    self:SetCurrent(percent * self._max:value())
end

function EnergyRecharge:GetMax()
	return self._max:value()
end 

function EnergyRecharge:GetCurrent()
	return self._current:value()
end

function EnergyRecharge:GetPercent()
	return self:GetMax() ~= 0 and self:GetCurrent()/self:GetMax() or 0
end

return EnergyRecharge