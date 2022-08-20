local containers = require "containers"

local assets =
{
    Asset("ANIM", "anim/spear.zip"),
    Asset("ANIM", "anim/swap_spear.zip"),
    Asset("ANIM", "anim/floating_items.zip"),

    Asset("IMAGE", "images/ui/element_spear_slot.tex"),
    Asset("ATLAS", "images/ui/element_spear_slot.xml"),
}

---------------------------------------------------------------------------------

local old_widgetsetup = containers.widgetsetup

local element_spear =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 36, 0),
            Vector3(0, -36, 0),
        },
        slotbg =
        {
            { image = "element_spear_slot1.tex" , atlas = "images/ui/element_spear_slot.xml" },
            { image = "element_spear_slot2.tex" , atlas = "images/ui/element_spear_slot.xml" },
        },
        animbank = "ui_cookpot_1x2",
        animbuild = "ui_cookpot_1x2",
        pos = Vector3(0, 60, 0),
    },
    usespecificslotsforitems = true,
    type = "hand_inv",
}

function element_spear.itemtestfn(container, item, slot)
	return item:HasTag("gem")
end

function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "element_spear" or prefab == "element_spear" then
		for k, v in pairs(element_spear) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return old_widgetsetup(container, prefab, data, ...)
end

---------------------------------------------------------------------------------

--转换成武器去听
local function OwnerOnDamageCalculated(owner, data)
    local inst = owner.components.combat:GetWeapon()
    if inst == nil then
        return
    end
    inst:PushEvent("damagecalculated", {target = data.target, damage = data.damage, weapon = data.weapon, stimuli = data.stimuli, elementvalue = data.elementvalue, crit = data.crit, attackkey = data.attackkey})
end

local function OwnerOnHitOther(owner, data)
    local inst = owner.components.combat:GetWeapon()
    if inst == nil then
        return
    end
    inst:PushEvent("onhitother", {target = data.terget, damage = data.damage, damageresolved = data.damageresolved, stimuli = data.stimuli, weapon = data.weapon, redirected = data.redirected})
end

--统一设置计时器的格式
local function LocalStartTimer(inst, name, time)
    if name == nil or time == nil or time < 0 then
        return
    end
    if inst.components.timer:TimerExists(name) then
        inst.components.timer:SetTimeLeft(name, time)
    else
        inst.components.timer:StartTimer(name, time)
    end
end

---------------------------------------------------------------------------------

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_spear", "swap_spear")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)
    end
    
    --武器被削了
    owner.components.combat.external_critical_rate_multipliers:SetModifier(inst, 0.221, "all_permanent")
    --owner.components.combat.external_critical_damage_multipliers:SetModifier(inst, 1, "all_permanent")
    --owner.components.combat.external_element_mastery_multipliers:SetModifier(inst, 200, "all_permanent")
    
    owner:ListenForEvent("damagecalculated", OwnerOnDamageCalculated)
    owner:ListenForEvent("onhitother", OwnerOnHitOther)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst.components.container ~= nil then
        inst.components.container:Close()
    end

    owner.components.combat.externaldamagemultipliers:RemoveModifier(inst)
    owner.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
	owner.components.combat.external_atk_multipliers:RemoveModifier(inst)
    owner.components.combat.external_critical_rate_multipliers:RemoveModifier(inst)
    owner.components.combat.external_critical_damage_multipliers:RemoveModifier(inst)
    owner.components.combat.external_attacktype_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_pyro_res_multipliers:RemoveModifier(inst)
    owner.components.combat.external_element_mastery_multipliers:RemoveModifier(inst)

    owner:RemoveEventCallback("damagecalculated", OwnerOnDamageCalculated)
    owner:RemoveEventCallback("onhitother", OwnerOnHitOther)
end

---------------------------------------------------------------------------------

