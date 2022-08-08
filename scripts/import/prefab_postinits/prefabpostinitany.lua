AddPrefabPostInitAny(function(inst)
	if inst.components.elementreactor ~= nil and inst.components.elementreactor.indicator ~= nil then
	    inst.components.elementreactor.indicator:SetTrackingTarget(inst)
	end
end)

AddPrefabPostInitAny(function(inst)
    if not inst.components.lootdropper then
	    return
	end
	
    if not inst.components.combat then
	    return
	end
	
	if inst:HasTag("wall") or inst:HasTag("chester") then
		return
	end
	
	if inst.components.health then
	    if inst.components.health.maxhealth < 1000 then
			--让它掉落，不然的话，太难攒了
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 0.1)
		    
		elseif inst.components.health.maxhealth <= 2500 then
		
		    inst.components.lootdropper:AddChanceLoot("randomartifacts", 0.5)
			
		elseif inst.components.health.maxhealth <= 6000 then
		    
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
			
		else
		    
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 0.5)
			
		end
	else
	    if not inst:HasTag("epic") then

		    inst.components.lootdropper:AddChanceLoot("randomartifacts", 0.1)
			
		else
		    
			inst.components.lootdropper:AddChanceLoot("randomartifacts", 1)
			
		end
	end
	
end)


