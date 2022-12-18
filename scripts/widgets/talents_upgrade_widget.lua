local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"
local IngredientUI = require "widgets/genshin_widgets/Gingredientui"
local ScrollArea = require "widgets/scrollarea"

local function HasDoubleLine(str)
    if str:find("\n") ~= nil or str:find("\v") ~= nil or str:find("\f") ~= nil or str:find("\r") ~= nil then
        return true
    end
    return false
end

local TalentUpgrade_Text = Class(Widget, function(self, owner, title, previousvalue, subsequentvalue)
    Widget._ctor(self, nil)
    self.owner = owner

    self.bg = self:AddChild(Image("images/ui/talentupgrade_text_bg.xml", "talentupgrade_text_bg.tex"))
    self.bg:SetScale(0.45, 0.45, 0.45)
    
    self.title = self:AddChild(Text("genshinfont", HasDoubleLine(title) and 22 or 28, title, {159/255, 162/255, 169/255, 1}))
    self.title:SetPosition(-230, 0, 0)
    self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:SetRegionSize(300, 100)
    self.title:EnableWordWrap(true)

    self.previousvalue = self:AddChild(Text("genshinfont", HasDoubleLine(previousvalue) and 22 or 28, previousvalue, {253/255, 253/255, 253/255, 1}))
    self.previousvalue:SetPosition(0, 0, 0)
    self.previousvalue:SetHAlign(ANCHOR_MIDDLE)
    self.previousvalue:SetVAlign(ANCHOR_MIDDLE)
    self.previousvalue:SetRegionSize(300, 100)
    self.previousvalue:EnableWordWrap(true)

    self.subsequentvalue = self:AddChild(Text("genshinfont", HasDoubleLine(subsequentvalue) and 22 or 28, subsequentvalue, {253/255, 253/255, 253/255, 1}))
    self.subsequentvalue:SetPosition(208, 0, 0)
    self.subsequentvalue:SetHAlign(ANCHOR_RIGHT)
    self.subsequentvalue:SetVAlign(ANCHOR_MIDDLE)
    self.subsequentvalue:SetRegionSize(300, 100)
    self.subsequentvalue:EnableWordWrap(true)
end)

