local assets =
{
	Asset("IMAGES", "images/null.tex"),
	Asset("ATLAS", "images/null.xml"),

	Asset("IMAGES", "images/pyro.tex"),
	Asset("ATLAS", "images/pyro.xml"),

	Asset("IMAGES", "images/cryo.tex"),
	Asset("ATLAS", "images/cryo.xml"),

	Asset("IMAGES", "images/hydro.tex"),
	Asset("ATLAS", "images/hydro.xml"),

	Asset("IMAGES", "images/electro.tex"),
	Asset("ATLAS", "images/electro.xml"),

	Asset("IMAGES", "images/anemo.tex"),
	Asset("ATLAS", "images/anemo.xml"),

	Asset("IMAGES", "images/geo.tex"),
	Asset("ATLAS", "images/geo.xml"),

	Asset("IMAGES", "images/dendro.tex"),
	Asset("ATLAS", "images/dendro.xml"),

	Asset("IMAGES", "images/frozen.tex"),
	Asset("ATLAS", "images/frozen.xml"),
}

local prefabs =
{

}

local anims = 
{
	"pyro",
	"cryo",
	"hydro",
	"electro",
	"anemo",
	"geo",
	"dendro",
	"frozen",
}

local function YOFFSET(target)
    if target == nil then
	    return 6
	end
    if target.prefab == "krampus" then 
	    return 4.25
	elseif target.prefab == "babybeefalo" then
	    return 2.7
	elseif target.prefab == "beeguard" then
	    return 2.5
	elseif target.prefab == "teenbird" then
	    return 4.1
    elseif target:HasTag("player") then
	    return 3.1
	elseif target:HasTag("koalefant") then
	    return 4.5
	elseif target:HasTag("glommer") then
	    return 3.4
	elseif target:HasTag("deer") then
	    return 3.6
	elseif target:HasTag("eyeturret") then
	    return 5
	elseif target:HasTag("beefalo") then
	    return 4.25
	elseif target:HasTag("nightmarecreature") then
	    return 4
	elseif target:HasTag("bishop") then
	    return 4.5
	elseif target:HasTag("rook") then
	    return 4.5
	elseif target:HasTag("knight") then
	    return 3.5
	elseif target:HasTag("bat") then
	    return 3.5
	elseif target:HasTag("minotaur") then
	    return 5
	elseif target:HasTag("ghost") then
	    return 4
	elseif target:HasTag("tallbird") then
	    return 5.5
	elseif target:HasTag("chester") then
	    return 2
	elseif target:HasTag("largecreature") then
	    return 7.7
	elseif target:HasTag("insect") then
	    return 2.1
	elseif target:HasTag("smallcreature") then
	    return 2
    else
	    return 5
	end
end

local function CreateAnim(number)
    local inst = CreateEntity("anim"..number)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    
    inst.entity:AddTransform()
	--inst.entity:AddNetwork()
	inst.entity:AddImage()

	inst.y_offset = 6

	inst.Image:SetTexture(resolvefilepath("images/null.xml"), "null.tex")
    inst.Image:SetWorldOffset(0, inst.y_offset, 0)

	inst.persists = false

    return inst
end

local function targetupdatefunc(target)
	local element1 = 0
	local element2 = 0
	for i = 1, 7 do
		if target.components.elementreactor.element_stack[i].value > 0 then
			if element1 == 0 then
				element1 = i
			elseif element2 == 0 then
				element2 = i
			end
		end
	end
	local element1_value = element1 > 0 and target.components.elementreactor.element_stack[element1].value or 0
	local element2_value = element2 > 0 and target.components.elementreactor.element_stack[element2].value or 0
	--显示图标为冻元素
	if target.components.freezable and target.components.freezable:IsFrozen() then
		if element1 == 2 or element1 == 3 then
			element1 = 8
		elseif element2 == 2 or element2 == 3 then
			element2 = 8
		elseif element1 == 0 and element2 == 0 then
			element1 = 8
		end
	end

	target.components.elementreactor.indicator:PushEvent("element_updated", {element1 = element1, element2 = element2, element1_value = element1_value, element2_value = element2_value})
end

local function SetTrackingTarget(inst, target)
	if inst.anim1 == nil then
        inst.anim1 = CreateAnim(1)
	    inst.anim1.entity:SetParent(inst.entity)
	end
	if inst.anim2 == nil then
	    inst.anim2 = CreateAnim(2)
	    inst.anim2.entity:SetParent(inst.entity)
	end
	if target ~= nil then
	    inst.entity:SetParent(target.entity)
		inst.anim1.y_offset = YOFFSET(target)
		inst.anim2.y_offset = YOFFSET(target)
		inst.anim1.Image:SetWorldOffset(0, inst.anim1.y_offset, 0)
		inst.anim2.Image:SetWorldOffset(0, inst.anim2.y_offset, 0)
	end

	if not TheWorld.ismastersim then
	    return 
	end

	if target == nil then
		return
	end
	inst.target = target
	inst._target:set(target)

    inst.components.entitytracker:TrackEntity("owner", target)
	target:ListenForEvent("element_updated", targetupdatefunc)
	target:ListenForEvent("unfreeze", targetupdatefunc)
