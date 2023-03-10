------------------耐热药剂--------------------
local function pyro_potion_attachfn(inst, target)
    if target.components.temperature == nil then
        return
    end
    inst.player_overheathurtrate = target.components.temperature.overheathurtrate or target.components.temperature.hurtrate
    target.components.temperature:SetOverheatHurtRate(0.25 * inst.player_overheathurtrate)
end

local function pyro_potion_detachfn(inst, target)
    if target.components.temperature == nil then
        return
    end
    target.components.temperature:SetOverheatHurtRate(inst.player_overheathurtrate or TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME)
end

------------------耐寒药剂--------------------
local function cryo_potion_attachfn(inst, target)
    if target.components.temperature == nil then
        return
    end
    inst.player_freezinghurtrate = target.components.temperature.hurtrate
    target.components.temperature:SetFreezingHurtRate(0.25 * inst.player_freezinghurtrate)
end

local function cryo_potion_detachfn(inst, target)
    if target.components.temperature == nil then
        return
    end
    target.components.temperature:SetFreezingHurtRate(inst.player_freezinghurtrate or TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME)
end

------------------防潮药剂--------------------
local function hydro_potion_attachfn(inst, target)
    if target.components.moisture == nil then
        return
    end
    target.components.moisture.waterproofnessmodifiers:SetModifier(inst, 0.2, "all_potion")
end

local function hydro_potion_detachfn(inst, target)
    if target.components.moisture == nil then
        return
    end
    target.components.moisture.waterproofnessmodifiers:RemoveModifier(inst, "all_potion")
end

------------------绝缘药剂--------------------
local function electro_potion_attachfn(inst, target)
    if target.components.playerlightningtarget == nil then
        return
    end
    inst.player_lightningchance = target.components.playerlightningtarget:GetHitChance()
    target.components.playerlightningtarget:SetHitChance(0)
end

local function electro_potion_detachfn(inst, target)
    if target.components.playerlightningtarget == nil then
        return
    end
    target.components.playerlightningtarget:SetHitChance(inst.player_lightningchance or TUNING.PLAYER_LIGHTNING_TARGET_CHANCE)
end

------------------防风药剂--------------------
local function anemo_potion_attachfn(inst, target)
    if target.components.locomotor == nil then
        return
    end
    target.components.locomotor:SetExternalSpeedMultiplier(inst, "all_potion", 1.1)  --注意SetExternalSpeedMultiplier和之前的Modifier不一样
end

local function anemo_potion_detachfn(inst, target)
    if target.components.locomotor == nil then
        return
    end
    target.components.locomotor:RemoveExternalSpeedMultiplier(inst, "all_potion")
end

------------------防尘药剂--------------------
local function geo_potion_attachfn(inst, target)
    if target.components.workmultiplier == nil then
        return
    end
    target.components.workmultiplier:AddMultiplier(ACTIONS.MINE, 1.3, inst)
end

local function geo_potion_detachfn(inst, target)
    if target.components.workmultiplier == nil then
        return
    end
    target.components.workmultiplier:RemoveMultiplier(ACTIONS.MINE, inst)
end

------------------治草（耐艹bushi）药剂--------------------
local function dendro_potion_attachfn(inst, target)
    if target.components.workmultiplier == nil then
        return
    end
    target.components.workmultiplier:AddMultiplier(ACTIONS.CHOP, 1.3, inst)
end

local function dendro_potion_detachfn(inst, target)
    if target.components.workmultiplier == nil then
        return
    end
    target.components.workmultiplier:RemoveMultiplier(ACTIONS.CHOP, inst)
end

------------------------------------------------------------------------------
------------------------------------------------------------------------------

