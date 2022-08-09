
local Refineable = Class(function(self, inst)
	self.inst = inst 

    self._current_level = net_tinybyte(inst.GUID, "refineable._current_level", "refineleveldirty")
    self._max_level = net_tinybyte(inst.GUID, "refineable._max_level", "refineleveldirty")

    self._ingredient = net_string(inst.GUID, "refineable._ingredient", "refineingredientdirty")
    self._overrideimage = net_string(inst.GUID, "refineable._overrideimage", "refineingredientdirty")
    self._overrideatlas = net_string(inst.GUID, "refineable._overrideatlas", "refineingredientdirty")

    self.inst.displaynamefn = function (inst)
        local level = self:GetCurrentLevel()
        local refinetext = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "精炼"..level.."阶" or "Rank "..level
        return STRINGS.NAMES[string.upper(inst.prefab)].." "..refinetext
    end

    self.inst:ListenForEvent("refineleveldirty", function ()
        local lv = math.clamp(self._current_level:value(), 1, 5)
        inst.inv_image_bg = { image = "refinenumber"..lv..".tex" }
        inst.inv_image_bg.atlas = "images/inventoryimages/refinenumber.xml"
    end)
end)

function Refineable:GetCurrentLevel()
    return self._current_level:value()
end

function Refineable:GetMaxLevel()
    return self._max_level:value()
end

function Refineable:GetIngredient()
    return self._ingredient:value() ~= "" and self._ingredient:value() or self.inst.prefab
end

function Refineable:GetImage()
    return self._overrideimage:value()
end

function Refineable:GetAtlas()
    return self._overrideatlas:value()
end

return Refineable