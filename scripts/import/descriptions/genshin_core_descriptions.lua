-----------------------------------------------------------------------
-----------------------------------------------------------------------
--有几个函数我要先给一下
local function plainfloatfunc(num)  --直接写,浮点
    return string.format("%.1f", num) 
end

local function plainintfunc(num)    --直接写,整数
    return string.format("%d", num) 
end
local plainfunc = plainfloatfunc

local function dmgmultfunc(num)  --攻击倍率通用模板函数
    return string.format("%.1f%%", 100 * num) 
end
local dmgmultfunc_sc = dmgmultfunc
local dmgmultfunc_en = dmgmultfunc

local function timefunc(num)  --时间通用模板函数
    return string.format("%.1f秒", num) 
end
local function timefunc_en(num)
    return string.format("%.1fs", num) 
end
local timefunc_sc = timefunc

-----------------------------------------------------------------------
-----------------------------------------------------------------------

if TUNING.LANGUAGE_GENSHIN_CORE == "sc" then

	STRINGS.GENSHIN_ACTION_REFINEWEAPON = "精炼"
	STRINGS.WEAPON_REFINELEVEL_WARNING = "当前作为素材的武器已经被精炼过，请手动在游戏内右键动作精炼"

    STRINGS.NAMES.ELEMENT_SPEAR = "元素长矛"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELEMENT_SPEAR = "没有神之眼却能使用元素力，你，是个例外"
	STRINGS.RECIPE_DESC.ELEMENT_SPEAR = "无派蒙也能使用元素，哼"
	TUNING.WEAPONEFFECT_ELEMENT_SPEAR = {
		"无羁的朱赤之蝶\n•释放元素战技后，获得16%全元素伤害加成。元素伤害暴击时，元素战技或等效于元素战技的技能冷却时间减少1秒。（该武器主动技能视为使用元素战技）",
		"无羁的朱赤之蝶\n•释放元素战技后，获得20%全元素伤害加成。元素伤害暴击时，元素战技或等效于元素战技的技能冷却时间减少1秒。（该武器主动技能视为使用元素战技）",
		"无羁的朱赤之蝶\n•释放元素战技后，获得24%全元素伤害加成。元素伤害暴击时，元素战技或等效于元素战技的技能冷却时间减少1秒。（该武器主动技能视为使用元素战技）",
		"无羁的朱赤之蝶\n•释放元素战技后，获得28%全元素伤害加成。元素伤害暴击时，元素战技或等效于元素战技的技能冷却时间减少1秒。（该武器主动技能视为使用元素战技）",
		"无羁的朱赤之蝶\n•释放元素战技后，获得32%全元素伤害加成。元素伤害暴击时，元素战技或等效于元素战技的技能冷却时间减少1秒。（该武器主动技能视为使用元素战技）",
	}

	STRINGS.GENSHIN_ACTION_USEPOTION = "使用药剂"
	STRINGS.NAMES.FLAMING_ESSENTIAL_OIL = "烈火精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMING_ESSENTIAL_OIL = "以孕育火元素的物质制成，涂抹后能更有效地汇聚火元素，也会让人变得热情。"
	STRINGS.RECIPE_DESC.FLAMING_ESSENTIAL_OIL = "让人更亲和火元素的油膏，能提升造成的火元素伤害"
	STRINGS.NAMES.FROSTING_ESSENTIAL_OIL = "霜劫精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTING_ESSENTIAL_OIL = "涂抹后会感到冰冰凉凉，提高冰元素魔导能力之余，还能让人头脑冷静。"
	STRINGS.RECIPE_DESC.FROSTING_ESSENTIAL_OIL = "让人更亲和冰元素的油膏，能提升造成的冰元素伤害"
	STRINGS.NAMES.STREAMING_ESSENTIAL_OIL = "激流精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.STREAMING_ESSENTIAL_OIL = "湿湿滑滑的外用药，能够让人更有效地引导水元素。有种微妙的气味。"
	STRINGS.RECIPE_DESC.STREAMING_ESSENTIAL_OIL = "让人更亲和水元素的油膏，能提升造成的水元素伤害"
	STRINGS.NAMES.SHOCKING_ESSENTIAL_OIL = "惊雷精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHOCKING_ESSENTIAL_OIL = "触碰时感觉酥酥麻麻，涂抹后会让人更容易导出雷元素，但可能会影响发型。"
	STRINGS.RECIPE_DESC.SHOCKING_ESSENTIAL_OIL = "让人更亲和雷元素的油膏，能提升造成的雷元素伤害"
	STRINGS.NAMES.GUSHING_ESSENTIAL_OIL = "狂风精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUSHING_ESSENTIAL_OIL = "有着清香的气味。据说，如果使用这种药在原野上旅行，从来都是顺风而行。"
	STRINGS.RECIPE_DESC.GUSHING_ESSENTIAL_OIL = "让人更亲和风元素的油膏，能提升造成的风元素伤害"
	STRINGS.NAMES.UNMOVING_ESSENTIAL_OIL = "磐石精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNMOVING_ESSENTIAL_OIL = "其中有着细小颗粒的药，涂抹时能感受到其中含有的岩元素。据说对跌打损伤也有好处。"
	STRINGS.RECIPE_DESC.UNMOVING_ESSENTIAL_OIL = "让人更亲和岩元素的油膏，能提升造成的岩元素伤害"
	STRINGS.NAMES.FOREST_ESSENTIAL_OIL = "丛林精油"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOREST_ESSENTIAL_OIL = "富有营养的外用药剂，如果用在土地中一定是高效的生长剂。能让人更轻松地引导草元素。"
	STRINGS.RECIPE_DESC.FOREST_ESSENTIAL_OIL = "让人更亲和草元素的油膏，能提升造成的草元素伤害"

	STRINGS.NAMES.HEATSHIELD_POTION = "耐热药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEATSHIELD_POTION = "原理并不是让人身体变得凉爽，而是让人习惯高温，以此降低置身其中的不适感。"
	STRINGS.RECIPE_DESC.HEATSHIELD_POTION = "让人忍耐高热的奇特药剂，能提升火元素抗性"
	STRINGS.NAMES.FROSTSHIELD_POTION = "耐寒药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTSHIELD_POTION = "喝下去时舌尖有种冻僵的感觉，等这种感觉扩散到全身后，就不再会感到寒冷了。"
	STRINGS.RECIPE_DESC.FROSTSHIELD_POTION = "让人忍耐寒冷的奇异药水，能提升冰元素抗性"
	STRINGS.NAMES.DESICCANT_POTION = "防潮药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DESICCANT_POTION = "这种药剂据信能够防潮，对于保存物件十分实用。内服亦可，对风湿病患者而言是宝物。"
	STRINGS.RECIPE_DESC.DESICCANT_POTION = "让人忍耐潮湿环境的药物，能提升水元素抗性"
	STRINGS.NAMES.INSULATION_POTION = "绝缘药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.INSULATION_POTION = "喝下去感觉酥酥麻麻的奇特药物，据说绝缘的原理其实是让人体内充满相反的雷电。"   --作者吐槽，这真的能够绝缘吗
	STRINGS.RECIPE_DESC.INSULATION_POTION = "可以防止触电的药水，能提升雷元素抗性"
	STRINGS.NAMES.WINDBARRIER_POTION = "防风药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINDBARRIER_POTION = "对于时常需要风餐露宿的冒险家来说，是非常实用的药剂。据说能防止风寒。"
	STRINGS.RECIPE_DESC.WINDBARRIER_POTION = "让人抵抗强风的神秘药剂，能提升风元素抗性"
	STRINGS.NAMES.DUSTPROOF_POTION = "防尘药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUSTPROOF_POTION = "喝下去时嘴里有磁石的奇特味道。对于风尘仆仆的旅人，可以保持浑身清洁。"
	STRINGS.RECIPE_DESC.DUSTPROOF_POTION = "让人不受沙尘侵扰的药物，能提升岩元素抗性"
	STRINGS.NAMES.DENDROCIDE_POTION = "治草药剂"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DENDROCIDE_POTION = "原理和一般除草剂不同，不是杀死草木，而是让它们陷入沉睡。内服据说可以调理身体。"
	STRINGS.RECIPE_DESC.DENDROCIDE_POTION = "可以抑制草木生长的药物，能提升草元素抗性"

    STRINGS.NAMES.RANDOMARTIFACTS = "深秘圣遗物匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS = "收纳圣遗物的圣物匣。愿见者可以感受圣迹"

	STRINGS.NAMES.RANDOMARTIFACTS_BFMT = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_BFMT = "装有一件随机的\"冰风迷途的勇士\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_BFMT = "装有一件随机的\"冰风迷途的勇士\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_YZMN = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_YZMN = "装有一件随机的\"炽烈的炎之魔女\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_YZMN = "装有一件随机的\"炽烈的炎之魔女\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_CLZY = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CLZY = "装有一件随机的\"翠绿之影\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CLZY = "装有一件随机的\"翠绿之影\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_RLSN = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_RLSN = "装有一件随机的\"如雷的盛怒\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_RLSN = "装有一件随机的\"如雷的盛怒\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_CLZX = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CLZX = "装有一件随机的\"沉沦之心\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CLZX = "装有一件随机的\"沉沦之心\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_YGPY = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_YGPY = "装有一件随机的\"悠古的磐岩\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_YGPY = "装有一件随机的\"悠古的磐岩\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_CBZH = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CBZH = "装有一件随机的\"苍白之火\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CBZH = "装有一件随机的\"苍白之火\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_CBZH = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_JYQY = "装有一件随机的\"绝缘之旗印\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_JYQY = "装有一件随机的\"绝缘之旗印\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_JYQY = "圣遗物还圣匣"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_SLJY = "装有一件随机的\"深林的记忆\"圣遗物"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_SLJY = "装有一件随机的\"深林的记忆\"圣遗物"
	STRINGS.NAMES.RANDOMARTIFACTS_SLJY = "圣遗物还圣匣"

	STRINGS.NAMES.ARTIFACTSBUNDLEWRAP = "圣遗物包装盒"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBUNDLEWRAP = "用于打包将要还圣的圣遗物"
	STRINGS.RECIPE_DESC.ARTIFACTSBUNDLEWRAP = "打包用于还圣的圣遗物，可不能反悔哦"

	STRINGS.NAMES.ARTIFACTSBUNDLE = "打包的圣遗物"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBUNDLE = "可以制作圣遗物还圣匣"

	STRINGS.NAMES.ARTIFACTSBACKPACK = "圣遗物收纳箱"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBACKPACK = "可以储存大量的圣遗物"
	STRINGS.RECIPE_DESC.ARTIFACTSBACKPACK = "收纳你旅行过程中的财富"

	STRINGS.NAMES.ARTIFACTS_REFINER = "还圣奥迹"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTS_REFINER = "可以在此处批量合成圣物匣"
	STRINGS.RECIPE_DESC.ARTIFACTS_REFINER = "更方便地将圣遗物还圣"

	STRINGS.NAMES.BFMT_FLOWER = "历经风雪的思念"
	STRINGS.NAMES.BFMT_PLUME = "摧冰而行的执望"
	STRINGS.NAMES.BFMT_SANDS = "冰雪故园的终期"
	STRINGS.NAMES.BFMT_GOBLET = "遍结寒霜的傲骨"
	STRINGS.NAMES.BFMT_CIRCLET = "破冰踏雪的回音"

	STRINGS.NAMES.YZMN_FLOWER = "魔女的炎之花"
	STRINGS.NAMES.YZMN_PLUME = "魔女常燃之羽"
	STRINGS.NAMES.YZMN_SANDS = "魔女破灭之时"
	STRINGS.NAMES.YZMN_GOBLET = "魔女的心之火"
	STRINGS.NAMES.YZMN_CIRCLET = "焦灼的魔女帽"

	STRINGS.NAMES.CLZY_FLOWER = "野花记忆的绿野"
	STRINGS.NAMES.CLZY_PLUME = "猎人青翠的箭羽"
	STRINGS.NAMES.CLZY_SANDS = "翠绿猎人的笃定"
	STRINGS.NAMES.CLZY_GOBLET = "翠绿猎人的容器"
	STRINGS.NAMES.CLZY_CIRCLET = "翠绿的猎人之冠"

	STRINGS.NAMES.RLSN_FLOWER = "雷鸟的怜悯"
	STRINGS.NAMES.RLSN_PLUME = "雷灾的孑遗"
	STRINGS.NAMES.RLSN_SANDS = "雷霆的时计"
	STRINGS.NAMES.RLSN_GOBLET = "降雷的凶兆"
	STRINGS.NAMES.RLSN_CIRCLET = "唤雷的头冠"

	STRINGS.NAMES.CLZX_FLOWER = "饰金胸花"
	STRINGS.NAMES.CLZX_PLUME = "追忆之风"
	STRINGS.NAMES.CLZX_SANDS = "坚铜罗盘"
	STRINGS.NAMES.CLZX_GOBLET = "沉波之盏"
	STRINGS.NAMES.CLZX_CIRCLET = "酒渍船帽"

	STRINGS.NAMES.YGPY_FLOWER = "磐陀裂生之花"
	STRINGS.NAMES.YGPY_PLUME = "嵯峨群峰之翼"
	STRINGS.NAMES.YGPY_SANDS = "星罗圭璧之晷"
	STRINGS.NAMES.YGPY_GOBLET = "巉岩琢塑之樽"
	STRINGS.NAMES.YGPY_CIRCLET = "不动玄岩之相"

	STRINGS.NAMES.CBZH_FLOWER = "无垢之花"
	STRINGS.NAMES.CBZH_PLUME = "贤医之羽"
	STRINGS.NAMES.CBZH_SANDS = "停摆之刻"
	STRINGS.NAMES.CBZH_GOBLET = "超越之盏"
	STRINGS.NAMES.CBZH_CIRCLET = "嗤笑之面"

	STRINGS.NAMES.JYQY_FLOWER = "明威之镡"
	STRINGS.NAMES.JYQY_PLUME = "切落之羽"
	STRINGS.NAMES.JYQY_SANDS = "雷云之笼"
	STRINGS.NAMES.JYQY_GOBLET = "绯花之壶"
	STRINGS.NAMES.JYQY_CIRCLET = "华饰之兜"

	STRINGS.NAMES.SLJY_FLOWER = "迷宫的游人"
	STRINGS.NAMES.SLJY_PLUME = "翠蔓的智者"
	STRINGS.NAMES.SLJY_SANDS = "贤智的定期"
	STRINGS.NAMES.SLJY_GOBLET = "迷误者之灯"
	STRINGS.NAMES.SLJY_CIRCLET = "月桂的宝冠"

	STRINGS.ARTIFACTS_SORTITEM_LIMIT = "已选择属性数量达到上限"

    TUNING.ARTIFACTS_TAG = {
		flower = "生之花",  
		plume = "死之羽",
		sands = "时之沙",
		goblet = "空之杯",
		circlet = "理之冠",
	}

	TUNING.ARTIFACTS_TYPE = {
		atk = "攻击力",            --小攻击
		atk_per = "攻击力",     --大攻击
		def = "防御力",         --小防御
        def_per = "防御力",     --大防御
        hp = "生命值",             --小生命
		hp_per = "生命值",      --大生命
        crit_rate = "暴击率",   --暴击
        crit_dmg = "暴击伤害",    --暴伤
        mastery = "元素精通",       --元素精通
        recharge = "元素充能效率",    --元素充能效率
        pyro = "火元素伤害加成",        --火伤
        cryo = "冰元素伤害加成",        --冰伤
        hydro = "水元素伤害加成",       --水伤
        electro = "雷元素伤害加成",     --雷伤
        anemo = "风元素伤害加成",       --风伤
        geo = "岩元素伤害加成",         --岩伤
        dendro = "草元素伤害加成",      --草伤
        physical = "物理伤害加成",    --物伤
	}

    TUNING.SETBONUSTEXT = "套装效果"

	TUNING.ARTIFACTS_SETS = {
		bfmt = "冰风迷途的勇士",      --冰套
		yzmn = "炽烈的炎之魔女",      --火套
		clzy = "翠绿之影",            --风套
		rlsn = "如雷的盛怒",          --如雷
		clzx = "沉沦之心",            --水套
		ygpy = "悠古的磐岩",          --磐岩
		cbzh = "苍白之火",            --苍白
		jyqy = "绝缘之旗印",          --绝缘
		sljy = "深林的记忆",          --草套
	}

	TUNING.ARTIFACTS_EFFECT = {
		bfmt = {
			"2件套:获得15%冰元素伤害加成。",
			"4件套:攻击处于冰元素影响下的敌人时，暴击率提高20%；若敌人处于冻结状态下，则暴击率额外提升20%。",
		},
        yzmn = {
			"2件套:获得15%火元素伤害加成。",
			"4件套:超载、烈绽放反应造成的伤害提升40%，蒸发、融化反应的加成系数提高15%。释放元素战技后的10秒内，2件套的效果提高50%，该效果最多叠加三次。",
		},
		clzy = {
			"2件套:获得15%风元素伤害加成。",
			"4件套:扩散反应的伤害提升60%。根据扩散反应的元素类型，降低受到影响的敌人40%的对应元素抗性，持续10秒。",
		},
		rlsn = {
            "2件套:获得15%雷元素伤害加成。",
			"4件套:超载、感电、超导、超绽放反应造成的伤害提升40%，超激化反应带来的伤害提升提高20%。触发上述元素反应或原激化反应时，元素战技冷却时间减少1秒。该效果每0.8秒最多触发一次。",
		},
		clzx = {
            "2件套:获得15%水元素伤害加成。",
			"4件套:施放元素战技后的15秒内，普通攻击与重击造成的伤害提升30%。",
		},
		ygpy = {
            "2件套:获得15%岩元素伤害加成。",
			"4件套:获得岩元素反应形成的晶片时，获得35%对应元素伤害加成，持续10秒。同时只能通过该效果获得一种元素伤害加成。",
		},
		cbzh = {
            "2件套:造成的物理伤害提高25%。",
			"4件套:元素战技命中敌人后，攻击力提升9%。该效果持续7秒，至多叠加2层，每0.3秒至多触发一次。叠满2层时，2件套的效果提升100%。",
		},
		jyqy = {
			"2件套:元素充能效率提升20%。",
			"4件套:基于元素充能效率的25%，提高元素爆发造成的伤害。至多通过这种方式获得75%提升。",
		},
		sljy = {
			"2件套:获得15%草元素伤害加成。",
			"4件套:元素战技或元素爆发命中敌人后，使命中目标的草元素抗性降低30%，持续8秒。",
		},
	}

    TUNING.NOARTIFACTS_WARNING = "暂未拥有当前位置圣遗物"

	TUNING.IMMUNED_TEXT = "免疫"
    TUNING.OVERLOAD_TEXT = "超载"
    TUNING.SUPERCONDUCT_TEXT = "超导"
    TUNING.ELECTROCHARGED_TEXT = "感电"
    TUNING.MELT_TEXT = "融化"
    TUNING.VAPORIZE_TEXT = "蒸发"
    TUNING.CRYSTALIZE_TEXT = "结晶"
    TUNING.SWIRL_TEXT = "扩散"
    TUNING.FROZEN_TEXT = "冻结"
	TUNING.BURNING_TEXT = "燃烧"
	--草元素相关 ⬇
	TUNING.QUICKEN_TEXT = "原激化"
	TUNING.BLOOM_TEXT = "绽放"
	TUNING.SPREAD_TEXT = "蔓激化"
	TUNING.AGGRAVATE_TEXT = "超激化"
	TUNING.BURGEON_TEXT = "烈绽放"
	TUNING.HYPERBLOOM_TEXT = "超绽放"

	TUNING.UI_HEALTH_TEXT = "生命值"
	TUNING.UI_ATK_TEXT = "攻击力"
	TUNING.UI_DEF_TEXT = "防御力"
	TUNING.UI_MASTERY_TEXT = "元素精通"
	TUNING.UI_CRITRATE_TEXT = "暴击率"
	TUNING.UI_CRITDMG_TEXT = "暴击伤害"
	TUNING.UI_RECHARGE_TEXT = "元素充能效率"
	TUNING.UI_CD_TEXT = "冷却缩减"
	TUNING.UI_PYRO_TEXT = "火元素伤害加成"
	TUNING.UI_PYRORES_TEXT = "火元素抗性"
	TUNING.UI_HYDRO_TEXT = "水元素伤害加成"
	TUNING.UI_HYDRORES_TEXT = "水元素抗性"
	TUNING.UI_DENDRO_TEXT = "草元素伤害加成"
	TUNING.UI_DENDRORES_TEXT = "草元素抗性"
	TUNING.UI_ELECTRO_TEXT = "雷元素伤害加成"
	TUNING.UI_ELECTRORES_TEXT = "雷元素抗性"
	TUNING.UI_ANEMO_TEXT = "风元素伤害加成"
	TUNING.UI_ANEMORES_TEXT = "风元素抗性"
	TUNING.UI_CRYO_TEXT = "冰元素伤害加成"
	TUNING.UI_CRYORES_TEXT = "冰元素抗性"
	TUNING.UI_GEO_TEXT = "岩元素伤害加成"
	TUNING.UI_GEORES_TEXT = "岩元素抗性"
	TUNING.UI_PHYSICAL_TEXT = "物理伤害加成"
	TUNING.UI_PHYSICALRES_TEXT = "物理抗性"

	TUNING.DEFAULT_CONSTELLATION_DESC = {
        titlename = {
            "异界之星",
            "异界之星",
            "异界之星",
            "异界之星",
            "异界之星",
            "异界之星",
        },
        content = {
            "点亮此人一方星空之刻尚未到来。",
            "点亮此人一方星空之刻尚未到来。",
            "点亮此人一方星空之刻尚未到来。",
            "点亮此人一方星空之刻尚未到来。",
            "点亮此人一方星空之刻尚未到来。",
            "点亮此人一方星空之刻尚未到来。",
        },
    }

	TUNING.CONSTELLATION_INGREDIENT_LACK = "材料不足"
	TUNING.CONSTELLATION_ACTICVATED = "已激活"
	TUNING.CONSTELLATION_STAR_NEEDED = "激活需要"

	TUNING.TALENT_TYPE_COMBAT = "战斗天赋"
	TUNING.TALENT_TYPE_PASSIVE = "固有天赋"

	TUNING.DEFAULT_TALENTS_DESC = {
		titlename = {
            "普通攻击",
            "元素战技",
            "元素爆发",
            "固有天赋1",
            "固有天赋2",
            "固有天赋3",
			"?",
        },
        content = {
            {{str = "普通攻击：描述。", title = false}},
            {{str = "元素战技：描述。", title = false}},
            {{str = "元素爆发：描述。", title = false}},
            {{str = "固有天赋1：描述。" ,title = false}},
            {{str = "固有天赋2：描述。", title = false}},
            {{str = "固有天赋3：描述。", title = false}},
			{{str = "?", title = false}},
        },
	}

	TUNING.DEFAULTSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "普通攻击伤害", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "重击伤害", 
            formula = dmgmultfunc,
        },
    }

    TUNING.DEFAULTSKILL_ELESKILL_TEXT = 
    {
        DMG = {
            title = "技能伤害",
            formula = dmgmultfunc,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
    }

    TUNING.DEFAULTSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "技能伤害", 
            formula = dmgmultfunc,
        },
        CD = {
            title = "冷却时间",
            formula = timefunc,
        },
        ENERGY = {
            title = "元素能量",
            formula = plainintfunc,
        },
    }

