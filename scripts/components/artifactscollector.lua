-------------------------------------------------------
--冰套
local function bfmtfourfn(inst)
    inst.components.combat.external_critical_rate_multipliers:SetModifier("artifacts", 0.2, "cryo_attached_bfmt4", { element_attached = "cryo" })
    inst.components.combat.external_critical_rate_multipliers:SetModifier("artifacts", 0.2, "frozen_bfmt4", 
    {
        custom_fn = function(attacker, target, atk_elements, atk_key) 
            return target.components.freezable and target.components.freezable:IsFrozen()
        end
    })
end

local function de_bfmtfourfn(inst)
    inst.components.combat.external_critical_rate_multipliers:RemoveModifier("artifacts", "cryo_attached_bfmt4")
    inst.components.combat.external_critical_rate_multipliers:RemoveModifier("artifacts", "frozen_bfmt4")
end

-------------------------------------------------------
--火套
local function OnDamageCalculated_YZMN4(inst, data)
    if data == nil or data.attackkey == nil or data.attackkey ~= "elementalskill" then
        return
    end
    --如果是元素战技
    if not inst:HasTag("yzmn4_eleskill_lvl") then
        inst.components.combat.external_pyro_multipliers:SetModifier("artifacts", 0.075, "all_yzmn4_eleskill_lvl")
        inst:AddTag("yzmn4_eleskill_lvl")
        inst:DoTaskInTime(10, function(inst)
            inst:RemoveTag("yzmn4_eleskill_lvl")
            inst.components.combat.external_pyro_multipliers:RemoveModifier("artifacts", "all_yzmn4_eleskill_lvl")
        end)
        return
    elseif not inst:HasTag("yzmn4_eleskill_lv2") then
        inst.components.combat.external_pyro_multipliers:SetModifier("artifacts", 0.075, "all_yzmn4_eleskill_lv2")
        inst:AddTag("yzmn4_eleskill_lv2")
        inst:DoTaskInTime(10, function(inst)
            inst:RemoveTag("yzmn4_eleskill_lv2")
            inst.components.combat.external_pyro_multipliers:RemoveModifier("artifacts", "all_yzmn4_eleskill_lv2")
        end)
        return
    elseif not inst:HasTag("yzmn4_eleskill_lv3") then
        inst.components.combat.external_pyro_multipliers:SetModifier("artifacts", 0.075, "all_yzmn4_eleskill_lv3")
        inst:AddTag("yzmn4_eleskill_lv3")
        inst:DoTaskInTime(10, function(inst)
            inst:RemoveTag("yzmn4_eleskill_lv3")
            inst.components.combat.external_pyro_multipliers:RemoveModifier("artifacts", "all_yzmn4_eleskill_lv3")
        end)
    end
end

local function yzmnfourfn(inst)
    inst.components.elementreactor.attack_overload_bonus_modifier:SetModifier("artifacts", 0.4, "all_yzmn4")
    inst.components.elementreactor.attack_melt_bonus_modifier:SetModifier("artifacts", 0.15, "all_yzmn4")
    inst.components.elementreactor.attack_vaporize_bonus_modifier:SetModifier("artifacts", 0.15, "all_yzmn4")
    inst.components.elementreactor.attack_burgeon_bonus_modifier:SetModifier("artifacts", 0.4, "all_yzmn4")
    inst:ListenForEvent("damagecalculated", OnDamageCalculated_YZMN4)
end

local function de_yzmnfourfn(inst)
    inst.components.elementreactor.attack_overload_bonus_modifier:RemoveModifier("artifacts", "all_yzmn4")
    inst.components.elementreactor.attack_melt_bonus_modifier:RemoveModifier("artifacts", "all_yzmn4")
    inst.components.elementreactor.attack_vaporize_bonus_modifier:RemoveModifier("artifacts", "all_yzmn4")
    inst.components.elementreactor.attack_burgeon_bonus_modifier:RemoveModifier("artifacts", "all_yzmn4")
    inst:RemoveEventCallback("damagecalculated", OnDamageCalculated_YZMN4)
end

