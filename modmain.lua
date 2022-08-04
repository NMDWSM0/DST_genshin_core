---@diagnostic disable: lowercase-global

----------------------------------------------------
----------------- 非常危险的尝试 -------------------

local ModManager = GLOBAL.ModManager

local runmodfn = function(fn,mod,modtype)
	return (function(...)
		if fn then
			local status, r = xpcall( function() return fn(unpack(arg)) end, debug.traceback)
			if not status then
				print("error calling "..modtype.." in mod "..ModInfoname(mod.modname)..": \n"..r)
				ModManager:RemoveBadMod(mod.modname,r)
				ModManager:DisplayBadMods()
			else
				return r
			end
		end
	end)
end

function ModManager:GetPostInitFns(type, id)
    local retfns = {}
	for i,modname in ipairs(self.enabledmods) do
		local mod = self:GetMod(modname)
		if mod.postinitfns[type] then
			local modfns = nil
			if id then
				modfns = mod.postinitfns[type][id]
			else
				modfns = mod.postinitfns[type]
			end

			--变相实现AddStateGrapghPostInitAny
			if type == "StategraphPostInit" and mod.postinitfns[type]["nil"] ~= nil then
			    for i,modfn in ipairs(mod.postinitfns[type]["nil"]) do
				    table.insert(retfns, runmodfn(modfn, mod, type))
				end
			end
			--然而此行为非常危险，如果哪天官方改底层，我就没了
			--其实对所有sg修改本身就很危险，所以修改的时候，一定要多加判断

			if modfns ~= nil then
				for i,modfn in ipairs(modfns) do
					--print(modname, "added modfn "..type.." for "..tostring(id))
					table.insert(retfns, runmodfn(modfn, mod, id and type..": "..id or type))
				end
			end
		end
	end
	return retfns
end

----------------------------------------------------
----------------- 注册Prefab文件 -------------------

PrefabFiles = {
	"dmgind",
	"element_indicator",
	"crystal_shield",
	"crystal_shieldfx",
	"element_spear",
	"element_spearfx",
	"reactionfx",
	"preparedartifacts",
	"randomartifacts",
	"artifacts_bundle",
	"artifactsbackpack",
	"bloombomb",
	"genshin_potions"
}

----------------------------------------------------
------------------ 图片资源文件 --------------------

