--全套装
local SETS = {}
for k,v in pairs(TUNING.ARTIFACTS_SETS) do
    table.insert(SETS, k)
end

--全位置
local TAGS = {                   --什么，你说叫的太俗了？
    "flower",      --花          生之花
    "plume",       --毛          死之羽
    "sands",       --沙漏        时之沙
    "goblet",      --杯子        空之杯
    "circlet",     --头          理之冠
}

--全属性
local TYPES_ALL = {
    "hp_per",      --大生命
    "hp",          --小生命
    "atk_per",     --大攻击
    "atk",         --小攻击
    "def_per",     --大防御
    "def",         --小防御
    "mastery",     --元素精通
    --"recharge",    --元素充能效率
    "crit_rate",   --暴击
    "crit_dmg",    --暴伤
    "pyro",        --火伤
    "cryo",        --冰伤
    "hydro",       --水伤
    "electro",     --雷伤
    "anemo",       --风伤
    "geo",         --岩伤
    "dendro",      --草伤
    "physical",    --物伤
}

--主词条
local TYPES_MAIN = {
    flower = {--花
        "hp",      --小生命
    },
    plume = {--羽毛
        "atk",     --小攻击
    },
    sands = {--沙漏
        "atk_per", --大攻击
        "hp_per",  --大生命
        "def_per", --大防御
        "mastery", --精通
        --"recharge",--充能
    },
    goblet = {--杯子
        "atk_per", --大攻击
        "hp_per",  --大生命
        "def_per", --大防御
        "pyro",    --火伤
        "cryo",    --冰伤
        "hydro",   --水伤
        "electro", --雷伤
        "anemo",   --风伤
        "geo",     --岩伤
        "dendro",  --草伤
        "physical",--物伤
    },
    circlet = {--头
        "atk_per", --大攻击
        "hp_per",  --大生命
        "def_per", --大防御
        "mastery", --精通
        "crit_rate",--暴击
        "crit_dmg", --暴伤
    },
}

--主词条数据 --这里用的四星圣遗物数据，因为五星实在是变态
local NUMBER_MAIN = {
    hp_per = 0.466,      --大生命
    hp = 47.8,             --小生命
    atk_per = 0.466,     --大攻击
    atk = 33.1,            --小攻击   --饥荒羽毛的小公鸡太变态了，我是削了又削
    def_per = 0.583,     --大防御
    --没有小防御主词条
    mastery = 187,       --元素精通
    --recharge = 0.518,    --元素充能效率
    crit_rate = 0.331,   --暴击
    crit_dmg = 0.662,    --暴伤
    pyro = 0.466,        --火伤
    cryo = 0.466,        --冰伤
    hydro = 0.466,       --水伤
    electro = 0.466,     --雷伤
    anemo = 0.466,       --风伤
    geo = 0.466,         --岩伤
    dendro = 0.466,      --草伤
    physical = 0.583,    --物伤
}

--副词条
local TYPES_SUB = {
    "hp_per",      --大生命
    "hp",          --小生命
    "atk_per",     --大攻击
    "atk",         --小攻击
    "def_per",     --大防御
    "def",         --小防御
    "mastery",     --元素精通
    --"recharge",    --元素充能效率
    "crit_rate",   --暴击
    "crit_dmg",    --暴伤
}

--副词条数据 --同样是四星数据
local NUMBER_SUB = {
    hp_per = {0.041, 0.047, 0.053, 0.058},      --大生命
    hp = {2.1, 2.4, 2.7, 3.0},                  --小生命
    atk_per = {0.041, 0.047, 0.053, 0.058},     --大攻击
    atk = {1.4, 1.6, 1.8, 1.9},                 --小攻击
    def_per = {0.051, 0.058, 0.066, 0.073},     --大防御
    def = {16, 19, 21, 23},                     --小防御
    mastery = {16, 19, 21, 23},                 --元素精通
    --recharge = {0.045, 0.052, 0.058, 0.065},    --元素充能效率
    crit_rate = {0.027, 0.031, 0.035, 0.039},   --暴击
    crit_dmg = {0.054, 0.062, 0.070, 0.078},     --暴伤
}