local function GetElement(inst, type)
    if type == nil then
        return 8 
    end

    if type == "charge" then
        if inst.components.container.slots[1] == nil then
            return 8
        end
        if inst.components.container.slots[1].prefab == "redgem" then
            return 1  --火
        elseif inst.components.container.slots[1].prefab == "yellowgem" then --饥荒没有浅蓝
            return 2  --冰
        elseif inst.components.container.slots[1].prefab == "bluegem" then
            return 3  --水
        elseif inst.components.container.slots[1].prefab == "purplegem" then
            return 4  --雷
        elseif inst.components.container.slots[1].prefab == "greengem" then
            return 5  --风
        elseif inst.components.container.slots[1].prefab == "orangegem" then
            return 6  --岩
        elseif inst.components.container.slots[1].prefab == "opalpreciousgem" then
            return 7  --草
        else
            return 8  --物理
        end
    elseif type == "skill" then
        if inst.components.container.slots[2] == nil then
            return 8
        end
        if inst.components.container.slots[2].prefab == "redgem" then
            return 1  --火
        elseif inst.components.container.slots[2].prefab == "yellowgem" then --饥荒没有浅蓝
            return 2  --冰
        elseif inst.components.container.slots[2].prefab == "bluegem" then
            return 3  --水
        elseif inst.components.container.slots[2].prefab == "purplegem" then
            return 4  --雷
        elseif inst.components.container.slots[2].prefab == "greengem" then
            return 5  --风
        elseif inst.components.container.slots[2].prefab == "orangegem" then
            return 6  --岩
        elseif inst.components.container.slots[2].prefab == "opalpreciousgem" then
            return 7  --草
        else
            return 8  --物理
        end
    end
    return 8 
end

local anims = {
    "pyro",
    "cryo",
    "hydro",
    "electro",
    "anemo",
    "geo",
    "dendro",
}

local function SpawnFx(elements, x, y, z)
    local fxname
    if elements >= 1 and elements <= 7 then
        fxname = "element_spearfx_"..anims[elements]
    end
    if fxname == nil then
        return
    end
    local fx = SpawnPrefab(fxname)
    fx.Transform:SetPosition(x, y, z)
end

local function DoElementAttack(inst, target, pos)
    if inst.components.rechargeable == nil or inst.components.rechargeable.IsCharged == nil then
		return false
	end	
    if not inst.components.rechargeable:IsCharged() then
		return false
	end	

    local x, y, z 
    if target ~= nil then
        local x1, y1, z1 = target.Transform:GetWorldPosition()
        x = x1
        y = y1
        z = z1
    else
        x = pos.x
        y = pos.y
        z = pos.z
    end
    local attacker = inst.components.inventoryitem.owner

    if attacker == nil then
        return
    end
    
    local ents = TheSim:FindEntities(x, y, z, 4, {"_combat"}, {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "playerghost", "companion", "noauradamage"})
    local bloombombs = TheSim:FindEntities(x, y, z, 4, {"bloombomb"}, {"isexploding", "istracing"})
    
    local elements = GetElement(inst, "skill")
    SpawnFx(elements, x, y, z)

    if elements == 1 then
        for k, v in pairs(bloombombs) do
            v:Burgeon(attacker)
        end
    elseif elements == 4 then
        for k, v in pairs(bloombombs) do
            v:Hyperbloom(attacker)
        end
    end

    if ents == nil then
        inst.components.rechargeable:Discharge(TUNING.ELEMENT_SPEAR_COOLDOWN)
        return
    end

    if attacker ~= nil and attacker.components.combat ~= nil then
		if attacker.components.combat.ignorehitrange then
            for k, v in pairs(ents) do
                attacker.components.combat:DoAttack(v, inst, nil, elements, 2.31, "elementalskill")
            end
		else
			attacker.components.combat.ignorehitrange = true
            for k, v in pairs(ents) do
                attacker.components.combat:DoAttack(v, inst, nil, elements, 2.31, "elementalskill")
            end
			attacker.components.combat.ignorehitrange = false
		end
    end

    inst.components.rechargeable:Discharge(TUNING.ELEMENT_SPEAR_COOLDOWN)
end

---------------------------------------------------------------------------------

local function ElementFn(inst, owner, target)
    return owner and owner.sg and owner.sg:HasStateTag("chargeattack") and GetElement(inst, "charge") or 8
end

local function AttackkeyFn(inst, owner, target)
    return owner and owner.sg and owner.sg:HasStateTag("chargeattack") and "charge" or "normal"
end

local function DamageFn(weapon, attacker, target)
    if attacker == nil or attacker.components.combat == nil then
        return TUNING.SPEAR_DAMAGE
    end
    return attacker.components.combat.defaultdamage + TUNING.SPEAR_DAMAGE
end

local function ChargeATKRateFn(inst, attacker, target)
    return 1.7
end

local function StartRechargeFn(inst)
    --
end

local function StopRechargeFn(inst)
    --
end

