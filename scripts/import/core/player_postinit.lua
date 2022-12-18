local function charged(inst)
	if (not inst:HasTag("playerghost")) and (not inst:HasTag("charging")) then
        inst:AddTag("charging")
	end
end

local function uncharged(inst)
	if inst:HasTag("charging") then
        inst:RemoveTag("charging")
    end
end

AddModRPCHandler("player", "StartCharge", charged)
AddModRPCHandler("player", "StopCharge", uncharged)

local function synchronize(inst)   
	inst.cancharge = inst._cancharge:value()
end

AddPlayerPostInit(function(inst)
    inst.old_cancharge = false
    inst.cancharge = false
    inst.attack_start_time = 0
	inst.GetTime = GetTime()
    inst._cancharge = net_bool(inst.GUID, "inst._cancharge", "chargeconditiondirty")

    inst:DoPeriodicTask(FRAMES, function(inst)
        inst.old_cancharge = inst.cancharge
        inst.cancharge = (inst.GetTime - inst.attack_start_time) > 11 * FRAMES
        if inst.old_cancharge ~= inst.cancharge then
            inst._cancharge:set(inst.cancharge)
        end
        inst.GetTime = GetTime()
        if inst:HasTag("charging") then
            return
        end
        inst.attack_start_time = inst.GetTime
    end)

    local device = 1
    local numInputs = 1
    local input1 = GLOBAL.KEY_F
    local input2
    local input3
    local input4
    local intParam
    if not TheNet:IsDedicated() then
        device, numInputs, input1, input2, input3, input4, intParam = TheInputProxy:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_ATTACK, false, true)
    end
	TheInput:AddKeyDownHandler(numInputs > 0 and input1 or GLOBAL.KEY_F, function()
        if numInputs >= 2 and not TheInput:IsKeyDown(input2) then
            return
        elseif numInputs >= 3 and not TheInput:IsKeyDown(input3) then
            return
        elseif numInputs == 4 and not TheInput:IsKeyDown(input4) then
            return
        end
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD"
        if IsHUDscreen then
			SendModRPCToServer(MOD_RPC["player"]["StartCharge"])
		end
	end)
    TheInput:AddKeyUpHandler(numInputs > 0 and input1 or GLOBAL.KEY_F, function()
        if numInputs >= 2 and not TheInput:IsKeyDown(input2) then
            return
        elseif numInputs >= 3 and not TheInput:IsKeyDown(input3) then
            return
        elseif numInputs == 4 and not TheInput:IsKeyDown(input4) then
            return
        end
        local IsHUDscreen = GLOBAL.TheFrontEnd:GetActiveScreen() and GLOBAL.TheFrontEnd:GetActiveScreen().name == "HUD"
        if IsHUDscreen then
			SendModRPCToServer(MOD_RPC["player"]["StopCharge"])
		end
	end)

    --Sneak these into pristine state for optimization
    inst:AddTag("_combatstatus")
    inst:AddTag("_artifactscollector")
    inst:AddTag("_energyrecharge")
    inst:AddTag("_elementalcaster")
    inst:AddTag("_talents")
    inst:AddTag("_constellation")

	if not TheWorld.ismastersim then
		inst:ListenForEvent("chargeconditiondirty",synchronize)
        return
	end

    if inst.components.combatstatus == nil then
        inst:AddComponent("combatstatus")
    end
    if inst.components.artifactscollector == nil then
        inst:AddComponent("artifactscollector")
    end
    if inst.components.energyrecharge == nil then
        inst:AddComponent("energyrecharge")
    end
    if inst.components.elementalcaster == nil then
    inst:AddComponent("elementalcaster")
    end
    if inst.components.talents == nil then
        inst:AddComponent("talents")
    end
    if inst.components.constellation == nil then
    inst:AddComponent("constellation")
    end

    if inst.starting_inventory == nil then
        inst.starting_inventory = {}
    end
    table.insert(inst.starting_inventory, "element_spear")

    --修正maxhealth被类外部函数修改时造成的问题
    --[[inst:ListenForEvent("healthdelta", function(inst, data)
        if inst.components.health then
            inst.components.health:SynchronizeBaseHealth()
        end
    end)]]

    --人物防御力初始化
    inst.components.combat.defense = 300
    --非原神角色天赋最高等级1级
    if not inst:HasTag("genshin_character") then
        inst.components.talents.maxlevel = 1
    end
end)







