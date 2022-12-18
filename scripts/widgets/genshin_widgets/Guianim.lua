local GWidget = require "widgets/genshin_widgets/Gwidget"

local GUIAnim = Class(GWidget, function(self)
    GWidget._ctor(self, "UIAnim")
    self.inst.entity:AddAnimState()
end)

function GUIAnim:GetAnimState()
    return self.inst.AnimState
end

function GUIAnim:SetFacing(dir)
	self.inst.UITransform:SetFacing(dir)
end

function GUIAnim:DebugDraw_AddSection(dbui, panel)
    GUIAnim._base.DebugDraw_AddSection(self, dbui, panel)

    dbui.Spacing()
    dbui.Text("UIAnim")
    dbui.Indent() do
        local animstate = self:GetAnimState()
        if animstate then
            dbui.Value("AnimDone", animstate:AnimDone())
            dbui.Value("CurrentFacing", animstate:GetCurrentFacing())
            dbui.ValueColor("AddColour", animstate:GetAddColour())
            dbui.ValueColor("MultColour", animstate:GetMultColour())
            dbui.Value("CurrentAnimationTime", animstate:GetCurrentAnimationTime(), "%.3f")
            if dbui.TreeNode("Might crash") then
                -- If the underlying animation is null, then
                -- GetCurrentAnimationLength will assert. Should be safe to
                -- expand if AnimDone == true, but that's not very helpful.
                dbui.Value("CurrentAnimationLength", animstate:GetCurrentAnimationLength(), "%.3f")
                dbui.TreePop()
            end
        end
    end
    dbui.Unindent()
end

-- UIAnim 特有的 SetTint
function GUIAnim:SetTint(r, g, b, a, stop_transit, ignore_children)
    GWidget.SetTint(self, r, g, b, a, stop_transit, ignore_children)  --GWidget.SetTint
    self.inst.AnimState:SetMultColour(self:GetTint())  --注意ParentTint
end

return GUIAnim