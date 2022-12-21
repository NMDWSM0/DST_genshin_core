local easing = require("easing")
local GWidget = require "widgets/genshin_widgets/Gwidget"

--我不知道为什么，单个中文字符输进去就是会没有任何报错的炸掉
--是我的字体有问题吗？
--可是这个中文字哪怕多加一个空格都没问题
local function StringHasChineseChar(str)
    if str == nil then
        return false
    end
    local l = #string.gsub(str, "[^\128-\191]", "")
    return (l ~= 0)
end

local function FixSingleChineseChar(str)
    if StringHasChineseChar(str) and string.len(str) == 3 then  --单个中文字符
        return ' '..str
    end
    return str
end

-- GText
local GText = Class(GWidget, function(self, font, size, text, colour)
    GWidget._ctor(self, "Text")

    -----------------------------------
    -- added area
    self.update_while_paused = true
    -----------------------------------

    self.inst.entity:AddTextWidget()

    self.inst.TextWidget:SetFont(font)
    self.font = font

	self:SetSize(size)

    self:SetColour(colour or { 1, 1, 1, 1 })

    if text ~= nil then
        self:SetString(text)
    end

    self.TransitColor = self.TransitColour
end)

function GText:__tostring()
    return string.format("%s - %s", self.name, self.string or "")
end

function GText:DebugDraw_AddSection(dbui, panel)
    GText._base.DebugDraw_AddSection(self, dbui, panel)
    local DebugPickers = require("dbui_no_package/debug_pickers")

    dbui.Spacing()
    dbui.Text("Text")
    dbui.Indent() do
        local changed, text = dbui.InputText("string", self:GetString())
        if changed then
            self:SetString(text)
        end

        local region_x,region_y = self.inst.TextWidget:GetRegionSize()
        changed, region_x,region_y = dbui.DragFloat3("region size", region_x,region_y, 100, 1, 1000, "%.f")
        if changed then
            self:SetRegionSize(region_x,region_y)
        end

        local colour = DebugPickers.Colour(dbui, "colour", self.colour)
        if colour then
            self:SetColour(colour)
        end

        local face, size = DebugPickers.Font(dbui, "", self.font, self.size)
        if face then
            self:SetFont(face)
            self:SetSize(size)
        end
    end
    dbui.Unindent()
end

--重写SetColour，立即停止渐变改色
function GText:SetColour(r, g, b, a, stop_transit)
    if stop_transit then
        self:CancelColorTo()
    end
    if r ~= nil then
        self.colour = type(r) == "number" and { r, g, b, a } or r
    end
    local o_r, o_g, o_b, o_a = unpack(self.colour)
    local t_r, t_g, t_b, t_a = self:GetTint()
    self.inst.TextWidget:SetColour(o_r * t_r, o_g * t_g, o_b * t_b, o_a * t_a)
end

function GText:GetColour()
    return { unpack(self.colour) }
end

function GText:SetHorizontalSqueeze(squeeze)
    self.inst.TextWidget:SetHorizontalSqueeze(squeeze)
end

function GText:SetFadeAlpha(a, skipChildren)
    if not self.can_fade_alpha then return end

    local t_r, t_g, t_b, t_a = self:GetTint()
    self.inst.TextWidget:SetColour(self.colour[1] * t_r, self.colour[2] * t_g, self.colour[3] * t_b, self.colour[4] * a * t_a)
    GWidget.SetFadeAlpha( self, a, skipChildren )
end

--重写SetAlpha，立即停止渐变改色
function GText:SetAlpha(a, stop_transit)
    if stop_transit then
        self:CancelColorTo()
    end
    self:SetColour(1, 1, 1, a)
end

--重写UpdateAlpha，立即停止渐变改色
function GText:UpdateAlpha(a, stop_transit)
    if stop_transit then
        self:CancelColorTo()
    end
    self.colour[4] = a
    self:SetColour(unpack(self.colour))
end

function GText:SetFont(font)
    self.inst.TextWidget:SetFont(font)
    self.font = font
end

function GText:SetSize(sz)
	if LOC then
		sz = sz * LOC.GetTextScale()
	end
    self.inst.TextWidget:SetSize(sz)
    self.size = sz
end

function GText:GetSize()
    return self.size
end

function GText:SetRegionSize(w,h)
    self.inst.TextWidget:SetRegionSize(w,h)
end

function GText:GetRegionSize()
    return self.inst.TextWidget:GetRegionSize()
end

function GText:ResetRegionSize()
    return self.inst.TextWidget:ResetRegionSize()
end

function GText:SetString(str)
    str = FixSingleChineseChar(str)
    self.string = str
    self.inst.TextWidget:SetString(str or "")