--SGhandler，这样写不是直接覆盖，兼容性好点（要是别人直接覆盖，那我凉凉）
local function newattackactionhandler(sg)
    if sg.actionhandlers[ACTIONS.ATTACK] == nil then
	    return
    end

	local old_attackfn = sg.actionhandlers[ACTIONS.ATTACK].deststate
	sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
	    local state = old_attackfn(inst, action)
        local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
        local isriding = inst.components.rider:IsRiding()
        if state == "attack" and not isriding and (weapon and weapon:HasTag("chargeattack_weapon") or inst.chargesgname ~= nil) and inst.cancharge then
            state = inst.chargesgname ~= nil and FunctionOrValue(inst.chargesgname, inst) or "chargeattack"
        end
        return state
	end
end

local function newattackactionhandler_client(sg)
    if sg.actionhandlers[ACTIONS.ATTACK] == nil then
	    return
    end

	local old_attackfn = sg.actionhandlers[ACTIONS.ATTACK].deststate
	sg.actionhandlers[ACTIONS.ATTACK].deststate = function(inst, action)
	    local state = old_attackfn(inst, action)
        local equip = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local isriding = inst.replica.rider and inst.replica.rider:IsRiding() or false
        if state == "attack" and not isriding and (equip and equip:HasTag("chargeattack_weapon") or inst.chargesgname ~= nil) and inst.cancharge then
            state = inst.chargesgname ~= nil and FunctionOrValue(inst.chargesgname, inst) or "chargeattack"
        end
        return state
	end
end

AddStategraphPostInit("wilson", newattackactionhandler)
AddStategraphPostInit("wilson_client", newattackactionhandler_client)






--local i = 0

local chargeattack = State{
    name = "chargeattack",
    tags = { "chargeattack", "attack", "notalking", "abouttoattack", "autopredict" },

    onenter = function(inst)
        --i = i + 1
        if inst.components.combat:InCooldown() then
            inst.sg:RemoveStateTag("abouttoattack")
            inst:ClearBufferedAction()
            inst.sg:GoToState("idle", true)
            return
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        local buffaction = inst:GetBufferedAction()
        local target = buffaction ~= nil and buffaction.target or nil
        inst.components.combat:SetTarget(target)
        inst.components.combat:StartAttack()
        inst.components.locomotor:Stop()
        local cooldown = 21 * FRAMES

        inst.AnimState:PlayAnimation("spearjab")

        inst.sg:SetTimeout(cooldown)

        if target ~= nil then
            inst.components.combat:BattleCry()
            if target:IsValid() then
                inst:FacePoint(target:GetPosition())
                inst.sg.statemem.attacktarget = target
                inst.sg.statemem.retarget = target
            end
        end
    end,

    timeline =
    {
        TimeEvent(6 * FRAMES, function(inst)
            inst:PerformBufferedAction()
            --print(i, "出伤")
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
        --print(i, "timeout")
    end,

    events =
    {
        EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        inst.components.combat:SetTarget(nil)
        if inst.sg:HasStateTag("abouttoattack") then
            inst.components.combat:CancelAttack()
        end
        --print(i, "exit")
    end,
}

local chargeattack_client = State{
    name = "chargeattack",
    tags = { "chargeattack", "attack", "notalking", "abouttoattack" },

    onenter = function(inst)
        local buffaction = inst:GetBufferedAction()
        if inst.replica.combat ~= nil then
            if inst.replica.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            inst.replica.combat:StartAttack()
        end
        if inst.sg.laststate == inst.sg.currentstate then
            inst.sg.statemem.chained = true
        end
        inst.components.locomotor:Stop()

        inst.AnimState:PlayAnimation("spearjab")

        if buffaction ~= nil then
            inst:PerformPreviewBufferedAction()

            if buffaction.target ~= nil and buffaction.target:IsValid() then
                inst:FacePoint(buffaction.target:GetPosition())
                inst.sg.statemem.attacktarget = buffaction.target
                inst.sg.statemem.retarget = buffaction.target
            end
        end

        inst.sg:SetTimeout(21 * FRAMES)
    end,

    timeline =
    {
        TimeEvent(7 * FRAMES, function(inst)   --这里出伤，但是要提前，不然有些伤害会卡掉
            inst:ClearBufferedAction()
            inst.sg:RemoveStateTag("abouttoattack")
        end),
    },

    ontimeout = function(inst)
        inst.sg:RemoveStateTag("attack")
        inst.sg:AddStateTag("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)
        if inst.sg:HasStateTag("abouttoattack") and inst.replica.combat ~= nil then
            inst.replica.combat:CancelAttack()
        end
    end,
}

AddStategraphState("SGwilson", chargeattack)
AddStategraphState("SGwilson_client", chargeattack_client)

local function SGWilsonPostInit(sg)
    sg.states["chargeattack"] = chargeattack
end

local function SGWilsonClientPostInit(sg)
    sg.states["chargeattack"] = chargeattack_client
end

AddStategraphPostInit("wilson", SGWilsonPostInit)
AddStategraphPostInit("wilson_client", SGWilsonClientPostInit)