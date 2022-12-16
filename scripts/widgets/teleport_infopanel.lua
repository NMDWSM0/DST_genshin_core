local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Button = require "widgets/button"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"

local origin_size = {x = 321, y = 704}  -- 右侧原始大小

local Teleport_Infopanel = Class(Widget, function(self, owner, w, h)
    Widget._ctor(self, "Teleport_Infopanel")
    self.owner = owner

    local scale = h / origin_size.y  --整体缩放倍率
    local local_y = origin_size.y
    local local_x = (w / h) * local_y
    local widget_x_offset = 0.5 * local_x - 0.5 * origin_size.x
    self:SetScale(scale, scale, scale)

	self.backbg = self:AddChild(ImageButton("images/ui.xml", "blank.tex"))
	self.backbg:ForceImageSize(local_x, local_y)  --(2048, 1024) * 0.8
	self.backbg.scale_on_focus = false  --禁止缩放
	self.backbg.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.backbg:SetOnClick(function()
	    self.parent:HideInfo()
        self:Hide()
	end)
    self.backbg:MoveToBack()

    -------------------------------------------------
    --变量
    self.world_pos = Vector3(0, 0, 0)
    -------------------------------------------------

    self.bg = self:AddChild(Image("images/ui/teleport_bg.xml", "teleport_bg.tex"))
    self.bg:SetPosition(widget_x_offset, 0, 0)

    self.icon = self:AddChild(Image("images/ui/teleport_waypoint_button.xml", "teleport_waypoint_button.tex"))
    self.icon:SetScale(0.65, 0.65, 0.65)
    self.icon:SetPosition(widget_x_offset - 130, 330, 0)

    self.title = self:AddChild(Text("genshinfont", 27, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "传送锚点" or "Teleport Waypoint"
    , {211/255, 188/255, 142/255, 1}))
    self.title:SetPosition(widget_x_offset + 0, 328, 0)
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:SetRegionSize(225, 100)
    self.title:EnableWordWrap(true)
    
    self.custom_text_bg = self:AddChild(Image("images/ui/teleport_loc_bg.xml", "teleport_loc_bg.tex"))
    self.custom_text_bg:SetScale(0.49, 0.49, 0.49)
    self.custom_text_bg:SetPosition(widget_x_offset + 0, 278, 0)

    self.custom_text = self:AddChild(Text("genshinfont", 20, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "永恒大陆" or "The Constant"
    , {103/255, 107/255, 116/255, 1}))
    self.custom_text:SetPosition(widget_x_offset + 18, 277, 0)
    self.custom_text:SetHAlign(ANCHOR_LEFT)
    self.custom_text:SetVAlign(ANCHOR_MIDDLE)
    self.custom_text:SetRegionSize(280, 100)
    self.custom_text:EnableWordWrap(true)

    self.detail_text = self:AddChild(Text("genshinfont", 23, STRINGS.TELEPORT_WAYPOINT_DETAIL, {104/255, 110/255, 123/255, 1}))
    self.detail_text:SetPosition(widget_x_offset + 2, 0, 0)
    self.detail_text:SetHAlign(ANCHOR_LEFT)
    self.detail_text:SetVAlign(ANCHOR_TOP)
    self.detail_text:SetRegionSize(290, 512)
    self.detail_text:EnableWordWrap(true)

    self.confirm_btn = self:AddChild(ImageButton("images/ui/button_tpconfirm.xml", "button_tpconfirm.tex"))
    self.confirm_btn:SetPosition(widget_x_offset + 0, -310, 0)
    self.confirm_btn:SetText(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "传送" or "Teleport")
    self.confirm_btn:SetFont("genshinfont")
    self.confirm_btn:SetTextSize(25)
    self.confirm_btn:SetTextColour(236/255, 229/255, 216/255, 1)
    self.confirm_btn:SetTextFocusColour(236/255, 229/255, 216/255, 1)
    self.confirm_btn.text:SetPosition(10, 0, 0)
    self.confirm_btn.text:Show()
    self.confirm_btn:SetNormalScale({0.49, 0.49, 0.49})
    self.confirm_btn:SetFocusScale({0.51, 0.51, 0.51})
    self.confirm_btn:SetOnClick(function ()
        local x, y, z = self.world_pos:Get()
        -- 关闭地图界面：
        if self.owner ~= nil and self.owner.HUD ~= nil and self.owner.HUD:IsMapScreenOpen() then
            TheFrontEnd:PopScreen()
        end
        --传送
        SendModRPCToServer(GetModRPC("genshintp", "tptowaypoint"), x, y, z)
    end)

    self.close = self:AddChild(ImageButton("images/ui/button_off2.xml", "button_off2.tex"))
    self.close:SetPosition(widget_x_offset + 140, 329, 0)
    self.close:SetScale(0.42, 0.42, 0.42)
    self.close:SetOnClick(function ()
        self.parent:HideInfo()
        self:Hide()
    end)
end)

function Teleport_Infopanel:ShowInfo(world_pos, custom_info)
    self.world_pos = world_pos
    if custom_info ~= nil then
        self.custom_text:SetString(custom_info)
    else

    end
    self:Show()
end

return Teleport_Infopanel