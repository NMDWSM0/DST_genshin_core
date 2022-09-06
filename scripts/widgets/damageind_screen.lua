local Widget = require "widgets/widget"
local Text = require "widgets/text"

local PopupNumber = Class(Widget, function(self, font, size, text, color)
	Widget._ctor(self, "PopupNumber")
	self.text = self:AddChild(Text(font, size, text, color))
    self.size = size
    self.t = 0
    self.t_max = TUNING.LABEL_TIME
    self.x_offset = 0
    self.y_offset = 0
    self.color = {}
end)

local damageind_screen = Class(Widget, function(self, owner)
    Widget._ctor(self, nil)
	self.owner = owner
    self.numbers = {}
	
    self.inst:ListenForEvent("UICreateDMGNumber", function(owner, data) self:ShowPopupNumber(data) end, TheWorld)
	self:StartUpdating()
end)

---------------------------------------------------------------------------------------
--------------------------------------Update-------------------------------------------

local function nearothers(x, y, others)
    if others == nil then
        return false
    end
    for i, v in ipairs(others) do
        local this = Vector3(x, y, 0)
        local that = Vector3(others.x_offset, others.y_offset, 0)
        if this:Dist(that) < 40 then
            return true
        end
    end
    return false
end

function damageind_screen:ShowPopupNumber(data)
    --[[print(data.size)
    print(data.text)
    print(data.color.r)
    print(data.color.g)
    print(data.color.b)
    print(data.screenpos.x)
    print(data.screenpos.y)]]
    local yoffset = 120 + (math.random() - 0.5) * 150
    local xoffset = (math.random() - 0.5) * 150

    local retry = 0
    while nearothers(data.screenpos.x + xoffset, data.screenpos.y + yoffset, self.numbers) do
        yoffset = 120 + (math.random() - 0.5) * 150
        xoffset = (math.random() - 0.5) * 150
        retry = retry + 1
        if retry > 5 then
            break
        end
    end

	local popupnumber = self:AddChild(PopupNumber("outline_genshinfont", data.size, data.text, {data.color.r, data.color.g, data.color.b, 0}))
	popupnumber:SetPosition(data.screenpos.x + xoffset, data.screenpos.y + yoffset)
    popupnumber.x_offset = data.screenpos.x + xoffset
    popupnumber.y_offset = data.screenpos.y + yoffset + (data.isnumber and 25 or 0)
    popupnumber.color = data.color
    popupnumber.delayed = false
    table.insert(self.numbers, popupnumber)
end

function damageind_screen:OnUpdate(dt)
    for i,v in ipairs(self.numbers) do
        if v.t > v.t_max then
            v:Kill()
            table.remove(self.numbers, i)
        else
            if i >= 2 then
                if not v.delayed then
                    v.delayed = true
                    v.t = v.t - 0.1 * math.random()
                end
            else
                v.delayed = true
            end
            if v.t < 0 then
                v:Hide()
            else
                v:Show()
                local r = v.t/v.t_max
                local dy = 10 * math.pow(v.t/v.t_max - 1/2, 2)
                local scale = r < 1/3 and 1 + 27 * (r-1/3) ^ 2 or (r > 0.8 and 1 - 5 * (r-0.8) ^ 2 or 1)
		        local alpha = r < 1/8 and 1 - 64 * (r-1/8) ^ 2 or (r > 0.8 and 1 - 25 * (r-0.8) ^ 2 or 1)
                local dark = r < 1/5 and 1 - 25 * (r-1/5) ^ 2 or (r > 0.8 and 1 - 25 * (r-0.8) ^ 2 or 1)

		        v.y_offset = v.y_offset + dy
                v:SetPosition(v.x_offset, v.y_offset)
                v:SetScale(scale)
                v.text:SetColour(v.color.r * dark, v.color.g * dark, v.color.b * dark, alpha * 0.95)
            end
            v.t = v.t + dt
        end
    end
	
end

return damageind_screen