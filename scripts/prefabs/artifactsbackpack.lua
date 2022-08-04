local containers = require "containers"

local assets =
{
    Asset("ANIM", "anim/artifactsbackpack.zip"),
    Asset("ANIM", "anim/ui_artifactsbackpack_6x9.zip"),
    Asset("IMAGE", "images/inventoryimages/artifactsbackpack.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbackpack.xml"),
}

---------------------------------------------------------------------------------

local old_widgetsetup = containers.widgetsetup

local artifactsbackpack =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5-150,  72,  0),
            Vector3(-37.5-75,  72,  0),
            Vector3(-37.5,  72,  0),
            Vector3(37.5,  72,  0),
            Vector3(37.5+75,  72,  0),
            Vector3(37.5+150,  72,  0),

            Vector3(-37.5-150,  0,  0),
            Vector3(-37.5-75,  0,  0),
            Vector3(-37.5,  0,  0),
            Vector3(37.5,  0,  0),
            Vector3(37.5+75,  0,  0),
            Vector3(37.5+150,  0,  0),

            Vector3(-37.5-150,  -72,  0),
            Vector3(-37.5-75,  -72,  0),
            Vector3(-37.5,  -72,  0),
            Vector3(37.5,  -72,  0),
            Vector3(37.5+75,  -72,  0),
            Vector3(37.5+150,  -72,  0),

            Vector3(-37.5-150,  -144,  0),
            Vector3(-37.5-75,  -144,  0),
            Vector3(-37.5,  -144,  0),
            Vector3(37.5,  -144,  0),
            Vector3(37.5+75,  -144,  0),
            Vector3(37.5+150,  -144,  0),

            Vector3(-37.5-150,  -216,  0),
            Vector3(-37.5-75,  -216,  0),
            Vector3(-37.5,  -216,  0),
            Vector3(37.5,  -216,  0),
            Vector3(37.5+75,  -216,  0),
            Vector3(37.5+150,  -216,  0),

            Vector3(-37.5-150,  -288,  0),
            Vector3(-37.5-75,  -288,  0),
            Vector3(-37.5,  -288,  0),
            Vector3(37.5,  -288,  0),
            Vector3(37.5+75,  -288,  0),
            Vector3(37.5+150,  -288,  0),

            Vector3(-37.5-150,  -360,  0),
            Vector3(-37.5-75,  -360,  0),
            Vector3(-37.5,  -360,  0),
            Vector3(37.5,  -360,  0),
            Vector3(37.5+75,  -360,  0),
            Vector3(37.5+150,  -360,  0),

            Vector3(-37.5-150,  -432,  0),
            Vector3(-37.5-75,  -432,  0),
            Vector3(-37.5,  -432,  0),
            Vector3(37.5,  -432,  0),
            Vector3(37.5+75,  -432,  0),
            Vector3(37.5+150,  -432,  0),

            Vector3(-37.5-150,  -504,  0),
            Vector3(-37.5-75,  -504,  0),
            Vector3(-37.5,  -504,  0),
            Vector3(37.5,  -504,  0),
            Vector3(37.5+75,  -504,  0),
            Vector3(37.5+150,  -504,  0),
        },
        animbank = "ui_artifactsbackpack_6x9",
        animbuild = "ui_artifactsbackpack_6x9",
        pos = Vector3(240, 80, 0),
    },
    type = "cooker",
}

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, artifactsbackpack.widget.slotpos ~= nil and #artifactsbackpack.widget.slotpos or 0)

function artifactsbackpack.itemtestfn(container, item, slot)
	return item:HasTag("artifacts")
end

function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "artifactsbackpack" or prefab == "artifactsbackpack" then
		for k, v in pairs(artifactsbackpack) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return old_widgetsetup(container, prefab, data, ...)
end

---------------------------------------------------------------------------------

local function OnOpen(inst)
    if inst.components.inventoryitem.owner then
        inst.components.inventoryitem.owner:PushEvent("artbackpackchange")
    end
end

local function OnClose(inst)
    if inst.components.inventoryitem.owner then
        inst.components.inventoryitem.owner:PushEvent("artbackpackchange")
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("artifactsbackpack")
    inst.AnimState:SetBuild("artifactsbackpack")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("container")
    inst:AddTag("artifactsbackpack")

    MakeInventoryFloatable(inst, "small", 0.2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "artifactsbackpack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/artifactsbackpack.xml"
	inst.components.inventoryitem:ChangeImageName("artifactsbackpack")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("artifactsbackpack", artifactsbackpack)
    inst.components.container.canbeopened = true
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    inst.components.inventoryitem.cangoincontainer = true

    return inst
end

return Prefab("artifactsbackpack", fn, assets)
