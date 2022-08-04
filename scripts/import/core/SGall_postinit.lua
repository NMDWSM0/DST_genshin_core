local function allsgfn(sg)
    if sg == nil or sg.events == nil or sg.events.attacked == nil then
	    return
    end

	local old_attackedfn = sg.events.attacked.fn
	sg.events.attacked.fn = function(inst, data)
	    if inst:HasTag("player") and inst:HasTag("shielded") then
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