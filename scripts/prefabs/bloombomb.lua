local function LocalIndicator(inst, reactiontype)
    if not TUNING.DMGIND_ENABLE then
        return
    end
    
    local CDI = SpawnPrefab("dmgind")
    CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
    CDI.isheal = false
    CDI.indicator = 0
    CDI.element_type = 0
    CDI.reaction_type = reactiontype
    if CDI.CreateDamageIndicator ~= nil then
        CDI:CreateDamageIndicator()
    end
end

local function GetTimeRemained(inst)
    local time = 0
    --land, grow1, grow2, explode_pre
    if inst.AnimState:IsCurrentAnimation("land") then
        time = inst.AnimState:GetCurrentAnimationTime()
    elseif inst.AnimState:IsCurrentAnimation("grow1") then
        time = inst.AnimState:GetCurrentAnimationTime() + 10
    elseif inst.AnimState:IsCurrentAnimation("grow2") then
        time = inst.AnimState:GetCurrentAnimationTime() + 20
    elseif inst.AnimState:IsCurrentAnimation("explode_pre") then
        time = inst.AnimState:GetCurrentAnimationTime() + 30
    end
    return time
end

local function Explode(inst, isburgeon)
    inst._growtask = nil
    inst:AddTag("isexploding")
    
    if isburgeon then
        inst.Transform:SetScale(1.6, 1.6, 1.6)
        inst.AnimState:SetMultColour(1, 0.3, 0.1, 1)
    else
        inst.Transform:SetScale(1, 1, 1)
        inst.AnimState:SetMultColour(1, 1, 1, 1)
    end
    inst.AnimState:SetDeltaTimeMultiplier(1)

    inst.AnimState:PlayAnimation("explode")
    inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_explode")
    inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), inst.Remove)
    inst.persists = false

    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, isburgeon and 4.5 or 3, {"_combat"}, inst.exclude_tag)
    for k, v in pairs (ents) do
        if v ~= inst.attacker then
            v.components.combat:GetAttacked(inst.attacker, inst.basedmg * (1 + inst.mastery_rate) * inst.bonus, nil, 7, 0, "elementreaction")  --草伤
        end
    end
end

local function TraceFire(inst)
    inst:AddTag("istracing")

    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 10, {"_combat"}, inst.exclude_tag)
    local target = nil
    for k, v in pairs (ents) do
        if v ~= inst.attacker then
            target = v
            break
        end
    end

    local finaldmg = inst.basedmg * (1 + inst.mastery_rate) * inst.bonus
    local tracebomb = SpawnPrefab("bloomtracebomb")
    tracebomb.Transform:SetPosition(x, y, z)
    if target ~= nil then
        tracebomb:SetTraceTarget(inst.attacker, target, finaldmg)
    else
        tracebomb:Remove()
    end

    inst:Remove()
end

local function Burgeon(inst, attacker)
    if inst:HasTag("isexploding") or inst:HasTag("istracing") or attacker == nil then
        return
    end

    inst.basedmg = inst.basedmg * 1.5
    inst.mastery_rate = attacker.components.combat:CalcMasteryAddition(4)
    inst.bonus = attacker.components.elementreactor and (attacker.components.elementreactor.attack_burgeon_bonus * attacker.components.elementreactor.attack_burgeon_bonus_modifier:Get()) or 1
    attacker:PushEvent("burgeontarget")
    LocalIndicator(inst, 14)
    Explode(inst, true)
end

local function Hyperbloom(inst, attacker)
    if inst:HasTag("isexploding") or inst:HasTag("istracing") or attacker == nil then
        return
    end

    inst.basedmg = inst.basedmg * 1.5
    inst.mastery_rate = attacker.components.combat:CalcMasteryAddition(4)
    inst.bonus = attacker.components.elementreactor and (attacker.components.elementreactor.attack_hyperbloom_bonus * attacker.components.elementreactor.attack_hyperbloom_bonus_modifier:Get()) or 1
    attacker:PushEvent("hyperbloomtarget")
    LocalIndicator(inst, 15)
    TraceFire(inst)
end

local function affectedby(inst, attacker, target, element)
    if inst:HasTag("isexploding") or inst:HasTag("istracing") or attacker == nil then
        return
    end

    for k, v in pairs(inst.attacker_tag) do
        if not attacker:HasTag(v) then
            return
        end
    end

    local x1, y1, z1 = target.Transform:GetWorldPosition()
    local x2, y2, z2 = inst.Transform:GetWorldPosition()
    local dx = x1 - x2
    local dz = z1 - z2
    if (dx * dx + dz * dz) > 6 then
        return
    end

    if element == 1 then
        Burgeon(inst, attacker)
    elseif element == 4 then
        Hyperbloom(inst, attacker)
    end
end

local function Grow(inst, level)
    if level > 2 then
        inst.AnimState:PlayAnimation("explode_pre")
        local len = inst.AnimState:GetCurrentAnimationLength()
        inst._growtask = inst:DoTaskInTime(1.5 * GetRandomMinMax(len * .5, len), Explode)
    else
        inst.AnimState:PlayAnimation("grow"..tostring(level))
        inst._growtask = inst:DoTaskInTime(1.5 * inst.AnimState:GetCurrentAnimationLength(), Grow, level + 1)
    end
end

local function SetAttackMode(inst, attacker, attacker_tag, exclude_tag)
    inst.attacker = attacker
    inst.attacker_tag = attacker_tag
    inst.exclude_tag = exclude_tag
end

local function SetBaseDMG(inst, basedmg, mastery_rate, bonus)
    inst.basedmg = basedmg
    inst.mastery_rate = mastery_rate
    inst.bonus = bonus
