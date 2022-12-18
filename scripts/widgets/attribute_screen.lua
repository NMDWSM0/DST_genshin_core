local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local ImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GMultiLayerButton = require "widgets/genshin_widgets/Gmultilayerbutton"
require "widgets/genshin_widgets/Gbtnpresets"

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

local attribute_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	
	----------------------------------------------------------------------------------------------
	--快速属性显示	

	local name = STRINGS.CHARACTER_NAMES[self.owner.prefab] or self.owner.prefab
	self.playername = self:AddChild(Text("genshinfont", 48, name, {1, 1, 1, 1}))
	self.playername:SetPosition(500, 230, 0)

	--生命值
	self.health_textbar_quick = self:AddChild(Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex"))
	self.health_textbar_quick:SetPosition(500,130,0)
	self.health_textbar_quick:SetScale(0.8,0.8,0.8)
	self.health_badge_quick = self:AddChild(Image("images/ui/health_badge.xml", "health_badge.tex"))
	self.health_badge_quick:SetPosition(360,130,0)
	self.health_badge_quick:SetScale(0.4,0.4,0.4)

	self.health_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_HEALTH_TEXT, {1, 1, 1, 1}))
	self.health_text_quick:SetHAlign(ANCHOR_LEFT)
    self.health_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.health_text_quick:SetRegionSize(400, 60)
    self.health_text_quick:EnableWordWrap(true)
	self.health_text_quick:SetPosition(580,130,0)
	self.health_number_quick = self:AddChild(Text("genshinfont", 30, 0, {1, 1, 1, 1}))
	self.health_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.health_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.health_number_quick:SetRegionSize(300, 60)
    self.health_number_quick:EnableWordWrap(true)
	self.health_number_quick:SetPosition(490,130,0)

	--攻击力
	self.atk_badge_quick = self:AddChild(Image("images/ui/atk_badge.xml", "atk_badge.tex"))
	self.atk_badge_quick:SetPosition(360,90,0)
	self.atk_badge_quick:SetScale(0.4,0.4,0.4)

	self.atk_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_ATK_TEXT, {1, 1, 1, 1}))
	self.atk_text_quick:SetHAlign(ANCHOR_LEFT)
    self.atk_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.atk_text_quick:SetRegionSize(400, 60)
    self.atk_text_quick:EnableWordWrap(true)
	self.atk_text_quick:SetPosition(580,90,0)
	self.atk_number_quick = self:AddChild(Text("genshinfont", 30, 0, {1, 1, 1, 1}))
	self.atk_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.atk_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.atk_number_quick:SetRegionSize(300, 60)
    self.atk_number_quick:EnableWordWrap(true)
	self.atk_number_quick:SetPosition(490,90,0)

	--防御力
	self.def_textbar_quick = self:AddChild(Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex"))
	self.def_textbar_quick:SetPosition(500,50,0)
	self.def_textbar_quick:SetScale(0.8,0.8,0.8)
	self.def_badge_quick = self:AddChild(Image("images/ui/def_badge.xml", "def_badge.tex"))
	self.def_badge_quick:SetPosition(360,50,0)
	self.def_badge_quick:SetScale(0.4,0.4,0.4)

	self.def_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_DEF_TEXT, {1, 1, 1, 1}))
	self.def_text_quick:SetHAlign(ANCHOR_LEFT)
    self.def_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.def_text_quick:SetRegionSize(400, 60)
    self.def_text_quick:EnableWordWrap(true)
	self.def_text_quick:SetPosition(580,50,0)
	self.def_number_quick = self:AddChild(Text("genshinfont", 30, 0, {1, 1, 1, 1}))
	self.def_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.def_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.def_number_quick:SetRegionSize(300, 60)
    self.def_number_quick:EnableWordWrap(true)
	self.def_number_quick:SetPosition(490,50,0)

	--元素精通
	self.element_mastery_badge_quick = self:AddChild(Image("images/ui/element_mastery_badge.xml", "element_mastery_badge.tex"))
	self.element_mastery_badge_quick:SetPosition(360,10,0)
	self.element_mastery_badge_quick:SetScale(0.4,0.4,0.4)

	self.element_mastery_text_quick = self:AddChild(Text("genshinfont", 30, TUNING.UI_MASTERY_TEXT, {1, 1, 1, 1}))
	self.element_mastery_text_quick:SetHAlign(ANCHOR_LEFT)
    self.element_mastery_text_quick:SetVAlign(ANCHOR_MIDDLE)
    self.element_mastery_text_quick:SetRegionSize(400, 60)
    self.element_mastery_text_quick:EnableWordWrap(true)
	self.element_mastery_text_quick:SetPosition(580,10,0)
	self.element_mastery_number_quick = self:AddChild(Text("genshinfont", 30, 0, {1, 1, 1, 1}))
	self.element_mastery_number_quick:SetHAlign(ANCHOR_RIGHT)
    self.element_mastery_number_quick:SetVAlign(ANCHOR_MIDDLE)
    self.element_mastery_number_quick:SetRegionSize(300, 60)
    self.element_mastery_number_quick:EnableWordWrap(true)
	self.element_mastery_number_quick:SetPosition(490,10,0)

	--交替有背景bar条

	local desc_str = (self.owner.character_description or STRINGS.CHARACTER_DESCRIPTIONS[self.owner.prefab]) or "player"
	self.character_description = self:AddChild(Text("genshinfont", 28, desc_str, {1, 1, 1, 0.4}))
	self.character_description:SetHAlign(ANCHOR_LEFT)
    self.character_description:SetVAlign(ANCHOR_TOP)
    self.character_description:SetRegionSize(300, 300)
	self.character_description:EnableWordWrap(true)
	self.character_description:SetPosition(500, -245, 0)

	----------------------------------------------------------------------------------------------
	--开启详细显示按钮
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.detailshow = self:AddChild(ImageButton("images/ui/button_detail.xml", "button_detail.tex"))
	else
	    self.detailshow = self:AddChild(ImageButton("images/ui/button_detail_en.xml", "button_detail_en.tex"))
	end
	self.detailshow:SetPosition(500, -50, 0)
	self.detailshow:SetScale(0.95,0.95,0.95)
	self.detailshow.focus_scale = {1.05,1.05,1.05}

	----------------------------------------------------------------------------------------------
	--用来遮挡的半透明图片
	self.detailbg = self:AddChild(Image("images/ui/background_shadow.xml", "background_shadow.tex"))
	self.detailbg:SetScale(0.92, 0.92, 0.92)

	----------------------------------------------------------------------------------------------
	--关闭详细显示按钮
	self.detailclose = self:AddChild(GMultiLayerButton(GetSingleGButtonConfig("light", "images/ui/icon_genshin_button.xml", "icon_close.tex")))
	self.detailclose:SetPosition(722, 333, 0)
	self.detailclose:SetScale(1, 1, 1)

	----------------------------------------------------------------------------------------------
	--详细属性显示

	--生命值
	self.health_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.health_textbar:SetPosition(-350,320,0)
	self.health_badge = self:AddChild(Image("images/ui/health_badge.xml", "health_badge.tex"))
	self.health_badge:SetPosition(-610,320,0)
	self.health_badge:SetScale(0.5,0.5,0.5)
	self.health_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_HEALTH_TEXT, {1, 1, 1, 1}))
	self.health_text:SetHAlign(ANCHOR_LEFT)
    self.health_text:SetVAlign(ANCHOR_MIDDLE)
    self.health_text:SetRegionSize(300, 60)
    self.health_text:EnableWordWrap(true)
	self.health_text:SetPosition(-435,320,0)

	self.base_hp_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.base_hp_number:SetPosition(-200,320,0)
	self.bonus_hp_number = self:AddChild(Text("genshinfont", 32, 0, {150/255, 253/255, 65/255, 1}))
	self.bonus_hp_number:SetPosition(-90,320,0)

	--攻击力
	self.atk_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.atk_textbar:SetPosition(-350,270,0)
	self.atk_badge = self:AddChild(Image("images/ui/atk_badge.xml", "atk_badge.tex"))
	self.atk_badge:SetPosition(-610,270,0)
	self.atk_badge:SetScale(0.5,0.5,0.5)
	self.atk_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_ATK_TEXT, {1, 1, 1, 1}))
	self.atk_text:SetHAlign(ANCHOR_LEFT)
    self.atk_text:SetVAlign(ANCHOR_MIDDLE)
    self.atk_text:SetRegionSize(300, 60)
    self.atk_text:EnableWordWrap(true)
	self.atk_text:SetPosition(-435,270,0)

	self.base_atk_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.base_atk_number:SetPosition(-200,270,0)
	self.bonus_atk_number = self:AddChild(Text("genshinfont", 32, 0, {150/255, 253/255, 65/255, 1}))
	self.bonus_atk_number:SetPosition(-90,270,0)

	--防御力
	self.def_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.def_textbar:SetPosition(-350,220,0)
	self.def_badge = self:AddChild(Image("images/ui/def_badge.xml", "def_badge.tex"))
	self.def_badge:SetPosition(-610,220,0)
	self.def_badge:SetScale(0.5,0.5,0.5)

	self.def_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_DEF_TEXT, {1, 1, 1, 1}))
	self.def_text:SetHAlign(ANCHOR_LEFT)
    self.def_text:SetVAlign(ANCHOR_MIDDLE)
    self.def_text:SetRegionSize(300, 60)
    self.def_text:EnableWordWrap(true)
	self.def_text:SetPosition(-435,220,0)
	self.base_def_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.base_def_number:SetPosition(-200,220,0)
	self.bonus_def_number = self:AddChild(Text("genshinfont", 32, 0, {150/255, 253/255, 65/255, 1}))
	self.bonus_def_number:SetPosition(-90,220,0)
	
	--元素精通
	self.element_mastery_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.element_mastery_textbar:SetPosition(-350,95,0)
	self.element_mastery_textbar:SetScale(1, 4, 0)
	self.element_mastery_badge = self:AddChild(Image("images/ui/element_mastery_badge.xml", "element_mastery_badge.tex"))
	self.element_mastery_badge:SetPosition(-610,170,0)
	self.element_mastery_badge:SetScale(0.5,0.5,0.5)

	self.element_mastery_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_MASTERY_TEXT, {1, 1, 1, 1}))
	self.element_mastery_text:SetHAlign(ANCHOR_LEFT)
    self.element_mastery_text:SetVAlign(ANCHOR_MIDDLE)
    self.element_mastery_text:SetRegionSize(300, 60)
    self.element_mastery_text:EnableWordWrap(true)
	self.element_mastery_text:SetPosition(-435,170,0)
	self.element_mastery_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.element_mastery_number:SetPosition(-200,170,0)
	self.element_mastery_description = self:AddChild(Text("genshinfont", 26, nil, {0.85, 0.85, 0.85, 1}))
	self.element_mastery_description:SetHAlign(ANCHOR_LEFT)
    self.element_mastery_description:SetVAlign(ANCHOR_TOP)
	self.element_mastery_description:SetPosition(-382,76,0)

	--暴击率、暴击伤害
	self.crit_rate_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.crit_rate_textbar:SetPosition(-350,-30,0)
	self.crit_dmg_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.crit_dmg_textbar:SetPosition(-350,-80,0)
	self.crit_badge = self:AddChild(Image("images/ui/crit_badge.xml", "crit_badge.tex"))
	self.crit_badge:SetPosition(-610,-30,0)
	self.crit_badge:SetScale(0.5,0.5,0.5)

	self.crit_rate_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_CRITRATE_TEXT, {1, 1, 1, 1}))
	self.crit_rate_text:SetHAlign(ANCHOR_LEFT)
    self.crit_rate_text:SetVAlign(ANCHOR_MIDDLE)
    self.crit_rate_text:SetRegionSize(300, 60)
    self.crit_rate_text:EnableWordWrap(true)
	self.crit_rate_text:SetPosition(-435,-30,0)
	self.crit_rate_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.crit_rate_number:SetPosition(-200,-30,0)

	self.crit_dmg_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_CRITDMG_TEXT, {1, 1, 1, 1}))
	self.crit_dmg_text:SetHAlign(ANCHOR_LEFT)
    self.crit_dmg_text:SetVAlign(ANCHOR_MIDDLE)
    self.crit_dmg_text:SetRegionSize(300, 60)
    self.crit_dmg_text:EnableWordWrap(true)
	self.crit_dmg_text:SetPosition(-435,-80,0)
	self.crit_dmg_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.crit_dmg_number:SetPosition(-200,-80,0)

	--元素充能效率
	self.recharge_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.recharge_textbar:SetPosition(-350,-130,0)
	self.recharge_badge = self:AddChild(Image("images/ui/recharge_badge.xml", "recharge_badge.tex"))
	self.recharge_badge:SetPosition(-610,-130,0)
	self.recharge_badge:SetScale(0.5,0.5,0.5)

	self.recharge_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_RECHARGE_TEXT, {1, 1, 1, 1}))
	self.recharge_text:SetHAlign(ANCHOR_LEFT)
    self.recharge_text:SetVAlign(ANCHOR_MIDDLE)
    self.recharge_text:SetRegionSize(300, 60)
    self.recharge_text:EnableWordWrap(true)
	self.recharge_text:SetPosition(-435,-130,0)
	self.recharge_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.recharge_number:SetPosition(-200,-130,0)

	--冷却缩减
	self.cd_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.cd_textbar:SetPosition(-350,-180,0)
	self.cd_badge = self:AddChild(Image("images/ui/cd_badge.xml", "cd_badge.tex"))
	self.cd_badge:SetPosition(-610,-180,0)
	self.cd_badge:SetScale(0.5,0.5,0.5)

	self.cd_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_CD_TEXT, {1, 1, 1, 1}))
	self.cd_text:SetHAlign(ANCHOR_LEFT)
    self.cd_text:SetVAlign(ANCHOR_MIDDLE)
    self.cd_text:SetRegionSize(300, 60)
    self.cd_text:EnableWordWrap(true)
	self.cd_text:SetPosition(-435,-180,0)
	self.cd_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.cd_number:SetPosition(-200,-180,0)

	--火元素
	self.pyro_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.pyro_textbar:SetPosition(305,320,0)
	self.pyro_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.pyro_res_textbar:SetPosition(305,270,0)
	self.pyro_badge = self:AddChild(Image("images/ui/pyro_badge.xml", "pyro_badge.tex"))
	self.pyro_badge:SetPosition(45,320,0)
	self.pyro_badge:SetScale(0.5,0.5,0.5)

	self.pyro_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_PYRO_TEXT, {1, 1, 1, 1}))
	self.pyro_text:SetHAlign(ANCHOR_LEFT)
    self.pyro_text:SetVAlign(ANCHOR_MIDDLE)
    self.pyro_text:SetRegionSize(300, 60)
    self.pyro_text:EnableWordWrap(true)
	self.pyro_text:SetPosition(220,320,0)
	self.pyro_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.pyro_number:SetPosition(455,320,0)

	self.pyro_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_PYRORES_TEXT, {1, 1, 1, 1}))
	self.pyro_res_text:SetHAlign(ANCHOR_LEFT)
    self.pyro_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.pyro_res_text:SetRegionSize(300, 60)
    self.pyro_res_text:EnableWordWrap(true)
	self.pyro_res_text:SetPosition(220,270,0)
	self.pyro_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.pyro_res_number:SetPosition(455,270,0)

	--水元素
	self.hydro_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.hydro_textbar:SetPosition(305,220,0)
	self.hydro_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.hydro_res_textbar:SetPosition(305,170,0)
	self.hydro_badge = self:AddChild(Image("images/ui/hydro_badge.xml", "hydro_badge.tex"))
	self.hydro_badge:SetPosition(45,220,0)
	self.hydro_badge:SetScale(0.5,0.5,0.5)

	self.hydro_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_HYDRO_TEXT, {1, 1, 1, 1}))
	self.hydro_text:SetHAlign(ANCHOR_LEFT)
    self.hydro_text:SetVAlign(ANCHOR_MIDDLE)
    self.hydro_text:SetRegionSize(300, 60)
    self.hydro_text:EnableWordWrap(true)
	self.hydro_text:SetPosition(220,220,0)
	self.hydro_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.hydro_number:SetPosition(455,220,0)

	self.hydro_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_HYDRORES_TEXT, {1, 1, 1, 1}))
	self.hydro_res_text:SetHAlign(ANCHOR_LEFT)
    self.hydro_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.hydro_res_text:SetRegionSize(300, 60)
    self.hydro_res_text:EnableWordWrap(true)
	self.hydro_res_text:SetPosition(220,170,0)
	self.hydro_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.hydro_res_number:SetPosition(455,170,0)

	--草元素
	self.dendro_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.dendro_textbar:SetPosition(305,120,0)
	self.dendro_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.dendro_res_textbar:SetPosition(305,70,0)
	self.dendro_badge = self:AddChild(Image("images/ui/dendro_badge.xml", "dendro_badge.tex"))
	self.dendro_badge:SetPosition(45,120,0)
	self.dendro_badge:SetScale(0.5,0.5,0.5)

	self.dendro_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_DENDRO_TEXT, {1, 1, 1, 1}))
	self.dendro_text:SetHAlign(ANCHOR_LEFT)
    self.dendro_text:SetVAlign(ANCHOR_MIDDLE)
    self.dendro_text:SetRegionSize(300, 60)
    self.dendro_text:EnableWordWrap(true)
	self.dendro_text:SetPosition(220,120,0)
	self.dendro_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.dendro_number:SetPosition(455,120,0)

	self.dendro_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_DENDRORES_TEXT, {1, 1, 1, 1}))
	self.dendro_res_text:SetHAlign(ANCHOR_LEFT)
    self.dendro_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.dendro_res_text:SetRegionSize(300, 60)
    self.dendro_res_text:EnableWordWrap(true)
	self.dendro_res_text:SetPosition(220,70,0)
	self.dendro_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.dendro_res_number:SetPosition(455,70,0)

	--雷元素
	self.electro_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.electro_textbar:SetPosition(305,20,0)
	self.electro_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.electro_res_textbar:SetPosition(305,-30,0)
	self.electro_badge = self:AddChild(Image("images/ui/electro_badge.xml", "electro_badge.tex"))
	self.electro_badge:SetPosition(45,20,0)
	self.electro_badge:SetScale(0.5,0.5,0.5)

	self.electro_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_ELECTRO_TEXT, {1, 1, 1, 1}))
	self.electro_text:SetHAlign(ANCHOR_LEFT)
    self.electro_text:SetVAlign(ANCHOR_MIDDLE)
    self.electro_text:SetRegionSize(300, 60)
    self.electro_text:EnableWordWrap(true)
	self.electro_text:SetPosition(220,20,0)
	self.electro_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.electro_number:SetPosition(455,20,0)

	self.electro_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_ELECTRORES_TEXT, {1, 1, 1, 1}))
	self.electro_res_text:SetHAlign(ANCHOR_LEFT)
    self.electro_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.electro_res_text:SetRegionSize(300, 60)
    self.electro_res_text:EnableWordWrap(true)
	self.electro_res_text:SetPosition(220,-30,0)
	self.electro_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.electro_res_number:SetPosition(455,-30,0)

	--风元素
	self.anemo_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.anemo_textbar:SetPosition(305,-80,0)
	self.anemo_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.anemo_res_textbar:SetPosition(305,-130,0)
	self.anemo_badge = self:AddChild(Image("images/ui/anemo_badge.xml", "anemo_badge.tex"))
	self.anemo_badge:SetPosition(45,-80,0)
	self.anemo_badge:SetScale(0.5,0.5,0.5)

	self.anemo_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_ANEMO_TEXT, {1, 1, 1, 1}))
	self.anemo_text:SetHAlign(ANCHOR_LEFT)
    self.anemo_text:SetVAlign(ANCHOR_MIDDLE)
    self.anemo_text:SetRegionSize(300, 60)
    self.anemo_text:EnableWordWrap(true)
	self.anemo_text:SetPosition(220,-80,0)
	self.anemo_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.anemo_number:SetPosition(455,-80,0)

	self.anemo_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_ANEMORES_TEXT, {1, 1, 1, 1}))
	self.anemo_res_text:SetHAlign(ANCHOR_LEFT)
    self.anemo_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.anemo_res_text:SetRegionSize(300, 60)
    self.anemo_res_text:EnableWordWrap(true)
	self.anemo_res_text:SetPosition(220,-130,0)
	self.anemo_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.anemo_res_number:SetPosition(455,-130,0)

	--冰元素
	self.cryo_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.cryo_textbar:SetPosition(305,-180,0)
	self.cryo_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.cryo_res_textbar:SetPosition(305,-230,0)
	self.cryo_badge = self:AddChild(Image("images/ui/cryo_badge.xml", "cryo_badge.tex"))
	self.cryo_badge:SetPosition(45,-180,0)
	self.cryo_badge:SetScale(0.5,0.5,0.5)

	self.cryo_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_CRYO_TEXT, {1, 1, 1, 1}))
	self.cryo_text:SetHAlign(ANCHOR_LEFT)
    self.cryo_text:SetVAlign(ANCHOR_MIDDLE)
    self.cryo_text:SetRegionSize(300, 60)
    self.cryo_text:EnableWordWrap(true)
	self.cryo_text:SetPosition(220,-180,0)
	self.cryo_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.cryo_number:SetPosition(455,-180,0)

	self.cryo_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_CRYORES_TEXT, {1, 1, 1, 1}))
	self.cryo_res_text:SetHAlign(ANCHOR_LEFT)
    self.cryo_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.cryo_res_text:SetRegionSize(300, 60)
    self.cryo_res_text:EnableWordWrap(true)
	self.cryo_res_text:SetPosition(220,-230,0)
	self.cryo_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.cryo_res_number:SetPosition(455,-230,0)

	--岩元素
	self.geo_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.geo_textbar:SetPosition(305,-280,0)
	self.geo_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.geo_res_textbar:SetPosition(305,-330,0)
	self.geo_badge = self:AddChild(Image("images/ui/geo_badge.xml", "geo_badge.tex"))
	self.geo_badge:SetPosition(45,-280,0)
	self.geo_badge:SetScale(0.5,0.5,0.5)

	self.geo_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_GEO_TEXT, {1, 1, 1, 1}))
	self.geo_text:SetHAlign(ANCHOR_LEFT)
    self.geo_text:SetVAlign(ANCHOR_MIDDLE)
    self.geo_text:SetRegionSize(300, 60)
    self.geo_text:EnableWordWrap(true)
	self.geo_text:SetPosition(220,-280,0)
	self.geo_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.geo_number:SetPosition(455,-280,0)

	self.geo_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_GEORES_TEXT, {1, 1, 1, 1}))
	self.geo_res_text:SetHAlign(ANCHOR_LEFT)
    self.geo_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.geo_res_text:SetRegionSize(300, 60)
    self.geo_res_text:EnableWordWrap(true)
	self.geo_res_text:SetPosition(220,-330,0)
	self.geo_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.geo_res_number:SetPosition(455,-330,0)
	
	-- 物理
	self.physical_textbar = self:AddChild(Image("images/ui/textbar_light.xml", "textbar_light.tex"))
	self.physical_textbar:SetPosition(-350,-280,0)
	self.physical_res_textbar = self:AddChild(Image("images/ui/textbar_dark.xml", "textbar_dark.tex"))
	self.physical_res_textbar:SetPosition(-350,-330,0)
	self.physical_badge = self:AddChild(Image("images/ui/physical_badge.xml", "physical_badge.tex"))
	self.physical_badge:SetPosition(-610,-280,0)
	self.physical_badge:SetScale(0.5,0.5,0.5)

	self.physical_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_PHYSICAL_TEXT, {1, 1, 1, 1}))
	self.physical_text:SetHAlign(ANCHOR_LEFT)
    self.physical_text:SetVAlign(ANCHOR_MIDDLE)
    self.physical_text:SetRegionSize(300, 60)
    self.physical_text:EnableWordWrap(true)
	self.physical_text:SetPosition(-435,-280,0)
	self.physical_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.physical_number:SetPosition(-200,-280,0)

	self.physical_res_text = self:AddChild(Text("genshinfont", 32, TUNING.UI_PHYSICALRES_TEXT, {1, 1, 1, 1}))
	self.physical_res_text:SetHAlign(ANCHOR_LEFT)
    self.physical_res_text:SetVAlign(ANCHOR_MIDDLE)
    self.physical_res_text:SetRegionSize(300, 60)
    self.physical_res_text:EnableWordWrap(true)
	self.physical_res_text:SetPosition(-435,-330,0)
	self.physical_res_number = self:AddChild(Text("genshinfont", 32, 0, {1, 1, 1, 1}))
	self.physical_res_number:SetPosition(-200,-330,0)

	--英文位置调整
	if TUNING.LANGUAGE_GENSHIN_CORE == "en" then
		self.element_mastery_description:SetPosition(-330,75,0)
	end

	----------------------------------------------------------------------------------------------
	
	local detailboard = {
		self.detailbg,
		self.detailclose,

		self.health_badge,
		self.health_text,
		self.base_hp_number,
		self.bonus_hp_number,
		self.health_textbar,

		self.atk_badge,
		self.atk_text,
		self.base_atk_number,
		self.bonus_atk_number,
		self.atk_textbar,

		self.def_badge,
		self.def_text,
		self.base_def_number,
		self.bonus_def_number,
		self.def_textbar,

		self.element_mastery_badge,
		self.element_mastery_text,
		self.element_mastery_number,
		self.element_mastery_description,
		self.element_mastery_textbar,

		self.crit_badge,
	    self.crit_rate_text,
	    self.crit_rate_number,
		self.crit_rate_textbar,
	    self.crit_dmg_text,
	    self.crit_dmg_number,
		self.crit_dmg_textbar,

		self.recharge_badge,
		self.recharge_text,
		self.recharge_number,
		self.recharge_textbar,
		
		self.cd_badge,
		self.cd_text,
		self.cd_number,
		self.cd_textbar,

		self.pyro_badge,
		self.pyro_text,
		self.pyro_number,
		self.pyro_textbar,
		self.pyro_res_text,
		self.pyro_res_number,
		self.pyro_res_textbar,

		self.hydro_badge,
		self.hydro_text,
		self.hydro_number,
		self.hydro_textbar,
		self.hydro_res_text,
		self.hydro_res_number,
		self.hydro_res_textbar,

		self.dendro_badge,
		self.dendro_text,
		self.dendro_number,
		self.dendro_textbar,
		self.dendro_res_text,
		self.dendro_res_number,
		self.dendro_res_textbar,

		self.electro_badge,
		self.electro_text,
		self.electro_number,
		self.electro_textbar,
		self.electro_res_text,
		self.electro_res_number,
		self.electro_res_textbar,

		self.anemo_badge,
		self.anemo_text,
		self.anemo_number,
		self.anemo_textbar,
		self.anemo_res_text,
		self.anemo_res_number,
		self.anemo_res_textbar,

		self.cryo_badge,
		self.cryo_text,
		self.cryo_number,
		self.cryo_textbar,
		self.cryo_res_text,
		self.cryo_res_number,
		self.cryo_res_textbar,

		self.geo_badge,
		self.geo_text,
		self.geo_number,
		self.geo_textbar,
		self.geo_res_text,
		self.geo_res_number,
		self.geo_res_textbar,

		self.physical_badge,
		self.physical_text,
		self.physical_number,
		self.physical_textbar,
		self.physical_res_text,
		self.physical_res_number,
		self.physical_res_textbar,
	}

	for k,v in pairs(detailboard) do
		v:Hide()
	end

	self.detailshow:SetOnClick(function()
	    for k,v in pairs(detailboard) do
		    v:Show()
		end
	end)
	self.detailclose:SetOnClick(function()
	    for k,v in pairs(detailboard) do
		    v:Hide()
		end
	end)
	
	----------------------------------------------------------------------------------------------
	self:StartUpdating()
