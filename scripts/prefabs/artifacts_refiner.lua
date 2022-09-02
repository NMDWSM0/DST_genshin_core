local containers = require "containers"

local assets =
{
    Asset("ANIM", "anim/artifacts_refiner.zip"),
    Asset("ANIM", "anim/ui_artifacts_refiner.zip"),
}

---------------------------------------------------------------------------------

local old_widgetsetup = containers.widgetsetup

local artifacts_refiner =
{
    widget =
    {
        slotpos =
        {
            Vector3(0,  100,  0),

            Vector3(-60-150,  -18,  0),
            Vector3(-60-75,  -18,  0),
            Vector3(-60,  -18,  0),
            Vector3(60,  -18,  0),
            Vector3(60+75,  -18,  0),
            Vector3(60+150,  -18,  0),

            Vector3(-60-150,  -105,  0),
            Vector3(-60-75,  -105,  0),
            Vector3(-60,  -105,  0),
            Vector3(60,  -105,  0),
            Vector3(60+75,  -105,  0),
            Vector3(60+150,  -105,  0),

            Vector3(-60-150,  -192,  0),
            Vector3(-60-75,  -192,  0),
            Vector3(-60,  -192,  0),
            Vector3(60,  -192,  0),
            Vector3(60+75,  -192,  0),
            Vector3(60+150,  -192,  0),

            Vector3(-60-150,  -279,  0),
            Vector3(-60-75,  -279,  0),
            Vector3(-60,  -279,  0),
            Vector3(60,  -279,  0),
            Vector3(60+75,  -279,  0),
            Vector3(60+150,  -279,  0),

            Vector3(-60-150,  -366,  0),
            Vector3(-60-75,  -366,  0),
            Vector3(-60,  -366,  0),
            Vector3(60,  -366,  0),
            Vector3(60+75,  -366,  0),
            Vector3(60+150,  -366,  0),

            Vector3(-60-150,  -453,  0),
            Vector3(-60-75,  -453,  0),
            Vector3(-60,  -453,  0),
            Vector3(60,  -453,  0),
            Vector3(60+75,  -453,  0),
            Vector3(60+150,  -453,  0),

            Vector3(-60-150,  -540,  0),
            Vector3(-60-75,  -540,  0),
            Vector3(-60,  -540,  0),
            Vector3(60,  -540,  0),
            Vector3(60+75,  -540,  0),
            Vector3(60+150,  -540,  0),
        },
        slotbg =
        {
            { atlas = "images/ui/art_slotbg_empty.xml", image = "art_slotbg_empty.tex", atlas_full = "images/ui/art_slotbg.xml", image_full = "art_slotbg.tex", 
                highlight_scale = 1.07, tile_scale = 1.25, tile_offset = Vector3(0, 10, 0) },
        },
        animbank = "ui_artifacts_refiner",
        animbuild = "ui_artifacts_refiner",
        pos = Vector3(250, 100, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "还圣" or "Create",
            position = Vector3(0, -633, 0),
            genshinstylebutton = true,
        },
        hinttext = {
            font = "genshinfont",
            text = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "还圣奥迹" or "Mystic Offering",
            position = Vector3(0, 193, 0),
            color = { 211/255, 188/255, 142/255, 1 },
            size = 36,
            regionsize = {x = 444, y = 100},
        }
    },
    type = "cooker",
}

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, artifacts_refiner.widget.slotpos ~= nil and #artifacts_refiner.widget.slotpos or 0)

function artifacts_refiner.itemtestfn(container, item, slot)
    local artifacts = item.components.artifacts or item.replica.artifacts
    if artifacts == nil then
        return false
    end
    if slot ~= 1 and artifacts:IsLocked() then
        return false
    end
	return true
end

function artifacts_refiner.widget.buttoninfo.fn(inst, doer)
    SendModRPCToServer(MOD_RPC["artifacts_refiner"]["dorefine"], inst)
end

function artifacts_refiner.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and not inst.replica.container:IsEmpty() and inst.replica.container:GetItemInSlot(1) ~= nil
end

function containers.widgetsetup(container, prefab, data, ...)
	if container.inst.prefab == "artifacts_refiner" or prefab == "artifacts_refiner" then
		for k, v in pairs(artifacts_refiner) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
        return
	end
    return old_widgetsetup(container, prefab, data, ...)
end

---------------------------------------------------------------------------------

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onhammered(inst, worker)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    inst.AnimState:PlayAnimation("hit")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.1, 1.1, 1.1)

    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("artifacts_refiner")
    inst.AnimState:SetBuild("artifacts_refiner")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("container")
    inst:AddTag("artifacts_refiner")

    inst.entity:SetPristine()

    inst.persists = true

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("artifacts_refiner", artifacts_refiner)
    inst.components.container.canbeopened = true
    --inst.components.container.onopenfn = OnOpen
    --inst.components.container.onclosefn = OnClose

    inst:AddComponent("lootdropper")
        
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("artifacts_refiner", fn, assets),
    MakePlacer("artifacts_refiner_placer", "artifacts_refiner", "artifacts_refiner", "idle")