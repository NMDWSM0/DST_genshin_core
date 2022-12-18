local function onweapon(self, weapon)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._weapon:set(weapon ~= nil and weapon or self.inst)
end

local function onweapondmg(self, weapondmg)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._weapondmg:set(weapondmg ~= nil and weapondmg or 0)
end

--------------------------------------------------------

local function onbase_hp(self, base_hp)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._base_hp:set(base_hp)
end

local function onhp(self, hp)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._hp:set(hp)
end

local function onbase_atk(self, base_atk)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._base_atk:set(base_atk)
end

local function onatk(self, atk)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._atk:set(atk)
end

local function onbase_def(self, base_def)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._base_def:set(base_def)
end

local function ondef(self, def)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._def:set(def)
end

local function onelement_mastery(self, element_mastery)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._element_mastery:set(element_mastery)
end

local function oncrit_rate(self, crit_rate)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._crit_rate:set(crit_rate)
end

local function oncrit_dmg(self, crit_dmg)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._crit_dmg:set(crit_dmg)
end

local function onrecharge(self, recharge)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._recharge:set(recharge)
end

---------------------------------------------------------

local function onpyro_bonus(self, pyro_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._pyro_bonus:set(pyro_bonus)
end

local function oncryo_bonus(self, cryo_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._cryo_bonus:set(cryo_bonus)
end

local function onhydro_bonus(self, hydro_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._hydro_bonus:set(hydro_bonus)
end

local function onelectro_bonus(self, electro_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._electro_bonus:set(electro_bonus)
end

local function onanemo_bonus(self, anemo_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._anemo_bonus:set(anemo_bonus)
end

local function ongeo_bonus(self, geo_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._geo_bonus:set(geo_bonus)
end

local function ondendro_bonus(self, dendro_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._dendro_bonus:set(dendro_bonus)
end

local function onphysical_bonus(self, physical_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._physical_bonus:set(physical_bonus)
end

---------------------------------------------------------

local function onpyro_res_bonus(self, pyro_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._pyro_res_bonus:set(pyro_res_bonus)
end

local function oncryo_res_bonus(self, cryo_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._cryo_res_bonus:set(cryo_res_bonus)
end

local function onhydro_res_bonus(self, hydro_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._hydro_res_bonus:set(hydro_res_bonus)
end

local function onelectro_res_bonus(self, electro_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._electro_res_bonus:set(electro_res_bonus)
end

local function onanemo_res_bonus(self, anemo_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._anemo_res_bonus:set(anemo_res_bonus)
end

local function ongeo_res_bonus(self, geo_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._geo_res_bonus:set(geo_res_bonus)
end

local function ondendro_res_bonus(self, dendro_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._dendro_res_bonus:set(dendro_res_bonus)
end

local function onphysical_res_bonus(self, physical_res_bonus)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._physical_res_bonus:set(physical_res_bonus)
end

---------------------------------------------------------

local function onclothing_base(self, clothing_base)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._clothing_base:set(clothing_base or "")
end

local function onclothing_body(self, clothing_body)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._clothing_body:set(clothing_body or "")
end

local function onclothing_hand(self, clothing_hand)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._clothing_hand:set(clothing_hand or "")
end

local function onclothing_legs(self, clothing_legs)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._clothing_legs:set(clothing_legs or "")
end

local function onclothing_feet(self, clothing_feet)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._clothing_feet:set(clothing_feet or "")
end

---------------------------------------------------------

local CombatStatus = Class(function(self, inst)
	self.inst = inst 

    self.weapon = nil
    self.weapondmg = nil

    self.base_hp = 100
    self.hp = 100
	self.base_atk = 10
    self.atk = 10
    self.base_def = 500
    self.def = 500
    self.element_mastery = 0
    self.crit_rate = 0.05
    self.crit_dmg = 0.50
    self.recharge = 0
	
    self.pyro_bonus = 0
    self.cryo_bonus = 0
    self.hydro_bonus = 0
    self.electro_bonus = 0
    self.anemo_bonus = 0
    self.geo_bonus = 0
    self.dendro_bonus = 0
    self.physical_bonus = 0

    self.pyro_res_bonus = 0
    self.cryo_res_bonus = 0
    self.hydro_res_bonus = 0
    self.electro_res_bonus = 0
    self.anemo_res_bonus = 0
    self.geo_res_bonus = 0
    self.dendro_res_bonus = 0
    self.physical_res_bonus = 0

    self.clothing_base = ""
    self.clothing_body = ""
    self.clothing_hand = ""
    self.clothing_legs = ""
    self.clothing_feet = ""
end,
nil,
{
    weapon = onweapon,
    weapondmg = onweapondmg,

    base_hp = onbase_hp,
    hp = onhp,
	base_atk = onbase_atk,
    atk = onatk,
    base_def = onbase_def,
    def = ondef,
    element_mastery = onelement_mastery,
    crit_rate = oncrit_rate,
    crit_dmg = oncrit_dmg,
    recharge = onrecharge,
	
    pyro_bonus = onpyro_bonus,
    cryo_bonus = oncryo_bonus,
    hydro_bonus = onhydro_bonus,
    electro_bonus = onelectro_bonus,
    anemo_bonus = onanemo_bonus,
    geo_bonus = ongeo_bonus,
    dendro_bonus = ondendro_bonus,
    physical_bonus = onphysical_bonus,

    pyro_res_bonus = onpyro_res_bonus,
    cryo_res_bonus = oncryo_res_bonus,
    hydro_res_bonus = onhydro_res_bonus,
    electro_res_bonus = onelectro_res_bonus,
    anemo_res_bonus = onanemo_res_bonus,
    geo_res_bonus = ongeo_res_bonus,
    dendro_res_bonus = ondendro_res_bonus,
    physical_res_bonus = onphysical_res_bonus,

    clothing_base = onclothing_base,
    clothing_body = onclothing_body,
    clothing_hand = onclothing_hand,
    clothing_legs = onclothing_legs,
    clothing_feet = onclothing_feet,
})

---------------------------------------------------------

function CombatStatus:Set(weapon, weapondmg, base_hp, hp, base_atk, atk, base_def, def, element_mastery, crit_rate, crit_dmg, recharge, list, list_res, clothing)
    self.weapon = weapon
    self.weapondmg = weapondmg

    self.base_hp = base_hp
    self.hp = hp
    self.base_atk = base_atk
    self.atk = atk
    self.base_def = base_def
    self.def = def
    self.element_mastery = element_mastery
    self.crit_rate = crit_rate
    self.crit_dmg = crit_dmg
    self.recharge = recharge
	
    self.pyro_bonus = list[1]
    self.cryo_bonus = list[2]
    self.hydro_bonus = list[3]
    self.electro_bonus = list[4]
    self.anemo_bonus = list[5]
    self.geo_bonus = list[6]
    self.dendro_bonus = list[7]
    self.physical_bonus = list[8]

    self.pyro_res_bonus = list_res[1]
    self.cryo_res_bonus = list_res[2]
    self.hydro_res_bonus = list_res[3]
    self.electro_res_bonus = list_res[4]
    self.anemo_res_bonus = list_res[5]
    self.geo_res_bonus = list_res[6]
    self.dendro_res_bonus = list_res[7]
    self.physical_res_bonus = list_res[8]

    self.clothing_base = clothing.base
    self.clothing_hand = clothing.hand
    self.clothing_body = clothing.body
    self.clothing_legs = clothing.legs
    self.clothing_feet = clothing.feet
end

function CombatStatus:GetWeapon()
    return self.weapon ~= nil and self.weapon or self.inst
end

function CombatStatus:GetWeaponDmg()
    return self.weapondmg
end

function CombatStatus:GetBaseHp()
    return self.base_hp
end

function CombatStatus:GetHp()
    return self.hp
end

function CombatStatus:GetBaseAtk()
    return self.base_atk
end

function CombatStatus:GetAtk()
    return self.atk
end

function CombatStatus:GetBaseDef()
    return self.base_def
end

function CombatStatus:GetDef()
    return self.def
end

function CombatStatus:GetElementMastery()
    return self.element_mastery
end

function CombatStatus:GetCritRate()
    return self.crit_rate
end

function CombatStatus:GetCritDMG()
    return self.crit_dmg
end

function CombatStatus:GetRecharge()
    return self.recharge
end

-------------------------------------
function CombatStatus:GetPyroBonus()
    return self.pyro_bonus
end

function CombatStatus:GetCryoBonus()
    return self.cryo_bonus
end

function CombatStatus:GetHydroBonus()
    return self.hydro_bonus
end

function CombatStatus:GetElectroBonus()
    return self.electro_bonus
end

function CombatStatus:GetAnemoBonus()
    return self.anemo_bonus
end

function CombatStatus:GetGeoBonus()
    return self.geo_bonus
end

function CombatStatus:GetDendroBonus()
    return self.dendro_bonus
end

function CombatStatus:GetPhysicalBonus()
    return self.physical_bonus
end
-------------------------------------
function CombatStatus:GetPyroResBonus()
    return self.pyro_res_bonus
end

function CombatStatus:GetCryoResBonus()
    return self.cryo_res_bonus
end

function CombatStatus:GetHydroResBonus()
    return self.hydro_res_bonus
end

function CombatStatus:GetElectroResBonus()
    return self.electro_res_bonus
end

function CombatStatus:GetAnemoResBonus()
    return self.anemo_res_bonus
end

function CombatStatus:GetGeoResBonus()
    return self.geo_res_bonus
end

function CombatStatus:GetDendroResBonus()
    return self.dendro_res_bonus
end

function CombatStatus:GetPhysicalResBonus()
    return self.physical_res_bonus
end
-------------------------------------
function CombatStatus:GetClothing()
    local clothing = {
        base = self.clothing_base,
        body = self.clothing_body,
        hand = self.clothing_hand,
        legs = self.clothing_legs,
        feet = self.clothing_feet,
    }
    return clothing
end

return CombatStatus