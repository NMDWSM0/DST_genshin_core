local function calculatestatus(inst)
    if inst.components.combat == nil or inst.components.combatstatus == nil or inst.components.inventory == nil then
	    return
	end

	local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local weapondmg = weapon ~= nil and weapon.components.weapon and weapon.components.weapon:GetDamage(inst, inst) or 0
	if weapon and weapon:HasTag("subtextweapon") then
		weapondmg = weapondmg - inst.components.combat.defaultdamage
	end
	--武器
    
    local base_hp = TUNING.ARTIFACTS_ON_HEALTH and inst.components.health.base_health or inst.components.health.maxhealth
	--基础生命值
	local hp = inst.components.health.maxhealth
    --生命值
	local base_atk = weapon ~= nil and weapon.components.weapon and weapon.components.weapon:GetDamage(inst, inst) or inst.components.combat.defaultdamage
	--基础攻击力，人物白字加武器白字  (官方的武器是直接覆盖掉人物白字的，如果按照原神的设定，武器伤害请使用函数返回人物白字加武器白字)
	local atk = base_atk * inst.components.combat.external_atk_multipliers:Get() + (inst.components.combat.atkbonus ~= nil and inst.components.combat.atkbonus or 0) + inst.components.combat.external_atkbonus_multipliers:Get()
	--攻击力 = 基础攻击力 * 攻击力加成 + 小公鸡
    local base_def = inst.components.combat.defense
	--基础防御力
	local def = base_def * inst.components.combat.external_defense_multipliers:Get() + inst.components.combat.defensebonus
	--防御力 = 基础防御力 * 防御力加成 + 小防御
	local element_mastery = inst.components.combat.element_mastery + inst.components.combat.external_element_mastery_multipliers:Get()
	--元素精通

	local crit_rate = inst.components.combat.critical_rate + inst.components.combat.external_critical_rate_multipliers:Get()
	--暴击率，只显示通用暴击率
	local crit_dmg = inst.components.combat.critical_damage + inst.components.combat.external_critical_damage_multipliers:Get()
	--暴击伤害，只显示通用暴击伤害
	
	--元素充能
	local recharge = 0
    if inst.components.energyrecharge ~= nil then
		recharge = inst.components.energyrecharge:GetEnergyRecharge()
	end

	--冷却缩减，护盾强效，无

	--元素属性
	local list = 
	{
		inst.components.combat.pyro + inst.components.combat.external_pyro_multipliers:Get() - 1, 
		inst.components.combat.cryo + inst.components.combat.external_cryo_multipliers:Get() - 1, 
        inst.components.combat.hydro + inst.components.combat.external_hydro_multipliers:Get() - 1, 
		inst.components.combat.electro + inst.components.combat.external_electro_multipliers:Get() - 1, 
		inst.components.combat.anemo + inst.components.combat.external_anemo_multipliers:Get() - 1, 
		inst.components.combat.geo + inst.components.combat.external_geo_multipliers:Get() - 1, 
		inst.components.combat.dendro + inst.components.combat.external_dendro_multipliers:Get() - 1, 
		inst.components.combat.physical + inst.components.combat.external_physical_multipliers:Get() - 1, 
	}
	local list_res = 
	{
		inst.components.combat.pyro_res + inst.components.combat.external_pyro_res_multipliers:Get(), 
		inst.components.combat.cryo_res + inst.components.combat.external_cryo_res_multipliers:Get(), 
		inst.components.combat.hydro_res + inst.components.combat.external_hydro_res_multipliers:Get(), 
		inst.components.combat.electro_res + inst.components.combat.external_electro_res_multipliers:Get(), 
		inst.components.combat.anemo_res + inst.components.combat.external_anemo_res_multipliers:Get(), 
		inst.components.combat.geo_res + inst.components.combat.external_geo_res_multipliers:Get(), 
		inst.components.combat.dendro_res + inst.components.combat.external_dendro_res_multipliers:Get(), 
		inst.components.combat.physical_res + inst.components.combat.external_physical_res_multipliers:Get(), 
	}

	local clothing = inst.components.skinner and inst.components.skinner:GetClothing() or {}

	--统一设置好，利用这个组件为桥梁，给客机传过去
	inst.components.combatstatus:Set(weapon, weapondmg, base_hp, hp, base_atk, atk, base_def, def, element_mastery, crit_rate, crit_dmg, recharge, list, list_res, clothing)