local function OnDamageCalculated(inst, data)
    local owner = inst.components.inventoryitem.owner
    if owner == nil or owner.components.combat == nil then
        return
    end

    --[[
    if data.attackkey == "normal" then
        print("normalattack\n\n")
        owner.components.combat.external_attacktype_multipliers:SetModifier(inst, 0.2, "charge_weaponeffect1")
        owner.components.combat.external_critical_rate_multipliers:SetModifier(inst, 0.1, "charge_weaponeffect1")
        LocalStartTimer(inst, "up_chargedmg_chargecrit", 6)
    end
    --
    if data.attackkey == "charge" then
        print("chargeattack\n\n")
        owner.components.combat.external_atk_multipliers:SetModifier(inst, 0.1, "all_weaponeffect2")  --
        owner.components.combat.external_critical_damage_multipliers:SetModifier(inst, 0.2, "all_weaponeffect2")
        LocalStartTimer(inst, "up_basedmg_allcritdmg", 6)
    end]]
    --只保留减cd和元素技能加元素伤害的特效，其他的砍掉了
    if data.crit and data.stimuli >= 1 and data.stimuli <= 7 then
        --print("elementcrit\n\n")
        if not inst:HasTag("weaponcrit_decreasecd") then
            inst.components.rechargeable:LeftTimeDelta(1)
            inst:AddTag("weaponcrit_decreasecd")
            inst:DoTaskInTime(3, function(inst) inst:RemoveTag("weaponcrit_decreasecd") end)
        end
    end
    --但是倍率下调到0.16
    if data.attackkey == "elementalskill" and data.stimuli >= 1 and data.stimuli <= 7 then
        --print("skillelement\n\n")
        local rate = {0.16, 0.2, 0.24, 0.28, 0.32}
        local level = inst.components.refineable:GetCurrentLevel()
        owner.components.combat.external_pyro_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_cryo_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_hydro_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_electro_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_anemo_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_geo_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        owner.components.combat.external_dendro_multipliers:SetModifier(inst, rate[level], "all_weaponeffect3")
        LocalStartTimer(inst, "up_alleledmg", 10)
    end
end

local function OnHitOther(inst, data)
    
end

local function ratefn(inst)
    return 1
end

local function CanCastFn(doer, target, pos)
    if doer == nil or doer.components.combat == nil then
        return
    end
    local inst = doer.components.combat:GetWeapon()
    if inst == nil then
       return false
    elseif inst.components.rechargeable and not inst.components.rechargeable:IsCharged() then
		return false
	end	
    return true
end

local function OnTimerDone(inst, data)
    local owner = inst.components.inventoryitem.owner
    if owner == nil or owner.components.combat == nil then
        return
    end

    if data.name == "up_chargedmg_chargecrit" then
        owner.components.combat.external_attacktype_multipliers:RemoveModifier(inst, "charge_weaponeffect1")
        owner.components.combat.external_critical_rate_multipliers:RemoveModifier(inst, "charge_weaponeffect1")
    end
    if data.name == "up_basedmg_allcritdmg" then
        owner.components.combat.external_atk_multipliers:RemoveModifier(inst, "all_weaponeffect2")
        owner.components.combat.external_critical_damage_multipliers:RemoveModifier(inst, "all_weaponeffect2")
    end
    if data.name == "up_alleledmg" then
        owner.components.combat.external_pyro_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_cryo_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_hydro_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_electro_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_anemo_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_geo_multipliers:RemoveModifier(inst, "all_weaponeffect3")
        owner.components.combat.external_dendro_multipliers:RemoveModifier(inst, "all_weaponeffect3")
    end
end

---------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spear")
    inst.AnimState:SetBuild("swap_spear")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("rechargeable")
    inst:AddTag("aselementalskill")
    inst:AddTag("chargeattack_weapon")
    inst:AddTag("subtextweapon")
    inst.subtext = "crit_rate"
    inst.subnumber = "22.1%"
    inst.description = TUNING.WEAPONEFFECT_ELEMENT_SPEAR

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DamageFn)
    inst.components.weapon:SetOverrideStimuliFn(ElementFn)
	inst.components.weapon:SetOverrideAttackkeyFn(AttackkeyFn)
    -------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "spear"
    inst.components.inventoryitem.atlasname = GetInventoryItemAtlas("spear.tex")
	inst.components.inventoryitem:ChangeImageName("spear")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("rechargeable")

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(DoElementAttack)
    inst.components.spellcaster:SetCanCastFn(CanCastFn)
    --inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canonlyuseoncombat = true
    inst.components.spellcaster.veryquickcast = true

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("element_spear", element_spear)
	inst.components.container.canbeopened = true

    inst:AddComponent("refineable")

    inst:AddComponent("timer")
    inst:ListenForEvent("timerdone", OnTimerDone)

    inst:ListenForEvent("damagecalculated", OnDamageCalculated)
    inst:ListenForEvent("onhitother", OnHitOther)

    MakeHauntableLaunch(inst)
    inst.chargeattackdmgratefn = ChargeATKRateFn

    return inst
end

return Prefab("element_spear", fn, assets)