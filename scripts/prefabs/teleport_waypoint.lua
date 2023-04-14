local assets =
{
    Asset("ANIM", "anim/teleport_waypoint.zip"),
}

---------------------------------------------------------------------------------

local function RegisterSelf(inst, playerid)
    local x, y, z = inst.Transform:GetWorldPosition()
    SendModRPCToClient(GetClientModRPC("GenshinCore", "registerwaypoint"), playerid, x, y, z, inst.GUID, inst.components.writeable:GetText())
end

local function UnRegisterSelf(inst, playerid)
    SendModRPCToClient(GetClientModRPC("GenshinCore", "unregisterwaypoint"), playerid, inst.GUID)
end

---------------------------------------------------------------------------------

local function CheckPosition(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 20, {"teleport_waypoint"})
    if #ents >= 2 then  --哎呦，除了我还有至少一个啊
        return false
    end
    return true
end

local function OnBuilt(inst)
    if not CheckPosition(inst) then
        inst.components.talker:Say(STRINGS.TELEPORT_WAYPOINT_CRASH)
        inst.components.lootdropper:DropLoot()
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx:SetMaterial("metal")
        inst:Remove()
        --注册取消事件
        for i, player in ipairs(AllPlayers) do
            UnRegisterSelf(inst, player.userid)
        end
        return
    end
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end

local function OnPlayerJoined(inst, player)
    -- 当新玩家加入向他推送事件
    RegisterSelf(inst, player.userid)
end

local function OnWritingEndedFn(inst)
    -- 书写完成，向所有玩家推送注册事件
    for i, player in ipairs(AllPlayers) do
        RegisterSelf(inst, player.userid)
    end
    -- 监听新玩家加入
    inst:ListenForEvent("ms_playerjoined", function(src, player) OnPlayerJoined(inst, player) end, TheWorld)
end

local function OnLoad(inst)
    -- 加载时向所有玩家推送注册事件
    for i, player in ipairs(AllPlayers) do
        RegisterSelf(inst, player.userid)
    end
    -- 监听新玩家加入
    inst:ListenForEvent("ms_playerjoined", function(src, player) OnPlayerJoined(inst, player) end, TheWorld)
end

local function OnHammered(inst, worker)
    -- 摧毁时向所有玩家推送取消注册事件
    for i, player in ipairs(AllPlayers) do
        UnRegisterSelf(inst, player.userid)
    end
    --拆除
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function OnHit(inst, worker)
    inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("teleport_waypoint")
    inst.AnimState:SetBuild("teleport_waypoint")
    inst.AnimState:PlayAnimation("idle", true)

    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst:AddTag("structure")
    inst:AddTag("teleport_waypoint")
    --Sneak these into pristine state for optimization
    inst:AddTag("_writeable")

    inst:AddComponent("talker")

    inst.entity:SetPristine()
    inst.persists = true

    if not TheWorld.ismastersim then
        return inst
    end
    --Remove these tags so that they can be added properly when replicating components below
    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("writeable")
    inst.components.writeable:SetOnWritingEndedFn(OnWritingEndedFn)

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:ListenForEvent("onbuilt", OnBuilt)

    inst.OnLoad = OnLoad

    return inst
end

return Prefab("teleport_waypoint", fn, assets),
    MakePlacer("teleport_waypoint_placer", "teleport_waypoint", "teleport_waypoint", "build")