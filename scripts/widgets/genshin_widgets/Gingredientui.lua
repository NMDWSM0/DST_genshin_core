require "class"

local GWidget = require "widgets/genshin_widgets/Gwidget"
local GText = require "widgets/genshin_widgets/Gtext"
local GImage = require "widgets/genshin_widgets/Gimage"
local GImageButton = require "widgets/genshin_widgets/Gimagebutton"
local GThreeSlice = require "widgets/genshin_widgets/Gthreeslice"

local GIngredientUI = Class(GImageButton, function(self, atlas, image, quantity, on_hand, has_enough, name, owner, recipe_type, quant_text_scale, ingredient_recipe)
    GImageButton._ctor(self, resolvefilepath("images/hud.xml"), has_enough and "inv_slot.tex" or "resource_needed.tex")

    --self:SetClickable(false)

    local crafting_atlas = resolvefilepath("images/crafting_menu.xml")

    --self.bg = self:AddChild(GImage(hud_atlas, has_enough and "inv_slot.tex" or "resource_needed.tex"))

	self:SetFocusScale(1.1)

    self.ing = self.image:AddChild(GImage(atlas, image))

	if recipe_type ~= nil and AllRecipes[recipe_type] then
		self:Enable()
	else
		self:Disable()
	end

    if quantity ~= nil then
        self.quant = self.image:AddChild(GText(SMALLNUMBERFONT, JapaneseOnPS4() and 30 or 24))
        self.quant:SetPosition(7, -32, 0)
		if quant_text_scale ~= nil then
			self.quant:SetScale(quant_text_scale, quant_text_scale)
		end
        if not IsCharacterIngredient(recipe_type) then
            local builder = owner ~= nil and owner.replica.builder or nil
            if builder ~= nil then
                quantity = RoundBiasedUp(quantity * builder:IngredientMod())
            end
            self.quant:SetString(string.format("%d/%d", on_hand, quantity))
        elseif recipe_type == CHARACTER_INGREDIENT.MAX_HEALTH
            or recipe_type == CHARACTER_INGREDIENT.MAX_SANITY then
            self.quant:SetString(string.format("-%2.0f%%", quantity * 100))
        else
            self.quant:SetString(string.format("-%d", quantity))
        end
        if not has_enough then
            self.quant:SetColour(255/255, 155/255, 155/255, 1)
        end
    end

	self.recipe_type = recipe_type
	self.has_enough = has_enough
	self.owner = owner

	local tooltip = name

	local meta = ingredient_recipe ~= nil and ingredient_recipe.meta or nil

	if meta and not has_enough then
		if meta.build_state == "hint" or meta.build_state == "hide" then
			self.fg = self.image:AddChild(GImage(crafting_atlas, "ingredient_lock.tex"))
			self.fg:ScaleToSize(self.ing:GetSize())
			
			--self.ing:SetTint(0.7, 0.7, 0.7, 1)
			--self.image:SetTint(0.7, 0.7, 0.7, 1)
		elseif meta.can_build then
			self.ingredient_recipe = ingredient_recipe

			if meta.build_state == "prototype" then
				self.fg = self.image:AddChild(GImage(crafting_atlas, "ingredient_prototype.tex"))
			    tooltip = tooltip.."\n".. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY)..": "..STRINGS.UI.CRAFTING.PROTOTYPE
			else
				self.fg = self.image:AddChild(GImage(crafting_atlas, "ingredient_craft.tex"))
			    tooltip = tooltip.."\n".. TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_PRIMARY)..": "..(ingredient_recipe.recipe.actionstr ~= nil and STRINGS.UI.CRAFTING.RECIPEACTION[ingredient_recipe.recipe.actionstr] or STRINGS.UI.CRAFTING.BUILD)
			end
			self.fg:ScaleToSize(self.ing:GetSize())

			self.onclick = function()
				if self.ingredient_recipe ~= nil and meta.can_build then
					DoRecipeClick(self.owner, self.ingredient_recipe.recipe, nil)
				end
			end

			self.ongainfocus = function()
				local GCraftingMenuIngredients = require "widgets/genshin_widgets/redux/Gcraftingmenu_ingredients"

				self.sub_ingredients = self.parent:AddChild(GWidget("sub_ingredients"))
				self.sub_ingredients:MoveToBack()
				self.background = self.sub_ingredients:AddChild(GThreeSlice(crafting_atlas, "popup_end.tex", "popup_short.tex"))

				self.ingredients = self.sub_ingredients:AddChild(GCraftingMenuIngredients(self.owner, 4, self.ingredient_recipe.recipe, 1.5))

				self._scale = 1.0

				self.background:ManualFlow(math.min(5, self.ingredients.num_items), true)

				local x = self.background.startcap:GetPositionXYZ()

				self.sub_ingredients:SetPosition(0, -75)
				self.sub_ingredients:SetScale(self._scale)
			end

			self.onlosefocus = function()
				if self.sub_ingredients ~= nil then
					self.sub_ingredients:Kill()
					self.sub_ingredients = nil
				end
			end
		end
	end

	if not self.ingredient_recipe then
		self:Select() -- a disable that blocks focus highlighting
	end

    self:SetTooltip(tooltip)

end)

return GIngredientUI