Assets = {
--字体
	Asset("FONT", MODROOT.."fonts/genshinfont.zip" ),

--制作栏图片
	Asset("IMAGE", "images/inventoryimages/randomartifacts.tex"),
    Asset("ATLAS", "images/inventoryimages/randomartifacts.xml"),

	Asset("IMAGE", "images/inventoryimages/artifactsbundle.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbundle.xml"),

	Asset("IMAGE", "images/inventoryimages/artifactsbackpack.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbackpack.xml"),

    Asset("IMAGE", "images/inventoryimages/artifactsbundlewrap.tex"),
    Asset("ATLAS", "images/inventoryimages/artifactsbundlewrap.xml"),
--全都是UI图片
    ---------------------------------------------
	--这是技能冷却图标
    Asset( "ANIM", "anim/genshincd_meter.zip" ),

	Asset( "IMAGE", "images/ui/skillkey_bg.tex"),
    Asset( "ATLAS", "images/ui/skillkey_bg.xml"),

	---------------------------------------------
	--背景
    Asset( "IMAGE", "images/ui/property_background_pyro.tex"),
    Asset( "ATLAS", "images/ui/property_background_pyro.xml"),

	Asset( "IMAGE", "images/ui/property_background_cryo.tex"),
    Asset( "ATLAS", "images/ui/property_background_cryo.xml"),

	Asset( "IMAGE", "images/ui/property_background_hydro.tex"),
    Asset( "ATLAS", "images/ui/property_background_hydro.xml"),

	Asset( "IMAGE", "images/ui/property_background_electro.tex"),
    Asset( "ATLAS", "images/ui/property_background_electro.xml"),

	Asset( "IMAGE", "images/ui/property_background_anemo.tex"),
    Asset( "ATLAS", "images/ui/property_background_anemo.xml"),

	Asset( "IMAGE", "images/ui/property_background_geo.tex"),
    Asset( "ATLAS", "images/ui/property_background_geo.xml"),

	Asset( "IMAGE", "images/ui/property_background_dendro.tex"),
    Asset( "ATLAS", "images/ui/property_background_dendro.xml"),

	Asset( "IMAGE", "images/ui/property_background_no.tex"),
    Asset( "ATLAS", "images/ui/property_background_no.xml"),
	
	Asset( "IMAGE", "images/ui/background_shadow.tex"),
    Asset( "ATLAS", "images/ui/background_shadow.xml"),

	Asset( "IMAGE", "images/ui/textbar_dark.tex"),
    Asset( "ATLAS", "images/ui/textbar_dark.xml"),

	Asset( "IMAGE", "images/ui/textbar_light.tex"),
    Asset( "ATLAS", "images/ui/textbar_light.xml"),

	Asset( "IMAGE", "images/ui/textbar_gradients.tex"),
    Asset( "ATLAS", "images/ui/textbar_gradients.xml"),

	---------------------------------------------
	--神之眼图标
	Asset( "IMAGE", "images/ui/pyro_vision.tex"),
    Asset( "ATLAS", "images/ui/pyro_vision.xml"),

	Asset( "IMAGE", "images/ui/cryo_vision.tex"),
    Asset( "ATLAS", "images/ui/cryo_vision.xml"),

	Asset( "IMAGE", "images/ui/hydro_vision.tex"),
    Asset( "ATLAS", "images/ui/hydro_vision.xml"),

	Asset( "IMAGE", "images/ui/electro_vision.tex"),
    Asset( "ATLAS", "images/ui/electro_vision.xml"),

	Asset( "IMAGE", "images/ui/anemo_vision.tex"),
    Asset( "ATLAS", "images/ui/anemo_vision.xml"),

	Asset( "IMAGE", "images/ui/geo_vision.tex"),
    Asset( "ATLAS", "images/ui/geo_vision.xml"),

	--呜呜，草元素神之眼官方都没图
	--Asset( "IMAGE", "images/ui/dendro_vision.tex"),
    --Asset( "ATLAS", "images/ui/dendro_vision.xml"),

	Asset( "IMAGE", "images/ui/no_vision.tex"),
    Asset( "ATLAS", "images/ui/no_vision.xml"),

	---------------------------------------------
	--badge小图标
	Asset( "IMAGE", "images/ui/health_badge.tex"),
    Asset( "ATLAS", "images/ui/health_badge.xml"),

	Asset( "IMAGE", "images/ui/atk_badge.tex"),
    Asset( "ATLAS", "images/ui/atk_badge.xml"),

	Asset( "IMAGE", "images/ui/def_badge.tex"),
    Asset( "ATLAS", "images/ui/def_badge.xml"),

	Asset( "IMAGE", "images/ui/element_mastery_badge.tex"),
    Asset( "ATLAS", "images/ui/element_mastery_badge.xml"),

	Asset( "IMAGE", "images/ui/crit_badge.tex"),
    Asset( "ATLAS", "images/ui/crit_badge.xml"),

	Asset( "IMAGE", "images/ui/recharge_badge.tex"),
    Asset( "ATLAS", "images/ui/recharge_badge.xml"),

	Asset( "IMAGE", "images/ui/cd_badge.tex"),
    Asset( "ATLAS", "images/ui/cd_badge.xml"),

	Asset( "IMAGE", "images/ui/pyro_badge.tex"),
    Asset( "ATLAS", "images/ui/pyro_badge.xml"),

	Asset( "IMAGE", "images/ui/cryo_badge.tex"),
    Asset( "ATLAS", "images/ui/cryo_badge.xml"),

	Asset( "IMAGE", "images/ui/hydro_badge.tex"),
    Asset( "ATLAS", "images/ui/hydro_badge.xml"),

	Asset( "IMAGE", "images/ui/electro_badge.tex"),
    Asset( "ATLAS", "images/ui/electro_badge.xml"),

	Asset( "IMAGE", "images/ui/anemo_badge.tex"),
    Asset( "ATLAS", "images/ui/anemo_badge.xml"),

	Asset( "IMAGE", "images/ui/geo_badge.tex"),
    Asset( "ATLAS", "images/ui/geo_badge.xml"),

    Asset( "ATLAS", "images/ui/dendro_badge.xml"),
    Asset( "ATLAS", "images/ui/dendro_badge.xml"),

	Asset( "ATLAS", "images/ui/physical_badge.xml"),
    Asset( "ATLAS", "images/ui/physical_badge.xml"),

	---------------------------------------------
	--按钮
	--主界面相关两个（开和关）
	Asset( "IMAGE", "images/ui/button_on.tex"),
    Asset( "ATLAS", "images/ui/button_on.xml"),
	
	Asset( "IMAGE", "images/ui/button_off1.tex"),
    Asset( "ATLAS", "images/ui/button_off1.xml"),
	
	--左侧选择条（6个，实际上能有几个呢？）
	Asset( "IMAGE", "images/ui/button_attribute.tex"),
    Asset( "ATLAS", "images/ui/button_attribute.xml"),

	Asset( "IMAGE", "images/ui/button_weapons.tex"),
    Asset( "ATLAS", "images/ui/button_weapons.xml"),

	Asset( "IMAGE", "images/ui/button_artifacts.tex"),
    Asset( "ATLAS", "images/ui/button_artifacts.xml"),

	Asset( "IMAGE", "images/ui/button_constellation.tex"),
    Asset( "ATLAS", "images/ui/button_constellation.xml"),

	Asset( "IMAGE", "images/ui/button_talents.tex"),
    Asset( "ATLAS", "images/ui/button_talents.xml"),

	Asset( "IMAGE", "images/ui/button_profile.tex"),
    Asset( "ATLAS", "images/ui/button_profile.xml"),


	--Attribute界面（第一个界面）
	Asset( "IMAGE", "images/ui/button_off2.tex"),
    Asset( "ATLAS", "images/ui/button_off2.xml"),

	Asset( "IMAGE", "images/ui/button_detail.tex"),
    Asset( "ATLAS", "images/ui/button_detail.xml"),

	Asset( "IMAGE", "images/ui/button_detail_en.tex"),
    Asset( "ATLAS", "images/ui/button_detail_en.xml"),

	--Weapon界面（第二个界面）
	Asset( "IMAGE", "images/ui/weapon_refine_bg.tex"),
    Asset( "ATLAS", "images/ui/weapon_refine_bg.xml"),

	Asset( "IMAGE", "images/ui/button_refine.tex"),
    Asset( "ATLAS", "images/ui/button_refine.xml"),

	Asset( "ANIM", "anim/weapon_show.zip"),

	--Artifacts界面（第三个界面）
	Asset( "IMAGE", "images/ui/button_arttype.tex"),
    Asset( "ATLAS", "images/ui/button_arttype.xml"),

    Asset( "IMAGE", "images/ui/art_bg.tex"),
    Asset( "ATLAS", "images/ui/art_bg.xml"),

	Asset( "IMAGE", "images/ui/artifact_stars.tex"),
    Asset( "ATLAS", "images/ui/artifact_stars.xml"),

	Asset( "IMAGE", "images/ui/effect_active.tex"),
    Asset( "ATLAS", "images/ui/effect_active.xml"),

	Asset( "IMAGE", "images/ui/effect_inactive.tex"),
    Asset( "ATLAS", "images/ui/effect_inactive.xml"),

    Asset( "IMAGE", "images/ui/slotempty.tex"),
    Asset( "ATLAS", "images/ui/slotempty.xml"),

	Asset( "IMAGE", "images/ui/button_back.tex"),
    Asset( "ATLAS", "images/ui/button_back.xml"),

	Asset( "IMAGE", "images/ui/button_switch.tex"),
    Asset( "ATLAS", "images/ui/button_switch.xml"),

	--Constellation界面（第四个界面）
    ---------------------------------------------------------------
    Asset( "IMAGE", "images/ui/constellation_bg_shadow.tex" ),
    Asset( "ATLAS", "images/ui/constellation_bg_shadow.xml" ),

	Asset( "IMAGE", "images/ui/constellation_popup_bg.tex" ),
    Asset( "ATLAS", "images/ui/constellation_popup_bg.xml" ),

	Asset( "IMAGE", "images/ui/constellation_lightened.tex" ),
    Asset( "ATLAS", "images/ui/constellation_lightened.xml" ),

	Asset( "IMAGE", "images/ui/constellation_unlightened.tex" ),
    Asset( "ATLAS", "images/ui/constellation_unlightened.xml" ),

	Asset( "IMAGE", "images/ui/constellation_text_bg.tex" ),
    Asset( "ATLAS", "images/ui/constellation_text_bg.xml" ),

	Asset( "IMAGE", "images/ui/button_unlock_constellation.tex" ),
    Asset( "ATLAS", "images/ui/button_unlock_constellation.xml" ),
	
	Asset( "IMAGE", "images/ui/constellation_locked_red.tex" ),
    Asset( "ATLAS", "images/ui/constellation_locked_red.xml" ),

	Asset( "IMAGE", "images/ui/constellation_star_ui.tex" ),
    Asset( "ATLAS", "images/ui/constellation_star_ui.xml" ),
	
    Asset( "IMAGE", "images/ui/constellation_traveler/1_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/1_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/1_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/1_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/2_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/2_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/2_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/2_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/3_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/3_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/3_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/3_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/4_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/4_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/4_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/4_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/5_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/5_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/5_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/5_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/6_enable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/6_enable.xml" ),
    Asset( "IMAGE", "images/ui/constellation_traveler/6_disable.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/6_disable.xml" ),

    Asset( "IMAGE", "images/ui/constellation_traveler/constellation_image.tex" ),
    Asset( "ATLAS", "images/ui/constellation_traveler/constellation_image.xml" ),

	--Talents界面（第五个界面）
    ---------------------------------------------------------------
    Asset( "IMAGE", "images/ui/talents_text_bg.tex" ),
    Asset( "ATLAS", "images/ui/talents_text_bg.xml" ),

	Asset( "IMAGE", "images/ui/talents_popup_bg.tex" ),
    Asset( "ATLAS", "images/ui/talents_popup_bg.xml" ),

	Asset( "IMAGE", "images/ui/talentattr_text_bg.tex" ),
    Asset( "ATLAS", "images/ui/talentattr_text_bg.xml" ),

	Asset( "IMAGE", "images/ui/talentattr_btn_en.tex" ),
    Asset( "ATLAS", "images/ui/talentattr_btn_en.xml" ),
	Asset( "IMAGE", "images/ui/talentattr_btn_sc.tex" ),
    Asset( "ATLAS", "images/ui/talentattr_btn_sc.xml" ),

	Asset( "IMAGE", "images/ui/talentinfo_btn_en.tex" ),
    Asset( "ATLAS", "images/ui/talentinfo_btn_en.xml" ),
	Asset( "IMAGE", "images/ui/talentinfo_btn_sc.tex" ),
    Asset( "ATLAS", "images/ui/talentinfo_btn_sc.xml" ),

	Asset( "IMAGE", "images/ui/button_talent_levelup.tex" ),
    Asset( "ATLAS", "images/ui/button_talent_levelup.xml" ),
	
	Asset( "IMAGE", "images/ui/talents_max_red.tex" ),
    Asset( "ATLAS", "images/ui/talents_max_red.xml" ),

	Asset( "IMAGE", "images/ui/talents_upgrade_bg.tex" ),
    Asset( "ATLAS", "images/ui/talents_upgrade_bg.xml" ),
	
	Asset( "IMAGE", "images/ui/button_talentupgrade_close.tex" ),
    Asset( "ATLAS", "images/ui/button_talentupgrade_close.xml" ),

	Asset( "IMAGE", "images/ui/button_talentupgrade_cancel.tex" ),
    Asset( "ATLAS", "images/ui/button_talentupgrade_cancel.xml" ),

	Asset( "IMAGE", "images/ui/button_talentupgrade_confirm.tex" ),
    Asset( "ATLAS", "images/ui/button_talentupgrade_confirm.xml" ),
	
	Asset( "IMAGE", "images/ui/talentupgrade_text_bg.tex" ),
    Asset( "ATLAS", "images/ui/talentupgrade_text_bg.xml" ),
	-------------------

	Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_1.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_1.xml" ),

    Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_2.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_2.xml" ),

    Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_3.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_3.xml" ),

    Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_4.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_4.xml" ),

    Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_5.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_5.xml" ),

    Asset( "IMAGE", "images/ui/talents_traveler/talent_icon_6.tex" ),
    Asset( "ATLAS", "images/ui/talents_traveler/talent_icon_6.xml" ),
}

