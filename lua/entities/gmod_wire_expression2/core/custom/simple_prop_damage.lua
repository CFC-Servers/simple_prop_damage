E2Lib.RegisterExtension( "simple_prop_damage", true )

e2function void entity:spdAdminDisable()
    if not IsValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = 1
end

e2function void entity:spdAdminEnable()
    if not IsValid( this ) then return end
    if not self.player:IsAdmin() then return end
    
    this.spdDisabled = 0
end
