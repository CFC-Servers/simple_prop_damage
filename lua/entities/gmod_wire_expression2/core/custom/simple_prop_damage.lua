E2Lib.RegisterExtension( "simple_prop_damage", true )

e2function void entity:spdAdminDisable()
    if not IsValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = true
end

e2function void entity:spdAdminEnable()
    if not IsValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = false
end