end

local function updateanimation(inst)
    --inst.Label:SetText(inst.element1..":  "..inst.element1_value.."\n"..inst.element2..": "..inst.element2_value)

	if inst.anim1 == nil or inst.anim2 == nil then
	    SetTrackingTarget(inst, inst.target)
	end

    if inst.element1 == 0 and inst.element2 == 0 then
	    inst.anim1.Image:SetTexture(resolvefilepath("images/null.xml"), "null.tex")
		inst.anim2.Image:SetTexture(resolvefilepath("images/null.xml"), "null.tex")
		inst.anim1.Image:SetWorldOffset(-0.4, inst.anim1.y_offset, 0)
		inst.anim2.Image:SetWorldOffset(0.4, inst.anim2.y_offset, 0)

	elseif inst.element1 ~= 0 and inst.element2 ~= 0 then
	    inst.anim1.Image:SetTexture(resolvefilepath("images/"..anims[inst.element1]..".xml"), anims[inst.element1]..".tex")
		inst.anim2.Image:SetTexture(resolvefilepath("images/"..anims[inst.element2]..".xml"), anims[inst.element2]..".tex")
		inst.anim1.Image:SetWorldOffset(-0.45, inst.anim1.y_offset, 0)
		inst.anim2.Image:SetWorldOffset(0.45, inst.anim2.y_offset, 0)

	else
	    if inst.element1 ~= 0 then
		    inst.anim1.Image:SetTexture(resolvefilepath("images/"..anims[inst.element1]..".xml"), anims[inst.element1]..".tex")
			inst.anim2.Image:SetTexture(resolvefilepath("images/null.xml"), "null.tex")

		elseif inst.element2 ~= 0 then
		    inst.anim1.Image:SetTexture(resolvefilepath("images/null.xml"), "null.tex")
		    inst.anim2.Image:SetTexture(resolvefilepath("images/"..anims[inst.element2]..".xml"), anims[inst.element2]..".tex")

		end
		inst.anim1.Image:SetWorldOffset(0, inst.anim1.y_offset, 0)
		inst.anim2.Image:SetWorldOffset(0, inst.anim2.y_offset, 0)
	end
end

local function OnElementDirty(inst)
	inst.element1 = inst._element1:value()
	inst.element2 = inst._element2:value()
	--inst.element1_value = inst._element1_value:value()
	--inst.element2_value = inst._element2_value:value()
	updateanimation(inst)
end

local function SetElement(inst, data)
    inst.element1 = data.element1
	inst.element2 = data.element2
	--inst.element1_value = data.element1_value
	--inst.element2_value = data.element2_value
    inst._element1:set(data.element1)
	inst._element2:set(data.element2)
	--inst._element1_value:set(data.element1_value)
	--inst._element2_value:set(data.element2_value)
	inst._target:set(inst.target)
	updateanimation(inst)
end

local function OnTargetDirty(inst)
    inst.target = inst._target:value()
    SetTrackingTarget(inst, inst.target)
end

-------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
	
	inst.entity:AddLabel()
	inst.Label:SetWorldOffset(0, 6, 2)
	inst.Label:SetFont(NUMBERFONT)
	inst.Label:SetFontSize(TUNING.LABEL_FONT_SIZE - 10)

	--Label is for DEBUG
	inst.Label:Enable(false)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
	inst:AddTag("element_indicator")

	----------------------------------------------------------------------------
	inst.element1 = 0
	inst.element2 = 0
	--inst.element1_value = 0
	--inst.element2_value = 0
	inst.target = nil
	----------------------------------------------------------------------------
	inst._element1 = net_byte(inst.GUID,"element_indicator._element1","elementdirty")
	inst._element2 = net_byte(inst.GUID,"element_indicator._element2","elementdirty")
	--inst._element1_value = net_float(inst.GUID,"_element1_value","elementdirty")
	--inst._element2_value = net_float(inst.GUID,"_element2_value","elementdirty")
	inst._target = net_entity(inst.GUID,"element_indicator._target","targetdirty")
	----------------------------------------------------------------------------		

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
	    inst:ListenForEvent("elementdirty", OnElementDirty)
		inst:ListenForEvent("targetdirty", OnTargetDirty)
		return inst
    end
   	
	inst.persists = false
	
	inst.anim1 = nil
	inst.anim2 = nil
	
	inst:AddComponent("entitytracker")

	inst:ListenForEvent("element_updated", SetElement)

	inst.SetTrackingTarget = SetTrackingTarget
	
    return inst
end

return Prefab("element_indicator", fn, assets, prefabs)