local function MakeBuff(name, typ, element, add_attachfn, add_detachfn)
    
    local function OnAttached(inst, target)
        inst.entity:SetParent(target.entity)
        inst.Transform:SetPosition(0, 0, 0) --in case of loading
        
        if target.components.combat then
            if typ == "oil" then
                target.components.combat["external_"..element.."_multipliers"]:SetModifier(inst, 0.25, "all_essential_oil")
            else
                target.components.combat["external_"..element.."_res_multipliers"]:SetModifier(inst, 0.25, "all_potion")
            end
        end

        if add_attachfn ~= nil then
            add_attachfn(inst, target)
        end 

        inst:ListenForEvent("death", function()
            inst.components.debuff:Stop()
        end, target)
    end
    
    local function OnDetached(inst, target)
        if target.components.combat then
            if typ == "oil" then
                target.components.combat["external_"..element.."_multipliers"]:RemoveModifier(inst, "all_essential_oil")
            else
                target.components.combat["external_"..element.."_res_multipliers"]:RemoveModifier(inst, "all_potion")
            end
        end

        if add_detachfn ~= nil then
            add_detachfn(inst, target)
        end 

        inst:Remove()
    end

    local function OnTimerDone(inst, data)
        if data.name == "buffover" then
            inst.components.debuff:Stop()
        end
    end
    
    local function OnExtended(inst, target)
        inst.components.timer:StopTimer("buffover")
        inst.components.timer:StartTimer("buffover", TUNING.GENSHIN_POTIONS_DURATION)
    end

    local function fn()
        local inst = CreateEntity()

        if not TheWorld.ismastersim then
            --Not meant for client!
            inst:DoTaskInTime(0, inst.Remove)

            return inst
        end

        inst.entity:AddTransform()

        --[[Non-networked entity]]
        --inst.entity:SetCanSleep(false)
        inst.entity:Hide()
        inst.persists = false

        inst:AddTag("CLASSIFIED")

        inst:AddComponent("debuff")
        inst.components.debuff:SetAttachedFn(OnAttached)
        inst.components.debuff:SetDetachedFn(OnDetached)
        inst.components.debuff:SetExtendedFn(OnExtended)
        inst.components.debuff.keepondespawn = true

        inst:AddComponent("timer")
        inst.components.timer:StartTimer("buffover", TUNING.GENSHIN_POTIONS_DURATION)
        inst:ListenForEvent("timerdone", OnTimerDone)

        return inst
    end

    return Prefab(name.."_"..typ.."buff", fn)
end

local function MakeItem(name, typ, ele)
    local complete_name = typ == "oil" and name.."_essential_oil" or name.."_potion"

    local assets =
    {
        Asset("ANIM", "anim/genshin_potions.zip"),
        Asset("IMAGE", "images/inventoryimages/genshin_potions.tex"),
        Asset("ATLAS", "images/inventoryimages/genshin_potions.xml"),
    }
    
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.Transform:SetScale(0.7, 0.7, 0.7)

        MakeInventoryPhysics(inst)

        inst:AddTag("genshin_potions")
        inst:AddTag("genshin_potions_type_"..name)

        inst.AnimState:SetBank("genshin_potions")
        inst.AnimState:SetBuild("genshin_potions")
        inst.AnimState:PlayAnimation(complete_name)

        MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/genshin_potions.xml"
        inst.components.inventoryitem.imagename = complete_name
	    inst.components.inventoryitem:ChangeImageName(complete_name)

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst.onuse = function(inst, player)
            player:AddDebuff(name.."_"..typ.."buff", name.."_"..typ.."buff")
            play:PushEvent("use_elemental_potion", {element = ele, name = name, type = typ})
        end

        return inst
    end

    return Prefab(complete_name, fn, assets)
end

return MakeItem("flaming", "oil", "pyro"), MakeBuff("flaming", "oil", "pyro"),
    MakeItem("frosting", "oil", "cryo"), MakeBuff("frosting", "oil", "cryo"),
    MakeItem("streaming", "oil", "hydro"), MakeBuff("streaming", "oil", "hydro"),
    MakeItem("shocking", "oil", "electro"), MakeBuff("shocking", "oil", "electro"),
    MakeItem("gushing", "oil", "anemo"), MakeBuff("gushing", "oil", "anemo"),
    MakeItem("unmoving", "oil", "geo"), MakeBuff("unmoving", "oil", "geo"),
    MakeItem("forest", "oil", "dendro"), MakeBuff("forest", "oil", "dendro"),
    MakeItem("heatshield", "potion", "pyro"), MakeBuff("heatshield", "potion", "pyro", pyro_potion_attachfn, pyro_potion_detachfn),
    MakeItem("frostshield", "potion", "cryo"), MakeBuff("frostshield", "potion", "cryo", cryo_potion_attachfn, cryo_potion_detachfn),
    MakeItem("desiccant", "potion", "hydro"), MakeBuff("desiccant", "potion", "hydro", hydro_potion_attachfn, hydro_potion_detachfn),
    MakeItem("insulation", "potion", "electro"), MakeBuff("insulation", "potion", "electro", electro_potion_attachfn, electro_potion_detachfn),
    MakeItem("windbarrier", "potion", "anemo"), MakeBuff("windbarrier", "potion", "anemo", anemo_potion_attachfn, anemo_potion_detachfn),
    MakeItem("dustproof", "potion", "geo"), MakeBuff("dustproof", "potion", "geo", geo_potion_attachfn, geo_potion_detachfn),
    MakeItem("dendrocide", "potion", "dendro"), MakeBuff("dendrocide", "potion", "dendro", dendro_potion_attachfn, dendro_potion_detachfn)