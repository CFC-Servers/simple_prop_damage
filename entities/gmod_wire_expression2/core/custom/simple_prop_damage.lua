E2Lib.RegisterExtension( "simple_prop_damage", true )

e2function void entity:spdAdmDisable()
    if not isValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = 1
end

e2function void entity:spdAdmEnable()
    if not isValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = 0
end
