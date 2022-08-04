local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Button = require("widgets/button")

local constellation_image_content = Class(Widget, function(self, owner, atlas, texture, positions, lines)
    Widget._ctor(self, nil)
	self.owner = owner
    
    self.image = self:AddChild(Image(atlas, texture))
    self.lineimage = self:AddChild(Image(lines..".xml", "constellation_lines.tex"))

    self.stars = {}
    for i = 1, 6 do
        local star = self:AddChild(Image("images/ui/constellation_unlightened.xml", "constellation_unlightened.tex"))
        star:SetScale(0.25, 0.25, 0.25)
        star:SetPosition(positions[i][1], positions[i][2], 0)
        table.insert(self.stars, star)
    end
end)

local constellation_image = Class(Button, function(self, owner, atlas, texture, positions, lines)
    Button._ctor(self, nil)
	self.owner = owner
    self.scale_on_focus = false  --禁止缩放
	self.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
    self:SetScissor(-800, -360, 1600, 720)

    if positions == nil then
        positions = TUNING.DEFAULT_CONSTELLATION_POSITION
    end
    
    self.content = self:AddChild(constellation_image_content(owner, atlas, texture, positions, lines))
    self.content:SetPosition(0, 0, 0)
    self.content:SetScale(0.7, 0.7, 0.7)
    --默认参数 0.7
    --自动计算焦点位置
    self.offset = {}
    for i = 1, 6 do
        local x_offset = -2 * positions[i][1]
        local y_offset = -2 * positions[i][2]
        table.insert(self.offset, {x_offset, y_offset})
    end

    self.current_focus = 0
end)

function constellation_image:FocusOn(level)
    if level == self.current_focus then
        return
    end

    if level == nil or type(level) ~= "number" or level < 1 or level > 6 then
        self.content:MoveTo(self.content:GetPosition(), Vector3(0, 0, 0), 0.4)
        self.content:ScaleTo(2, 0.7, 0.4)
        self.content.image:TintTo({r=1, g=1, b=1, a=0.1}, {r=1, g=1, b=1, a=1}, 0.4)
    else
        self.content:MoveTo(self.content:GetPosition(), Vector3(self.offset[level][1], self.offset[level][2], 0), 0.4)
        if self.current_focus == 0 then
            self.content:ScaleTo(0.7, 2, 0.4)
            self.content.image:TintTo({r=1, g=1, b=1, a=1}, {r=1, g=1, b=1, a=0.1}, 0.4)
        end
    end
    self.current_focus = level
end

function constellation_image:Unlock(level) 
    if level == nil or type(level) ~= "number" or level < 1 or level > 6 then
        return
    end
    self.content.stars[level]:SetTexture("images/ui/constellation_lightened.xml", "constellation_lightened.tex")
end

return constellation_image