if KnownModIndex:IsModEnabled("genshin_raiden") or KnownModIndex:IsModEnabled("workshop-2845021470") or TUNING.ENERGY_RECHARGE_ENABLE then
    table.insert(TYPES_ALL, "recharge")
    table.insert(TYPES_MAIN.sands, "recharge")
    NUMBER_MAIN["recharge"] = 0.518
    table.insert(TYPES_SUB, "recharge")
    NUMBER_SUB["recharge"] = {0.045, 0.052, 0.058, 0.065}
end

---------------------------------------------------------------

local function onsets(self, sets)
    self.inst.replica.artifacts._sets:set(sets or "")
end

local function ontag(self, tag)
    self.inst.replica.artifacts._tag:set(tag or "")
end

local function onmain(self, main)
    self.inst.replica.artifacts._main_type:set(main.type or "")
    self.inst.replica.artifacts._main_number:set(main.number or 0)
end

local function onsub1(self, sub1)
    self.inst.replica.artifacts._sub1_type:set(sub1.type or "")
    self.inst.replica.artifacts._sub1_number:set(sub1.number or 0)
end

local function onsub2(self, sub2)
    self.inst.replica.artifacts._sub2_type:set(sub2.type or "")
    self.inst.replica.artifacts._sub2_number:set(sub2.number or 0)
end

local function onsub3(self, sub3)
    self.inst.replica.artifacts._sub3_type:set(sub3.type or "")
    self.inst.replica.artifacts._sub3_number:set(sub3.number or 0)
end

local function onsub4(self, sub4)
    self.inst.replica.artifacts._sub4_type:set(sub4.type or "")
    self.inst.replica.artifacts._sub4_number:set(sub4.number or 0)
end

local function onlocked(self, locked)
    self.inst.replica.artifacts._locked:set(locked or false)
end

---------------------------------------------------------------

local Artifacts = Class(function(self, inst)
    self.inst = inst
    self:Lock(false)
    self.inited = false
    --圣遗物套装，默认冰套
    self.sets = "bfmt"
    --圣遗物类别，默认是花
    self.tag = "flower"
    --主属性，默认生命值
    self.main = {
        type = "hp",
        number = 35.7,
    }
    --四条副属性，默认无
    self.sub1 = {}
    self.sub2 = {}
    self.sub3 = {}
    self.sub4 = {}
end,
nil,
{
    sets = onsets,
    tag = ontag,
    main = onmain,
    sub1 = onsub1,
    sub2 = onsub2,
    sub3 = onsub3,
    sub4 = onsub4,
    locked = onlocked,
})

