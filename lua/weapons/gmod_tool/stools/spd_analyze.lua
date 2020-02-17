if SERVER then
	AddCSLuaFile("spd_analyze.lua")
end

if CLIENT then

	language.Add("tool.spd_analyze.name", "SPD Analyze")
	language.Add("tool.spd_analyze.desc", "Analyze the current health stats on a prop. Note that Weight and Volume can be influenced by the admin-controlled ConVars spd_health_weightratio and spd_health_volumeratio.")
	language.Add("tool.spd_analyze.0", "Base Health = Weight + Volume. Maximum Health = Base Health * Health Multiplier.")
	
end

TOOL.Category = "SPD"
TOOL.Name = "#tool.spd_analyze.name"

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", {
		Text = "#tool.spd_analyze.name", Description = "#tool.spd_analyze.desc"
	})
end

function TOOL:Think()

	local owner = self:GetOwner()
	local ent = owner:GetEyeTrace().Entity
	
	if not IsValid(ent) or not ent:GetClass() == "prop_physics" then
		return
	end
	
	if SERVER then
	
		if spdGetHealth(ent) ~= nil then
		
			ent:SetNWInt("spdHealth", math.ceil(spdGetHealth(ent) * GetConVar("spd_prophealth"):GetInt()))
			
		else
		
			ent:SetNWInt("spdHealth", math.ceil(spdGetMaxHealth(ent) * GetConVar("spd_prophealth"):GetInt()))
			
		end
		
		ent:SetNWInt("spdMaxHealth", math.ceil(spdGetMaxHealth(ent)))
		ent:SetNWInt("spdWeightHealth", math.ceil(spdGetWeightHealth(ent)))
		ent:SetNWInt("spdVolumeHealth", math.ceil(spdGetVolumeHealth(ent)))
		ent:SetNWInt("spdHealthMultiplier", GetConVar("spd_prophealth"):GetInt())
		
	end
	
	if CLIENT then
		
		spdAnalyzeTooltip(ent, ent:GetNWInt("spdHealth"), ent:GetNWInt("spdMaxHealth"), ent:GetNWInt("spdWeightHealth"), ent:GetNWInt("spdVolumeHealth"), ent:GetNWInt("spdHealthMultiplier"))
		
	end

end

function spdAnalyzeEffect(ent)

	local effect = EffectData()
	local entPos = ent:GetPos()
	effect:SetStart(entPos)
	effect:SetOrigin(entPos)
	effect:SetEntity(ent)
	util.Effect("propspawn", effect)

end

function spdAnalyzeTooltip(e, h, mh, wh, vh, hm)

	AddWorldTip(e:EntIndex(), "Current Health: "..h.." || Base Health: "..mh.." || Weight: "..wh.." || Volume: "..vh.." || Health Multiplier: "..hm, 0.5, e:GetPos(), e)
	halo.Add({e}, Color(0, 0, 255, 255), 2, 2, 0, true, true)

end

function TOOL:LeftClick(trace)
	return false
end