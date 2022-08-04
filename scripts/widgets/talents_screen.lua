local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local TalentsPopup = require "widgets/talents_popup"
local TalentsButton = require "widgets/talents_button"
local TalentsUpgradeWidget = require "widgets/talents_upgrade_widget"

local talents_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	
    self.path = owner.talents_path or "images/ui/talents_traveler"
    self.description = owner.talents_description or TUNING.DEFAULT_TALENTS_DESC
    self.talents_number = owner.talents_number or 1
    --1, 6, 7

    for i = 1, 7 do
        local num = math.min(i, self.talents_number)
        self["talents_button"..string.format("%d", i)] = self:AddChild(TalentsButton(self.path.."/talent_icon_"..string.format("%d", num)..".xml", "talent_icon_"..string.format("%d", num)..".tex", self.description.titlename[num]))
        self["talents_button"..string.format("%d", i)]:SetPosition(580, 320 - 75*i, 0)
        self["talents_button"..string.format("%d", i)]:SetOnClick(function() self:ShowTalent(i) end)
        if i > self.talents_number then
            self["talents_button"..string.format("%d", i)]:Hide()
        end
    end

    ------------------------------------------------------------------------
    --popup弹出
    self.talents_popup = self:AddChild(TalentsPopup(self.owner, self, self.path))
    self.talents_popup:SetScale(0.8, 0.8, 0.8)
    self.talents_popup:SetPosition(-540, -20, 0)
    self.talents_popup:Hide()

    ------------------------------------------------------------------------
    --升级界面
    self.upgradewidget = self:AddChild(TalentsUpgradeWidget(self.owner))
    self.upgradewidget:Hide()
    
    -----------------------------------------------------------------------
    self.inst:ListenForEvent("talentsleveldirty", function() 
        local TalentsComponent = TheNet:GetIsServer() and self.owner.components.talents or self.owner.replica.talents
        if TalentsComponent == nil then
            return
        end
        self:UpdateTalentsLevel()
    end, owner)
end)

function talents_screen:ShowPopup(num)
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --显示命之座详细四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
        self.parent.mainclose,
	}
    --显示popup界面
    self.talents_popup:ShowLevel(num)
    self.talents_popup:Show()
	--隐藏父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Hide()
	end
end

function talents_screen:HidePopup()
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --显示命之座详细四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
        self.parent.mainclose,
	}
	--隐藏popup界面和返回按钮，显示自身除了popup和返回按钮以外的任何东西
    self.talents_popup:Hide()
	--显示父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Show()
	end
end

function talents_screen:ShowTalent(num)
    if num < 1 or num > 7 then
        self:HideTalent()
        return
    end

    local buttons = {
        self.talents_button1,
        self.talents_button2,
        self.talents_button3,
        self.talents_button4,
        self.talents_button5,
        self.talents_button6,
        self.talents_button7,
    }

    buttons[num]:Select()
    self:ShowPopup(num)
	for i = 1, 7 do
        if i ~= num then
            buttons[i]:Unselect()
        end
    end
end

function talents_screen:HideTalent()
    local buttons = {
        self.talents_button1,
        self.talents_button2,
        self.talents_button3,
        self.talents_button4,
        self.talents_button5,
        self.talents_button6,
        self.talents_button7,
    }

	self:HidePopup()
	for i = 1, 7 do
        buttons[i]:Unselect()
    end
end

function talents_screen:ShowUpgradeWidget(talent)
    self.upgradewidget:Show()
    self.upgradewidget:ShowUpgrade(talent)
end

function talents_screen:UpdateTalentsLevel()
    local TalentsComponent = TheNet:GetIsServer() and self.owner.components.talents or self.owner.replica.talents
    self.talents_button1:SetLevel(TalentsComponent:GetTalentLevel(1), TalentsComponent:IsWithExtension(1))
    self.talents_button2:SetLevel(TalentsComponent:GetTalentLevel(2), TalentsComponent:IsWithExtension(2))
    self.talents_button3:SetLevel(TalentsComponent:GetTalentLevel(3), TalentsComponent:IsWithExtension(3))
    self.talents_popup:UpdateTalentsLevel()
end

return talents_screen