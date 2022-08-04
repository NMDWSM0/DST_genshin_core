AddComponentPostInit("inventory", function(self)
    function self:CalcAppliedDamage(damage, attacker, weapon)
        --check resistance and specialised armor
        local absorbers = {}
        for k, v in pairs(self.equipslots) do
            if v.components.resistance ~= nil and
                v.components.resistance:HasResistance(attacker, weapon) and
                v.components.resistance:ShouldResistDamage() then
                --v.components.resistance:ResistDamage(damage)
                return 0
            elseif v.components.armor ~= nil then
                absorbers[v.components.armor] = v.components.armor:GetAbsorption(attacker, weapon)
            end
        end
    
        -- print("Incoming damage", damage)
    
        local absorbed_percent = 0
        local total_absorption = 0
        for armor, amt in pairs(absorbers) do
            -- print("\t", armor.inst, "absorbs", amt)
            absorbed_percent = math.max(amt, absorbed_percent)
            total_absorption = total_absorption + amt
        end
    
        local absorbed_damage = damage * absorbed_percent
        local leftover_damage = damage - absorbed_damage
    
        -- print("\tabsorbed%", absorbed_percent, "total_absorption", total_absorption, "absorbed_damage", absorbed_damage, "leftover_damage", leftover_damage)
    
        return leftover_damage
    end
end)