local PropertyMain = require "widgets/property_main"
local ImageButton = require "widgets/imagebutton"
local damageind_screen = require "widgets/damageind_screen"
local InvSlot = require "widgets/invslot"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local ItemTile = require "widgets/itemtile"
local Teleport_Waypoint_Button = require "widgets/teleport_waypoint_button"
local Teleport_Infopanel = require "widgets/teleport_infopanel"
local writeables = require "writeables"

--------------------------------------------------------------------------
--添加自定义UI
--
AddClassPostConstruct("widgets/controls",function(self)        
	if self.owner and self.owner:HasTag("player") then
	    self.openproperty = self:AddChild(ImageButton("images/ui/button_on.xml","button_on.tex"))
		self.openproperty:SetPosition(100,100,0)
	    self.openproperty:SetScale(1,1,1)
		self.openproperty.focus_scale = {1.1,1.1,1.1}
	    self.openproperty:SetOnClick(function()
			SendModRPCToServer(MOD_RPC["combatdata"]["combat"])
			if self.property_main.shown then
				if TUNING.CONTROLWITHUI then
					self.property_main:Hide()
				else
				    TheFrontEnd:PopScreen(self.property_main)
				end
			else
				if TUNING.CONTROLWITHUI then
					self.property_main:Show()
				else
				    TheFrontEnd:PushScreen(self.property_main)
				end
			end
	    end)

        if TUNING.DMGIND_ENABLE then
			self.Dmgind_Screen = self:AddChild(damageind_screen(self.owner))
			self.Dmgind_Screen:MoveToFront()
		end

		self.property_main = PropertyMain(self.owner)
		if TUNING.CONTROLWITHUI then
			self:AddChild(self.property_main)
			local screen_width, screen_height = TheSim:GetScreenSize()
			self.property_main:SetPosition(screen_width / 2, screen_height / 2, 0)
			self.property_main:SetScale(TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE)
		end
		self.property_main:MoveToFront()
		self.property_main:Hide(-1)
	end
end)

--------------------------------------------------------------------------
--修改Map
AddClassPostConstruct("screens/mapscreen", function(self)  -- 给小地图添加传送锚点按钮，这个过程会
    if self.owner.registered_waypoint == nil then
		return
	end
	self.wp_btns = {}
	for k, v in pairs(self.owner.registered_waypoint) do
		if v ~= nil then
			self.wp_btns[k] = self:AddChild(Teleport_Waypoint_Button(self.owner, k, v.pos, v.info))
			self.wp_btns[k]:SetOnClick(function ()
				self:ShowInfo(k)
			end)
		end
	end
	self.tp_panel_open = false

	local w, h = TheSim:GetScreenSize()
	-- local scale = h / origin_size.y
	self.TP_Panel = self:AddChild(Teleport_Infopanel(self.owner, w, h))
	-- self.TP_Panel:SetScale(scale, scale, scale)
	self.TP_Panel:SetPosition(0.5 * w, 0.5 * h, 0)
	self.TP_Panel:Hide(-1)

	function self:ShowInfo(wp_id)
		for k, v in pairs(self.wp_btns) do
			if k ~= wp_id then
				v:Unselect()
			else
				v:Select()
				self.TP_Panel:ShowInfo(v.world_pos, v.custom_info)
			end
		end
		self.tp_panel_open = true
	end

	function self:HideInfo()
		for k, v in pairs(self.wp_btns) do
			v:Unselect()
			v:StartUpdating()
		end
		-- self.TP_Panel:Hide() 已经在那一边做了
		self.tp_panel_open = false
	end

	--禁止在打开状态点击其它东西比如转视角
	local old_OnControl = self.OnControl
	function self:OnControl(control, down)
		if self.tp_panel_open then
			for k, v in pairs(self.wp_btns) do
				if v:OnControl(control, down) then
					return true
				end
			end
			return self.TP_Panel:OnControl(control, down)
		end
	
		return old_OnControl(self, control, down)
	end
	--禁止在打开状态缩放
	local old_DoZoomIn = self.DoZoomIn
	local old_DoZoomOut = self.DoZoomOut
	function self:DoZoomIn(...)
		if self.tp_panel_open then
			return
		end
		return old_DoZoomIn(self, ...)
	end
	function self:DoZoomOut(...)
		if self.tp_panel_open then
			return
		end
		return old_DoZoomOut(self, ...)
	end
	--禁止在打开状态拖动
	local old_MapWidget_Update = self.minimap.OnUpdate
	local function MapWidget_OnUpdate(self, ...)
		if self.parent.tp_panel_open then
			return
		end
		old_MapWidget_Update(self, ...)
	end
	self.minimap.OnUpdate = MapWidget_OnUpdate
end)

--------------------------------------------------------------------------
--修改container

