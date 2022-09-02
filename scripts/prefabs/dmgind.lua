local function SetNumberSign(inst)
	inst.sign = inst.isheal and 1 or -1
end

local function CreateDamageIndicator(inst, data)
    SetNumberSign(inst)
	local amount = inst.sign * (inst.indicator or 0)
	local color
	local text
	local isnumber
	local size
	local screenpos_x, screenpos_y = TheSim:GetScreenPos(inst.Transform:GetWorldPosition())

	if inst.reaction_type == 0 then
	    local element_type = inst.element_type
	    if amount < 0 then
		    --color = TUNING.HEALTH_LOSE_COLOR
		    if (element_type == 1) then--火元素伤害
		        color = TUNING.PYRO_COLOR
		    elseif (element_type == 2) then--冰元素伤害
		        color = TUNING.CRYO_COLOR
		    elseif (element_type == 3) then--水元素伤害
		        color = TUNING.HYDRO_COLOR
		    elseif (element_type == 4) then--雷元素伤害
		        color = TUNING.ELECTRO_COLOR
		    elseif (element_type == 5) then--风元素伤害
		        color = TUNING.ANEMO_COLOR
		    elseif (element_type == 6) then--岩元素伤害
		        color = TUNING.GEO_COLOR
		    elseif (element_type == 7) then--草元素伤害
		        color = TUNING.DENDRO2_COLOR
		    else--if (element_type == 8) --物理伤害
		        color = TUNING.PHYSICAL_COLOR
		    end
	    else
		    color = TUNING.HEALTH_GAIN_COLOR
	    end
    
	    text = string.format("%d", math.abs(amount))
		isnumber = true

	else
		if inst.reaction_type == -1 then
			color = TUNING.IMMUNE_COLOR
			text = TUNING.IMMUNED_TEXT
	    elseif inst.reaction_type == 1 then
		    color = TUNING.ELECTROCHARGED_COLOR
			text = TUNING.ELECTROCHARGED_TEXT
		elseif inst.reaction_type == 2 then
		    color = TUNING.OVERLOAD_COLOR
			text = TUNING.OVERLOAD_TEXT
		elseif inst.reaction_type == 3 then
		    color = TUNING.SUPERCONDUCT_COLOR
			text = TUNING.SUPERCONDUCT_TEXT
		elseif inst.reaction_type == 4 then
		    color = TUNING.VAPORIZE_COLOR
			text = TUNING.VAPORIZE_TEXT
		elseif inst.reaction_type == 5 then
		    color = TUNING.MELT_COLOR
			text = TUNING.MELT_TEXT
		elseif inst.reaction_type == 6 then
		    color = TUNING.FROZEN_COLOR
			text = TUNING.FROZEN_TEXT
		elseif inst.reaction_type == 7 then
		    color = TUNING.SWIRL_COLOR
			text = TUNING.SWIRL_TEXT
		elseif inst.reaction_type == 8 then
		    color = TUNING.CRYSTALIZE_COLOR
			text = TUNING.CRYSTALIZE_TEXT
		elseif inst.reaction_type == 9 then
		    color = TUNING.BURNING_COLOR
			text = TUNING.BURNING_TEXT
		elseif inst.reaction_type == 10 then
		    color = TUNING.BLOOM_COLOR
			text = TUNING.BLOOM_TEXT
		elseif inst.reaction_type == 11 then
		    color = TUNING.QUICKEN_COLOR
			text = TUNING.QUICKEN_TEXT
		elseif inst.reaction_type == 12 then
		    color = TUNING.AGGRAVATE_COLOR
			text = TUNING.AGGRAVATE_TEXT
		elseif inst.reaction_type == 13 then
		    color = TUNING.SPREAD_COLOR
			text = TUNING.SPREAD_TEXT
		elseif inst.reaction_type == 14 then
		    color = TUNING.BURGEON_COLOR
			text = TUNING.BURGEON_TEXT
		elseif inst.reaction_type == 15 then
		    color = TUNING.HYPERBLOOM_COLOR
			text = TUNING.HYPERBLOOM_TEXT
		else
		    color = TUNING.PHYSICAL_COLOR
		end
		isnumber = false
    end

	local critbig = 1
		if inst.iscrit == true then
		    critbig = 1.4
		end
	size = inst.reaction_type == 0 and TUNING.LABEL_NUMBER_SIZE * critbig or TUNING.LABEL_FONT_SIZE

	local data = {text = text, color = color, size = size, screenpos = {x = screenpos_x, y = screenpos_y}, isnumber = isnumber}
    local userids = {}
	for i, player in ipairs(AllPlayers) do
		table.insert(userids, player.userid)
	end
	TheWorld:PushEvent("UICreateDMGNumber", data)
	local x,y,z = inst.Transform:GetWorldPosition()
	SendModRPCToClient(GetClientModRPC("GenshinCore", "DMGnumberUpdate"), userids, text, color.r, color.g, color.b, size, x, y, z, isnumber)

	--[[inst:StartThread(function()
		local label = inst.Label

		local t = 0
		local t_max = TUNING.LABEL_TIME
		local dt = TUNING.LABEL_TIME_DELTA

		local y = TUNING.LABEL_Y_START + (math.random() - 0.5) * 2
		local side = (math.random() - 0.5) * 3

		local critbig = 1
		if inst.iscrit:value() == true then
		    critbig = 1.3
		end
		size = inst._reaction_type:value() == 0 and TUNING.LABEL_NUMBER_SIZE * critbig or TUNING.LABEL_FONT_SIZE

		while inst:IsValid() and t < t_max do
		    local dy = 12 * math.pow(t - t_max/2, 2)
			local scale = t < t_max/3 and (1/3 + 2 * t/t_max) or (t < t_max/2 and 1 or 1.2 - 0.4 * (t/t_max))
			local alpha = 1 - 3 * math.pow(t - dt/2, 2)

			y = y + dy
			
			label:SetFontSize(size * scale)
			
			local headingtarget = 45 % 180
			if headingtarget == 0 then
				label:SetWorldOffset(0, y, side)  		-- from 3d plane x = 0
			elseif headingtarget == 45 then
				label:SetWorldOffset(side, y, -side)	-- from 3d plane x + z = 0
			elseif headingtarget == 90 then
				label:SetWorldOffset(side, y, 0)		-- from 3d plane z = 0
			elseif headingtarget == 135 then
				label:SetWorldOffset(side, y, side)		-- from 3d plane z - x = 0
			end

			t = t + dt
			Sleep(dt)
		end

		if TheWorld.ismastersim then
			inst:Remove()
		end
	end)]]
	inst:Remove()
end


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()

	inst.sign = -1
	inst.isheal = false
	inst.indicator = 0
	inst.iscrit = false
	inst.element_type = 0
	inst.reaction_type = 0
	
	inst:AddTag("NOCLICK")

    --inst:AddComponent("dmgnumber")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.CreateDamageIndicator = CreateDamageIndicator

	inst.persists = false
	return inst
end

return Prefab("dmgind", fn)