function Artifacts:Init(sets, tag, maintype)  --可选参数，比如指定套装，位置和主词条生成(但是不能有BUG，比如不可以生成主词条是攻击力的花)
    if self.inited then
        return
    end
    --确定套装
    if sets ~= nil and table.contains(SETS, sets) then
        self.sets = sets
    else
        self.sets = SETS[math.random(1, #SETS)]
    end

    --确定圣遗物位置
    if tag ~= nil and table.contains(TAGS, tag) then
        self.tag = tag
    else
        self.tag = TAGS[math.random(1, #TAGS)]
    end

    --确定主词条，但是不能有冲突
    if maintype ~= nil and table.contains(TYPES_MAIN[self.tag], maintype) then
        self.main.type = maintype
        self.main.number = NUMBER_MAIN[self.main.type]
    else
        self.main.type = TYPES_MAIN[self.tag][math.random(1, #(TYPES_MAIN[self.tag]))]
        self.main.number = NUMBER_MAIN[self.main.type]
    end

    --确定副词条，但是没有重复
    local subs = {}
    while #subs < 4 do
        local selected = TYPES_SUB[math.random(1, #TYPES_SUB)]
        if selected ~= self.main.type and not table.contains(subs, selected) then
            table.insert(subs, selected)
        end
    end
    self.sub1.type = subs[1]
    self.sub1.number = NUMBER_SUB[self.sub1.type][math.random(1, #(NUMBER_SUB[self.sub1.type]))]
    self.sub2.type = subs[2]
    self.sub2.number = NUMBER_SUB[self.sub2.type][math.random(1, #(NUMBER_SUB[self.sub2.type]))]
    self.sub3.type = subs[3]
    self.sub3.number = NUMBER_SUB[self.sub3.type][math.random(1, #(NUMBER_SUB[self.sub3.type]))]
    self.sub4.type = subs[4]
    self.sub4.number = NUMBER_SUB[self.sub4.type][math.random(1, #(NUMBER_SUB[self.sub4.type]))]

    --强化副词条，进行4-5次(20级)
    local times = 4
    local i = 0
    while i < times do
        if math.random() < 0.25 then     --强化第一个副词条
            self.sub1.number = self.sub1.number + NUMBER_SUB[self.sub1.type][math.random(1, #(NUMBER_SUB[self.sub1.type]))]
        elseif math.random() < 0.5 then  --强化第二个副词条
            self.sub2.number = self.sub2.number + NUMBER_SUB[self.sub2.type][math.random(1, #(NUMBER_SUB[self.sub2.type]))]
        elseif math.random() < 0.75 then --强化第三个副词条
            self.sub3.number = self.sub3.number + NUMBER_SUB[self.sub3.type][math.random(1, #(NUMBER_SUB[self.sub3.type]))]
        else                             --强化第四个副词条
            self.sub4.number = self.sub4.number + NUMBER_SUB[self.sub4.type][math.random(1, #(NUMBER_SUB[self.sub4.type]))]
        end
        i = i + 1
    end

    onmain(self, self.main)
    onsub1(self, self.sub1)
    onsub2(self, self.sub2)
    onsub3(self, self.sub3)
    onsub4(self, self.sub4)

    self.inited = true
    self.inst:SetDescription()
end

function Artifacts:Lock(value)
    if value == nil then
        value = not self.locked
    end
    self.locked = value
    self:ChangeImageBG()
end

function Artifacts:ChangeImageBG()
    if self.locked then
        self.inst.inv_image_bg = { image = "inv_art_lock.tex" }
        self.inst.inv_image_bg.atlas = "images/inventoryimages/inv_art_lock.xml"
    else
        self.inst.inv_image_bg = nil
    end
    --#region
    local old = self.inst.components.inventoryitem.imagename
    self.inst.components.inventoryitem:ChangeImageName("nil")
    self.inst.components.inventoryitem:ChangeImageName(old)
end

function Artifacts:OnSave()
    return
    {
        main = self.main,
        sub1 = self.sub1,
        sub2 = self.sub2,
        sub3 = self.sub3,
        sub4 = self.sub4,
        inited = self.inited,
        locked = self.locked,
    }
end

function Artifacts:OnLoad(data)
    if data == nil then
        return
    end
    if data.main ~= nil then
        self.main = data.main
    end
    if data.sub1 ~= nil then
        self.sub1 = data.sub1
    end
    if data.sub2 ~= nil then
        self.sub2 = data.sub2
    end
    if data.sub3 ~= nil then
        self.sub3 = data.sub3
    end
    if data.sub4 ~= nil then
        self.sub4 = data.sub4
    end
    self.inited = data.inited ~= nil and data.inited or false
    self:Lock(data.locked ~= nil and data.locked or false)
    self.inst:SetDescription()
end

function Artifacts:GetSets()
    return self.sets
end

function Artifacts:GetTag()
    return self.tag
end

function Artifacts:GetMain()
    return self.main
end

function Artifacts:GetSub1()
    return self.sub1
end

function Artifacts:GetSub2()
    return self.sub2
end

function Artifacts:GetSub3()
    return self.sub3
end

function Artifacts:GetSub4()
    return self.sub4
end

function Artifacts:IsLocked()
    return self.locked
end

return Artifacts