-------------------------------------------------------
--风套
local function OnSwirlTarget_CLZY4(inst, data)
    if data and data.target and data.target.components.combat and data.element_swirled ~= nil and data.element_swirled >= 1 and data.element_swirled <= 4 then
        if not data.target:HasTag("clzy4_resdown_ele"..data.element_swirled) then
            local elements = {
                "pyro",
                "cryo",
                "hydro",
                "electro",
            }
            local element = elements[data.element_swirled]
            data.target.components.combat["external_"..element.."_res_multipliers"]:SetModifier("artifacts", -0.4, "all_clzy4_resdown")
            data.target:AddTag("clzy4_resdown_ele"..data.element_swirled)
            data.target:DoTaskInTime(10, function(target)
                target:RemoveTag("clzy4_resdown_ele"..data.element_swirled)
                target.components.combat["external_"..element.."_res_multipliers"]:RemoveModifier("artifacts", "all_clzy4_resdown")
            end)
        end
    end
end

local function clzyfourfn(inst)
    inst.components.elementreactor.attack_swirl_bonus_modifier:SetModifier("artifacts", 0.6, "all_clzy4")
    inst:ListenForEvent("swirltarget", OnSwirlTarget_CLZY4)
end

local function de_clzyfourfn(inst)
    inst.components.elementreactor.attack_swirl_bonus_modifier:RemoveModifier("artifacts", "all_clzy4")
    inst:RemoveEventCallback("swirltarget", OnSwirlTarget_CLZY4)
end

-------------------------------------------------------
--如雷套
local function OnElectroReaction_RLSN4(inst, data)
    if not inst:HasTag("rlsn4_decreasecd") then
        --如果有真的元素战技
        if inst.components.elementalcaster ~= nil then
            inst.components.elementalcaster:LeftTimeDelta("elementalskill", 1)
        end
        local weapon = inst.components.combat:GetWeapon()
        if weapon and weapon.components.rechargeable and weapon:HasTag("aselementalskill") then
            weapon.components.rechargeable:LeftTimeDelta(1)
        end
        inst:AddTag("rlsn4_decreasecd")
        inst:DoTaskInTime(0.8, function(inst) inst:RemoveTag("rlsn4_decreasecd") end)
    end
end

local function rlsnfourfn(inst)
    inst.components.elementreactor.attack_overload_bonus_modifier:SetModifier("artifacts", 0.4, "all_rlsn4")
    inst.components.elementreactor.attack_electrocharged_bonus_modifier:SetModifier("artifacts", 0.4, "all_rlsn4")
    inst.components.elementreactor.attack_superconduct_bonus_modifier:SetModifier("artifacts", 0.4, "all_rlsn4")
    inst.components.elementreactor.attack_hyperbloom_bonus_modifier:SetModifier("artifacts", 0.4, "all_rlsn4")
    inst.components.elementreactor.attack_aggravate_bonus_modifier:SetModifier("artifacts", 0.2, "all_rlsn4")
    inst:ListenForEvent("overloadtarget", OnElectroReaction_RLSN4)
    inst:ListenForEvent("superconducttarget", OnElectroReaction_RLSN4)
    inst:ListenForEvent("electrochargedtarget", OnElectroReaction_RLSN4)
    inst:ListenForEvent("hyperbloomtarget", OnElectroReaction_RLSN4)
    inst:ListenForEvent("quickentarget", OnElectroReaction_RLSN4)
    inst:ListenForEvent("aggravatetarget", OnElectroReaction_RLSN4)
end

local function de_rlsnfourfn(inst)
    inst.components.elementreactor.attack_overload_bonus_modifier:RemoveModifier("artifacts", "all_rlsn4")
    inst.components.elementreactor.attack_electrocharged_bonus_modifier:RemoveModifier("artifacts", "all_rlsn4")
    inst.components.elementreactor.attack_superconduct_bonus_modifier:RemoveModifier("artifacts", "all_rlsn4")
    inst.components.elementreactor.attack_hyperbloom_bonus_modifier:RemoveModifier("artifacts", "all_rlsn4")
    inst.components.elementreactor.attack_aggravate_bonus_modifier:RemoveModifier("artifacts", "all_rlsn4")
    inst:RemoveEventCallback("overloadtarget", OnElectroReaction_RLSN4)
    inst:RemoveEventCallback("superconducttarget", OnElectroReaction_RLSN4)
    inst:RemoveEventCallback("electrochargedtarget", OnElectroReaction_RLSN4)
    inst:RemoveEventCallback("hyperbloomtarget", OnElectroReaction_RLSN4)
    inst:RemoveEventCallback("quickentarget", OnElectroReaction_RLSN4)
    inst:RemoveEventCallback("aggravatetarget", OnElectroReaction_RLSN4)
