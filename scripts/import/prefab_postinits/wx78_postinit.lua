--[[
AddPrefabPostInit("wx78", function(inst)
    if not TheWorld.ismastersim then
        return
	end
    --生命
    local function apply_health(inst)
        local max_upgrades = 15
        inst.components.health:SetMaxHealthWithPercent(math.ceil(TUNING.WX78_MIN_HEALTH + inst.level * (TUNING.WX78_MAX_HEALTH - TUNING.WX78_MIN_HEALTH) / max_upgrades))
    end

    -------------------------------------------------
    local old_eatfn = inst.components.eater.oneatfn
    local function oneat(inst, food)
        old_eatfn(inst, food)
        apply_health(inst)
    end
    inst.components.eater:SetOnEatFn(oneat)

    -------------------------------------------------
    local old_onpreload = inst.OnPreLoad
    local function onpreload(inst, data)
        old_onpreload(inst, data)
        apply_health(inst)
    end
    inst.OnPreLoad = onpreload
    -------------------------------------------------
    inst:ListenForEvent("death", function(inst)
        inst:DoTaskInTime(FRAMES, function(inst) apply_health(inst) end)
    end)

    inst:ListenForEvent("ms_playerreroll", function(inst)
        inst:DoTaskInTime(FRAMES, function(inst) apply_health(inst) end)
    end) --delevel, give back some gears
end)
]]


local function maxhealth_change(inst, wx, amount, isloading)
    if wx.components.health ~= nil then
        local current_health_percent = wx.components.health:GetPercent()

        --wx.components.health.maxhealth = wx.components.health.maxhealth + amount
        wx.components.health:SetMaxHealth(wx.components.health.base_health + amount)

        if not isloading then
            wx.components.health:SetPercent(current_health_percent)

            -- We want to force a badge pulse, but also maintain the health percent as much as we can.
            local badgedelta = (amount > 0 and 0.01) or -0.01
            wx.components.health:DoDelta(badgedelta, false, nil, true)
        end
    end
end

local function maxhealth_activate(inst, wx, isloading)
    maxhealth_change(inst, wx, TUNING.WX78_MAXHEALTH_BOOST, isloading)
end

local function maxhealth_deactivate(inst, wx)
    maxhealth_change(inst, wx, -TUNING.WX78_MAXHEALTH_BOOST)
end

local function maxhealth2_activate(inst, wx, isloading)
    local maxhealth2_boost = TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT
    maxhealth_change(inst, wx, maxhealth2_boost, isloading)
end

local function maxhealth2_deactivate(inst, wx)
    local maxhealth2_boost = TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT
    maxhealth_change(inst, wx, -maxhealth2_boost)
end

AddPrefabPostInit("wx78module_maxhealth", function(inst)
    if inst.components.upgrademodule == nil then
        return
    end
    inst.components.upgrademodule.onactivatedfn = maxhealth_activate
    inst.components.upgrademodule.ondeactivatedfn = maxhealth_deactivate
end)

AddPrefabPostInit("wx78module_maxhealth2", function(inst)
    if inst.components.upgrademodule == nil then
        return
    end
    inst.components.upgrademodule.onactivatedfn = maxhealth2_activate
    inst.components.upgrademodule.ondeactivatedfn = maxhealth2_deactivate
end)
