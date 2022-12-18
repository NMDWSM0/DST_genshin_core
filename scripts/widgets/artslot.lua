local Text = require "widgets/genshin_widgets/Gtext"
local Image = require "widgets/genshin_widgets/Gimage"
local Button = require "widgets/genshin_widgets/Gbutton"

local function fillparams(table, default)
    if table == nil or type(table) ~= "table" then
        return default
    end
    for k, v in pairs(default) do
        if table[k] == nil then
            table[k] = v
        end
    end
    return table
end

local minimapatlas_lut = {}
local function GetMiniMapAtlas(imagename, no_fallback)
    local atlas = minimapatlas_lut[imagename]
    if atlas ~= nil then
        return atlas
    end

    local minimapatlases = {resolvefilepath("minimap/minimap_data.xml")}
    for _, atlases in ipairs(ModManager:GetPostInitData("MinimapAtlases")) do
        for _, path in ipairs(atlases) do
            table.insert(minimapatlases, resolvefilepath(path))
        end
    end

    for k, v in pairs(minimapatlases) do
        if TheSim:AtlasContains(v, imagename) then
            atlas = v
        end
    end
    if not no_fallback and atlas == nil then
        atlas = minimapatlases[1]
    end

	if atlas ~= nil then
		minimapatlas_lut[imagename] = atlas
	end
    
	return atlas
end

local default_posinfo = {tile_scale = 1, tile_x = 0, tile_y = 0, lock_x = -36, lock_y = 46, owner_x = 38, owner_y = 44}
local ArtSlot = Class(Button, function(self, owner, atlas, bgim, posinfo, highlight_image)
    Button._ctor(self, "ArtSlot")
    self.owner = owner
    self.posinfo = fillparams(posinfo, default_posinfo)
    self.bgimage = self:AddChild(Image(atlas, bgim))
    self.atlas = atlas
    self.bgim = bgim
    self.hlim = highlight_image or bgim
    self.tile = nil

    self.lockicon = self:AddChild(Image("images/ui/art_lock.xml", "art_lock.tex"))
    self.lockicon:SetPosition(self.posinfo.lock_x, self.posinfo.lock_y)
    
    local mapicon_tex = self.owner.prefab..".tex"
    local mapicon_atlas = GetMiniMapAtlas(mapicon_tex, true)
    if mapicon_atlas == nil then
        mapicon_tex = self.owner.prefab..".png"
        mapicon_atlas = GetMiniMapAtlas(mapicon_tex)
    end
    if mapicon_atlas == nil then
        mapicon_tex = "mod.tex"
        mapicon_atlas = "images/saveslot_portraits.xml"
    end

    self.ownericon = self:AddChild(Image(mapicon_atlas, mapicon_tex))
    self.ownericon:SetScale(0.5)
    self.ownericon:SetPosition(self.posinfo.owner_x, self.posinfo.owner_y)
    self.lockicon:Hide(-1)
    self.ownericon:Hide(-1)

    self.highlight_scale = 1.05
    self.base_scale = 1
    self:SetOnSelect(function() 
        self:SetScale(self.highlight_scale)
        self.big = true
        self.bgimage:SetTexture(self.atlas, self.hlim)
    end)
    self:SetOnUnSelect(function() 
        self:DeHighlight()
    end)
end)

function ArtSlot:LockHighlight()
    if not self.highlight then
        self:ScaleTo(self.base_scale, self.highlight_scale, .25)
        self.highlight = true
    end
end

function ArtSlot:UnlockHighlight()
    if self.highlight then
        if self.big then
            self:ScaleTo(self.base_scale, self.highlight_scale, .25)
        else
            self:ScaleTo(self.highlight_scale, self.base_scale, .25)
        end
        self.highlight = false
    end
end

function ArtSlot:Highlight()
    if not self.selected and not self.big then
        self:ScaleTo(self.base_scale, self.highlight_scale, .25)
        self.big = true
        self.bgimage:SetTexture(self.atlas, self.hlim)
    end
end

function ArtSlot:DeHighlight()
    if not self.selected and self.big then
        if not self.highlight then
            self:ScaleTo(self.highlight_scale, self.base_scale, .15)
        end
        self.big = false
        self.bgimage:SetTexture(self.atlas, self.bgim)
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
            self.tile:SetScale(self.posinfo.tile_scale)
            self.tile:SetPosition(self.posinfo.tile_x, self.posinfo.tile_y, 0)
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