end

-------------------------------------------------------
--水套
local function OnDamageCalculated_CLZX4(inst, data)
    if data == nil or data.attackkey == nil or data.attackkey ~= "elementalskill" then
        return
    end
    --如果是元素战技
    if not inst:HasTag("clzx4_eleskill") then
        inst.components.combat.external_attacktype_multipliers:SetModifier("artifacts", 0.3, "normal_clzx4_eleskill", { atk_key = "normal" })
        inst.components.combat.external_attacktype_multipliers:SetModifier("artifacts", 0.3, "charge_clzx4_eleskill", { atk_key = "charge" })
        inst:AddTag("clzx4_eleskill")
        inst:DoTaskInTime(15, function(inst)
            inst:RemoveTag("clzx4_eleskill")
            inst.components.combat.external_attacktype_multipliers:RemoveModifier("artifacts", "normal_clzx4_eleskill")
            inst.components.combat.external_attacktype_multipliers:RemoveModifier("artifacts", "charge_clzx4_eleskill")
        end)
    end
end

local function clzxfourfn(inst)
    inst:ListenForEvent("damagecalculated", OnDamageCalculated_CLZX4)
end

local function de_clzxfourfn(inst)
    inst:RemoveEventCallback("damagecalculated", OnDamageCalculated_CLZX4)
end

-------------------------------------------------------
--磐岩套
local function OnGetShield_YGPY4(inst, data)
    if data == nil or data.element == nil or type(data.element) ~= "number" or data.element < 1 or data.element > 4 then
        return
    end
    local modifiers = {
        inst.components.combat.external_pyro_multipliers,
	    inst.components.combat.external_cryo_multipliers,
	    inst.components.combat.external_hydro_multipliers,
	    inst.components.combat.external_electro_multipliers,
    }

    --移除来自四件套的元素加伤效果
    for k,v in pairs(modifiers) do
        v:RemoveModifier("artifacts", "all_ygpy4") 
    end
    if inst.ygpy4_canceltask ~= nil then  --并且重置计时器
        inst.ygpy4_canceltask:Cancel()
        inst.ygpy4_canceltask = nil
    end

    --加上新的加成
    modifiers[data.element]:SetModifier("artifacts", 0.35, "all_ygpy4")
    inst.ygpy4_canceltask = inst:DoTaskInTime(10, function() modifiers[data.element]:RemoveModifier("artifacts", "all_ygpy4") end)
end

local function ygpyfourfn(inst)
    inst:ListenForEvent("getcrystallizeshield", OnGetShield_YGPY4)
end

local function de_ygpyfourfn(inst)
    inst:RemoveEventCallback("getcrystallizeshield", OnGetShield_YGPY4)
end

-------------------------------------------------------
--苍白套
local function checkcbzhtag(inst)
    if inst:HasTag("cbzh4_eleskill_lvl") and inst:HasTag("cbzh4_eleskill_lv2") then
        inst.components.combat.external_physical_multipliers:SetModifier("artifacts", 0.25, "all_ygpy4_lv1andlv2")
    else
        inst.components.combat.external_physical_multipliers:RemoveModifier("artifacts", "all_ygpy4_lv1andlv2")
    end
end