----------------------------------------------------
GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
--------------------- 自定义 -----------------------

TUNING.LANGUAGE_GENSHIN_CORE = "sc"
TUNING.ELEMENTINDICATOR_ENABLED = true
TUNING.DMGIND_ENABLE = true
TUNING.UISCALE = 1
TUNING.ENABLE_ENVIRONMENT_ELEMENT = true

--Language
TUNING.LANGUAGE_GENSHIN_CORE = GetModConfigData("language")

--Display
TUNING.ELEMENTINDICATOR_ENABLED = GetModConfigData("elementindicator")

TUNING.DMGIND_ENABLE = GetModConfigData("damageindicator")

TUNING.UISCALE = GetModConfigData("uiscale")

TUNING.CONTROLWITHUI = GetModConfigData("controlwhenUIon")

TUNING.CDBADGE_REFRESH_TIME = GetModConfigData("cdbadgerefreshtime")

--Game
TUNING.ENABLE_ENVIRONMENT_ELEMENT = GetModConfigData("environmentelement")

TUNING.ENERGY_RECHARGE_ENABLE = GetModConfigData("energyrecharge")

TUNING.ARTIFACTS_ON_HEALTH = GetModConfigData("artifactsdowithhealth")

TUNING.WEAPON_REFINE_PROTECTION = GetModConfigData("weaponrefineprotection")

