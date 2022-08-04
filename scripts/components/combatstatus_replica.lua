local CombatStatus = Class(function(self, inst)
	self.inst = inst 

    self._weapon = net_entity(inst.GUID, "combatstatus._weapon", "combatstatusdirty")
    self._weapondmg = net_int(inst.GUID, "combatstatus._weapondmg", "combatstatusdirty")

    self._base_hp = net_int(inst.GUID, "combatstatus._base_hp", "combatstatusdirty")
	self._hp = net_int(inst.GUID, "combatstatus._hp", "combatstatusdirty")
	self._base_atk = net_int(inst.GUID, "combatstatus._base_atk", "combatstatusdirty")
	self._atk = net_int(inst.GUID, "combatstatus._atk", "combatstatusdirty")
	self._base_def = net_int(inst.GUID, "combatstatus._base_def", "combatstatusdirty")
	self._def = net_int(inst.GUID, "combatstatus._def", "combatstatusdirty")
	self._element_mastery = net_int(inst.GUID, "combatstatus._element_mastery", "combatstatusdirty")
	self._crit_rate = net_float(inst.GUID, "combatstatus._crit_rate", "combatstatusdirty")
	self._crit_dmg = net_float(inst.GUID, "combatstatus._crit_dmg", "combatstatusdirty")
    self._recharge = net_float(inst.GUID, "combatstatus._recharge", "combatstatusdirty")

	self._pyro_bonus = net_float(inst.GUID, "combatstatus._pyro_bonus", "combatstatusdirty")
    self._cryo_bonus = net_float(inst.GUID, "combatstatus._cryo_bonus", "combatstatusdirty")
    self._hydro_bonus = net_float(inst.GUID, "combatstatus._hydro_bonus", "combatstatusdirty")
    self._electro_bonus = net_float(inst.GUID, "combatstatus._electro_bonus", "combatstatusdirty")
    self._anemo_bonus = net_float(inst.GUID, "combatstatus._anemo_bonus", "combatstatusdirty")
    self._geo_bonus = net_float(inst.GUID, "combatstatus._geo_bonus", "combatstatusdirty")
    self._dendro_bonus = net_float(inst.GUID, "combatstatus._dendro_bonus", "combatstatusdirty")
    self._physical_bonus = net_float(inst.GUID, "combatstatus._physical_bonus", "combatstatusdirty")

    self._pyro_res_bonus = net_float(inst.GUID, "combatstatus._pyro_res_bonus", "combatstatusdirty")
    self._cryo_res_bonus = net_float(inst.GUID, "combatstatus._cryo_res_bonus", "combatstatusdirty")
    self._hydro_res_bonus = net_float(inst.GUID, "combatstatus._hydro_res_bonus", "combatstatusdirty")
    self._electro_res_bonus = net_float(inst.GUID, "combatstatus._electro_res_bonus", "combatstatusdirty")
    self._anemo_res_bonus = net_float(inst.GUID, "combatstatus._anemo_res_bonus", "combatstatusdirty")
    self._geo_res_bonus = net_float(inst.GUID, "combatstatus._geo_res_bonus", "combatstatusdirty")
    self._dendro_res_bonus = net_float(inst.GUID, "combatstatus._dendro_res_bonus", "combatstatusdirty")
    self._physical_res_bonus = net_float(inst.GUID, "combatstatus._physical_res_bonus", "combatstatusdirty")

    self._clothing_base = net_string(inst.GUID, "combatstatus._clothing_base", "combatstatusdirty")
    self._clothing_body = net_string(inst.GUID, "combatstatus._clothing_body", "combatstatusdirty")
    self._clothing_hand = net_string(inst.GUID, "combatstatus._clothing_hand", "combatstatusdirty")
    self._clothing_legs = net_string(inst.GUID, "combatstatus._clothing_legs", "combatstatusdirty")
    self._clothing_feet = net_string(inst.GUID, "combatstatus._clothing_feet", "combatstatusdirty")
end)

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
    return self._crit_rate:value()
end

function CombatStatus:GetCritDMG()
    return self._crit_dmg:value()
end

function CombatStatus:GetRecharge()
    return self._recharge:value()
end

-------------------------------------
function CombatStatus:GetPyroBonus()
    return self._pyro_bonus:value()
end

function CombatStatus:GetCryoBonus()
    return self._cryo_bonus:value()
end

function CombatStatus:GetHydroBonus()
    return self._hydro_bonus:value()
end

function CombatStatus:GetElectroBonus()
    return self._electro_bonus:value()
end

function CombatStatus:GetAnemoBonus()
    return self._anemo_bonus:value()
end

function CombatStatus:GetGeoBonus()
    return self._geo_bonus:value()
end

function CombatStatus:GetDendroBonus()
    return self._dendro_bonus:value()
end

function CombatStatus:GetPhysicalBonus()
    return self._physical_bonus:value()
end
-------------------------------------
function CombatStatus:GetPyroResBonus()
    return self._pyro_res_bonus:value()
end

function CombatStatus:GetCryoResBonus()
    return self._cryo_res_bonus:value()
end

function CombatStatus:GetHydroResBonus()
    return self._hydro_res_bonus:value()
end

function CombatStatus:GetElectroResBonus()
    return self._electro_res_bonus:value()
end

function CombatStatus:GetAnemoResBonus()
    return self._anemo_res_bonus:value()
end

function CombatStatus:GetGeoResBonus()
    return self._geo_res_bonus:value()
end

function CombatStatus:GetDendroResBonus()
    return self._dendro_res_bonus:value()
end

function CombatStatus:GetPhysicalResBonus()
    return self._physical_res_bonus:value()
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