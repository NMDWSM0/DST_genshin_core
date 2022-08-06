local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ScrollArea = require "widgets/scrollarea"

local function HasDoubleLine(str)
    if str:find("\n") ~= nil or str:find("\v") ~= nil or str:find("\f") ~= nil or str:find("\r") ~= nil then
        return true
    end
    return false
end

--这个是底下要用的东西
local Talentattr_Text = Class(Widget, function(self, owner, title, value)
    Widget._ctor(self, nil)
    self.owner = owner

    self.bg = self:AddChild(Image("images/ui/talentattr_text_bg.xml", "talentattr_text_bg.tex"))
    self.bg:SetScale(0.8, 0.8, 0.8)

    self.title = self:AddChild(Text("genshinfont", HasDoubleLine(title) and 26 or 36, title or "属性", {211/255, 188/255, 142/255, 1}))
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:EnableWordWrap(true)
    self.title:SetAutoSizingString(title, 300, false)
    self.title:SetRegionSize(300, 52, 0)
    self.title:SetPosition(-85, 0, 0)

    self.value = self:AddChild(Text("genshinfont", HasDoubleLine(value) and 26 or 36, value or "1.00%", {234/255, 228/255, 214/255, 1}))
    self.value:SetHAlign(ANCHOR_RIGHT)
    self.value:SetVAlign(ANCHOR_MIDDLE)
    self.value:EnableWordWrap(true)
    self.value:SetAutoSizingString(value, 235, false)
    self.value:SetRegionSize(235, 52, 0)
    self.value:SetPosition(118, 0, 0)
end)

function Talentattr_Text:SetValue(value)
    self.value:SetAutoSizingString(value, 235, false)
    self.value:SetRegionSize(235, 52, 0)
end

---------------------------------------------------------------------------------------------------
--***********************************************************************************************--
--***********************************************************************************************--
--***********************************************************************************************--
---------------------------------------------------------------------------------------------------