----------------------------------------------------
---------------------- 常量 ------------------------

TUNING.LABEL_NUMBER_SIZE = 48

TUNING.LABEL_FONT_SIZE = 36

TUNING.LABEL_TIME = 1

TUNING.ELEMENT_SPEAR_COOLDOWN = 7

--COLOR
--元素伤害颜色
TUNING.IMMUNE_COLOR = {
	r = 128/255,
	g = 128/255,
	b = 128/255
}

TUNING.PYRO_COLOR = {
	r = 224/255,
	g = 104/255,
	b = 58/255
}

TUNING.CRYO_COLOR = {
	r = 170/255,
	g = 251/255,
	b = 252/255
}

TUNING.HYDRO_COLOR = {
	r = 0,
	g = 179/255,
	b = 254/255
}

TUNING.ELECTRO_COLOR = {
	r = 217/255,
	g = 133/255,
	b = 253/255
}

TUNING.ANEMO_COLOR = {
	r = 79/255,
	g = 239/255,
	b = 185/255
}

TUNING.GEO_COLOR = {
	r = 220/255,
	g = 157/255,
	b = 27/155
}

TUNING.DENDRO_COLOR = {
	r = 148/255,
	g = 230/255,
	b = 41/255
}

TUNING.DENDRO2_COLOR = {
	r = 8/155, 
	g = 208/255, 
	b = 15/255
}

