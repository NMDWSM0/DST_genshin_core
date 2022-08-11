local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local ArtSlot = require "widgets/artslot"
local ItemTile = require "widgets/itemtile"
local ScrollArea = require "widgets/scrollarea"

local TYPES = {
    "flower",
    "plume",
    "sands",
    "goblet",
    "circlet",
}

local function posx(num)
    return ((num - 1) % 5) * 83
end

local function posy(num)
    return math.floor((num - 1) / 5) * (-83)
end

local artifacts_popup = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	
    self.currenttype = "flower"

	----------------------------------------------------------------------------------------------
    --中心显示器
	self.center_slot = self:AddChild(ArtSlot("images/ui/art_bg.xml", "art_bg.tex", owner))
    self.center_slot:SetPosition(-20, -125, 0)
    self.center_slot:SetScale(1.8,1.8,1.8)
    self.center_slot.highlight_scale = 1.8
    self.center_slot.base_scale = 1.8
    self.center_slot:SetClickable(false)

    self.center_emptywarning = self:AddChild(Image("images/ui/slotempty.xml", "slotempty.tex"))
    self.center_emptywarning:SetPosition(25, -75, 0)
    self.center_emptywarning:SetScale(0.6, 0.6, 0.6)

    ----------------------------------------------------------------------------------------------
    --左侧上方切换按钮
    self.button_flower = self:AddChild(ImageButton("images/ui/button_arttype.xml","flower_normal.tex", nil, nil, nil, "flower_selected.tex"))
    self.button_flower:SetPosition(-700, 300, 0)

    self.button_plume = self:AddChild(ImageButton("images/ui/button_arttype.xml","plume_normal.tex", nil, nil, nil, "plume_selected.tex"))
    self.button_plume:SetPosition(-610, 300, 0)

    self.button_sands = self:AddChild(ImageButton("images/ui/button_arttype.xml","sands_normal.tex", nil, nil, nil, "sands_selected.tex"))
    self.button_sands:SetPosition(-520, 300, 0)

    self.button_goblet = self:AddChild(ImageButton("images/ui/button_arttype.xml","goblet_normal.tex", nil, nil, nil, "goblet_selected.tex"))
    self.button_goblet:SetPosition(-430, 300, 0)

    self.button_circlet = self:AddChild(ImageButton("images/ui/button_arttype.xml","circlet_normal.tex", nil, nil, nil, "circlet_selected.tex"))
    self.button_circlet:SetPosition(-340, 300, 0)
	
    ----------------------------------------------------------------------------------------------
    --左侧圣遗物显示区先显示为空
    self.art = {}
    self.artnumber = 0
    --没有圣遗物的信息
    self.noartifacts_title = self:AddChild(Text("genshinfont", 50, nil, {1, 1, 1, 1}))
    self.noartifacts_title:SetHAlign(ANCHOR_MIDDLE)
    self.noartifacts_title:SetVAlign(ANCHOR_MIDDLE)
    self.noartifacts_title:SetRegionSize(400, 60)
    self.noartifacts_title:EnableWordWrap(true)
    self.noartifacts_title:SetPosition(-520, 30, 0)
    self.noartifacts_text = self:AddChild(Text("genshinfont", 32, TUNING.NOARTIFACTS_WARNING, {1, 1, 1, 1}))
    self.noartifacts_text:SetHAlign(ANCHOR_MIDDLE)
    self.noartifacts_text:SetVAlign(ANCHOR_TOP)
    self.noartifacts_text:SetRegionSize(400, 80)
    self.noartifacts_text:EnableWordWrap(true)
    self.noartifacts_text:SetPosition(-520, -40, 0)

    ----------------------------------------------------------------------------------------------
    --右侧圣遗物详细显示区
    self.detail_list = self:AddChild(ScrollArea(420, 650, 1100))
    self.detail_list:SetPosition(500, 25, 0)

    --圣遗物名字
    self.name_text = Text("genshinfont", 44, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.name_text)
    self.name_text:SetHAlign(ANCHOR_LEFT)
    self.name_text:SetVAlign(ANCHOR_MIDDLE)
    self.name_text:SetRegionSize(400, 80)
    self.name_text:EnableWordWrap(true)
    self.name_text:SetPosition(0, -40, 0)
    --500, 300, 0
    --圣遗物位置
    self.type_text = Text("genshinfont", 28, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.type_text)
    self.type_text:SetHAlign(ANCHOR_LEFT)
    self.type_text:SetVAlign(ANCHOR_MIDDLE)
    self.type_text:SetRegionSize(400, 60)
    self.type_text:EnableWordWrap(true)
    self.type_text:SetPosition(0, -80, 0)
    --圣遗物主属性
    self.main_textbar = Image("images/ui/textbar_light.xml", "textbar_light.tex")
    self.detail_list:AddItem(self.main_textbar)
    self.main_textbar:SetPosition(-45, -120, 0)
    self.main_textbar:SetScale(0.52, 0.8, 0.8)

    self.main_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.main_text)
    self.main_text:SetHAlign(ANCHOR_LEFT)
    self.main_text:SetVAlign(ANCHOR_MIDDLE)
    self.main_text:SetRegionSize(300, 60)
    self.main_text:EnableWordWrap(true)
    self.main_text:SetPosition(-40, -120, 0)

    self.main_number = Text("genshinfont", 35, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.main_number)
    self.main_number:SetHAlign(ANCHOR_RIGHT)
    self.main_number:SetVAlign(ANCHOR_MIDDLE)
    self.main_number:SetRegionSize(300, 60)
    self.main_number:EnableWordWrap(true)
    self.main_number:SetPosition(-40, -120, 0)

    --星级和等级(假的，全显示五星满级)
    self.stars = Image("images/ui/artifact_stars.xml", "artifact_stars.tex")
    self.detail_list:AddItem(self.stars)
    self.stars:SetPosition(-125, -175, 0)
    self.stars:SetScale(0.8, 0.8, 0.8)

    --副词条
    self.sub1_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub1_text)
    self.sub1_text:SetPosition(0, -225, 0)
    self.sub1_text:SetHAlign(ANCHOR_LEFT)
    self.sub1_text:SetVAlign(ANCHOR_MIDDLE)
    self.sub1_text:SetRegionSize(400, 60)
    self.sub1_text:EnableWordWrap(true)

    self.sub2_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub2_text)
    self.sub2_text:SetPosition(0, -260, 0)
    self.sub2_text:SetHAlign(ANCHOR_LEFT)
    self.sub2_text:SetVAlign(ANCHOR_MIDDLE)
    self.sub2_text:SetRegionSize(400, 60)
    self.sub2_text:EnableWordWrap(true)

    self.sub3_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub3_text)
    self.sub3_text:SetPosition(0, -295, 0)
    self.sub3_text:SetHAlign(ANCHOR_LEFT)
    self.sub3_text:SetVAlign(ANCHOR_MIDDLE)
    self.sub3_text:SetRegionSize(400, 60)
    self.sub3_text:EnableWordWrap(true)

    self.sub4_text = Text("genshinfont", 32, nil, {1, 1, 1, 1})
    self.detail_list:AddItem(self.sub4_text)
    self.sub4_text:SetPosition(0, -330, 0)
    self.sub4_text:SetHAlign(ANCHOR_LEFT)
    self.sub4_text:SetVAlign(ANCHOR_MIDDLE)
    self.sub4_text:SetRegionSize(400, 60)
    self.sub4_text:EnableWordWrap(true)
    --套装名字
    self.sets_text = Text("genshinfont", 32, nil, {150/255, 253/255, 135/255, 1})
    self.detail_list:AddItem(self.sets_text)
    self.sets_text:SetHAlign(ANCHOR_LEFT)
    self.sets_text:SetVAlign(ANCHOR_MIDDLE)
    self.sets_text:SetRegionSize(400, 60)
    self.sets_text:EnableWordWrap(true)
    self.sets_text:SetPosition(0, -370, 0)
    --套装图标
    self.setseffect2_icon = Image("images/ui/effect_inactive.xml", "effect_inactive.tex")
    self.detail_list:AddItem(self.setseffect2_icon)
    self.setseffect2_icon:SetScale(0.45, 0.45, 0.45)
    self.setseffect2_icon:SetPosition(-190, -398, 0)
    self.setseffect4_icon = Image("images/ui/effect_inactive.xml", "effect_inactive.tex")
    self.detail_list:AddItem(self.setseffect4_icon)
    self.setseffect4_icon:SetScale(0.45, 0.45, 0.45)
    self.setseffect4_icon:SetPosition(-190, -457, 0)
    --套装2效果
    self.setseffect2_text = Text("genshinfont", 28, nil, {0.75, 0.75, 0.75, 1})
    self.detail_list:AddItem(self.setseffect2_text)
    self.setseffect2_text:SetHAlign(ANCHOR_LEFT)
    self.setseffect2_text:SetVAlign(ANCHOR_TOP)
    self.setseffect2_text:SetRegionSize(270, 110)
    self.setseffect2_text:EnableWordWrap(true)
    self.setseffect2_text:SetPosition(-40, -440, 0)

    --套装4效果
    self.setseffect4_text = Text("genshinfont", 28, nil, {0.75, 0.75, 0.75, 1})
    self.detail_list:AddItem(self.setseffect4_text)
    self.setseffect4_text:SetHAlign(ANCHOR_LEFT)
    self.setseffect4_text:SetVAlign(ANCHOR_TOP)
    self.setseffect4_text:SetRegionSize(270, 600)
    self.setseffect4_text:EnableWordWrap(true)
    self.setseffect4_text:SetPosition(-40, -745, 0)

    self.detail_list:UpdateContentHeight()

    ----------------------------------------------------------------------------------------------
    --卸下和切换按钮
    self.button_switch = self:AddChild(ImageButton("images/ui/button_switch.xml","button_switch.tex"))
    self.button_switch:SetPosition(455, -300, 0)
    self.button_switch:SetScale(0.9, 0.9, 0.9)
    self.button_switch.focus_scale = {1.1,1.1,1.1}

	----------------------------------------------------------------------------------------------
    --按钮按下动作
    
    self.button_flower:SetOnClick(function() self:ShowType("flower") end)
    self.button_plume:SetOnClick(function() self:ShowType("plume") end)
    self.button_sands:SetOnClick(function() self:ShowType("sands") end)
    self.button_goblet:SetOnClick(function() self:ShowType("goblet") end)
    self.button_circlet:SetOnClick(function() self:ShowType("circlet") end)

    self.button_switch:SetOnClick(function() self:SwitchorRemove(self.center_slot.tile and self.center_slot.tile.item or nil) end)

    ----------------------------------------------------------------------------------------------
    --监听事件刷新
    self.inst:ListenForEvent("equip", function() self:SetType(self.currenttype) end, owner)
    self.inst:ListenForEvent("unequip", function() self:SetType(self.currenttype) end, owner)
    self.inst:ListenForEvent("itemget", function() self:SetType(self.currenttype) end, owner)
    self.inst:ListenForEvent("itemlose", function() self:SetType(self.currenttype) end, owner)
    self.inst:ListenForEvent("artbackpackchange", function() self:SetType(self.currenttype) end, owner)
