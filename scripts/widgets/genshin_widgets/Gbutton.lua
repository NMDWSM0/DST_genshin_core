local GWidget = require "widgets/genshin_widgets/Gwidget"
local GText = require "widgets/genshin_widgets/Gtext"

--base class for Gimagebuttons and Ganimbuttons.
local GButton = Class(GWidget, function(self)
    GWidget._ctor(self, "BUTTON")

    self.font = "genshinfont"  --GButton 使用默认使用原神字体
    self.fontdisabled = "genshinfont"

	self.textcolour = {0, 0, 0, 1}
	self.textfocuscolour = {0, 0, 0, 1}
	self.textdowncolour = {0, 0, 0, 1}
	self.textdisabledcolour = {0, 0, 0, 1}
    self.textselectedcolour = {0, 0, 0, 1}

    self.text = self:AddChild(GText(self.font, 40))
	self.text:SetVAlign(ANCHOR_MIDDLE)
    self.text:SetColour(self.textcolour)
    self.text:Hide(-1)

	self.clickoffset = Vector3(0, -3, 0)

	self.selected = false

	self.control = CONTROL_ACCEPT
	self.mouseonly = false
	self.help_message = STRINGS.UI.HELP.SELECT
end)

function GButton:DebugDraw_AddSection(dbui, panel)
    GButton._base.DebugDraw_AddSection(self, dbui, panel)

    dbui.Spacing()
    dbui.Text("Button")
    dbui.Indent() do
        dbui.Value("IsSelected", self:IsSelected())
        dbui.Value("IsEnabled", self:IsEnabled())

        dbui.ColorEdit4("textcolour        ", unpack(self.textcolour))
        dbui.ColorEdit4("textfocuscolour   ", unpack(self.textfocuscolour))
        dbui.ColorEdit4("textdisabledcolour", unpack(self.textdisabledcolour))
        dbui.ColorEdit4("textselectedcolour", unpack(self.textselectedcolour))
    end
    dbui.Unindent()
end

function GButton:SetControl(ctrl)
	if ctrl == CONTROL_PRIMARY then
		self.control = CONTROL_ACCEPT
	elseif ctrl then
		self.control = ctrl
	end
	self.mouseonly = ctrl == CONTROL_PRIMARY
end

function GButton:OnControl(control, down)
	if GButton._base.OnControl(self, control, down) then return true end

	if not self:IsEnabled() or not self.focus then return false end

	if self:IsSelected() and not self.AllowOnControlWhenSelected then return false end

	if control == self.control and (not self.mouseonly or TheFrontEnd.isprimary) then

		if down then
			if not self.down then
				self.text:TransitColour(self.textdowncolour)
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				self.o_pos = self:GetLocalPosition()
				self:TransitPosition(self.o_pos + self.clickoffset, nil, nil, 0.1)
				self.down = true
				if self.whiledown then
					self:StartUpdating()
				end
				if self.ondown then
					self.ondown()
				end
			end
		else
			if self.down then
				self.text:TransitColour(self.textfocuscolour)
				self.down = false
                self:ResetPreClickPosition()
				if self.onclick then
					self.onclick()
				end
				self:StopUpdating()
			end
		end

		return true
	end

end

-- Will only run if the button is manually told to start updating: we don't want a bunch of unnecessarily updating widgets
function GButton:OnUpdate(dt)
	if self.down then
		if self.whiledown then
			self.whiledown()
		end
	end
end

function GButton:OnGainFocus(noanim)
	GButton._base.OnGainFocus(self)

    if self:IsEnabled() and not self.selected and TheFrontEnd:GetFadeLevel() <= 0 then
    	if self.text then
			if noanim then
				self.text:SetColour(self.textfocuscolour)
			else
				self.text:TransitColour(self.textfocuscolour)
			end
		end
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction())
	end

    if self.ongainfocus then
        self.ongainfocus(self:IsEnabled())
    end
end

function GButton:ResetPreClickPosition()
	if self.o_pos then
		self:TransitPosition(self.o_pos, nil, nil, 0.1)
        self.o_pos = nil
    end
end

function GButton:OnLoseFocus(noanim)
	GButton._base.OnLoseFocus(self)

	if self:IsEnabled() and not self.selected then
		if noanim then
			self.text:SetColour(self.textcolour)
		else
			self.text:TransitColour(self.textcolour)
		end
	end
	self:ResetPreClickPosition()

	self.down = false

    if self.onlosefocus then
        self.onlosefocus(self:IsEnabled())
    end
end

function GButton:OnEnable(noanim)
	if not self.focus and not self.selected then --Note(Peter):This causes the disabled font to remain on an enabled text button, if it has focus (EG: When you click on a button and the button is temporarily disabled). Why do we check the focus here?
		if noanim then
			self.text:SetColour(self.textcolour)
		else
			self.text:TransitColour(self.textcolour)
		end
	    self.text:SetFont(self.font)
	end
end

function GButton:OnDisable(noanim)
	if noanim then
		self.text:SetColour(self.textdisabledcolour)
	else
		self.text:TransitColour(self.textdisabledcolour)
	end
    self.text:SetFont(self.fontdisabled)
end