else

	STRINGS.GENSHIN_ACTION_REFINEWEAPON = "Refine"
	STRINGS.WEAPON_REFINELEVEL_WARNING = "The weapon selected as ingredient has been refined.PLease Use ACTTIONS in DST game to refine."

    STRINGS.NAMES.ELEMENT_SPEAR = "Element Spear"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.ELEMENT_SPEAR = "Capable of using elemental energy without a Vision, you are an exception"
    STRINGS.RECIPE_DESC.ELEMENT_SPEAR = "I can use elemental energy without Paimon!!!"
	TUNING.WEAPONEFFECT_ELEMENT_SPEAR = {
		"Reckless Cinnabar\n•Gain a 16% Elemental DMG Bonus for all elements after casting elemental skill.When attacks with elemental damage crits, decreases the CD of Elemental Skill or skills equal to it by 1s.(The skill of this weapon is equal to using Elemental Skill)",
		"Reckless Cinnabar\n•Gain a 20% Elemental DMG Bonus for all elements after casting elemental skill.When attacks with elemental damage crits, decreases the CD of Elemental Skill or skills equal to it by 1s.(The skill of this weapon is equal to using Elemental Skill)",
		"Reckless Cinnabar\n•Gain a 24% Elemental DMG Bonus for all elements after casting elemental skill.When attacks with elemental damage crits, decreases the CD of Elemental Skill or skills equal to it by 1s.(The skill of this weapon is equal to using Elemental Skill)",
		"Reckless Cinnabar\n•Gain a 28% Elemental DMG Bonus for all elements after casting elemental skill.When attacks with elemental damage crits, decreases the CD of Elemental Skill or skills equal to it by 1s.(The skill of this weapon is equal to using Elemental Skill)",
		"Reckless Cinnabar\n•Gain a 32% Elemental DMG Bonus for all elements after casting elemental skill.When attacks with elemental damage crits, decreases the CD of Elemental Skill or skills equal to it by 1s.(The skill of this weapon is equal to using Elemental Skill)",
	}

	STRINGS.GENSHIN_ACTION_USEPOTION = "Use Potion"
	STRINGS.NAMES.FLAMING_ESSENTIAL_OIL = "Flaming Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMING_ESSENTIAL_OIL = "It is made of materials that gestate Pyro, which serves to draw in Pyro energy more effectively."
	STRINGS.RECIPE_DESC.FLAMING_ESSENTIAL_OIL = "Grants greater affinity for Pyro, boosting Pyro DMG"
	STRINGS.NAMES.FROSTING_ESSENTIAL_OIL = "Frosting Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTING_ESSENTIAL_OIL = "It has a chilling sensation when applied, and helps one to better channel Cryo energy."
	STRINGS.RECIPE_DESC.FROSTING_ESSENTIAL_OIL = "Grants greater affinity for Cryo, boosting Cryo DMG"
	STRINGS.NAMES.STREAMING_ESSENTIAL_OIL = "streaming Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.STREAMING_ESSENTIAL_OIL = "It's a slippery medicine for external use, able to better channel Hydro energy. It has a subtle fragrance."
	STRINGS.RECIPE_DESC.STREAMING_ESSENTIAL_OIL = "Grants greater affinity for Hydro, boosting Hydro DMG"
	STRINGS.NAMES.SHOCKING_ESSENTIAL_OIL = "Shocking Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.SHOCKING_ESSENTIAL_OIL = "It induces a tingling sensation on the skin and renders the user better able to better channel Electro energy."
	STRINGS.RECIPE_DESC.SHOCKING_ESSENTIAL_OIL = "Grants greater affinity for Electro, boosting Electro DMG"
	STRINGS.NAMES.GUSHING_ESSENTIAL_OIL = "Gushing Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.GUSHING_ESSENTIAL_OIL = "It is said that using it during your travels will make you walk as if you're riding on the wind."
	STRINGS.RECIPE_DESC.GUSHING_ESSENTIAL_OIL = "Grants greater affinity for Anemo, boosting Anemo DMG"
	STRINGS.NAMES.UNMOVING_ESSENTIAL_OIL = "Unmoving Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNMOVING_ESSENTIAL_OIL = "You can feel the fine Geo pellets within when applied. It's said to help with physical injuries."
	STRINGS.RECIPE_DESC.UNMOVING_ESSENTIAL_OIL = "Grants greater affinity for Geo, boosting Geo DMG"
	STRINGS.NAMES.FOREST_ESSENTIAL_OIL = "Forest Essential Oil"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOREST_ESSENTIAL_OIL = "It's a nourishing external medicine that promotes growth of plants, able to better channel Dendro energy."
	STRINGS.RECIPE_DESC.FOREST_ESSENTIAL_OIL = "Grants greater affinity for Dendro, boosting Dendro DMG"

	STRINGS.NAMES.HEATSHIELD_POTION = "Heatshield Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEATSHIELD_POTION = "It works not by cooling the body, but by helping the body acclimate to high temperatures."
	STRINGS.RECIPE_DESC.HEATSHIELD_POTION = "A potion that boosts Pyro RES"
	STRINGS.NAMES.FROSTSHIELD_POTION = "frostShield Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTSHIELD_POTION = "Induces a chilling sensation when drank, but once this sensation spreads throughout the body, the feeling of being cold disappears."
	STRINGS.RECIPE_DESC.FROSTSHIELD_POTION = "A potion that boosts Cryo RES"
	STRINGS.NAMES.DESICCANT_POTION = "Desiccant Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DESICCANT_POTION = "It is said to act like a desiccant and be highly effective at keeping items dry. It can also be ingested for the same effect."
	STRINGS.RECIPE_DESC.DESICCANT_POTION = "A potion that boosts Hydro RES"
	STRINGS.NAMES.INSULATION_POTION = "Insulation Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.INSULATION_POTION = "It is said to work by filling the body with inversely charged electrical energy, which counteracts the effect of Electro damage."   --作者吐槽，这真的能够绝缘吗
	STRINGS.RECIPE_DESC.INSULATION_POTION = "A potion that boosts Electro RES"
	STRINGS.NAMES.WINDBARRIER_POTION = "Windbarrier Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.WINDBARRIER_POTION = "It works wonders for adventurers out in the world and is even said to keep the cold away."
	STRINGS.RECIPE_DESC.WINDBARRIER_POTION = "A potion that boosts Anemo RES"
	STRINGS.NAMES.DUSTPROOF_POTION = "Dustproof Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DUSTPROOF_POTION = "It has a strange taste not unlike that of magnets. It keeps a traveler clean from all the sand and dust out there."
	STRINGS.RECIPE_DESC.DUSTPROOF_POTION = "A potion that boosts Geo RES"
	STRINGS.NAMES.DENDROCIDE_POTION = "Dendrocide Potion"
    STRINGS.CHARACTERS.GENERIC.DESCRIBE.DENDROCIDE_POTION = "Rather than killing the plants, it puts them in deep hibernation. It's also said to be good for the body if ingested."
	STRINGS.RECIPE_DESC.DENDROCIDE_POTION = "A potion that boosts Dendro RES"

    STRINGS.NAMES.RANDOMARTIFACTS = "Domain Reliquary"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS = "A reliquary used to store artifacts.May its finder experience miracles"

	STRINGS.NAMES.RANDOMARTIFACTS_BFMT = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_BFMT = "Contains a random artifact of the \"Blizzard Strayer\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_BFMT = "Contains a random artifact of the \"Blizzard Strayer\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_YZMN = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_YZMN = "Contains a random artifact of the \"Crimson Witch of Flames\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_YZMN = "Contains a random artifact of the \"Crimson Witch of Flames\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_CLZY = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CLZY = "Contains a random artifact of the \"Viridescent Venerer\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CLZY = "Contains a random artifact of the \"Viridescent Venerer\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_RLSN = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_RLSN = "Contains a random artifact of the \"Thundering Fury\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_RLSN = "Contains a random artifact of the \"Thundering Fury\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_CLZX = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CLZX = "Contains a random artifact of the \"Heart of Depth\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CLZX = "Contains a random artifact of the \"Heart of Depth\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_YGPY = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_YGPY = "Contains a random artifact of the \"Archaic Petra\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_YGPY = "Contains a random artifact of the \"Archaic Petra\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_CBZH = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_CBZH = "Contains a random artifact of the \"Pale Flame\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_CBZH = "Contains a random artifact of the \"Pale Flame\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_CBZH = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_JYQY = "Contains a random artifact of the \"Emblem of Serverd Fate\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_JYQY = "Contains a random artifact of the \"Emblem of Serverd Fate\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_JYQY = "Artifacts Strongbox"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.RANDOMARTIFACTS_SLJY = "Contains a random artifact of the \"Deepwood Memories\" series"
	STRINGS.RECIPE_DESC.RANDOMARTIFACTS_SLJY = "Contains a random artifact of the \"Deepwood Memories\" series"
	STRINGS.NAMES.RANDOMARTIFACTS_SLJY = "Artifacts Strongbox"

	STRINGS.NAMES.ARTIFACTSBUNDLEWRAP = "Artifacts Bundlewrap"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBUNDLEWRAP = "Used to pack artifacts for crafting Artifacts Strongbox"
	STRINGS.RECIPE_DESC.ARTIFACTSBUNDLEWRAP = "Pack artifacts for crafting Artifacts Strongbox, NO Regret"

	STRINGS.NAMES.ARTIFACTSBUNDLE = "Packed Artifacts"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBUNDLE = "Used to craft Artifacts Strongbox"

    STRINGS.NAMES.ARTIFACTSBACKPACK = "Artifacts Backpack"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTSBACKPACK = "Use to store your artifacts"
	STRINGS.RECIPE_DESC.ARTIFACTSBACKPACK = "Use to store your artifacts"

	STRINGS.NAMES.ARTIFACTS_REFINER = "Mystic Offering"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARTIFACTS_REFINER = "You can craft batch of artifacts here"
	STRINGS.RECIPE_DESC.ARTIFACTS_REFINER = "Craft artifacts easier"

	STRINGS.NAMES.BFMT_FLOWER = "Snowswept Memory"
	STRINGS.NAMES.BFMT_PLUME = "Icebreaker's Resolve"
	STRINGS.NAMES.BFMT_SANDS = "Frozen Homeland's Demise"
	STRINGS.NAMES.BFMT_GOBLET = "Frost-Waved Dignity"
	STRINGS.NAMES.BFMT_CIRCLET = "Broken Rime's Echo"

	STRINGS.NAMES.YZMN_FLOWER = "Witch's Flower of Blaze"
	STRINGS.NAMES.YZMN_PLUME = "Witch's Ever-Burniung Plume"
	STRINGS.NAMES.YZMN_SANDS = "Witch's End Time"
	STRINGS.NAMES.YZMN_GOBLET = "Witch's Heart Flames"
	STRINGS.NAMES.YZMN_CIRCLET = "Witch's Scorching Hat"

	STRINGS.NAMES.CLZY_FLOWER = "In Remembrance of Viridescent Fields"
	STRINGS.NAMES.CLZY_PLUME = "Viridescent Arrow Feather"
	STRINGS.NAMES.CLZY_SANDS = "Viridescent Venerer's Determination"
	STRINGS.NAMES.CLZY_GOBLET = "Viridescent Venerer's Diadem"
	STRINGS.NAMES.CLZY_CIRCLET = "Viridescent Venerer's Vessel"

	STRINGS.NAMES.RLSN_FLOWER = "Thunderbird's Mercy"
	STRINGS.NAMES.RLSN_PLUME = "Survivor of Catastrophe"
	STRINGS.NAMES.RLSN_SANDS = "Hourglass of Thunder"
	STRINGS.NAMES.RLSN_GOBLET = "Omen of Thunderstorm"
	STRINGS.NAMES.RLSN_CIRCLET = "Thundersummoner's Crown"

	STRINGS.NAMES.CLZX_FLOWER = "Gilded Corsage"
	STRINGS.NAMES.CLZX_PLUME = "Gust of Nostalgia"
	STRINGS.NAMES.CLZX_SANDS = "Copper Compass"
	STRINGS.NAMES.CLZX_GOBLET = "Goblet of Thundering Deep"
	STRINGS.NAMES.CLZX_CIRCLET = "Wine-Stained Tricorne"

	STRINGS.NAMES.YGPY_FLOWER = "Flower of Creviced Cliff"
	STRINGS.NAMES.YGPY_PLUME = "Feather of Jagged Peaks"
	STRINGS.NAMES.YGPY_SANDS = "Sundial of Enduring Jade"
	STRINGS.NAMES.YGPY_GOBLET = "Goblet of Chiseled Crag"
	STRINGS.NAMES.YGPY_CIRCLET = "Mask of Solitude Basalt"

	STRINGS.NAMES.CBZH_FLOWER = "Stainless Bloom"
	STRINGS.NAMES.CBZH_PLUME = "Wise Doctor's Pinion"
	STRINGS.NAMES.CBZH_SANDS = "Moment of Cessation"
	STRINGS.NAMES.CBZH_GOBLET = "Surpassing Cup"
	STRINGS.NAMES.CBZH_CIRCLET = "Mocking Mask"

	STRINGS.NAMES.JYQY_FLOWER = "Magnificent Tsuba"
	STRINGS.NAMES.JYQY_PLUME = "Sundered Feather"
	STRINGS.NAMES.JYQY_SANDS = "Storm Cage"
	STRINGS.NAMES.JYQY_GOBLET = "Scarlet Vessel"
	STRINGS.NAMES.JYQY_CIRCLET = "Ornate Kabuto"

	STRINGS.NAMES.SLJY_FLOWER = "Labyrinth Wayfarer"
	STRINGS.NAMES.SLJY_PLUME = "Scholar of Vines"
	STRINGS.NAMES.SLJY_SANDS = "A Time of Insight"
	STRINGS.NAMES.SLJY_GOBLET = "Lamp of the Lost"
	STRINGS.NAMES.SLJY_CIRCLET = "Laurel Coronet"

	STRINGS.ARTIFACTS_SORTITEM_LIMIT = "Sorting Option Limit Reached"

    TUNING.ARTIFACTS_TAG = {
		flower = "Flower of Life",  
		plume = "Plume of Death",
		sands = "Sands of Eon",
		goblet = "Goblet of Eonothem",
		circlet = "Circlet of Logos",
	} 

	TUNING.ARTIFACTS_TYPE = {
		atk = "ATK",            --小攻击
		atk_per = "ATK",     --大攻击
		def = "DEF",         --小防御
        def_per = "DEF",     --大防御
        hp = "HP",             --小生命
		hp_per = "HP",      --大生命
        crit_rate = "CRIT Rate",   --暴击
        crit_dmg = "CRIT DMG",    --暴伤
		mastery = "Elemental Mastery",       --元素精通
        recharge = "Energy Recharge",    --元素充能效率
        pyro = "Pyro DMG Bonus",        --火伤
        cryo = "Cryo DMG Bonus",        --冰伤
        hydro = "Hydro DMG Bonus",       --水伤
        electro = "Electro DMG Bonus",     --雷伤
        anemo = "Anemo DMG Bonus",       --风伤
        geo = "Geo DMG Bonus",         --岩伤
        dendro = "Dendro DMG Bonus",      --草伤
        physical = "Physical DMG Bonus",    --物伤
	} 

    TUNING.SETBONUSTEXT = "Set Bonus"

    TUNING.ARTIFACTS_SETS = {
		bfmt = "Blizzard Strayer",      --冰套
		yzmn = "Crimson Witch of Flames",      --火套
		clzy = "Viridescent Venerer",            --风套
		rlsn = "Thundering Fury",          --如雷
		clzx = "Heart of Depth",            --水套
		ygpy = "Archaic Petra",          --磐岩
		cbzh = "Pale Flame",            --苍白
		jyqy = "Emblem of Serverd Fate",          --绝缘
		sljy = "Deepwood Memories"            --草套
	} 

	TUNING.ARTIFACTS_EFFECT = {
		bfmt = {
			"2-Piece Set:Cryo DMG Bonus +15%",
			"4-Piece Set:When a character attacks an opponent affected by Cryo,their CRIT Rate is increased by 20%.If the opponent is Frozen,CRIT Rate is increased by an additional 20%.",
		},
        yzmn = {
			"2-Piece Set:Pyro DMG Bonus +15%",
			"4-Piece Set:Increases Overloaded and Burgeon DMG by 40%.Increase Vaporize and Melt DMG by 15%.Using Elemental Skill increases 2-Piece Set Bonus by 50% of its starting value for 10s.Max 3 stacks.",
		},
		clzy = {
			"2-Piece Set:Anemo DMG Bonus +15%",
			"4-Piece Set:Increases Swirl DMG by 60%.Decreases opponent's elemental RES to the element infused in the Swirl by 40% for 10s.",
		},
		rlsn = {
            "2-Piece Set:Electro DMG Bonus +15%",
			"4-Piece Set:Increases DMG caused by Overloaded, Electro-Charged, Superconduct, and Hyperbloom by 40%, and the DMG Bonus conferred by Aggravate is increased by 20%. When Quicken or the aforementioned Elemental Reactions are triggered, Elemental Skill CD is decreased by 1s.Can only occur once every 0.8s.",
		},
		clzx = {
            "2-Piece Set:Hydro DMG Bonus +15%",
			"4-Piece Set:After using Elemental Skill,increases Normal Attack and Charged Attack DMG by 30% for 15s.",
		},
		ygpy = {
            "2-Piece Set:Geo DMG Bonus +15%",
			"4-Piece Set:Upon obtaining an Elemental Shard created through a Crystallize Reaction,gain 35% DMG Bonus for that particular element for 10s.Only one form of Elemental DMG Bonus can be gained in this manner at any one time.",
		},
		cbzh = {
            "2-Piece Set:Physical DMG is increased by 25%",
			"4-Piece Set:When an Elemental Skill hits an opponent,ATK is increased by 9% for 7s.This effect stacks up to 2 times and can be triggered once every 0.3s.Once 2 stacks are reached,the 2-set effect is increased by 100%.",
		},
		jyqy = {
			"2-Piece Set:Energy Recharge +20%",
			"4-Piece Set:Increases Elemental Burst DMG by 25% of Energy Recharge.A maximum of 75% bonus DMG can be obtained in this way.",
		},
		sljy = {
			"2-Piece Set:Dendro DMG Bonus +15%",
			"4-Piece Set:After Elemental Skills or Bursts hit opponents, the target's Dendro RES will be decreased by 30% for 8s.",
		},
	}

    TUNING.NOARTIFACTS_WARNING = "No artifacts available for this slot"

	TUNING.IMMUNED_TEXT = "Immuned"
    TUNING.OVERLOAD_TEXT = "Overloaded"
    TUNING.SUPERCONDUCT_TEXT = "Superconduct"
    TUNING.ELECTROCHARGED_TEXT = "Electro-charged"
    TUNING.MELT_TEXT = "Melt"
    TUNING.VAPORIZE_TEXT = "Vaporize"
    TUNING.CRYSTALIZE_TEXT = "Crystallize"
    TUNING.SWIRL_TEXT = "Swirl"
    TUNING.FROZEN_TEXT = "Frozen"
	TUNING.BURNING_TEXT = "Burning"
	--dendro-related ⬇
	TUNING.QUICKEN_TEXT = "Quicken"
	TUNING.BLOOM_TEXT = "Bloom"
	TUNING.SPREAD_TEXT = "Spread"
	TUNING.AGGRAVATE_TEXT = "Aggravate"
	TUNING.BURGEON_TEXT = "Burgeon"
	TUNING.HYPERBLOOM_TEXT = "Hyperbloom"

	TUNING.UI_HEALTH_TEXT = "Max HP"
	TUNING.UI_ATK_TEXT = "ATK"
	TUNING.UI_DEF_TEXT = "DEF"
	TUNING.UI_MASTERY_TEXT = "Elemental Mastery"
	TUNING.UI_CRITRATE_TEXT = "CRIT Rate"
	TUNING.UI_CRITDMG_TEXT = "CRIT DMG"
	TUNING.UI_RECHARGE_TEXT = "Energy Recharge"
	TUNING.UI_CD_TEXT = "CD Reduction"
	TUNING.UI_PYRO_TEXT = "Pyro DMG Bonus"
	TUNING.UI_PYRORES_TEXT = "Pyro RES"
	TUNING.UI_HYDRO_TEXT = "Hydro DMG Bonus"
	TUNING.UI_HYDRORES_TEXT = "Hydro RES"
	TUNING.UI_DENDRO_TEXT = "Dendro DMG Bonus"
	TUNING.UI_DENDRORES_TEXT = "Dendro RES"
	TUNING.UI_ELECTRO_TEXT = "Electro DMG Bonus"
	TUNING.UI_ELECTRORES_TEXT = "Electro RES"
	TUNING.UI_ANEMO_TEXT = "Anemo DMG Bonus"
	TUNING.UI_ANEMORES_TEXT = "Anemo RES"
	TUNING.UI_CRYO_TEXT = "Cryo DMG Bonus"
	TUNING.UI_CRYORES_TEXT = "Cryo RES"
	TUNING.UI_GEO_TEXT = "Geo DMG Bonus"
	TUNING.UI_GEORES_TEXT = "Geo RES"
	TUNING.UI_PHYSICAL_TEXT = "Physical DMG Bonus"
	TUNING.UI_PHYSICALRES_TEXT = "Physical RES"

	TUNING.DEFAULT_CONSTELLATION_DESC = {
        titlename = {
            "Star of Another World",
            "Star of Another World",
            "Star of Another World",
            "Star of Another World",
            "Star of Another World",
            "Star of Another World",
        },
        content = {
            "The time has not yet come for this person's corner of the night sky to light up",
            "The time has not yet come for this person's corner of the night sky to light up",
            "The time has not yet come for this person's corner of the night sky to light up",
            "The time has not yet come for this person's corner of the night sky to light up",
            "The time has not yet come for this person's corner of the night sky to light up",
            "The time has not yet come for this person's corner of the night sky to light up",
        },
    }

	TUNING.CONSTELLATION_INGREDIENT_LACK = "Insufficient materials"
	TUNING.CONSTELLATION_ACTICVATED = "Activated"
	TUNING.CONSTELLATION_STAR_NEEDED = "Activate Required;"

	TUNING.TALENT_TYPE_COMBAT = "Combat Talent"
	TUNING.TALENT_TYPE_PASSIVE = "Passive Talent"

	TUNING.DEFAULT_TALENTS_DESC = {
		titlename = {
            "Normal Attack",
            "Elemental Skill",
            "Elemental Burst",
            "Passive Talent 1",
            "Passive Talent 2",
            "Passive Talent 3",
        },
        content = {
            {{str = "Normal Attack: description.", title = false}},
            {{str = "Elemental Skill: description.", title = false}},
            {{str = "Elemental Burst: description.", title = false}},
            {{str = "Passive Talent 1: description." ,title = false}},
            {{str = "Passive Talent 2: description.", title = false}},
            {{str = "Passive Talent 3: description.", title = false}},
			{{str = "?", title = false}},
        },
	}

	TUNING.DEFAULTSKILL_NORMALATK_TEXT = 
    {
        ATK_DMG = {
            title = "Normal Attack DMG", 
            formula = dmgmultfunc,
        },
        CHARGE_ATK_DMG = {
            title = "Charged Attack DMG", 
            formula = dmgmultfunc,
        },
    }

    TUNING.DEFAULTSKILL_ELESKILL_TEXT = 
    {
        DMG = {
            title = "Skill DMG",
            formula = dmgmultfunc,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
    }

    TUNING.DEFAULTSKILL_ELEBURST_TEXT = 
    {
        DMG = {
            title = "Skill DMG", 
            formula = dmgmultfunc,
        },
        CD = {
            title = "CD",
            formula = timefunc_en,
        },
        ENERGY = {
            title = "Energy Cost",
            formula = plainintfunc,
        },
    }
end