local exclude_tags = {
	"chester",
	"butterfly",
	"glommer",
	"hutch",
	"bird",
}
AddPrefabPostInitAny(function(inst)
	if not inst.components.combat then
		return
	end
	
    if inst:HasTag("player") or inst:HasTag("abigail") or inst:HasTag("kasen_self") then
		return
	end

	for k,v in pairs(exclude_tags) do
		if inst:HasTag(v) then
			inst.components.combat.defense = 0
			return
		end
	end

    inst.components.combat.crit_rate = 0
    inst.components.combat.pyro_res = 0.1
	inst.components.combat.cryo_res = 0.1
	inst.components.combat.hydro_res = 0.1
	inst.components.combat.electro_res = 0.1
	inst.components.combat.anemo_res = 0.1
	inst.components.combat.geo_res = 0.1
	inst.components.combat.dendro_res = 0.1
	inst.components.combat.physical_res = 0.15

	--BOSS
	if inst.prefab == "spat" then
	    inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("warg") then
	    inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("spiderqueen") then
	    inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("leif") then
		inst.components.combat.pyro_res = 0
		inst.components.combat.cryo_res = 0.15
		inst.components.combat.hydro_res = 0.15
		inst.components.combat.electro_res = 0.15
		inst.components.combat.anemo_res = 0.15
		inst.components.combat.geo_res = 0.15
		inst.components.combat.dendro_res = 0.3
	    inst.components.combat.physical_res = 0
	elseif inst:HasTag("antlion") then
	    inst.components.combat.geo_res = 0.3
		inst.components.combat.physical_res = 0.2
	elseif inst:HasTag("moose") then
		inst.components.combat.electro_res = 0.35
		inst.components.combat.physical_res = 0.2
	elseif inst.prefab == "mossling" then
		inst.components.combat.electro_res = 0.25
	elseif inst:HasTag("bearger") then
	    inst.components.combat.anemo_res = 0.2
		inst.components.combat.dendro_res = 0.2
		inst.components.combat.physical_res = 0.2
	elseif inst:HasTag("deerclops") then
		inst.components.combat.pyro_res = 0
	    inst.components.combat.cryo_res = 0.5
		inst.components.combat.physical_res = 0.2
	elseif inst:HasTag("dragonfly") then
		inst.components.combat.hydro_res = 0
		inst.components.combat.cryo_res = 0
	    inst.components.combat.pyro_res = 0.65
		inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("beequeen") then
		inst.components.combat.anemo_res = 0.3
		inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("lordfruitfly") then
		inst.components.combat.anemo_res = 0.4
		inst.components.combat.physical_res = 0.2
	elseif inst:HasTag("crabking") then
		inst.components.combat.geo_res = 0.35
		inst.components.combat.physical_res = 0.35
	elseif inst:HasTag("malbatross") then
		inst.components.combat.hydro_res = 0.4
		inst.components.combat.physical_res = 0.2
	elseif inst:HasTag("klaus") then
		inst.components.combat.pyro_res = 0.15
	    inst.components.combat.cryo_res = 0.15
	    inst.components.combat.hydro_res = 0.15
	    inst.components.combat.electro_res = 0.15
	    inst.components.combat.anemo_res = 0.15
	    inst.components.combat.geo_res = 0.15
	    inst.components.combat.dendro_res = 0.15
		inst.components.combat.physical_res = 0.3
	elseif inst.prefab == "deer_red" then
		inst.components.combat.pyro_res = 0.35
	elseif inst.prefab == "deer_blue" then
		inst.components.combat.cryo_res = 0.35
	elseif inst:HasTag("shadowchesspiece") then
		inst.components.combat.pyro_res = 0.25
	    inst.components.combat.cryo_res = 0.25
	    inst.components.combat.hydro_res = 0.25
	    inst.components.combat.electro_res = 0.25
	    inst.components.combat.anemo_res = 0.25
	    inst.components.combat.geo_res = 0.25
	    inst.components.combat.dendro_res = 0.25
	elseif inst:HasTag("toadstool") then
		inst.components.combat.pyro_res = 0.15
	    inst.components.combat.cryo_res = 0.15
	    inst.components.combat.hydro_res = 0.15
	    inst.components.combat.electro_res = 0.15
	    inst.components.combat.anemo_res = 0.15
	    inst.components.combat.geo_res = 0.3
	    inst.components.combat.dendro_res = 0.3
		inst.components.combat.physical_res = 0.3
	elseif inst:HasTag("minotaur") then
		inst.components.combat.pyro_res = 0.15
	    inst.components.combat.cryo_res = 0.15
	    inst.components.combat.hydro_res = 0.15
	    inst.components.combat.electro_res = 0.15
	    inst.components.combat.anemo_res = 0.15
	    inst.components.combat.geo_res = 0.15
	    inst.components.combat.dendro_res = 0.15
		inst.components.combat.physical_res = 0.25
	elseif inst:HasTag("stalker") then
		inst.components.combat.pyro_res = 0.25
	    inst.components.combat.cryo_res = 0.25
	    inst.components.combat.hydro_res = 0.25
	    inst.components.combat.electro_res = 0.25
	    inst.components.combat.anemo_res = 0.25
	    inst.components.combat.geo_res = 0.25
	    inst.components.combat.dendro_res = 0.25
		inst.components.combat.physical_res = 0.3
	elseif inst:HasTag("brightmareboss") then
		inst.components.combat.pyro_res = 0.25
	    inst.components.combat.cryo_res = 0.25
	    inst.components.combat.hydro_res = 0.25
	    inst.components.combat.electro_res = 0.25
	    inst.components.combat.anemo_res = 0.25
	    inst.components.combat.geo_res = 0.25
	    inst.components.combat.dendro_res = 0.25
		inst.components.combat.physical_res = 0.3

	--其他生物
	elseif inst:HasTag("spider") then
		--没什么效果
	elseif inst:HasTag("pigman") then
		inst.components.combat.physical_res = 0
	elseif inst:HasTag("chess") then
		inst.components.combat.physical_res = 0.5
	elseif inst:HasTag("archive_centipede") then
		inst.components.combat.physical_res = 0.4
	elseif inst:HasTag("shadowcreature") then
		inst.components.combat.pyro_res = 0.2
	    inst.components.combat.cryo_res = 0.2
	    inst.components.combat.hydro_res = 0.2
	    inst.components.combat.electro_res = 0.2
	    inst.components.combat.anemo_res = 0.2
	    inst.components.combat.geo_res = 0.2
	    inst.components.combat.dendro_res = 0.2

	elseif inst.prefab == "firehound" then
		inst.components.combat.pyro_res = 0.25
	elseif inst.prefab == "icehound" then
		inst.components.combat.cryo_res = 0.25
	elseif inst.prefab == "clayhound" then
		inst.components.combat.geo_res = 0.25
	elseif inst.prefab == "moonhound" then
		inst.components.combat.electro_res = 0.25

    elseif inst:HasTag("cavedweller") then
		inst.components.combat.geo_res = 0.25
		inst.components.combat.physical_res = 0.3
	elseif inst:HasTag("tentacle") then
		inst.components.combat.hydro_res = 0.2
	elseif inst:HasTag("rocky") then
		inst.components.combat.geo_res = 0.5
	end
end)