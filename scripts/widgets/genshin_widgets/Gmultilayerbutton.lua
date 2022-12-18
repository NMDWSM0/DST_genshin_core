local GButton = require "widgets/genshin_widgets/Gbutton"
local GImage = require "widgets/genshin_widgets/Gimage"
require "widgets/genshin_widgets/Gbtnpresets"
----------------------------------------------------------------
-- GMultiLayerButton 旨在解决多层按钮渐变动画
-- 使用切换Texture的方式并不能解决所有的切换动画，只有透明度和文字颜色可以渐变
-- 虽然大多数情况这个问题确实被解决了，但是我们仍然需要一种方式，解决那些复杂的按钮动画
-- 比如border渐变，我们将border放在另一个图层，比如在原图底部；在focus时将border图片渐变出现+放大
-- GMultiLayerButton 在每一层都支持同时设置多个属性，可以结合使用position，scale，tint
-- 你也可以在饥荒中实现原神那样的带动效的按钮
----------------------------------------------------------------

local GMultiLayerButton = Class(GButton, function(self, layers)
    GButton._ctor(self, "MultiLayerButton")

    self.images = {}
    self.layers = layers or GetDefaultGButtonConfig("light", "medium", "ok")
    self.showtext = false
    self:InitLayers()

    self.focus_sound = nil

    -- self.image:SetTexture(self.atlas, self.image_normal)
end)

function GMultiLayerButton:InitLayers()
    -- 遍历所有层次，依次添加
    for k, v in pairs(self.layers) do
        if v.type == "image" then
            local image = self:AddChild(GImage(v.textures.atlas, v.textures.normal))
            table.insert(self.images, image)
        elseif v.type == "text" then
            self.showtext = true
        end
    end
    --反向遍历self.images，放置于底部
    for i = (#self.images), 1, -1 do
        self.images[i]:MoveToBack()
    end
    if self.showtext then  --为_base层设置文字颜色参数，下层自动设置颜色，不需要我在上层再设置
        local text_index = #self.layers
        self:SetTextColour(self.layers[text_index].colors.normal)
        self:SetTextFocusColour(self.layers[text_index].colors.focus)
        self:SetTextDownColour(self.layers[text_index].colors.down)
        self:SetTextSelectedColour(self.layers[text_index].colors.selected)
        self:SetTextDisabledColour(self.layers[text_index].colors.disable)
    end
    --刷新当前状态
    self:_RefreshImageState()
end

function GMultiLayerButton:_RefreshImageState()
    if self:IsSelected() then
        self:OnSelect(true)
    elseif self:IsEnabled() then
        if self.focus then
            self:OnGainFocus(true)
        else
            self:OnLoseFocus(true)
        end
    else
        self:OnDisable(true)
    end
end

function GMultiLayerButton:OnGainFocus(noanim)
	GMultiLayerButton._base.OnGainFocus(self, noanim)
    if self:IsSelected() then return end
    --按钮状态改变为为focus
    if noanim then
        --无动画，用作初始化
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self:IsEnabled() and self.layers[i].textures.change then
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.focus)
            end
            image:SetPosition(ToVector3(self.layers[i].position.focus), nil, nil, true)
            image:SetScale(self.layers[i].scale.focus, nil, nil, true)
            image:SetTint(self.layers[i].tint.focus, nil, nil, nil, true)
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.focus)
            self.text:SetPosition(ToVector3(self.layers[text_index].position.focus), nil, nil, true)
        end
    else
        --有动画
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self:IsEnabled() and self.layers[i].textures.change then
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.focus)
            end
            image:TransitPosition(unpack(self.layers[i].position.focus))
            image:TransitScale(unpack(self.layers[i].scale.focus))
            image:TransitTint(unpack(self.layers[i].tint.focus))
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.focus)
            self.text:TransitPosition(unpack(self.layers[text_index].position.focus))
        end
    end
    --声音
    if self.focus_sound then
        TheFrontEnd:GetSound():PlaySound(self.focus_sound)
    end
end

function GMultiLayerButton:OnLoseFocus(noanim)
	GMultiLayerButton._base.OnLoseFocus(self, noanim)
    if self:IsSelected() then return end
    --按钮状态改变为为normal
    if noanim then
        --无动画，用作初始化
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self:IsEnabled() and self.layers[i].textures.change then
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.normal)
            end
            image:SetPosition(ToVector3(self.layers[i].position.normal), nil, nil, true)
            image:SetScale(self.layers[i].scale.normal, nil, nil, true)
            image:SetTint(self.layers[i].tint.normal, nil, nil, nil, true)
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.normal)
            self.text:SetPosition(ToVector3(self.layers[text_index].position.normal), nil, nil, true)
        end
    else
        --有动画
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self:IsEnabled() and self.layers[i].textures.change then
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.normal)
            end
            image:TransitPosition(unpack(self.layers[i].position.normal))
            image:TransitScale(unpack(self.layers[i].scale.normal))
            image:TransitTint(unpack(self.layers[i].tint.normal))
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.normal)
            self.text:TransitPosition(unpack(self.layers[text_index].position.normal))
        end
    end
end

