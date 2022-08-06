local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ArtSlot = require "widgets/artslot"
local ItemTile = require "widgets/itemtile"
local ArtifactsPopop = require "widgets/artifacts_popup"
local ScrollArea = require "widgets/scrollarea"

--数字转化成带逗号的数字
local function GetScoreFormat(num)
    local num = math.ceil(num)
    local length = #tostring(num)
	local t = math.ceil(length/3)
	local score = num
	local strs = {}
	if num >= 0 and t >= 2 then
	    for i = 1,t do
		    local str = num - 1000 * math.floor(num/1000)
			if i ~= t then
			    if #tostring(str) == 1 then
				    str = "00"..tostring(str)
				elseif #tostring(str) == 2 then
				    str = "0"..tostring(str)
				end
			end
			table.insert(strs, 1, str)
			num = math.floor(num/1000)
		end
		for i = 1,t do
		    score = i == 1 and tostring(strs[i]) or tostring(score)..","..tostring(strs[i])
		end
	end
	return score
end

local artifacts_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	self.previouseffect_1 = ""
	self.previouseffect_2 = ""
	
    ----------------------------------------------------------------------------------------------
    --popup界面的返回按钮
	self.popupback = self:AddChild(ImageButton("images/ui/button_back.xml","button_back.tex"))
	self.popupback:SetPosition(722, 333, 0)
	self.popupback:SetScale(0.75, 0.75, 0.75)
	self.popupback.focus_scale = {1.1,1.1,1.1}

	----------------------------------------------------------------------------------------------
	--快速属性显示
	--生命值
	self.health_textbar_quick = self:AddChild(Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex"))
	self.health_textbar_quick:SetPosition(500,260,0)
	self.health_textbar_quick:SetScale(0.8,0.8,0.8)
	self.health_badge_quick = self:AddChild(Image("images/ui/health_badge.xml", "health_badge.tex"))
	self.health_badge_quick:SetPosition(350,260,0)
	self.health_badge_quick:SetScale(0.4,0.4,0.4)

	self.health_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_HEALTH_TEXT, {1, 1, 1, 1}))
	self.health_text_quick:SetHAlign(ANCHOR_LEFT)
    self.health_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.health_text_quick:SetRegionSize(400, 60)
    self.health_text_quick:EnableWordWrap(true)
	self.health_text_quick:SetPosition(570,260,0)
	self.health_number_quick = self:AddChild(Text("genshinfont", 30, "+0", {1, 1, 1, 1}))
	self.health_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.health_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.health_number_quick:SetRegionSize(300, 60)
    self.health_number_quick:EnableWordWrap(true)
	self.health_number_quick:SetPosition(480,260,0)

	--攻击力
	self.atk_badge_quick = self:AddChild(Image("images/ui/atk_badge.xml", "atk_badge.tex"))
	self.atk_badge_quick:SetPosition(350,220,0)
	self.atk_badge_quick:SetScale(0.4,0.4,0.4)

	self.atk_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_ATK_TEXT, {1, 1, 1, 1}))
	self.atk_text_quick:SetHAlign(ANCHOR_LEFT)
    self.atk_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.atk_text_quick:SetRegionSize(400, 60)
    self.atk_text_quick:EnableWordWrap(true)
	self.atk_text_quick:SetPosition(570,220,0)
	self.atk_number_quick = self:AddChild(Text("genshinfont", 30, "+0", {1, 1, 1, 1}))
	self.atk_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.atk_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.atk_number_quick:SetRegionSize(300, 60)
    self.atk_number_quick:EnableWordWrap(true)
	self.atk_number_quick:SetPosition(480,220,0)

	--防御力
	self.def_textbar_quick = self:AddChild(Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex"))
	self.def_textbar_quick:SetPosition(500,180,0)
	self.def_textbar_quick:SetScale(0.8,0.8,0.8)
	self.def_badge_quick = self:AddChild(Image("images/ui/def_badge.xml", "def_badge.tex"))
	self.def_badge_quick:SetPosition(350,180,0)
	self.def_badge_quick:SetScale(0.4,0.4,0.4)

	self.def_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_DEF_TEXT, {1, 1, 1, 1}))
	self.def_text_quick:SetHAlign(ANCHOR_LEFT)
    self.def_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.def_text_quick:SetRegionSize(400, 60)
    self.def_text_quick:EnableWordWrap(true)
	self.def_text_quick:SetPosition(570,180,0)
	self.def_number_quick = self:AddChild(Text("genshinfont", 30, "+0", {1, 1, 1, 1}))
	self.def_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.def_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.def_number_quick:SetRegionSize(300, 60)
    self.def_number_quick:EnableWordWrap(true)
	self.def_number_quick:SetPosition(480,180,0)

	--元素精通
	self.element_mastery_badge_quick = self:AddChild(Image("images/ui/element_mastery_badge.xml", "element_mastery_badge.tex"))
	self.element_mastery_badge_quick:SetPosition(350,140,0)
	self.element_mastery_badge_quick:SetScale(0.4,0.4,0.4)

	self.element_mastery_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_MASTERY_TEXT, {1, 1, 1, 1}))
	self.element_mastery_text_quick:SetHAlign(ANCHOR_LEFT)
    self.element_mastery_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.element_mastery_text_quick:SetRegionSize(400, 60)
    self.element_mastery_text_quick:EnableWordWrap(true)
	self.element_mastery_text_quick:SetPosition(570,140,0)
	self.element_mastery_number_quick = self:AddChild(Text("genshinfont", 30, "+0", {1, 1, 1, 1}))
	self.element_mastery_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.element_mastery_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.element_mastery_number_quick:SetRegionSize(300, 60)
    self.element_mastery_number_quick:EnableWordWrap(true)
	self.element_mastery_number_quick:SetPosition(480,140,0)
	--交替有背景bar条

    ----------------------------------------------------------------------------------------------
	--显示圣遗物？
    self.artifacts_slots_flower = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.artifacts_slots_flower:SetPosition(-215, -50, 0)
    self.artifacts_slots_flower:SetScale(1.8,1.8,1.8)
    self.artifacts_slots_flower.highlight_scale = 1.9
    self.artifacts_slots_flower.base_scale = 1.8

    self.artifacts_slots_plume = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.artifacts_slots_plume:SetPosition(-320, -135, 0)
    self.artifacts_slots_plume:SetScale(1.8,1.8,1.8)
    self.artifacts_slots_plume.highlight_scale = 1.9
    self.artifacts_slots_plume.base_scale = 1.8

    self.artifacts_slots_sands = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.artifacts_slots_sands:SetPosition(-20, -220, 0)
    self.artifacts_slots_sands:SetScale(1.8,1.8,1.8)
    self.artifacts_slots_sands.highlight_scale = 1.9
    self.artifacts_slots_sands.base_scale = 1.8

    self.artifacts_slots_goblet = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.artifacts_slots_goblet:SetPosition(280, -135, 0)
    self.artifacts_slots_goblet:SetScale(1.8,1.8,1.8)
    self.artifacts_slots_goblet.highlight_scale = 1.9
    self.artifacts_slots_goblet.base_scale = 1.8

    self.artifacts_slots_circlet = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.artifacts_slots_circlet:SetPosition(175, -50, 0)
    self.artifacts_slots_circlet:SetScale(1.8,1.8,1.8)
    self.artifacts_slots_circlet.highlight_scale = 1.9
    self.artifacts_slots_circlet.base_scale = 1.8
	
    ----------------------------------------------------------------------------------------------
    self.setdescription_list = self:AddChild(ScrollArea(400, 340, 800))
	self.setdescription_list:SetPosition(540, -60, 0)

    --套装效果几个大字
	self.setbonustext = Text("genshinfont", 34, TUNING.SETBONUSTEXT, {150/255, 253/255, 135/255, 1})
	self.setdescription_list:AddItem(self.setbonustext)
	self.setbonustext:SetHAlign(ANCHOR_LEFT)
    self.setbonustext:SetVAlign(ANCHOR_MIDDLE)
    self.setbonustext:SetRegionSize(400, 60)
    self.setbonustext:EnableWordWrap(true)
    self.setbonustext:SetPosition(0, 0, 0)
	--540, 90, 0

	--套装名字 1/2
    self.sets_text1 = Text("genshinfont", 32, nil, {150/255, 253/255, 135/255, 1})
	self.setdescription_list:AddItem(self.sets_text1)
    self.sets_text1:SetHAlign(ANCHOR_LEFT)
    self.sets_text1:SetVAlign(ANCHOR_MIDDLE)
    self.sets_text1:SetRegionSize(400, 60)
    self.sets_text1:EnableWordWrap(true)
    self.sets_text1:SetPosition(0, -40, 0)
	self.sets_text2 = Text("genshinfont", 32, nil, {150/255, 253/255, 135/255, 1})
	self.setdescription_list:AddItem(self.sets_text2)
    self.sets_text2:SetHAlign(ANCHOR_LEFT)
    self.sets_text2:SetVAlign(ANCHOR_MIDDLE)
    self.sets_text2:SetRegionSize(400, 60)
    self.sets_text2:EnableWordWrap(true)
    self.sets_text2:SetPosition(0, -125, 0)
    --套装图标 2个  这次都是绿色才显示
    self.effect1_icon = Image("images/ui/effect_active.xml", "effect_active.tex")
	self.setdescription_list:AddItem(self.effect1_icon)
    self.effect1_icon:SetScale(0.45, 0.45, 0.45)
    self.effect1_icon:SetPosition(-190, -70, 0)
    self.effect2_icon = Image("images/ui/effect_active.xml", "effect_active.tex")
	self.setdescription_list:AddItem(self.effect2_icon)
    self.effect2_icon:SetScale(0.45, 0.45, 0.45)
    self.effect2_icon:SetPosition(-190, -132, 0)
    --效果1 一定是个两件套效果
    self.effect1_text = Text("genshinfont", 28, nil, {150/255, 253/255, 135/255, 1})
	self.setdescription_list:AddItem(self.effect1_text)
    self.effect1_text:SetHAlign(ANCHOR_LEFT)
    self.effect1_text:SetVAlign(ANCHOR_TOP)
    self.effect1_text:SetRegionSize(270, 110)
    self.effect1_text:EnableWordWrap(true)
    self.effect1_text:SetPosition(-40, -112, 0)
    --效果2 可能是个两件套效果也可能是个四件套效果
    self.effect2_text = Text("genshinfont", 28, nil, {150/255, 253/255, 135/255, 1})
	self.setdescription_list:AddItem(self.effect2_text)
    self.effect2_text:SetHAlign(ANCHOR_LEFT)
    self.effect2_text:SetVAlign(ANCHOR_TOP)
    self.effect2_text:SetRegionSize(270, 600)
    self.effect2_text:EnableWordWrap(true)
    self.effect2_text:SetPosition(-40, -420, 0)

	self.setdescription_list:UpdateContentHeight()

    ----------------------------------------------------------------------------------------------
    --圣遗物详情
    self.popup = self:AddChild(ArtifactsPopop(self.owner))

    ----------------------------------------------------------------------------------------------
	--按键按下(显示圣遗物的那些按键)
    self.artifacts_slots_flower:SetOnClick(function() self:ShowPopup("flower") end)
	self.artifacts_slots_plume:SetOnClick(function() self:ShowPopup("plume") end)
	self.artifacts_slots_sands:SetOnClick(function() self:ShowPopup("sands") end)
	self.artifacts_slots_goblet:SetOnClick(function() self:ShowPopup("goblet") end)
	self.artifacts_slots_circlet:SetOnClick(function() self:ShowPopup("circlet") end)
    --popup返回按键
	self.popupback:SetOnClick(function() 
		self:HidePopup() 
		SendModRPCToServer(MOD_RPC["combatdata"]["combat"])
	end)
	----------------------------------------------------------------------------------------------
    --设置初始状态，开始刷新
	self.popupback:MoveToFront()
	self.popup:Hide()
	self:StartUpdating()
