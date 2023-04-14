---@diagnostic disable: lowercase-global
local ischinese = locale == "zh" or locale == "zht" or locale == "zhr"

if ischinese then
    name = "元素反应"
    description = "一个能让你在饥荒世界里使用元素反应的MOD\n包含火、冰、水、雷，风、岩、草元素，以及蒸发、融化、超导、超载、冻结、感电、扩散、结晶、激化、超激化、蔓激化、绽放、超绽放和烈绽放元素反应\n支持圣遗物和药剂选项\nMOD人物可以适配本MOD来使用天赋和命之座选项"
else
    name = "Element Reaction"
    description = "A MOD which enables you to use elemental energy in the DST world.\nThe MOD contains Pyro, Cryo, Hydro, Electro, Anemo, Geo and Dendro element, and also contains reactions as Vaporize, Melt, Superconduct, Frozen, Electro-charged, Swirl, Crystallize, Quicken, Aggravate, Spread, Bloom, Hyperbloom and Burgeon.\nSupport Artifacts and Potions.\nMOD characters can adapt to this MOD to enable Talents and Constellations."
end

author = "1526606449"
version = "1.4.5"
api_version = 10
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
icon_atlas = "elementreaction.xml"
icon = "elementreaction.tex"
all_clients_require_mod = true
client_only_mod = false
server_filter_tags = {"Element Reaction"}
priority = -9  --这个文件也必须写成-9，不然有的装备栏会覆盖我的写法

local opt_Empty = {{description = "", data = 0}}

local function Title(title, hover)
    return {
        name = title,
        hover = hover,
        options = opt_Empty,
        default = 0,
    }
end

local SEPARATOR = Title("")

