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

AddComponentPostInit("freezable", function(self)
    --self.wearofftime = 6
    --self.damagetobreak = 2147483647
    self.elereac_wearofftime = 4
    self.lastfrozenstimuli = nil

    local upvaluehelper = require "import/upvaluehelper"
	local fn = upvaluehelper.GetEventHandle(self.inst, "attacked","components/freezable")
	if fn then
		self.inst:RemoveEventCallback("attacked", fn)
	end

    local function new_OnAttacked(inst, data)
        if data == nil then
            return
        end
        local atk_elements = tryconvert(data.stimuli)
        -------------------------------------------------------------------------
        --只有火元素伤害和物理伤害会破除冰冻
        --仅对玩家生效
        if self:IsFrozen() and atk_elements == 1 then
            self:Unfreeze()
        elseif self:IsFrozen() and not(data.attacker and data.attacker:HasTag("player")) then
            self.damagetotal = self.damagetotal + math.abs(data.damage or 0)
            if self.damagetotal >= self.damagetobreak then
                self:Unfreeze()
            end
        elseif self:IsFrozen() and atk_elements == 8 then
        --更新内容
        -------------------------------------------------------------------------
        self.damagetotal = self.damagetotal + math.abs(data.damage or 0)
            if self.damagetotal >= self.damagetobreak then
                self:Unfreeze()
                local mastery_rate = 0
                if data.attacker ~= nil and data.attacker.components.combat then
                    mastery_rate = data.attacker.components.combat:CalcMasteryAddition(4)
                end
                local base_damage = 21.7
                local bonus = data.attacker and data.attacker.components.elementreactor and (data.attacker.components.elementreactor.attack_shattered_bonus * data.attacker.components.elementreactor.attack_shattered_bonus_modifier:Get()) or 1
                self.inst.components.combat:GetAttacked(data.attacker, base_damage * (1 + mastery_rate) * bonus, nil, 8, nil--[[spdmg]], 0--[[ele_value]], "normal")  --碎冰是物理伤害
            end
        end
    end
	self.inst:ListenForEvent("attacked", new_OnAttacked)

	local old_OnRemoveFromEntity = self.OnRemoveFromEntity
	function self:OnRemoveFromEntity()
	    self.inst:RemoveEventCallback("attacked", new_OnAttacked)
		old_OnRemoveFromEntity(self)
	end

    local old_AddColdness = self.AddColdness
    function self:AddColdness(coldness, freezetime, nofreeze, stimuli)
        if stimuli == nil then
            self.lastfrozenstimuli = "normal"
        elseif self.lastfrozenstimuli ~= "normal" and stimuli == "reaction" then
            self.lastfrozenstimuli = "reaction"
        end
        old_AddColdness(self, coldness, freezetime, nofreeze)
    end

    local old_Thaw = self.Thaw
    function self:Thaw(thawtime)
        local defaulttime = self.lastfrozenstimuli == "reaction" and self.elereac_wearofftime or self.wearofftime
        old_Thaw(self, thawtime or defaulttime)
    end

    local old_UpdateTint = self.UpdateTint
    function self:UpdateTint()
        if self.coldness <= 0 then
            self.lastfrozenstimuli = nil
        end
        old_UpdateTint(self)
    end
end)