local talents_popup = Class(Widget, function(self, owner, up1parent, path)
    Widget._ctor(self, nil)
	self.owner = owner
    self.up1parent = up1parent
    self.path = path
    self.description = owner.talents_description or TUNING.DEFAULT_TALENTS_DESC
    self.attributes = owner.talents_attributes or {
        value = {
			TUNING.DEFAULTSKILL_NORMALATK,
			TUNING.DEFAULTSKILL_ELESKILL,
			TUNING.DEFAULTSKILL_ELEBURST,
		},
		text = {
			TUNING.DEFAULTSKILL_NORMALATK_TEXT,
			TUNING.DEFAULTSKILL_ELESKILL_TEXT,
			TUNING.DEFAULTSKILL_ELEBURST_TEXT,
		},
        keysort = {
            TUNING.DEFAULTSKILL_NORMALATK_SORT,
			TUNING.DEFAULTSKILL_ELESKILL_SORT,
			TUNING.DEFAULTSKILL_ELEBURST_SORT,
        }
    }

    --变量
    self.current_show = 1

    --UI
    self.bg = self:AddChild(Image("images/ui/talents_popup_bg.xml", "talents_popup_bg.tex"))
    
    self.type = self:AddChild(Text("genshinfont", 30, TUNING.TALENT_TYPE_COMBAT, {211/255, 188/255, 142/255, 1}))
    self.type:SetPosition(0, 440, 0)
    --居中不需要去SetRegionSize

    self.icon = self:AddChild(Image(path.."/talent_icon_1.xml", "talent_icon_1.tex"))
    self.icon:SetPosition(0, 375, 0)
    self.icon:SetScale(0.44, 0.44, 0.44)

    self.title = self:AddChild(Text("genshinfont", 36, self.description.titlename[1], {211/255, 188/255, 142/255, 1}))
    self.title:SetPosition(0, 310, 0)

    self.level = self:AddChild(Text("genshinfont", 30, "Lv. 1", {234/255, 228/255, 214/255, 1}))
    self.level:SetPosition(0, 282, 0)

    -----------------------------------------------------------------

    self.infolist = self:AddChild(ScrollArea(500, 520, 2000))
    self.infolist:SetPosition(0, -55, 0)

    self.infolist_items = {}
    self:SetInfoList(1)

    ---------------------------------------------------

    self.attributelist = self:AddChild(ScrollArea(500, 520, 2000))
    self.attributelist:SetPosition(0, -55, 0)
    
    self.attributelist_items = {}
    self:SetAttritubeList(1)

    ------------------------------------------------------------
    --按钮后放出来
    local lan = TUNING.LANGUAGE_GENSHIN_CORE
    self.info_button = self:AddChild(ImageButton("images/ui/talentinfo_btn_"..lan..".xml", "talentinfo_btn_normal_"..lan..".tex", "talentinfo_btn_focus_"..lan..".tex", "talentinfo_btn_selected_"..lan..".tex", "talentinfo_btn_focus_"..lan..".tex", "talentinfo_btn_selected_"..lan..".tex"))
    self.info_button:SetPosition(0, 235, 0)
    self.info_button:SetScale(0.6, 0.6, 0.6)
    self.info_button.clickoffset = Vector3(0, 0, 0)
    self.info_button:SetOnClick(function()
        self.info_button:Select()
        self.attribute_button:Unselect()
        self.infolist:Show()
        self.attributelist:Hide()
    end)

    self.attribute_button = self:AddChild(ImageButton("images/ui/talentattr_btn_"..lan..".xml", "talentattr_btn_normal_"..lan..".tex", "talentattr_btn_focus_"..lan..".tex", "talentattr_btn_selected_"..lan..".tex", "talentattr_btn_focus_"..lan..".tex", "talentattr_btn_selected_"..lan..".tex"))
    self.attribute_button:SetPosition(125, 235, 0)
    self.attribute_button:SetScale(0.6, 0.6, 0.6)
    self.attribute_button.clickoffset = Vector3(0, 0, 0)
    self.attribute_button:SetOnClick(function()
        self.attribute_button:Select()
        self.info_button:Unselect()
        self.infolist:Hide()
        self.attributelist:Show()
    end)

    self.info_button:Select()
    self.attributelist:Hide()
    ------------------------------------------------------------

    local string = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "升级" or "Level Up"
    self.levelup_button = self:AddChild(ImageButton("images/ui/button_talent_levelup.xml", "button_talent_levelup.tex"))
    self.levelup_button:SetText(string)
    self.levelup_button:SetFont("genshinfont")
    self.levelup_button:SetTextSize(50)
    self.levelup_button:SetTextColour(59/255, 66/255, 85/255, 1)
    self.levelup_button:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    self.levelup_button.text:SetPosition(10, 0, 0)
    self.levelup_button.text:Show()
    self.levelup_button:SetPosition(0, -390, 0)
    self.levelup_button:SetScale(0.8, 0.8, 0.8)
    self.levelup_button.focus_scale = {1.07, 1.07, 1.07}
    self.levelup_button:SetOnClick(function()
        self.up1parent:ShowUpgradeWidget(self.current_show)
    end)

    self.max_level_bg = self:AddChild(Image("images/ui/talents_max_red.xml", "talents_max_red.tex"))
    self.max_level_bg:SetPosition(0, -390, 0)
    self.max_level_bg:SetScale(0.8, 0.8, 0.8)
    self.max_level_text = self:AddChild(Text("genshinfont", 34, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "已达到最大等级" or "Max level reached", {254/255, 203/255, 52/255, 1}))
    self.max_level_text:SetPosition(0, -390, 0)
    self.max_level_text:SetHAlign(ANCHOR_MIDDLE)
    self.max_level_text:SetVAlign(ANCHOR_MIDDLE)
    self.max_level_text:SetRegionSize(430, 100)
    self.max_level_text:EnableWordWrap(true)
    
    self.max_level_bg:Hide()
    self.max_level_text:Hide()
end)

function talents_popup:SetInfoList(num)
    local desc = self.description.content[num]
    
    self.infolist_items = {}
    self.infolist:ClearItemsInfo()

    local paddings = {0}
    local lv = 1
    for k, v in pairs(desc) do
        local textwidget = Text("genshinfont", 36, v.str, v.title and {255/255, 215/255, 128/255, 1} or {234/255, 228/255, 214/255, 1})
        table.insert(self.infolist_items, textwidget)
        textwidget:SetRegionSize(480, 1000, 0)
        textwidget:SetHAlign(ANCHOR_LEFT)
        textwidget:SetVAlign(ANCHOR_TOP)
        textwidget:EnableWordWrap(true)
        self.infolist:AddItem(textwidget, lv, 1000, 36)
        if lv >= 2 then
            table.insert(paddings, v.title and 38 or 8)
        end
        lv = lv + 1
    end
    self.infolist:SetItemAutoPadding(paddings)
