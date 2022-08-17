local containers = require "containers"

local containerassets =
{
    Asset("ANIM", "anim/ui_bundle_2x2.zip"),
    Asset("ANIM", "anim/artifactsbundle.zip"),

    Asset("IMAGE", "images/inventoryimages/artifactsbundle.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbundle.xml"),

    Asset("IMAGE", "images/inventoryimages/artifactsbundlewrap.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbundlewrap.xml"),
}

local old_widgetsetup = containers.widgetsetup

local artifactsbundlecontainer =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5, 32 + 4, 0),
            Vector3(37.5, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            --Vector3(37.5, -(32 + 4), 0),
        },
        animbank = "ui_bundle_2x2",
        animbuild = "ui_bundle_2x2",
        pos = Vector3(200, 0, 0),
        side_align_tip = 120,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.WRAPBUNDLE,
            position = Vector3(0, -100, 0),
        }
    },
    type = "cooker",
}

function artifactsbundlecontainer.itemtestfn(container, item, slot)
    local artifacts = item.components.artifacts or item.replica.artifacts
	return item:HasTag("artifacts") and not artifacts:IsLocked()
end

function artifactsbundlecontainer.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.WRAPBUNDLE):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.WRAPBUNDLE.code, inst, ACTIONS.WRAPBUNDLE.mod_name)
    end
end

function artifactsbundlecontainer.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "artifactsbundlecontainer" or prefab == "artifactsbundlecontainer" then
		for k, v in pairs(artifactsbundlecontainer) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return old_widgetsetup(container, prefab, data, ...)
end

local function fncontainer()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("bundle")

    --V2C: blank string for controller action prompt
    inst.name = " "

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("artifactsbundlecontainer", artifactsbundlecontainer)

    inst.persists = false

    return inst
end

--********************************************--

local function OnStartBundling(inst)--, doer)
    inst.components.stackable:Get():Remove()
end

local wrapassets =
{
    Asset("ANIM", "anim/bundle.zip"),
    Asset("INV_IMAGE", "bundle_large"),
}

local wrapprefabs =
{
    "bundle",
    "artifactsbundlecontainer",
}

local function fnwrap()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("artifactsbundle")
    inst.AnimState:SetBuild("artifactsbundle")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetSinks(false)
    inst.components.inventoryitem.imagename = "artifactsbundlewrap"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/artifactsbundlewrap.xml"
	inst.components.inventoryitem:ChangeImageName("artifactsbundlewrap")

    inst:AddComponent("bundlemaker")
    inst.components.bundlemaker:SetBundlingPrefabs("artifactsbundlecontainer", "artifactsbundle")
    inst.components.bundlemaker:SetOnStartBundlingFn(OnStartBundling)


    return inst
end

--********************************************--

local assets =
{
    Asset("ANIM", "anim/bundle.zip"),
    Asset("INV_IMAGE", "bundle_large"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("artifactsbundle")
    inst.AnimState:SetBuild("artifactsbundle")
    inst.AnimState:PlayAnimation("idle_large")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "artifactsbundle"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/artifactsbundle.xml"
	inst.components.inventoryitem:ChangeImageName("artifactsbundle")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    return inst
end

return Prefab("artifactsbundlewrap", fnwrap, wrapassets, wrapprefabs),
    Prefab("artifactsbundlecontainer", fncontainer, containerassets),
    Prefab("artifactsbundle", fn, assets)