local function OnDamageCalculated_CBZH4(inst, data)
    if data == nil or data.attackkey == nil or data.attackkey ~= "elementalskill" then
        return
    end
    if not inst:HasTag("cbzh4_eleskill_lvl") then
        inst.components.combat.external_atk_multipliers:SetModifier("artifacts", 0.09, "all_cbzh4_eleskill_lvl")
        checkcbzhtag(inst)
        inst:AddTag("cbzh4_eleskill_lvl")
        inst:DoTaskInTime(7, function(inst)
            inst:RemoveTag("cbzh4_eleskill_lvl")
            inst.components.combat.external_atk_multipliers:RemoveModifier("artifacts", "all_cbzh4_eleskill_lvl")
            checkcbzhtag(inst)
        end)
        return
    elseif not inst:HasTag("cbzh4_eleskill_lv2") then
        inst.components.combat.external_atk_multipliers:SetModifier("artifacts", 0.09, "all_cbzh4_eleskill_lv2")
        checkcbzhtag(inst)
        inst:AddTag("cbzh4_eleskill_lv2")
        inst:DoTaskInTime(7, function(inst)
            inst:RemoveTag("cbzh4_eleskill_lv2")
            inst.components.combat.external_atk_multipliers:RemoveModifier("artifacts", "all_cbzh4_eleskill_lv2")
            checkcbzhtag(inst)
        end)
    end
end

local function cbzhfourfn(inst)
    inst:ListenForEvent("damagecalculated", OnDamageCalculated_CBZH4)
end

local function de_cbzhfourfn(inst)
    inst:RemoveEventCallback("damagecalculated", OnDamageCalculated_CBZH4)
end

-------------------------------------------------------
--绝缘套
local function OnRechargeChange_JYQY4(inst)
    local recharge = inst.components.energyrecharge ~= nil and inst.components.energyrecharge:GetEnergyRecharge() or 1
    local rate = math.max(math.min(0.25 * recharge, 0.75), 0)
    inst.components.combat.external_attacktype_multipliers:SetModifier("artifacts", rate, "elementalburst_jyqy4", { atk_key = "elementalburst" })
end

local function jyqyfourfn(inst)
    OnRechargeChange_JYQY4(inst)
    inst:ListenForEvent("energyrecharge_change", OnRechargeChange_JYQY4)
end

local function de_jyqyfourfn(inst)
    inst:RemoveEventCallback("energyrecharge_change", OnRechargeChange_JYQY4)
    inst.components.combat.external_attacktype_multipliers:RemoveModifier("artifacts", "elementalburst_jyqy4")
end

-------------------------------------------------------
--草套
local function OnDamageCalculated_SLJY4(inst, data)
    if data == nil or data.attackkey == nil or (data.attackkey ~= "elementalskill" and data.attackkey ~= "elementalburst") then
        return
    end

    local target = data.target
    if target == nil or target.components.combat == nil or target:HasTag("sljy4_dendroresdown") then
        return
    end
    target.components.combat.external_dendro_res_multipliers:SetModifier("artifacts", -0.3, "all_sljy4_resdown")
    target:AddTag("sljy4_dendroresdown")
    target:DoTaskInTime(8, function(target)
        target.components.combat.external_dendro_res_multipliers:RemoveModifier("artifacts", "all_sljy4_resdown")
        target:RemoveTag("sljy4_dendroresdown")
    end)
end

local function sljyfourfn(inst)
    inst:ListenForEvent("damagecalculated", OnDamageCalculated_SLJY4)
end

local function de_sljyfourfn(inst)
    inst:RemoveEventCallback("damagecalculated", OnDamageCalculated_SLJY4)
end



--------------------------------------------------------------------
--------------------------------------------------------------------
--下面开始定义

local function onexist_replica_test(self, exist_replica_test)
    if not self.inst.replica or not self.inst.replica.artifactscollector then
        --不存在
        return
    end
    local value = self.inst.replica.artifactscollector._exist_replica_test:value()
    self.inst.replica.artifactscollector._exist_replica_test:set(not value)
end

local ArtifactsCollector = Class(function(self, inst)
    self.inst = inst
    
    self.hp_per = 0
    self.hp = 0
    self.atk_per = 0
    self.atk = 0
    self.def_per = 0
    self.def = 0
    self.mastery = 0
    self.recharge = 0

    self.pyro = 0
    self.pyro_res = 0
    self.cryo = 0
    self.cryo_res = 0
    self.hydro = 0
    self.hydro_res = 0
    self.electro = 0
    self.electro_res = 0
    self.anemo = 0
    self.anemo_res = 0
    self.geo = 0
    self.geo_res = 0
    self.dendro = 0
    self.dendro_res = 0
    self.physical = 0
    self.pyhsical_res = 0

    --装备和卸下四件套自定义函数时要干的事
    self.setsfourfn = nil
    self.de_setsfourfn = nil

    --用来检测replica还在不在的？
    self.exist_replica_test = false
end,
nil,
{
    exist_replica_test = onexist_replica_test,
})