if ischinese then

    configuration_options =
    {
        Title("语言"),
        {
            name = "language",
            label = "更换语言",
            hover = "默认显示为中文是因为您的饥荒主体选择了中文",
            options =
            {
                { description = "中文", data = "sc", hover = "本MOD相关文本将被显示为中文" },
                { description = "English", data = "en", hover = "If you want config screen to show in English, choose languages EXCEPT CHINESE \nin the DST game， and RESTART GAME" },
            },
            default = "sc",
        },

        Title("显示"),
        {
            name = "elementindicator",
            label = "开启元素图标显示",
            hover = "关闭后可以降低延迟",
            options =
            {
                { description = "开启", data = true, hover = "附着有元素的生物会在头顶显示元素图标" },
                { description = "关闭", data = false, hover = "生物头顶任何时候都没有元素图标" },
            },
            default = true,
        },
        {
            name = "damageindicator",
            label = "开启元素伤害显示",
            hover = "自带的元素伤害显示，如果使用其它显示模组可关闭",
            options =
            {
                { description = "开启", data = true, hover = "攻击生物以及触发元素反应时会显示对应颜色的数字和文字" },
                { description = "关闭", data = false, hover = "攻击和元素反应时不会弹出任何字符" },
            },
            default = true,
        },
        {
            name = "uiscale",
            label = "UI面板显示比例",
            hover = "如果UI大小显示不正常可以尝试修改",
            options =
            {
                { description = "150%", data = 1.5, hover = "UI显示大小：150%" },
                { description = "140%", data = 1.4, hover = "UI显示大小：140%" },
                { description = "130%", data = 1.3, hover = "UI显示大小：130%" },
                { description = "120%", data = 1.2, hover = "UI显示大小：120%" },
                { description = "110%", data = 1.1, hover = "UI显示大小：110%" },
                { description = "自动调整", data = -1, hover = "UI显示自动调整" },
                { description = "100%", data = 1, hover = "UI显示大小：100%" },
                { description = "90%", data = 0.9, hover = "UI显示大小：90%" },
                { description = "80%", data = 0.8, hover = "UI显示大小：80%" },
                { description = "70%", data = 0.7, hover = "UI显示大小：70%" },
                { description = "60%", data = 0.6, hover = "UI显示大小：60%" },
            },
            default = -1,
        },
        {
            name = "controlwhenUIon",
            label = "打开面板时操作游戏",
            hover = "关闭后，打开面板时不能操作游戏，但操作面板时不会引起视角变化",
            options =
            {
                { description = "开启", data = true, hover = "打开属性主面板时可以正常游戏，但是鼠标滚轮会引起视角缩放" },
                { description = "关闭", data = false, hover = "打开属性主面板时无法操作装备栏等游戏元素" },
            },
            default = true,
        },
        {
            name = "cdbadgerefreshtime",
            label = "技能图标刷新频率",
            hover = "如果感觉延迟高，可以将此值调长",
            options =
            {
                { description = "0.1秒", data = 0.1, hover = "每秒刷新10次" },
                { description = "0.2秒", data = 0.2, hover = "每秒刷新5次" },
                { description = "0.5秒", data = 0.5, hover = "每秒刷新2次" },
                { description = "1秒", data = 1, hover = "每秒刷新1次" },
            },
            default = 0.1,
        },

        Title("游戏"),
        {
            name = "environmentelement",
            label = "开启环境元素",
            hover = "环境与元素的交互，开启后可能卡顿",
            options =
            {
                { description = "开启", data = true, hover = "下雨时会为生物添加水元素附着等" },
                { description = "关闭", data = false, hover = "周围环境对生物的元素附着将没有任何影响" },
            },
            default = true,
        },
        {
            name = "energyrecharge",
            label = "生成充能词条",
            hover = "只有完全适配本MOD的角色才可以从中获取收益",
            options =
            {
                { description = "开启", data = true, hover = "圣遗物将生成充能词条，如果您使用的MOD没有使用本MOD的energy_recharge组件，请关闭选项" },
                { description = "关闭", data = false, hover = "圣遗物将不会生成充能词条" },
            },
            default = true,
        },
        {
            name = "artifactsminhealth",
            label = "圣遗物掉落所需最低生命值",
            hover = "低于(不包括)该数值的怪物将不会掉落圣遗物",
            options =
            {
                { description = "100", data = 100, hover = "低于100生命值的生物将不会掉落圣遗物" },
                { description = "200", data = 200, hover = "低于200生命值的生物将不会掉落圣遗物" },
                { description = "500", data = 500, hover = "低于500生命值的生物将不会掉落圣遗物" },
                { description = "1000", data = 1000, hover = "低于1000生命值的生物将不会掉落圣遗物" },
            },
            default = 100,
        },
        {
            name = "artifactsdrop",
            label = "圣遗物掉落概率",
            hover = "圣遗物掉落数量也受此选项影响",
            options =
            {
                { description = "0.5倍", data = 0.5, hover = "圣遗物掉落概率为默认值0.5倍" },
                { description = "1倍", data = 1, hover = "圣遗物掉落概率为默认值" },
                { description = "1.5倍", data = 1.5, hover = "圣遗物掉落概率为默认值1.5倍" },
                { description = "2倍", data = 2, hover = "圣遗物掉落概率为默认值2倍" },
            },
            default = 1,
        },
        {
            name = "artifactsdowithhealth",
            label = "圣遗物修改生命值",
            hover = "部分角色MOD与该项不兼容，请关闭",
            options =
            {
                { description = "开启", data = true, hover = "圣遗物将会修改玩家的最大生命值，如果您使用MOD人物且出现了生命值异常，请关闭选项" },
                { description = "关闭", data = false, hover = "圣遗物将不会对玩家的最大生命值产生任何修改" },
            },
            default = true,
        },
        {
            name = "weaponrefineprotection",
            label = "武器精炼保护",
            hover = "使用已精炼的武器作为素材时，会提示手动选择素材并使用游戏内动作精炼",
            options =
            {
                { description = "开启", data = true, hover = "精炼2阶及以上的武器将给予提示并保护" },
                { description = "关闭", data = false, hover = "选择已经精炼的武器作为材料将不会给出任何提示，请注意素材精炼等级" },
            },
            default = true,
        },
    }

