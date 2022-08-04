local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ScrollArea = require "widgets/scrollarea"
local IngredientUI = require "widgets/ingredientui"

local weapon_refine_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
    self.weapon = nil

    self.previous_weapon = nil
    self.previous_level = nil
    self.can = false
    -----------------------------------------------------
	
    self.refine_bg = self:AddChild(Image("images/ui/weapon_refine_bg.xml", "weapon_refine_bg.tex"))
    self.refine_bg:MoveToBack()
    self.refine_bg:SetScale(0.95, 0.95, 0.95)


    self.refineclose = self:AddChild(ImageButton("images/ui/button_off1.xml","button_off1.tex"))
	self.refineclose:SetPosition(722, 313, 0)
	-- self.refineclose:SetScale(1, 1, 1)
	self.refineclose.focus_scale = {1.1,1.1,1.1}
    self.refineclose:SetOnClick(function()
	    self:Hide()
	end)
    
    --武器名字
    self.name_text = self:AddChild(Text("genshinfont", 32, nil, {211/255, 188/255, 142/255, 1}))
    self.name_text:SetHAlign(ANCHOR_LEFT)
    self.name_text:SetVAlign(ANCHOR_MIDDLE)
    self.name_text:SetRegionSize(300, 80)
    self.name_text:EnableWordWrap(true)
    self.name_text:SetPosition(-530, 310, 0)

    --左侧按钮，实际上是摆设因为只有精炼这一项哈哈哈哈哈
    if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_refine = self:AddChild(ImageButton("images/ui/button_refine.xml", "button_refine_selected.tex", "button_refine_selected.tex", nil, "button_refine_selected.tex", "button_profile_selected.tex"))
	else
	    self.button_refine = self:AddChild(ImageButton("images/ui/button_refine.xml", "button_refine_selected_en.tex", "button_refine_selected_en.tex", nil, "button_refine_selected_en.tex", "button_refine_selected_en.tex"))
	end
    self.button_refine:SetPosition(-600, 220, 0)
    self.button_refine:SetScale(0.8, 0.8, 0.8)
    self.button_refine.scale_on_focus = false
	self.button_refine.move_on_click = false

    --等级提示
    self.refine_level_text = self:AddChild(Text("genshinfont",46, nil, {1, 1, 1, 1}))
    self.refine_level_text:SetHAlign(ANCHOR_MIDDLE)
    self.refine_level_text:SetVAlign(ANCHOR_MIDDLE)
    self.refine_level_text:SetRegionSize(400, 80)
    self.refine_level_text:EnableWordWrap(true)
    self.refine_level_text:SetPosition(455, 270, 0)

    local lvstr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "武器精炼等级" or "Weapon Refinement Level"
    self.refine_level_hint = self:AddChild(Text("genshinfont", 28, lvstr, {211/255, 188/255, 142/255, 1}))
    self.refine_level_hint:SetHAlign(ANCHOR_MIDDLE)
    self.refine_level_hint:SetVAlign(ANCHOR_MIDDLE)
    self.refine_level_hint:SetRegionSize(400, 80)
    self.refine_level_hint:EnableWordWrap(true)
    self.refine_level_hint:SetPosition(455, 235, 0)

    --右侧武器描述区
    self.detail_list = self:AddChild(ScrollArea(620, 300, 1100))
    self.detail_list:SetPosition(460, 55, 0)
    --武器effect
    self.effect_title = Text("genshinfont", 38, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.effect_title)
    self.effect_title:SetHAlign(ANCHOR_MIDDLE)
    self.effect_title:SetVAlign(ANCHOR_TOP)
    self.effect_title:SetRegionSize(600, 80)
    self.effect_title:EnableWordWrap(true)
    self.effect_title:SetPosition(0, 0, 0)

    self.effect_text1 = Text("genshinfont", 32, nil, {234/255, 228/255, 214/255, 1})
    self.detail_list:AddItem(self.effect_text1)
    self.effect_text1:SetHAlign(ANCHOR_LEFT)
    self.effect_text1:SetVAlign(ANCHOR_TOP)
    self.effect_text1:SetRegionSize(600, 400)
    self.effect_text1:EnableWordWrap(true)
    self.effect_text1:SetPosition(0, 0, 0)

    self.effect_text2 = Text("genshinfont", 32, nil, {234/255, 228/255, 214/255, 1})
    self.detail_list:AddItem(self.effect_text2)
    self.effect_text2:SetHAlign(ANCHOR_LEFT)
    self.effect_text2:SetVAlign(ANCHOR_TOP)
    self.effect_text2:SetRegionSize(600, 400)
    self.effect_text2:EnableWordWrap(true)
    self.effect_text2:SetPosition(0, 0, 0)

    self.detail_list:SetItemAutoPadding({-20, 10, -4})

    --
    local maxstr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "当前已达到精炼等级上限" or "Max Refinement Level reached"
    self.maxlevel_hint = self:AddChild(Text("genshinfont", 36, maxstr, {1, 1, 1, 1}))
    self.maxlevel_hint:SetHAlign(ANCHOR_MIDDLE)
    self.maxlevel_hint:SetVAlign(ANCHOR_MIDDLE)
    self.maxlevel_hint:SetRegionSize(400, 80)
    self.maxlevel_hint:EnableWordWrap(true)
    self.maxlevel_hint:SetPosition(455, -200, 0)

    local string = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "精炼" or "Refine"
    self.refine_button = self:AddChild(ImageButton("images/ui/button_unlock_constellation.xml", "button_unlock_constellation.tex"))
    self.refine_button:SetText(string)
    self.refine_button:SetFont("genshinfont")
    self.refine_button:SetTextSize(56)
    self.refine_button:SetTextColour(59/255, 66/255, 85/255, 1)
    self.refine_button:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    self.refine_button.text:SetPosition(10, 0, 0)
    self.refine_button.text:Show()
    self.refine_button:SetPosition(460, -340, 0)
    self.refine_button:SetScale(0.6, 0.6, 0.6)
    self.refine_button.focus_scale = {1.07, 1.07, 1.07}
    self.refine_button:SetOnClick(function()
        if self.can == false then
            self.owner.components.talker:Say(TUNING.CONSTELLATION_INGREDIENT_LACK)
            return
        end
        SendModRPCToServer(MOD_RPC["weapon"]["refine"], self.weapon)
    end)

    self.ingredient_items = {}

    -------------------------------------------------------------
    self.inst:ListenForEvent("itemget", function() self:UpdateIngredient() end, owner)
    self.inst:ListenForEvent("itemlose", function() self:UpdateIngredient() end, owner)
    self:StartUpdating()
