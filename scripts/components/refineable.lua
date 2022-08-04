local function oncurrent_level(self, current_level)
    self.inst.replica.refineable._current_level:set(current_level or 1)
end

local function onmax_level(self, max_level)
    self.inst.replica.refineable._max_level:set(max_level or 5)
end

local function oningredient(self, ingredient)
    self.inst.replica.refineable._ingredient:set(ingredient or "")
end

local function onoverrideimage(self, image)
    self.inst.replica.refineable._overrideimage:set(image or "")
end

local function onoverrideatlas(self, atlas)
    self.inst.replica.refineable._overrideatlas:set(atlas or "")
end

local Refineable = Class(function(self, inst)
	self.inst = inst 

    self.current_level = 1
    self.max_level = 5

    --默认是物品本身，但是也有可能是别的，这个可以自己设置
    self.ingredient = self.inst.prefab
    self.overrideimage = self.inst.components.inventoryitem.imagename
    self.overrideatlas = self.inst.components.inventoryitem.atlasname
end,
nil,
{
    current_level = oncurrent_level,
    max_level = onmax_level,
    ingredient = oningredient,
    overrideimage = onoverrideimage,
    overrideatlas = onoverrideatlas,
})

function Refineable:GetCurrentLevel()
    return self.current_level
end

function Refineable:GetMaxLevel()
    return self.max_level
end

function Refineable:GetIngredient()
    return self.ingredient or self.inst.prefab
end

function Refineable:GetImage()
    return self.overrideimage
end

function Refineable:GetAtlas()
    return self.overrideatlas
end

function Refineable:Refine(level)
    self.current_level = math.min(self.current_level + (level or 1), self.max_level)
end

function Refineable:OnSave()
    return 
    {
        current_level = self.current_level
    }
end

function Refineable:OnLoad(data)
    if data and data.current_level then
        self.current_level = data.current_level
    end
end

return Refineable