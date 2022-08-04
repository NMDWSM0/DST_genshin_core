ACTIONS.ATTACK.fn = function(act)
    if act.doer.sg ~= nil then
        if act.doer.sg:HasStateTag("propattack") then
            --don't do a real attack with prop weapons
            return true
        elseif act.doer.sg:HasStateTag("thrusting") then
            local weapon = act.doer.components.combat:GetWeapon()
            return weapon ~= nil
                and weapon.components.multithruster ~= nil
                and weapon.components.multithruster:StartThrusting(act.doer)
        elseif act.doer.sg:HasStateTag("helmsplitting") then
            local weapon = act.doer.components.combat:GetWeapon()
            return weapon ~= nil
                and weapon.components.helmsplitter ~= nil
                and weapon.components.helmsplitter:StartHelmSplitting(act.doer)
        end
    end
    ---------------------------------------------------------------------------
    --修改内容
    local instancemult = 1
    local ischarge = act.doer.sg ~= nil and act.doer.sg:HasStateTag("chargeattack")
    if ischarge then
        local weapon = act.doer.components.combat:GetWeapon()
        instancemult = act.doer.chargeattackdmgratefn ~= nil and act.doer:chargeattackdmgratefn(act.target) or (weapon and weapon.chargeattackdmgratefn ~= nil and weapon:chargeattackdmgratefn(act.doer, act.target) or 1)
    else
        instancemult = act.doer.normalattackdmgratefn ~= nil and act.doer:normalattackdmgratefn(act.target) or 1
    end
    if act.doer.customattackfn ~= nil then
        act.doer:customattackfn(act.target, instancemult, ischarge)
    else
        act.doer.components.combat:DoAttack(act.target, nil, nil, nil, instancemult)
    end
    -----------------------------------------------------------------------------
    return true
end