end

local function switchartifacts(inst, type, item)
    if item == nil or type == nil then
		return
	end
	inst.components.inventory:Equip(item)
end

local function removeartifacts(inst, type, item)
	if item == nil or type == nil then
		return
	end
	inst.components.inventory:GiveItem(item)
	inst.components.inventory:Unequip(EQUIPSLOTS[string.upper(type)])
end

local function lockartifacts(inst, value, item)
    if item == nil then
		return
	end
	item.components.artifacts:Lock(value)
end

local function updatehealth(inst)
	inst.components.health:SetMaxHealthWithPercent()
end

local function unlockconstellation(inst, level)
	if inst.components.constellation == nil or inst.constellation_starname == nil then
		return
	end
        local name = nil
        if type(inst.constellation_starname) == "string" then
            name = inst.constellation_starname
        elseif type(inst.constellation_starname) == "table" then
            local level = inst.components.constellation:GetActivatedLevel()
            if level >= 0 and level <= 5 then
                name = inst.constellation_starname[level + 1]
            end
        end
        if name == nil then
            return
        end
	local has, num_found = inst.components.inventory:Has(name, 1)
	if has then  --服务器端二次确认
		inst.components.inventory:ConsumeByName(inst.constellation_starname, 1)
	    inst.components.constellation:Unlock(level)
	end
end

local function upgradetalent(inst, talent_number)
	if inst.components.talents == nil or inst.talents_ingredients == nil then
		return
	end
	local previouslevel = inst.components.talents:GetBaseTalentLevel(talent_number)
	local ingredients = inst.talents_ingredients[previouslevel]
	if ingredients == nil then
		return
	end
	for i, v in ipairs(ingredients) do
        local has, num_found = inst.components.inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount)))
        if not has then --服务器端二次确认
            return
        end
        inst.components.inventory:ConsumeByName(v.type, v.amount)
    end
	inst.components.talents:UpgradeTalent(talent_number)
end

local function refineweapon(inst, weapon)
	if weapon == nil or weapon:HasTag("player") or weapon.components.refineable == nil then
		return
	end
	local ingredient = weapon.components.refineable:GetIngredient()
	local has, num_found = inst.components.inventory:Has(ingredient, 1)
	if not has then  --服务器端二次确认
		return
	end

	local all_ingredients = inst.components.inventory:FindItems(function (item)
		if item.prefab ~= ingredient then
			return false
		end
		if item.components.equippable and item.components.equippable:IsEquipped() then
			return false
		end
		return true
	end)

	local up_level = 1
	if all_ingredients[1].components.refineable == nil then --并不是可精炼的材料，这个材料应该是单独设置的
		inst.components.inventory:ConsumeByName(ingredient, 1) --如果这个物品本身是个容器呢？？这样的设置也太奇怪了
	else
		local min_refine = 2147483647
		local min_item = nil
		for k, v in pairs(all_ingredients) do
			if v.components.refineable:GetCurrentLevel() < min_refine then
				min_item = v
				min_refine = v.components.refineable:GetCurrentLevel()
			end
		end
		if TUNING.WEAPON_REFINE_PROTECTION and min_refine >= 2 then
			inst.components.talker:Say(STRINGS.WEAPON_REFINELEVEL_WARNING)
			return
		end
		if min_item.components.container then
			min_item.components.container:DropEverything()
		end
		min_item:Remove()
		up_level = min_refine
	end

	weapon.components.refineable:Refine(up_level)
end

