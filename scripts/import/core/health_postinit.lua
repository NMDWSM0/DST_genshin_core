local SourceModifierList = require("util/sourcemodifierlist")

AddComponentPostInit("health", function(self, inst)
	--先是关于最大生命值的修改
	self.base_health = 100
	self.maxhealth_modifier = SourceModifierList(self.inst, 1, SourceModifierList.additive)
	self.healthbonus = 0
	--涉及到设置最大生命值的函数，setmaxhealth
    local old_SetMaxHealth = self.SetMaxHealth
	function self:SetMaxHealth(amount)
		if not TUNING.ARTIFACTS_ON_HEALTH then
			old_SetMaxHealth(self, amount or self.maxhealth)
			return
		end
		if amount ~= nil then
            self.base_health = amount
		end
		old_SetMaxHealth(self, self.base_health * self.maxhealth_modifier:Get() + self.healthbonus)
	end
    --
	function self:SetMaxHealthWithPercent(amount)
        local percent = self:GetPercent()
		self:SetMaxHealth(amount)
		self:SetPercent(percent)
	end

	function self:SynchronizeBaseHealth()
		local base_health = (self.maxhealth - self.healthbonus) / self.maxhealth_modifier:Get()
		if math.abs(base_health - self.base_health) >= 1 then
			self.base_health = base_health
		end
	end
    
	--同时保存一下base_health，毕竟现在这个数值也是最大生命值的一个重要参数了
	local old_OnSave = self.OnSave
    function self:OnSave()
		local data = old_OnSave(self)
		if data ~= nil then
			--data.base_health = self.base_health
		end
		return data
	end
	
	local old_OnLoad = self.OnLoad
	function self:OnLoad(data)
		if data and data.base_health ~= nil then
			--self.base_health = data.base_health
		end
		old_OnLoad(self, data)
	end

	--和官方DoDelta一样，走个流程获取真实伤害而已
    function self:CalcResolved(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
		if self.redirect ~= nil and self.redirect(self.inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb) then
			return 0
		elseif not ignore_invincible and (self:IsInvincible() or self.inst.is_teleporting) then
			return 0
		elseif amount < 0 and not ignore_absorb then
			amount = amount * math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.clamp(1 - self.externalabsorbmodifiers:Get(), 0, 1)
		end
		return amount
	end

	function self:DoFireDamage(amount, doer, instant)
		local mult = self:GetFireDamageScale()
    	if not self:IsInvincible() and (not instant or mult > 0) then
        	local time = GetTime()
        	if not self.takingfiredamage then
        	    self.takingfiredamage = true
        	    self.takingfiredamagestarttime = time
        	    if (self.fire_timestart > 1 and not instant) or mult <= 0 then
        	        self.takingfiredamagelow = true
        	    end
        	    self.inst:StartUpdatingComponent(self)
        	    self.inst:PushEvent("startfiredamage", { low = self.takingfiredamagelow })
        	    ProfileStatsAdd("onfire")
        	end

        	self.lastfiredamagetime = time

        	if (instant or time - self.takingfiredamagestarttime > self.fire_timestart) and amount > 0 then
        	    if mult > 0 then
        	        if self.takingfiredamagelow then
        	            self.takingfiredamagelow = nil
         	            self.inst:PushEvent("changefiredamage", { low = false })
        	        end

        	        --We're going to take damage at this point, so make sure it's not over the cap/second
        	        if self.firedamagecaptimer <= time then
        	            self.firedamageinlastsecond = 0
        	            self.firedamagecaptimer = time + 1
        	        end

        	        if self.firedamageinlastsecond + amount > TUNING.MAX_FIRE_DAMAGE_PER_SECOND then
        	            amount = TUNING.MAX_FIRE_DAMAGE_PER_SECOND - self.firedamageinlastsecond
        	        end

        	        self:DoDelta(-amount * mult, false, doer ~= nil and (doer.nameoverride or doer.prefab) or "fire", nil, doer)

					----
					if TUNING.DMGIND_ENABLE and not self.inst:HasTag("wall") then
						local CDI = SpawnPrefab("dmgind")
						CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
						CDI.isheal = false
						CDI.indicator = amount * mult
						CDI.iscrit = false
						CDI.element_type = 1
						CDI.reaction_type = 0
						if CDI.CreateDamageIndicator ~= nil then
							CDI:CreateDamageIndicator()
						end
					end
					----

        	        self.inst:PushEvent("firedamage")

        	        self.firedamageinlastsecond = self.firedamageinlastsecond + amount
        	    elseif not self.takingfiredamagelow then
       		        self.takingfiredamagelow = true
       		        self.inst:PushEvent("changefiredamage", { low = true })
    	        end
    	    end
    	end
	end

	-----------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------
	--下面是有关伤害显示的更改
    --[[inst:ListenForEvent("takendamagecalculated", function(inst, data)
        if not TUNING.DMGIND_ENABLE then
			return
		end

	    if data == nil then
		    inst.thisdamagecrit = false
			inst.this_is_elementreaction = false
			return
		end
	    inst.thisdamagecrit = (data.crit ~= nil and type(data.crit)=="boolean") and data.crit or false
		inst.this_is_elementreaction = false
		if data.attackkey == "elementreaction" then
		    inst.this_is_elementreaction = true
		end
	end)]]

	inst:ListenForEvent("takendamagecalculated", function(inst, data)
        if not TUNING.DMGIND_ENABLE then
			return
		end

	    local iselementreaction = data.attackkey == "elementreaction" and true or false
		local iscritted = (data.crit ~= nil and type(data.crit) == "boolean") and data.crit or false
		local immuned = data.immuned ~= nil and data.immuned or false
		if inst.components.health then
			local amount = data and data.damageresolved ~= nil and type(data.damageresolved) == "number" and -data.damageresolved or 0

			--由于在进入old_GetAttacked之前把所有数字转换成字符了，所以这里要按照字符处理
			local element = 8
			if data == nil then
			    element = 8
			elseif data.stimuli == nil or data.stimuli == "physical" then
			    element = 8
			elseif data.stimuli == "fire" or data.stimuli == "pyro" then
			    element = 1
			elseif data.stimuli == "cryo" then
			    element = 2
			elseif data.stimuli == "hydro" then
			    element = 3
			elseif data.stimuli == "electric" or data.stimuli == "electro" then
			    element = 4
			elseif data.stimuli == "anemo" then
			    element = 5
			elseif data.stimuli == "geo" then
			    element = 6
			elseif data.stimuli == "dendro" then
			    element = 7
			elseif type(data.stimuli) == "string" then  --其它string，真给我整不会了
			    element = 8
			elseif type(data.stimuli) == "number" then --应该不会了
			    element = data.stimuli
		    end 

			if amount == 0 and not immuned then
				return
			end
			if math.abs(amount) > 0.1 then
				if amount < 0 then
					local CDI = SpawnPrefab("dmgind")
					CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
					CDI.isheal = amount > 0
					CDI.indicator = math.abs(amount)
					CDI.iscrit = not iselementreaction and iscritted or false
					CDI.element_type = element
					CDI.reaction_type = 0
					if CDI.CreateDamageIndicator ~= nil then
						CDI:CreateDamageIndicator()
					end
				end
			elseif immuned then
                local CDI = SpawnPrefab("dmgind")
	    		CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
				CDI.isheal = false
				CDI.indicator = 0
				CDI.element_type = 0
				CDI.reaction_type = -1
				if CDI.CreateDamageIndicator ~= nil then
				    CDI:CreateDamageIndicator()
				end
			end

		end
	end)

	inst:ListenForEvent("elementreaction", function(inst, data)
		if not TUNING.DMGIND_ENABLE then
			return
		end
		
	    local reactiontype = 0
		if data and data.reaction then
		    reactiontype = data.reaction
		end
	    
	    local CDI = SpawnPrefab("dmgind")
	    CDI.Transform:SetPosition(inst.Transform:GetWorldPosition())
		CDI.isheal = false
		CDI.indicator = 0
		CDI.element_type = 0
		CDI.reaction_type = reactiontype
		if CDI.CreateDamageIndicator ~= nil then
		    CDI:CreateDamageIndicator()
		end
	end)
end)