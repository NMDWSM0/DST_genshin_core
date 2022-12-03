local ElementalCaster = Class(function(self, inst)
	self.inst = inst 

    self.elementalskill = 0
	self.elementalburst = 0
	self.CDTime = GetTime()

	self._elementalskill = net_float(inst.GUID, "elementalcaster._elementalskill", "skillcddirty")
    self._elementalburst = net_float(inst.GUID, "elementalcaster._elementalburst", "skillcddirty")
    self._CDTime = net_float(inst.GUID, "elementalcaster._CDTime", "skillcddirty")

    self.inst:ListenForEvent("skillcddirty", function() self:synchronize() end)
end)

function ElementalCaster:synchronize()
    self.elementalskill = self._elementalskill:value()
	self.elementalburst = self._elementalburst:value()
	self.CDTime = self._CDTime:value()
end

return ElementalCaster