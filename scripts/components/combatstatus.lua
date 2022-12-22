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

local function oncrit_rate_dmg(self, crit_rate_dmg)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._crit_rate_dmg:set(crit_rate_dmg)
end

local function onrecharge(self, recharge)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._recharge:set(recharge)
end

---------------------------------------------------------

local function onpyro_pres(self, pyro_pres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._pyro_pres:set(pyro_pres)
end

local function oncryo_cres(self, cryo_cres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._cryo_cres:set(cryo_cres)
end

local function onhydro_hyres(self, hydro_hyres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._hydro_hyres:set(hydro_hyres)
end

local function onelectro_eres(self, electro_eres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._electro_eres:set(electro_eres)
end

local function onanemo_ares(self, anemo_ares)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._anemo_ares:set(anemo_ares)
end

local function ongeo_gres(self, geo_gres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._geo_gres:set(geo_gres)
end

local function ondendro_dres(self, dendro_dres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._dendro_dres:set(dendro_dres)
end

local function onphysical_phres(self, physical_phres)
    if not self.inst.replica.combatstatus then
        return
    end
    self.inst.replica.combatstatus._physical_phres:set(physical_phres)
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
--flt1和flt2是两个小浮点数，需要保留到小数点后三位，那么他们将会乘以1000后取整，然后两个数压缩称一个无符号整型
local function CompressSmallFloat(flt1, flt2)
    local uint16_1 = math.floor(flt1 * 1000)
    local uint16_2 = math.floor(flt2 * 1000)
    return uint16_1 * 65536 + uint16_2
end

local function ExtractSmallFloat(uint32)
    local uint16_1 = uint32 / 65536
    local uint16_2 = uint32 % 65536
    return { uint16_1 / 1000, uint16_2 / 1000 }
end

------------------------------------------------

local CombatStatus = Class(function(self, inst)
	self.inst = inst 

    self.weapon = nil
    self.weapondmg = nil

    self.base_hp = 100    --不过是
    self.hp = 100
	self.base_atk = 10
    self.atk = 10
    self.base_def = 500
    self.def = 500
    self.element_mastery = 0
    self.crit_rate_dmg = CompressSmallFloat(0.05, 0.50)
    self.recharge = 0000   --注意是*1000的值

    self.pyro_pres = CompressSmallFloat(0, 0)
    self.cryo_cres = CompressSmallFloat(0, 0)
    self.hydro_hyres = CompressSmallFloat(0, 0)
    self.electro_eres = CompressSmallFloat(0, 0)
    self.anemo_ares = CompressSmallFloat(0, 0)
    self.geo_gres = CompressSmallFloat(0, 0)
    self.dendro_dres = CompressSmallFloat(0, 0)
    self.physical_phres = CompressSmallFloat(0, 0)

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
    crit_rate_dmg = oncrit_rate_dmg,
    recharge = onrecharge,

    pyro_pres = onpyro_pres,
    cryo_cres = oncryo_cres,
    hydro_hyres = onhydro_hyres,
    electro_eres = onelectro_eres,
    anemo_ares = onanemo_ares,
    geo_gres = ongeo_gres,
    dendro_dres = ondendro_dres,
    physical_phres = onphysical_phres,

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
    self.crit_rate_dmg = CompressSmallFloat(crit_rate, crit_dmg)
    self.recharge = math.floor(recharge * 1000)

    self.pyro_pres = CompressSmallFloat(list[1], list_res[1])
    self.cryo_cres = CompressSmallFloat(list[2], list_res[2])
    self.hydro_hyres = CompressSmallFloat(list[3], list_res[3])
    self.electro_eres = CompressSmallFloat(list[4], list_res[4])
    self.anemo_ares = CompressSmallFloat(list[5], list_res[5])
    self.geo_gres = CompressSmallFloat(list[6], list_res[6])
    self.dendro_dres = CompressSmallFloat(list[7], list_res[7])
    self.physical_phres = CompressSmallFloat(list[8], list_res[8])

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
    return ExtractSmallFloat(self.crit_rate_dmg)[1]
end

function CombatStatus:GetCritDMG()
    return ExtractSmallFloat(self.crit_rate_dmg)[2]
end

function CombatStatus:GetRecharge()
    return self.recharge / 1000
end

-------------------------------------
function CombatStatus:GetPyroBonus()
    return ExtractSmallFloat(self.pyro_pres)[1]
end

function CombatStatus:GetCryoBonus()
    return ExtractSmallFloat(self.cryo_cres)[1]
end

function CombatStatus:GetHydroBonus()
    return ExtractSmallFloat(self.hydro_hyres)[1]
end

function CombatStatus:GetElectroBonus()
    return ExtractSmallFloat(self.electro_eres)[1]
end

function CombatStatus:GetAnemoBonus()
    return ExtractSmallFloat(self.anemo_ares)[1]
end

function CombatStatus:GetGeoBonus()
    return ExtractSmallFloat(self.geo_gres)[1]
end

function CombatStatus:GetDendroBonus()
    return ExtractSmallFloat(self.dendro_dres)[1]
end

function CombatStatus:GetPhysicalBonus()
    return ExtractSmallFloat(self.physical_phres)[1]
end
-------------------------------------
function CombatStatus:GetPyroResBonus()
    return ExtractSmallFloat(self.pyro_pres)[2]
end

function CombatStatus:GetCryoResBonus()
    return ExtractSmallFloat(self.cryo_cres)[2]
end

function CombatStatus:GetHydroResBonus()
    return ExtractSmallFloat(self.hydro_hyres)[2]
end

function CombatStatus:GetElectroResBonus()
    return ExtractSmallFloat(self.electro_eres)[2]
end

function CombatStatus:GetAnemoResBonus()
    return ExtractSmallFloat(self.anemo_ares)[2]
end

function CombatStatus:GetGeoResBonus()
    return ExtractSmallFloat(self.geo_gres)[2]
end

function CombatStatus:GetDendroResBonus()
    return ExtractSmallFloat(self.dendro_dres)[2]
end

function CombatStatus:GetPhysicalResBonus()
    return ExtractSmallFloat(self.physical_phres)[2]
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