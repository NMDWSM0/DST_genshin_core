local assets =
{
    Asset("ANIM", "anim/element_spearfx_pyro.zip"),
    Asset("ANIM", "anim/element_spearfx_cryo.zip"),
    Asset("ANIM", "anim/element_spearfx_hydro.zip"),
    Asset("ANIM", "anim/element_spearfx_electro.zip"),
    Asset("ANIM", "anim/element_spearfx_anemo.zip"),
    Asset("ANIM", "anim/element_spearfx_geo.zip"),
    Asset("ANIM", "anim/element_spearfx_dendro.zip"),
}

local function fnpyro()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_pyro")
    inst.AnimState:SetBuild("element_spearfx_pyro")
    inst.AnimState:PlayAnimation("pyro")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fncryo()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_cryo")
    inst.AnimState:SetBuild("element_spearfx_cryo")
    inst.AnimState:PlayAnimation("cryo")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnhydro()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_hydro")
    inst.AnimState:SetBuild("element_spearfx_hydro")
    inst.AnimState:PlayAnimation("hydro")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnelectro()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_electro")
    inst.AnimState:SetBuild("element_spearfx_electro")
    inst.AnimState:PlayAnimation("electro")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fnanemo()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_anemo")
    inst.AnimState:SetBuild("element_spearfx_anemo")
    inst.AnimState:PlayAnimation("anemo")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fngeo()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_geo")
    inst.AnimState:SetBuild("element_spearfx_geo")
    inst.AnimState:PlayAnimation("geo")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

local function fndendro()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(3, 3, 3)

    inst.AnimState:SetBank("element_spearfx_dendro")
    inst.AnimState:SetBuild("element_spearfx_dendro")
    inst.AnimState:PlayAnimation("dendro")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    inst:ListenForEvent("animover", inst.Remove)

    return inst
end

return Prefab("element_spearfx_pyro", fnpyro, assets),
    Prefab("element_spearfx_cryo", fncryo, assets),
    Prefab("element_spearfx_hydro", fnhydro, assets),
    Prefab("element_spearfx_electro", fnelectro, assets),
    Prefab("element_spearfx_anemo", fnanemo, assets),
    Prefab("element_spearfx_geo", fngeo, assets),
    Prefab("element_spearfx_dendro", fndendro, assets)