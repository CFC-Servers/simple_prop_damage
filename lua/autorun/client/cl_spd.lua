local function PopulateSPDMainPanel(panel)

	panel:AddControl("ComboBox", {
		Label = "#presets",
		MenuButton = 1,
		Folder = "SPD",
		Options = {
			Default = {
				spd_enabled = 1,
				spd_prophealth =1,
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
				spd_colorfade_r = 255,
				spd_colorfade_g = 0,
				spd_colorfade_b = 0,
				spd_debris = 1,
                spd_meleedamage = 1
			}
		},
		CVars = {
			[0] = "spd_enabled",
			[1] = "spd_prophealth",
			[2] = "spd_effects",
			[3] = "spd_explosion",
			[4] = "spd_color",
			[5] = "spd_unfreeze",
			[6] = "spd_unfreeze_threshold",
			[7] = "spd_removeconstraints",
			[8] = "spd_removeconstraints_threshold",
			[9] = "spd_explosion_effect",
			[10] = "spd_effect",
			[11] = "spd_effect2",
			[12] = "spd_physicsdamage",
			[13] = "spd_bulletdamage",
			[14] = "spd_explosiondamage",
			[15] = "spd_colorfade_r",
			[16] = "spd_colorfade_g",
			[17] = "spd_colorfade_b",
			[18] = "spd_debris",
                        [19] = "spd_meleedamage"
		}
	})
	
	panel:AddControl("CheckBox", {
        Label = "Enabled",
        Command = "spd_enabled",
    });
	
	panel:AddControl("Label", {
        Text = "Prop Health Multiplier: The higher this number is, the more health props will have."
    })
	panel:AddControl("Slider", {
        Label = "Prop Health Multiplier",
        Command = "spd_prophealth",
        Type = "Integer",
        Min = "0",
        Max = "10",
    })
	
	panel:AddControl("Label", {
        Text = "Enable Color Change: Whether or not props change color as they get damaged."
    })
	panel:AddControl("CheckBox", {
        Label = "Enable Color Change",
        Command = "spd_color",
    });
	panel:AddControl("Label", {
        Text = "Fade to Color: The color that props turn when damaged."
    })
	panel:AddControl("ComboBox", {
		Label = "#Color",
		MenuButton = "0",
		Options = {
			["#Red"] = {spd_colorfade_r = 255, spd_colorfade_g = 0, spd_colorfade_b = 0},
			["#Green"] = {spd_colorfade_r = 0, spd_colorfade_g = 255, spd_colorfade_b = 0},
			["#Blue"] = {spd_colorfade_r = 0, spd_colorfade_g = 0, spd_colorfade_b = 255},
			["#Cyan"] = {spd_colorfade_r = 0, spd_colorfade_g = 255, spd_colorfade_b = 255},
			["#Magenta"] = {spd_colorfade_r = 255, spd_colorfade_g = 0, spd_colorfade_b = 255},
			["#Yellow"] = {spd_colorfade_r = 255, spd_colorfade_g = 255, spd_colorfade_b = 0},
			["#Orange"] = {spd_colorfade_r = 255, spd_colorfade_g = 128, spd_colorfade_b = 0},
			["#Rose"] = {spd_colorfade_r = 255, spd_colorfade_g = 0, spd_colorfade_b = 128},
			["#Lime"] = {spd_colorfade_r = 128, spd_colorfade_g = 255, spd_colorfade_b = 0},
			["#Aqua"] = {spd_colorfade_r = 0, spd_colorfade_g = 255, spd_colorfade_b = 128},
			["#Purple"] = {spd_colorfade_r = 128, spd_colorfade_g = 0, spd_colorfade_b = 255},
			["#Azure"] = {spd_colorfade_r = 0, spd_colorfade_g = 128, spd_colorfade_b = 255},
			["#Black"] = {spd_colorfade_r = 0, spd_colorfade_g = 0, spd_colorfade_b = 0}
		}
	})
	
	panel:AddControl("Label", {
        Text = "Enable Damage Types: Whether or not specific damage types should actually damage props."
    })
	panel:AddControl("CheckBox", {
        Label = "Enable Physics Damage",
        Command = "spd_physicsdamage",
    });
	panel:AddControl("CheckBox", {
        Label = "Enable Bullet Damage",
        Command = "spd_bulletdamage",
    });
	panel:AddControl("CheckBox", {
        Label = "Enable Explosion Damage",
        Command = "spd_explosiondamage",
    });
	
	panel:AddControl("CheckBox", {
        Label = "Enable Unfreezing",
        Command = "spd_unfreeze",
    });
	panel:AddControl("Label", {
        Text = "Unfreeze Threshold: The percentage of health when props unfreeze. Also creates an effect when a prop is hit below this health."
    })
	panel:AddControl("Slider", {
        Label = "Unfreeze Threshold",
        Command = "spd_unfreeze_threshold",
        Type = "Float",
        Min = "0",
        Max = "1",
    })
	
	panel:AddControl("CheckBox", {
        Label = "Enable Constraint Removal",
        Command = "spd_removeconstraints",
    });
	panel:AddControl("Label", {
        Text = "Constraint Removal Threshold: The percentage of health when props lose their constraints. Also creates a different effect when a prop is hit below this health."
    })
	panel:AddControl("Slider", {
        Label = "Constraint Removal Threshold",
        Command = "spd_removeconstraints_threshold",
        Type = "Float",
        Min = "0",
        Max = "1",
    })
	
	panel:AddControl("Label", {
        Text = "Enable Particle Effects: Whether or not particle effects are created when a prop is damaged when below a threshold."
    })
	panel:AddControl("CheckBox", {
        Label = "Enable Particle Effects",
        Command = "spd_effects",
    });
	panel:AddControl("ComboBox", {
		Label = "#First Effect",
		MenuButton = "0",
		Options = {
			["#Antlion Gib"] = {spd_effect = "AntlionGib"},
			["#Blood"] = {spd_effect = "BloodImpact"},
			["#Small Sparks"] = {spd_effect = "StunstickImpact"},
			["#Sparks"] = {spd_effect = "cball_bounce"},
			["#Big Sparks"] = {spd_effect = "cball_explode"},
			["#Glass Impact"] = {spd_effect = "GlassImpact"},
			["#Manhack Sparks"] = {spd_effect = "ManhackSparks"},
			["#Flash"] = {spd_effect = "RPGShotDown"},
			["#Strider Blood"] = {spd_effect = "StriderBlood"},
			["#Splash"] = {spd_effect = "watersplash"},
			["#Confetti"] = {spd_effect = "balloon_pop"},
			["#None"] = {spd_effect = "none"}
		}
	})
	panel:AddControl("ComboBox", {
		Label = "#Second Effect",
		MenuButton = "0",
		Options = {
			["#Antlion Gib"] = {spd_effect2 = "AntlionGib"},
			["#Blood"] = {spd_effect2 = "BloodImpact"},
			["#Small Sparks"] = {spd_effect2 = "StunstickImpact"},
			["#Sparks"] = {spd_effect2 = "cball_bounce"},
			["#Big Sparks"] = {spd_effect2 = "cball_explode"},
			["#Glass Impact"] = {spd_effect2 = "GlassImpact"},
			["#Manhack Sparks"] = {spd_effect2 = "ManhackSparks"},
			["#Flash"] = {spd_effect2 = "RPGShotDown"},
			["#Strider Blood"] = {spd_effect2 = "StriderBlood"},
			["#Splash"] = {spd_effect2 = "watersplash"},
			["#Confetti"] = {spd_effect2 = "balloon_pop"},
			["#None"] = {spd_effect2 = "none"}
		}
	})
	
	panel:AddControl("Label", {
        Text = "Enable Explosion Effect: Whether or not an explosion effect is created when a prop is destroyed."
    })
	panel:AddControl("CheckBox", {
        Label = "Enable Explosion Effect",
        Command = "spd_explosion",
    });
	panel:AddControl("ComboBox", {
		Label = "#Explosion Effect",
		MenuButton = "0",
		Options = {
			["#None"] = {spd_explosion_effect = "none"},
			["#Explosion"] = {spd_explosion_effect = "Explosion"},
			["#Helicopter Bomb"] = {spd_explosion_effect = "HelicopterMegaBomb"},
			["#Flash"] = {spd_explosion_effect = "RPGShotDown"},
			["#Antlion Gib"] = {spd_explosion_effect = "AntlionGib"},
			["#Confetti"] = {spd_explosion_effect = "balloon_pop"},
			["#Big Sparks"] = {spd_explosion_effect = "cball_explode"},
			["#Water Surface Explosion"] = {spd_explosion_effect = "WaterSurfaceExplosion"}
		}
	})
	panel:AddControl("Label", {
        Text = "Enable Debris: Whether or not props should leave behind debris when they are destroyed."
    })
	panel:AddControl("CheckBox", {
        Label = "Enable Debris",
        Command = "spd_debris",
    });
