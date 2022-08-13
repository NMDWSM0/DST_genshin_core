function RegisterArtifactSlots()
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

    -- EQUIPSLOT_IDS = {}
    -- local slot = 0
    -- for k, v in pairs(EQUIPSLOTS) do
    --     slot = slot + 1
    --     EQUIPSLOT_IDS[v] = slot
    -- end
    -- slot = nil

    --这五个装备槽是没有UI的，你看不见它们
end