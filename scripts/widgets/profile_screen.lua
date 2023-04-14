local Widget = require "widgets/genshin_widgets/Gwidget"
local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local ScrollArea = require "widgets/scrollarea"

local profile_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, "profile_screen")
	self.owner = owner

    --需要更新的数据列表：
    self.update_list = {}

    -- 右侧资料显示区
    self.detail_list = self:AddChild(ScrollArea(450, 620, 1100))
    self.detail_list:SetPosition(480, -10, 0)
    
    -- 默认会包括人物的一点基本信息，以及人物写在"inst.profile_screen_show"列表中的信息
    -- 姓名
    local name = STRINGS.CHARACTER_NAMES[self.owner.prefab] or self.owner.prefab
	self.playername = Text("genshinfont", 42, name, {246/255, 242/255, 238/255, 1})
    self.detail_list:AddItem(self.playername)
	self.playername:SetHAlign(ANCHOR_LEFT)
    self.playername:SetVAlign(ANCHOR_MIDDLE)
    self.playername:SetRegionSize(400, 60)
    self.playername:EnableWordWrap(true)
	self.playername:SetPosition(20, -25, 0)
    -- 生日
    self.birthday_title = Text("genshinfont", 28, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "生日" or "Birthday", {246/255, 242/255, 238/255, 1})
    self.detail_list:AddItem(self.birthday_title)
	self.birthday_title:SetHAlign(ANCHOR_LEFT)
    self.birthday_title:SetVAlign(ANCHOR_MIDDLE)
    self.birthday_title:SetRegionSize(400, 60)
    self.birthday_title:EnableWordWrap(true)
	self.birthday_title:SetPosition(20, -80, 0)
    local birthday_str = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "未知" or "Unknown"
    if STRINGS.CHARACTER_BIOS[self.owner.prefab] ~= nil then
        birthday_str = STRINGS.CHARACTER_BIOS[self.owner.prefab][1].desc or (TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "未知" or "Unknown")
    end
    self.birthday_value = Text("genshinfont", 28, birthday_str, {246/255, 242/255, 238/255, 1})
    self.detail_list:AddItem(self.birthday_value)
	self.birthday_value:SetHAlign(ANCHOR_RIGHT)
    self.birthday_value:SetVAlign(ANCHOR_MIDDLE)
    self.birthday_value:SetRegionSize(400, 60)
    self.birthday_value:EnableWordWrap(true)
	self.birthday_value:SetPosition(-20, -80, 0)
    -- 最喜爱食物
    self.favfood_bar = Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex")
    self.detail_list:AddItem(self.favfood_bar)
	self.favfood_bar:SetPosition(-10, -120, 0)
	self.favfood_bar:SetScale(0.8,0.8,0.8)
    self.favfood_title = Text("genshinfont", 28, TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "最喜爱食物" or "Favorite Food", {246/255, 242/255, 238/255, 1})
    self.detail_list:AddItem(self.favfood_title)
	self.favfood_title:SetHAlign(ANCHOR_LEFT)
    self.favfood_title:SetVAlign(ANCHOR_MIDDLE)
    self.favfood_title:SetRegionSize(400, 60)
    self.favfood_title:EnableWordWrap(true)
	self.favfood_title:SetPosition(20, -120, 0)
    local favfood_str = TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "未知" or "Unknown"
    if STRINGS.CHARACTER_BIOS[self.owner.prefab] ~= nil and STRINGS.CHARACTER_BIOS[self.owner.prefab][2] ~= nil then
        favfood_str = STRINGS.CHARACTER_BIOS[self.owner.prefab][2].desc or (TUNING.LANGUAGE_GENSHIN_CORE == "sc" and "未知" or "Unknown")
    end
    self.favfood_value = Text("genshinfont", 28, favfood_str, {246/255, 242/255, 238/255, 1})
    self.detail_list:AddItem(self.favfood_value)
	self.favfood_value:SetHAlign(ANCHOR_RIGHT)
    self.favfood_value:SetVAlign(ANCHOR_MIDDLE)
    self.favfood_value:SetRegionSize(400, 60)
    self.favfood_value:EnableWordWrap(true)
	self.favfood_value:SetPosition(-20, -120, 0)

    if self.owner.genshin_profile_addition == nil then
        self.detail_list:UpdateContentHeight()
        self:StartUpdating()
        return
    end

    local i = 0
    for k, v in pairs(self.owner.genshin_profile_addition) do
        i = i + 1
        local y = -120 - 40 * i
        
        if i % 2 == 0 then
            local bar = Image("images/ui/textbar_gradients.xml", "textbar_gradients.tex")
            self.detail_list:AddItem(bar)
	        bar:SetPosition(-10, y, 0)
	        bar:SetScale(0.8,0.8,0.8)
        end

        local ttlwid = self.detail_list:AddItem(Text("genshinfont", 28, v.title, {1, 1, 1, 1}))
        ttlwid:SetPosition(20, y, 0)
        ttlwid:SetHAlign(ANCHOR_LEFT)
        ttlwid:SetVAlign(ANCHOR_MIDDLE)
        ttlwid:SetRegionSize(400, 60)
        ttlwid:EnableWordWrap(true)

        local valwid = self.detail_list:AddItem(Text("genshinfont", 28, v.desc, {1, 1, 1, 1}))
        valwid:SetPosition(-20, y, 0)
        valwid:SetHAlign(ANCHOR_RIGHT)
        valwid:SetVAlign(ANCHOR_MIDDLE)
        valwid:SetRegionSize(400, 60)
        valwid:EnableWordWrap(true)

        if v.update_fn ~= nil then
            table.insert(self.update_list, {
                widget = valwid,
                fn = v.update_fn,
                format = v.format_fn
            })
        end
    end

    self.detail_list:UpdateContentHeight()
    self:StartUpdating()
end)

function profile_screen:OnUpdate(dt)
    if not self.shown or not self.parent.shown then
        return
    end
    -- 更新
    for k, v in pairs(self.update_list) do
        local str = ""
        if v.fn ~= nil then
            if v.format ~= nil then
                str = v.format(v.fn(self.owner))
            else
                str = tostring(v.fn(self.owner))
            end
        end
        v.widget:SetString(str)
    end
end

return profile_screen