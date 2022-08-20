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
            inst.inv_image_bg = { image = "inv_art_lock.tex" }
            inst.inv_image_bg.atlas = "images/inventoryimages/inv_art_lock.xml"
        else
            inst.inv_image_bg = { image = "blank.tex" }
            inst.inv_image_bg.atlas = "images/ui.xml"
        end
        self.inst:PushEvent("imagechange")
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

function Artifacts:GetValueOfType(type)
    if self._main_type:value() == type then
        return self._main_number:value()
    elseif self._sub1_type:value() == type then
        return self._sub1_number:value()
    elseif self._sub2_type:value() == type then
        return self._sub2_number:value()
    elseif self._sub3_type:value() == type then
        return self._sub3_number:value()
    elseif self._sub4_type:value() == type then
        return self._sub4_number:value()
    end
    return 0
end

function Artifacts:IsLocked()
    return self._locked:value()
end

return Artifacts