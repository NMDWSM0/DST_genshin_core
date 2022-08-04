AddComponentPostInit("weapon", function(self)
    self.overrideattackkeyfn = nil

	function self:SetOverrideAttackkeyFn(fn)
        self.overrideattackkeyfn = fn
    end

    local old_LaunchProjectile = self.LaunchProjectile
    function self:LaunchProjectile(attacker, target)
        ---------------------------------------------------------------------
		--如果两个参数有一个不是nil，那基本上不是官方代码在调用我的函数
		local stimuli = self.overridestimulifn ~= nil and self.overridestimulifn(self.inst, attacker, target) or nil
		local attackkey = self.overrideattackkeyfn ~= nil and self.overrideattackkeyfn(self.inst, attacker, target) or nil
		
        if stimuli == nil and attackkey == nil then  --都是nil的话，就调用官方的就OK了
            old_LaunchProjectile(self, attacker, target)
            return
        end
		---------------------------------------------------------------------

        if self.projectile ~= nil then
            if self.onprojectilelaunch ~= nil then
                self.onprojectilelaunch(self.inst, attacker, target)
            end

            local proj = SpawnPrefab(self.projectile)
            if proj ~= nil then
                if proj.components.projectile ~= nil then
				    if self.projectile_offset ~= nil then
					    local x, y, z = attacker.Transform:GetWorldPosition()

					    local dir = (target:GetPosition() - Vector3(x, y, z)):Normalize()
					    dir = dir * self.projectile_offset

	                    proj.Transform:SetPosition(x + dir.x, y, z + dir.z)
				    else
	                    proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
				    end
					---------------------------------------------------------------------
					proj.components.projectile:SetStimuli(stimuli)
					proj.components.projectile.atk_key = attackkey
					---------------------------------------------------------------------
                    proj.components.projectile:Throw(self.inst, target, attacker)
                    if self.inst.projectiledelay ~= nil then
                        proj.components.projectile:DelayVisibility(self.inst.projectiledelay)
                    end
                elseif proj.components.complexprojectile ~= nil then
                    proj.Transform:SetPosition(attacker.Transform:GetWorldPosition())
                    proj.components.complexprojectile:Launch(target:GetPosition(), attacker, self.inst)
                end
            end

            if self.onprojectilelaunched ~= nil then
                self.onprojectilelaunched(self.inst, attacker, target)
            end
        end
    end
end)