end

local function MakeBomb(name)
    local assets =
    {
        Asset("ANIM", "anim/mushroombomb.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddLight()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetFourFaced()
        inst.Transform:SetScale(0.6, 0.6, 0.6)

        inst.AnimState:SetBank("bloombomb")
        inst.AnimState:SetBuild("bloombomb")
        inst.AnimState:PlayAnimation("land")
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetMultColour(0.7, 1, 0.7, 1)
        inst.AnimState:SetDeltaTimeMultiplier(0.667)

        inst:AddTag("explosive")
        inst:AddTag("bloombomb")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst:AddComponent("entitytracker")

        inst._growtask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() * 1.5, Grow, 1)

        SetAttackMode(inst, nil, {"_combat", "player"}, {"FX", "NOCLICK", "DECOR", "INLIMBO", "noauradamage"})
        SetBaseDMG(inst, 0, 0, 0)

        inst.SetAttackMode = SetAttackMode
        inst.SetBaseDMG = SetBaseDMG
        inst.Burgeon = Burgeon
        inst.Hyperbloom = Hyperbloom
        inst.GetTimeRemained = GetTimeRemained

        inst:ListenForEvent("entity_damagecalculated", function(world, data)
            affectedby(inst, data.attacker, data.target, data.stimuli)
        end, TheWorld)

        return inst
    end

    return Prefab(name, fn, assets)
end

local function MakeProjectile(name, bombname)
    local assets =
    {
        Asset("ANIM", "anim/bloombomb.zip"),
    }

    local prefabs =
    {
        bombname,
    }

    local function OnProjectileHit(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        inst:Remove()
        local bomb = SpawnPrefab(bombname)
        bomb.Transform:SetPosition(x, y, z)
        bomb:SetAttackMode(inst.attacker, inst.attacker_tag, inst.exclude_tag)
        bomb:SetBaseDMG(inst.basedmg, inst.mastery_rate, inst.bonus)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.entity:AddPhysics()
        inst.Physics:SetMass(1)
        inst.Physics:SetFriction(0)
        inst.Physics:SetDamping(0)
        inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:SetCapsule(.2, .2)

        inst.AnimState:SetBank("bloombomb")
        inst.AnimState:SetBuild("bloombomb")
        inst.AnimState:PlayAnimation("projectile_loop", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("locomotor")

        inst:AddComponent("complexprojectile")
        inst.components.complexprojectile:SetHorizontalSpeed(15)
        inst.components.complexprojectile:SetGravity(-50)
        inst.components.complexprojectile:SetLaunchOffset(Vector3(0, 2.5, 0))
        inst.components.complexprojectile:SetOnHit(OnProjectileHit)

        inst:AddComponent("entitytracker")

        inst.persists = false

        inst.SetAttackMode = SetAttackMode
        inst.SetBaseDMG = SetBaseDMG

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

local function MakeTraceBomb(name)
    local assets =
    {
        Asset("ANIM", "anim/bloombomb.zip"),
    }

    local function OnHitTarget(inst)
        if inst.target.components.combat then
            inst.target.components.combat:GetAttacked(inst.attacker, inst.finaldmg, nil, 7, 0, "elementreaction")  --草伤，但是没有元素附着
        end
        inst:Remove()
    end

    local function UpdatePosition(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x + inst.speed.x * FRAMES, y + inst.speed.y * FRAMES, z + inst.speed.z * FRAMES)

        if inst.target == nil or (inst.target.components.health and inst.target.components.health:IsDead()) then
            inst:Remove()
            return
        end

        local x1, y1, z1 = inst.target.Transform:GetWorldPosition()
        if x1 == nil or z1 == nil then
            inst:Remove()
            return
        end
        local dx = x - x1
        local dz = z - z1
        if (dx * dx + dz * dz) < 1.2 then
            OnHitTarget(inst)
            return
        end

        inst.speed = inst.speed + inst.accelration * FRAMES
        if inst.speed:Length() > 25 then
            inst.speed = (inst.speed:GetNormalized()) * 25
        end
    end

    local function SetTraceTarget(inst, attacker, target, finaldmg)
        inst.attacker = attacker
        inst.target = target
        inst.finaldmg = finaldmg

        local angle = math.random() * 360
        local range = math.random() * 4
        local yspeed = math.random() * 3 + 9
        inst.speed = Vector3(math.cos(angle) * range, yspeed, math.sin(angle) * range)
        inst.accelration = Vector3(0, 0, 0)
        inst:DoTaskInTime(0.2, function(inst)
            if inst.target == nil or (inst.target.components.health and inst.target.components.health:IsDead()) then
                inst:Remove()
                return
            end
            local x, y, z = inst.Transform:GetWorldPosition()
            local x1, y1, z1 = inst.target.Transform:GetWorldPosition()
            if x1 == nil or z1 == nil then
                inst:Remove()
                return
            end
            local vec = Vector3(x1 - x, y1 - y, z1 - z)
            inst.accelration = (vec:GetNormalized()) * 50 
        end)
        inst:DoPeriodicTask(FRAMES, UpdatePosition)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.Transform:SetScale(0.6, 0.6, 0.6)

        inst.AnimState:SetBank("bloombomb")
        inst.AnimState:SetBuild("bloombomb")
        inst.AnimState:PlayAnimation("projectile_loop", true)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        inst.AnimState:SetMultColour(0.5, 1, 0.5, 0.7)

        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        inst.SetTraceTarget = SetTraceTarget

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return MakeBomb("bloombomb"),
    MakeProjectile("bloombomb_projectile", "bloombomb"),
    MakeTraceBomb("bloomtracebomb")
