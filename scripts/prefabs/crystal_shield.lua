local assets =
{
    Asset("ANIM", "anim/crystal_shield.zip"),
}

local prefabs =
{
    "forcefieldfx",
}

local anims = 
{
	"pyro",
	"cryo",
	"hydro",
	"electro",
}

local colors = 
{
	{
	    r = 0.8*255/255,
	    g = 0.8*108/255,
	    b = 0.8*30/255
	},
	{
	    r = 0.8*96/255,
	    g = 0.8*255/255,
	    b = 0.8*255/255
	},
	{
	    r = 0,
	    g = 0.8*192/255,
	    b = 0.8*255/255
    },
	{
	    r = 0.8*204/255,
	    g = 0.8*128/255,
	    b = 0.8*255/255
    }
}

local function GetFormerShield(target)
    local shield = nil
    if target and target.children then
	    for k,v in pairs(target.children) do
	        if k:HasTag("crystal_shield") then
		        shield = k
		    end
	    end
	end
	return shield
end

local function SetElement(inst, element)
    if element == nil or element < 1 or element > 4 then
	    return
	end
    inst.element = element
	local anim = anims[element]
	inst.AnimState:PlayAnimation(anim, true)
end

local function GenerateShield(inst, minplayer)
    inst.AnimState:PlayAnimation("null")

    inst._fx = SpawnPrefab("crystal_shieldfx")
    inst._fx.entity:SetParent(minplayer.entity)
    inst._fx.Transform:SetPosition(0, 0.2, 0)

	inst._fx.AnimState:SetMultColour(colors[inst.element].r, colors[inst.element].g, colors[inst.element].b, 1)

	inst:AddTag("noauradamage")
	inst:AddTag("companion")
	inst:AddComponent("combat")

	--不用手动继承防御力，盾在被重定向伤害之前，基础伤害由玩家的防御计算
	if inst.element == 1 then                     --对应元素增加150%抗性
        inst.components.combat.pyro_res = 2.5
	elseif inst.element == 2 then
        inst.components.combat.cryo_res = 2.5
	elseif inst.element == 3 then
        inst.components.combat.hydro_res = 2.5
	elseif inst.element == 4 then
        inst.components.combat.electro_res = 2.5
	end

	if minplayer.components.rider:IsRiding() then  --骑牛时不能对牛提供保护
	    inst:Remove()
	    return
	end

	inst.components.entitytracker:TrackEntity("owner", minplayer)

	local target = inst
	minplayer.components.combat.redirectdamagefn =
    function(inst, attacker, damage, weapon, stimuli)
        return target:IsValid()
            and not (target.components.health ~= nil and target.components.health:IsDead())
            and stimuli ~= "darkness"
            and target
            or nil
    end
	if not minplayer:HasTag("shielded") then
	    minplayer:AddTag("shielded")
	end
	minplayer:PushEvent("getcrystallizeshield", {element = inst.element})
end

local function CheckPlayer(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x, y, z, 2,{"player"}, {"playerghost"})

	if ents == nil then
	    return
	end

	local mindist = 4
	local minplayer = nil
	for k, v in pairs(ents) do
	    if inst:GetDistanceSqToInst(v) < mindist * mindist then
		    mindist = inst:GetDistanceSqToInst(v)
			minplayer = v
		end
	end

	if minplayer == nil then
	    return
	end

	local formershield = GetFormerShield(minplayer)
	if formershield ~= nil then
	    formershield:Remove()
	end
	--先清除上一护盾
	minplayer:AddChild(inst)
	inst.checktask:Cancel()
	if inst.components.timer:TimerExists("disappear") then
	    inst.components.timer:SetTimeLeft("disappear", 15)
	end
	GenerateShield(inst, minplayer)
end

local function OnTimerDone(inst)
    inst:Remove()
end

local function OnRemove(inst)
    local owner = inst.components.entitytracker:GetEntity("owner")
	if owner and owner:HasTag("shielded") then
	    owner:RemoveTag("shielded")
	end
	if inst._fx ~= nil then
	    inst._fx:kill_fx()
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

    inst.element = 8
	
	inst:AddTag("NOCLICK")
	inst:AddTag("crystal_shield")

	inst.AnimState:SetBank("crystal_shield")
	inst.AnimState:SetBuild("crystal_shield")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst.checktask = inst:DoPeriodicTask(FRAMES, function(inst) CheckPlayer(inst) end)

	inst:AddComponent("timer")
	inst.components.timer:StartTimer("disappear", 10)
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst:AddComponent("health")

	inst:AddComponent("entitytracker")

	inst.SetElement = SetElement

	inst:ListenForEvent("onremove", OnRemove)

	return inst
end

return Prefab("crystal_shield", fn, assets, prefabs)