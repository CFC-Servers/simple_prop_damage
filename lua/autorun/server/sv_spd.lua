AddCSLuaFile("autorun/client/cl_spd.lua")

include("spd/server/sv_spd.lua")

if not ConVarExists("spd_enabled") then
	
	CreateConVar("spd_enabled", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)
	
end

local cvartbl = cvartbl or {}
cvartbl[1] = {"spd_prophealth", 1}
cvartbl[2] = {"spd_effects", 1}
cvartbl[3] = {"spd_explosion", 1}
cvartbl[4] = {"spd_color", 1}
cvartbl[5] = {"spd_unfreeze", 1}
cvartbl[6] = {"spd_unfreeze_threshold", 0.5}
cvartbl[7] = {"spd_removeconstraints", 1}
cvartbl[8] = {"spd_removeconstraints_threshold", 0.25}
cvartbl[9] = {"spd_explosion_effect", "Explosion"}
cvartbl[10] = {"spd_effect", "StunstickImpact"}
cvartbl[11] = {"spd_effect2", "cball_explode"}
cvartbl[12] = {"spd_physicsdamage", 1}
cvartbl[13] = {"spd_bulletdamage", 1}
cvartbl[14] = {"spd_explosiondamage", 1}
cvartbl[15] = {"spd_tool_heal_adminonly", 1}
cvartbl[16] = {"spd_tool_toggle_adminonly", 1}
cvartbl[17] = {"spd_health_weightratio", 0.5}
cvartbl[18] = {"spd_health_volumeratio", 0.5}
cvartbl[19] = {"spd_colorfade_r", 255}
cvartbl[20] = {"spd_colorfade_g", 0}
cvartbl[21] = {"spd_colorfade_b", 0}
cvartbl[22] = {"spd_debris", 1}
cvartbl[23] = {"spd_meleedamage", 1}

for i=1, #cvartbl do

	local cvar = cvartbl[i][1]
	local default = cvartbl[i][2]
	
	if not ConVarExists(cvar) then
	
		CreateConVar(cvar, default, FCVAR_ARCHIVE)
		
	end
	
end