-- Calling "Select" on a button makes it behave as if it were disabled (i.e. won't respond to being clicked), but will still be able
-- to be focused by the mouse or controller. The original use case for this was the page navigation buttons: when you click a button
-- to navigate to a page, you select that page and, because you're already on that page, the button for that page becomes unable to
-- be clicked. But because fully disabling the button creates weirdness when navigating with a controller (disabled widgets can't be
-- focused), we have this new state, Selected.
-- NB: For image buttons, you need to set the image_selected variable. Best practice is for this to be the same texture as disabled.
function GButton:Select(noanim)
	self.selected = true
	self:OnSelect(noanim)
end

-- This is roughly equivalent to calling Enable after calling Disable--it cancels the Selected state. An unselected button will behave normally.
function GButton:Unselect(noanim)
	self.selected = false
	self:OnUnselect(noanim)
end

-- This is roughly equivalent to OnDisable
function GButton:OnSelect(noanim)
	if noanim then
		self.text:SetColour(self.textselectedcolour)
	else
		self.text:TransitColour(self.textselectedcolour)
	end
    if self.onselect then
        self.onselect()
    end
end

-- This is roughly equivalent to OnEnable
function GButton:OnUnselect(noanim)
	if self:IsEnabled() then
		if self.focus then
			if self.text then
				if noanim then
					self.text:SetColour(self.textfocuscolour)
				else
					self.text:TransitColour(self.textfocuscolour)
				end
			end
		else
			self:OnLoseFocus()
		end
	else
		self:OnDisable()
	end
    if self.onunselect then
        self.onunselect()
    end
end

function GButton:IsSelected()
	return self.selected
end

function GButton:SetOnClick( fn )
    self.onclick = fn
end

function GButton:SetOnSelect( fn )
    self.onselect = fn
end

function GButton:SetOnUnSelect( fn )
    self.onunselect = fn
end

function GButton:SetOnUnselect( fn )
    self.onunselect = fn
end

function GButton:SetOnDown( fn )
	self.ondown = fn
end

function GButton:SetWhileDown( fn )
	self.whiledown = fn
end

function GButton:SetFont(font)
	self.font = font
	if self:IsEnabled() then
		self.text:SetFont(font)
		if self.text_shadow then
			self.text_shadow:SetFont(font)
		end
	end
end

function GButton:SetDisabledFont(font)
	self.fontdisabled = font
	if not self:IsEnabled() then
		self.text:SetFont(font)
		if self.text_shadow then
			self.text_shadow:SetFont(font)
		end
	end
end

function GButton:SetTextColour(r, g, b, a)
	if type(r) == "number" then
		self.textcolour = {r, g, b, a}
	else
		self.textcolour = r
	end

	if self:IsEnabled() and not self.focus and not self.selected then
		self.text:SetColour(self.textcolour, true)
	end
end

function GButton:SetTextFocusColour(r, g, b, a)
	if type(r) == "number" then
		self.textfocuscolour = {r, g, b, a}
	else
		self.textfocuscolour = r
	end
	self.textdowncolour = self.textfocuscolour

	if self.focus and not self.down and not self.selected then
		self.text:SetColour(self.textfocuscolour, true)
	end
end

-- 注意，SetTextFocusColour会覆盖down的颜色，请先设置focus的颜色
function GButton:SetTextDownColour(r, g, b, a)
	if type(r) == "number" then
		self.textdowncolour = {r, g, b, a}
	else
		self.textdowncolour = r
	end

	if self.focus and self.down and not self.selected then
		self.text:SetColour(self.textdowncolour, true)
	end
end

function GButton:SetTextDisabledColour(r, g, b, a)
	if type(r) == "number" then
		self.textdisabledcolour = {r, g, b, a}
	else
		self.textdisabledcolour = r
	end

	if not self:IsEnabled() then
		self.text:SetColour(self.textdisabledcolour, true)
	end
end

function GButton:SetTextSelectedColour(r, g, b, a)
	if type(r) == "number" then
		self.textselectedcolour = {r, g, b, a}
	else
		self.textselectedcolour = r
	end

	if self.selected then
		self.text:SetColour(self.textselectedcolour, true)
	end
end

function GButton:SetTextSize(sz)
	self.size = sz
	self.text:SetSize(sz)
	if self.text_shadow then self.text_shadow:SetSize(sz) end
end

function GButton:GetText()
    return self.text:GetString()
end

function GButton:SetText(msg, dropShadow, dropShadowOffset)
    if msg then
    	self.name = msg or "button"
        self.text:SetString(msg)
        self.text:Show(-1)
        if self:IsEnabled() then
			self.text:SetColour(self.selected and self.textselectedcolour or (self.focus and self.textfocuscolour or self.textcolour), true)
		else
			self.text:SetColour(self.textdisabledcolour, true)
		end

		if dropShadow then
			if self.text_shadow == nil then
				self.text_shadow = self:AddChild(GText(self.font, self.size or 40))
				self.text_shadow:SetVAlign(ANCHOR_MIDDLE)
				self.text_shadow:SetColour(0.1, 0.1, 0.1, 1)
				local offset = dropShadowOffset or {-2, -2}
				self.text_shadow:SetPosition(offset[1], offset[2])
			    self.text:MoveToFront()
			end
		    self.text_shadow:SetString(msg)
		end
    else
        self.text:Hide(-1)
        if self.text_shadow then self.text_shadow:Hide(-1) end
    end
end

function GButton:SetHelpTextMessage(str)
	if str then
		self.help_message = str
	end
end

function GButton:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}
	if (not self:IsSelected() or self.AllowOnControlWhenSelected) and self.help_message ~= "" then
    	table.insert(t, TheInput:GetLocalizedControl(controller_id, self.control, false, false ) .. " " .. self.help_message)
    end
	return table.concat(t, "  ")
end

return GButton