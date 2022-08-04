AddComponentPostInit("projectile", function(self)
    self.atk_key = "normal"

	local function StopTrackingDelayOwner(self)
        if self.delayowner ~= nil then
            self.inst:RemoveEventCallback("onremove", self._ondelaycancel, self.delayowner)
            self.inst:RemoveEventCallback("newstate", self._ondelaycancel, self.delayowner)
            self.delayowner = nil
        end
    end

    local old_Hit = self.Hit
	function self:Hit(target)
        if self.atk_key == "normal" or self.atk_key == nil then
            --normal的话，就直接调用官方的，不会有事的
            old_Hit(self, target)
            return
        end

        local attacker = self.owner
        local weapon = self.inst
        StopTrackingDelayOwner(self)
        self:Stop()
        self.inst.Physics:Stop()

        if attacker.components.combat == nil and attacker.components.weapon ~= nil and attacker.components.inventoryitem ~= nil then
            weapon = (self.has_damage_set and weapon.components.weapon ~= nil) and weapon or attacker
            attacker = attacker.components.inventoryitem.owner
        end

        if self.onprehit ~= nil then
            self.onprehit(self.inst, attacker, target)
        end
        if attacker ~= nil and attacker.components.combat ~= nil then
		    if attacker.components.combat.ignorehitrange then
	            attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli, 1, self.atk_key)
		    else
			    attacker.components.combat.ignorehitrange = true
			    attacker.components.combat:DoAttack(target, weapon, self.inst, self.stimuli, 1, self.atk_key)
			    attacker.components.combat.ignorehitrange = false
		    end
        end
        if self.onhit ~= nil then
            self.onhit(self.inst, attacker, target)
        end
    end

end)