AddComponentPostInit("freezable", function(self)
    self.wearofftime = 6
    self.damagetobreak = 2147483647

    local function new_OnAttacked(inst, data)
        local self = inst.components.freezable
        if data == nil then
            return
        end
        -------------------------------------------------------------------------
        --只有火元素伤害和物理伤害会破除冰冻
        --仅对玩家生效
        if self:IsFrozen() and ((not(data.attacker and data.attacker:HasTag("player"))) or (data.stimuli ~= nil and type(data.stimuli) == "number" and (data.stimuli == 1 or data.stimuli == 8))) then
        --更新内容
        -------------------------------------------------------------------------
            self:Unfreeze()
            if (data.stimuli == 8) then   --碎冰伤害
                local mastery_rate = 0
                if data.attacker ~= nil and data.attacker.components.combat then
                    mastery_rate = data.attacker.components.combat:CalcMasteryAddition(4)
                end
                local base_damage = 21.7
                local bonus = data.attacker and data.attacker.components.elementreactor and (data.attacker.components.elementreactor.attack_shattered_bonus * data.attacker.components.elementreactor.attack_shattered_bonus_modifier:Get()) or 1
                self.inst.components.combat:GetAttacked(data.attacker, base_damage * (1 + mastery_rate) * bonus, nil, 8, 0)  --碎冰是物理伤害
            end
        end
    end
	self.inst:ListenForEvent("attacked", new_OnAttacked)

	local old_OnRemoveFromEntity = self.OnRemoveFromEntity
	function self:OnRemoveFromEntity()
	    self.inst:RemoveEventCallback("attacked", new_OnAttacked)
		old_OnRemoveFromEntity(self)
	end
end)