TUNING.PHYSICAL_COLOR = {
	r = 1,
	g = 1,
	b = 1
}

--元素反应颜色
TUNING.OVERLOAD_COLOR = {
	r = 221/255,
	g = 70/255,
	b = 85/255
}

TUNING.SUPERCONDUCT_COLOR = {
	r = 163/255,
	g = 106/255,
	b = 248/255
}

TUNING.VAPORIZE_COLOR = {
    r = 248/255,
	g = 187/255,
	b = 121/255
}

TUNING.MELT_COLOR = {
	r = 246/255, 
	g = 153/255, 
	b = 96/255
}

TUNING.ELECTROCHARGED_COLOR = TUNING.ELECTRO_COLOR

TUNING.FROZEN_COLOR = TUNING.CRYO_COLOR

TUNING.SWIRL_COLOR = TUNING.ANEMO_COLOR

TUNING.CRYSTALIZE_COLOR = TUNING.GEO_COLOR

TUNING.BURNING_COLOR = TUNING.PYRO_COLOR

TUNING.QUICKEN_COLOR = TUNING.DENDRO2_COLOR

TUNING.BLOOM_COLOR = TUNING.DENDRO2_COLOR

TUNING.SPREAD_COLOR = TUNING.DENDRO2_COLOR

TUNING.AGGRAVATE_COLOR = TUNING.ELECTRO_COLOR

