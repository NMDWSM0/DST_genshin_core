local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local Button = require "widgets/genshin_widgets/Gbutton"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"
local ScrollArea = require "widgets/scrollarea"

local SortItem = Class(Button, function (self, atlas, image_normal, image_highlight, image_selected, name)
    Button._ctor(self)
    self.bg = self:AddChild(Image(atlas, image_normal))
    self.bg:SetScale(0.8, 0.8, 0.8)
    self._selected = false

    self.highlight_scale = 1.01
    self.base_scale = 1

    self.atlas = atlas
    self.image_normal = image_normal
    self.image_highlight = image_highlight
    self.image_selected = image_selected

    self.indextext = self:AddChild(Text("genshinfont", 32, nil, {132/255, 215/255, 28/255, 1}))
    self.indextext:SetHAlign(ANCHOR_LEFT)
    self.indextext:SetVAlign(ANCHOR_MIDDLE)
    self.indextext:SetRegionSize(400, 80)
    self.indextext:EnableWordWrap(true)
    self.indextext:SetPosition(-8, -2, 0)
    self.indextext:Hide(-1)

    self.name = name
    self.nametext = self:AddChild(Text("genshinfont", 30, name, {236/255, 229/255, 216/255, 1}))
    self.nametext:SetHAlign(ANCHOR_LEFT)
    self.nametext:SetVAlign(ANCHOR_MIDDLE)
    self.nametext:SetRegionSize(380, 80)
    self.nametext:EnableWordWrap(true)
    self.nametext:SetPosition(10, -1, 0)
end)

function SortItem:OnGainFocus()
    if not self._selected and not self.big then
        self:ScaleTo(self.base_scale, self.highlight_scale, .25)
        self.big = true
        self.bg:SetTexture(self.atlas, self.image_highlight)
    end
end

function SortItem:OnLoseFocus()
    if not self._selected and self.big then
        if not self.highlight then
            self:ScaleTo(self.highlight_scale, self.base_scale, .15)
        end
        self.big = false
        self.bg:SetTexture(self.atlas, self.image_normal)
    end
end

function SortItem:ChangeToSelect(index)
    self._selected = true
    self.bg:SetTexture(self.atlas, self.image_selected)
    self.indextext:Show(-1)
    self.indextext:SetString(index or 1)
    self.nametext:SetColour(66/255, 75/255, 92/255, 1)
end

function SortItem:ChangeToNormal()
    self._selected = false
    self.bg:SetTexture(self.atlas, self.image_normal)
    self.indextext:Hide(-1)
    self.nametext:SetColour(236/255, 229/255, 216/255, 1)
end

local max_choosenum = 2
local s = {
    "atk",         --小攻击
    "atk_per",     --大攻击
    "def",         --小防御
    "def_per",     --大防御
    "hp",          --小生命
    "hp_per",      --大生命
    "crit_rate",   --暴击
    "crit_dmg",    --暴伤
    "mastery",     --元素精通
    "recharge",    --元素充能效率
    "pyro",        --火伤
    "cryo",        --冰伤
    "hydro",       --水伤
    "electro",     --雷伤
    "anemo",       --风伤
    "geo",         --岩伤
    "dendro",      --草伤
    "physical",    --物伤
}

local Artifacts_SortPanel = Class(Widget, function(self, owner, parent)
    Widget._ctor(self, "Artifacts_SortPanel")
    self.owner = owner
    self.pr = parent
----------------------------------------------------------
    self.bg = self:AddChild(Image("images/ui/art_sort_bg.xml", "art_sort_bg.tex"))
    self.bg:SetScale(0.8, 0.8, 0.8)

    local titlestr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "排序方式" or "Sort Order"
    self.title = self:AddChild(Text("genshinfont", 35, titlestr, {211/255, 188/255, 142/255, 1}))
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:SetRegionSize(440, 80)
    self.title:EnableWordWrap(true)
    self.title:SetPosition(0, 320, 0)

    local subtitlestr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "属性排序规则" or "Sort by Attributes"
    self.subtitle = self:AddChild(Text("genshinfont", 35, subtitlestr, {187/255, 185/255, 178/255, 1}))
    self.subtitle:SetHAlign(ANCHOR_LEFT)
    self.subtitle:SetVAlign(ANCHOR_MIDDLE)
    self.subtitle:SetRegionSize(440, 80)
    self.subtitle:EnableWordWrap(true)
    self.subtitle:SetPosition(0, 260, 0)

    self.scrollarea = self:AddChild(ScrollArea(480, 540, 1400))
    self.scrollarea:SetPosition(0, -30, 0)

    self.select_num = 0
    self.selects = {}
    self.btns = {}
    local number = 0
    for j = 1, #s do
        local k = s[j]
        local v = TUNING.ARTIFACTS_TYPE[k]
        number = number + 1
        local name = v
        if string.find(k, "per") ~= nil then
            name = v..(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "百分比" or " Percentage")
        end
        self.btns[k] = SortItem("images/ui/art_sortitem.xml", "art_sortitem_normal.tex", "art_sortitem_highlight.tex", "art_sortitem_selected.tex", name)
        self.scrollarea:AddItem(self.btns[k], number, 64)
        self.btns[k]:SetPosition(0, -10 - 60 * (number - 1), 0)
        self.btns[k]:SetOnClick(function ()
            if not self.btns[k]._selected then  --原本没有选中
                if self.select_num >= max_choosenum then
                    --self.owner.components.talker:Say(STRINGS.ARTIFACTS_SORTITEM_LIMIT)
                    self.parent.parent.parent.toast_screen:ShowToast(STRINGS.ARTIFACTS_SORTITEM_LIMIT)
                    return
                end
                local index = 0
                for i = 1, max_choosenum do
                    if self.selects[tostring(i)] == nil then
                        self.selects[tostring(i)] = k
                        self.select_num = self.select_num + 1
                        index = i
                        break
                    end
                end
                self.btns[k]:ChangeToSelect(index)
            else
                for i = 1, max_choosenum do
                    if self.selects[tostring(i)] == k then
                        self.selects[tostring(i)] = nil
                        self.select_num = self.select_num - 1
                        break
                    end
                end
                self.btns[k]:ChangeToNormal()
            end
        end)
    end
    self.scrollarea:UpdateContentHeight()

    local string = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "确认筛选" or "Confirm Filter"
    self.confirm_sort = self:AddChild(GMultiLayerButton(GetDefaultGButtonConfig("light", "xxlong", "ok")))
    self.confirm_sort:SetText(string)
    self.confirm_sort:SetPosition(0, -334, 0)
    self.confirm_sort:SetScale(0.8, 0.8, 0.8)
    self.confirm_sort:SetOnClick(function()
        local final_sortkeys = {}
        for i = 1, self.select_num do
            table.insert(final_sortkeys, self.selects[tostring(i)])
        end
        self.pr:SetSortKeys(final_sortkeys)
        self.pr:HideTwoPanels()
    end)
end)

return Artifacts_SortPanel