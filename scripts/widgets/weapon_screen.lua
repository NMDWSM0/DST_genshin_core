local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ScrollArea = require "widgets/scrollarea"
local WeaponRefineScreen = require "widgets/weapon_refine_screen"

local weapon_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
    self.previous_name = ""
    self.previous_level = 0
	
    --右侧武器详细显示区
    self.detail_list = self:AddChild(ScrollArea(420, 610, 1100))
    self.detail_list:SetPosition(550, 20, 0)
    --武器名字
    self.name_text = Text("genshinfont", 44, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.name_text)
    self.name_text:SetHAlign(ANCHOR_LEFT)
    self.name_text:SetVAlign(ANCHOR_MIDDLE)
    self.name_text:SetRegionSize(400, 80)
    self.name_text:EnableWordWrap(true)
    self.name_text:SetPosition(5, -40, 0)
    --545, 280, 0
    --武器类型
    self.type_text = Text("genshinfont", 28, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.type_text)
    self.type_text:SetHAlign(ANCHOR_LEFT)
    self.type_text:SetVAlign(ANCHOR_MIDDLE)
    self.type_text:SetRegionSize(400, 60)
    self.type_text:EnableWordWrap(true)
    self.type_text:SetPosition(0, -60, 0)
    --武器主属性
    self.main_textbar = Image("images/ui/textbar_light.xml", "textbar_light.tex")
    self.detail_list:AddItem(self.main_textbar)
    self.main_textbar:SetPosition(-45, -100, 0)
    self.main_textbar:SetScale(0.52, 0.8, 0.8)

    self.main_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.main_text)
    self.main_text:SetHAlign(ANCHOR_LEFT)
    self.main_text:SetVAlign(ANCHOR_MIDDLE)
    self.main_text:SetRegionSize(300, 60)
    self.main_text:EnableWordWrap(true)
    self.main_text:SetPosition(-40, -100, 0)

    self.main_number = Text("genshinfont", 35, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.main_number)
    self.main_number:SetHAlign(ANCHOR_RIGHT)
    self.main_number:SetVAlign(ANCHOR_MIDDLE)
    self.main_number:SetRegionSize(300, 60)
    self.main_number:EnableWordWrap(true)
    self.main_number:SetPosition(-45, -100, 0)
    --武器副属性
    self.sub_textbar = Image("images/ui/textbar_light.xml", "textbar_light.tex")
    self.detail_list:AddItem(self.sub_textbar)
    self.sub_textbar:SetPosition(-45, -150, 0)
    self.sub_textbar:SetScale(0.52, 0.8, 0.8)

    self.sub_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub_text)
    self.sub_text:SetHAlign(ANCHOR_LEFT)
    self.sub_text:SetVAlign(ANCHOR_MIDDLE)
    self.sub_text:SetRegionSize(300, 60)
    self.sub_text:EnableWordWrap(true)
    self.sub_text:SetPosition(-40, -150, 0)

    self.sub_number = Text("genshinfont", 35, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub_number)
    self.sub_number:SetHAlign(ANCHOR_RIGHT)
    self.sub_number:SetVAlign(ANCHOR_MIDDLE)
    self.sub_number:SetRegionSize(300, 60)
    self.sub_number:EnableWordWrap(true)
    self.sub_number:SetPosition(-45, -150, 0)

    --星级和等级(假的，全显示五星满级)
    self.stars = Image("images/ui/artifact_stars.xml", "artifact_stars.tex")
    self.detail_list:AddItem(self.stars)
    self.stars:SetPosition(-125, -215, 0)
    self.stars:SetScale(0.8, 0.8, 0.8)

    --精炼等级，没有的显示1
    self.refine_text = Text("genshinfont", 34, nil, {245/255, 225/255, 153/255, 1})
    self.detail_list:AddItem(self.refine_text)
    self.refine_text:SetHAlign(ANCHOR_LEFT)
    self.refine_text:SetVAlign(ANCHOR_MIDDLE)
    self.refine_text:SetRegionSize(300, 60)
    self.refine_text:EnableWordWrap(true)
    self.refine_text:SetPosition(-45, -270, 0)

    --特效文字
    self.effect_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.effect_text)
    self.effect_text:SetHAlign(ANCHOR_LEFT)
    self.effect_text:SetVAlign(ANCHOR_TOP)
    self.effect_text:SetRegionSize(300, 700)
    self.effect_text:EnableWordWrap(true)
    self.effect_text:SetPosition(-45, -640, 0)

    self.detail_list:UpdateContentHeight()

    self.refinescreen = self:AddChild(WeaponRefineScreen(self.owner))
    self.refinescreen:SetPosition(0, 10, 0)

    local string = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "强化" or "Enhance"
    self.refineopen = self:AddChild(ImageButton("images/ui/button_unlock_constellation.xml", "button_unlock_constellation.tex"))
    self.refineopen:SetText(string)
    self.refineopen:SetFont("genshinfont")
    self.refineopen:SetTextSize(56)
    self.refineopen:SetTextColour(59/255, 66/255, 85/255, 1)
    self.refineopen:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    self.refineopen.text:SetPosition(10, 0, 0)
    self.refineopen.text:Show()
    self.refineopen:SetPosition(510, -310, 0)
    self.refineopen:SetScale(0.6, 0.6, 0.6)
    self.refineopen.focus_scale = {1.07, 1.07, 1.07}
    self.refineopen:SetOnClick(function()
        self.refinescreen:Show()
        self.refinescreen:UpdateIngredient()
    end)

    self.refinescreen:MoveToFront()
    self.refinescreen:Hide()

    self:StartUpdating()
