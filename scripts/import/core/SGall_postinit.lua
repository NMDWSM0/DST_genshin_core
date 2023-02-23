local function allsgfn(sg)
    if sg == nil or sg.events == nil or sg.events.attacked == nil then
	    return
    end

	local old_attackedfn = sg.events.attacked.fn
	sg.events.attacked.fn = function(inst, data)
	    if inst:HasTag("player") and (inst:HasTag("shielded") or inst:HasTag("nohitanim")) then
		    return
		end
		if not (inst.components.freezable and inst.components.freezable:IsFrozen()) then
		    if data ~= nil then
			    old_attackedfn(inst, data)
			else
			    old_attackedfn(inst)
			end
		end
	end
end

--nil在此处，实际上是指，全部sg生效
AddStategraphPostInit("nil", allsgfn)

AddGlobalClassPostConstruct("stategraph", "StateGraphInstance", function (self)
    local old_GoToState = self.GoToState
    function self:GoToState(...)
        if self.tags and self.tags["no_gotootherstate"] then
            print("Try to goto another state while in an unchanging state")
            return
        end
        old_GoToState(self, ...)
    end
end)