end

function GText:GetString()
    return self.inst.TextWidget:GetString() or ""
end

--WARNING: This is not optimized!
-- Recommend to use only in FE menu screens.
-- Causes infinite loop when used with SetRegionSize!
--
-- maxwidth [optional]: max region width, only works when autosizing
-- maxchars [optional]: max chars from original string
-- ellipses [optional]: defaults to "..."
--
-- Works best specifying BOTH maxwidth AND maxchars!
--
-- How to pick non-arbitrary maxchars:
--  1) Call with only maxwidth, and a super long string of dots:
--     e.g. wdgt:SetTruncatedString(".............................", 30)
--  2) Find out how many dots were actually kept:
--     e.g. print(wdgt:GetString():len())
--  3) Use that number as an estimate for maxchars, or round up
--     a little just in case dots aren't the smallest character
function GText:SetTruncatedString(str, maxwidth, maxchars, ellipses)
	local str_fits = true
    str = str ~= nil and str:match("^[^\n\v\f\r]*") or ""
    if #str > 0 then
        if type(ellipses) ~= "string" then
            ellipses = ellipses and "..." or ""
        end
        if maxchars ~= nil and str:utf8len() > maxchars then
            str = str:utf8sub(1, maxchars)
            self.inst.TextWidget:SetString(str..ellipses)
			str_fits = false
        else
            self.inst.TextWidget:SetString(str)
        end
        if maxwidth ~= nil then
            while self.inst.TextWidget:GetRegionSize() > maxwidth do
                str = str:utf8sub(1, -2)
                self.inst.TextWidget:SetString(str..ellipses)
				str_fits = false
            end
        end
    else
        self.inst.TextWidget:SetString("")
    end
	return str_fits
end

local function IsWhiteSpace(charcode)
    -- 32: space
    --  9: \t
    return charcode == 32 or charcode == 9
end

local function IsNewLine(charcode)
    -- 10: \n
    -- 11: \v
    -- 12: \f
    -- 13: \r
    return charcode >= 10 and charcode <= 13
end

