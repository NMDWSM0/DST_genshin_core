local Talents = Class(function(self, inst)
    self.inst = inst

    self._maxlevel = net_smallbyte(inst.GUID, "talents._maxlevel", "talentsmaxleveldirty")

    self._level_talent1 = net_smallbyte(inst.GUID, "talents._level_talent1", "talentsleveldirty")
    self._level_talent2 = net_smallbyte(inst.GUID, "talents._level_talent2", "talentsleveldirty")
    self._level_talent3 = net_smallbyte(inst.GUID, "talents._level_talent3", "talentsleveldirty")

    self._level_talent1_extension = net_tinybyte(inst.GUID, "talents._level_talent1_extension", "talentsleveldirty")
    self._level_talent2_extension = net_tinybyte(inst.GUID, "talents._level_talent2_extension", "talentsleveldirty")
    self._level_talent3_extension = net_tinybyte(inst.GUID, "talents._level_talent3_extension", "talentsleveldirty")
    
end)

function Talents:GetTalentLevel(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return 1
    end
    return self["_level_talent"..talent]:value() + self["_level_talent"..talent.."_extension"]:value()
end

function Talents:GetBaseTalentLevel(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return 1
    end
    return self["_level_talent"..talent]:value()
end

function Talents:CanUpgradeTalent(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return false
    end
    return self["_level_talent"..talent]:value() < self._maxlevel:value()
end

function Talents:IsWithExtension(talent)
    if talent == nil or type(talent) ~= "number" or talent < 1 or talent > 3 then
        return false
    end
    return self["_level_talent"..talent.."_extension"]:value() > 0
end

return Talents