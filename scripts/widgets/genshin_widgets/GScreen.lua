local GWidget = require "widgets/genshin_widgets/Gwidget"
require "widgets/genshin_widgets/Gimage"

local GScreen = Class(GWidget, function(self, name)
    GWidget._ctor(self, name)
	--self.focusstack = {}
	--self.focusindex = 0
	self.handlers = {}
	--self.inst:Hide()
    self.is_screen = true
end)

function GScreen:OnCreate()
end

function GScreen:GetHelpText()
	return ""
end

function GScreen:OnDestroy()
	self:Kill()
end

function GScreen:OnUpdate(dt)
	return true
end

function GScreen:OnBecomeInactive()
	self.last_focus = self:GetDeepestFocus()
end

function GScreen:OnBecomeActive()
	TheSim:SetUIRoot(self.inst.entity)
	if self.last_focus and self.last_focus.inst.entity:IsValid() then
		self.last_focus:SetFocus()
	else
		self.last_focus = nil
		if self.default_focus then
			self.default_focus:SetFocus()
		end
	end
end

function GScreen:AddEventHandler(event, fn)
	if not self.handlers[event] then
		self.handlers[event] = {}
	end

	self.handlers[event][fn] = true

	return fn
end

function GScreen:RemoveEventHandler(event, fn)
	if self.handlers[event] then
		self.handlers[event][fn] = nil
	end
end

function GScreen:HandleEvent(type, ...)
	local handlers = self.handlers[type]
	if handlers then
		for k,v in pairs(handlers) do
			k(...)
		end
	end
end

function GScreen:SetDefaultFocus()
	if self.default_focus then
		self.default_focus:SetFocus()
		return true
	end
end

return GScreen