end)

function weapon_refine_screen:UpdateIngredient()
    local weapon = self.weapon
    if weapon == nil or weapon:HasTag("player") then
        return
    end
    local refineable = TheNet:GetIsServer() and weapon.components.refineable or weapon.replica.refineable
    if refineable == nil then
        return
    end
    
    for k, v in pairs(self.ingredient_items) do
        v:Kill()
    end
    self.ingredient_items = {}

    local ingredient = refineable:GetIngredient()
    local Inventory = self.owner.replica.inventory

    local has, num_found = Inventory:Has(ingredient, 1)  --这个找是不会找到装备栏里面的东西的，装在手上的这个是绝对安全的
    local image = refineable:GetImage()..".tex" or ingredient..".tex"
    local atlas = refineable:GetAtlas() or resolvefilepath(GetInventoryItemAtlas(image))
    if num_found >= 1 then
        self.can = true
    else
        self.can = false
    end

    local ing = self:AddChild(IngredientUI(atlas, image, 1, num_found, has, STRINGS.NAMES[string.upper(ingredient)], self.owner, ingredient))
    if GetGameModeProperty("icons_use_cc") then
        ing.ing:SetEffect("shaders/ui_cc.ksh")
    end
    ing:SetPosition(Vector3(455, -200, 0))
    ing:SetScale(1.5, 1.5, 1.5)
    table.insert(self.ingredient_items, ing)
end

function weapon_refine_screen:OnUpdate(dt)
    --获取数据
	local combatstatus = TheNet:GetIsServer() and self.owner.components.combatstatus or self.owner.replica.combatstatus
    if combatstatus == nil then
        return
    end
    local weapon = combatstatus:GetWeapon()
    self.weapon = weapon

    if weapon == nil or weapon:HasTag("player") then
        self.previous_weapon = nil
        self.previous_level = 0
        self:Hide()  --强制关闭
        return
    end

    self.name_text:SetString(STRINGS.NAMES[string.upper(weapon.prefab)])

    local refineable = TheNet:GetIsServer() and weapon.components.refineable or weapon.replica.refineable
    local current_level = refineable and refineable:GetCurrentLevel() or 1
    local max_level = refineable and refineable:GetMaxLevel() or 1

    if current_level == max_level then
        self.maxlevel_hint:Show()
        self.refine_button:Hide()
        for k, v in pairs(self.ingredient_items) do
            v:Hide()
        end
    else
        self.maxlevel_hint:Hide()
        self.refine_button:Show()
        for k, v in pairs(self.ingredient_items) do
            v:Show()
        end
    end

    if self.previous_weapon == weapon.prefab and self.previous_level == current_level then
        return
    end
    self.previous_weapon = weapon.prefab
    self.previous_level = current_level

    self:UpdateIngredient()

    local level_text = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and current_level.."阶" or "Rank "..current_level
    self.refine_level_text:SetString(level_text)

    if not weapon:HasTag("subtextweapon") then
        self.effect_text1:Hide()
        self.effect_text2:Hide()
        self.effect_title:Hide()
        return
    else
        self.effect_title:Show()
        self.effect_text1:Show()
    end

    if refineable == nil or current_level == max_level then
        local oridesc = refineable ~= nil and type(weapon.description) == "table" and weapon.description[current_level]
            or (type(weapon.description) == "string" and weapon.description or "")
        local index = string.find(oridesc, "\n")
        local title = string.sub(oridesc, 1, index - 1)
        local desc = string.sub(oridesc, index + 4)
        local ranktext = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "当前效果:" or "Current:"
        self.effect_title:SetString("• "..title.." •")
        self.effect_text1:SetString("•"..ranktext..desc)
        self.effect_text2:Hide()
    else
        local oridesc1 = weapon.description[current_level]
        local oridesc2 = weapon.description[current_level + 1]
        local index = string.find(oridesc1, "\n")
        local title = string.sub(oridesc1, 1, index - 1)
        local desc1 = string.sub(oridesc1, index + 4)
        local desc2 = string.sub(oridesc2, index + 4)
        local ranktext1 = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "当前效果:" or "Current:"
        local ranktext2 = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "下一阶效果:" or "Next Rank:"
        self.effect_title:SetString("• "..title.." •")
        self.effect_text1:SetString("•"..ranktext1..desc1)
        self.effect_text2:SetString("•"..ranktext2..desc2)
        self.effect_text2:Show()
    end

    self.detail_list:SetItemAutoPadding({-20, 10, -4})
end

return weapon_refine_screen