function GMultiLayerButton:OnControl(control, down)
    --此函数不依赖下层OnControl，因此文字颜色需要自己写变化过程
    if not self:IsEnabled() or not self.focus then return end

	if self:IsSelected() and not self.AllowOnControlWhenSelected then return false end

	if control == self.control and (not self.mouseonly or TheFrontEnd.isprimary) then
        if down then
            if not self.down then
                --状态改变为down，一定有动画
                for i = 1, (#self.images) do
                    local image = self.images[i]
                    if self:IsEnabled() and self.layers[i].textures.change then
                        image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.down)
                    end
                    image:TransitPosition(unpack(self.layers[i].position.down))
                    image:TransitScale(unpack(self.layers[i].scale.down))
                    image:TransitTint(unpack(self.layers[i].tint.down))
                end
                if self.showtext then  --如果显示文字，那么position和size还有colour都需要设置
                    local text_index = #self.layers
                    self.text:SetSize(self.layers[text_index].sizes.down)
                    self.text:TransitPosition(unpack(self.layers[text_index].position.down))
                    self.text:TransitColour(unpack(self.layers[text_index].colors.down))
                end
                --声音
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                --整体位移
                self.o_pos = self:GetLocalPosition()
                if self.move_on_click then
                    self:TransitPosition(self.o_pos + self.clickoffset, nil, nil, 0.1)
                end
                self.down = true
                if self.whiledown then
                    self:StartUpdating()
                end
                if self.ondown then
                    self.ondown()
                end
            end
        else
            if self.down then
                --状态改变为focus，一定有动画
                for i = 1, (#self.images) do
                    local image = self.images[i]
                    if self:IsEnabled() and self.layers[i].textures.change then
                        image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.focus)
                    end
                    image:TransitPosition(unpack(self.layers[i].position.focus))
                    image:TransitScale(unpack(self.layers[i].scale.focus))
                    image:TransitTint(unpack(self.layers[i].tint.focus))
                end
                if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
                    local text_index = #self.layers
                    self.text:SetSize(self.layers[text_index].sizes.focus)
                    self.text:TransitPosition(unpack(self.layers[text_index].position.focus))
                    self.text:TransitColour(unpack(self.layers[text_index].colors.focus))
                end
                --取消整体位移
                self.down = false
                self:ResetPreClickPosition()
                if self.onclick then
                    self.onclick()
                end
                self:StopUpdating()
            end
        end
        return true
    end
end

function GMultiLayerButton:OnEnable(noanim)
	GMultiLayerButton._base.OnEnable(self, noanim)
    if self.focus then
        self:OnGainFocus(noanim)
    else
        self:OnLoseFocus(noanim)
    end
end

function GMultiLayerButton:OnDisable(noanim)
	GMultiLayerButton._base.OnDisable(self, noanim)
	--状态改变为disable
    if noanim then
        --无动画，用作初始化
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self.layers[i].textures.change then  --此处不需要判断是否Enable，因为本来就已经disable了
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.disable)
            end
            image:SetPosition(ToVector3(self.layers[i].position.disable), nil, nil, true)
            image:SetScale(self.layers[i].scale.disable, nil, nil, true)
            image:SetTint(self.layers[i].tint.disable, nil, nil, nil, true)
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.disable)
            self.text:SetPosition(ToVector3(self.layers[text_index].position.disable), nil, nil, true)
        end
    else
        --有动画
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self.layers[i].textures.change then  --此处不需要判断是否Enable，因为本来就已经disable了
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.disable)
            end
            image:TransitPosition(unpack(self.layers[i].position.disable))
            image:TransitScale(unpack(self.layers[i].scale.disable))
            image:TransitTint(unpack(self.layers[i].tint.disable))
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.disable)
            self.text:TransitPosition(unpack(self.layers[text_index].position.disable))
        end
    end
end

function GMultiLayerButton:OnSelect(noanim)
    GMultiLayerButton._base.OnSelect(self, noanim)
    --状态变化为selected
	if noanim then
        --无动画，用作初始化
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self.layers[i].textures.change then  --此处不需要判断是否Enable，因为Select级别更高？？（饥荒这么设计的）
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.selected)
            end
            image:SetPosition(ToVector3(self.layers[i].position.selected), nil, nil, true)
            image:SetScale(self.layers[i].scale.selected, nil, nil, true)
            image:SetTint(self.layers[i].tint.selected, nil, nil, nil, true)
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.selected)
            self.text:SetPosition(ToVector3(self.layers[text_index].position.selected), nil, nil, true)
        end
    else
        --有动画
        for i = 1, (#self.images) do
            local image = self.images[i]
            if self.layers[i].textures.change then  --此处不需要判断是否Enable，因为Select级别更高？？（饥荒这么设计的）
                image:SetTexture(self.layers[i].textures.atlas, self.layers[i].textures.selected)
            end
            image:TransitPosition(unpack(self.layers[i].position.selected))
            image:TransitScale(unpack(self.layers[i].scale.selected))
            image:TransitTint(unpack(self.layers[i].tint.selected))
        end
        if self.showtext then  --如果显示文字，那么position和size还需要设置，不过colour已经设置过了
            local text_index = #self.layers
            self.text:SetSize(self.layers[text_index].sizes.selected)
            self.text:TransitPosition(unpack(self.layers[text_index].position.selected))
        end
    end
end

function GMultiLayerButton:OnUnselect(noanim)
    GMultiLayerButton._base.OnUnselect(self, noanim)
    if self:IsEnabled() then
        self:OnEnable(noanim)
    else
        self:OnDisable(noanim)
    end
end

--以列表形式返回所有size
function GMultiLayerButton:GetSizes()
    local sizes = {}
    for k, v in pairs(self.images) do
        table.insert(sizes, v:GetSize())
    end
    return sizes
end

--以顺序形式返回size，要几个接几个
function GMultiLayerButton:GetSize()
    return unpack(self:GetSizes())
end

-- 中间那一些函数不需要
-- 我这里的按钮不需要中途更改这些参数
-- 如果都支持了中途该参数，那需要改的太多了，不止colour，还有scale，tint和position都中途改
-- 太多了，写都写不下

function GMultiLayerButton:SetFocusSound(sound)
    self.focus_sound = sound
end

return GMultiLayerButton