local function refineartifacts(inst, refiner)
	if refiner == nil or refiner.components.container == nil then
		return
	end
	local number = refiner.components.container:NumItems() - 1 --去掉第一个
	local finalnumber = math.floor(number / 3)
	local proto_art = refiner.components.container:GetItemInSlot(1)
	if proto_art == nil or finalnumber == 0 then
		inst.components.talker:Say(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "材料不足" or "Insufficient Materials")
		return
	end
	local sets = proto_art.components.artifacts.sets
	local i = 1
	local consumed = 0
	while consumed < finalnumber * 3 and i <= refiner.components.container:GetNumSlots() do --1号位置是不动的
		if refiner.components.container:GetItemInSlot(i + 1) ~= nil then
			local item = refiner.components.container:RemoveItemBySlot(i + 1)
			item:Remove()
			consumed = consumed + 1
		end
		i = i + 1
	end
	local tags = {"flower", "plume", "sands", "goblet", "circlet"}
	for j = 1, finalnumber do
		local tag = tags[math.random(5)]
		refiner.components.container:GiveItem(SpawnPrefab(sets.."_"..tag))
	end
	refiner.components.container:Close(inst)
end

local function tptowaypoint(inst, x, y, z)
	local angle = math.random() * 2 * 3.1415926
	local range = 1.5
	local x_offset = math.cos(angle) * range
	local z_offset = math.sin(angle) * range
	while not TheWorld.Map:IsPassableAtPoint(x + x_offset, y, z + z_offset) do
		angle = math.random() * 2 * 3.1415926
		x_offset = math.cos(angle) * range
		z_offset = math.sin(angle) * range
	end
	inst.Transform:SetPosition(x + x_offset, y, z + z_offset)
end

-------------------------------------------------------------------------------
--Client Functions
local function updatedmgnumber(text, r, g, b, size, x, y, z, isnumber)
	local screenpos_x, screenpos_y = TheSim:GetScreenPos(x, y, z)
    local data = {text = text, color = {r = r, g = g, b = b}, size = size, screenpos = {x = screenpos_x, y = screenpos_y}, isnumber = isnumber}
	if TheNet:GetIsClient() then
	    TheWorld:PushEvent("UICreateDMGNumber", data)
	end
end

local function registerwaypoint(x, y, z, waypoint_id, custom_info)
	if not ThePlayer then
        return
    end
	if ThePlayer.registered_waypoint == nil then
		ThePlayer.registered_waypoint = {}
	end
	ThePlayer.registered_waypoint[waypoint_id] = {pos = Vector3(x, y, z), info = custom_info}
end

local function unregisterwaypoint(waypoint_id)
	if not ThePlayer then
        return
    end
	if ThePlayer.registered_waypoint == nil or ThePlayer.registered_waypoint[waypoint_id] == nil then
		return
	end
	ThePlayer.registered_waypoint[waypoint_id] = nil
end

--Server
AddModRPCHandler("combatdata", "combat", calculatestatus)
AddModRPCHandler("artifacts", "lock", lockartifacts)
AddModRPCHandler("inventory", "removeartifacts", removeartifacts)
AddModRPCHandler("inventory", "switchartifacts", switchartifacts)
AddModRPCHandler("existhealthreplica", "updatehealth", updatehealth)
AddModRPCHandler("constellation", "unlock", unlockconstellation)
AddModRPCHandler("talents", "upgrade", upgradetalent)
AddModRPCHandler("weapon", "refine", refineweapon)
AddModRPCHandler("artifacts_refiner", "dorefine", refineartifacts)
AddModRPCHandler("genshintp", "tptowaypoint", tptowaypoint)
--Client
AddClientModRPCHandler("GenshinCore", "DMGnumberUpdate", updatedmgnumber)
AddClientModRPCHandler("GenshinCore", "registerwaypoint", registerwaypoint)
AddClientModRPCHandler("GenshinCore", "unregisterwaypoint", unregisterwaypoint)