end)

function artifacts_popup:ShowType(type)
    local typebuttons = {
		self.button_flower,
		self.button_plume,
		self.button_sands,
		self.button_goblet,
		self.button_circlet,
	}

    if not table.contains(TYPES, type) then
        type = "flower"
    end

    self["button_"..type]:Select()
	self:SetType(type)
	for k,v in pairs(typebuttons) do
		if v ~= self["button_"..type] then
			v:Unselect()
		end
	end
    self.detail_list:Reset()
end

function artifacts_popup:SetType(type)
    --当前显示的是什么位置的圣遗物
    self.currenttype = table.contains(TYPES, type) and type or "flower"
    local componentname = TheWorld.ismastersim and "components" or "replica"
    --物品栏和背包，还有圣遗物箱子
    local inventory = self.owner.replica.inventory
    local overflow = inventory:GetOverflowContainer()
	overflow = (overflow ~= nil and overflow:IsOpenedBy(self.owner)) and overflow or nil
    local num_slots_inventory = inventory:GetNumSlots()
    local artifactsbackpacks = {}
    for k = 1, num_slots_inventory do
        local item = inventory:GetItemInSlot(k)
        local itemcontainer = (item ~= nil and item[componentname].container) and item[componentname].container or nil
        if itemcontainer and item:HasTag("artifactsbackpack") then
            table.insert(artifactsbackpacks, itemcontainer)
        end
    end
    if overflow ~= nil then
        local num_slots_backpack = overflow:GetNumSlots()
        for k = 1, num_slots_backpack do
            local item = overflow:GetItemInSlot(k)
            local itemcontainer = (item ~= nil and item[componentname].container) and item[componentname].container or nil
            if itemcontainer and item:HasTag("artifactsbackpack") then
                table.insert(artifactsbackpacks, itemcontainer)
            end
        end
    end

    --获取该位置圣遗物
    local mainitem = inventory:GetEquippedItem(EQUIPSLOTS[string.upper(self.currenttype)])
    if mainitem then
        self.center_emptywarning:Hide()
    else
        self.center_emptywarning:Show()
    end

    --把之前显示的全部清除
    for k = 1, self.artnumber do
        self.art[k]:Kill()
    end

    --显示物品栏和背包中所有带有该类型圣遗物标签的物品
    local i = 0  
    --一号位是穿在身上的那个
    if mainitem ~= nil then
        i = i + 1
        self.art[i] = ArtSlot("images/hud.xml", "inv_slot.tex", self.owner)
		self:AddChild(self.art[i])
        self.art[i]:SetPosition(-686 + posx(i), 200 + posy(i))
		self.art[i]:SetScale(1)
        self.art[i]:SetTile(ItemTile(mainitem))
        self.art[i]:SetOnClick(function() self:SetItemOnDetail(mainitem) end)
    end
    --然后是物品栏里的
    for k = 1, num_slots_inventory do
        local item = inventory:GetItemInSlot(k)
        if item and item:HasTag("artifacts_"..self.currenttype) then
            i = i + 1
            self.art[i] = ArtSlot("images/hud.xml", "inv_slot.tex", self.owner)
		    self:AddChild(self.art[i])
            self.art[i]:SetPosition(-686 + posx(i), 200 + posy(i))
		    self.art[i]:SetScale(1)
            self.art[i]:SetTile(ItemTile(item))
            self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
        end
    end
    --然后是背包里的
    if overflow ~= nil then
        local num_slots_backpack = overflow:GetNumSlots()
        for k = 1, num_slots_backpack do
            local item = overflow:GetItemInSlot(k)
            if item and item:HasTag("artifacts_"..self.currenttype) then
                i = i + 1
                self.art[i] = ArtSlot("images/hud.xml", "inv_slot.tex", self.owner)
		        self:AddChild(self.art[i])
                self.art[i]:SetPosition(-686 + posx(i), 200 + posy(i))
		        self.art[i]:SetScale(1)
                self.art[i]:SetTile(ItemTile(item))
                self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
            end
        end
    end
    --最后是圣遗物箱子里面的
    if #artifactsbackpacks > 0 then
        for t,v in pairs(artifactsbackpacks) do
            local num_slots_artbackpack = v:GetNumSlots()
            for k = 1, num_slots_artbackpack do
                local item = v:GetItemInSlot(k)
                if item and item:HasTag("artifacts_"..self.currenttype) then
                    i = i + 1
                    self.art[i] = ArtSlot("images/hud.xml", "inv_slot.tex", self.owner)
		            self:AddChild(self.art[i])
                    self.art[i]:SetPosition(-686 + posx(i), 200 + posy(i))
		            self.art[i]:SetScale(1)
                    self.art[i]:SetTile(ItemTile(item))
                    self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
                end
            end
        end
    end

    --记录一下数字
    self.artnumber = i
    --如果有就显示信息，没有显示没有
    if self.artnumber > 0 then
        self.art[1].onclick(self)
    else
        self:HideDetail()
        self.center_slot:SetTile(nil)
    end
