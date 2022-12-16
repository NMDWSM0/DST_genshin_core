local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"

local teleport_waypoint_button = Class(ImageButton, function(self, owner, waypoint_id, world_pos, custom_info)
    ImageButton._ctor(self, "images/ui/teleport_waypoint_button.xml", "teleport_waypoint_button.tex")
    self.focus_scale = {1.15, 1.15, 1.15}
    self.normal_scale = {1, 1, 1}

    self.owner = owner
    self.waypoint_id = waypoint_id
    self.world_pos = world_pos
    self.custom_info = custom_info

    self.ring = self:AddChild(Image("images/ui/tp_select_ring.xml", "tp_select_ring.tex"))
    self.ring:Hide()
    self.ring:SetPosition(-2, 0, 0)

    self:SetOnSelect(function()
        self.image:SetScale(self.focus_scale[1], self.focus_scale[2], self.focus_scale[3])
        self.ring:Show()
    end)
    self:SetOnUnSelect(function()
        self.image:SetScale(self.normal_scale[1], self.normal_scale[2], self.normal_scale[3])
        self.ring:Hide()
    end)

    self:SetScale(1.1, 1.1, 1.1)
    self:StartUpdating()
end)

function teleport_waypoint_button:OnUpdate()
    if not self.parent or not self.parent.minimap or not self.world_pos then
        return
    end

    local scale_multiple = self.parent.minimap:GetZoom()
    if scale_multiple > 5 then
        self:Hide()
    else
        self:Show()
    end

    local x, y, z = self.world_pos:Get()
    local map_x, map_y = self.parent.minimap:WorldPosToMapPos(x, z, 0)
    local screen_width, screen_height = TheSim:GetScreenSize()
    local screen_x = (map_x + 1) * screen_width / 2
    local screen_y = (map_y + 1) * screen_height / 2
    self:SetPosition(screen_x, screen_y)
end

return teleport_waypoint_button