end)

function artifacts_screen:ShowPopup(type)
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --进入圣遗物界面四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
		self.parent.mainclose,
	}
    --显示popup界面和返回按钮，隐藏自身除了popup以外的任何东西(快速圣遗物属性显示和五个圣遗物按钮)
	self.popup:ShowType(type)
    self.popup:Show()
	self.popupback:Show()
	for k,v in pairs(self.children) do
		if v ~= self.popup and v ~= self.popupback then
			v:Hide()
		end
	end
	--隐藏父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Hide()
	end
	self.setdescription_list:Reset()
end

function artifacts_screen:HidePopup()
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --进入圣遗物界面四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
		self.parent.mainclose,
	}
	--隐藏popup界面和返回按钮，显示自身除了popup和返回按钮以外的任何东西(快速圣遗物属性显示和五个圣遗物按钮)
    self.popup:Hide()
	self.popupback:Hide()
	for k,v in pairs(self.children) do
		if v ~= self.popup and v ~= self.popupback then
			v:Show()
		end
	end
	--显示父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Show()
	end
	self.setdescription_list:Reset()
	self.noscreenchange = false
end

function artifacts_screen:OnUpdate(dt)
    --获取数据
	local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus
    local inventory = self.owner.replica.inventory

	if inventory == nil or combatstatus == nil then
		self.popup:Hide()
		return
	end
    
    --获取装备的圣遗物
    local flower_item = inventory:GetEquippedItem(EQUIPSLOTS.FLOWER)
    local plume_item = inventory:GetEquippedItem(EQUIPSLOTS.PLUME)
    local sands_item = inventory:GetEquippedItem(EQUIPSLOTS.SANDS)
    local goblet_item = inventory:GetEquippedItem(EQUIPSLOTS.GOBLET)
    local circlet_item = inventory:GetEquippedItem(EQUIPSLOTS.CIRCLET)

    --先计算小面板
	local artinumber = {}
	local items = {
		flower_item,
        plume_item,
        sands_item,
        goblet_item,
        circlet_item,
	}
	local baseatk = combatstatus:GetBaseAtk()
	local basehp = combatstatus:GetBaseHp()
	local basedef = combatstatus:GetBaseDef()
    for k,v in pairs(TUNING.ARTIFACTS_TYPE) do
		artinumber[k] = 0
	end
    for k,v in pairs(items) do
		local articomponent = v and (TheWorld.ismastersim and v.components.artifacts or v.replica.artifacts) or nil
		if articomponent ~= nil then 
		    artinumber[(articomponent:GetMain()).type] = artinumber[(articomponent:GetMain()).type] + (articomponent:GetMain()).number
		    artinumber[(articomponent:GetSub1()).type] = artinumber[(articomponent:GetSub1()).type] + (articomponent:GetSub1()).number
		    artinumber[(articomponent:GetSub2()).type] = artinumber[(articomponent:GetSub2()).type] + (articomponent:GetSub2()).number
		    artinumber[(articomponent:GetSub3()).type] = artinumber[(articomponent:GetSub3()).type] + (articomponent:GetSub3()).number
		    artinumber[(articomponent:GetSub4()).type] = artinumber[(articomponent:GetSub4()).type] + (articomponent:GetSub4()).number
		end
	end
    local atkbonus = baseatk * (1 + artinumber["atk_per"]) + artinumber["atk"] - baseatk
	local hpbonus = basehp * (1 + artinumber["hp_per"]) + artinumber["hp"] - basehp
	local defbonus = basedef * (1 + artinumber["def_per"]) + artinumber["def"] - basedef
	local elementmastery = artinumber["mastery"]
	--生命值
	self.health_number_quick:SetString("+"..GetScoreFormat(hpbonus))
	--攻击力
	self.atk_number_quick:SetString("+"..GetScoreFormat(atkbonus))
	--防御力
	self.def_number_quick:SetString("+"..GetScoreFormat(defbonus))
	--元素精通
	self.element_mastery_number_quick:SetString("+"..GetScoreFormat(elementmastery))

	--显示套装效果
	local SETS_NUMBER = {}
    for k,v in pairs(TUNING.ARTIFACTS_SETS) do
        SETS_NUMBER[k] = 0
    end
	
	--显示圣遗物图片(以及套装计数)
    if flower_item ~= nil then
        self.artifacts_slots_flower:SetTile(ItemTile(flower_item))
		local sets = TheWorld.ismastersim and flower_item.components.artifacts:GetSets() or flower_item.replica.artifacts:GetSets()
		SETS_NUMBER[sets]  = SETS_NUMBER[sets] + 1
    else
        self.artifacts_slots_flower:SetTile(nil)
    end
    if plume_item ~= nil then
        self.artifacts_slots_plume:SetTile(ItemTile(plume_item))
		local sets = TheWorld.ismastersim and plume_item.components.artifacts:GetSets() or plume_item.replica.artifacts:GetSets()
		SETS_NUMBER[sets]  = SETS_NUMBER[sets] + 1
    else
        self.artifacts_slots_plume:SetTile(nil)
    end
    if sands_item ~= nil then
        self.artifacts_slots_sands:SetTile(ItemTile(sands_item))
		local sets = TheWorld.ismastersim and sands_item.components.artifacts:GetSets() or sands_item.replica.artifacts:GetSets()
		SETS_NUMBER[sets]  = SETS_NUMBER[sets] + 1
    else
        self.artifacts_slots_sands:SetTile(nil)
    end
    if goblet_item ~= nil then
        self.artifacts_slots_goblet:SetTile(ItemTile(goblet_item))
		local sets = TheWorld.ismastersim and goblet_item.components.artifacts:GetSets() or goblet_item.replica.artifacts:GetSets()
		SETS_NUMBER[sets]  = SETS_NUMBER[sets] + 1
    else
        self.artifacts_slots_goblet:SetTile(nil)
    end
    if circlet_item ~= nil then
        self.artifacts_slots_circlet:SetTile(ItemTile(circlet_item))
		local sets = TheWorld.ismastersim and circlet_item.components.artifacts:GetSets() or circlet_item.replica.artifacts:GetSets()
		SETS_NUMBER[sets]  = SETS_NUMBER[sets] + 1
    else
        self.artifacts_slots_circlet:SetTile(nil)
    end
    --显示套装
	local setseffect_1, setseffect_2
	local issets4effect = false
	for k,v in pairs(SETS_NUMBER) do
        if v >= 2 then
			if setseffect_1 == nil then
                setseffect_1 = k   --两件套
			else
				setseffect_2 = k
			end
        end
        if v >= 4 then
            setseffect_2 = k  --四件套
			issets4effect = true
        end
    end

	if setseffect_1 == nil or self.popup.shown then  --哦哟，没有套装效果/或者在popup界面
		self.sets_text1:Hide()
		self.sets_text2:Hide()
		self.effect1_icon:Hide()
		self.effect2_icon:Hide()
		self.effect1_text:Hide()
		self.effect2_text:Hide()
		return
	end

	if self.previouseffect_1 == setseffect_1 and self.previouseffect_2 == setseffect_2 and self.noscreenchange then
		return
	end
	self.previouseffect_1 = setseffect_1
	self.previouseffect_2 = setseffect_2
	self.noscreenchange = true

    if issets4effect then  --四件套的话，只显示第一个名字
		self.sets_text1:SetString(TUNING.ARTIFACTS_SETS[setseffect_1])
		self.effect1_text:SetString(TUNING.ARTIFACTS_EFFECT[setseffect_1][1])
		self.effect2_text:SetString(TUNING.ARTIFACTS_EFFECT[setseffect_1][2])
		self.effect2_icon:SetPosition(-190, -122, 0)
		self.effect2_text:SetPosition(-40, -410, 0) 

		self.sets_text1:Show()
		self.sets_text2:Hide()
		self.effect1_icon:Show()
		self.effect2_icon:Show()
		self.effect1_text:Show()
		self.effect2_text:Show()
	elseif setseffect_2 ~= nil then
        self.sets_text1:SetString(TUNING.ARTIFACTS_SETS[setseffect_1])
		self.sets_text2:SetString(TUNING.ARTIFACTS_SETS[setseffect_2])
		self.effect1_text:SetString(TUNING.ARTIFACTS_EFFECT[setseffect_1][1])
		self.effect2_text:SetString(TUNING.ARTIFACTS_EFFECT[setseffect_2][1])
		self.effect2_icon:SetPosition(-190, -152, 0)
		self.effect2_text:SetPosition(-40, -440, 0)

		self.sets_text1:Show()
		self.sets_text2:Show()
		self.effect1_icon:Show()
		self.effect2_icon:Show()
		self.effect1_text:Show()
		self.effect2_text:Show()
	else
		self.sets_text1:SetString(TUNING.ARTIFACTS_SETS[setseffect_1])
		self.effect1_text:SetString(TUNING.ARTIFACTS_EFFECT[setseffect_1][1])

		self.sets_text1:Show()
		self.sets_text2:Hide()
		self.effect1_icon:Show()
		self.effect2_icon:Hide()
		self.effect1_text:Show()
		self.effect2_text:Hide()
	end
	--self.setdescription_list:UpdateContentHeight()
end

return artifacts_screen