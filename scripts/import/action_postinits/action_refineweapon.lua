local REFINEWEAPON = GLOBAL.Action({ priority= 2 })
REFINEWEAPON.str = STRINGS.GENSHIN_ACTION_REFINEWEAPON
REFINEWEAPON.id = "REFINEWEAPON"
REFINEWEAPON.fn = function(act)
    local weapon = act.target
    if act.invobject.components.container then
        act.invobject.components.container:DropEverything()
    end
    local ingredient = act.doer.components.inventory:RemoveItem(act.invobject)
    if ingredient.components.refineable then
        local level = ingredient.components.refineable:GetCurrentLevel()
        weapon.components.refineable:Refine(level)
    else
        weapon.components.refineable:Refine(1)
    end
    ingredient:Remove()
    return true
end
AddAction(REFINEWEAPON)


AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions)
    local refineable = TheWorld.ismastersim and target.components.refineable or target.replica.refineable
    if refineable and refineable:GetIngredient() == inst.prefab then
        table.insert(actions, ACTIONS.REFINEWEAPON)
    end
end)


local refineweapon_handler = ActionHandler(ACTIONS.REFINEWEAPON, "doshortaction")
AddStategraphActionHandler("wilson", refineweapon_handler)
AddStategraphActionHandler("wilson_client", refineweapon_handler)