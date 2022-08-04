local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"

local talents_button = Class(ImageButton, function(self, image1_atlas, image1_texture, name)
    ImageButton._ctor(self, image1_atlas, image1_texture, nil, nil, nil, image1_texture, {0.35, 0.35, 0.35})
    self.focus_scale = {0.38, 0.38, 0.38}
    self.normal_scale = {0.35, 0.35, 0.35}

    self.ontint = false

    self.bg_image = self:AddChild(Image("images/ui/talents_text_bg.xml", "talents_text_bg.tex"))
    self.bg_image:SetPosition(-90, 0, 0)
    self.bg_image:SetScale(0.8, 0.8, 0.8)
    self.bg_image:SetTint(1, 1, 1, 0) --隐藏

    self.name = self:AddChild(Text("genshinfont", 28, name, {236/255, 229/255, 216/255, 1}))
    self.name:SetPosition(-250, 10, 0)
    self.name:SetHAlign(ANCHOR_RIGHT)
    self.name:SetVAlign(ANCHOR_MIDDLE)
    self.name:SetRegionSize(400, 100)
    self.name:EnableWordWrap(true)

    self.leveltext = self:AddChild(Text("genshinfont", 28, "Lv. 1", {236/255, 229/255, 216/255, 1}))
    self.leveltext:SetPosition(-200, -12, 0)
    self.leveltext:SetHAlign(ANCHOR_RIGHT)
    self.leveltext:SetVAlign(ANCHOR_MIDDLE)
    self.leveltext:SetRegionSize(300, 100)
    self.leveltext:EnableWordWrap(true)

    self:SetOnSelect(function() 
        self.image:SetScale(self.focus_scale[1], self.focus_scale[2], self.focus_scale[3])
        if self.ontint == false then
            self.bg_image:TintTo({r=1,g=1,b=1,a=0}, {r=1,g=1,b=1,a=0.8}, 0.4)
        end
        self.ontint = true
    end)
    self:SetOnUnSelect(function() 
        self.image:SetScale(self.normal_scale[1], self.normal_scale[2], self.normal_scale[3])
        if self.ontint == true then
            self.bg_image:TintTo({r=1,g=1,b=1,a=0.8}, {r=1,g=1,b=1,a=0}, 0.4)
        end
        self.ontint = false
    end)
    
    self.image:MoveToFront()
end)

function talents_button:SetLevel(level, withextension)
    if level < 1 or level > 15 then
        return
    end
    self.leveltext:SetString("Lv. "..string.format("%d", level))
    if withextension then
        self.leveltext:SetColour(105/255, 231/255, 230/255, 1)
    else
        self.leveltext:SetColour(236/255, 229/255, 216/255, 1)
    end
end

return talents_button