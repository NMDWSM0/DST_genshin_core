local CombatStatus = Class(function(self, inst)
	self.inst = inst 

    self._weapon = net_entity(inst.GUID, "combatstatus._weapon", "combatstatusdirty")
    self._weapondmg = net_ushortint(inst.GUID, "combatstatus._weapondmg", "combatstatusdirty")

    self._base_hp = net_ushortint(inst.GUID, "combatstatus._base_hp", "combatstatusdirty")
	self._hp = net_ushortint(inst.GUID, "combatstatus._hp", "combatstatusdirty")
	self._base_atk = net_ushortint(inst.GUID, "combatstatus._base_atk", "combatstatusdirty")
	self._atk = net_ushortint(inst.GUID, "combatstatus._atk", "combatstatusdirty")
	self._base_def = net_ushortint(inst.GUID, "combatstatus._base_def", "combatstatusdirty")
	self._def = net_ushortint(inst.GUID, "combatstatus._def", "combatstatusdirty")
	self._element_mastery = net_ushortint(inst.GUID, "combatstatus._element_mastery", "combatstatusdirty")
	self._crit_rate_dmg = net_uint(inst.GUID, "combatstatus._crit_rate_dmg", "combatstatusdirty")
    self._recharge = net_ushortint(inst.GUID, "combatstatus._recharge", "combatstatusdirty")

	self._pyro_pres = net_uint(inst.GUID, "combatstatus._pyro_pres", "combatstatusdirty")
    self._cryo_cres = net_uint(inst.GUID, "combatstatus._cryo_cres", "combatstatusdirty")
    self._hydro_hyres = net_uint(inst.GUID, "combatstatus._hydro_hyres", "combatstatusdirty")
    self._electro_eres = net_uint(inst.GUID, "combatstatus._electro_eres", "combatstatusdirty")
    self._anemo_ares = net_uint(inst.GUID, "combatstatus._anemo_ares", "combatstatusdirty")
    self._geo_gres = net_uint(inst.GUID, "combatstatus._geo_gres", "combatstatusdirty")
    self._dendro_dres = net_uint(inst.GUID, "combatstatus._dendro_dres", "combatstatusdirty")
    self._physical_phres = net_uint(inst.GUID, "combatstatus._physical_phres", "combatstatusdirty")

    self._clothing_base = net_string(inst.GUID, "combatstatus._clothing_base", "combatstatusdirty")
    self._clothing_body = net_string(inst.GUID, "combatstatus._clothing_body", "combatstatusdirty")
    self._clothing_hand = net_string(inst.GUID, "combatstatus._clothing_hand", "combatstatusdirty")
    self._clothing_legs = net_string(inst.GUID, "combatstatus._clothing_legs", "combatstatusdirty")
    self._clothing_feet = net_string(inst.GUID, "combatstatus._clothing_feet", "combatstatusdirty")
end)

local function ExtractSmallFloat(uint32)
    local uint16_1 = uint32 / 65536 - 32768
    local uint16_2 = uint32 % 65536 - 32768
    return { uint16_1 / 1000, uint16_2 / 1000 }
end

function CombatStatus:GetWeapon()
    return self._weapon:value()
end

function CombatStatus:GetWeaponDmg()
    return self._weapondmg:value()
end

function CombatStatus:GetBaseHp()
    return self._base_hp:value()
end

function CombatStatus:GetHp()
    return self._hp:value()
end

function CombatStatus:GetBaseAtk()
    return self._base_atk:value()
end

function CombatStatus:GetAtk()
    return self._atk:value()
end

function CombatStatus:GetBaseDef()
    return self._base_def:value()
end

function CombatStatus:GetDef()
    return self._def:value()
end

function CombatStatus:GetElementMastery()
    return self._element_mastery:value()
end

function CombatStatus:GetCritRate()
    return ExtractSmallFloat(self._crit_rate_dmg:value())[1]
end

function CombatStatus:GetCritDMG()
    return ExtractSmallFloat(self._crit_rate_dmg:value())[2]
end

function CombatStatus:GetRecharge()
    return self._recharge:value() / 1000
end

-------------------------------------
function CombatStatus:GetPyroBonus()
    return ExtractSmallFloat(self._pyro_pres:value())[1]
end

function CombatStatus:GetCryoBonus()
    return ExtractSmallFloat(self._cryo_cres:value())[1]
end

function CombatStatus:GetHydroBonus()
    return ExtractSmallFloat(self._hydro_hyres:value())[1]
end

function CombatStatus:GetElectroBonus()
    return ExtractSmallFloat(self._electro_eres:value())[1]
end

function CombatStatus:GetAnemoBonus()
    return ExtractSmallFloat(self._anemo_ares:value())[1]
end

function CombatStatus:GetGeoBonus()
    return ExtractSmallFloat(self._geo_gres:value())[1]
end

function CombatStatus:GetDendroBonus()
    return ExtractSmallFloat(self._dendro_dres:value())[1]
end

function CombatStatus:GetPhysicalBonus()
    return ExtractSmallFloat(self._physical_phres:value())[1]
end
-------------------------------------
function CombatStatus:GetPyroResBonus()
    return ExtractSmallFloat(self._pyro_pres:value())[2]
end

function CombatStatus:GetCryoResBonus()
    return ExtractSmallFloat(self._cryo_cres:value())[2]
end

function CombatStatus:GetHydroResBonus()
    return ExtractSmallFloat(self._hydro_hyres:value())[2]
end

function CombatStatus:GetElectroResBonus()
    return ExtractSmallFloat(self._electro_eres:value())[2]
end

function CombatStatus:GetAnemoResBonus()
    return ExtractSmallFloat(self._anemo_ares:value())[2]
end

function CombatStatus:GetGeoResBonus()
    return ExtractSmallFloat(self._geo_gres:value())[2]
end

function CombatStatus:GetDendroResBonus()
    return ExtractSmallFloat(self._dendro_dres:value())[2]
end

function CombatStatus:GetPhysicalResBonus()
    return ExtractSmallFloat(self._physical_phres:value())[2]
end
-------------------------------------
function CombatStatus:GetClothing()
    local clothing = {
        base = self._clothing_base:value(),
        body = self._clothing_body:value(),
        hand = self._clothing_hand:value(),
        legs = self._clothing_legs:value(),
        feet = self._clothing_feet:value(),
    }
    return clothing
end

return CombatStatus