TUNING.BURGEON_COLOR = TUNING.OVERLOAD_COLOR

TUNING.HYPERBLOOM_COLOR = TUNING.ELECTRO_COLOR

--其它颜色
TUNING.HEALTH_GAIN_COLOR = {
	r = 0.8*57/255,
	g = 0.8*255/255,
	b = 0.8*111/255
}

-----------------------------------
TUNING.GENSHIN_POTIONS_DURATION = 300

TUNING.DEFAULT_CONSTELLATION_POSITION = {
	{-250, 0},
	{-150, 0},
	{-50, 0},
	{50, 0},
	{150, 0},
	{250, 0},
}

TUNING.DEFAULTSKILL_NORMALATK = 
{
    --LEVEL            1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    ATK_DMG =        {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000},
    CHARGE_ATK_DMG = {1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700, 1.700},
}

TUNING.DEFAULTSKILL_ELESKILL = 
{
    CD = 10,
    --LEVEL 1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =  {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000},
}

TUNING.DEFAULTSKILL_ELEBURST = 
{
    CD = 10,
    ENERGY = 80, 
    --LEVEL 1      2      3      4      5      6      7      8      9      10     11     12     13     14     15
    DMG =  {1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000},
}

TUNING.DEFAULTSKILL_NORMALATK_SORT = 
{
    "ATK_DMG",
    "CHARGE_ATK_DMG",
}

TUNING.DEFAULTSKILL_ELESKILL_SORT = 
{
    "DMG",
	"CD",
}

TUNING.DEFAULTSKILL_ELEBURST_SORT = 
{
	"DMG",
    "CD",
    "ENERGY", 
}

require("recipe")
TUNING.DEFAULT_TALENTS_INGREDIENTS = 
{
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --1~2
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --2~3
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --3~4
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --4~5
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --5~6
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --6~7
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --7~8
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --8~9
    {Ingredient("cutgrass", 1), Ingredient("log", 1), Ingredient("goldnugget", 1)},  --9~10
}

TUNING.POLEARM_WEAPONS = {
	"spear",
	"element_spear",
}