local talents_upgrade_widget = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
    self.owner = owner
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
    self.ingredients = owner.talents_ingredients or TUNING.DEFAULT_TALENTS_INGREDIENTS

    self.current_talent = 0
    --------------------------------------

    self.bg = self:AddChild(Image("images/ui/talents_upgrade_bg.xml", "talents_upgrade_bg.tex"))

    self.close = self:AddChild(GMultiLayerButton(GetSingleGButtonConfig("dark", "images/ui/icon_genshin_button.xml", "icon_close.tex")))
    self.close:SetPosition(400, 283, 0)
    self.close:SetScale(0.743, 0.743, 0.743)
    self.close:SetOnClick(function()
        self:Hide()
    end)

    self.upgradetext1 = self:AddChild(Text("genshinfont", 40, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "天赋升级" or "Level Up Talent", {211/255, 188/255, 142/255, 1}))
    self.upgradetext1:SetPosition(0, 283, 0)

    self.upgradetext2 = self:AddChild(Text("genshinfont", 24, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "属性变更" or "Attribute Changes", {159/255, 162/255, 169/255, 1}))
    self.upgradetext2:SetPosition(0, 180, 0)

    self.leveltext1 = self:AddChild(Text("genshinfont", 24, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "等级" or "Lv.", {159/255, 162/255, 169/255, 1}))
    self.leveltext2 = self:AddChild(Text("genshinfont", 24, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "等级" or "Lv.", {159/255, 162/255, 169/255, 1}))
    self.leveltext1:SetPosition(-66, 226, 0)
    self.leveltext2:SetPosition(48, 226, 0)
    
    self.levelnumber1 = self:AddChild(Text("genshinfont", 36, "1", {236/255, 229/255, 216/255, 1}))
    self.levelnumber2 = self:AddChild(Text("genshinfont", 36, "2", {236/255, 229/255, 216/255, 1}))
    self.levelnumber1:SetPosition(-36, 228, 0)
    self.levelnumber2:SetPosition(82, 228, 0)

    --------------------------------------------------------------------------
    --list
    self.upgradetext_list = self:AddChild(ScrollArea(1050, 175, 1500, true))
    self.upgradetext_list:SetPosition(0, 75, 0)

    self.upgradetext_items = {}
    --------------------------------------------------------------------------
    
    self.requiretext = self:AddChild(Text("genshinfont", 26, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "所需材料" or "Required Materials", {159/255, 162/255, 169/255, 1}))
    self.requiretext:SetPosition(0, -40, 0)

    --材料
    self.ingredient_items = {}

    --
    self.cancel = self:AddChild(GMultiLayerButton(GetDefaultGButtonConfig("light", "long", "cancel")))
    self.cancel:SetText(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "取消" or "Cancel")
    self.cancel:SetScale(0.75, 0.75, 0.75)
    self.cancel:SetPosition(-196, -260, 0)
    self.cancel:SetOnClick(function()
        self:Hide()
    end)

    self.confirm = self:AddChild(GMultiLayerButton(GetDefaultGButtonConfig("light", "long", "ok")))
    self.confirm:SetText(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "确认" or "Confirm")
    self.confirm:SetScale(0.75, 0.75, 0.75)
    self.confirm:SetPosition(196, -260, 0)
    self.confirm:SetOnClick(function()
        if self.current_talent >= 1 and self.current_talent <= 3 then
            SendModRPCToServer(MOD_RPC["talents"]["upgrade"], self.current_talent)
        end
        self:Hide()
    end)

    ----------------------------------------------------------------
    self.inst:ListenForEvent("itemget", function() 
        self:UpdateTalentIngredients(self.current_talent)
    end, owner)
    self.inst:ListenForEvent("itemlose", function() 
        self:UpdateTalentIngredients(self.current_talent)
    end, owner)
end)

---------------------------------------------------------------------------------------

function talents_upgrade_widget:UpdateTalentLevel(talent)
    if talent < 1 or talent > 3 then
        return
    end
    local TalentsComponent = TheWorld.ismastersim and self.owner.components.talents or self.owner.replica.talents
    local previouslevel = TalentsComponent and TalentsComponent:GetTalentLevel(talent) or 1
    if previouslevel < 1 then
        previouslevel = 1
    elseif previouslevel > 14 then
        previouslevel = 14
    end
    local subsequentlevel = previouslevel + 1
    local withextension = TalentsComponent and TalentsComponent:IsWithExtension(talent) or false

    self.levelnumber1:SetString(string.format("%d", previouslevel))
    self.levelnumber2:SetString(string.format("%d", subsequentlevel))
    if withextension then
        self.levelnumber1:SetColour(105/255, 231/255, 230/255, 1)
        self.levelnumber2:SetColour(105/255, 231/255, 230/255, 1)
    else
        self.levelnumber1:SetColour(236/255, 229/255, 216/255, 1)
        self.levelnumber2:SetColour(236/255, 229/255, 216/255, 1)
    end
end

