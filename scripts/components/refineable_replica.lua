
local Refineable = Class(function(self, inst)
	self.inst = inst 

    self._current_level = net_tinybyte(inst.GUID, "refineable._current_level", "refineleveldirty")
    self._max_level = net_tinybyte(inst.GUID, "refineable._max_level", "refineleveldirty")

    self._ingredient = net_string(inst.GUID, "refineable._ingredient", "refineingredientdirty")
    self._overrideimage = net_string(inst.GUID, "refineable._overrideimage", "refineingredientdirty")
    self._overrideatlas = net_string(inst.GUID, "refineable._overrideatlas", "refineingredientdirty")
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