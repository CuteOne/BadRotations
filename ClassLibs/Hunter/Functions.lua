if select(3, UnitClass("player")) == 3 then
--[[           ]]   --[[]]     --[[]]   --[[]]     --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[]]     --[[]]
--[[           ]]   --[[]]     --[[]]   --[[  ]]   --[[]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[           ]]   --[[  ]]   --[[]]
--[[]]              --[[]]     --[[]]   --[[    ]] --[[]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[    ]] --[[]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[           ]]   --[[]]     --[[]]   --[[           ]]   --[[]]                   --[[ ]]             --[[ ]]        --[[]]     --[[]]   --[[           ]]
--[[]]              --[[           ]]   --[[]]   --[[  ]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]   --[[  ]]
--[[]]              --[[           ]]   --[[]]     --[[]]   --[[           ]]        --[[ ]]        --[[           ]]   --[[           ]]   --[[]]     --[[]]

--[[           ]]	--[[           ]]		  --[[]]		--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	     --[[  ]]		--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]				    --[[    ]] 		--[[]]					 --[[ ]]
--[[         ]]		--[[           ]]	   --[[      ]] 	--[[           ]]		 --[[ ]]
--[[]]	   --[[]]	--[[]]				  --[[        ]]			   --[[]]		 --[[ ]]
--[[           ]]	--[[           ]]	 --[[]]    --[[]]	--[[           ]]		 --[[ ]]		
--[[           ]] 	--[[           ]]	--[[]]      --[[]]	--[[           ]]		 --[[ ]]

-- Aoe Button
if  AoEModesLoaded ~= "CML Beast AoE Modes" then 
    AoEModes = { 
        [1] = { mode = "Sin", value = 1 , overlay = "Single Target Enabled", tip = "Recommended for one or two targets.", highlight = 0 },
        [2] = { mode = "AoE", value = 2 , overlay = "AoE Enabled", tip = "Recommended for three targets or more.", highlight = 0 },
        [3] = { mode = "Auto", value = 3 , overlay = "Auto-AoE Enabled", tip = "Recommended for lazy people like me.", highlight = 1 }
    };
    AoEModesLoaded = "CML Beast AoE Modes";
end
-- Interrupts Button
if  InterruptsModesLoaded ~= "CML Beast Interrupts Modes" then 
    InterruptsModes = { 
        [1] = { mode = "None", value = 1 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0 },
        [2] = { mode = "All", value = 2 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1 }
    };
    InterruptsModesLoaded = "CML Beast Interrupts Modes";
end

-- Defensive Button
if  DefensiveModesLoaded ~= "CML Beast Defensive Modes" then 
    DefensiveModes = { 
        [1] = { mode = "None", value = 1 , overlay = "Defensive Disabled", tip = "No Defensive Cooldowns will be used.", highlight = 0 },
        [2] = { mode = "All", value = 2 , overlay = "Defensive Enabled", tip = "Includes Deterrence and Feign Death.", highlight = 1 }
    };
    DefensiveModesLoaded = "CML Beast Defensive Modes";
end
-- Cooldowns Button
if  CooldownsModesLoaded ~= "CML Beast Cooldowns Modes" then 
    CooldownsModes = { 
        [1] = { mode = "None", value = 1 , overlay = "Cooldowns Disabled", tip = "No cooldowns will be used.", highlight = 0 },
        [2] = { mode = "User", value = 2 , overlay = "User Cooldowns Enabled", tip = "Includes config's selected spells.", highlight = 1 },
        [3] = { mode = "All", value = 3 , overlay = "Cooldowns Enabled", tip = "Includes Rapid Fire, Bestial Wrath and Focus Fire.", highlight = 1 }
    };
    CooldownsModesLoaded = "CML Beast Cooldowns Modes";
end

_AimedShot                = 19434;
_AMurderOfCrows           = 131894;
_ArcaneShot               = 3044; 
_AspectOfTheHawk          = 13165;
_AspectOfTheCheetah       = 5118;
_AspectOfTheIronHawk      = 109260;
_AspectOfThePack          = 13159; 
_Barrage                  = 120360;
_BestialWrath             = 19574;
_BindingShot              = 109248; 
_BlackArrow               = 3674;
_CallPet1                 = 883;
_CallPet2                 = 83242;
_CallPet3                 = 83243;
_CallPet4                 = 83244;
_CallPet5                 = 83245;
_Camouflage               = 51753;
_ChimeraShot              = 53209;
_CobraShot                = 77767; 
_ConcussiveShot           = 5116;
_CounterShot              = 147362;
_Deterrence               = 19263;
_DireBeast                = 120679;
_Disengage                = 781;
_DismissPet               = 2641; 
_DistractingShot          = 20736;
_EagleEye                 = 6197; 
_ExplosiveShot            = 53301; 
_FeignDeath               = 5384; 
_Fervor                   = 82726;
_Flare                    = 1543;
_FocusFire                = 82692;
_GlaiveToss               = 117050; 
_HeartOfThePhoenix        = 55709;
_HuntersMark              = 1130; 
_KillCommand              = 34026;
_KillShot                 = 53351;
_LynxRush                 = 120697;
_MastersCall              = 53271;
_MendPet                  = 136; 
_Misdirection             = 34477;
_MultiShot                = 2643;
_PowerShot                = 109259;
_RapidFire                = 3045;
_RevivePet                = 982; 
_ScareBeast               = 1513;
_ScatterShot              = 19503; 
_SerpentSting             = 1978;
_SilencingShot            = 34490;
_Stampede                 = 121818; 
_SteadyShot               = 56641;
_TameBeast                = 1515; 
_TranquilizingShot        = 19801; 
_TrapLauncher             = 77769; 
_TrapLauncherExplosive    = 82939;
_TrapLauncherFreezing     = 60192;
_TrapLauncherIce          = 82941;
_TrapLauncherSnakes       = 82948; 
_TrapExplosive            = 13813; 
_TrapFreezing             = 1499;
_TrapIce                  = 13809;
_TrapSnakes               = 34600; 
_WidowVenom               = 82654; 

