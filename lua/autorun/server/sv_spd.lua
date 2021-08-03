AddCSLuaFile("autorun/client/cl_spd.lua")

include("spd/server/sv_spd.lua")

if not ConVarExists("spd_enabled") then
    CreateConVar("spd_enabled", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY)
end

if not ConVarExists("spd_tool_toggle_adminonly") then
    CreateConVar("spd_tool_toggle_adminonly", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED)
end

if not ConVarExists("spd_tool_heal_adminonly") then
    CreateConVar("spd_tool_heal_adminonly", 1, FCVAR_ARCHIVE + FCVAR_REPLICATED)
end

local cvartbl = cvartbl or {
    spd_prophealth = 1,
    spd_effects = 1,
    spd_explosion = 1,
    spd_color = 1,
    spd_unfreeze = 1,
    spd_unfreeze_threshold = 0.5,
    spd_removeconstraints = 1,
    spd_removeconstraints_threshold = 0.25,
    spd_explosion_effect = "Explosion",
    spd_effect = "StunstickImpact",
    spd_effect2 = "cball_explode",
    spd_physicsdamage = 1,
    spd_bulletdamage = 1,
    spd_explosiondamage = 1,
    spd_health_weightratio = 0.5,
    spd_health_volumeratio = 0.5,
    spd_colorfade_r = 255,
    spd_colorfade_g = 0,
    spd_colorfade_b = 0,
    spd_debris = 1,
    spd_meleedamage = 1,
    spd_frozenmodifier = 0.5,
    spd_health_max = 75000,
    spd_health_max_destructible = 100,
}

for cvar, default in pairs( cvartbl ) do
    if not ConVarExists( cvar ) then
        CreateConVar( cvar, default, FCVAR_ARCHIVE )
    end
end
