local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local UIAnim = require "widgets/genshin_widgets/Guianim"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"
local ScrollArea = require "widgets/scrollarea"
local IngredientUI = require "widgets/genshin_widgets/Gingredientui"

local function removeskinstring(str)
    local pos = 0
	local lastpos = 0
    while true do
        pos = string.find(str, "_", pos + 1)  -- 查找下一个
        if pos == nil then 
		    break 
		end
        lastpos = pos
    end
	local copedstr = string.sub(str, 1, lastpos - 1)
	return copedstr
end

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


    self.refineclose = self:AddChild(GMultiLayerButton(GetIconGButtonConfig("close")))
	self.refineclose:SetPosition(722, 313, 0)
	self.refineclose:SetScale(0.743, 0.743, 0.743)
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

    --武器动画
    self.weaponanim = self:AddChild(UIAnim())
    self.weaponanim:SetPosition(-280, -60, 0)
	self.weaponanim:SetScale(1.3, 1.3, 1.3)
	self.weaponanim:GetAnimState():SetBank("weapon_show")
	self.weaponanim:GetAnimState():SetBuild("weapon_show")

    --等级提示
    self.refine_level_text = self:AddChild(Text("genshinfont", 46, nil, {1, 1, 1, 1}))
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
    self.detail_list:SetPosition(455, 55, 0)
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
    self.refine_button = self:AddChild(GMultiLayerButton(GetDefaultGButtonConfig("light", "medshort", "ok")))
    self.refine_button:SetText(string)
    self.refine_button:SetPosition(460, -340, 0)
    self.refine_button:SetScale(0.85, 0.85, 0.85)
    self.refine_button:SetOnClick(function()
        if self.can == false then
            -- self.owner.components.talker:Say(TUNING.CONSTELLATION_INGREDIENT_LACK)
            self.parent.parent.toast_screen:ShowToast(TUNING.CONSTELLATION_INGREDIENT_LACK)
            return
        end
        SendModRPCToServer(MOD_RPC["weapon"]["refine"], self.weapon)
    end)

    self.ingredient_items = {}

    -------------------------------------------------------------
    self.inst:ListenForEvent("itemget", function()
        if self.shown then
            self:UpdateIngredient()
        end
    end, owner)
    self.inst:ListenForEvent("itemlose", function()
        if self.shown then
            self:UpdateIngredient()
        end
    end, owner)
    self.inst:ListenForEvent("stacksizechange", function()
        if self.shown then
            self:UpdateIngredient()
        end
    end, owner)
    self.inst:ListenForEvent("refreshcrafting", function()
        if self.shown then
            self:UpdateIngredient()
        end
    end, owner)
    self.inst:ListenForEvent("refreshinventory", function()
        if self.shown then
            self:UpdateIngredient()
        end
    end, owner)
    self:StartUpdating()
end)

function weapon_refine_screen:UpdateIngredient()
    for k, v in pairs(self.ingredient_items) do
        v:Kill()
    end
    self.ingredient_items = {}

    local weapon = self.weapon
    if weapon == nil or weapon:HasTag("player") then
        return
    end
    local refineable = TheWorld.ismastersim and weapon.components.refineable or weapon.replica.refineable
    if refineable == nil then
        return
    end

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

