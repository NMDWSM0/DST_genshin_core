local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"

local function GetActualStringHeight(str, maxwidth, fontsize)
    local temptextwidget = Text("genshinfont", fontsize, "")
    temptextwidget:Hide()
    temptextwidget:SetMultilineTruncatedString(str, 100, maxwidth, nil, "...")
    local realwidth, realheight = temptextwidget:GetRegionSize()
    temptextwidget:Kill()
    --print(realwidth, realheight)
    return realheight
end

local ScrollContent = Class(Widget, function(self)
    Widget._ctor(self, nil)

    self.items = {}
    self.heightlevels = {} --保存那些物品之间都是第几级
    self.selfheights = {} --保存物品自身的高度（设定值）
    self.fontsizes = {}  --字体大小，因为获取的字体大小不对
end)

local ScrollArea = Class(Widget, function(self, listwidth, listheight, contentheight, first_top)
    Widget._ctor(self, nil)

    self.height = listheight
    self.width = listwidth
    self.contentheight = contentheight
    self.first_top = first_top or false

    self.bg = self:AddChild(Image("images/ui.xml", "blank.tex")) -- so that we have focus whenever the mouse is over this thing
    self.bg:ScaleToSize(self.width, self.height)
    self:SetScissor(-self.width/2, -self.height/2, self.width, self.height)

    self.scrollcontent = self:AddChild(ScrollContent())
    self.scrollcontent:SetPosition(0, self.height/2 - 20, 0)
    if self.first_top then
        self.scrollcontent:SetPosition(0, self.height/2, 0)
    end

    self.view_offset = 0
    self.max_offset = self.contentheight - self.height
end)

function ScrollArea:AddItem(item, level, selfheight, fontsize)
    if level == nil then
        local last_level = self.scrollcontent.heightlevels[#(self.scrollcontent.heightlevels)] or 0
        level = last_level + 1
    end

    self.scrollcontent:AddChild(item)
    table.insert(self.scrollcontent.items, item)
    table.insert(self.scrollcontent.heightlevels, level)
    table.insert(self.scrollcontent.selfheights, selfheight)
    table.insert(self.scrollcontent.fontsizes, fontsize or 36)

    self:UpdateContentHeight()
end

function ScrollArea:ClearItemsInfo()
    for k, v in pairs(self.scrollcontent.items) do
        if v ~= nil then
            v:Kill()
        end
    end
    self.scrollcontent.items = {}
    self.scrollcontent.heightlevels = {} --保存那些物品之间都是第几级
    self.scrollcontent.selfheights = {} --保存物品自身的高度（设定值）
    self.scrollcontent.fontsizes = {}
    self:UpdateContentHeight()
end

function ScrollArea:GetMaxHeightInLevel(level)
    local maxheight = 0
    for i, v in ipairs(self.scrollcontent.items) do
        if level == self.scrollcontent.heightlevels[i] then
            local height = self.scrollcontent.selfheights[i]
            if v.GetRegionSize ~= nil then --是文字框
                local w, h = v:GetRegionSize()
                height = GetActualStringHeight(v:GetString(), w, self.scrollcontent.fontsizes[i])
                --print(v:GetString(), w, v:GetSize(), height)
            elseif height == nil then
                height = 0 --只能这样了
            end
            maxheight = height > maxheight and height or maxheight
        end
    end
    return maxheight
end

--这句话要在加完所有内部元素之后更新
function ScrollArea:SetItemAutoPadding(paddings)
    --paddings，从level0 ~ level1开始写的表格/固定值，不然默认是默认值
    if #(self.scrollcontent.items) == 0 then
        return
    end

    local current_y = {}
    local default_padding = 10
    for i, v in ipairs(self.scrollcontent.items) do
        local temppadding = default_padding
        local level = self.scrollcontent.heightlevels[i]

        if type(paddings) == "table" and paddings[level] ~= nil then
            temppadding = paddings[level]
        elseif type(paddings) == "number" then
            temppadding = paddings
        end

        if current_y[level] == nil then --这个数字尚且不存在
            if level < 2 then
                current_y[level] = - temppadding
            else
                current_y[level] = current_y[level - 1] - temppadding - self:GetMaxHeightInLevel(level - 1)
            end
        end
        --current_y[level] -- 当前level的顶端y值

        local x = v:GetPosition().x
        local height = self.scrollcontent.selfheights[i]
        if height == nil then
            if v.GetRegionSize ~= nil then
                local width
                width, height = v:GetRegionSize()
            else
                height = 0 --只能这样了
            end
        end
        local y_offset = height / 2
        v:SetPosition(x, current_y[level] - y_offset, 0)
    end
    local max_level = self.scrollcontent.heightlevels[#(self.scrollcontent.items)]
    local y_buttom = current_y[max_level] - self:GetMaxHeightInLevel(max_level)
    local realcontentheight = 0 - y_buttom + 20
    self:UpdateContentHeight(realcontentheight)
end

function ScrollArea:UpdateContentHeight(realcontentheight)
    if realcontentheight == nil then
        local min_y_buttom = 0
        for i, v in ipairs(self.scrollcontent.items) do
            local y_pos = v:GetPosition().y
            local height = self.scrollcontent.selfheights[i]
            local y_buttom = y_pos
            if v.GetRegionSize ~= nil then --是文字框
                local w, h = v:GetRegionSize()
                height = GetActualStringHeight(v:GetString(), w, self.scrollcontent.fontsizes[i])
                y_buttom = y_pos + h / 2 - height
            elseif height ~= nil then
                y_buttom = y_pos - height / 2
            end
            min_y_buttom = y_buttom < min_y_buttom and y_buttom or min_y_buttom
        end
        realcontentheight = 0 - min_y_buttom
    end
    self.contentheight = realcontentheight + 20
    self.max_offset = self.contentheight - self.height
    self:Reset()
end

function ScrollArea:OnControl(control, down, force)
    if ScrollArea._base.OnControl(self, control, down) then return true end

    if down and ((self.focus) or force) then
        if control == CONTROL_SCROLLBACK then
            self:Scroll(-50, true)
            return true
        elseif control == CONTROL_SCROLLFWD then
            self:Scroll(50, true)
            return true
        end
    end
end

function ScrollArea:Scroll(amt, movemarker)
    local prev = self.view_offset

    if self.max_offset <= 0 then
        return false
    end

    -- Do Scroll on list
    self.view_offset = self.view_offset + amt
    if self.view_offset < 0 then
        self.view_offset = 0
        amt = self.view_offset - prev
    elseif self.view_offset > self.max_offset then
        self.view_offset = self.max_offset
        amt = self.view_offset - prev
    end

    local didScrolling = self.view_offset ~= prev

    -- Refresh the view
    local contentpos = self.scrollcontent:GetPosition()
    self.scrollcontent:SetPosition(0, contentpos.y + amt, 0)

    if self.onscrollcb ~= nil then
        self.onscrollcb()
    end
    return didScrolling
end

function ScrollArea:Reset()
    self.scrollcontent:SetPosition(0, self.height/2 - 20, 0)
    if self.first_top then
        self.scrollcontent:SetPosition(0, self.height/2, 0)
    end
    self.view_offset = 0
end

return ScrollArea