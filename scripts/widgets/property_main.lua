local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local AttributeScreen = require "widgets/attribute_screen"
local WeaponScreen = require "widgets/weapon_screen"
local ArtifactsScreen = require "widgets/artifacts_screen"
local ConstellationScreen = require "widgets/constellation_screen"
local TalentsScreen = require "widgets/talents_screen"

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

local property_main = Class(Screen, function(self, owner)
    Screen._ctor(self, "property_mainscreen")
	self.owner = owner

	--先搞清人物是什么元素的
	local element = "no"
	local elementstr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "无元素" or "No Element"
	local elements_en = {
		"Pyro",
		"Cryo",
		"Hydro",
		"Electro",
		"Anemo",
		"Geo",
		"Dendro",
	}
	local elements_sc = {
		"火元素",
		"冰元素",
		"水元素",
		"雷元素",
		"风元素",
		"岩元素",
		"草元素",
	}
	for i,v in ipairs (elements_en) do
	    if self.owner:HasTag(v) or self.owner:HasTag(string.upper(v)) or self.owner:HasTag(string.lower(v)) then
		    element = string.lower(v)
		    elementstr = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and elements_sc[i] or v
		end
	end

	--大背景
    self.background = self:AddChild(Image("images/ui/property_background_"..element..".xml", "property_background_"..element..".tex"))
	self.background:SetScale(0.8, 0.8, 0.8)

    ----------------------------------------------------------------------------------------------
	--人物动画
	self.playeranim = self:AddChild(UIAnim())
	self.playeranim:SetPosition(-18, -200, 0)
	self.playeranim:SetScale(1.2,1.2,1.2)
	self.playeranim:GetAnimState():SetBank("wilson")
	self.playeranim:GetAnimState():SetBuild(self.owner.AnimState:GetBuild())
	self.playeranim:SetFacing(FACING_DOWN)

	self.defaultanim = "idle_loop"
    --不得不放到这里
	----------------------------------------------------------------------------------------------

	--命之座界面的遮罩
	self.constellationbg = self:AddChild(ImageButton("images/ui/constellation_bg_shadow.xml", "constellation_bg_shadow.tex"))
	self.constellationbg:SetScale(0.82, 0.82, 0.82)
	self.constellationbg.scale_on_focus = false  --禁止缩放
	self.constellationbg.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.constellationbg:SetOnClick(function()
	    self.constellation_screen:HideConstellation()
	end)

	--天赋界面也有这样的遮罩，不过是透明的
	self.talentsbg = self:AddChild(ImageButton("images/ui.xml", "blank.tex"))
	self.talentsbg:ForceImageSize(1638, 819)  --(2048, 1024) * 0.8
	self.talentsbg.scale_on_focus = false  --禁止缩放
	self.talentsbg.clickoffset = Vector3(0, 0, 0)   --禁止按下移动
	self.talentsbg:SetOnClick(function()
	    self.talents_screen:HideTalent()
	end)
	
	----------------------------------------------------------------------------------------------
	--关闭按钮
	self.mainclose = self:AddChild(ImageButton("images/ui/button_off1.xml","button_off1.tex"))
	self.mainclose:SetPosition(650, 300, 0)
	self.mainclose:SetScale(1,1,1)
	self.mainclose.focus_scale = {1.1,1.1,1.1}
	self.mainclose:SetOnClick(function()
	    if TUNING.CONTROLWITHUI then
			self:Hide()
		else
			TheFrontEnd:PopScreen(self)
		end
	end)

	----------------------------------------------------------------------------------------------
	--显示神之眼样式和人物名字
	local name = STRINGS.CHARACTER_NAMES[self.owner.prefab] or self.owner.prefab
	self.title = self:AddChild(Text("genshinfont", 35, elementstr.." / "..name, {254/255, 235/255, 153/255, 1}))
	self.title:SetHAlign(ANCHOR_LEFT)
    self.title:SetVAlign(ANCHOR_MIDDLE)
    self.title:SetRegionSize(500, 60)
    self.title:EnableWordWrap(true)
	self.title:SetPosition(-350, 300, 0)

	self.vision = self:AddChild(Image("images/ui/"..element.."_vision.xml", element.."_vision.tex"))
	self.vision:SetPosition(-650, 300, 0)

	----------------------------------------------------------------------------------------------
	--左边一列选择按钮
	--第一个，Attribute
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_attribute = self:AddChild(ImageButton("images/ui/button_attribute.xml","button_attribute_normal.tex", "button_attribute_focus.tex", nil, "button_attribute_down.tex", "button_attribute_selected.tex"))
	else
	    self.button_attribute = self:AddChild(ImageButton("images/ui/button_attribute.xml","button_attribute_normal_en.tex", "button_attribute_focus_en.tex", nil, "button_attribute_down_en.tex", "button_attribute_selected_en.tex"))
	end
	self.button_attribute:SetPosition(-450,225,0)
	self.button_attribute:SetScale(0.9,0.9,0.9)
	self.button_attribute.move_on_click = false

	--第二个， Weapons
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_weapons = self:AddChild(ImageButton("images/ui/button_weapons.xml","button_weapons_normal.tex", "button_weapons_focus.tex", nil, "button_weapons_down.tex", "button_weapons_selected.tex"))
	else
	    self.button_weapons = self:AddChild(ImageButton("images/ui/button_weapons.xml","button_weapons_normal_en.tex", "button_weapons_focus_en.tex", nil, "button_weapons_down_en.tex", "button_weapons_selected_en.tex"))
	end
	self.button_weapons:SetPosition(-450,160,0)
	self.button_weapons:SetScale(0.9,0.9,0.9)
	self.button_weapons.move_on_click = false

	--第三个，Artifacts
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_artifacts = self:AddChild(ImageButton("images/ui/button_artifacts.xml","button_artifacts_normal.tex", "button_artifacts_focus.tex", nil, "button_artifacts_down.tex", "button_artifacts_selected.tex"))
	else
	    self.button_artifacts = self:AddChild(ImageButton("images/ui/button_artifacts.xml","button_artifacts_normal_en.tex", "button_artifacts_focus_en.tex", nil, "button_artifacts_down_en.tex", "button_artifacts_selected_en.tex"))
	end
	self.button_artifacts:SetPosition(-450,95,0)
	self.button_artifacts:SetScale(0.9,0.9,0.9)
	self.button_artifacts.move_on_click = false

	--第四个，Constellation
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_constellation = self:AddChild(ImageButton("images/ui/button_constellation.xml","button_constellation_normal.tex", "button_constellation_focus.tex", nil, "button_constellation_down.tex", "button_constellation_selected.tex"))
	else
	    self.button_constellation = self:AddChild(ImageButton("images/ui/button_constellation.xml","button_constellation_normal_en.tex", "button_constellation_focus_en.tex", nil, "button_constellation_down_en.tex", "button_constellation_selected_en.tex"))
	end
	self.button_constellation:SetPosition(-450,30,0)
	self.button_constellation:SetScale(0.9,0.9,0.9)
	self.button_constellation.move_on_click = false

	--第五个，Talents
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_talents = self:AddChild(ImageButton("images/ui/button_talents.xml","button_talents_normal.tex", "button_talents_focus.tex", nil, "button_talents_down.tex", "button_talents_selected.tex"))
	else
	    self.button_talents = self:AddChild(ImageButton("images/ui/button_talents.xml","button_talents_normal_en.tex", "button_talents_focus_en.tex", nil, "button_talents_down_en.tex", "button_talents_selected_en.tex"))
	end
	self.button_talents:SetPosition(-450,-35,0)
	self.button_talents:SetScale(0.9,0.9,0.9)
	self.button_talents.move_on_click = false

	--第六个，Profile
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.button_profile = self:AddChild(ImageButton("images/ui/button_profile.xml","button_profile_normal.tex", "button_profile_focus.tex", nil, "button_profile_down.tex", "button_profile_selected.tex"))
	else
	    self.button_profile = self:AddChild(ImageButton("images/ui/button_profile.xml","button_profile_normal_en.tex", "button_profile_focus_en.tex", nil, "button_profile_down_en.tex", "button_profile_selected_en.tex"))
	end
	self.button_profile:SetPosition(-450,-100,0)
	self.button_profile:SetScale(0.9,0.9,0.9)
	self.button_profile.move_on_click = false

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------
	--Attribute界面
	self.attribute_screen = self:AddChild(AttributeScreen(self.owner))
	self.attribute_screen:SetScale(0.9, 0.9, 0.9)
    
	----------------------------------------------------------------------------------------------
	--Weapon界面
	self.weapon_screen = self:AddChild(WeaponScreen(self.owner))
	self.weapon_screen:SetScale(0.9, 0.9, 0.9)
	----------------------------------------------------------------------------------------------
	--Artifacts界面
	self.artifacts_screen = self:AddChild(ArtifactsScreen(self.owner))
	self.artifacts_screen:SetScale(0.9, 0.9, 0.9)
	
	----------------------------------------------------------------------------------------------
	--Constellation界面
	self.constellation_screen = self:AddChild(ConstellationScreen(self.owner))
	self.constellation_screen:SetScale(0.9, 0.9, 0.9)
	----------------------------------------------------------------------------------------------
	--Talents界面
    self.talents_screen = self:AddChild(TalentsScreen(self.owner))
	self.talents_screen:SetScale(0.9, 0.9, 0.9)
	----------------------------------------------------------------------------------------------
	--Profile界面

	----------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------

	--按钮按下动作
	local choosebuttons = {
		self.button_attribute,
		self.button_weapons,
		self.button_artifacts,
		self.button_constellation,
		self.button_talents,
		self.button_profile,
	}
	local screens = {
		self.attribute_screen,
		self.weapon_screen,
		self.artifacts_screen,
		self.constellation_screen,
		self.talents_screen,
		--self.profile_screen,
	}

	self.button_attribute:SetOnClick(function()
	    self.button_attribute:Select()
		self.attribute_screen:Show()
		self.playeranim:GetAnimState():Show("ARM_normal")
		self.playeranim:GetAnimState():Hide("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_attribute then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    if v ~= self.attribute_screen then
			    v:Hide()
			end
		end
		self.constellationbg:Hide()
		self.talentsbg:Hide()
	end)

	self.button_weapons:SetOnClick(function()
	    self.button_weapons:Select()
		self.weapon_screen:Show()
		self.playeranim:GetAnimState():Hide("ARM_normal")
		self.playeranim:GetAnimState():Show("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_weapons then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    if v ~= self.weapon_screen then
			    v:Hide()
			end
		end
		self.constellationbg:Hide()
		self.talentsbg:Hide()
	end)

	self.button_artifacts:SetOnClick(function()
	    self.button_artifacts:Select()
		self.artifacts_screen:Show()
		self.playeranim:GetAnimState():Show("ARM_normal")
		self.playeranim:GetAnimState():Hide("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)--用什么动画呢
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_artifacts then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    if v ~= self.artifacts_screen then
			    v:Hide()
			end
		end
		self.constellationbg:Hide()
		self.talentsbg:Hide()
	end)

	self.button_constellation:SetOnClick(function()
	    self.button_constellation:Select()
		self.constellation_screen:Show()
		self.playeranim:GetAnimState():Show("ARM_normal")
		self.playeranim:GetAnimState():Hide("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)--不需要设置什么动画
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_constellation then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    if v ~= self.constellation_screen then
			    v:Hide()
			end
		end
		self.constellationbg:Show()
		self.talentsbg:Hide()
	end)

	self.button_talents:SetOnClick(function()
	    self.button_talents:Select()
		self.talents_screen:Show()
		self.playeranim:GetAnimState():Show("ARM_normal")
		self.playeranim:GetAnimState():Hide("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)--用什么动画呢
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_talents then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    if v ~= self.talents_screen then
			    v:Hide()
			end
		end
		self.constellationbg:Hide()
		self.talentsbg:Show()
	end)

	self.button_profile:SetOnClick(function()
	    self.button_profile:Select()
		--self.profile_screen:Show()
		self.playeranim:GetAnimState():Show("ARM_normal")
		self.playeranim:GetAnimState():Hide("ARM_carry")
		if not self.playeranim:GetAnimState():IsCurrentAnimation(self.defaultanim) then
	        self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)
		end
		for k,v in pairs(choosebuttons) do
		    if v ~= self.button_profile then
			    v:Unselect()
			end
		end
		for k,v in pairs(screens) do
		    --if v ~= self.profile_screen then
			    v:Hide()
			--end
		end
		self.constellationbg:Hide()
		self.talentsbg:Hide()
	end)

	-----------------------------------------------------------
    --监听事件刷新
    self.inst:ListenForEvent("equip", function() SendModRPCToServer(MOD_RPC["combatdata"]["combat"]) end, owner)
    self.inst:ListenForEvent("unequip", function() SendModRPCToServer(MOD_RPC["combatdata"]["combat"]) end, owner)

	-----------------------------------------------------------
    --初始化
	self.button_attribute:Select()

	self.attribute_screen:Show()
	self.weapon_screen:Hide()
	self.artifacts_screen:Hide()
	self.constellation_screen:Hide()
	self.talents_screen:Hide()

	self.constellationbg:Hide()
	self.talentsbg:Hide()
	----------------------------
	self.playeranim:GetAnimState():Hide("ARM_carry")
	self.playeranim:GetAnimState():PlayAnimation(self.defaultanim, true)
	self:StartUpdating()
end)

---------------------------------------------------------------------------------------
--------------------------------------Update-------------------------------------------

function property_main:UpdatePlayer()
    local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus

	--在命之座界面不显示人物
	if self.button_constellation.selected == true then
	    self.playeranim:Hide()
	elseif self.playeranim.shown == false then
	    self.playeranim:Show()
	end

	--获取人物动画数据
    local bank, animation, skin_mode, scale, y_offset = GetPlayerBadgeData(self.owner.prefab, false, false, false, false)
	self.playeranim:GetAnimState():SetBank(bank)
	self.defaultanim = bank == "ghost" and animation or "idle_loop"

    --print(GetSkinModes(self.owner.prefab)[1].type)

	--获取皮肤
	local clothing = combatstatus and combatstatus:GetClothing() or {}

	if clothing == nil or clothing.base == nil then
		return
	end
	local base_build = string.find(clothing.base, "none") ~= nil and self.owner.AnimState:GetBuild() or clothing.base
	--print(clothing.base)
	--print(base_build)

	--设置人物皮肤
	SetSkinsOnAnim(self.playeranim:GetAnimState(), self.owner.prefab, base_build, clothing, skin_mode)
end

function property_main:UpdateWeapon()
    local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus

    if combatstatus == nil then
		return
	end

	--获取武器
	local weapon = combatstatus:GetWeapon()
	if weapon == nil or weapon:HasTag("player") then
	    self.playeranim:GetAnimState():ClearOverrideSymbol("swap_object")
	    return
	end

	if weapon.weaponscreen_override ~= nil then
        self.playeranim:GetAnimState():OverrideSymbol("swap_object", weapon.weaponscreen_override.build, weapon.weaponscreen_override.folder)
    else
		--获取build并判断皮肤
		if weapon.AnimState == nil then
			return
		end
		local weaponbuild = weapon and weapon.AnimState:GetBuild() or ""
		local skin_build = weapon.AnimState:GetSkinBuild() ~= "" and weapon.AnimState:GetSkinBuild() or nil --weapon:GetSkinBuild()
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
		if skin_build ~= nil then
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
				self.playeranim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, swap_weaponbuild, weapon.GUID,
					"swap_staffs")
			elseif weaponbuild == "multitool_axe_pickaxe" then
				self.playeranim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, "swap_object", weapon.GUID,
					swap_weaponbuild)
			else
				self.playeranim:GetAnimState():OverrideItemSkinSymbol("swap_object", skin_build, swap_weaponbuild, weapon.GUID,
					swap_weaponbuild)
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
				self.playeranim:GetAnimState():OverrideSymbol("swap_object", "swap_staffs", swap_weaponbuild)
			elseif weaponbuild == "multitool_axe_pickaxe" then
				self.playeranim:GetAnimState():OverrideSymbol("swap_object", swap_weaponbuild, "swap_object")
			else
				self.playeranim:GetAnimState():OverrideSymbol("swap_object", swap_weaponbuild, swap_weaponbuild)
			end
		end
	end
	--print(weapon, weaponbuild, swap_weaponbuild, "\n", skin_build, "\n*****************************")
end

function property_main:OnUpdate(dt)
    --人物
    self:UpdatePlayer()
	---------------------------------------------------
	--武器
	self:UpdateWeapon()
	return true
end

function property_main:OnDestroy()
	self:Hide()
end

function property_main:OnBecomeInactive()
	self.last_focus = self:GetDeepestFocus()
	self:Hide()
end

function property_main:OnBecomeActive()
	TheSim:SetUIRoot(self.inst.entity)
	if self.last_focus and self.last_focus.inst.entity:IsValid() then
		self.last_focus:SetFocus()
	else
		self.last_focus = nil
		if self.default_focus then
			self.default_focus:SetFocus()
		end
	end

	self:SetPosition(155 + 800 * TUNING.GENSHINCORE_UISCALE, 120 + 400 * TUNING.GENSHINCORE_UISCALE, 0)
	self:SetScale(TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE)
    self:Show()
end

return property_main