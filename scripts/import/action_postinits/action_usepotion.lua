local USEPOTION = GLOBAL.Action({ priority= 2 })
USEPOTION.str = STRINGS.GENSHIN_ACTION_USEPOTION
USEPOTION.id = "USEPOTION"
USEPOTION.fn = function(act)
    local potion = act.invobject
	local doer = act.doer
    if potion and doer then
	    potion:onuse(doer)
        if potion.components.stackable then
            potion.components.stackable:Get(1):Remove()
        else
            potion:Remove()
        end
		return true
	end	
end
AddAction(USEPOTION)


AddComponentAction("INVENTORY", "inventoryitem", function(inst, doer, actions)
    if inst:HasTag("genshin_potions") then
	    table.insert(actions, ACTIONS.USEPOTION)
    end
end)


local usepotion_handler = ActionHandler(ACTIONS.USEPOTION, "domediumaction")
AddStategraphActionHandler("wilson", usepotion_handler)
AddStategraphActionHandler("wilson_client", usepotion_handler)