local PropertyMain = require "widgets/property_main"
local ImageButton = require "widgets/imagebutton"
local damageind_screen = require "widgets/damageind_screen"

--------------------------------------------------------------------------
--添加自定义UI

AddClassPostConstruct("widgets/controls",function(self)        
	if self.owner and self.owner:HasTag("player") then
	    self.openproperty = self:AddChild(ImageButton("images/ui/button_on.xml","button_on.tex"))
		self.openproperty:SetPosition(100,100,0)
	    self.openproperty:SetScale(1,1,1)
		self.openproperty.focus_scale = {1.1,1.1,1.1}
	    self.openproperty:SetOnClick(function()
			SendModRPCToServer(MOD_RPC["combatdata"]["combat"])
			if self.property_main.shown then
				if TUNING.CONTROLWITHUI then
					self.property_main:Hide()
				else
				    TheFrontEnd:PopScreen(self.property_main)
				end
				--self.property_main:Hide()
				--print(TheFrontEnd:GetActiveScreen().name)
			else
				if TUNING.CONTROLWITHUI then
					self.property_main:Show()
				else
				    TheFrontEnd:PushScreen(self.property_main)
				end
				--self.property_main:SetPosition(155 + 800 * TUNING.GENSHINCORE_UISCALE, 120 + 400 * TUNING.GENSHINCORE_UISCALE, 0)
				--self.property_main:SetScale(TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE)
				--self.property_main:Show()
				--print(TheFrontEnd:GetActiveScreen().name)
			end
	    end)

        if TUNING.DMGIND_ENABLE then
			self.Dmgind_Screen = self:AddChild(damageind_screen(self.owner))
			self.Dmgind_Screen:MoveToFront()
		end

	    --self.property_main = self:AddChild(PropertyMain(self.owner))
		self.property_main = PropertyMain(self.owner)
		if TUNING.CONTROLWITHUI then
			self:AddChild(self.property_main)
			self.property_main:SetPosition(155 + 800 * TUNING.GENSHINCORE_UISCALE, 120 + 400 * TUNING.GENSHINCORE_UISCALE, 0)
			self.property_main:SetScale(TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE)
		end
		--self.property_main:SetPosition(155 + 800 * TUNING.GENSHINCORE_UISCALE, 120 + 400 * TUNING.GENSHINCORE_UISCALE, 0)
		--self.property_main:SetScale(TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE, TUNING.GENSHINCORE_UISCALE)
		self.property_main:MoveToFront()
		self.property_main:Hide()

	end
end)