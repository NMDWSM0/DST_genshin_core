local SourceModifierList = require("util/sourcemodifierlist")
local ExtendedModifierList = require("import/core/extendedmodifierlist")

local function tryconvert(str)
    if str == nil then
		return 8
	elseif type(str) == "number" then
		return (str >= 1 and str <= 8) and str or 8
	elseif type(str) ~= "string" then
		return 8
	end

	if str == "fire" or str:lower() == "pyro" then
		return 1
	elseif str:lower() == "cryo" then
		return 2
    elseif str:lower() == "hydro" then
		return 3
	elseif str == "electric" or str:lower() == "electro" then
		return 4
	elseif str:lower() == "anemo" then
		return 5
	elseif str:lower() == "geo" then
		return 6
	elseif str:lower() == "dendro" then
		return 7
	else
		return 8
	end
end

local function IsIgnoreCD(attacker, weapon, stimuli, ele_value, attackkey)
    --是否无元素附着cd的判断函数，这里只需要排除几个特例
	local ignorecd = false
	if attacker and attacker:HasTag("ganyu") and attackkey == "frostlake_bloom" then
	    --甘雨二段蓄力霜华矢元素附着无视cd
	    ignorecd = true
	--[[elseif
	    ]]
	end

	return ignorecd
end

--模糊匹配字符串
local function CalculateModifierFromAbstractKey(sourcemodifier, key)
    local m = sourcemodifier._base
    for source, src_params in pairs(sourcemodifier._modifiers) do
        for k, v in pairs(src_params.modifiers) do
			if string.find(k, key) ~= nil then
	            m = sourcemodifier._fn(m, v)
	        end
        end
    end
    return m
end