function ArtifactsCollector:ResetModifier()
    --重置自身
    self.hp_per = 0
    self.hp = 0
    self.atk_per = 0
    self.atk = 0
    self.def_per = 0
    self.def = 0
    self.mastery = 0
    self.recharge = 0
    
    self.crit_rate = 0
    self.crit_dmg = 0

    self.pyro = 0
    self.pyro_res = 0
    self.cryo = 0
    self.cryo_res = 0
    self.hydro = 0
    self.hydro_res = 0
    self.electro = 0
    self.electro_res = 0
    self.anemo = 0
    self.anemo_res = 0
    self.geo = 0
    self.geo_res = 0
    self.dendro = 0
    self.dendro_res = 0
    self.physical = 0
    self.pyhsical_res = 0
    --移除所有部件中来自圣遗物的加成
    local modifiers = {
        --combat
        self.inst.components.combat.external_atk_multipliers,
        self.inst.components.combat.external_defense_multipliers,
        self.inst.components.combat.external_critical_rate_multipliers,
        self.inst.components.combat.external_critical_damage_multipliers,
        self.inst.components.combat.external_element_mastery_multipliers,
        self.inst.components.combat.external_pyro_multipliers,
	    self.inst.components.combat.external_cryo_multipliers,
	    self.inst.components.combat.external_hydro_multipliers,
	    self.inst.components.combat.external_electro_multipliers,
	    self.inst.components.combat.external_anemo_multipliers,
	    self.inst.components.combat.external_geo_multipliers,
	    self.inst.components.combat.external_dendro_multipliers,
	    self.inst.components.combat.external_physical_multipliers,
	    self.inst.components.combat.external_pyro_res_multipliers,
	    self.inst.components.combat.external_cryo_res_multipliers,
	    self.inst.components.combat.external_hydro_res_multipliers,
	    self.inst.components.combat.external_electro_res_multipliers,
	    self.inst.components.combat.external_anemo_res_multipliers,
	    self.inst.components.combat.external_geo_res_multipliers,
	    self.inst.components.combat.external_dendro_res_multipliers,
	    self.inst.components.combat.external_physical_res_multipliers,
        --elementreactor
        self.inst.components.elementreactor.attack_melt_bonus_modifier,
        self.inst.components.elementreactor.attack_vaporize_bonus_modifier,
        self.inst.components.elementreactor.attack_superconduct_bonus_modifier,
        self.inst.components.elementreactor.attack_overload_bonus_modifier,
        self.inst.components.elementreactor.attack_electrocharged_bonus_modifier,
        self.inst.components.elementreactor.attack_swirl_bonus_modifier,
        self.inst.components.elementreactor.attack_shattered_bonus_modifier,
        --health
        self.inst.components.health.maxhealth_modifier,
        --energyrecharge
        --self.inst.components.energyrecharge.external_recharge_multipliers,
    }
    for k,v in pairs(modifiers) do
        v:RemoveModifier("artifacts")
    end
    --单独处理元素充能
    if self.inst.components.energyrecharge then
        self.inst.components.energyrecharge:RemoveModifier("artifacts")
    end
    --小公鸡，小防御，小生命归零
    self.inst.components.combat.atkbonus = 0
    self.inst.components.combat.defensebonus = 0
    self.inst.components.health.healthbonus = 0
    --四件套自定义函数效果移除
    if self.de_setsfourfn ~= nil then
        self.de_setsfourfn(self.inst)
    end
    self.setsfourfn = nil
    self.de_setsfourfn = nil
end

function ArtifactsCollector:CalculateSingle(artifact)
    if artifact == nil then
        return
    end

    local main = artifact.components.artifacts:GetMain()
    local sub1 = artifact.components.artifacts:GetSub1()
    local sub2 = artifact.components.artifacts:GetSub2()
    local sub3 = artifact.components.artifacts:GetSub3()
    local sub4 = artifact.components.artifacts:GetSub4()

    if self[main.type] ~= nil then
        self[main.type] = self[main.type] + main.number
    end
    if self[sub1.type] ~= nil then
        self[sub1.type] = self[sub1.type] + sub1.number
    end
    if self[sub2.type] ~= nil then
        self[sub2.type] = self[sub2.type] + sub2.number
    end
    if self[sub3.type] ~= nil then
        self[sub3.type] = self[sub3.type] + sub3.number
    end
    if self[sub4.type] ~= nil then
        self[sub4.type] = self[sub4.type] + sub4.number
    end
