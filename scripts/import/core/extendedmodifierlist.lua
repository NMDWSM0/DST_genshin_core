-- Extend from SourceModifierList, to handle modifiers which have filters
-- 2022/6/27
-- it seems like that using English to comment is more proper😂

--[[filters: supported filters are listed as follows
{
    --attacker
    atk_elements = {},      you can use either number or the string of element
    atk_key = {},           string
    sgstates = {},          string
    --target
    element_attached = {},  you can use either number or the string of element
    custom_fn = function(attacker, target, atk_elements, atk_key)  (return a boolean value)
}
]]

--[[data: this is data you need when you want to check modifiers whether they are valid
{
    attacker,
    target,
    atk_elements,
    atk_key,
}
]]

-------------------------------------------------------------------------------
-- SourceModifierList manages modifiers applied by external sources.
--   Optionally, it will also handle multiple modifiers from the same source,
--   provided a key is passed in for each modifiers
-------------------------------------------------------------------------------

ExtendedModifierList = Class(function(self, inst, base_value, fn)
    self.inst = inst

    -- Private members
    self._modifiers = {}
    if base_value ~= nil then
        self._modifier = base_value
        self._base = base_value
    else
        self._modifier = 1
        self._base = 1
    end

    self._fn = fn or ExtendedModifierList.multiply
end)

ExtendedModifierList.multiply = function(a, b)
	return a * b
end

ExtendedModifierList.additive = function(a, b)
	return a + b
end

ExtendedModifierList.boolean = function(a, b)
    return a or b
end

-------------------------------------------------------------------------------
function ExtendedModifierList:Get()
	return self._modifier
end

-------------------------------------------------------------------------------

function table.contains(t, element)
    if t == nil then
        return false
    end

    if type(t) ~= "table" then
        if t == element then
            return true
        end
        return false
    end

    for k, v in pairs(t) do
        if v == element then
            return true
        end
    end
    return false
end

function table.isequal(a, b)
    if a == nil or b == nil then
        return false
    end
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end
    local _a, _b = 0, 0
    for k, v in pairs(a) do
        if type(v) == "table" then
            if not table.isequal(v, b[k]) then
                return false
            end
        else
            if v ~= b[k] then
                return false
            end
        end
        _a = _a + 1
    end
    for k, v in pairs(b) do
        _b = _b + 1
    end
    return _a == _b
end

local function RecalculateModifier(inst)
    local m = inst._base
    for source, src_params in pairs(inst._modifiers) do
        for k, v in pairs(src_params.modifiers) do
            if v.f == nil then
                m = inst._fn(m, v.v)  --只有没有filter的才可以
            end
        end
    end
    inst._modifier = m
end

local function CheckFilters(filters, data)
    if filters == nil then
        return true
    end

    local name = {"pyro", "cryo", "hydro", "electro", "anemo", "geo", "dendro"}

    if filters.atk_elements ~= nil and (not table.contains(filters.atk_elements, data.atk_elements)) and (not table.contains(filters.atk_elements, name[data.atk_elements])) then
        return false 
    end

    if filters.atk_key ~= nil and not table.contains(filters.atk_key, data.atk_key) then
        return false
    end

    if filters.sgstates ~= nil and (data.attacker == nil or data.attacker.sg == nil) then
        return false
    end
    if filters.sgstates ~= nil and not table.contains(filters.sgstates, data.attacker.sg.currentstate) then
        return false
    end

    if filters.element_attached ~= nil then
        local attached_eles = {}
        if data.target and data.target.components.elementreactor then
            for i = 1, 7 do
                if data.target.components.elementreactor.element_stack[i].value > 0 then
                    table.insert(attached_eles, i)
                end
            end
        end
        if data.target.components.freezable and data.target.components.freezable:IsFrozen() then
            table.insert(attached_eles, 2)
        end
        local have = false
        for k, ele in pairs(attached_eles) do
            if table.contains(filters.element_attached, ele) or table.contains(filters.element_attached, name[ele]) then
                have = true
            end
        end
        if have == false then
            return false
        end
    end

    if filters.custom_fn ~= nil and not filters.custom_fn(data.attacker, data.target, data.atk_elements, data.atk_key) then
        return false
    end

    return true
end

-------------------------------------------------------------------------------
-- Source can be an object or a name. If it is an object, then it will handle
--   removing the multiplier if the object is forcefully removed from the game.
-- Key is optional if you are only going to have one multiplier from a source.
function ExtendedModifierList:SetModifier(source, m, key, filters)
	if source == nil then
		return
	end

    if key == nil then
        key = "key"
    end

    if m == nil or m == self._base then
        self:RemoveModifier(source, key)
        return
    end

    local src_params = self._modifiers[source]
    local modi = { f = filters, v = m }
    if src_params == nil then
        self._modifiers[source] = {
            modifiers = { [key] = modi },
        }

        -- If the source is an object, then add a onremove event listener to cleanup if source is removed from the game
        if type(source) == "table" then
            self._modifiers[source].onremove = function(source)
                self._modifiers[source] = nil
                RecalculateModifier(self)
            end

            self.inst:ListenForEvent("onremove", self._modifiers[source].onremove, source)
        end

        RecalculateModifier(self)
    elseif src_params.modifiers[key] ~= modi then
        src_params.modifiers[key] = modi
        RecalculateModifier(self)
    end
end

-------------------------------------------------------------------------------
-- Key is optional if you want to remove the entire source
function ExtendedModifierList:RemoveModifier(source, key)
    local src_params = self._modifiers[source]
    if src_params == nil then
        return
    elseif key ~= nil then
        src_params.modifiers[key] = nil
        if next(src_params.modifiers) ~= nil then
            --this source still has other keys
			RecalculateModifier(self)
            return
        end
    end

    --remove the entire source
    if src_params.onremove ~= nil then
        self.inst:RemoveEventCallback("onremove", src_params.onremove, source)
    end
    self._modifiers[source] = nil
    RecalculateModifier(self)
end

-------------------------------------------------------------------------------
-- Key is optional if you want to calculate the entire source
function ExtendedModifierList:CalculateModifierFromSource(source, key, data)
    local src_params = self._modifiers[source]
    if src_params == nil then
        return self._base
    elseif key == nil then
        local m = self._base
        for k, v in pairs(src_params.modifiers) do
            if CheckFilters(v.f, data) then
                m = self._fn(m, v.v)
            end
        end
        return m
    end
    return src_params.modifiers[key] or self._base
end

-------------------------------------------------------------------------------
--
function ExtendedModifierList:CalculateModifierFromKey(key, data)
    local m = self._base
    for source, src_params in pairs(self._modifiers) do
        for k, v in pairs(src_params.modifiers) do
			if k == key then
	            if CheckFilters(v.f, data) then
                    m = self._fn(m, v.v)
                end
	        end
        end
    end
    return m
end

-------------------------------------------------------------------------------
--
function ExtendedModifierList:CalculateModifierFromFilter(data)
    local m = self._base
    for source, src_params in pairs(self._modifiers) do
        for k, v in pairs(src_params.modifiers) do
	        if CheckFilters(v.f, data) then
                m = self._fn(m, v.v)
            end
        end
    end
    return m
end

-------------------------------------------------------------------------------
return ExtendedModifierList

