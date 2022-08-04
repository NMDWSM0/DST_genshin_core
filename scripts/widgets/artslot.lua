local Image = require("widgets/image")
local Text = require("widgets/text")
local Button = require("widgets/button")

local ArtSlot = Class(Button, function(self, atlas, bgim, owner)
    Button._ctor(self, "ArtSlot")
    self.owner = owner
    self.bgimage = self:AddChild(Image(atlas, bgim))
    self.tile = nil

    self.highlight_scale = 1.2
    self.base_scale = 1
    self:SetOnSelect(function() 
        self:SetScale(self.highlight_scale)
    end)
    self:SetOnUnSelect(function() 
        self:SetScale(self.base_scale)
    end)
end)

function ArtSlot:LockHighlight()
    if not self.highlight then
        self:ScaleTo(self.base_scale, self.highlight_scale, .125)
        self.highlight = true
    end
end

function ArtSlot:UnlockHighlight()
    if self.highlight then
        if self.big then
            self:ScaleTo(self.base_scale, self.highlight_scale, .125)
        else
            self:ScaleTo(self.highlight_scale, self.base_scale, .125)
        end
        self.highlight = false
    end
end

function ArtSlot:Highlight()
    if not self.selected and not self.big then
        self:ScaleTo(self.base_scale, self.highlight_scale, .125)
        self.big = true
    end
end

function ArtSlot:DeHighlight()
    if not self.selected and self.big then
        if not self.highlight then
            self:ScaleTo(self.highlight_scale, self.base_scale, .25)
        end
        self.big = false
    end
end

function ArtSlot:OnGainFocus()
    self:Highlight()
end

function ArtSlot:OnLoseFocus()
    self:DeHighlight()
end

function ArtSlot:SetTile(tile)
    if self.tile ~= tile then
        if self.tile ~= nil then
            self.tile = self.tile:Kill()
        end
        if tile ~= nil then
            self.tile = self:AddChild(tile)
            if self.label ~= nil then
                self.label:MoveToFront()
            end
        end
        if self.ontilechangedfn ~= nil then
            self:ontilechangedfn(tile)
        end
    end
end

function ArtSlot:SetOnTileChangedFn(fn)
    self.ontilechangedfn = fn
end

function ArtSlot:SetBGImage2(atlas, img, tint)
    if atlas ~= nil and img ~= nil then
        if self.bgimage2 ~= nil then
            self.bgimage2:SetTexture(atlas, img)
        else
            self.bgimage2 = self:AddChild(Image(atlas, img))
            if self.tile ~= nil then
                self.tile:MoveToFront()
            end
            if self.label ~= nil then
                self.label:MoveToFront()
            end
        end
        if tint ~= nil then
            self.bgimage2:SetTint(unpack(tint))
        end
    elseif self.bgimage2 ~= nil then
        self.bgimage2 = self.bgimage2:Kill()
    end
end

function ArtSlot:SetLabel(msg, colour)
    if msg ~= nil then
        if self.label ~= nil then
            self.label:SetString(msg)
            self.label:SetColour(colour)
        else
            self.label = self:AddChild(Text("genshinfont", 26, msg, colour))
            self.label:SetPosition(3, -36)
        end
    elseif self.label ~= nil then
        self.label = self.label:Kill()
    end
end

return ArtSlot