AddComponentPostInit("rechargeable", function(self)

    function self:StopUpdatingCharge()
        if self.updating then
            self.updating = false
            self.inst:StopUpdatingComponent(self)
        end
    end
    
    function self:StartUpdatingCharge()
        if not self.updating then
            self.updating = true
            self.inst:StartUpdatingComponent(self)
        end
    end

    function self:LeftTimeDelta(time)
        self:StopUpdatingCharge()
		local ctm = 1
		if self.chargetimemod ~= nil then
		    ctm = self.chargetimemod:Get()
		end
        local chargetime = self.chargetime * (1 + ctm)
        self:SetCharge(chargetime > 0 and self.current + time * self.total / chargetime or self.total, true)
        self:StartUpdatingCharge()
    end

end)