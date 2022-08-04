--特殊装备栏
local EXTRA_EQUIPSLOTS =
{
    FLOWER = "flower",
    PLUME = "plume",
    SANDS = "sands",
    GOBLET = "goblet",
    CIRCLET = "circlet",
}

for k, v in pairs(EXTRA_EQUIPSLOTS) do 
    GLOBAL.EQUIPSLOTS[k] = v
end

GLOBAL.EQUIPSLOT_IDS = {}
local slot = 0
for k, v in pairs(GLOBAL.EQUIPSLOTS) do
    slot = slot + 1
    GLOBAL.EQUIPSLOT_IDS[v] = slot
end
slot = nil

--这五个装备槽是没有UI的，你看不见它们