function weapon_refine_screen:UpdateWeapon(weapon)
    if weapon.AnimState == nil then
        return
    end
	--获取build并判断皮肤
	local weaponbuild = weapon and weapon.AnimState:GetBuild() or ""
	local skin_build = weapon.AnimState:GetSkinBuild() ~= "" and weapon.AnimState:GetSkinBuild() or nil--weapon:GetSkinBuild()
	
    if weapon.weaponscreen_override ~= nil then
        self.weaponanim:GetAnimState():OverrideSymbol("swap_object", weapon.weaponscreen_override.build, weapon.weaponscreen_override.folder)
    else
        --处理皮肤(字符串操作)  (也处理吹箭)
        if skin_build ~= nil then
            weaponbuild = removeskinstring(weaponbuild)
        end
        --还有火腿棒你是个奇葩
        if weaponbuild == "hambat" then
            weaponbuild = "ham_bat"
        elseif weaponbuild == "oceanfishingrod" then
            --海钓竿你也是
            weaponbuild = "fishingrod_ocean"
        elseif weaponbuild == "nightsword" then
            --影刀？？？
            weaponbuild = "nightmaresword"
        elseif string.find(weaponbuild, "blow_dart") ~= nil then
            weaponbuild = "blowdart"
        end
        --处理swap
        local swap_weaponbuild = weaponbuild
        if string.find(weaponbuild, "swap") == nil then
            swap_weaponbuild = "swap_" .. weaponbuild
        end
        --设置build
        if weapon.swap_config ~= nil and weapon.swap_config[1] ~= nil then
            self.weaponanim:GetAnimState():OverrideSymbol("swap_object", weapon.swap_config[1], weapon.swap_config[2] or weapon.swap_config[1])
        elseif skin_build ~= nil then
            if string.find(weaponbuild, "staff") ~= nil then
                if weapon.prefab == "firestaff" then
                    swap_weaponbuild = "swap_redstaff"
                elseif weapon.prefab == "icestaff" then
                    swap_weaponbuild = "swap_bluestaff"
                elseif weapon.prefab == "telestaff" then
                    swap_weaponbuild = "swap_purplestaff"
                else
                    swap_weaponbuild = "swap_" .. weapon.prefab
                end
                self.weaponanim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, swap_weaponbuild,
                    weapon.GUID, "swap_staffs")
            elseif weaponbuild == "multitool_axe_pickaxe" then
                self.weaponanim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, "swap_object",
                    weapon.GUID, swap_weaponbuild)
            else
                self.weaponanim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, swap_weaponbuild,
                    weapon.GUID, swap_weaponbuild)
            end
        else
            if string.find(weaponbuild, "staff") ~= nil then
                if weapon.prefab == "firestaff" then
                    swap_weaponbuild = "swap_redstaff"
                elseif weapon.prefab == "icestaff" then
                    swap_weaponbuild = "swap_bluestaff"
                elseif weapon.prefab == "telestaff" then
                    swap_weaponbuild = "swap_purplestaff"
                else
                    swap_weaponbuild = "swap_" .. weapon.prefab
                end
                self.weaponanim:GetAnimState():OverrideSymbol("swap_object", "swap_staffs", swap_weaponbuild)
            elseif weaponbuild == "multitool_axe_pickaxe" then
                self.weaponanim:GetAnimState():OverrideSymbol("swap_object", swap_weaponbuild, "swap_object")
            else
                self.weaponanim:GetAnimState():OverrideSymbol("swap_object", swap_weaponbuild, swap_weaponbuild)
            end
        end
    end
	
    local ispolearm = false
    for k, v in pairs(TUNING.POLEARM_WEAPONS) do
        if weapon.prefab == v then
            ispolearm = true
            break
        end
    end
    self.weaponanim:GetAnimState():PlayAnimation(ispolearm and "idle_polearm" or "idle_sword")
end

function weapon_refine_screen:OnUpdate(dt)
    if not self.shown or not self.parent.shown then
        return
    end
    --获取数据
	local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus
    if combatstatus == nil then
        return
    end
    local weapon = combatstatus:GetWeapon()
    self.weapon = weapon

    if weapon == nil or weapon:HasTag("player") then
        self.previous_weapon = nil
        self.previous_level = 0
        self.weaponanim:GetAnimState():ClearOverrideSymbol("swap_object")
        self:Hide()  --强制关闭
        return
    end

    self.name_text:SetString(STRINGS.NAMES[string.upper(weapon.prefab)])

    local refineable = TheWorld.ismastersim and weapon.components.refineable or weapon.replica.refineable
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

    if not weapon:HasTag("subtextweapon") then
        self.effect_text1:Hide()
        self.effect_text2:Hide()
        self.effect_title:Hide()
        self:Hide()  --强制关闭
        return
    else
        self.effect_title:Show()
        self.effect_text1:Show()
    end

    self:UpdateWeapon(weapon)
    self:UpdateIngredient()

    local level_text = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and current_level.."阶" or "Rank "..current_level
    self.refine_level_text:SetString(level_text)

    if refineable == nil or current_level == max_level then
        local oridesc = refineable ~= nil and type(weapon.description) == "table" and weapon.description[current_level]
            or (type(weapon.description) == "string" and weapon.description or "")
        local index = string.find(oridesc, "\n")
        if index == nil then
            self.effect_title:SetString("•  •")
            self.effect_text1:SetString("·   ")
            self.effect_text2:Hide()
        else
            local title = string.sub(oridesc, 1, index - 1)
            local desc = string.sub(oridesc, index + 3)
            local ranktext = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "当前效果:" or "Current:"
            self.effect_title:SetString("• " .. title .. " •")
            self.effect_text1:SetString("·" .. ranktext .. desc)
            self.effect_text2:Hide()
        end
    else
        local oridesc1 = weapon.description[current_level]
        local oridesc2 = weapon.description[current_level + 1]
        local index = string.find(oridesc1, "\n")
        local title = string.sub(oridesc1, 1, index - 1)
        local desc1 = string.sub(oridesc1, index + 3)
        local desc2 = string.sub(oridesc2, index + 3)
        local ranktext1 = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "当前效果:" or "Current:"
        local ranktext2 = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "下一阶效果:" or "Next Rank:"
        self.effect_title:SetString("• "..title.." •")
        self.effect_text1:SetString("·"..ranktext1..desc1)
        self.effect_text2:SetString("·"..ranktext2..desc2)
        self.effect_text2:Show()
    end

    self.detail_list:SetItemAutoPadding({-20, 10, -4})
end

return weapon_refine_screen