AddComponentPostInit("combat", function(self)

    --必看，必看
	--!!!now these have been deprecated 现在它们被废除了
	--                                          攻击种类加成、暴击率和暴击伤害的调节器，由于key兼顾了攻击种类识别的功能，即便采用模糊识别，在设置key时须按照如下规则
	--                                          1.若要设置成全种类暴击加成，key中须包含"all"字符串
	--                                          2.若要设置成特定种类暴击加成，key中须包含与攻击种类相同的字符串，如重击--"charge"，普通攻击--"normal"，攻击类型可以自由设置
	--                                          3.不要让不同攻击种类的字符串互相以对方为子串，也不要包含all为字串，否则会造成多余计算
	--                                          4.基于上述规则，建议给key命名为：attacktype.."_xxxx"，即容易看懂又符合规则
	--                                          其他调节器无此规则，但建议按照相同模式，避免弄混
	--                                          ps：暴击调节器还在装备部分圣遗物时判断对敌人状态来追加暴击率，不过仅有圣遗物会使用到
	--                                          命名规则为"cryo_attached_xxxx"，意思是对冰元素附着的敌人暴击率/暴击伤害提升
	--                                          "frozen_xxx"，意思是对冻结的敌人暴击率/暴击伤害提升
	--you can use the regular to name your modifiers but they will not work
	--the new modifiers have "filters" which you can modifier attacktype and critical freely
	--you can goto "core/extendedmodifierlist" to have more details
	---------------------------------------------------------------------
    self.inst:AddComponent("elementreactor")
    --生命攻击基础属性已有，CD减少暂时未加
	self.damagebonus = 0
	--自己定义攻击力调节器，改为加算
	self.external_atk_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.atkbonus = 0
    --暴击爆伤
    self.critical_rate = 0.05 
	self.external_critical_rate_multipliers = ExtendedModifierList(self.inst, 0, ExtendedModifierList.additive)
	self.critical_damage = 0.5
	self.external_critical_damage_multipliers = ExtendedModifierList(self.inst, 0, ExtendedModifierList.additive)
	--攻击种类伤害加成
	self.external_attacktype_multipliers = ExtendedModifierList(self.inst, 1, ExtendedModifierList.additive)
	--增伤数值，如申鹤、云堇，以及激化反应
	self.external_dmgaddnumber_multipliers = ExtendedModifierList(self.inst, 0, ExtendedModifierList.additive)
	--防御力
	self.defense = 750
	self.external_defense_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.defensebonus = 0
	--元素伤害
	self.pyro = 0
	self.external_pyro_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.cryo = 0
	self.external_cryo_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.hydro = 0
	self.external_hydro_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.electro = 0
	self.external_electro_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.anemo = 0
	self.external_anemo_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.geo = 0
	self.external_geo_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.dendro = 0
	self.external_dendro_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.physical = 0
	self.external_physical_multipliers = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	--元素伤害抗性
	self.pyro_res = 0
	self.external_pyro_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.cryo_res = 0
	self.external_cryo_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.hydro_res = 0
	self.external_hydro_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.electro_res = 0
	self.external_electro_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.anemo_res = 0
	self.external_anemo_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.geo_res = 0
	self.external_geo_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.dendro_res = 0
	self.external_dendro_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	self.physical_res = 0
	self.external_physical_res_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	--元素精通
	self.element_mastery = 0
	self.external_element_mastery_multipliers = SourceModifierList(self.inst, 0, SourceModifierList.additive)
	--伤害免疫
	self.pyro_immunity = false
	self.cryo_immunity = false
	self.hydro_immunity = false
	self.electro_immunity = false
	self.anemo_immunity = false
	self.geo_immunity = false
	self.dendro_immunity = false
	self.physical_immunity = false

	--无视元素cd函数
	self.ignorecdfn = nil
	--防御穿透函数
    self.defense_ignorefn = nil
	--伤害元素/类型函数
	self.overrideattackkeyfn = nil
	self.overridestimulifn = nil
	

    ---------------------------------------------------
    -------------- SetOverrideStimuliFn ----------------

	function self:SetIgnoreCDFn(fn)
		--自定义无视CD
	    self.ignorecdfn = fn
		--inst, weapon, atk_elements, ele_value, attackkey
    end
	
	----------------------------------------------------
	----------------------------------------------------

    ----------------------------------------------------
    -------------- SetOverrideStimuliFn ----------------

	function self:SetOverrideStimuliFn(fn)
		--自定义伤害元素，比如通过attackkey
	    self.overridestimulifn = fn
		--inst, weapon, targ, attackkey
    end
	
	----------------------------------------------------
	----------------------------------------------------

	----------------------------------------------------
    ------------- SetOverrideAttackkeyFn ---------------

	function self:SetOverrideAttackkeyFn(fn)
		--自定义attackkey，比如通过当前sg状态判断是否重击
	    self.overrideattackkeyfn = fn
		--inst, weapon, target
    end
	
	----------------------------------------------------
	----------------------------------------------------

	----------------------------------------------------
    --------------- SetDefenseIgnoreFn -----------------

	function self:SetDefenseIgnoreFn(fn)
		--自定义防御穿透（比如雷神二命）
	    self.defense_ignorefn = fn
		--inst, target, weapon, atk_elements, attackkey
    end
	
	----------------------------------------------------
	----------------------------------------------------

	----------------------------------------------------
    -------------- CalcMasteryAddition -----------------

	function self:CalcMasteryAddition(calctype)
	    --元素精通加成
		--蒸发融化 (2.78 * x) / (x + 1400) 
		--结晶 (4.44 * x) / (x + 1400)
		--蔓激化超激化 (2.5 * x) / (x + 1200)
		--聚变反应 (16 * x) / (x + 2000)
		--上述结果为r, 则伤害为(1 + r) * basedmg(对于聚变反应), 增伤数字 * (1 + r)(对于增幅翻译), 吸收量 * (1 + r)(对于结晶盾), 基础伤害 * (1 + r)(对于激化)
		--对于basedmg, 超导 : 扩散 : 感电 : 碎冰 : 超载、绽放 : 超绽放、烈绽放 = 1 : 1.2 : 2.4 : 3 : 4 : 6
		--数值设定     7.23   8.68   17.36  21.7  28.93        43.4
		--结晶盾吸收量为18.51
		--激化系列反应基础增伤数值为28.93
		local mastery = self.element_mastery + self.external_element_mastery_multipliers:Get()
		local rate = 0
		if mastery <= 0 then
			return 0
		end
		if calctype == nil then
			calctype = 4
		end
		if (type(calctype) == "string" and calctype == "amplify") or (type(calctype) == "number" and calctype == 1) then
			rate = (2.78 * mastery) / (mastery + 1400) 
		elseif (type(calctype) == "string" and calctype == "crystalize") or (type(calctype) == "number" and calctype == 2) then
			rate = (4.44 * mastery) / (mastery + 1400) 
		elseif (type(calctype) == "string" and calctype == "quicken") or (type(calctype) == "number" and calctype == 3) then
			rate = (2.5 * mastery) / (mastery + 1200) 
		else --if calctype == "crystalize" or calctype == 4 then
			rate = (16 * mastery) / (mastery + 2000) 
		end
	    
		return rate
    end
	
	----------------------------------------------------
	----------------------------------------------------
 
	
	----------------------------------------------------
    ------------------ CalcCritical --------------------

	function self:CalcCritical(attacker, target, atk_elements, atk_key)
	    if atk_key == nil then
		    atk_key = "normal"
		end
		
	    --local rate = self.critical_rate + CalculateModifierFromAbstractKey(self.external_critical_rate_multipliers, "all") + CalculateModifierFromAbstractKey(self.external_critical_rate_multipliers, atk_key) + CalculateModifierFromAbstractKey(self.external_critical_rate_multipliers, element_string) + frozen_rate
		local rate = self.critical_rate + self.external_critical_rate_multipliers:CalculateModifierFromFilter({attacker = attacker, target = target, atk_elements = atk_elements, atk_key = atk_key})
		--暴击率   = 基础暴击率         + 通用暴击率加成                                                                   + 攻击种类暴击率加成                                                                 + 元素附着暴击率加成
		--local critical = self.critical_damage + CalculateModifierFromAbstractKey(self.external_critical_damage_multipliers, "all") + CalculateModifierFromAbstractKey(self.external_critical_damage_multipliers, atk_key) + CalculateModifierFromAbstractKey(self.external_critical_damage_multipliers, element_string)
		local critical = self.critical_damage + self.external_critical_damage_multipliers:CalculateModifierFromFilter({attacker = attacker, target = target, atk_elements = atk_elements, atk_key = atk_key})
		--暴击伤害     = 基础暴伤             + 通用暴伤加成                                                                       + 攻击种类暴伤加成                                                                     + 元素附着暴击伤害加成
		--圣遗物加成方式：计算好之后同意对combat组件添加带有相应标签的调节器，不需要再单独计算圣遗物的
		--不过现在好像没有什么圣遗物能加爆伤
		return (math.random() < rate) and (critical + 1) or 1
	end
	
	----------------------------------------------------
	----------------------------------------------------


	----------------------------------------------------
    ----------------- CalcAttackType -------------------

	function self:CalcAttackType(attacker, target, atk_elements, atk_key)
	    if atk_key == nil then
		    atk_key = "normal"
		end
	    --[[local type = CalculateModifierFromAbstractKey(self.external_attacktype_multipliers, atk_key)
		return type]]
		return self.external_attacktype_multipliers:CalculateModifierFromFilter({attacker = attacker, target = target, atk_elements = atk_elements, atk_key = atk_key})
	end
	
	----------------------------------------------------
	----------------------------------------------------
	
	
	----------------------------------------------------
    ------------------- CalcDefense ---------------------
	
	function self:CalcDefense(attacker, weapon, atk_elements, attackkey)
	    local defense = self.defense * self.external_defense_multipliers:Get() + self.defensebonus
		local defense_ignorance = attacker and attacker.components.combat and attacker.components.combat.defense_ignorefn ~= nil and attacker.components.combat.defense_ignorefn(attacker, self.inst, weapon, atk_elements, attackkey) or 0
		defense = defense * ((1-defense_ignorance) > 0 and (1-defense_ignorance) or 0)                                                                                         --inst, target, weapon, atk_elements, attackkey
		return (1 - defense / (defense + 950))
	end
	
	----------------------------------------------------
	----------------------------------------------------
	
	
	----------------------------------------------------
    ------------------ CalcElements --------------------
	
	function self:CalcElements(atk_elements)
	    atk_elements = tryconvert(atk_elements)
	
		local list = 
		{
		    self.pyro + self.external_pyro_multipliers:Get(), 
		    self.cryo + self.external_cryo_multipliers:Get(), 
			self.hydro + self.external_hydro_multipliers:Get(), 
			self.electro + self.external_electro_multipliers:Get(), 
			self.anemo + self.external_anemo_multipliers:Get(), 
			self.geo + self.external_geo_multipliers:Get(), 
			self.dendro + self.external_dendro_multipliers:Get(), 
		    self.physical + self.external_physical_multipliers:Get(), 
		}
	
	    return list[atk_elements]
	end
	
	----------------------------------------------------
	----------------------------------------------------
	
	
	----------------------------------------------------
    ---------------- CalcElementsRes -------------------
	
	function self:CalcElementsRes(atk_elements)
	    atk_elements = tryconvert(atk_elements)
	
		local list = 
		{
		    self.pyro_res + self.external_pyro_res_multipliers:Get(), 
		    self.cryo_res + self.external_cryo_res_multipliers:Get(), 
			self.hydro_res + self.external_hydro_res_multipliers:Get(), 
			self.electro_res + self.external_electro_res_multipliers:Get(), 
			self.anemo_res + self.external_anemo_res_multipliers:Get(), 
			self.geo_res + self.external_geo_res_multipliers:Get(), 
			self.dendro_res + self.external_dendro_res_multipliers:Get(), 
		    self.physical_res + self.external_physical_res_multipliers:Get(), 
		}
		local finalres = list[atk_elements]  --计算出最终抗性
		local finalrate = 1
		if finalres < 0 then
			finalrate = 1 - 0.5 * finalres
		elseif finalres < 0.75 then
			finalrate = 1 - finalres
		else
            finalrate = 1 / (1 + 4 * finalres)
		end
	    
	    return finalrate
	end
	
	----------------------------------------------------
	----------------------------------------------------


	----------------------------------------------------
    ---------------- CalcImmunity -------------------
	
	function self:CalcImmunity(atk_elements)
	    atk_elements = tryconvert(atk_elements)
	
		local list = 
		{
		    self.pyro_immunity,
			self.cryo_immunity,
			self.hydro_immunity,
			self.electro_immunity,
			self.anemo_immunity,
			self.geo_immunity,
			self.dendro_immunity,
			self.physical_immunity,
		}
		if list[atk_elements] then
			return true

		end
	    return false
	end
	
	----------------------------------------------------
	----------------------------------------------------
	
	
    ----------------------------------------------------
    -------------- CalcDamageResolved ------------------
	
	function self:CalcDamageResolved(attacker, damage, weapon, stimuli)  --跟官方的getattacked一样，走流程获取数字而已
	    if self.inst.components.health and self.inst.components.health:IsDead() then
			return damage
		end

		local blocked = false
        local damageredirecttarget = self.redirectdamagefn ~= nil and self.redirectdamagefn(self.inst, attacker, damage, weapon, stimuli) or nil
        local damageresolved = 0

		if self.inst.components.health ~= nil and damage ~= nil and damageredirecttarget == nil then
			if self.inst.components.inventory ~= nil then
				--damage = self.inst.components.inventory:ApplyDamage(damage, attacker, weapon)
                damage = self.inst.components.inventory:CalcAppliedDamage(damage, attacker, weapon)
			end
			damage = damage * self.externaldamagetakenmultipliers:Get()
			if damage > 0 and not self.inst.components.health:IsInvincible() then
				--Bonus damage only applies after unabsorbed damage gets through your armor
				if attacker ~= nil and attacker.components.combat ~= nil and attacker.components.combat.bonusdamagefn ~= nil then
					damage = (damage + attacker.components.combat.bonusdamagefn(attacker, self.inst, damage, weapon)) or 0
				end
	
				local cause = attacker == self.inst and weapon or attacker
				--V2C: guess we should try not to crash old mods that overwrote the health component
				--damageresolved = self.inst.components.health:DoDelta(-damage, nil, cause ~= nil and (cause.nameoverride or cause.prefab) or "NIL", nil, cause)
                damageresolved = self.inst.components.health:CalcResolved(-damage)
				damageresolved = damageresolved ~= nil and -damageresolved or damage
			else
				blocked = true
				damageresolved = 0
			end
		end

		return damageresolved
	end
	
	----------------------------------------------------
	----------------------------------------------------


	----------------------------------------------------
    ------------------ GetAttacked ---------------------
	
	local old_GetAttacked = self.GetAttacked
	function self:GetAttacked(attacker, damage, weapon, stimuli, ele_value, attackkey)
		local ele_value_copied = 1.3
		local attackkey_copied = "normal"
		local atk_elements = 8
		if ele_value == nil or type(ele_value) ~= "number" then
		    ele_value_copied = 1.3
		else
		ele_value_copied = ele_value
		end

		if attackkey == nil or type(attackkey) ~= "string" then
		    attackkey_copied = "normal"
		else
		    attackkey_copied = attackkey
		end

		atk_elements = tryconvert(stimuli)
		--以上三个参数全都不修改原值，因为有可能其他mod会改这几个值的
	
		--暴击伤害，攻击种类
		local critical = 1
		local typebonus = 1
		if attacker and attacker.components.combat ~= nil then
		    critical = attacker.components.combat:CalcCritical(attacker, self.inst, atk_elements, attackkey_copied)
		    typebonus = attacker.components.combat:CalcAttackType(attacker, self.inst, atk_elements, attackkey_copied)
        end
		if attackkey_copied == "elementreaction" then
		    critical = 1  --剧变反应不暴击
		end

		--护盾
		local defense = self:CalcDefense(attacker, weapon, atk_elements, attackkey_copied)

		--元素伤害加成和元素抗性加成
		local elements = 1
	    if attacker and attacker.components.combat ~= nil then
	        elements = attacker.components.combat:CalcElements(atk_elements) --atk_slements就是官方说的stimuli
		end
		local elements_res = self:CalcElementsRes(atk_elements)

		--元素反应
		local reaction_rate = 1
		local reaction_addnumber = 0
		local ignorecd = (attacker and attacker.components.combat and attacker.components.combat.ignorecdfn ~= nil )and attacker.components.combat.ignorecdfn(attacker, weapon, atk_elements, ele_value_copied, attackkey_copied) or IsIgnoreCD(attacker, weapon, atk_elements, ele_value_copied, attackkey_copied)
		if self.inst.components.elementreactor ~= nil and ele_value_copied > 0 and atk_elements ~= 8 then --物理伤害无需参与元素反应
		    self.inst.components.elementreactor:NewElement(atk_elements, ele_value_copied, attacker, ignorecd, true)
		    reaction_rate, reaction_addnumber = self.inst.components.elementreactor:CalcReaction()
		end

		--伤害免疫
		local immuned = self:CalcImmunity(atk_elements)
		if immuned then
			damage = 0
		end

		--增伤数值
		local dmgadd = self.external_dmgaddnumber_multipliers:Get()

		--最终传递给敌人的伤害（后面再去穿透护甲和伤害重定向）
		damage = (damage + dmgadd + reaction_addnumber) * critical * defense * (typebonus + elements - 1) * elements_res * reaction_rate
		local damageresolved = self:CalcDamageResolved(attacker, damage, weapon, stimuli)

		--推送一下事件
		if attacker ~= nil then
		    attacker:PushEvent("damagecalculated", { target = self.inst, damage = damage, damageresolved = damageresolved, weapon = weapon, stimuli = atk_elements, elementvalue = ele_value_copied, crit = critical > 1 and true or false, attackkey = attackkey_copied, immuned = immuned })
		end
	    self.inst:PushEvent("takendamagecalculated", { attacker = attacker, damage = damage, damageresolved = damageresolved, weapon = weapon, stimuli = atk_elements, elementvalue = ele_value_copied, crit = critical > 1 and true or false, attackkey = attackkey_copied, immuned = immuned })
		TheWorld:PushEvent("entity_damagecalculated", { attacker = attacker, target = self.inst, damage = damage, damageresolved = damageresolved, weapon = weapon, stimuli = atk_elements, elementvalue = ele_value_copied, crit = critical > 1 and true or false, attackkey = attackkey_copied, immuned = immuned })
	
		--有些mod获取attacked的stimuli数据不能有number，这下得整了
		local STIMULI = {"fire", "cryo", "hydro", "electric", "anemo", "geo", "dendro", "physical"}
		--这里用fire和electric而不是pyro和electro
		if type(stimuli) == "number" then
		    stimuli = STIMULI[stimuli]
		end
	    old_GetAttacked(self, attacker, damage, weapon, stimuli, ele_value, attackkey)
	end 
	
	----------------------------------------------------
	----------------------------------------------------
	
	
	----------------------------------------------------
    ------------------- CalcDamage ---------------------
	
    local old_CalcDamage = self.CalcDamage
	function self:CalcDamage(target, weapon, multiplier)
	    local old_damage = old_CalcDamage(self, target, weapon, multiplier)

		local basedamage
    	local basemultiplier = self.damagemultiplier
    	local externaldamagemultipliers = self.externaldamagemultipliers
    	local bonus = self.damagebonus --not affected by multipliers
    	local playermultiplier = target ~= nil and target:HasTag("player")
    	local pvpmultiplier = playermultiplier and self.inst:HasTag("player") and self.pvp_damagemod or 1
		local mount = nil

    	--NOTE: playermultiplier is for damage towards players
    	--      generally only applies for NPCs attacking players

    	if weapon ~= nil then
    	    --No playermultiplier when using weapons
    	    basedamage = weapon.components.weapon:GetDamage(self.inst, target) or 0
---@diagnostic disable-next-line: cast-local-type
    	    playermultiplier = 1
    	else
    	    basedamage = self.defaultdamage
---@diagnostic disable-next-line: cast-local-type
    	    playermultiplier = playermultiplier and self.playerdamagepercent or 1
    	    if self.inst.components.rider ~= nil and self.inst.components.rider:IsRiding() then
    	        mount = self.inst.components.rider:GetMount()
    	        if mount ~= nil and mount.components.combat ~= nil then
    	            basedamage = mount.components.combat.defaultdamage
    	            basemultiplier = mount.components.combat.damagemultiplier
    	            externaldamagemultipliers = mount.components.combat.externaldamagemultipliers
    	            bonus = mount.components.combat.damagebonus
    	        end

    	        local saddle = self.inst.components.rider:GetSaddle()
    	        if saddle ~= nil and saddle.components.saddler ~= nil then
    	            basedamage = basedamage + saddle.components.saddler:GetBonusDamage()
    	        end
    	    end
    	end

    	return (basedamage * (self.external_atk_multipliers:Get() - 1) + self.atkbonus)
    	    * (basemultiplier or 1)
    	    * externaldamagemultipliers:Get()
    	    * (multiplier or 1)
    	    * playermultiplier
    	    * pvpmultiplier
			* (self.customdamagemultfn ~= nil and self.customdamagemultfn(self.inst, target, weapon, multiplier, mount) or 1)
    	    + old_damage  --that's why -1 in line 544
	end
	
	----------------------------------------------------
	----------------------------------------------------


    ----------------------------------------------------
    -------------------- DoAttack ----------------------

	local old_DoAttack = self.DoAttack
	function self:DoAttack(targ, weapon, projectile, stimuli, instancemult, attackkey)

	    if targ == nil then
            targ = self.target
        end
        if weapon == nil then
            weapon = self:GetWeapon()
        end

	    ----------------------------------------------------------------------------
		--修改
		if attackkey == nil then  --优先级最高是直接传入参数
			if self.overrideattackkeyfn ~= nil then  --其次是人物的自定义伤害类型
				attackkey = self.overrideattackkeyfn(self.inst, weapon, targ) --最后是武器的自定义伤害类型
			elseif weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overrideattackkeyfn ~= nil then
                attackkey = weapon.components.weapon.overrideattackkeyfn(weapon, self.inst, targ)
            end
		end

		if stimuli == nil then  --优先级最高是直接传入参数
            if self.overridestimulifn ~= nil then  --其次是人物的自定义伤害类型
                stimuli = self.overridestimulifn(self.inst, weapon, targ, attackkey)
            end
        end
		--最后是武器的自定义伤害类型，在下面再看，之所以分开是因为官方写过

		if (attackkey == nil or attackkey == "normal") and (stimuli == nil or stimuli == 8) then
		    --如果attackkey是nil，那就可以用官方的函数了
			attackkey = nil
			stimuli = nil
		    old_DoAttack(self, targ, weapon, projectile, stimuli, instancemult)
			return
		end
	
		--ps:使用这种方式提高兼容性
		--attackkey是我自定义的参数，当官方调用DoAttack时，attackkey必然是nil
		--此时调用那时候的官方函数减小崩溃的可能性
		--什么时候还会崩溃呢，那就是attackkey存在（即攻击类型由我指定时），但是目前的函数与那时候的官方函数有冲突
		--其实这种情况是很少的，因为我指定的attackkey的攻击，基本上不会触碰到需要大改的更新内容（比如一堆乱七八糟的活动）
		--大部分时候没有问题或者只是伤害表现出现偏差，不至于直接崩溃
		--真正的直接崩溃只有在官方完全修改该函数逻辑，或者添加了传入参数（我的参数要往后挪）才会出现
		-----------------------------------------------------------------------------

		if stimuli == nil then  --优先级最高是直接传入参数
			--其次是人物的自定义伤害类型，已经判断过了，最后是武器的自定义伤害类型
            if weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overridestimulifn ~= nil then
                stimuli = weapon.components.weapon.overridestimulifn(weapon, self.inst, targ)
            end
            if stimuli == nil and self.inst.components.electricattacks ~= nil then
                stimuli = "electric"
            end
        end

        if not self:CanHitTarget(targ, weapon) then
            self.inst:PushEvent("onmissother", { target = targ, weapon = weapon })
            if self.areahitrange ~= nil and not self.areahitdisabled then
                self:DoAreaAttack(projectile or self.inst, self.areahitrange, weapon, self.areahitcheck, stimuli, AREA_EXCLUDE_TAGS)
            end
            return
        end

        self.inst:PushEvent("onattackother", { target = targ, weapon = weapon, projectile = projectile, stimuli = stimuli })

        if weapon ~= nil and projectile == nil then
            if weapon.components.projectile ~= nil then
                local projectile = self.inst.components.inventory:DropItem(weapon, false)
                if projectile ~= nil then
                    projectile.components.projectile:Throw(self.inst, targ)
					--------------------------------------------------------------
					--修改
					projectile.components.projectile.atk_key = attackkey
					--------------------------------------------------------------
                end
                return

            elseif weapon.components.complexprojectile ~= nil then
                local projectile = self.inst.components.inventory:DropItem(weapon, false)
                if projectile ~= nil then
                    projectile.components.complexprojectile:Launch(targ:GetPosition(), self.inst)
                end
                return

            elseif weapon.components.weapon:CanRangedAttack() then
                weapon.components.weapon:LaunchProjectile(self.inst, targ)
                return
            end
        end

        local reflected_dmg = 0
        local reflect_list = {}
        if targ.components.combat ~= nil then
            local mult =
                (   stimuli == "electric" or
                    (weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.stimuli == "electric")
                )
                and not (targ:HasTag("electricdamageimmune") or
                    (targ.components.inventory ~= nil and targ.components.inventory:IsInsulated()))
                and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (targ.components.moisture ~= nil and targ.components.moisture:GetMoisturePercent() or (targ:GetIsWet() and 1 or 0))
                or 1

            local dmg = self:CalcDamage(targ, weapon, mult) * (instancemult or 1)  --instancemult倍率

            --Calculate reflect first, before GetAttacked destroys armor etc.
            if projectile == nil then
                reflected_dmg = self:CalcReflectedDamage(targ, dmg, weapon, stimuli, reflect_list)
            end

			-------------------------------------------------------------------------
			--传入攻击种类参数，伤害计算改在这里进行
            targ.components.combat:GetAttacked(self.inst, dmg, weapon, stimuli, nil, attackkey)
			-------------------------------------------------------------------------

        elseif projectile == nil then
            reflected_dmg = self:CalcReflectedDamage(targ, 0, weapon, stimuli, reflect_list)
        end

        if weapon ~= nil then
            weapon.components.weapon:OnAttack(self.inst, targ, projectile)
        end

        if self.areahitrange ~= nil and not self.areahitdisabled then
            self:DoAreaAttack(targ, self.areahitrange, weapon, self.areahitcheck, stimuli, AREA_EXCLUDE_TAGS)
        end

        self.lastdoattacktime = GetTime()

        --Apply reflected damage to self after our attack damage is completed
        if reflected_dmg > 0 and self.inst.components.health ~= nil and not self.inst.components.health:IsDead() then
            self:GetAttacked(targ, reflected_dmg)
            for i, v in ipairs(reflect_list) do
                if v.inst:IsValid() then
                    v.inst:PushEvent("onreflectdamage", v)
                end
            end
        end
    end
 
	----------------------------------------------------
	----------------------------------------------------

	----------------------------------------------------
    ------------------ DoAreaAttack --------------------

	local old_DoAreaAttack = self.DoAreaAttack
	local AREAATTACK_MUST_TAGS = { "_combat" }
    function self:DoAreaAttack(target, range, weapon, validfn, stimuli, excludetags, attackkey)
		-------------------------------------------------------------------------------------------
        if attackkey == nil then  --优先级最高是直接传入参数
			if self.overrideattackkeyfn ~= nil then  --其次是人物的自定义伤害类型
				attackkey = self.overrideattackkeyfn(self.inst, weapon, target) --最后是武器的自定义伤害类型
			elseif weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overrideattackkeyfn ~= nil then
                attackkey = weapon.components.weapon.overrideattackkeyfn(weapon, self.inst, target)
            end
		end

		if stimuli == nil then  --优先级最高是直接传入参数
            if self.overridestimulifn ~= nil then  --其次是人物的自定义伤害类型
                stimuli = self.overridestimulifn(self.inst, weapon, target, attackkey) --最后是武器的自定义伤害类型
			elseif weapon ~= nil and weapon.components.weapon ~= nil and weapon.components.weapon.overridestimulifn ~= nil then
                stimuli = weapon.components.weapon.overridestimulifn(weapon, self.inst, target)
            end
        end

        if (attackkey == nil or attackkey == "normal") and (stimuli == nil or stimuli == 8) then
		    --如果attackkey是nil，那就可以用官方的函数了
			attackkey = nil
			stimuli = nil
			return old_DoAreaAttack(self, target, range, weapon, validfn, stimuli, excludetags)
		end
        -------------------------------------------------------------------------------------------
        local hitcount = 0
        local x, y, z = target.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, range, AREAATTACK_MUST_TAGS, excludetags)
        for i, ent in ipairs(ents) do
            if ent ~= target and
                ent ~= self.inst and
                self:IsValidTarget(ent) and
                (validfn == nil or validfn(ent, self.inst)) then
                self.inst:PushEvent("onareaattackother", { target = ent, weapon = weapon, stimuli = stimuli })
                ent.components.combat:GetAttacked(self.inst, self:CalcDamage(ent, weapon, self.areahitdamagepercent), weapon, stimuli, nil, attackkey)
                hitcount = hitcount + 1
            end
        end

        return hitcount
    end
	 
	----------------------------------------------------
	----------------------------------------------------

end)