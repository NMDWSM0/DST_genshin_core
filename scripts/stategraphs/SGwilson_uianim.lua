
local states =
{
    State{
        name = "idle",
        tags = { "idle" },

        onenter = function (inst, pushanim)
            if pushanim then
                inst.AnimState:PushAnimation("idle_loop", true)
            else
                inst.AnimState:PlayAnimation("idle_loop", true)
            end
        end,
    },

    State{
        name = "equip",
        tags = { "equip" },

        onenter = function (inst)
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
            inst.AnimState:PlayAnimation("item_out")
        end,

        -- timeline =
        -- {
        --     TimeEvent(4 * FRAMES, function (inst)
                
        --     end),
        -- },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function (inst)
            inst.AnimState:Show("ARM_carry")
            inst.AnimState:Hide("ARM_normal")
        end
    },

    State{
        name = "unequip",
        tags = { "unequip" },

        onenter = function (inst)
            inst.AnimState:Show("ARM_normal")
            inst.AnimState:Hide("ARM_carry")
            inst.AnimState:PlayAnimation("item_in")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function (inst)
            inst.AnimState:Show("ARM_normal")
            inst.AnimState:Hide("ARM_carry")
        end
    },

    State{
        name = "arti_enter",
        tags = { "arti" },

        onenter = function (inst)
            inst.AnimState:PlayAnimation("action_arti_enter")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("arti_idle")
                end
            end),
        },
    },

    State{
        name = "arti_idle",
        tags = { "arti", "idle" },

        onenter = function (inst, pushanim)
            if pushanim then
                inst.AnimState:PushAnimation("action_arti_idle", true)
            else
                inst.AnimState:PlayAnimation("action_arti_idle", true)
            end
        end,
    },

    State{
        name = "arti_exit",
        tags = { "arti" },

        onenter = function (inst)
            inst.AnimState:PlayAnimation("action_arti_exit")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },
    
}

return StateGraph("wilson_uianim", states, {}, "idle")