end)

function attribute_screen:OnUpdate(dt)
    --获取数据
	local combatstatus = TheWorld.ismastersim and self.owner.components.combatstatus or self.owner.replica.combatstatus

	if combatstatus == nil then
		return
	end
	
	local mastery = combatstatus:GetElementMastery()
	local rate1 = 0
	local rate2 = 0
	local rate3 = 0
	local rate4 = 0
	if mastery > 0 then
		rate1 = (278 * mastery) / (mastery + 1400) 
		rate2 = (444 * mastery) / (mastery + 1400) 
		rate3 = (250 * mastery) / (mastery + 1200) 
		rate4 = (1600 * mastery) / (mastery + 2000) 
	end

	-------------------------------------------------------------------------------------------------
	--设置UI

	--快速属性显示
	
	--生命值
	self.health_number_quick:SetString(GetScoreFormat(combatstatus:GetHp()))
	
	--攻击力
	self.atk_number_quick:SetString(GetScoreFormat(combatstatus:GetAtk()))

	--防御力
	self.def_number_quick:SetString(GetScoreFormat(combatstatus:GetDef()))

	--元素精通
	self.element_mastery_number_quick:SetString(GetScoreFormat(combatstatus:GetElementMastery()))

	-----------------------------------------------------------------
	--详细属性显示

	--生命值
	self.base_hp_number:SetString( string.format("%12s", GetScoreFormat(combatstatus:GetBaseHp())) )
	self.bonus_hp_number:SetString( string.format("%-12s", "+"..GetScoreFormat(combatstatus:GetHp() - combatstatus:GetBaseHp())) )

	--攻击力
	self.base_atk_number:SetString( string.format("%12s", GetScoreFormat(combatstatus:GetBaseAtk())) )
	self.bonus_atk_number:SetString( string.format("%-12s", "+"..GetScoreFormat(combatstatus:GetAtk() - combatstatus:GetBaseAtk())) )

	--防御力
	self.base_def_number:SetString( string.format("%12s", GetScoreFormat(combatstatus:GetBaseDef())) )
	self.bonus_def_number:SetString( string.format("%-12s", "+"..GetScoreFormat(combatstatus:GetDef() - combatstatus:GetBaseDef())) )

	--元素精通
	self.element_mastery_number:SetString( string.format("%12s", GetScoreFormat(combatstatus:GetElementMastery())) )
	if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then
	    self.element_mastery_description:SetString( string.format("元素精通可以提升元素反应带来的收益。\n·蒸发、融化反应造成伤害时，伤害提升%.1f%%;\n·超载、超导、感电、碎冰、扩散、绽放、超绽放、烈绽放反应\n造成的伤害提升%.1f%%;\n·超激化、蔓激化反应带来的伤害提升提高%.1f%%;\n·结晶反应形成的晶片护盾，提供的伤害吸收量提升%.1f%%。", rate1, rate4, rate3 * 2, rate2) )
	else
	    self.element_mastery_description:SetSize(22)
	    self.element_mastery_description:SetString( string.format("The higher a character's elemental mastery,the stronger the\nelemental energy that can be released.Increases damage caused by\nVaporize and Melt by %.1f%%.Also increases damage caused by\nOverloaded,Superconduct,Electro-Charged,Shattered,Swirl,Bloom,\nBurgeon and Hyperbloom by %.1f%%.Increases the DMG Bonus conferred\nby Spread and Aggravate by %.1f%%.Increases the damage absorption\npower of shields created through Crystallize by %.1f%%", rate1, rate4, rate3 * 2, rate2) )
	end
	--暴击率、暴击伤害
	self.crit_rate_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetCritRate()) )
	self.crit_dmg_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetCritDMG()) )

	--元素充能效率
	self.recharge_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetRecharge()) )

	--冷却缩减
	--self.cd_number:SetString( string.format("%12.1f%%", 100 * ?) )
	self.cd_number:SetString( string.format("%12.1f%%", 100 * 0.0) )

	--火元素
	self.pyro_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetPyroBonus()) )
	self.pyro_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetPyroResBonus()) )
    
	--水元素
	self.hydro_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetHydroBonus()) )
	self.hydro_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetHydroResBonus()) )
	
	--草元素
	self.dendro_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetDendroBonus()) )
	self.dendro_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetDendroResBonus()) )
	
	--雷元素
	self.electro_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetElectroBonus()) )
	self.electro_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetElectroResBonus()) )
	
	--风元素
	self.anemo_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetAnemoBonus()) )
	self.anemo_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetAnemoResBonus()) )
	
	--冰元素
	self.cryo_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetCryoBonus()) )
	self.cryo_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetCryoResBonus()) )
	
	--岩元素
	self.geo_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetGeoBonus()) )
	self.geo_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetGeoResBonus()) )
	
	--物理
	self.physical_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetPhysicalBonus()) )
	self.physical_res_number:SetString( string.format("%12.1f%%", 100 * combatstatus:GetPhysicalResBonus()) )

end

return attribute_screen