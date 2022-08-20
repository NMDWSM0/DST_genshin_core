
local function onequip(inst, owner)
    inst:AddTag("nosteal")
    inst:DoTaskInTime(FRAMES, function(inst)
        if owner.components.artifactscollector ~= nil then
            owner.components.artifactscollector:RecalculateModifier()
        end
    end)
end

local function onunequip(inst, owner) 
    inst:RemoveTag("nosteal")
	inst:DoTaskInTime(FRAMES, function(inst)
        if owner.components.artifactscollector ~= nil then
            owner.components.artifactscollector:RecalculateModifier()
        end
    end)
end

---------------------------------------------------------------------------------
local function GetDesc(inst)
    local mainstring = TUNING.ARTIFACTS_TYPE[inst.components.artifacts.main.type]
    local mainnumber = inst.components.artifacts.main.number > 1 and inst.components.artifacts.main.number or (100 * inst.components.artifacts.main.number).."%"

    local sub1string = TUNING.ARTIFACTS_TYPE[inst.components.artifacts.sub1.type]
    local sub1number = inst.components.artifacts.sub1.number > 1 and inst.components.artifacts.sub1.number or (100 * inst.components.artifacts.sub1.number).."%"

    local sub2string = TUNING.ARTIFACTS_TYPE[inst.components.artifacts.sub2.type]
    local sub2number = inst.components.artifacts.sub2.number > 1 and inst.components.artifacts.sub2.number or (100 * inst.components.artifacts.sub2.number).."%"

    local sub3string = TUNING.ARTIFACTS_TYPE[inst.components.artifacts.sub3.type]
    local sub3number = inst.components.artifacts.sub3.number > 1 and inst.components.artifacts.sub3.number or (100 * inst.components.artifacts.sub3.number).."%"

    local sub4string = TUNING.ARTIFACTS_TYPE[inst.components.artifacts.sub4.type]
    local sub4number = inst.components.artifacts.sub4.number > 1 and inst.components.artifacts.sub4.number or (100 * inst.components.artifacts.sub4.number).."%"

    local desc = mainstring..": "..mainnumber.."\n"..
                 sub1string..": "..sub1number.."\n"..
                 sub2string..": "..sub2number.."\n"..
                 sub3string..": "..sub3number.."\n"..
                 sub4string..": "..sub4number
    return desc
end

local function SetDescription(inst)
    local desc = GetDesc(inst)
    inst.components.inspectable:SetDescription(desc)
end

---------------------------------------------------------------------------------

local function MakeArtifacts(sets, tag, maintype) 
    local assets =
    {
        Asset("ANIM", "anim/"..sets..".zip"),
        Asset("IMAGE", "images/inventoryimages/"..sets..".tex"),
        Asset("ATLAS", "images/inventoryimages/"..sets..".xml"),
    }
    
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank(sets)
        inst.AnimState:SetBuild(sets)
        inst.AnimState:PlayAnimation(tag)

        inst:AddTag("artifacts")
        inst:AddTag("artifacts_all")
        inst:AddTag("artifacts_"..sets)
        inst:AddTag("artifacts_"..tag)

        inst.inv_image_bg = { image = "blank.tex" }
        inst.inv_image_bg.atlas = "images/ui.xml"

        MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst.SetDescription = SetDescription

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = sets.."_"..tag
        inst.components.inventoryitem.atlasname = "images/inventoryimages/"..sets..".xml"
	    inst.components.inventoryitem:ChangeImageName(sets.."_"..tag)

        inst:AddComponent("artifacts")
        inst.components.artifacts:Init(sets, tag, maintype)

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS[string.upper(tag)]
	    inst.components.equippable:SetOnEquip(onequip)
	    inst.components.equippable:SetOnUnequip(onunequip)

        return inst
    end

    return Prefab(sets.."_"..tag, fn, assets)
end

return MakeArtifacts("bfmt", "flower"),  --冰
    MakeArtifacts("bfmt", "plume"),
    MakeArtifacts("bfmt", "sands"),
    MakeArtifacts("bfmt", "goblet"),
    MakeArtifacts("bfmt", "circlet"),
    --火
    MakeArtifacts("yzmn", "flower"),
    MakeArtifacts("yzmn", "plume"),
    MakeArtifacts("yzmn", "sands"),
    MakeArtifacts("yzmn", "goblet"),
    MakeArtifacts("yzmn", "circlet"),
    --风
    MakeArtifacts("clzy", "flower"),
    MakeArtifacts("clzy", "plume"),
    MakeArtifacts("clzy", "sands"),
    MakeArtifacts("clzy", "goblet"),
    MakeArtifacts("clzy", "circlet"),
    --雷
    MakeArtifacts("rlsn", "flower"),
    MakeArtifacts("rlsn", "plume"),
    MakeArtifacts("rlsn", "sands"),
    MakeArtifacts("rlsn", "goblet"),
    MakeArtifacts("rlsn", "circlet"),
    --水
    MakeArtifacts("clzx", "flower"),
    MakeArtifacts("clzx", "plume"),
    MakeArtifacts("clzx", "sands"),
    MakeArtifacts("clzx", "goblet"),
    MakeArtifacts("clzx", "circlet"),
    --岩
    MakeArtifacts("ygpy", "flower"),
    MakeArtifacts("ygpy", "plume"),
    MakeArtifacts("ygpy", "sands"),
    MakeArtifacts("ygpy", "goblet"),
    MakeArtifacts("ygpy", "circlet"),
    --苍白
    MakeArtifacts("cbzh", "flower"),
    MakeArtifacts("cbzh", "plume"),
    MakeArtifacts("cbzh", "sands"),
    MakeArtifacts("cbzh", "goblet"),
    MakeArtifacts("cbzh", "circlet"),
    --绝缘
    MakeArtifacts("jyqy", "flower"),
    MakeArtifacts("jyqy", "plume"),
    MakeArtifacts("jyqy", "sands"),
    MakeArtifacts("jyqy", "goblet"),
    MakeArtifacts("jyqy", "circlet"),
    --草套
    MakeArtifacts("sljy", "flower"),
    MakeArtifacts("sljy", "plume"),
    MakeArtifacts("sljy", "sands"),
    MakeArtifacts("sljy", "goblet"),
    MakeArtifacts("sljy", "circlet")