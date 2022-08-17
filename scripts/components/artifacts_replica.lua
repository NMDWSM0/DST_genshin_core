local Artifacts = Class(function(self, inst)
	self.inst = inst 

    self._sets = net_string(inst.GUID, "artifacts._sets", "attributedirty")

    self._tag = net_string(inst.GUID, "artifacts._tag", "attributedirty")

    self._main_type = net_string(inst.GUID, "artifacts._main_type", "attributedirty")
    self._main_number = net_float(inst.GUID, "artifacts._main_number", "attributedirty")

    self._sub1_type = net_string(inst.GUID, "artifacts._sub1_type", "attributedirty")
    self._sub1_number = net_float(inst.GUID, "artifacts._sub1_number", "attributedirty")

    self._sub2_type = net_string(inst.GUID, "artifacts._sub2_type", "attributedirty")
    self._sub2_number = net_float(inst.GUID, "artifacts._sub2_number", "attributedirty")

    self._sub3_type = net_string(inst.GUID, "artifacts._sub3_type", "attributedirty")
    self._sub3_number = net_float(inst.GUID, "artifacts._sub3_number", "attributedirty")

    self._sub4_type = net_string(inst.GUID, "artifacts._sub4_type", "attributedirty")
    self._sub4_number = net_float(inst.GUID, "artifacts._sub4_number", "attributedirty")

    self._locked = net_bool(inst.GUID, "artifacts._locked", "lockdirty")

    self.inst:ListenForEvent("lockdirty", function ()
        if self:IsLocked() then
            self.inst.inv_image_bg = { image = "inv_art_lock.tex" }
            self.inst.inv_image_bg.atlas = "images/inventoryimages/inv_art_lock.xml"
        else
            self.inst.inv_image_bg = nil
        end
    end)
end)

function Artifacts:GetSets()
    return self._sets:value()
end

function Artifacts:GetTag()
    return self._tag:value()
end

function Artifacts:GetMain()
    return {
        type = self._main_type:value(),
        number = self._main_number:value(),
    }
end

function Artifacts:GetSub1()
    return {
        type = self._sub1_type:value(),
        number = self._sub1_number:value(),
    }
end

function Artifacts:GetSub2()
    return {
        type = self._sub2_type:value(),
        number = self._sub2_number:value(),
    }
end

function Artifacts:GetSub3()
    return {
        type = self._sub3_type:value(),
        number = self._sub3_number:value(),
    }
end

function Artifacts:GetSub4()
    return {
        type = self._sub4_type:value(),
        number = self._sub4_number:value(),
    }
end

function Artifacts:IsLocked()
    return self._locked:value()
end

return Artifacts