function AutoCallPet()
    if BadBoy_data["Check Auto Call Pet"] ~= 1 then 
        autoCallPetValue = 7; 
    else
    --if tryWhistle == nil then tryWhistle = 0; end
   --[[ if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) and tryWhistle <= GetTime() then
        if GetUnitSpeed("player") == 0 then
            tryWhistle = (GetTime()+3);
            autoCallPetValue = 0;
            return;
        end
    end]]
        if (not UnitExists("pet") or UnitIsDeadOrGhost("pet")) then
            if BadBoy_data["Box Auto Call Pet"] == 1 then
                autoCallPetValue = 1;
            elseif BadBoy_data["Box Auto Call Pet"] == 2 then
                autoCallPetValue = 2;
            elseif BadBoy_data["Box Auto Call Pet"] == 3 then
                autoCallPetValue = 3;
            elseif BadBoy_data["Box Auto Call Pet"] == 4 then
                autoCallPetValue = 4;
            elseif BadBoy_data["Box Auto Call Pet"] == 5 then
                autoCallPetValue = 5;
            end
        else
            autoCallPetValue = 6;
        end
    end
end

function Cooldowns()
    local bestialWrath = 19574;
    local rapidFire = 3045;
    local focusFire = 82692;
    local frenzyStacks = 19615;
    local killCommand = 34026;
    local beastWithin = 34471;
    -- Bestial Wrath
    if BadBoy_data["Check Bestial Wrath"] == 1
      and GetSpellCD(bestialWrath) < 1
      and GetSpellCD(killCommand) < 2
      and (BadBoy_data["Box Bestial Wrath"] and GetFocus() > BadBoy_data["Box Bestial Wrath"]) then
        cooldownValue = 1;
    -- Focus Fire
    elseif BadBoy_data["Check Focus Fire"] == 1
      and select(4,UnitBuffID("player",frenzyStacks)) == 5
      and not (UnitBuffID("player", beastWithin) and GetFocus() > 12)-- Not under Beast Within
      and GetSpellCD(killCommand) > 1 -- Kill Command CD over 1 sec
      and (GetSpellCD(bestialWrath) > 20 or BadBoy_data["Check Bestial Wrath"] == 0) -- Bestial Wrath CD over 20 sec
      and UnitBuffID("player", rapidFire) ~= true -- not under Rapid Fire
      and GetSpellCD(rapidFire) >= 5 then -- Rapid Fire CD over 5 sec
        cooldownValue = 2;
    else
        cooldownValue = 0;
    end
end

function Misdirection()
	if BadBoy_data["Box Misdirection"] ~= nil then local MisdirectionValue = BadBoy_data["Box Misdirection"]; end
	if BadBoy_data["Box Misdirection"] ~= 0 and UnitExists("target") and UnitIsUnit("player","target") ~= 1 then
		local MisdirectionTarget = nil
		if UnitExists("focus") and not UnitIsDeadOrGhost("focus") then
			MisdirectionTarget = "focus"
		elseif UnitExists("pet") and not UnitIsDeadOrGhost("pet") then
		    MisdirectionTarget = "pet"
		end	
	  	if UnitThreatSituation("player", "target") == 3 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end
	  	if UnitThreatSituation("player", "target") == 1 and MisdirectionValue == 2 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end
	  	if MisdirectionValue == 3 then
			if MisdirectionTarget ~= nil then
				if castSpell(MisdirectionTarget,_Misdirection) then return; end
			end
	  	end  	
	end
end

--[[]]     --[[]] 		  --[[]]		--[[           ]]	--[[]]	   --[[]]	--[[           ]]
--[[ ]]   --[[ ]] 		 --[[  ]] 		--[[           ]]	--[[]]	  --[[]]	--[[           ]]
--[[           ]] 	    --[[    ]]		--[[]]	   --[[]]	--[[        ]]		--[[]]
--[[           ]]	   --[[      ]] 	--[[           ]] 	--[[    ]] 			--[[           ]]
--[[]] 	   --[[]]	  --[[        ]]	--[[        ]]		--[[        ]]				   --[[]]
--[[]]	   --[[]]	 --[[]]    --[[]]	--[[]]	  --[[]]	--[[]]	  --[[]]	--[[           ]]
--[[]]	   --[[]]	--[[]]      --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[           ]]

--[[           ]] 	--[[]]	   --[[]]	--[[           ]]  	--[[]]	   --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	--[[]]	   --[[]]
--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[]]	  --[[]]
--[[           ]] 	--[[]]	   --[[]]	--[[           ]] 	 --[[]]	  --[[]]
	   	   --[[]]	--[[]]	   --[[]]	--[[        ]]		  --[[]] --[[]]
--[[           ]] 	--[[           ]] 	--[[]]	  --[[]]	  --[[       ]]
--[[           ]] 	--[[           ]] 	--[[]]	   --[[]]	   --[[     ]]








end
