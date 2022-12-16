
--非常非常感谢“能力勋章”的作者整理的这一份新版制作栏的详细内容
--[[
{
	name,--配方名，一般情况下和需要合成的道具同名
	ingredients,--配方
	tab,--合成栏(已废弃)
	level,--解锁科技
	placer,--建筑类科技放置时显示的贴图、占位等/也可以配List用于添加更多额外参数，比如不可分解{no_deconstruction = true}
	min_spacing,--最小间距，不填默认为3.2
	nounlock,--不解锁配方，只能在满足科技条件的情况下制作(分类默认都算专属科技站,不需要额外添加了)
	numtogive,--一次性制作的数量，不填默认为1
	builder_tag,--制作者需要拥有的标签
	atlas,--需要用到的图集文件(.xml)，不填默认用images/name.xml
	image,--物品贴图(.tex)，不填默认用name.tex
	testfn,--尝试放下物品时的函数，可用于判断坐标点是否符合预期
	product,--实际合成道具，不填默认取name
	build_mode,--建造模式,水上还是陆地(默认为陆地BUILDMODE.LAND,水上为BUILDMODE.WATER)
	build_distance,--建造距离(玩家距离建造点的距离)
	filters,--制作栏分类列表，格式参考{"SPECIAL_EVENT","CHARACTER"}
	
	--扩展字段
	placer,--建筑类科技放置时显示的贴图、占位等
	filter,--制作栏分类
	description,--覆盖原来的配方描述
	canbuild,--制作物品是否满足条件的回调函数,支持参数(recipe, self.inst, pt, rotation),return 结果,原因
	sg_state,--自定义制作物品的动作(比如吹气球就可以调用吹的动作)
	no_deconstruction,--填true则不可分解(也可以用function)
	require_special_event,--特殊活动(比如冬季盛宴限定之类的)
	dropitem,--制作后直接掉落物品
	actionstr,--把"制作"改成其他的文字
	manufactured,--填true则表示是用制作站制作的，而不是用builder组件来制作(比如万圣节的药水台就是用这个)
}
--]]

local function potions_recipes(name, typ, special_ing, special_num)
    local complete_name = typ == "oil" and name.."_essential_oil" or name.."_potion"

    if typ == "oil" then
        return {
            name = complete_name,
            ingredients = 
            {
			    Ingredient(special_ing, special_num),
                Ingredient("goldnugget", 1),
                Ingredient("froglegs", 1)
            },
            level = TECH.MAGIC_TWO,
            atlas = "images/inventoryimages/genshin_potions.xml",
            image = complete_name..".tex",
            filters = { "MAGIC", "CHARACTER" },
        }
    else
        return {
            name = complete_name,
            ingredients = 
            {
			    Ingredient(special_ing, special_num),
                Ingredient("goldnugget", 1),
                Ingredient("petals", 2)
            },
            level = TECH.MAGIC_TWO,
            atlas = "images/inventoryimages/genshin_potions.xml",
            image = complete_name..".tex",
            filters = { "MAGIC", "CHARACTER" },
        }
    end
end

