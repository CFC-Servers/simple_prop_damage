local tostring = tostring
local rawget = rawget
local rawset = rawset
local IsValid = IsValid
local GetConVar = GetConVar
local SafeRemoveEntity = SafeRemoveEntity
local Lerp = Lerp
local Color = Color
local Vector = Vector
local EffectData = EffectData

local hookRun = hook.Run
local utilEffect = util.Effect
local constraintRemoveAll = constraint.RemoveAll
local entsCreate = ents.Create

local mathRandom = math.random
local mathClamp = math.Clamp

local DMG_CRUSH = DMG_CRUSH
local DMG_BULLET = DMG_BULLET
local DMG_BLAST = DMG_BLAST
local DMG_CLUB = DMG_CLUB
local COLLISION_GROUP_WORLD = COLLISION_GROUP_WORLD
local SOLID_VPHYSICS = SOLID_VPHYSICS

local TickInterval = engine.TickInterval()

local spd = spd or {}
local coltbl = coltbl or {}

local function spdEntityRemoved(ent)
    local entIndex = ent:EntIndex()

    rawset( spd, entIndex, nil )
    rawset( coltbl, entIndex, nil )
end
hook.Add("EntityRemoved", "spdEntityRemovedHook", spdEntityRemoved)

local immuneEntities = {
    -- SimfPhys
    gmod_sent_vehicle_fphysics_wheel = true,
    gmod_sent_vehicle_fphysics_base = true,
    gmod_sent_vehicle_fphysics_attachment = true,
    prop_vehicle_prisoner_pod = true,
    phys_spring = true,
    m9k_nervegasnade = true,
    sammyservers_textscreen = true
}

local spdEnabled
local physicsDamage
local bulletDamage
local explosionDamage
local meleeDamage
local frozenModifier
local propHealth
local spdColor
local colorFadeR
local colorFadeG
local colorFadeB
local unfreezeThreshold
local removeConstraintsThreshold
local spdEffects
local spdEffect
local spdEffect2
local spdExplosionEffect
local spdUnfreeze
local spdRemoveConstraints
local spdExplosion
local spdDebrisEnabled
local healthMax
local healthWeightRatio
local healthVolumeRatio

function SPDUpdateConvars()
    spdEnabled = GetConVar( "spd_enabled" ):GetBool()

    physicsDamage = GetConVar( "spd_physicsdamage" ):GetFloat()
    bulletDamage = GetConVar( "spd_bulletdamage" ):GetFloat()
    explosionDamage = GetConVar("spd_explosiondamage"):GetFloat()
    meleeDamage = GetConVar("spd_meleedamage"):GetFloat()

    frozenModifier = GetConVar( "spd_frozenmodifier" ):GetFloat()
    propHealth = GetConVar( "spd_prophealth" ):GetInt()

    spdColor = GetConVar( "spd_color" ):GetBool()
    colorFadeR = GetConVar( "spd_colorfade_r" ):GetInt()
    colorFadeG = GetConVar( "spd_colorfade_g" ):GetInt()
    colorFadeB = GetConVar( "spd_colorfade_b" ):GetInt()

    unfreezeThreshold = GetConVar( "spd_unfreeze_threshold" ):GetFloat()
    removeConstraintsThreshold = GetConVar( "spd_removeconstraints_threshold" ):GetFloat()

    spdEffects = GetConVar( "spd_effects" ):GetBool()
    spdEffect = cvars.String( "spd_effect" )
    spdEffect2 = cvars.String( "spd_effect2" )
    spdExplosionEffect = cvars.String( "spd_explosion_effect" )

    spdUnfreeze = GetConVar( "spd_unfreeze" ):GetBool()
    spdRemoveConstraints = GetConVar( "spd_removeconstraints" ):GetBool()
    spdExplosion = GetConVar( "spd_explosion" ):GetBool()
    spdDebrisEnabled = GetConVar( "spd_debris" ):GetBool()

    healthMax = GetConVar( "spd_health_max" ):GetInt()
    healthWeightRatio = GetConVar( "spd_health_weightratio" ):GetFloat()
    healthVolumeRatio = GetConVar( "spd_health_volumeratio" ):GetFloat()
end
hook.Add( "Initialize", "SPDConvarSetup", SPDUpdateConvars )

