local Widget = require "widgets/widget"
local Button = require "widgets/button"

local Draggable_GenshinBtn = Class(Button, function(self)
	Widget._ctor(self, "Draggable_GenshinBtn")

    self.scale_on_focus = false  --禁止缩放
	self.clickoffset = Vector3(0, 0, 0)   --禁止按下移动

	self:SetOnClick()

	self._drag_tolerance = 4
	self:SetOnDragFinish(nil)
end)

function Draggable_GenshinBtn:SetOnDragFinish(fn)
	self._ondragfinish = fn
end

function Draggable_GenshinBtn:OnControl(control, down)
	Widget.OnControl(self, control, down)

	if control == CONTROL_ACCEPT then
		if down then
			self:BeginDrag()
		else
			if not self:HasMoved() then
				if self.onclick then
					self.onclick()
				end
			end
			self:EndDrag()
		end
	end
end

function Draggable_GenshinBtn:OnLoseFocus()
	if self:IsDragging() then
		self:EndDrag()
	end
end

function Draggable_GenshinBtn:HasMoved()
	if self._dragorigin == nil then
		return false
	end

	local bx, by, bz = self._dragorigin:Get()
	local x, y, z = self:GetPosition():Get()

	if math.abs(x - bx) + math.abs(y - by) >= self._drag_tolerance then
		return true
	end

	return false
end

function Draggable_GenshinBtn:IsDragging()
	return self._draghandler ~= nil
end

function Draggable_GenshinBtn:BeginDrag()
	if self:IsDragging() then
		return
	end

	self._dragorigin = self:GetPosition()
	local pos = self._dragorigin

	self._draghandler = TheInput:AddMoveHandler(function(x, y)
		local deltax = x - (TheFrontEnd.lastx or x)
		local deltay = y - (TheFrontEnd.lasty or y)

		local screen_width, screen_height = TheSim:GetScreenSize()

		local nx = pos.x + deltax
		local ny = pos.y + deltay

		local a = 0
        local b = 0
        if self.key_bg then
            a, b = self.key_bg:GetSize()
        end

		nx = math.clamp(nx, a/2, screen_width - a/2) -- 0,0 is bottom right of screen
		ny = math.clamp(ny, b/2, screen_height - b/2)
		
		pos = Vector3(nx, ny, pos.z)
		self:SetPosition(pos)
	end)
end

function Draggable_GenshinBtn:EndDrag()
	if not self:IsDragging() then -- checks self._draghandler
		return
	end

	self._draghandler:Remove()

	if self._ondragfinish and self:HasMoved() then
		self._ondragfinish(self._dragorigin, self:GetPosition())
	end

	self._dragorigin = nil
	self._draghandler = nil
end

return Draggable_GenshinBtn