end

function ArtifactsCollector:SetsTwo(sets)
    if sets == "bfmt" then
        self.cryo = self.cryo + 0.15
    elseif sets == "yzmn" then
        self.pyro = self.pyro + 0.15
    elseif sets == "clzy" then
        self.anemo = self.anemo + 0.15
    elseif sets == "rlsn" then
        self.electro = self.electro + 0.15
    elseif sets == "clzx" then
        self.hydro = self.hydro + 0.15
    elseif sets == "ygpy" then
        self.geo = self.geo + 0.15
    elseif sets == "cbzh" then
        self.physical = self.physical + 0.25
    elseif sets == "jyqy" then
        self.recharge = self.recharge + 0.2
    elseif sets == "sljy" then
        self.dendro = self.dendro + 0.15
    end
end

function ArtifactsCollector:SetsFour(sets)
    if sets == "bfmt" then
        self.setsfourfn = bfmtfourfn
        self.de_setsfourfn = de_bfmtfourfn
    elseif sets == "yzmn" then
        self.setsfourfn = yzmnfourfn
        self.de_setsfourfn = de_yzmnfourfn
    elseif sets == "clzy" then
        self.setsfourfn = clzyfourfn
        self.de_setsfourfn = de_clzyfourfn
    elseif sets == "rlsn" then
        self.setsfourfn = rlsnfourfn
        self.de_setsfourfn = de_rlsnfourfn
    elseif sets == "clzx" then
        self.setsfourfn = clzxfourfn
        self.de_setsfourfn = de_clzxfourfn
    elseif sets == "ygpy" then
        self.setsfourfn = ygpyfourfn
        self.de_setsfourfn = de_ygpyfourfn
    elseif sets == "cbzh" then
        self.setsfourfn = cbzhfourfn
        self.de_setsfourfn = de_cbzhfourfn
    elseif sets == "jyqy" then
        self.setsfourfn = jyqyfourfn
        self.de_setsfourfn = de_jyqyfourfn
    elseif sets == "sljy" then
        self.setsfourfn = sljyfourfn
        self.de_setsfourfn = de_sljyfourfn
    end
end

function ArtifactsCollector:CalculateSets(data)
    local SETS_NUMBER = {}
    for k,v in pairs(TUNING.ARTIFACTS_SETS) do
        SETS_NUMBER[k] = 0
    end

    for k,v in pairs(data) do
        if v and v.components.artifacts.sets ~= nil and SETS_NUMBER[v.components.artifacts.sets] ~= nil then
            SETS_NUMBER[v.components.artifacts.sets] = SETS_NUMBER[v.components.artifacts.sets] + 1
        end
    end

    for k,v in pairs(SETS_NUMBER) do
        if v >= 2 then
            self:SetsTwo(k)   --两件套
        end
        if v >= 4 then
            self:SetsFour(k)  --四件套
        end
    end
end

