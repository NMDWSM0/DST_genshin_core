local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ScrollArea = require "widgets/scrollarea"

local constellation_popup = Class(Widget, function(self, owner, up1parent, path)
    Widget._ctor(self, nil)
	self.owner = owner
    self.up1parent = up1parent
    self.path = path
    self.decription = self.owner.constellation_decription or TUNING.DEFAULT_CONSTELLATION_DESC

    --变量
    self.current_show = 1
    self.can = false

    --UI
    self.bg = self:AddChild(Image("images/ui/constellation_popup_bg.xml", "constellation_popup_bg.tex"))

    self.icon = self:AddChild(Image(path.."/1_disable.xml", "1_disable.tex"))
    self.icon:SetPosition(0, 350, 0)
    self.icon:SetScale(0.44, 0.44, 0.44)
    
    local string = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "激活" or "Activate"
    self.enable_button = self:AddChild(ImageButton("images/ui/button_unlock_constellation.xml", "button_unlock_constellation.tex"))
    self.enable_button:SetText(string)
    self.enable_button:SetFont("genshinfont")
    self.enable_button:SetTextSize(50)
    self.enable_button:SetTextColour(59/255, 66/255, 85/255, 1)
    self.enable_button:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    self.enable_button.text:SetPosition(10, 0, 0)
    self.enable_button.text:Show()
    self.enable_button:SetPosition(0, -390, 0)
    self.enable_button:SetScale(0.8, 0.8, 0.8)
    self.enable_button.focus_scale = {1.07, 1.07, 1.07}
    self.enable_button:SetOnClick(function()
        if self.can == false then
            self.owner.components.talker:Say(TUNING.CONSTELLATION_INGREDIENT_LACK)
            return
        end
        self.up1parent:UnlockConstellation(self.current_show or 0)
    end)
    
    --中间文字-------------------------------------------------------------------
    self.decription_list = self:AddChild(ScrollArea(430, 340, 1000))
    self.decription_list:SetPosition(0, 35, 0)

    --self.titlename = self:AddChild(Text("genshinfont", 40, self.decription.titlename[1], {211/255, 188/255, 142/255, 1}))
    self.titlename = Text("genshinfont", 40, self.decription.titlename[1], {211/255, 188/255, 142/255, 1})
    self.decription_list:AddItem(self.titlename)
    self.titlename:SetPosition(0, 0, 0)
    self.titlename:SetHAlign(ANCHOR_LEFT)
    self.titlename:SetVAlign(ANCHOR_MIDDLE)
    self.titlename:SetRegionSize(430, 100)
    self.titlename:EnableWordWrap(true)

    --self.levelname = self:AddChild(Text("genshinfont", 34, "命之座 第1层", {236/255, 229/255, 216/255, 1}))
    self.levelname = Text("genshinfont", 34, "命之座 第1层", {236/255, 229/255, 216/255, 1})
    self.decription_list:AddItem(self.levelname)
    self.levelname:SetPosition(0, -45, 0)
    self.levelname:SetHAlign(ANCHOR_LEFT)
    self.levelname:SetVAlign(ANCHOR_MIDDLE)
    self.levelname:SetRegionSize(430, 100)
    self.levelname:EnableWordWrap(true)

    --self.content = self:AddChild(Text("genshinfont", 34, self.decription.titlename[1], {128/255, 128/255, 128/255, 1}))
    self.content = Text("genshinfont", 34, self.decription.titlename[1], {128/255, 128/255, 128/255, 1})
    self.decription_list:AddItem(self.content)
    self.content:SetPosition(0, -485, 0)
    self.content:SetHAlign(ANCHOR_LEFT)
    self.content:SetVAlign(ANCHOR_TOP)
    self.content:SetRegionSize(430, 800)
    self.content:EnableWordWrap(true)

    self.decription_list:UpdateContentHeight()
    --------------------------------------------------------------

    self.cannot_unlock_bg = self:AddChild(Image("images/ui/constellation_locked_red.xml", "constellation_locked_red.tex"))
    self.cannot_unlock_bg:SetPosition(0, -390, 0)
    self.cannot_unlock_bg:SetScale(0.8, 0.8, 0.8)
    self.cannot_unlock_text = self:AddChild(Text("genshinfont", 34, "需要先激活", {1, 1, 1, 1}))
    self.cannot_unlock_text:SetPosition(0, -390, 0)
    self.cannot_unlock_text:SetHAlign(ANCHOR_MIDDLE)
    self.cannot_unlock_text:SetVAlign(ANCHOR_MIDDLE)
    self.cannot_unlock_text:SetRegionSize(430, 100)
    self.cannot_unlock_text:EnableWordWrap(true)

    self.unlocked_text = self:AddChild(Text("genshinfont", 34, TUNING.CONSTELLATION_ACTICVATED, {255/255, 204/255, 50/255, 1}))
    self.unlocked_text:SetPosition(0, -390, 0)
    self.unlocked_text:SetHAlign(ANCHOR_MIDDLE)
    self.unlocked_text:SetVAlign(ANCHOR_MIDDLE)
    self.unlocked_text:SetRegionSize(430, 100)
    self.unlocked_text:EnableWordWrap(true)

    self.cannot_unlock_bg:Hide()
    self.cannot_unlock_text:Hide()
    self.unlocked_text:Hide()
    
    self.starneedtitle = self:AddChild(Text("genshinfont", 34, TUNING.CONSTELLATION_STAR_NEEDED, {236/255, 229/255, 216/255, 1}))
    self.starneedtitle:SetPosition(0, -180, 0)
    self.starneedtitle:SetHAlign(ANCHOR_LEFT)
    self.starneedtitle:SetVAlign(ANCHOR_MIDDLE)
    self.starneedtitle:SetRegionSize(430, 100)
    self.starneedtitle:EnableWordWrap(true)

    self.starimage = self:AddChild(Image("images/ui/constellation_star_ui.xml", "constellation_star_ui.tex"))
    self.starimage:SetPosition(0, -260, 0)
    self.starimage:SetScale(0.6, 0.6, 0.6)

    self.starnumber = self:AddChild(Text("genshinfont", 22, "0/1", {59/255, 66/255, 85/255, 1}))
    self.starnumber:SetPosition(0, -304, 0)
    self.starnumber:SetHAlign(ANCHOR_MIDDLE)
    self.starnumber:SetVAlign(ANCHOR_MIDDLE)
    self.starnumber:SetRegionSize(430, 100)
    self.starnumber:EnableWordWrap(true)

-------------------------------------------------------------------------
    self.inst:ListenForEvent("itemget", function() self:CheckIngredient() end, owner)
    self.inst:ListenForEvent("itemlose", function() self:CheckIngredient() end, owner)
end)

