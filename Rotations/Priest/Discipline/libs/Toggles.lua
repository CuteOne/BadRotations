if select(3, UnitClass("player")) == 5 then

  function DisciplineToggles()
    -- -- Halo Button
    -- if HaloModesLoaded ~= "Discipline Priest Halo Modes" then
    -- 	HaloModes = {
    -- 		[1] = { mode = "off", value = 1 , overlay = "Halo Disabled", tip = "|cffFF0000Halo/Star/Cascade \n|cffFFDD11wont be used.", highlight = 0, icon = 120644 },
    -- 		[2] = { mode = "on", value = 2 , overlay = "Halo Enabled", tip = "|cff00FF00Halo/Star/Cascade \n|cffFFDD11will be used.", highlight = 1, icon = 120644 }
    -- 	};
    -- 	CreateButton("Halo",1,1)
    -- 	HaloModesLoaded = "Discipline Priest Halo Modes";
    -- end

    -- -- DoT Button
    -- if DoTModesLoaded ~= "Discipline Priest DoT Modes" then
    -- 	DoTModes = {
    -- 		[1] = { mode = "off", value = 1 , overlay = "DotEmAll off", tip = "|cffFF0000No Multidot \n|cffFFDD11This modes are only for \nSingleTarget=1 and Rotation=weave \n\n|cffFF0000This stuff is experimental!", highlight = 0, icon = 155271 },
    -- 		[2] = { mode = "SWP", value = 2 , overlay = "SWP only on", tip = "|cff00FF00SWP only \n|cffFFDD11Dots all Targets with SWP.\nSet min. health in Options", highlight = 1, icon = 589 },
    -- 		[3] = { mode = "VT", value = 3 , overlay = "VT only on", tip = "|cff00FF00VT only \n|cffFFDD11Dots all Targets with VT.\nSet min. health in Options", highlight = 1, icon = 34914 },
    -- 		[4] = { mode = "All", value = 4 , overlay = "DotEmAll", tip = "|cff00FF00SWP&VT \n|cffFFDD11Dots all Targets with SWP&VT.\nSet min. health in Options", highlight = 1, icon = 165370 }
    -- 	};
    -- 	CreateButton("DoT",2,0)
    -- 	DoTModesLoaded = "Discipline Priest DoT Modes";
    -- end

    -- -- Single Rotation Button
    -- if SingleModesLoaded ~= "Discipline Priest Single Modes" then
    -- 	SingleModes = {
    -- 		[1] = { mode = "weave", value = 1 , overlay = "weave rotation", tip = "|cffFF0000Single Target Rotation \n|cffFFDD11DoT-Weave Rotation is active. \nPress to change rotation to Traditional", highlight = 0, icon = 73510 }
    -- 		--[1] = { mode = "trad", value = 1 , overlay = "traditional rotation", tip = "|cffFF0000Single Target Rotation \n|cffFFDD11Traditional Rotation is active. \nPress to change rotation to DoT-Weave", highlight = 0, icon = 15407 },
    -- 		--[2] = { mode = "weave", value = 2 , overlay = "weave rotation", tip = "|cffFF0000Single Target Rotation \n|cffFFDD11DoT-Weave Rotation is active. \nPress to change rotation to Traditional", highlight = 0, icon = 73510 }
    -- 	};
    -- 	--CreateButton("Single",3,1)
    -- 	CreateButton("Single",0,1)
    -- 	SingleModesLoaded = "Discipline Priest Single Modes";
    -- end

    -- -- Rotation Button
    -- if RotationModesLoaded ~= "Discipline Priest Rotation Modes" then
    -- 	RotationModes = {
    -- 		[1] = { mode = "std", value = 1 , overlay = "Single Target", tip = "|cff00FF00Single Target \n|cffFFDD11Style can be chosen with 'trad/weave' Button", highlight = 0, icon = 139139 },
    -- 		--[2] = { mode = "dual", value = 2 , overlay = "Dual Boss Targets", tip = "|cff00FF00Dual Target \n|cffFFDD11Chose this for two bosses", highlight = 0, icon = 78203 },
    -- 		--[2] = { mode = "3+", value = 2 , overlay = "3+ Targets", tip = "|cff00FF002+ Enemies \n|cffFFDD11Choose # of dots in options.", highlight = 0, icon = 48045 }
    -- 		--[2] = { mode = "multi", value = 2 , overlay = "Multi Target", tip = "|cff00FF00Multi Target \n|cffFFDD11Choose # of dots in options.", highlight = 0, icon = 48045 }
    -- 		[2] = { mode = "beta", value = 2 , overlay = "Beta Rotation", tip = "|cff00FF00Beta Rotation \n|cffFFDD11This is in development", highlight = 0, icon = 78203 },
    -- 	};
    -- 	CreateButton("Rotation",3,0)
    -- 	RotationModesLoaded = "Discipline Priest Rotation Modes";
    -- end

    -- Feather Button
    if FeathertModesLoaded ~= "Discipline Priest Feather Modes" then
      FeatherModes = {
        [1] = { mode = "off", value = 1 , overlay = "Feather Disabled", tip = "|cffFF0000Feather", highlight = 0, icon = 121536 },
        [2] = { mode = "auto", value = 2 , overlay = "Feather Auto", tip = "|cff00FF00Feather", highlight = 1, icon = 121536 }
      };
      --CreateButton("Feather",0,1)
      CreateButton("Feather",3,1)
      FeatherModesLoaded = "Discipline Priest Feather Modes";
    end

    -- Cooldowns Button
    if CooldownsModesLoaded ~= "Discipline Priest Cooldowns Modes" then
      CooldownsModes = {
        [1] = { mode = "off", value = 1 , overlay = "Cooldowns Disabled", tip = "|cffFF0000Cooldowns \n|cffFFDD11No cooldowns will be used.", highlight = 0, icon = 34433 },
        [2] = { mode = "on", value = 2 , overlay = "Cooldowns Enabled", tip = "|cff00FF00Cooldowns \n|cffFFDD11Only used if enabled in Settings. \n|cffFF0000Spells Included: \n|cffFFDD11Power Infusion \nShadowfiend \nMindbender", highlight = 1, icon = 34433 }
      };
      CreateButton("Cooldowns",2,1)
      CooldownsModesLoaded = "Discipline Priest Cooldowns Modes";
    end

    -- Defensive Button
    if DefensiveModesLoaded ~= "Discipline Priest Defensive Modes" then
      DefensiveModes = {
        [1] = { mode = "off", value = 1, overlay = "Defensive Disabled", tip = "|cffFF0000Defensive \n|cffFFDD11No Defensive Cooldowns will be used.", highlight = 0, icon = 17 },
        [2] = { mode = "on", value = 2, overlay = "Defensive Enabled", tip = "|cff00FF00Defensive \n|cffFF0000Spells Included: \n|cffFFDD11Power Word: Shield \nFade (glyphed) \nDesperate Prayer \nHealthstone", highlight = 1, icon = 17 }
      };
      CreateButton("Defensive",1,0)
      DefensiveModesLoaded = "Discipline Priest Defensive Modes";
    end


  end -- END TOGGLES




  -- handle specific toggles
  function SpecificToggle(toggle)
    if getValue(toggle) == 1 then
      return IsLeftControlKeyDown();
    elseif getValue(toggle) == 2 then
      return IsLeftShiftKeyDown();
    elseif getValue(toggle) == 3 then
      return IsLeftAltKeyDown();
    elseif getValue(toggle) == 4 then
      return IsRightControlKeyDown();
    elseif getValue(toggle) == 5 then
      return IsRightShiftKeyDown();
    elseif getValue(toggle) == 6 then
      return IsRightAltKeyDown();
    elseif getValue(toggle) == 7 then
      return 1
    end
  end

end
