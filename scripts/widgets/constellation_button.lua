local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"

local constellation_button = Class(ImageButton, function(self, image1_atlas, image1_texture, name)
    ImageButton._ctor(self, image1_atlas, image1_texture, nil, nil, nil, image1_texture, {0.35, 0.35, 0.35})
    self.focus_scale = {0.38, 0.38, 0.38}
    self.normal_scale = {0.35, 0.35, 0.35}

    self.ontint = false

    self.bg_image = self:AddChild(Image("images/ui/constellation_text_bg.xml", "constellation_text_bg.tex"))
    self.bg_image:SetPosition(100, 0, 0)
    self.bg_image:SetScale(0.8, 0.8, 0.8)
    self.bg_image:SetTint(1, 1, 1, 0) --隐藏

    self.name = self:AddChild(Text("genshinfont", 30, name, {236/255, 229/255, 216/255, 1}))
    self.name:SetPosition(175, 0, 0)
    self.name:SetHAlign(ANCHOR_LEFT)
    self.name:SetVAlign(ANCHOR_MIDDLE)
    self.name:SetRegionSize(250, 100)
    self.name:EnableWordWrap(true)

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

return constellation_button