end

local function PopulateSPDAdvancedPanel(panel)

	panel:AddControl("ComboBox", {
		Label = "#presets",
		MenuButton = 1,
		Folder = "SPD",
		Options = {
			Default = {
				spd_tool_heal_adminonly = 1,
				spd_tool_toggle_adminonly = 1,
				spd_health_weightratio = 0.5,
				spd_health_volumeratio = 0.5
			}
		},
		CVars = {
			[18] = "spd_tool_heal_adminonly",
			[19] = "spd_tool_toggle_adminonly",
			[20] = "spd_health_weightratio",
			[21] = "spd_health_volumeratio"
		}
	})

	panel:AddControl("Label", {
        Text = "Weight Ratio: The HIGHER this number is, the more base health props will have due to weight. Setting this to 0 means that weight has no effect on prop health. Use the Prop Health multiplier for large-scale tuning of prop health."
    })
	panel:AddControl("Slider", {
        Label = "Weight Ratio",
        Command = "spd_health_weightratio",
        Type = "Float",
        Min = "0",
        Max = "1",
    })
	
	panel:AddControl("Label", {
        Text = "Volume Ratio: The HIGHER this number is, the more base health props will have due to volume. Setting this to 0 means that volume has no effect on prop health. Use the Prop Health multiplier for large-scale tuning of prop health."
    })
	panel:AddControl("Slider", {
        Label = "Volume Ratio",
        Command = "spd_health_volumeratio",
        Type = "Float",
        Min = "0",
        Max = "1",
    })
	
	panel:AddControl("Label", {
        Text = "Admin-Only Tools: Whether or not only admins can use the SPD tools."
    })
	panel:AddControl("CheckBox", {
        Label = "Heal Tool Admin-Only",
        Command = "spd_tool_heal_adminonly",
    });
	panel:AddControl("CheckBox", {
        Label = "Toggle Tool Admin-Only",
        Command = "spd_tool_toggle_adminonly",
    });

end

hook.Add("PopulateToolMenu", "SPD Options", function()
	
	spawnmenu.AddToolMenuOption("Options", "SPD", "Advanced Options", "Advanced Options", "", "", PopulateSPDAdvancedPanel)
	spawnmenu.AddToolMenuOption("Options", "SPD", "Simple Prop Damage", "Simple Prop Damage", "", "", PopulateSPDMainPanel)
	
end)