end)

function weapon_screen:OnUpdate(dt)
    --获取数据
	local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus
    if combatstatus == nil then
        return
    end
    local weapon = combatstatus:GetWeapon()

    if weapon == nil or weapon:HasTag("player") or combatstatus == nil then
        self.name_text:Hide()
        self.type_text:Hide()
        self.main_textbar:Hide()
        self.main_text:Hide()
        self.main_number:Hide()
        self.sub_textbar:Hide()
        self.sub_text:Hide()
        self.sub_number:Hide()
        self.stars:Hide()
        self.refine_text:Hide()
        self.effect_text:Hide()
        self.refineopen:Hide()
        self.previous_name = nil
        self.previous_level = 0
        return
    end

    local refineable = TheWorld.ismastersim and weapon.components.refineable or weapon.replica.refineable
    local current_level = refineable and refineable:GetCurrentLevel() or 1
    if self.previous_name == weapon.prefab and self.previous_level == current_level then
        return
    end
    self.previous_name = weapon.prefab
    self.previous_level = current_level
    
    local name = STRINGS.NAMES[string.upper(weapon.prefab)]
    local damage = math.floor(combatstatus:GetWeaponDmg())
    self.name_text:SetString(name)
    self.main_text:SetString("基础攻击力")
    if TUNING.LANGUAGE_GENSHIN_CORE == "en" then
        self.main_text:SetString("Base ATK")
    end
    self.main_number:SetString(damage)

    self.name_text:Show()
    self.type_text:Show()
    self.main_textbar:Show()
    self.main_text:Show()
    self.main_number:Show()
    self.stars:Show()
    if weapon:HasTag("subtextweapon") then
        local desc = refineable ~= nil and type(weapon.description) == "table" and weapon.description[current_level]
            or (type(weapon.description) == "string" and weapon.description or "")
        local refinestr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "精炼"..current_level.."阶" or "Refinement Rank "..current_level
        self.sub_text:SetString(TUNING.ARTIFACTS_TYPE[weapon.subtext])
        self.sub_number:SetString(weapon.subnumber)
        self.refine_text:SetString(refinestr)
        self.effect_text:SetString(desc)
        self.sub_textbar:Show()
        self.sub_text:Show()
        self.sub_number:Show()
        self.refine_text:Show()
        self.effect_text:Show()
        self.refineopen:Show()
    else
        self.sub_textbar:Hide()
        self.sub_text:Hide()
        self.sub_number:Hide()
        self.refine_text:Hide()
        self.effect_text:Hide()
        self.refineopen:Hide()
    end

    self.detail_list:UpdateContentHeight()
end

return weapon_screen