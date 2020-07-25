local spd = spd or {}
local coltbl = coltbl or {}

local affectedEnts = {
    "prop_physics" = true,
    "prop_vehicle_prisoner_pod" = true 
}

function IsSPDAffectedEntity( ent )
    if affectedEnts[ent:GetClass()] or WireLib.HasPorts( ent ) or ent.IsWire then
        
        return true        
    end
    
    return false
end

function IsSPDAffectedLOSEntity( ent )
    if ent:GetClass() == "prop_vehicle_prisoner_pod" or WireLib.HasPorts( ent ) or ent.IsWire then
        
        return true        
    end
    
    return false
end


local function isInLineOfSight( sVector, ent )
    if not isvector( sVector ) then return false end
    
    local entPosition = ent:GetPos() or Vector( 0, 0, 0 )
    
    local losTraceData = {}
    losTraceData["start"] = sVector
    losTraceData["endpos"] = entPosition
    losTraceData["filter"] = ent
    
    local losTrace = util.TraceLine( losTraceData )
    if not losTrace.Hit then
        
        return true
    end
    
    return false
end

local function spdEntityRemoved( ent )
    spd[ent:EntIndex()] = nil
    coltbl[ent:EntIndex()] = nil
end
hook.Add("EntityRemoved", "spdEntityRemovedHook", spdEntityRemoved)

local function spdEntityTakeDamage(ent, dmg)
    local entOwner = ent:CPPIGetOwner()

    if not IsValid( entOwner ) then
        return
    end

    if GetConVar( "spd_enabled" ):GetInt() == 0 then
        return
    end

    if not IsSPDAffectedEntity( ent ) then
        return
    end
    
    local condForSpecial = not isInLineOfSight( dmg:GetDamagePosition(), ent ) and dmg:IsDamageType( DMG_BLAST )
    if IsSPDAffectedLOSEntity( ent ) and condForSpecial then
        return
    end
    
    if dmg:IsDamageType( DMG_CRUSH ) then
        local physicsDamage = GetConVar( "spd_physicsdamage" ):GetFloat()

        if physicsDamage == 0 then return end

        dmg:ScaleDamage( physicsDamage )
    end

    if dmg:IsDamageType( DMG_BULLET ) then
        local bulletDamage = GetConVar( "spd_bulletdamage" ):GetFloat()

        if bulletDamage == 0 then return end

        dmg:ScaleDamage( bulletDamage )
    end

    if dmg:IsDamageType( DMG_BLAST ) then
        local explosionDamage = GetConVar( "spd_explosiondamage" ):GetFloat()

        if explosionDamage == 0 then return end

        dmg:ScaleDamage( explosionDamage )
    end

    if dmg:IsDamageType( DMG_CLUB ) then
        local meleeDamage = GetConVar( "spd_meleedamage" ):GetFloat()

        if meleeDamage == 0 then return end

        dmg:ScaleDamage( meleeDamage )
    end

    local entPhysObj = ent:GetPhysicsObject()
    local entIndex = ent:EntIndex()

    local shouldDamage = hook.Run( "SPDEntityTakeDamage", ent, dmg )
    if shouldDamage == false then return end

    if IsValid( ent ) and IsValid( entPhysObj ) and spd[entIndex] == nil and ent:Health() == 0 then
        local spdHealth = spdGetMaxHealth( ent )
        
        spd[entIndex] = spdHealth
        coltbl[entIndex] = ent:GetColor()
    end
    
    if IsValid( ent ) and IsValid( entPhysObj ) and spd[entIndex] then
        spd[entIndex] = spd[entIndex] - dmg:GetDamage() / GetConVar( "spd_prophealth" ):GetInt()
        
        local spdMaxHealth = spdGetMaxHealth( ent )
        
        if GetConVar( "spd_color" ):GetInt() ~= 0 then
            local entHealthPercent = spd[entIndex] / spdMaxHealth
            
            local entR = coltbl[ entIndex ].r
            local entG = coltbl[ entIndex ].g
            local entB = coltbl[ entIndex ].b
            
            local fadeR = GetConVar( "spd_colorfade_r" ):GetInt()
            local fadeG = GetConVar( "spd_colorfade_g" ):GetInt()
            local fadeB = GetConVar( "spd_colorfade_b" ):GetInt()
            
            local newR = Lerp( entHealthPercent, fadeR, entR )
            local newG = Lerp( entHealthPercent, fadeG, entG )
            local newB = Lerp( entHealthPercent, fadeB, entB )
            
            local alpha = coltbl[entIndex].a
            
            local color = Color( newR, newG, newB, alpha )
            
            ent:SetColor( color )
        end
        
        if spd[entIndex] < spdMaxHealth * GetConVar( "spd_unfreeze_threshold" ):GetFloat() then
            if GetConVar( "spd_effects" ):GetInt() ~= 0 then
                local effect = EffectData()
                local dmgPos = dmg:GetDamagePosition()
                effect:SetStart( dmgPos )
                effect:SetOrigin( dmgPos )
                util.Effect( cvars.String( "spd_effect" ), effect )
            end
            
            if GetConVar( "spd_unfreeze" ):GetInt() ~= 0 then
                entPhysObj:EnableMotion( true ) 
            end
        end
        
        if spd[entIndex] < spdMaxHealth * GetConVar( "spd_removeconstraints_threshold" ):GetFloat() then
            if GetConVar( "spd_effects" ):GetInt() ~= 0 then
                local effect = EffectData()
                local dmgPos = dmg:GetDamagePosition()
                
                effect:SetStart( dmgPos )
                effect:SetOrigin( dmgPos )
                
                util.Effect( cvars.String( "spd_effect2" ), effect )
            end
            
            if GetConVarNumber( "spd_removeconstraints" ) ~= 0 then
                constraint.RemoveAll( ent ) 
            end
        end
        
        if spd[entIndex] <= 0 then
            if GetConVar( "spd_explosion" ):GetFloat() ~= 0 then
                local effect = EffectData()
                local entPos = ent:WorldSpaceCenter()
                
                effect:SetStart( entPos )
                effect:SetOrigin( entPos )
                
                util.Effect( cvars.String( "spd_explosion_effect" ), effect )
            end
            
            spdDebris( ent )
            
            SafeRemoveEntity( ent ) 
        end
    end
