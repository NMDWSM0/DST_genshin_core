local Widget = require "widgets/widget"

-- GWidget
local GWidget = Class(Widget, function(self, name)
    Widget._ctor(self, name)
	-- just adjust some anim
    self.parent_tint = {1, 1, 1, 1}
    self._tint = {1, 1, 1, 1}
end)

-----------------------------------------------------
-- ScaleTo
-- 重写SetScale添加是否结束ScaleTo动画的支持
function GWidget:SetScale(pos, y, z, stop_transit)
    if stop_transit then
        self:CancelScaleTo(true)
    end
    if type(pos) == "table" and pos.x == nil then
        pos, y, z = unpack(pos)
    end
    Widget.SetScale(self, pos, y, z)
end

-- 重写ScaleTo，并且支持拉伸
function GWidget:ScaleTo(from, to, time, fn)
    if from == nil then
        local x, y, z = self:GetLooseScale()
        from = {x = x, y = y, z = z}
    end
    if type(from) == "number" then
        from = {x = from, y = from, z = from}
    end
    if type(to) == "number" then
        to = {x = to, y = to, z = to}
    end
    if from.x == to.x and from.y == to.y and from.z == to.z then
        return 
    end
    if time <= 0 then
        self:SetScale(to.x, to.y, to.z)
        return
    end
    if not self.inst.components.genshin_uianim then
        self.inst:AddComponent("genshin_uianim")
    end
    self.inst.components.genshin_uianim:ScaleTo(from, to, time, fn)
end

-- 渐变比例接口函数，并且支持拉伸
function GWidget:TransitScale(pos, y, z, animtime, fn)
    local dest = type(pos) == "number" and {x = pos, y = y or pos, z = z or pos} or {x = pos.x, y = pos.y, z = pos.z}
    self:CancelScaleTo()
    self:ScaleTo(nil, dest, animtime or 0.15, fn)
end

-------------------------------------------------------
-- MoveTo
-- 重写SetPosition添加是否结束MoveTo动画的支持
function GWidget:SetPosition(pos, y, z, stop_transit)
    if stop_transit then
        self:CancelMoveTo(true)
    end
    if type(pos) == "table" then
        if pos.x == nil then
            pos = ToVector3(pos)
        elseif pos.Get == nil then
            y = pos.y
            z = pos.z
            pos = pos.x
        end
    end
    Widget.SetPosition(self, pos, y, z)
end

-- 重写MoveTo
function GWidget:MoveTo(from, to, time, fn)
    if from == nil then
        local x, y, z = self:GetPositionXYZ()
        from = {x = x, y = y, z = z}
    end
    if from.x == to.x and from.y == to.y and from.z == to.z then
        return 
    end
    if time <= 0 then
        self:SetPosition(to.x, to.y, to.z)
        return
    end
    if not self.inst.components.genshin_uianim then
        self.inst:AddComponent("genshin_uianim")
    end
    self.inst.components.genshin_uianim:MoveTo(from, to, time, fn)
end

-- 渐变位置接口函数
function GWidget:TransitPosition(pos, y, z, animtime, fn)
    local dest = type(pos) == "number" and {x = pos, y = y, z = z} or {x = pos.x, y = pos.y, z = pos.z}  --pos是Vector3
    self:CancelMoveTo()
    self:MoveTo(nil, dest, animtime or 0.1, fn)
end

-------------------------------------------------------
-- RotateTo
-- 重写SetRotation添加是否结束RotateTo动画的支持
function GWidget:SetRotation(angle, stop_transit)
    if stop_transit then
        self:CancelRotateTo(true)
    end
    Widget.SetRotation(self, angle)
end

-- 重写RotateTo
function GWidget:RotateTo(from, to, time, fn, infinite)
    if from == nil then
        from = self.inst.UITransform:GetLocalRotation()
    end
    if from == to then
        return 
    end
    if time <= 0 then
        self:SetRotation(to)
        return
    end
    if not self.inst.components.genshin_uianim then
        self.inst:AddComponent("genshin_uianim")
    end
    self.inst.components.genshin_uianim:RotateTo(from, to, time, fn, infinite)
end

-- 渐变旋转接口函数，不支持拉伸
function GWidget:TransitRotation(dest, animtime, fn)
    self:CancelRotateTo()
    self:RotateTo(nil, dest, animtime or 0.18, fn)
end

-------------------------------------------------------
-- TintTo
-- 这几个Tint函数都是新写的
function GWidget:SetTint(r, g, b, a, stop_transit, ignore_children)
    if r ~= nil then
        self._tint = type(r) == "number" and {r, g, b, a} or r
    end
    if stop_transit then
        self:CancelTintTo()
    end
    if not ignore_children then
        local t = {self:GetTint()}
        for k, v in pairs(self.children) do
            if v.UpdateParentTint then
                v:UpdateParentTint(unpack(t))
            end
        end
    end
end

function GWidget:GetTint(solitary)
    if solitary then
        return unpack(self._tint)
    end

    return self._tint[1] * self.parent_tint[1], self._tint[2] * self.parent_tint[2], self._tint[3] * self.parent_tint[3], self._tint[4] * self.parent_tint[4]
end

function GWidget:UpdateParentTint(r, g, b, a)
    self.parent_tint = {r, g, b, a}
    self:SetTint()
end

-- 重写TintTo
function GWidget:TintTo(from, to, time, fn)
    if from == nil then
        local t_r, t_g, t_b, t_a = self:GetTint(true)
        from = {r = t_r, g = t_g, b = t_b, a = t_a}
    end
    if from.r == to.r and from.g == to.g and from.b == to.b and from.a == to.a then
        return
    end
    if time <= 0 then
        self:SetTint(to.r, to.g, to.b, to.a)
        return
    end
    if not self.inst.components.genshin_uianim then
        self.inst:AddComponent("genshin_uianim")
    end
    self.inst.components.genshin_uianim:TintTo(from, to, time, fn)
end

-- 渐变Tint颜色接口函数
function GWidget:TransitTint(r, g, b, a, animtime, fn)
    local dest = type(r) == "number" and { r = r, g = g, b = b, a = a } or {r = r[1], g = r[2], b = r[3], a = r[4]}
    self:CancelTintTo()
    self:TintTo(nil, dest, animtime or 0.22, fn)
end

-------------------------------------------------------
-- 第一个运用到渐变的功能
-- 添加渐变隐藏
function GWidget:Hide(animtime)
    animtime = animtime or 0.22
    if animtime <= 0 or self.shown == false then
        self.inst.entity:Hide(false) --立即
    else
        self:TransitTint(1, 1, 1, 0, animtime, function ()
            self.inst.entity:Hide(false)
        end)
    end
    local was_visible = self.shown == true
    self.shown = false
    self:OnHide(was_visible)
end

-- 添加渐变显现
function GWidget:Show(animtime)
    animtime = animtime or 0.22
    local r, g, b, a = self:GetTint(true)
    if self.shown and r * g * b * a == 1 then
        -- do nothing on color tint
    else
        if animtime <= 0 then
            self:SetTint(1, 1, 1, 1, true)
        else
            self:TransitTint(1, 1, 1, 1, animtime)
        end
    end
    self.inst.entity:Show(false)
    local was_hidden = self.shown == false
    self.shown = true
    self:OnShow(was_hidden)
end

return GWidget