else

    configuration_options =
    {
        Title("Language"),
        {
            name = "language",
            label = "Change Language",
            hover = "The config shows in English because your DST Game language is English",
            options =
            {
                {description = "English", data = "en", hover = "Texts about this MOD will be show in English" },
                {description = "中文", data = "sc", hover = "如果您想将本界面改为中文，请将饥荒本体语言改成中文，然后重启游戏" },
            },
            default = "en",
        },

        Title("Displays"),
        {
            name = "elementindicator",
            label = "The Icon of Elements",
            hover = "Can avoid lags if turn off",
            options =
            {
                {description = "On", data = true, hover = "Icons of element will display on craetures attached with element" },
                {description = "Off", data = false, hover = "There will be NO icons on craetures at any time" },
            },
            default = true,
        },
        {
            name = "damageindicator",
            label = "Damage with Elements",
            hover = "Show damage with elements, can turn off if use other MODs to show damage",
            options =
            {
                {description = "On", data = true, hover = "Numbers and strings will display when you attack or trigger element reaction" },
                {description = "Off", data = false, hover = "Nothing will display when you attack or trigger element reaction" },
            },
            default = true,
        },
        {
            name = "uiscale",
            label = "UI Scale",
            hover = "Control the UI scale if your UI displays incorrectly",
            options =
            {
                {description = "150%", data = 1.5, hover = "The UI will scale to 150%" },
                {description = "140%", data = 1.4, hover = "The UI will scale to 140%" },
                {description = "130%", data = 1.3, hover = "The UI will scale to 130%" },
                {description = "120%", data = 1.2, hover = "The UI will scale to 120%" },
                {description = "110%", data = 1.1, hover = "The UI will scale to 110%" },
                {description = "Auto", data = -1, hover = "The UI will resize automatically" },
                {description = "100%", data = 1, hover = "The UI will scale to 100%" },
                {description = "90%", data = 0.9, hover = "The UI will scale to 90%" },
                {description = "80%", data = 0.8, hover = "The UI will scale to 80%" },
                {description = "70%", data = 0.7, hover = "The UI will scale to 70%" },
                {description = "60%", data = 0.6, hover = "The UI will scale to 60%" },
            },
            default = -1,
        },
        {
            name = "controlwhenUIon",
            label = "Control game when UI is on",
            hover = "Cannot control game with UI on if it's off, will not cause camera zoom however",
            options =
            {
                {description = "On", data = true, hover = "When you open the interface, you can continue game such as control equislots etc" },
                {description = "Off", data = false, hover = "You cannot control game with UI on, but cameras won't zoom when scrolling"},
            },
            default = true,
        },
        {
            name = "cdbadgerefreshtime",
            label = "Refresh time of the Skill Badge",
            hover = "Set the value higher if you feel lags",
            options =
            {
                { description = "100ms", data = 0.1, hover = "Refresh 10 times per second" },
                { description = "200ms", data = 0.2, hover = "Refresh 5 times per second" },
                { description = "500ms", data = 0.5, hover = "Refresh twice per second" },
                { description = "1s", data = 1, hover = "Refresh once per second" },
            },
            default = 0.1,
        },

        Title("Games"),
        {
            name = "environmentelement",
            label = "Elements from Environment",
            hover = "The interactions between elements and enviroment, but may cause slow or lags",
            options =
            {
                {description = "On", data = true, hover = "Hydro will be attached when raining etc" },
                {description = "Off", data = false, hover = "Environment will no longer affect elements" },
            },
            default = true,
        },
        {
            name = "energyrecharge",
            label = "Enable energyrecharge properties",
            hover = "Only characters who have completely adaptations to this MOD can benefit from it",
            options =
            {
                {description = "On", data = true, hover = "if character don't use energy_recharge component of this mod,please turn it off" },
                {description = "Off", data = false, hover = "Artifacts will not have recharge sub texts(also no main text)" },
            },
            default = true,
        },
        {
            name = "artifactsminhealth",
            label = "The min health of entities who drop artifacts",
            hover = "Creatures whose maxhealth is lower than the value will never drop artifacts",
            options =
            {
                { description = "100", data = 100, hover = "" },
                { description = "200", data = 200, hover = "" },
                { description = "500", data = 500, hover = "" },
                { description = "1000", data = 1000, hover = "" },
            },
            default = 100,
        },
        {
            name = "artifactsdrop",
            label = "The chance of artifacts dropping",
            hover = "The number of artifacts dropping is also affected by this",
            options =
            {
                { description = "0.5", data = 0.5, hover = "Arifacts will drop at the 50% of deafult rate" },
                { description = "1", data = 1, hover = "Arifacts will drop at the deafult rate" },
                { description = "1.5", data = 1.5, hover = "Arifacts will drop at the 150% of deafult rate" },
                { description = "2", data = 2, hover = "Arifacts will drop at the 200% of deafult rate" },
            },
            default = 1,
        },
        {
            name = "artifactsdowithhealth",
            label = "Artifacts do with health",
            hover = "Some of character MODs are not compatible with this, please turn off",
            options =
            {
                {description = "On", data = true, hover = "If something is wrong about maxhealth, please turn it off" },
                {description = "Off", data = false, hover = "Artifacts will modifiy the maxhealth of characters" },
            },
            default = true,
        },
        {
            name = "weaponrefineprotection",
            label = "Weapon Refine Protection",
            hover = "Give a warning when choose refined weapons as ingredients",
            options =
            {
                { description = "On", data = true, hover = "Selcet ingredients manually and use ACTIONS in DST game to refine" },
                { description = "Off", data = false, hover = "There will be NO warnings when you choose refined weapons as ingredients" },
            },
            default = true,
        },
    }

end