function ArtifactsCollector:AddModifier()
    --health
    self.inst.components.health.maxhealth_modifier:SetModifier("artifacts", self.hp_per, "all_artifacts_base")
    --combat
    self.inst.components.combat.external_atk_multipliers:SetModifier("artifacts", self.atk_per, "all_artifacts_base")
    self.inst.components.combat.external_defense_multipliers:SetModifier("artifacts", self.def_per, "all_artifacts_base")
    self.inst.components.combat.external_critical_rate_multipliers:SetModifier("artifacts", self.crit_rate, "all_artifacts_base")
    self.inst.components.combat.external_critical_damage_multipliers:SetModifier("artifacts", self.crit_dmg, "all_artifacts_base")
    self.inst.components.combat.external_element_mastery_multipliers:SetModifier("artifacts", self.mastery, "all_artifacts_base")
    self.inst.components.combat.external_pyro_multipliers:SetModifier("artifacts", self.pyro, "all_artifacts_base")
	self.inst.components.combat.external_cryo_multipliers:SetModifier("artifacts", self.cryo, "all_artifacts_base")
	self.inst.components.combat.external_hydro_multipliers:SetModifier("artifacts", self.hydro, "all_artifacts_base")
	self.inst.components.combat.external_electro_multipliers:SetModifier("artifacts", self.electro, "all_artifacts_base")
	self.inst.components.combat.external_anemo_multipliers:SetModifier("artifacts", self.anemo, "all_artifacts_base")
	self.inst.components.combat.external_geo_multipliers:SetModifier("artifacts", self.geo, "all_artifacts_base")
	self.inst.components.combat.external_dendro_multipliers:SetModifier("artifacts", self.dendro, "all_artifacts_base")
	self.inst.components.combat.external_physical_multipliers:SetModifier("artifacts", self.physical, "all_artifacts_base")
	self.inst.components.combat.external_pyro_res_multipliers:SetModifier("artifacts", self.pyro_res, "all_artifacts_base")
	self.inst.components.combat.external_cryo_res_multipliers:SetModifier("artifacts", self.cryo_res, "all_artifacts_base")
	self.inst.components.combat.external_hydro_res_multipliers:SetModifier("artifacts", self.hydro_res, "all_artifacts_base")
	self.inst.components.combat.external_electro_res_multipliers:SetModifier("artifacts", self.electro_res, "all_artifacts_base")
	self.inst.components.combat.external_anemo_res_multipliers:SetModifier("artifacts", self.anemo_res, "all_artifacts_base")
	self.inst.components.combat.external_geo_res_multipliers:SetModifier("artifacts", self.geo_res, "all_artifacts_base")
	self.inst.components.combat.external_dendro_res_multipliers:SetModifier("artifacts", self.dendro_res, "all_artifacts_base")
	self.inst.components.combat.external_physical_res_multipliers:SetModifier("artifacts", self.pyhsical_res, "all_artifacts_base")
    --energyrecharge
    if self.inst.components.energyrecharge then
        self.inst.components.energyrecharge:SetModifier("artifacts", self.recharge, "all_artifacts_base")
    end
    --小公鸡，小生命，小防御
    self.inst.components.health.healthbonus = self.hp
    self.inst.components.combat.atkbonus = self.atk
    self.inst.components.combat.defensebonus = self.def
    --四件套自定义函数触发
    if self.setsfourfn ~= nil then
        self.setsfourfn(self.inst)
    end
    --生命值这边要触发一下

    --[[if Shard_IsWorldAvailable(TheShard:GetShardId()) then
        print(TheShard:GetShardId())
    end
    if self.inst.migration then
        print(self.inst.migration.worldid)
        return
    end]]
    --self.inst.components.health:SetMaxHealthWithPercent()
    self.exist_replica_test = not self.exist_replica_test
end

function ArtifactsCollector:RecalculateModifier()
    --先重置
    self:ResetModifier()
    local flower = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.FLOWER)
    local plume = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.PLUME)
    local sands = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.SANDS)
    local goblet = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.GOBLET)
    local circlet = self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.CIRCLET)

    --计算单件加成
    self:CalculateSingle(flower)
    self:CalculateSingle(plume)
    self:CalculateSingle(sands)
    self:CalculateSingle(goblet)
    self:CalculateSingle(circlet)

    --计算套装加成
    self:CalculateSets({flower, plume, sands, goblet, circlet})

    --执行
    self:AddModifier()
end

--[[
function ArtifactsCollector:upd(dt)
    if self.pre_health < 0 then
        if self.inst.components.health then
            self.pre_health = self.inst.components.health.maxhealth
        end
        print(self.pre_health)
        return
    end

    if self.pre_health ~= self.inst.components.health.maxhealth then
        local delta = self.inst.components.health.maxhealth - self.pre_health
        self.inst.components.health:SetMaxHealthWithPercent(delta + self.inst.components.health.base_health)
        self.pre_health = self.inst.components.health.maxhealth
    end
end

function ArtifactsCollector:OnUpdate(dt)
    if self.wait_update then
        return
    end

    self:upd(dt)
end
]]
return ArtifactsCollector