end

function artifacts_popup:HideDetail()
    self.name_text:Hide()
    self.type_text:Hide()
    self.sets_text:Hide()
    self.main_textbar:Hide()
    self.main_text:Hide()
    self.main_number:Hide()
    self.stars:Hide()
    self.sub1_text:Hide()
    self.sub2_text:Hide()
    self.sub3_text:Hide()
    self.sub4_text:Hide()
    self.setseffect2_icon:Hide()
    self.setseffect2_text:Hide()
    self.setseffect4_icon:Hide()
    self.setseffect4_text:Hide()
    self.button_switch:Hide()

    --显示左边大字
    self.noartifacts_title:Show()
    self.noartifacts_title:SetString(TUNING.ARTIFACTS_TAG[self.currenttype])
    self.noartifacts_text:Show()
end

function artifacts_popup:ShowDetail(item)
    if item == nil then
        return
    end
    self.noartifacts_title:Hide()
    self.noartifacts_text:Hide()

    --当前圣遗物基本信息
    local artifacts = item.components.artifacts or item.replica.artifacts
    if artifacts == nil then
        return
    end
    local name = STRINGS.NAMES[string.upper(item.prefab)]
    local type = TUNING.ARTIFACTS_TAG[artifacts:GetTag()]
    local sets = TUNING.ARTIFACTS_SETS[artifacts:GetSets()]

    --获取一波当前显示的这个圣遗物，有几件和它相同的在装备
    local isequipped = false
    local hasequip = false
    local setsnumber = 0
    for k,v in pairs(TYPES) do
        local anotheritem  = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS[string.upper(v)])  --那个部位的圣遗物
        if anotheritem ~= nil then
            if v == artifacts:GetTag() then
                hasequip = true
            end
            local anotherartifacts = anotheritem.components.artifacts or anotheritem.replica.artifacts
            if anotherartifacts == nil then
                return
            end
            if anotherartifacts:GetSets() == artifacts:GetSets() then  --那个圣遗物的套装和当前显示居然一样诶
                setsnumber = setsnumber + 1
            end
            if anotheritem == item then
                isequipped = true
            end
        end
    end

    --把数量附加在sets字符串后面
    sets = sets..":("..setsnumber..")"

    --套装描述要显示什么颜色什么图标
    local effect2_color = {0.75, 0.75, 0.75, 1}
    local effect4_color = {0.75, 0.75, 0.75, 1}
    local status2 = "inactive"
    local status4 = "inactive"
    if setsnumber >= 2 then
        effect2_color = {150/255, 253/255, 135/255, 1}
        status2 = "active"
    end
    if setsnumber >= 4 then
        effect4_color = {150/255, 253/255, 135/255, 1}
        status4 = "active"
    end

    local setseffect2string = TUNING.ARTIFACTS_EFFECT[artifacts:GetSets()][1]
    local setseffect4string = TUNING.ARTIFACTS_EFFECT[artifacts:GetSets()][2]

    local mainstring = TUNING.ARTIFACTS_TYPE[(artifacts:GetMain()).type]
    local mainnumber = (artifacts:GetMain()).number > 1 and string.format("%.1f", (artifacts:GetMain()).number) or string.format("%.1f", (100 * (artifacts:GetMain()).number)).."%"

    local sub1string = TUNING.ARTIFACTS_TYPE[(artifacts:GetSub1()).type]
    local sub1number = (artifacts:GetSub1()).number > 1 and string.format("%.1f", (artifacts:GetSub1()).number) or string.format("%.1f", (100 * (artifacts:GetSub1()).number)).."%"

    local sub2string = TUNING.ARTIFACTS_TYPE[(artifacts:GetSub2()).type]
    local sub2number = (artifacts:GetSub2()).number > 1 and string.format("%.1f", (artifacts:GetSub2()).number) or string.format("%.1f", (100 * (artifacts:GetSub2()).number)).."%"

    local sub3string = TUNING.ARTIFACTS_TYPE[(artifacts:GetSub3()).type]
    local sub3number = (artifacts:GetSub3()).number > 1 and string.format("%.1f", (artifacts:GetSub3()).number) or string.format("%.1f", (100 * (artifacts:GetSub3()).number)).."%"

    local sub4string = TUNING.ARTIFACTS_TYPE[(artifacts:GetSub4()).type]
    local sub4number = (artifacts:GetSub4()).number > 1 and string.format("%.1f", (artifacts:GetSub4()).number) or string.format("%.1f", (100 * (artifacts:GetSub4()).number)).."%"

    local button_switch_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_switch.tex" or "button_switch_en.tex"
    local button_remove_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_remove.tex" or "button_remove_en.tex"
    local button_equip_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_equip.tex" or "button_equip_en.tex"
    -------------------------------------------------------
    self.name_text:Show()
    self.type_text:Show()
    self.sets_text:Show()
    self.main_textbar:Show()
    self.main_text:Show()
    self.main_number:Show()
    self.stars:Show()
    self.sub1_text:Show()
    self.sub2_text:Show()
    self.sub3_text:Show()
    self.sub4_text:Show()
    self.setseffect2_icon:Show()
    self.setseffect2_text:Show()
    self.setseffect4_icon:Show()
    self.setseffect4_text:Show()
    self.button_switch:Show()

    self.name_text:SetString(name)
    self.type_text:SetString(type)
    self.sets_text:SetString(sets)

    self.main_text:SetString(mainstring)
    self.main_number:SetString(mainnumber)
    self.sub1_text:SetString("•"..sub1string.."+"..sub1number)
    self.sub2_text:SetString("•"..sub2string.."+"..sub2number)
    self.sub3_text:SetString("•"..sub3string.."+"..sub3number)
    self.sub4_text:SetString("•"..sub4string.."+"..sub4number)

    self.setseffect2_icon:SetTexture("images/ui/effect_"..status2..".xml", "effect_"..status2..".tex")
    self.setseffect2_text:SetString(setseffect2string)
    self.setseffect2_text:SetColour(effect2_color[1], effect2_color[2], effect2_color[3], effect2_color[4])
    self.setseffect4_icon:SetTexture("images/ui/effect_"..status4..".xml", "effect_"..status4..".tex")
    self.setseffect4_text:SetString(setseffect4string)
    self.setseffect4_text:SetColour(effect4_color[1], effect4_color[2], effect4_color[3], effect4_color[4])

    self.detail_list:UpdateContentHeight()

    if isequipped then
        self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_remove_tex)
        self.button_switch.image_normal = button_remove_tex
        self.button_switch.image_focus = button_remove_tex
        self.button_switch.image_down = button_remove_tex
    elseif hasequip then
        self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_switch_tex)
        self.button_switch.image_normal = button_switch_tex
        self.button_switch.image_focus = button_switch_tex
        self.button_switch.image_down = button_switch_tex
    else
        self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_equip_tex)
        self.button_switch.image_normal = button_equip_tex
        self.button_switch.image_focus = button_equip_tex
        self.button_switch.image_down = button_equip_tex
    end
end

function artifacts_popup:SetItemOnDetail(item)
    for i = 1, self.artnumber do
        self.art[i]:Unselect()
        if self.art[i].tile and self.art[i].tile.item == item then
            self.art[i]:Select()
        end
    end
    --显示详细信息
    self:ShowDetail(item)
    --把中心格换成那个物品
    self.center_slot:SetTile(item ~= nil and ItemTile(item) or nil)
end

function artifacts_popup:SwitchorRemove(item)
    if item == nil then
        return
    end
    local artifacts = item.components.artifacts or item.replica.artifacts
    if artifacts == nil then
        return
    end
    local type = artifacts:GetTag()
    local nowitem = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS[string.upper(type)])
    if item == nowitem then
        --卸下装备
        SendModRPCToServer(MOD_RPC["inventory"]["removeartifacts"], type, item)
    else
        --切换装备
        SendModRPCToServer(MOD_RPC["inventory"]["switchartifacts"], type, item)
    end
end

return artifacts_popup