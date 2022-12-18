local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"
local ArtSlot = require "widgets/artslot"
local Artifacts_ItemTile = require "widgets/artifacts_itemtile"
local ScrollArea = require "widgets/scrollarea"
local Artifacts_Scroll = require "widgets/artifacts_scroll"
local Artifacts_SortPanel = require "widgets/artifacts_sortpanel"
local Artifacts_FilterPanel = require "widgets/artifacts_filterpanel"

local TYPES = {
    "flower",
    "plume",
    "sands",
    "goblet",
    "circlet",
}

local artifacts_popup = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	
    self.currenttype = "flower"

    self.sortkeys = {}

    self.filter = "all"

	----------------------------------------------------------------------------------------------
    --中心显示器
	self.center_slot = self:AddChild(ArtSlot(owner, "images/ui/art_bg.xml", "art_bg.tex"))
    self.center_slot:SetPosition(-20, -125, 0)
    self.center_slot:SetScale(1.8,1.8,1.8)
    self.center_slot.highlight_scale = 1.8
    self.center_slot.base_scale = 1.8
    self.center_slot:SetClickable(false)

    self.center_emptywarning = self:AddChild(Image("images/ui/slotempty.xml", "slotempty.tex"))
    self.center_emptywarning:SetPosition(25, -75, 0)
    self.center_emptywarning:SetScale(0.6, 0.6, 0.6)
    self.center_emptywarning:Hide(-1)

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
    --属性排序面板
    self.sort_panel = self:AddChild(Artifacts_SortPanel(self.owner, self))
    self.sort_panel:SetPosition(-520, -5, 0)
    self.sort_panel:Hide(-1)

    self.sort_button = self:AddChild(ImageButton("images/ui/button_art_sort.xml","button_art_sort.tex"))
    self.sort_button:SetPosition(-330, -320, 0)
	self.sort_button:SetScale(0.8, 0.8, 0.8)
	self.sort_button.focus_scale = {1.1,1.1,1.1}
    self.sort_button:SetOnClick(function ()
        if self.sort_panel.shown then
            self:HideTwoPanels()
        else
            self:ShowSortPanel()
        end
    end)

    ----------------------------------------------------------------------------------------------
    --过滤器面板
    self.filter_panel = self:AddChild(Artifacts_FilterPanel(self.owner, self))
    self.filter_panel:SetPosition(-520, -10, 0)
    self.filter_panel:Hide(-1)

    self.filter_button = self:AddChild(ImageButton("images/ui/button_art_filter.xml","button_art_filter.tex"))
    self.filter_button:SetText("")
    self.filter_button:SetFont("genshinfont")
    self.filter_button:SetTextSize(40)
    self.filter_button:SetTextColour(59/255, 66/255, 85/255, 1)
    self.filter_button:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    self.filter_button.text:SetHAlign(ANCHOR_LEFT)
    self.filter_button.text:SetVAlign(ANCHOR_MIDDLE)
    self.filter_button.text:SetRegionSize(360, 80)
    self.filter_button.text:EnableWordWrap(true)
    self.filter_button.text:SetPosition(2.5, -2.5, 0)
    self.filter_button.text:Show()
    self.filter_button:SetPosition(-550, -320, 0)
	self.filter_button:SetScale(0.75, 0.75, 0.75)
	self.filter_button.focus_scale = {1.05, 1.05, 1.05}
    self.filter_button:SetOnClick(function ()
        if self.filter_panel.shown then
            self:HideTwoPanels()
        else
            self:ShowFilterPanel()
        end
    end)

    self:SetFilter("all", true)

    ----------------------------------------------------------------------------------------------
    --左侧圣遗物显示区先显示为空
    self.artscroll = self:AddChild(Artifacts_Scroll(450, 520, {}, {x_pos = {-162, -54, 54, 162}, height = 116, padding_vertical = 13}))
    self.artscroll:SetPosition(-520, -10, 0)
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
    --圣遗物锁定按钮
    self.button_lock = ImageButton("images/ui/art_button_lock.xml","art_button_lock_unlocked.tex")
    self.detail_list:AddItem(self.button_lock)
    self.button_lock:SetPosition(96, -78, 0)
    self.button_lock:SetOnClick(nil)
    self.button_lock.focus_scale = {1.07, 1.07, 1.07}
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
    self.button_switch = self:AddChild(GMultiLayerButton(GetNoiconGButtonConfig("light", "long")))
    self.button_switch:SetPosition(455, -300, 0)
    self.button_switch:SetScale(0.8, 0.8, 0.8)
    self.button_switch:SetText(TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "切换" or "Switch")

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
    ----------------------------------------------------------------------------------------------

    self.blankbtn = self:AddChild(ImageButton("images/ui.xml", "blank.tex"))
	self.blankbtn:ForceImageSize(1638, 819)  --(2048, 1024) * 0.8
	self.blankbtn.scale_on_focus = false  --禁止缩放
	self.blankbtn.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.blankbtn:SetOnClick(function()
	    self:HideTwoPanels()
	end)
    self.blankbtn:Hide(-1)
    self.filter_button:MoveToFront()
    self.sort_button:MoveToFront()
    self.filter_panel:MoveToFront()
    self.sort_panel:MoveToFront()
