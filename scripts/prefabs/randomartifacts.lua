local assets =
{
    Asset("ANIM", "anim/randomartifacts.zip"),
    Asset("IMAGE", "images/inventoryimages/randomartifacts.tex"),
    Asset("ATLAS", "images/inventoryimages/randomartifacts.xml"),
}

local function InitLoottable(set)
    local loottable = {}
    local number_sets = 0
    local number_tags = 0

    local sets = {}
    if set == "all" then
        for k,v in pairs(TUNING.ARTIFACTS_SETS) do
            table.insert(sets, k)
            number_sets = number_sets + 1
        end
    else
        table.insert(sets, set)
        number_sets = number_sets + 1
    end

    local tags = {}
    for k,v in pairs(TUNING.ARTIFACTS_TAG) do
        table.insert(tags, k)
        number_tags = number_tags + 1
    end

    local totalnumber = set == "all" and (math.random()<0.1 and 3 or (math.random()<0.5 and 2 or 1)) or 1
    for i = 1, totalnumber do
        local setnumber = math.random(number_sets)
        local tagnumber = math.random(number_tags)
        local art = sets[setnumber].."_"..tags[tagnumber]
        table.insert(loottable, art)
    end
    return loottable
end

local function OnUnwrapped(inst, pos, doer)
    if inst.burnt then
        SpawnPrefab("ash").Transform:SetPosition(pos:Get())
    else
        local loottable = InitLoottable(inst.set)
        if loottable ~= nil then
            local moisture = inst.components.inventoryitem:GetMoisture()
            local iswet = inst.components.inventoryitem:IsWet()
            for i, v in ipairs(loottable) do
                local item = SpawnPrefab(v)
                if item ~= nil then
                    if item.Physics ~= nil then
                        item.Physics:Teleport(pos:Get())
                    else
                        item.Transform:SetPosition(pos:Get())
                    end
                    if item.components.inventoryitem ~= nil then
                        item.components.inventoryitem:InheritMoisture(moisture, iswet)
                    end
                end
            end
        end
        SpawnPrefab("gift_unwrap").Transform:SetPosition(pos:Get())
    end
    if doer ~= nil and doer.SoundEmitter ~= nil then
        doer.SoundEmitter:PlaySound("dontstarve/common/together/packaged")
    end
    if inst.components.stackable and inst.components.stackable.stacksize > 1 then
        (inst.components.stackable:Get(1)):Remove()
    else
        inst:Remove()
    end
end


local function RandomArtifacts(set)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        local animname = set == "all" and "anim" or "anim_"..set
        inst.AnimState:SetBank("randomartifacts")
        inst.AnimState:SetBuild("randomartifacts")
        inst.AnimState:PlayAnimation(animname)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = "images/inventoryimages/randomartifacts.xml"
        local imagename = set == "all" and "randomartifacts" or "randomartifacts_"..set
        inst.components.inventoryitem.imagename = imagename
	    inst.components.inventoryitem:ChangeImageName(imagename)

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

        inst:AddComponent("inspectable")

        inst:AddComponent("unwrappable")
        inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

        inst.set = set

        return inst
    end

    return set == "all" and Prefab("randomartifacts", fn, assets) or Prefab("randomartifacts_"..set, fn, assets)
end

return RandomArtifacts("all"),
    RandomArtifacts("bfmt"),
    RandomArtifacts("yzmn"),
    RandomArtifacts("clzy"),
    RandomArtifacts("clzx"),
    RandomArtifacts("ygpy"),
    RandomArtifacts("rlsn"),
    RandomArtifacts("cbzh"),
    RandomArtifacts("jyqy"),
    RandomArtifacts("sljy")