----------------------------------------------------
---------------------- 描述 ------------------------

modimport("scripts/import/descriptions/descriptions.lua")

----------------------------------------------------
----------------------- 字体 -----------------------

function ApplyLocalizedFonts()

	TheSim:UnloadFont("genshinfont")
    TheSim:UnloadPrefabs({"fonts_genshin"})

    GenshinFontPrefab = Prefab("fonts_genshin", nil, {Asset("FONT", MODROOT.."fonts/genshinfont.zip" )})
    RegisterPrefabs(GenshinFontPrefab)
    TheSim:LoadPrefabs({"fonts_genshin"})

    TheSim:LoadFont(MODROOT.."fonts/genshinfont.zip", "genshinfont")
    TheSim:SetupFontFallbacks("genshinfont", DEFAULT_FALLBACK_TABLE)

end

getmetatable(TheSim).__index.UnregisterAllPrefabs = (function()
	local oldUnregisterAllPrefabs = getmetatable(TheSim).__index.UnregisterAllPrefabs
	return function(self, ...)
		oldUnregisterAllPrefabs(self, ...)
		ApplyLocalizedFonts()
	end
end)()

local OldRegisterPrefabs = ModManager.RegisterPrefabs
local function NewRegisterPrefabs(self)
	OldRegisterPrefabs(self)
	ApplyLocalizedFonts()
end
ModManager.RegisterPrefabs=NewRegisterPrefabs

local OldStart = Start
function Start()
	ApplyLocalizedFonts()
	OldStart()
end

----------------------------------------------------
---------------------- 制作 ------------------------

modimport("scripts/import/recipes/genshin_core_recipes.lua")

-----**************************************************************-----
-----**************************************************************-----
-----      下面是有关combat属性扩展以及元素反应加成有关的内容      -----
-----**************************************************************-----
-----**************************************************************-----

modimport("scripts/import/core/health_postinit.lua")

modimport("scripts/import/core/inventory_postinit.lua")

modimport("scripts/import/core/weapon_postinit.lua")

modimport("scripts/import/core/projectile_postinit.lua")

modimport("scripts/import/core/freezable_postinit.lua")

modimport("scripts/import/core/combat_postinit.lua")

modimport("scripts/import/core/SGall_postinit.lua")

modimport("scripts/import/core/player_postinit.lua")

modimport("scripts/import/action_postinits/attack_postinit.lua")

modimport("scripts/import/action_postinits/action_usepotion.lua")

modimport("scripts/import/action_postinits/action_refineweapon.lua")

modimport("scripts/import/prefab_postinits/prefabpostinitany.lua")

-----**************************************************************-----
-----**************************************************************-----
-----**************************************************************-----
-----**************************************************************-----

modimport("scripts/import/core/artifacts_slots.lua")

modimport("scripts/import/component_postinits/bundler_postinit.lua")

modimport("scripts/import/component_postinits/rechargeable_postinit.lua")

modimport("scripts/import/prefab_postinits/wx78_postinit.lua")
----------------------------------------------------
----------------------- UI -------------------------

modimport("scripts/import/core/ui_classpostconstruct.lua")

--客机组件
require "entityreplica"
AddReplicableComponent("combatstatus")
AddReplicableComponent("artifacts")
AddReplicableComponent("artifactscollector")
AddReplicableComponent("constellation")
AddReplicableComponent("talents")
AddReplicableComponent("energyrecharge")
AddReplicableComponent("elementalcaster")
AddReplicableComponent("refineable")

----------------------------------------------------
----------------------- RPC ------------------------

modimport("scripts/import/mod_rpcs/modrpc.lua")

-----------------------------------------------------------------------
-----------------------------Bug Tracker-------------------------------
bugtracker_config = {
	email = "diaokedu17430@126.com",
	upload_client_log = true,
	upload_server_log = true,
	-- 其它配置项目...
}