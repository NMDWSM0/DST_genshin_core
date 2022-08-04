local Constellation = Class(function(self, inst)
    self.inst = inst

    self._level = net_tinybyte(inst.GUID, "constellation._level", "constellationleveldirty")
    
end)

function Constellation:CanUnlockLevel(level)
    return level == self._level:value() + 1
end

function Constellation:GetActivatedLevel()
    return self._level:value()
end

return Constellation