local function spdEntityTakeDamage(ent, dmg)
    if not spdEnabled then return end

    if not IsValid( ent ) then return end
    if ent.spdDisabled then return end

    local entOwner = ent:CPPIGetOwner()
    if not IsValid( entOwner ) then return end

    if ent:IsNPC() then return end
    if ent:IsNextBot() then return end

    if rawget( immuneEntities, ent:GetClass() ) then return end

    if dmg:IsDamageType( DMG_CRUSH ) then
        if physicsDamage == 0 then return end
        dmg:ScaleDamage( physicsDamage )
    end

    if dmg:IsDamageType( DMG_BULLET ) then
        if bulletDamage == 0 then return end
        dmg:ScaleDamage( bulletDamage )
    end

    if dmg:IsDamageType( DMG_BLAST ) then
        if explosionDamage == 0 then return end
        dmg:ScaleDamage( explosionDamage )
    end

    if dmg:IsDamageType( DMG_CLUB ) then
        if meleeDamage == 0 then return end
        dmg:ScaleDamage( meleeDamage )
    end

    local entPhysObj = ent:GetPhysicsObject()
    local entIndex = ent:EntIndex()

    if not IsValid( entPhysObj ) then return end

    if entPhysObj:IsAsleep() then
        dmg:ScaleDamage( frozenModifier )
    end

    local shouldDamage = hookRun( "SPDEntityTakeDamage", ent, dmg )
    if shouldDamage == false then return end

    local spdForEnt = rawget( spd, entIndex )

    if spdForEnt == nil and ent:Health() == 0 then
        local spdHealth = spdGetMaxHealth( ent )

        rawset( spd, entIndex, spdHealth )
        spdForEnt = spdHealth

        rawset( coltbl, entIndex, ent:GetColor() )
    end

    if spdForEnt then
        local newHealth = spdForEnt - dmg:GetDamage() / propHealth
        rawset( spd, entIndex, newHealth )

        local spdMaxHealth = spdGetMaxHealth(ent)

        if spdColor then

            local entCol = rawget( coltbl, entIndex )

            local entHealthPercent = newHealth / spdMaxHealth
            local entR = rawget( entCol, "r" )
            local entG = rawget( entCol, "g" )
            local entB = rawget( entCol, "b" )
            local entA = rawget( entCol, "a" )
            local newR = Lerp( entHealthPercent, colorFadeR, entR )
            local newG = Lerp( entHealthPercent, colorFadeG, entG )
            local newB = Lerp( entHealthPercent, colorFadeB, entB )
            local color = Color( newR, newG, newB, entA )

            ent:SetColor( color )
        end

        if newHealth < spdMaxHealth * unfreezeThreshold then

            if spdEffects then
                local effect = EffectData()
                local dmgPos = dmg:GetDamagePosition()
                effect:SetStart( dmgPos )
                effect:SetOrigin( dmgPos )
                utilEffect(spdEffect, effect)
            end

            if spdUnfreeze then
                entPhysObj:EnableMotion(true)
            end

        end

        if newHealth < spdMaxHealth * removeConstraintsThreshold then

            if spdEffects then
                local effect = EffectData()
                local dmgPos = dmg:GetDamagePosition()
                effect:SetStart(dmgPos)
                effect:SetOrigin(dmgPos)
                utilEffect(spdEffect2, effect)
            end

            if spdRemoveConstraints then constraintRemoveAll(ent) end
        end

        if newHealth <= 0 then
            if spdExplosion then
                local effect = EffectData()
                local entPos = ent:WorldSpaceCenter()
                effect:SetStart(entPos)
                effect:SetOrigin(entPos)
                utilEffect(spdExplosionEffect, effect)
            end

            spdDebris( ent )
            SafeRemoveEntity( ent )
        end

    end

end

hook.Add( "EntityTakeDamage", "spdEntityTakeDamageHook", spdEntityTakeDamage )

function spdDebris( ent )

    if not spdDebrisEnabled then return end

    if IsValid( ent ) and not ent.spdDestroyed then
        ent.spdDestroyed = true

        local debris = entsCreate( "base_gmodentity" )
        local mat = "debris/debris" .. tostring( mathRandom( 1, 4 ) )

        debris:SetPos( ent:GetPos() )
        debris:SetAngles( ent:GetAngles() )
        debris:SetModel( ent:GetModel() )
        debris:SetMaterial( mat, false )
        debris:SetCollisionGroup( COLLISION_GROUP_WORLD )
        debris:PhysicsInit( SOLID_VPHYSICS )

        local physobj = debris:GetPhysicsObject()
        --local force = spdGetMaxHealth(ent) * 4
        local force = 1000

        physobj:AddVelocity(Vector(mathRandom(-force, force), mathRandom(-force, force), mathRandom(-force, force)))
        physobj:AddAngleVelocity(Vector(mathRandom(-force, force), mathRandom(-force, force), mathRandom(-force, force)))

        timer.Simple(10, function()

            if IsValid(debris) then

                local effect = EffectData()
                local debrisPos = debris:GetPos()
                effect:SetStart(debrisPos)
                effect:SetOrigin(debrisPos)
                effect:SetEntity(debris)
                utilEffect("entity_remove", effect)

            end

            timer.Simple(TickInterval, function()
                SafeRemoveEntity(debris)
            end )
        end )

    end

end

function spdGetColor(ent)
    return rawget( coltbl, ent:EntIndex() )
end

function spdEnable(ent)
    if IsValid(ent) then
        ent.spdDisabled = nil
    end
end

function spdDisable(ent)
    if IsValid(ent) then
        ent.spdDisabled = true
    end
end

function spdClear(ent)
    local entIndex = ent:EntIndex()
    rawset( spd, entIndex, nil )
    rawset( coltbl, entIndex, nil )
end

function spdGetHealth(ent)
    return rawget( spd, ent:EntIndex() )
end

function spdGetMaxHealth(ent)
    local maxHealth = spdGetWeightHealth(ent) + spdGetVolumeHealth(ent)
    local clampedHealth = mathClamp( maxHealth, 0, healthMax )

    return clampedHealth
end

function spdGetWeightHealth(ent)
    return ent:GetPhysicsObject():GetMass() * healthWeightRatio
end

function spdGetVolumeHealth(ent)
    local phys = ent:GetPhysicsObject()
    if not IsValid( phys ) then return 0 end

    local volume = phys:GetVolume()
    if not volume then return 0 end

    return volume / 500 * healthVolumeRatio
end
