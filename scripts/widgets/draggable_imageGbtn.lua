local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local Draggable_GenshinBtn = require "widgets/draggable_genshinbtn"


local Draggable_ImageGBtn = Class(Draggable_GenshinBtn, function(self, atlas, image)
	Draggable_GenshinBtn._ctor(self, "draggable_imageGbtn")
    self.scale_on_focus = false  --禁止缩放
	self.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
    self:SetOnClick()

    self.btn = self:AddChild(ImageButton(atlas, image))
    -- self.btn:SetOnClick(function()
	--     if not self:HasMoved() and self.onclick ~= nil then
    --         self.onclick()
    --     end
	-- end)

end)

function Draggable_ImageGBtn:SetBTNOnClick(func)
    self.btn:SetOnClick(function()
        if not self:HasMoved() then
            func()
        end
    end)
end

function Draggable_ImageGBtn:SetBTNFocusScale(scale)
    self.btn.focus_scale = scale
end

return Draggable_ImageGBtn