function constellation_popup:ShowLevel(level)
    self.current_show = level
    self:Refresh()
    self.decription_list:UpdateContentHeight()
end

function constellation_popup:Refresh()
    local ConstellationComponent = TheNet:GetIsServer() and self.owner.components.constellation or self.owner.replica.constellation
    if ConstellationComponent == nil then
        return
    end

    local activatedlevel = ConstellationComponent:GetActivatedLevel() 
    self.titlename:SetString(self.decription.titlename[self.current_show])
    if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
        self.levelname:SetString("命之座 第"..string.format("%d", self.current_show).."层")
    else
        self.levelname:SetString("Constellation Lv. "..string.format("%d", self.current_show))
    end
    self.content:SetString(self.decription.content[self.current_show])
    if self.current_show > 1 then
        if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
            self.cannot_unlock_text:SetString("需要先激活"..self.decription.titlename[self.current_show-1])
        else
            self.cannot_unlock_text:SetString("Must activate "..self.decription.titlename[self.current_show-1].." first")
        end
    end
    self:CheckIngredient()

    if self.current_show <= activatedlevel then
        self.icon:SetTexture(self.path.."/"..string.format("%d", self.current_show).."_enable.xml", string.format("%d", self.current_show).."_enable.tex")
        self.content:SetColour(1, 1, 1, 1)
        self.enable_button:Hide()
        self.cannot_unlock_bg:Hide()
        self.cannot_unlock_text:Hide()
        self.unlocked_text:Show()
        self.starneedtitle:Hide()
        self.starimage:Hide()
        self.starnumber:Hide()
    elseif self.current_show == activatedlevel + 1 then
        self.icon:SetTexture(self.path.."/"..string.format("%d", self.current_show).."_disable.xml", string.format("%d", self.current_show).."_disable.tex")
        self.content:SetColour(128/255, 128/255, 128/255, 1)
        self.enable_button:Show()
        self.cannot_unlock_bg:Hide()
        self.cannot_unlock_text:Hide()
        self.unlocked_text:Hide()
        self.starneedtitle:Show()
        self.starimage:Show()
        self.starnumber:Show()
    else
        self.icon:SetTexture(self.path.."/"..string.format("%d", self.current_show).."_disable.xml", string.format("%d", self.current_show).."_disable.tex")
        self.content:SetColour(128/255, 128/255, 128/255, 1)
        self.enable_button:Hide()
        self.cannot_unlock_bg:Show()
        self.cannot_unlock_text:Show()
        self.unlocked_text:Hide()
        self.starneedtitle:Show()
        self.starimage:Show()
        self.starnumber:Show()
    end
end

function constellation_popup:CheckIngredient()
    local Inventory = self.owner.replica.inventory
    local has, star_number = Inventory:Has(self.owner.constellation_starname, 1)
    self.starnumber:SetString(star_number.."/1")
    if star_number == 0 then
        self.starnumber:SetColour(255/255, 114/255, 84/255, 1)
        self.can = false
    else
        self.starnumber:SetColour(59/255, 66/255, 85/255, 1)
        self.can = true
    end
end

return constellation_popup