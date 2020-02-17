if SERVER then
	AddCSLuaFile("spd_toggle.lua")
end

if CLIENT then

	language.Add("tool.spd_toggle.name", "SPD Toggle")
	language.Add("tool.spd_toggle.desc", "Toggle SPD on a specific prop.")
	language.Add("tool.spd_toggle.0", "Left-Click to disable SPD on a prop. Right-Click to enable SPD on a prop.")
	
end

TOOL.Category = "SPD"
TOOL.Name = "#tool.spd_toggle.name"

function TOOL.BuildCPanel(panel)
	panel:AddControl("Header", {
		Text = "#tool.spd_toggle.name", Description = "#tool.spd_toggle.desc"
	})
end

function TOOL:LeftClick(trace)
	
	local owner = self:GetOwner()
	local ent = trace.Entity
	
	if GetConVar("spd_tool_toggle_adminonly"):GetInt() ~= 0 and owner:IsAdmin() == false then
		
		if CLIENT then
		
			notification.AddLegacy("This tool is restricted to admins!" , NOTIFY_ERROR, 5)
			return false
			
		end
		
		return false
	
	end
	
	if IsValid(ent) and ent:GetClass() == "prop_physics" then
		
		spdDisableEffect(ent)
		
		if CLIENT then
			return true
		end
	
		spdDisable(ent)
		
		return true
	
	end
	
	return false
	
end

function TOOL:RightClick(trace)
	
	local owner = self:GetOwner()
	local ent = trace.Entity
	
	if GetConVar("spd_tool_toggle_adminonly"):GetInt() ~= 0 and owner:IsAdmin() == false then
	
		if CLIENT then
		
			notification.AddLegacy("This tool is restricted to admins!" , NOTIFY_ERROR, 5)
			return false
			
		end
		
		return false
	
	end
	
	if IsValid(ent) and ent:GetClass() == "prop_physics" then
		
		spdEnableEffect(ent)
		
		if CLIENT then
			return true
		end
	
		spdEnable(ent)
		
		return true
	
	end
	
	return false
	
end

function spdEnableEffect(ent)

	local effect = EffectData()
	local entPos = ent:GetPos()
	effect:SetStart(entPos)
	effect:SetOrigin(entPos)
	effect:SetEntity(ent)
	util.Effect("phys_freeze", effect)

end

function spdDisableEffect(ent)

	local effect = EffectData()
	local entPos = ent:GetPos()
	effect:SetStart(entPos)
	effect:SetOrigin(entPos)
	effect:SetEntity(ent)
	util.Effect("phys_unfreeze", effect)

end