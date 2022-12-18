local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Button = require "widgets/button"
local ImageButton = require "widgets/imagebutton"
local ScrollArea = require "widgets/scrollarea"

local FilterItem = Class(Button, function (self, atlas, image_normal, image_highlight, image_selected, name, iconatlas, iconimage, iconimage2)
    Button._ctor(self)
    self.bg = self:AddChild(Image(atlas, image_normal))
    self.bg:SetScale(0.8, 0.8, 0.8)
    self._selected = false

    self.atlas = atlas
    self.image_normal = image_normal
    self.image_highlight = image_highlight
    self.image_selected = image_selected

    self.iconatlas = iconatlas
    self.iconimage = iconimage
    self.iconimage2 = iconimage2
    self.icon = self:AddChild(Image(iconatlas, iconimage))
    self.icon:SetScale(0.6)
    self.icon:SetPosition(-190, 0, 0)

    self.name = name
    self.nametext = self:AddChild(Text("genshinfont", 30, name, {236/255, 229/255, 216/255, 1}))
    self.nametext:SetHAlign(ANCHOR_LEFT)
    self.nametext:SetVAlign(ANCHOR_MIDDLE)
    self.nametext:SetRegionSize(360, 80)
    self.nametext:EnableWordWrap(true)
    self.nametext:SetPosition(20, -1, 0)
end)

function FilterItem:OnGainFocus()
    if not self._selected and not self.big then
        --self:ScaleTo(self.base_scale, self.highlight_scale, .25)
        self.big = true
        self.bg:SetTexture(self.atlas, self.image_highlight)
    end
end

function FilterItem:OnLoseFocus()
    if not self._selected and self.big then
        -- if not self.highlight then
        --     self:ScaleTo(self.highlight_scale, self.base_scale, .15)
        -- end
        self.big = false
        self.bg:SetTexture(self.atlas, self.image_normal)
    end
end

function FilterItem:ChangeToSelect()
    self._selected = true
    self.bg:SetTexture(self.atlas, self.image_selected)
    if self.iconimage2 ~= nil then
        self.icon:SetTexture(self.iconatlas, self.iconimage2)
    end
    self.nametext:SetColour(66/255, 75/255, 92/255, 1)
end

function FilterItem:ChangeToNormal()
    self._selected = false
    self.bg:SetTexture(self.atlas, self.image_normal)
    if self.iconimage2 ~= nil then
        self.icon:SetTexture(self.iconatlas, self.iconimage)
    end
    self.nametext:SetColour(236/255, 229/255, 216/255, 1)
end

local s = {
    "all",
    "sljy",
    "jyqy",
    "clzx",
    "bfmt",
    "yzmn",
    "rlsn",
    "ygpy",
    "clzy",
    "cbzh",
}

local Artifacts_FilterPanel = Class(Widget, function(self, owner, parent)
    Widget._ctor(self, "Artifacts_FilterPanel")
    self.owner = owner
    self.pr = parent
----------------------------------------------------------
    self.bg = self:AddChild(Image("images/ui/art_filter_bg.xml", "art_filter_bg.tex"))
    self.bg:SetScale(0.8, 0.8, 0.8)

    self.scrollarea = self:AddChild(ScrollArea(480, 540, 1400))
    self.scrollarea:SetPosition(0, 0, 0)
    
    self.btns = {}
    for j = 1, #s do
        local filter = s[j]
        local name = TUNING.ARTIFACTS_SETS[filter]
        if name == nil then
            name = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "全部" or "All"
        end
        local iconatlas = "images/inventoryimages/"..filter..".xml"
        local iconimage = filter.."_flower.tex"
        local iconimage2 = nil
        if filter == "all" then
            iconatlas = "images/ui/articon_all.xml"
            iconimage = "articon_all_normal.tex"
            iconimage2 = "articon_all_selected.tex"
        end
        self.btns[filter] = FilterItem("images/ui/art_filteritem.xml", "art_filteritem_normal.tex", "art_filteritem_highlight.tex", "art_filteritem_selected.tex", name, iconatlas, iconimage, iconimage2)
        self.scrollarea:AddItem(self.btns[filter], j, 60)
        self.btns[filter]:SetPosition(0, -10 - 54 * (j - 1), 0)
        self.btns[filter]:SetOnClick(function ()
            self.btns[filter]:ChangeToSelect()
            for k, v in pairs(self.btns) do
                if k ~= filter then
                    v:ChangeToNormal()
                end
            end

            self.pr:SetFilter(filter)
            self.pr:HideTwoPanels()
        end)
    end
    self.scrollarea:UpdateContentHeight()

    self.btns["all"]:ChangeToSelect()
end)

return Artifacts_FilterPanel