AddClassPostConstruct("widgets/containerwidget",function(self)      
	local old_Open = self.Open
	function self:Open(container, doer)
		local widget = container.replica.container:GetWidget()
		if not (widget and widget.buttoninfo ~= nil and widget.buttoninfo.genshinstylebutton) then
			old_Open(self, container, doer)
			return
		end
		self:Close()

		if widget.bgatlas ~= nil and widget.bgimage ~= nil then
			self.bgimage:SetTexture(widget.bgatlas, widget.bgimage)
		end

		if widget.animbank ~= nil then
			self.bganim:GetAnimState():SetBank(widget.animbank)
		end

		if widget.animbuild ~= nil then
			self.bganim:GetAnimState():SetBuild(widget.animbuild)
		end

		if widget.pos ~= nil then
			self:SetPosition(widget.pos)
		end

		if widget.hinttext ~= nil then
			local hinttext = widget.hinttext
			self.hint_t = self:AddChild(Text(hinttext.font or "genshinfont", hinttext.size or 34, hinttext.text or "", hinttext.color or {1, 1, 1, 1}))
			if hinttext.position ~= nil then
				self.hint_t:SetPosition(hinttext.position)
			end
			if hinttext.regionsize ~= nil then
				self.hint_t:SetHAlign(ANCHOR_LEFT)
    			self.hint_t:SetVAlign(ANCHOR_MIDDLE)
				self.hint_t:SetRegionSize(hinttext.regionsize.x, hinttext.regionsize.y)
    			self.hint_t:EnableWordWrap(true)
			end
		end

		if widget.buttoninfo ~= nil then
			if doer ~= nil and doer.components.playeractionpicker ~= nil then
				doer.components.playeractionpicker:RegisterContainer(container)
			end

			self.button = self:AddChild(ImageButton("images/ui/button_talentupgrade_confirm.xml", "button_talentupgrade_confirm.tex", nil, "button_talentupgrade_confirm_disabled.tex"))
			self.button:SetPosition(widget.buttoninfo.position)
			self.button:SetText(widget.buttoninfo.text)
			if widget.buttoninfo.fn ~= nil then
				self.button:SetOnClick(function()
					if doer ~= nil then
						if doer:HasTag("busy") then
							--Ignore button click when doer is busy
							return
						elseif doer.components.playercontroller ~= nil then
							local iscontrolsenabled, ishudblocking = doer.components.playercontroller:IsEnabled()
							if not (iscontrolsenabled or ishudblocking) then
								--Ignore button click when controls are disabled
								--but not just because of the HUD blocking input
								return
							end
						end
					end
					widget.buttoninfo.fn(container, doer)
				end)
			end
    		self.button:SetFont("genshinfont")
    		self.button:SetDisabledFont("genshinfont")
    		self.button:SetTextSize(78)
    		self.button:SetTextColour(59/255, 66/255, 85/255, 1)
    		self.button:SetTextFocusColour(59/255, 66/255, 85/255, 1)
    		self.button:SetTextDisabledColour(150/255, 150/255, 150/255, 1)
    		self.button.text:SetPosition(0, 0, 0)
    		self.button.text:Show()
    		self.button:SetScale(0.46, 0.46, 0.46)
    		self.button.focus_scale = {1.05, 1.05, 1.05}

			if widget.buttoninfo.validfn ~= nil then
				if widget.buttoninfo.validfn(container) then
					self.button:Enable()
				else
					self.button:Disable()
				end
			end

			if TheInput:ControllerAttached() then
				self.button:Hide()
			end

			self.button.inst:ListenForEvent("continuefrompause", function()
				if TheInput:ControllerAttached() then
					self.button:Hide()
				else
					self.button:Show()
				end
			end, TheWorld)
		end

		self.isopen = true
		self:Show()

		if self.bgimage.texture then
			self.bgimage:Show()
		else
			self.bganim:GetAnimState():PlayAnimation("open")
		end

		self.onitemlosefn = function(inst, data) self:OnItemLose(data) end
		self.inst:ListenForEvent("itemlose", self.onitemlosefn, container)

		self.onitemgetfn = function(inst, data) self:OnItemGet(data) end
		self.inst:ListenForEvent("itemget", self.onitemgetfn, container)

		self.onrefreshfn = function(inst, data) self:Refresh() end
		self.inst:ListenForEvent("refresh", self.onrefreshfn, container)

		local constructionsite = doer.components.constructionbuilderuidata ~= nil and
			doer.components.constructionbuilderuidata:GetContainer() == container and
			doer.components.constructionbuilderuidata:GetConstructionSite() or nil
		local constructionmats = constructionsite ~= nil and constructionsite:GetIngredients() or nil

		for i, v in ipairs(widget.slotpos or {}) do
			local bgoverride = widget.slotbg ~= nil and widget.slotbg[i] or nil
			local slot = InvSlot(i,
				bgoverride ~= nil and bgoverride.atlas or "images/hud.xml",
				bgoverride ~= nil and bgoverride.image or (constructionmats ~= nil and "inv_slot_construction.tex" or "inv_slot.tex"
				),
				self.owner,
				container.replica.container
			)
			if bgoverride and bgoverride.highlight_scale ~= nil then
				slot.highlight_scale = bgoverride.highlight_scale
			end
			if bgoverride and (bgoverride.tile_scale ~= nil or bgoverride.tile_offset ~= nil) then
				local function ontilechanged(self, tile)
					if tile ~= nil then
						tile:SetScale(bgoverride.tile_scale or 1)
						tile:SetPosition(bgoverride.tile_offset)
						if bgoverride.atlas_full and bgoverride.image_full then
							self.bgimage:SetTexture(bgoverride.atlas_full, bgoverride.image_full)
						end
					else
						self.bgimage:SetTexture(bgoverride.atlas, bgoverride.image)
					end
				end
				slot:SetOnTileChangedFn(ontilechanged)
			end
			self.inv[i] = self:AddChild(slot)

			slot:SetPosition(v)

			if not container.replica.container:IsSideWidget() then
				if widget.top_align_tip ~= nil then
					slot.top_align_tip = widget.top_align_tip
				else
					slot.side_align_tip = (widget.side_align_tip or 0) - v.x
				end
			end

			if constructionmats ~= nil and constructionsite ~= nil then
				slot:ConvertToConstructionSlot(constructionmats[i], constructionsite:GetSlotCount(i))
			end
		end

		self.container = container

		self:Refresh()

	end
end)

----------------------------------------------------------------
--添加新的writeables布局
local SignGenerator = require "signgenerator"
local tp_wp_layout = {
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
            widget:OverrideText( SignGenerator(inst, doer) )
        end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
}
writeables.AddLayout("teleport_waypoint", tp_wp_layout)