end)

function artifacts_popup:OnHide()
    -- 用于修复中心显示器延迟Hide的BUG：立即Hide它
    self.center_slot:Hide(-1)
end

function artifacts_popup:OnShow()
    -- 与上面的OnHide对应，此处需要立即显示
    self.center_slot:Show(-1)
end

function artifacts_popup:ShowSortPanel()
    self.sort_panel:Show()
    self.filter_panel:Hide()
    self.artscroll:Hide()

    self.blankbtn:Show()
end

function artifacts_popup:ShowFilterPanel()
    self.sort_panel:Hide()
    self.filter_panel:Show()
    self.artscroll:Hide()

    self.blankbtn:Show()
end

function artifacts_popup:HideTwoPanels()
    self.sort_panel:Hide()
    self.filter_panel:Hide()
    self.artscroll:Show()

    self.blankbtn:Hide()
end

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

function artifacts_popup:SetSortKeys(keys)
    for k, v in pairs(keys) do
        print(v)
    end
    self.sortkeys = keys
    self.artscroll:CompletelyChangeItem(self:Sort(self.sortkeys))
end

function artifacts_popup:SetFilter(filter, initial)
    self.filter = filter
    local basestr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "套装筛选 / " or "Set Filter / "
    local namestr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "全部" or "All"
    if TUNING.ARTIFACTS_SETS[filter] ~= nil then
        namestr = TUNING.ARTIFACTS_SETS[filter]
    end
    self.filter_button:SetText(basestr..namestr)
    if initial then
        return
    end
    self:SetType(self.currenttype)
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

    -- --把之前显示的全部清除
    for k = 1, self.artnumber do
        self.art[k]:Kill()
    end
    self.art = {}

    --显示物品栏和背包中所有带有该类型圣遗物标签的物品
    local i = 0  
    --一号位是穿在身上的那个
    if mainitem ~= nil and mainitem:HasTag("artifacts_"..self.filter) then
        i = i + 1
        self.art[i] = ArtSlot(self.owner, "images/ui/art_slotbg.xml", "art_slotbg.tex", {tile_scale = 1.2, tile_x = 0, tile_y = 10}, "art_slotbg_hl.tex")
		self.art[i]:SetScale(1)
        self.art[i]:SetTile(Artifacts_ItemTile(mainitem))
        self.art[i]:SetOnClick(function() self:SetItemOnDetail(mainitem) end)
        self.art[i].ownericon:Show(-1)
        local artifacts = mainitem.components.artifacts or mainitem.replica.artifacts
        if artifacts and artifacts:IsLocked() then
            self.art[i].lockicon:Show(-1)
        end
    end
    --然后是物品栏里的
    for k = 1, num_slots_inventory do
        local item = inventory:GetItemInSlot(k)
        if item and item:HasTag("artifacts_"..self.currenttype) and item:HasTag("artifacts_"..self.filter) then
            i = i + 1
            self.art[i] = ArtSlot(self.owner, "images/ui/art_slotbg.xml", "art_slotbg.tex", {tile_scale = 1.2, tile_x = 0, tile_y = 10}, "art_slotbg_hl.tex")
		    self.art[i]:SetScale(1)
            self.art[i]:SetTile(Artifacts_ItemTile(item))
            self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
            local artifacts = item.components.artifacts or item.replica.artifacts
            if artifacts and artifacts:IsLocked() then
                self.art[i].lockicon:Show(-1)
            end
        end
    end
    --然后是背包里的
    if overflow ~= nil then
        local num_slots_backpack = overflow:GetNumSlots()
        for k = 1, num_slots_backpack do
            local item = overflow:GetItemInSlot(k)
            if item and item:HasTag("artifacts_"..self.currenttype) and item:HasTag("artifacts_"..self.filter) then
                i = i + 1
                self.art[i] = ArtSlot(self.owner, "images/ui/art_slotbg.xml", "art_slotbg.tex", {tile_scale = 1.2, tile_x = 0, tile_y = 10}, "art_slotbg_hl.tex")
		        self.art[i]:SetScale(1)
                self.art[i]:SetTile(Artifacts_ItemTile(item))
                self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
                local artifacts = item.components.artifacts or item.replica.artifacts
                if artifacts and artifacts:IsLocked() then
                    self.art[i].lockicon:Show(-1)
                end
            end
        end
    end
    --最后是圣遗物箱子里面的
    if #artifactsbackpacks > 0 then
        for t,v in pairs(artifactsbackpacks) do
            local num_slots_artbackpack = v:GetNumSlots()
            for k = 1, num_slots_artbackpack do
                local item = v:GetItemInSlot(k)
                if item and item:HasTag("artifacts_"..self.currenttype) and item:HasTag("artifacts_"..self.filter) then
                    i = i + 1
                    self.art[i] = ArtSlot(self.owner, "images/ui/art_slotbg.xml", "art_slotbg.tex", {tile_scale = 1.2, tile_x = 0, tile_y = 10}, "art_slotbg_hl.tex")
		            self.art[i]:SetScale(1)
                    self.art[i]:SetTile(Artifacts_ItemTile(item))
                    self.art[i]:SetOnClick(function() self:SetItemOnDetail(item) end)
                    local artifacts = item.components.artifacts or item.replica.artifacts
                    if artifacts and artifacts:IsLocked() then
                        self.art[i].lockicon:Show(-1)
                    end
                end
            end
        end
    end

    --排序

    --记录一下数字
    self.artnumber = i
    self.artscroll:CompletelyChangeItem(self:Sort(self.sortkeys))
    --如果有就显示信息，没有显示没有
    if self.artnumber > 0 then
        self.art[1].onclick(self)
    else
        self:HideDetail()
        self.center_slot:SetTile(nil)
    end
