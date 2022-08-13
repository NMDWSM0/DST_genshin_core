AddPrefabPostInit("houndmound", function(inst)
    local old_SpawnAllGuards = nil
    local old_OnHaunt = nil
    if inst.components.combat then
        old_SpawnAllGuards = inst.components.combat.onhitfn
    end
    if inst.components.hauntable then
        old_OnHaunt = inst.components.hauntable.onhaunt
    end

    if old_SpawnAllGuards == nil or old_OnHaunt == nil then
        return
    end

    local function SpawnAllGuards(inst, attacker)
        if inst.components.health == nil then
            return
        end
        old_SpawnAllGuards(inst, attacker)
    end

    local function OnHaunt(inst, haunter)
        if inst.components.health == nil then
            return
        end
        old_OnHaunt(inst, haunter)
    end

    if inst.components.combat then
        inst.components.combat:SetOnHit(SpawnAllGuards)
    end
    if inst.components.hauntable then
        inst.components.hauntable:SetOnHauntFn(OnHaunt)
    end

end)