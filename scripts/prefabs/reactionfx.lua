local assets =
{
    Asset("ANIM", "anim/overload_fx.zip"),
    Asset("ANIM", "anim/superconduct_fx.zip"),
    Asset("ANIM", "anim/electrocharged_fx.zip"),
    Asset("ANIM", "anim/swirl_fx.zip"),
    Asset("ANIM", "anim/crystallize_fx.zip"),
    --Asset("ANIM", "anim/vaporize_fx.zip"),
    --和融化的特效一样的
}

----------------------------------------------------------------------

local function StartChangingSwirlColor(inst)
    local finalcolor = TUNING.ANEMO_COLOR
    if inst.element_swirled == 1 then
        finalcolor = TUNING.PYRO_COLOR
    elseif inst.element_swirled == 2 then
        finalcolor = TUNING.CRYO_COLOR
    elseif inst.element_swirled == 3 then
        finalcolor = TUNING.HYDRO_COLOR
    elseif inst.element_swirled == 4 then
        finalcolor = TUNING.ELECTRO_COLOR
    end
    --print(finalcolor.r, finalcolor.g, finalcolor.b)
    inst.components.colourtweener:StartTween({finalcolor.r, finalcolor.g, finalcolor.b, 0.8}, 16 * FRAMES)
end

local function StartChangingCrystallizeColor(inst)
    local finalcolor = TUNING.GEO_COLOR
    if inst.element_crystallized == 1 then
        finalcolor = TUNING.PYRO_COLOR
    elseif inst.element_crystallized == 2 then
        finalcolor = TUNING.CRYO_COLOR
    elseif inst.element_crystallized == 3 then
        finalcolor = TUNING.HYDRO_COLOR
    elseif inst.element_crystallized == 4 then
        finalcolor = TUNING.ELECTRO_COLOR
    end
    --print(finalcolor.r, finalcolor.g, finalcolor.b)
    inst.components.colourtweener:StartTween({finalcolor.r, finalcolor.g, finalcolor.b, 0.8}, 16 * FRAMES)
end

----------------------------------------------------------------------

local function fnoverload()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("overload_fx")
    inst.AnimState:SetBuild("overload_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetMultColour(253/255, 98/255, 63/255, 0.7)
    inst.AnimState:SetDeltaTimeMultiplier(0.75)

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnsuperconduct()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1, 1, 1)

    inst.AnimState:SetBank("superconduct_fx")
    inst.AnimState:SetBuild("superconduct_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetMultColour(1, 1, 1, 0.25)
    inst.AnimState:SetDeltaTimeMultiplier(0.75)

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnelectrocharged()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.4, 1, 1.2)

    inst.AnimState:SetBank("electrocharged_fx")
    inst.AnimState:SetBuild("electrocharged_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetMultColour(187/255, 117/255, 233/255, 0.9)
    inst.AnimState:SetDeltaTimeMultiplier(0.6)
    --inst.AnimState:

    inst.entity:SetPristine()

    --inst:ListenForEvent("animover", inst.Remove)
    inst:DoTaskInTime(1, inst.Remove)

    return inst
end

local function fnswirl()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.2, 1.2, 1.2)

    inst.AnimState:SetBank("swirl_fx")
    inst.AnimState:SetBuild("swirl_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetDeltaTimeMultiplier(0.75)
    inst.AnimState:SetMultColour(TUNING.ANEMO_COLOR.r, TUNING.ANEMO_COLOR.g, TUNING.ANEMO_COLOR.b, 0.8)

    inst.element_swirled = 0

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colourtweener")

    inst.StartChangingSwirlColor = StartChangingSwirlColor
    inst:DoTaskInTime(FRAMES, inst.StartChangingSwirlColor)

    --inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fncrystallize()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.AnimState:SetBank("crystallize_fx")
    inst.AnimState:SetBuild("crystallize_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetDeltaTimeMultiplier(0.75)
    inst.AnimState:SetMultColour(TUNING.GEO_COLOR.r, TUNING.GEO_COLOR.g, TUNING.GEO_COLOR.b, 0.8)

    inst.element_crystallized = 0

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("colourtweener")

    inst.StartChangingCrystallizeColor = StartChangingCrystallizeColor
    inst:DoTaskInTime(FRAMES, inst.StartChangingCrystallizeColor)

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnvaporize()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(1, 1, 1)

    inst.AnimState:SetBank("vaporize_fx")
    inst.AnimState:SetBuild("vaporize_fx")
    inst.AnimState:PlayAnimation("idle")
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end


return Prefab("overload_fx", fnoverload, assets),
    Prefab("superconduct_fx", fnsuperconduct, assets),
    Prefab("electrocharged_fx", fnelectrocharged, assets),
    Prefab("swirl_fx", fnswirl, assets),
    Prefab("crystallize_fx", fncrystallize, assets)--,
    --Prefab("vaporize_fx", fnvaporize, assets),