end

function artifacts_popup:Sort(sortkeys)
    if sortkeys == nil then
        sortkeys = {}
    end

    local function sortfunc(a, b)
        local item_a = a.tile.item
        local item_b = b.tile.item
        if item_a == nil or item_b == nil then
            return false
        end

        local artifacts_a = item_a.components.artifacts or item_a.replica.artifacts
        local artifacts_b = item_b.components.artifacts or item_b.replica.artifacts
        if artifacts_a == nil or artifacts_b == nil then
            return item_a.GUID > item_b.GUID
        end
        
        for k, v in pairs(sortkeys) do
            local value_a = artifacts_a:GetValueOfType(v)
            local value_b = artifacts_b:GetValueOfType(v)
            if value_a > value_b then
                return true
            elseif value_a < value_b then
                return false
            end
        end
        return item_a.GUID > item_b.GUID
    end

    local result = {}
    for k, v in pairs(self.art) do
        table.insert(result, v)
    end
    table.sort(result, sortfunc)
    return result
end

function artifacts_popup:HideDetail()
    self.name_text:Hide()
    self.button_lock:Hide()
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

    self.button_lock:SetOnClick(nil)

    --显示左边大字
    self.noartifacts_title:Show()
    self.noartifacts_title:SetString(TUNING.ARTIFACTS_TAG[self.currenttype])
    self.noartifacts_text:Show()