end

hook.Add( "EntityTakeDamage", "spdEntityTakeDamageHook", spdEntityTakeDamage )

function spdDebris( ent )
    if GetConVar( "spd_debris" ):GetInt() == 0 then
        return
    end
    
    if IsValid( ent ) and not ent.spdDestroyed then
        ent.spdDestroyed = true
        
        local debris = ents.Create( "base_gmodentity" )
        local mat = "debris/debris" .. tostring( math.random( 1, 4 ) )
        
        debris:SetPos( ent:GetPos() )
        debris:SetAngles( ent:GetAngles() )
        debris:SetModel( ent:GetModel() )
        debris:SetMaterial( mat, false )
        debris:SetCollisionGroup( COLLISION_GROUP_WORLD )
        debris:PhysicsInit( SOLID_VPHYSICS )
        
        local physobj = debris:GetPhysicsObject()
        --local force = spdGetMaxHealth(ent) * 4
        local force = 1000
        
        local function randForceSymmetric() return math.random( -force, force) end
        local velVector = Vector( randForceSymmetric(), randForceSymmetric(), randForceSymmetric() )
        
        physobj:AddVelocity( velVector )
        physobj:AddAngleVelocity( velVector )
        
        timer.Simple( 10, function()
            if IsValid( debris ) then
                local effect = EffectData()
                local debrisPos = debris:GetPos()
                
                effect:SetStart( debrisPos )
                effect:SetOrigin( debrisPos )
                effect:SetEntity( debris )

                util.Effect( "entity_remove", effect )
            end
            
            timer.Simple( engine.TickInterval(), function()
                SafeRemoveEntity( debris )
            end)
        end)
    end
end

function spdGetColor( ent )
    return coltbl[ent:EntIndex()]
end

function spdEnable( ent )
    if IsValid( ent ) then
        ent.spdDisabled = false
    end
end

function spdDisable( ent )
    ent.spdDisabled = nil
end

function spdClear( ent )
    spd[ent:EntIndex()] = nil
    coltbl[ent:EntIndex()] = nil
end

function spdGetHealth( ent )
    return spd[ent:EntIndex()]
end

function spdGetMaxHealth( ent )
    return spdGetWeightHealth( ent ) + spdGetVolumeHealth( ent )
end

function spdGetWeightHealth( ent )
    return ent:GetPhysicsObject():GetMass() * GetConVar( "spd_health_weightratio" ):GetFloat()
end

function spdGetVolumeHealth( ent )
    return ent:GetPhysicsObject():GetVolume() / 500 * GetConVar( "spd_health_volumeratio" ):GetFloat()
end