-- maxwidth can be a single number or an array of numbers if maxwidth is different per line
function GText:SetMultilineTruncatedString_Impl(str, maxlines, maxwidth, maxcharsperline, ellipses)
	local str_fits = true
    if str == nil or #str <= 0 then
        self.inst.TextWidget:SetString("")
        return str_fits
    end
    local tempmaxwidth = type(maxwidth) == "table" and maxwidth[1] or maxwidth
    if maxlines <= 1 then
        str_fits = self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, ellipses) -- returns true if the string was truncated
    else
        self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, false)
        local line = self:GetString()
        if #line < #str then
            if IsNewLine(str:byte(#line + 1)) then
                str = str:sub(#line + 2)
            elseif not IsWhiteSpace(str:byte(#line + 1)) then
                local found_white = false
                for i = #line, 1, -1 do
                    if IsWhiteSpace(line:byte(i)) then
                        line = line:sub(1, i)
                        found_white = true
                        break
                    end
                end
                str = str:sub(#line + 1)

                if not found_white then
                    --Testing for finding areas where we've had to split on
                    --print("Warning: ".. line .. " was split on non-whitespace.")
                end
            else
                str = str:sub(#line + 2)
                while #str > 0 and IsWhiteSpace(str:byte(1)) do
                    str = str:sub(2)
                end
            end
            if #str > 0 then
                if type(maxwidth) == "table" then
                    if #maxwidth > 2 then
                        tempmaxwidth = {}
                        for i = 2, #maxwidth do
                            table.insert(tempmaxwidth, maxwidth[i])
                        end
                    elseif #maxwidth == 2 then
                        tempmaxwidth = maxwidth[2]
                    end
                end
                str_fits = self:SetMultilineTruncatedString_Impl(str, maxlines - 1, tempmaxwidth, maxcharsperline, ellipses)
                self.inst.TextWidget:SetString(line.."\n"..(self.inst.TextWidget:GetString() or ""))
            end
        end
    end

	return str_fits
end

function GText:UpdateOriginalSize()
	self.original_size = self.size
end

function GText:SetMultilineTruncatedString(str, maxlines, maxwidth, maxcharsperline, ellipses, shrink_to_fit, min_shrink_font_size)
    if str == nil or #str <= 0 then
        self.inst.TextWidget:SetString("")
        return
    end

	if shrink_to_fit then
		--ensure that we reset the size back to the original size when we get new text
		if self.original_size ~= nil then
			self:SetSize( self.original_size )
		else
			self.original_size = self:GetSize()
		end
	end

	local str_fits = self:SetMultilineTruncatedString_Impl(str, maxlines, maxwidth, maxcharsperline, ellipses)
	while not str_fits and shrink_to_fit and LOC.GetShouldTextFit() and self:GetSize() > (min_shrink_font_size or 16) do -- the 16 is a semi reasonable "smallest" size that is okay. This is to stop stackoverflow from infinite recursion due to bad string data.
		local new_size = self:GetSize() - 1 --drop size to fit a whole word
		local shrinked_maxlines = math.floor(maxlines * self.original_size / new_size)  -- num lines that fit in original size

		self:SetSize( new_size )
		str_fits = self:SetMultilineTruncatedString_Impl(str, shrinked_maxlines, maxwidth, maxcharsperline, ellipses)
	end
end

function GText:SetAutoSizingString(str, max_width, allow_scaling_up)
-- Note: Use SetMultilineTruncatedString instead of this
    self:SetString(str)
	self.inst.TextWidget:ResetRegionSize()

	self.target_font_size = self:GetSize()
	local w = self:GetRegionSize()

	local scale = allow_scaling_up and (max_width / w) or math.min(1, max_width / w)
	if scale ~= 1 then
		self:SetSize(self.target_font_size * scale)
	end
end

function GText:RemoveAutoSizing()
	self:SetSize(self.target_font_size)
	self.target_font_size = nil
end

function GText:SetVAlign(anchor)
    self.inst.TextWidget:SetVAnchor(anchor)
end

function GText:SetHAlign(anchor)
    self.inst.TextWidget:SetHAnchor(anchor)
end

function GText:EnableWordWrap(enable)
    self.inst.TextWidget:EnableWordWrap(enable)
end

function GText:EnableWhitespaceWrap(enable)
    self.inst.TextWidget:EnableWhitespaceWrap(enable)
end

-----------------------------------------------------------------------
-----------------------------------------------------------------------
-- added functions

--渐变改色结束
function GText:FinishCurrentColor()
    if not self.inst or not self.inst:IsValid() then
        -- sometimes the ent becomes invalid during a "finished" callback, but this gets run anyways.
        return
    end
    local val = self.color_dest
    self.color_t = nil
    self:SetColour(val.r, val.g, val.b, val.a)
end

--取消渐变改色
function GText:CancelColorTo()
	self.color_t = nil
end

--渐变改色开始
function GText:ColorTo(start, dest, duration)
    self.color_start = start or {r = self.colour[1], g = self.colour[2], b = self.colour[3], a = self.colour[4]}
    self.color_dest = dest
    if self.color_start.r == self.color_dest.r and self.color_start.g == self.color_dest.g
        and self.color_start.b == self.color_dest.b and self.color_start.a == self.color_dest.a then
        return
    end
    if duration <= 0 then
        self:SetColour(dest.r, dest.g, dest.b, dest.a)
        return
    end
    self.color_duration = duration
    self.color_t = 0
    self.inst:StartWallUpdatingComponent(self)
end

--更新函数，用于实现渐变改色
function GText:OnWallUpdate(dt)
    if not self.inst:IsValid() then
		self.inst:StopWallUpdatingComponent(self)
		return
    end
    if not self.update_while_paused and TheNet:IsServerPaused() then return end
    if self.color_t then
        self.color_t = self.color_t + dt

        if self.color_t < self.color_duration then
            local r = easing.outCubic( self.color_t, self.color_start.r, self.color_dest.r - self.color_start.r, self.color_duration)
            local g = easing.outCubic( self.color_t, self.color_start.g, self.color_dest.g - self.color_start.g, self.color_duration)
            local b = easing.outCubic( self.color_t, self.color_start.b, self.color_dest.b - self.color_start.b, self.color_duration)
            local a = easing.outCubic( self.color_t, self.color_start.a, self.color_dest.a - self.color_start.a, self.color_duration)
            self:SetColour(r, g, b, a)
        else
            self:FinishCurrentColor()
        end
    end
    if not self.color_t then
        self.inst:StopWallUpdatingComponent(self)
    end
end

--渐变改色接口函数
function GText:TransitColour(r, g, b, a, animtime)
    local dest = type(r) == "number" and { r = r, g = g, b = b, a = a } or {r = r[1], g = r[2], b = r[3], a = r[4]}
    self:CancelColorTo()
    self:ColorTo(nil, dest, animtime or 0.22)
end

--对于Text组件，特有的SetTint
function GText:SetTint(r, g, b, a, stop_transit, ignore_children)
    GWidget.SetTint(self, r, g, b, a, stop_transit, ignore_children)  --GWidget.SetTint
    self:SetColour() --无参setcolour相当于更新颜色，在tint变化后需要做
end

return GText