end

function artifacts_popup:ShowDetail(item, index)
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

    -- local button_switch_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_switch.tex" or "button_switch_en.tex"
    -- local button_remove_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_remove.tex" or "button_remove_en.tex"
    -- local button_equip_tex = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "button_equip.tex" or "button_equip_en.tex"
    local button_switch_str = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "切换" or "Switch"
    local button_remove_str = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "卸下" or "Remove"
    local button_equip_str = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "装备" or "Equip"
    -------------------------------------------------------
    self.name_text:Show()
    self.button_lock:Show()
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
    self.sub1_text:SetString("·"..sub1string.."+"..sub1number)
    self.sub2_text:SetString("·"..sub2string.."+"..sub2number)
    self.sub3_text:SetString("·"..sub3string.."+"..sub3number)
    self.sub4_text:SetString("·"..sub4string.."+"..sub4number)

    self.setseffect2_icon:SetTexture("images/ui/effect_"..status2..".xml", "effect_"..status2..".tex")
    self.setseffect2_text:SetString(setseffect2string)
    self.setseffect2_text:SetColour(effect2_color[1], effect2_color[2], effect2_color[3], effect2_color[4])
    self.setseffect4_icon:SetTexture("images/ui/effect_"..status4..".xml", "effect_"..status4..".tex")
    self.setseffect4_text:SetString(setseffect4string)
    self.setseffect4_text:SetColour(effect4_color[1], effect4_color[2], effect4_color[3], effect4_color[4])

    self.detail_list:UpdateContentHeight()

    local cur_locked = artifacts:IsLocked()
    if cur_locked then
        self.button_lock:SetTextures("images/ui/art_button_lock.xml","art_button_lock_locked.tex")
    else
        self.button_lock:SetTextures("images/ui/art_button_lock.xml","art_button_lock_unlocked.tex")
    end
    self.button_lock:SetOnClick(function ()
        local locked = artifacts:IsLocked()
        SendModRPCToServer(MOD_RPC["artifacts"]["lock"], not locked, item)
        if locked and index ~= nil then  --原先是锁定状态，现在解锁了
            self.art[index].lockicon:Hide()
            self.button_lock:SetTextures("images/ui/art_button_lock.xml","art_button_lock_unlocked.tex")
        else
            self.art[index].lockicon:Show()
            self.button_lock:SetTextures("images/ui/art_button_lock.xml","art_button_lock_locked.tex")
        end
    end)

    if isequipped then
        self.button_switch:SetText(button_remove_str)
        -- self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_remove_tex)
        -- self.button_switch.image_normal = button_remove_tex
        -- self.button_switch.image_focus = button_remove_tex
        -- self.button_switch.image_down = button_remove_tex
    elseif hasequip then
        self.button_switch:SetText(button_switch_str)
        -- self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_switch_tex)
        -- self.button_switch.image_normal = button_switch_tex
        -- self.button_switch.image_focus = button_switch_tex
        -- self.button_switch.image_down = button_switch_tex
    else
        self.button_switch:SetText(button_equip_str)
        -- self.button_switch.image:SetTexture("images/ui/button_switch.xml", button_equip_tex)
        -- self.button_switch.image_normal = button_equip_tex
        -- self.button_switch.image_focus = button_equip_tex
        -- self.button_switch.image_down = button_equip_tex
    end
end

function artifacts_popup:SetItemOnDetail(item)
    local index
    for i = 1, self.artnumber do
        if self.art[i].tile and self.art[i].tile.item == item then
            self.art[i]:Select()
            index = i
        else
            self.art[i]:Unselect()
        end
    end
    --显示详细信息
    self:ShowDetail(item, index)
    --把中心格换成那个物品
    self.center_slot:SetTile(item ~= nil and Artifacts_ItemTile(item) or nil)
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