local function randomartifacts_recipes(name)
    return {
        name = "randomartifacts_"..name,
        ingredients = 
        {
			Ingredient("artifactsbundle", 1, "images/inventoryimages/artifactsbundle.xml"),
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/randomartifacts.xml",
        image = "randomartifacts_"..name..".tex",
        filters = { "MAGIC", "CHARACTER" },
    }
end

local Recipes = {

    ---------------------------武器-----------------------------
	{
        name = "element_spear",
        ingredients = 
        {
			Ingredient("spear",1),
            Ingredient("nightmarefuel",3),
            Ingredient("livinglog",2)
        },
        level = TECH.MAGIC_TWO,
        atlas = "images/inventoryimages/element_spear.xml",
        image = "element_spear.tex",
        filters = { "WEAPONS", "CHARACTER" },
    },

    ---------------------------工具-----------------------------
	{
        name = "artifactsbundlewrap",
        ingredients = 
        {
			Ingredient("papyrus", 2), 
            Ingredient("rope", 4), 
            Ingredient("goldnugget", 1)
        },
        level = TECH.NONE,
        atlas = "images/inventoryimages/artifactsbundlewrap.xml",
        image = "artifactsbundlewrap.tex",
        numtogive = 6,
        filters = { "TOOLS", "CHARACTER" },
    },
    {
        name = "artifactsbackpack",
        ingredients = 
        {
			Ingredient("boards", 3), 
            Ingredient("twigs", 6), 
            Ingredient("randomartifacts", 3, "images/inventoryimages/randomartifacts.xml")
        },
        level = TECH.SCIENCE_ONE,
        atlas = "images/inventoryimages/artifactsbackpack.xml",
        image = "artifactsbackpack.tex",
        filters = { "TOOLS", "CHARACTER" },
    },

    ---------------------------建筑-----------------------------
	{
        name = "artifacts_refiner",
        ingredients = 
        {
			Ingredient("artifactsbundle", 10, "images/inventoryimages/artifactsbundle.xml"),
            Ingredient("artifactsbackpack", 1, "images/inventoryimages/artifactsbackpack.xml"),
            Ingredient("cutstone", 4)
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/artifacts_refiner.xml",
        image = "artifacts_refiner.tex",
        filters = { "STRUCTURES", "CHARACTER" },
        placer = "artifacts_refiner_placer",
    },
    {
        name = "teleport_waypoint",
        ingredients = 
        {
			Ingredient("fireflies", 1),
            Ingredient("rocks", 5),
            Ingredient("twigs", 3)
        },
        level = TECH.SCIENCE_TWO,
        atlas = "images/inventoryimages/teleport_waypoint.xml",
        image = "teleport_waypoint.tex",
        filters = { "STRUCTURES", "CHARACTER" },
        placer = "teleport_waypoint_placer",
    },

    ---------------------------精炼-----------------------------
	potions_recipes("flaming", "oil", "charcoal", 3), 
    potions_recipes("frosting", "oil", "ice", 4), 
    potions_recipes("streaming", "oil", "tentaclespots", 1), 
    potions_recipes("shocking", "oil", "transistor", 1), 
    potions_recipes("gushing", "oil", "butterflywings", 2), 
    potions_recipes("unmoving", "oil", "rocks", 6), 
    potions_recipes("forest", "oil", "cutgrass", 8), 
    potions_recipes("heatshield", "potion", "charcoal", 3), 
    potions_recipes("frostshield", "potion", "ice", 4), 
    potions_recipes("desiccant", "potion", "tentaclespots", 1), 
    potions_recipes("insulation", "potion", "transistor", 1), 
    potions_recipes("windbarrier", "potion", "butterflywings", 2), 
    potions_recipes("dustproof", "potion", "rocks", 6), 
    potions_recipes("dendrocide", "potion", "cutgrass", 8), 


    ---------------------------圣遗物还圣匣-----------------------------
    randomartifacts_recipes("bfmt"),
    randomartifacts_recipes("yzmn"),
    randomartifacts_recipes("clzy"),
    randomartifacts_recipes("rlsn"),
    randomartifacts_recipes("clzx"),
    randomartifacts_recipes("ygpy"),
    randomartifacts_recipes("cbzh"),
    randomartifacts_recipes("jyqy"),
    randomartifacts_recipes("sljy"),

}


for k, data in pairs(Recipes) do
    AddRecipe2(data.name, data.ingredients, data.level, {
        min_spacing = data.min_spacing,
        nounlock = data.nounlock,
        numtogive = data.numtogive,
        builder_tag = data.builder_tag,
        atlas = data.atlas,
        image = data.image,
        testfn = data.testfn,
        product = data.product,
        build_mode = data.build_mode,
        build_distance = data.build_distance,

        placer = data.placer,
        filter = data.filter,
        description = data.description,
        canbuild = data.canbuild,
        sg_state = data.sg_state,
        no_deconstruction = data.no_deconstruction,
        require_special_event = data.require_special_event,
        dropitem = data.dropitem,
        actionstr = data.actionstr,
        manufactured = data.manufactured,
    }, data.filters)
end