function talents_upgrade_widget:UpdateTalentText(talent)
    if talent < 1 or talent > 3 then
        return
    end
    local TalentsComponent = TheWorld.ismastersim and self.owner.components.talents or self.owner.replica.talents
    local previouslevel = TalentsComponent and TalentsComponent:GetTalentLevel(talent) or 1
    if previouslevel < 1 then
        previouslevel = 1
    elseif previouslevel > 14 then
        previouslevel = 14
    end
    local subsequentlevel = previouslevel + 1

    self.upgradetext_items = {}
    self.upgradetext_list:ClearItemsInfo()

    local paddings = {0}
    local lv = 1
    if self.attributes.keysort[talent] ~= nil and type(self.attributes.keysort[talent]) == "table" then
        for i, k in ipairs(self.attributes.keysort[talent]) do
            if type(self.attributes.value[talent][k]) == "table" then
                local v = self.attributes.text[talent][k]
            
                local titlestring = v.title
                local previous_valuenumber = self.attributes.value[talent][k][previouslevel]
                local previous_valuestring = v.formula(previous_valuenumber or 0)
                local subsequent_valuenumber = self.attributes.value[talent][k][subsequentlevel]
                local subsequent_valuestring = v.formula(subsequent_valuenumber or 0)

                local upgradetext = TalentUpgrade_Text(self.owner, titlestring, previous_valuestring, subsequent_valuestring)
                self.upgradetext_list:AddItem(upgradetext, lv, 40)
                table.insert(self.upgradetext_items, upgradetext)
                if lv >= 2 then
                    table.insert(paddings, 4)
                end
                lv = lv + 1
            end
        end
    else 
        for k, v in pairs(self.attributes.text[num]) do
            if type(self.attributes.value[talent][k]) == "table" then
                local titlestring = v.title
                local previous_valuenumber = self.attributes.value[talent][k][previouslevel]
                local previous_valuestring = v.formula(previous_valuenumber or 0)
                local subsequent_valuenumber = self.attributes.value[talent][k][subsequentlevel]
                local subsequent_valuestring = v.formula(subsequent_valuenumber or 0)

                local upgradetext = TalentUpgrade_Text(self.owner, titlestring, previous_valuestring, subsequent_valuestring)
                self.upgradetext_list:AddItem(upgradetext, lv, 53)
                table.insert(self.upgradetext_items, upgradetext)
                if lv >= 2 then
                    table.insert(paddings, 6)
                end
                lv = lv + 1
            end
        end
    end

    self.upgradetext_list:SetItemAutoPadding(paddings)
end

function talents_upgrade_widget:UpdateTalentIngredients(talent)
    if talent < 1 or talent > 3 then
        return
    end

    for k, v in pairs(self.ingredient_items) do
        v:Kill()
    end
    self.ingredient_items = {}

    local Builder = self.owner.replica.builder
    local Inventory = self.owner.replica.inventory
    local TalentsComponent = TheWorld.ismastersim and self.owner.components.talents or self.owner.replica.talents
    local baselevel = TalentsComponent and TalentsComponent:GetBaseTalentLevel(talent) or 1
    local ingredients = self.ingredients[baselevel]
    if ingredients == nil then
        return
    end

    local num = ingredients ~= nil and #ingredients or 0
    local w = 64
    local div = 10
    local half_div = div * 0.5
    local offset = 0 --center
    local hasallingredients = true
    if num > 1 then
        offset = offset - (w *.5 + half_div) * (num - 1)
    end
    for i, v in ipairs(ingredients) do
        local has, num_found = Inventory:Has(v.type, math.max(1, RoundBiasedUp(v.amount)))
        if not has then
            hasallingredients = false
        end
        local ing = self:AddChild(IngredientUI(v:GetAtlas(), v:GetImage(), v.amount ~= 0 and v.amount or nil, num_found, has, STRINGS.NAMES[string.upper(v.type)], self.owner, v.type))
        if GetGameModeProperty("icons_use_cc") then
            ing.ing:SetEffect("shaders/ui_cc.ksh")
        end
        if num > 1 and #self.ingredient_items > 0 then
            offset = offset + half_div
        end
        ing:SetPosition(Vector3(offset, -130, 0))
        offset = offset + w + half_div
        table.insert(self.ingredient_items, ing)
    end

    if hasallingredients then
        self.confirm:Enable()
        self.confirm.focus_scale = {1.05, 1.05, 1.05}
    else
        self.confirm:Disable()
        self.confirm.focus_scale = {1, 1, 1}
    end
end

function talents_upgrade_widget:ShowUpgrade(talent)
    if talent == nil then
        talent = 1
    end
    self.current_talent = talent
    self:UpdateTalentText(talent)
    self:UpdateTalentLevel(talent)
    self:UpdateTalentIngredients(talent)
end

return talents_upgrade_widget