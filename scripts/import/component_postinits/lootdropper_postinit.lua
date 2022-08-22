AddComponentPostInit("lootdropper", function (self)
    
    local old_GenerateLoot = self.GenerateLoot
    function self:GenerateLoot(...)
        local inst = self.inst
        if not inst.components.combat then
            return old_GenerateLoot(self, ...)
        end
        if inst:HasTag("wall") or inst:HasTag("chester") then
            return old_GenerateLoot(self, ...)
        end
        if self.artdrop_added then
            return old_GenerateLoot(self, ...)
        end
        
        local minhealth = TUNING.ARTIFACTS_MINHEALTH
        local baserate = 0.05 * TUNING.ARTIFACTS_DROPRATE
    
        if inst.components.health then
            if inst.components.health.maxhealth < minhealth then
                return old_GenerateLoot(self, ...)
            else
                local h = inst.components.health.maxhealth
                local r = math.min(5, baserate * math.pow((h / 100), 0.932))
                while r > 1 do
                    inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
                    r = r - 1
                end
                inst.components.lootdropper:AddChanceLoot("randomartifacts", math.clamp(r, 0, 1))
            end
        else
            if not inst:HasTag("epic") then
                inst.components.lootdropper:AddChanceLoot("randomartifacts", 0.1)
            else
                inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
            end
        end
        self.artdrop_added = true
        return old_GenerateLoot(self, ...)
    end

end)