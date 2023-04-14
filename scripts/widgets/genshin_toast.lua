local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local UIAnim = require "widgets/genshin_widgets/Guianim"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"


local Genshin_Toast = Class(Widget, function(self)
	Widget._ctor(self, "genshin_toast")
    self.toclose = 0
    self.toclick = 0
    
    self.bg = self:AddChild(ImageButton("images/ui/constellation_bg_shadow.xml", "constellation_bg_shadow.tex"))
    self.bg.scale_on_focus = false
    self.bg.move_on_click = false
    self.bg:SetTint(1, 1, 1, 0.4)
    self.bg:SetOnClick(function ()
        self:HideToast()
    end)
    self.bg:SetScale(0.86, 0.86, 0.86)

    self.toast_box = self:AddChild(Image("images/ui/genshin_toast_boxes.xml", "normal.tex"))
    self.toast_box:SetScale(0.82, 0.82, 0.82)

    self.text = self:AddChild(Text("genshinfont", 35, " ", {236/255, 229/255, 216/255, 1}))

    self:HideToast(true)
end)

function Genshin_Toast:ShowToast(str, type, remain_t, clickable_t)
    if not type then
        type = "normal"
    end
    self.toclose = remain_t or 3
    self.toclick = clickable_t or 0.7
    self:Hide(-1)
    self.toast_box:SetTexture("images/ui/genshin_toast_boxes.xml", type..".tex")
    self.text:SetString(str)
    self.bg:Disable()
    self:StartUpdating()
    self:Show()
end

function Genshin_Toast:HideToast(force)
    self.toclose = 0
    self.toclick = 0
    self:Hide(force and -1 or nil)
    self:StopUpdating()
end

function Genshin_Toast:OnUpdate(dt)
    if not self.shown or not self.parent.shown then
        self:HideToast(true)
		return
	end
    self.toclose = self.toclose - dt
    self.toclick = self.toclick - dt
    if self.toclick <= 0 and not self.bg:IsEnabled() then
        self.bg:Enable()
    end
    if self.toclose <= 0 then
        self:HideToast()
    end
end

return Genshin_Toast