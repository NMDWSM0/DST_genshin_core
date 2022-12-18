local Widget = require "widgets/genshin_widgets/Gwidget"
local Image = require "widgets/genshin_widgets/Gimage"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"
local ScrollArea = require "widgets/scrollarea"

local Artifacts_Scroll = Class(Widget, function(self, listwidth, listheight, artitems, iteminfo, scrollbar_offset, scrollbar_height_offset)
    Widget._ctor(self, "Artifacts_Scroll")

    if artitems == nil then
        artitems = {}
    end
    self.ori_info = iteminfo or {x_pos = {-37 - 64 - 10, -37, 37, 37 + 64 + 10}, height = 64, padding_vertical = 10}

    self.scrollarea = self:AddChild(ScrollArea(listwidth, listheight, 128 * 250, true))

    --AddItem(item, level, selfheight, fontsize)
    self:BuildItems(artitems, self.ori_info)

    self.scrollbar_offset = {
        listwidth / 2 + (scrollbar_offset or 0),
        0,
    }
    self.scrollbar_height = listheight + (scrollbar_height_offset or 0)
    self:BuildScrollBar()
end)

function Artifacts_Scroll:CompletelyChangeItem(artitems, iteminfo)
    if iteminfo ~= nil then
        self.ori_info = iteminfo
    end
	self:BuildItems(artitems, self.ori_info)
    self:ResetScroll()
end

--[[
    iteminfo = {
        x_pos,
        height,
        padding_vertical,
    }
]]

function Artifacts_Scroll:BuildItems(artitems, iteminfo)
    self.scrollarea:ClearItemsInfo(true)
    local paddings = {10}
    for j = 1, 250 do
        for i = 1, 4 do
            local index = 4 * (j - 1) + i
            if artitems[index] ~= nil then
                self.scrollarea:AddItem(artitems[index], j, iteminfo.height)
                artitems[index]:SetPosition(iteminfo.x_pos[i], 0, 0)
            else
                break
            end
        end
        table.insert(paddings, iteminfo.padding_vertical)
    end
    self.scrollarea:SetItemAutoPadding(paddings)
    self.scrollarea:Reset()
end

local bar_width_scale_factor = 1

function Artifacts_Scroll:BuildScrollBar()
	self.scroll_bar_container = self:AddChild(Widget("scroll-bar-container"))
    self.scroll_bar_container:SetPosition(unpack(self.scrollbar_offset))

    local line_height = self.scrollbar_height
    self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/global_redux.xml", "scrollbar_bar.tex"))
    self.scroll_bar_line:ScaleToSize(11 * bar_width_scale_factor, line_height)
    self.scroll_bar_line:SetPosition(0, 0)

    self.position_marker = self.scroll_bar_container:AddChild(ImageButton("images/global_redux.xml", "scrollbar_handle.tex"))
    self.position_marker.scale_on_focus = false
    self.position_marker.move_on_click = false
    self.position_marker.show_stuff = true
    self.position_marker:SetPosition(0, self.scrollbar_height / 2)
    self.position_marker:SetScale(bar_width_scale_factor*0.3, bar_width_scale_factor*0.3, 1)
    self.position_marker:SetOnDown( function()
        TheFrontEnd:LockFocus(true)
        self.dragging = true
    end)
    self.position_marker:SetWhileDown( function()
		self:DoDragScroll()
    end)
    self.position_marker.OnLoseFocus = function()
        --do nothing OnLoseFocus
    end
    self.position_marker:SetOnClick( function()
        self.dragging = nil
        TheFrontEnd:LockFocus(false)
        self:RefreshMarkerPosition()
    end)

    self.scroll_bar_container:Hide(-1)
end

function Artifacts_Scroll:DoDragScroll()
    if not self:CanScroll() then
        return
    end
    --Check if we're near the scroll bar
    local marker = self.position_marker:GetWorldPosition()
	local DRAG_SCROLL_X_THRESHOLD = 150
    if math.abs(TheFrontEnd.lastx - marker.x) <= DRAG_SCROLL_X_THRESHOLD then
		--Note(Peter): Forgive me... I'm abusing the setting of local positions and getting of world positions to get the world(screen) space extents of the scroll bar so I can compare it to the mouse position
        self.position_marker:SetPosition(0, self:GetSlideStart())
        marker = self.position_marker:GetWorldPosition()
        local start_y = marker.y
        self.position_marker:SetPosition(0, self:GetSlideStart() - self:GetSlideRange())
        marker = self.position_marker:GetWorldPosition()
        local end_y = marker.y

        local pos_rate = math.clamp( (start_y - TheFrontEnd.lasty)/(start_y - end_y), 0, 1 )
        local scroll_amt = self.scrollarea.view_offset - pos_rate * self.scrollarea.max_offset
        self.scrollarea:Scroll(-scroll_amt)
        self:RefreshMarkerPosition()
    else
		-- Far away from the scroll bar, revert to original pos
        --self.scrollarea:Reset()
    end
end

function Artifacts_Scroll:CanScroll()
	return self.scrollarea.max_offset > 0
end

function Artifacts_Scroll:GetPositionScale()
	return self.scrollarea.view_offset / self.scrollarea.max_offset
end

function Artifacts_Scroll:GetSlideStart()
	return self.scrollbar_height / 2
end

function Artifacts_Scroll:GetSlideRange()
	return self.scrollbar_height
end

function Artifacts_Scroll:OnControl(control, down, force)
    if Artifacts_Scroll._base.OnControl(self, control, down) then return true end

    if down and ((self.focus) or force) then
        if control == CONTROL_SCROLLBACK then
            self.scrollarea:Scroll(-50, true)
            return true
        elseif control == CONTROL_SCROLLFWD then
            self.scrollarea:Scroll(50, true)
            return true
        end
    end

    if self:CanScroll() then
		self.scroll_bar_container:Show()
		self:RefreshMarkerPosition()
	else
		self.scroll_bar_container:Hide()
	end
end

function Artifacts_Scroll:RefreshMarkerPosition()
    self.position_marker:SetPosition(0, self:GetSlideStart() - self:GetPositionScale() * self:GetSlideRange())
end

function Artifacts_Scroll:ResetScroll()
	self.position_marker:SetPosition(0, self.scrollbar_height / 2)
    if self:CanScroll() then
		self.scroll_bar_container:Show()
	else
		self.scroll_bar_container:Hide()
	end
    self.scrollarea:Reset()
end

return Artifacts_Scroll