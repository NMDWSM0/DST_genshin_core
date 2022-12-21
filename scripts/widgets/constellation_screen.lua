local Widget = require "widgets/genshin_widgets/Gwidget"
local ConstellationPopup = require "widgets/constellation_popup"
local ConstellationImage = require "widgets/constellation_image"
local ConstellationButton = require "widgets/constellation_button"

local constellation_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
	
    local path = owner.constellation_path or "images/ui/constellation_traveler"
    local positions = owner.constellation_positions
    local lines = path.."/constellation_lines"
    self.path = path
    self.decription = self.owner.constellation_decription or TUNING.DEFAULT_CONSTELLATION_DESC

    self.constellation_image = self:AddChild(ConstellationImage(owner, path.."/constellation_image.xml", "constellation_image.tex", positions, lines))
    self.constellation_image:SetPosition(0, 300, 0)
	self.constellation_image:SetOnClick(function()
	    self:HideConstellation()
	end)

    self.constellation_button1 = self:AddChild(ConstellationButton(path.."/1_disable.xml", "1_disable.tex", self.decription.titlename[1]))
    self.constellation_button1:SetPosition(400, 210, 0)

    self.constellation_button2 = self:AddChild(ConstellationButton(path.."/2_disable.xml", "2_disable.tex", self.decription.titlename[2]))
    self.constellation_button2:SetPosition(445, 133, 0)

    self.constellation_button3 = self:AddChild(ConstellationButton(path.."/3_disable.xml", "3_disable.tex", self.decription.titlename[3]))
    self.constellation_button3:SetPosition(470, 45, 0)

    self.constellation_button4 = self:AddChild(ConstellationButton(path.."/4_disable.xml", "4_disable.tex", self.decription.titlename[4]))
    self.constellation_button4:SetPosition(470, -45, 0)

    self.constellation_button5 = self:AddChild(ConstellationButton(path.."/5_disable.xml", "5_disable.tex", self.decription.titlename[5]))
    self.constellation_button5:SetPosition(445, -133, 0)

    self.constellation_button6 = self:AddChild(ConstellationButton(path.."/6_disable.xml", "6_disable.tex", self.decription.titlename[6]))
    self.constellation_button6:SetPosition(400, -210, 0)
   
    --按钮动作
    self.constellation_button1:SetOnClick(function() self:ShowConstellation(1) end)
    self.constellation_button2:SetOnClick(function() self:ShowConstellation(2) end)
    self.constellation_button3:SetOnClick(function() self:ShowConstellation(3) end)
    self.constellation_button4:SetOnClick(function() self:ShowConstellation(4) end)
    self.constellation_button5:SetOnClick(function() self:ShowConstellation(5) end)
    self.constellation_button6:SetOnClick(function() self:ShowConstellation(6) end)

    ------------------------------------------------------------------------
    --popup弹出
    self.constellation_popup = self:AddChild(ConstellationPopup(self.owner, self, path))
    self.constellation_popup:SetScale(0.8, 0.8, 0.8)
    self.constellation_popup:SetPosition(-540, -20, 0)
    self.constellation_popup:Hide()

-------------------------------------------------------------------------
    self.inst:ListenForEvent("constellationleveldirty", function() 
        local ConstellationComponent = TheWorld.ismastersim and self.owner.components.constellation or self.owner.replica.constellation
        if ConstellationComponent == nil then
            return
        end
        for level = 1, ConstellationComponent:GetActivatedLevel() do
            self:UnlockConstellationClient(level) 
        end
    end, owner)
end)

-----------------------------------------------------------------
--
function constellation_screen:OnShow(was_hidden)
    if was_hidden then
        self.constellation_image:TransitPosition(0, 0, 0, 0.4)
    end
end

function constellation_screen:OnHide(was_visible)
    if was_visible then
        self.constellation_image:TransitPosition(0, 300, 0, 0.4)
    end
end

-----------------------------------------------------------------
--功能

function constellation_screen:ShowPopup(level)
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --显示命之座详细四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
        self.parent.mainclose,
	}
    --显示popup界面
    self.constellation_popup:ShowLevel(level)
    self.constellation_popup:Show()
	--隐藏父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Hide()
	end
end

function constellation_screen:HidePopup()
    local thingsofparents = {
        self.parent.title,
		self.parent.vision,
        --显示命之座详细四个隐藏的东西，标题，神之眼，左侧按钮，关闭按钮
		self.parent.button_attribute,
		self.parent.button_weapons,
		self.parent.button_artifacts,
		self.parent.button_constellation,
		self.parent.button_talents,
		self.parent.button_profile,
        self.parent.mainclose,
	}
	--隐藏popup界面和返回按钮，显示自身除了popup和返回按钮以外的任何东西
    self.constellation_popup:Hide()
	--显示父界面的一些东西
	for k,v in pairs(thingsofparents) do
		v:Show()
	end
end

function constellation_screen:ShowConstellation(level)
    if level < 1 or level > 6 then
        self:HideConstellation()
        return
    end

    local buttons = {
        self.constellation_button1,
        self.constellation_button2,
        self.constellation_button3,
        self.constellation_button4,
        self.constellation_button5,
        self.constellation_button6,
    }

    buttons[level]:Select()
	self:ShowPopup(level)
	for i = 1, 6 do
        if i ~= level then
            buttons[i]:Unselect()
        end
    end

    self.constellation_image:FocusOn(level)
end

function constellation_screen:HideConstellation()
    local buttons = {
        self.constellation_button1,
        self.constellation_button2,
        self.constellation_button3,
        self.constellation_button4,
        self.constellation_button5,
        self.constellation_button6,
    }

	self:HidePopup()
	for i = 1, 6 do
        buttons[i]:Unselect()
    end
    self.constellation_image:FocusOn(0)
end

function constellation_screen:UnlockConstellation(level)
    if level == nil or type(level) ~= "number" or level < 1 or level > 6 then
        return
    end
    --正经操作
    SendModRPCToServer(MOD_RPC["constellation"]["unlock"], level)
end

function constellation_screen:UnlockConstellationClient(level)
    --客户端修改UI，不做正经的
    if level == nil or type(level) ~= "number" or level < 1 or level > 6 then
        return
    end
    --UI操作
    local buttons = {
        self.constellation_button1,
        self.constellation_button2,
        self.constellation_button3,
        self.constellation_button4,
        self.constellation_button5,
        self.constellation_button6,
    }
    buttons[level]:SetTextures(self.path.."/"..string.format("%d", level).."_enable.xml", string.format("%d", level).."_enable.tex", nil, nil, nil, string.format("%d", level).."_enable.tex.tex")
    if buttons[level]:IsSelected() then
        buttons[level]:Unselect()
        buttons[level]:Select()
    end
    self.constellation_image:Unlock(level)
    self.constellation_popup:Refresh()
end

return constellation_screen