end

function talents_popup:SetAttritubeList(num)
    if num < 1 or num > 3 then
        return
    end
    local TalentsComponent = TheWorld.ismastersim and self.owner.components.talents or self.owner.replica.talents
    local talentlevel = TalentsComponent and TalentsComponent:GetTalentLevel(num) or 1

    self.attributelist_items = {}
    self.attributelist:ClearItemsInfo()

    local paddings = {0}
    local lv = 1
    if self.attributes.keysort[num] ~= nil and type(self.attributes.keysort[num]) == "table" then
        for i, k in ipairs(self.attributes.keysort[num]) do
            local v = self.attributes.text[num][k]
            local titlestring = v.title
            local valuenumber
            if type(self.attributes.value[num][k]) == "table" then
                valuenumber = self.attributes.value[num][k][talentlevel]
            else
                valuenumber = self.attributes.value[num][k]
            end
            local valuestring = v.formula(valuenumber or 0)
            local attrtextwidget = Talentattr_Text(self.owner, titlestring, valuestring)
            self.attributelist:AddItem(attrtextwidget, lv, 48)
            self.attributelist_items[k] = attrtextwidget
            if lv >= 2 then
                table.insert(paddings, 6)
            end
            lv = lv + 1
        end
    else 
        for k, v in pairs(self.attributes.text[num]) do
            local titlestring = v.title
            local valuenumber
            if type(self.attributes.value[num][k]) == "table" then
                valuenumber = self.attributes.value[num][k][talentlevel]
            else
                valuenumber = self.attributes.value[num][k]
            end
            local valuestring = v.formula(valuenumber or 0)
            local attrtextwidget = Talentattr_Text(self.owner, titlestring, valuestring)
            self.attributelist:AddItem(attrtextwidget, lv, 48)
            self.attributelist_items[k] = attrtextwidget
            if lv >= 2 then
                table.insert(paddings, 6)
            end
            lv = lv + 1
        end
    end

    self.attributelist:SetItemAutoPadding(paddings)
end

function talents_popup:ShowLevel(num)
    self.current_show = num
    self.infolist:Reset()
    self.type:SetString(num <= 3 and TUNING.TALENT_TYPE_COMBAT or TUNING.TALENT_TYPE_PASSIVE)
    self.icon:SetTexture(self.path.."/talent_icon_"..string.format(num)..".xml", "talent_icon_"..string.format(num)..".tex")
    self.title:SetString(self.description.titlename[num])
    self:SetInfoList(num)
    self:SetAttritubeList(num)
    self:UpdateTalentsLevel()
    if num < 1 or num > 3 then
        self.info_button:Select()
        self.attribute_button:Unselect()
        self.infolist:Show()
        self.attributelist:Hide()
        self.attribute_button:Hide()
    else
        self.attribute_button:Show()
    end
end

function talents_popup:UpdateTalentsLevel()
    local TalentsComponent = TheWorld.ismastersim and self.owner.components.talents or self.owner.replica.talents
    if self.current_show > 3 and self.current_show < 1 then
        self.level:SetString("Lv. 1")
        self.level:SetColour(234/255, 228/255, 214/255, 1)
        return
    end
    local talentlevel = TalentsComponent and TalentsComponent:GetTalentLevel(self.current_show) or 1
    self.level:SetString("Lv. "..string.format("%d", talentlevel))
    if TalentsComponent and TalentsComponent:IsWithExtension(self.current_show) then
        self.level:SetColour(105/255, 231/255, 230/255, 1)
    else
        self.level:SetColour(234/255, 224/255, 214/255, 1)
    end
    if self.current_show >= 1 and self.current_show <= 3 then
        for k, v in pairs(self.attributelist_items) do
            local valuenumber
            if type(self.attributes.value[self.current_show][k]) == "table" then
                valuenumber = self.attributes.value[self.current_show][k][talentlevel]
            else
                valuenumber = self.attributes.value[self.current_show][k]
            end
            local valuestring = (self.attributes.text[self.current_show][k]).formula(valuenumber or 0)
            v:SetValue(valuestring)
        end
    end

    if TalentsComponent and TalentsComponent:CanUpgradeTalent(self.current_show) then
        self.levelup_button:Show()
        self.max_level_bg:Hide()
        self.max_level_text:Hide()
    else
        self.levelup_button:Hide()
        self.max_level_bg:Show()
        self.max_level_text:Show()
    end
end

return talents_popup