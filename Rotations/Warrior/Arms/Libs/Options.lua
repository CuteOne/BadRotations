if select(3, UnitClass("player")) == 1 then
  if GetSpecialization() == 1 then
    function WarriorArmsConfig()
      if currentConfig ~= "Arms Chumii" then
        ClearConfig();
        thisConfig = 0;
        -- Title
        CreateNewTitle(thisConfig,"Arms |cffFF0000Chumii");

        -- Wrapper
        CreateNewWrap(thisConfig,"-------- General Rotation --------");

        --Multi-Rend
        CreateNewCheck(thisConfig,"Multi-Rend","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRend spreading|cffFFBB00.");
        CreateNewText(thisConfig,"Multi-Rend");

        -- Pause Toggle
        CreateNewCheck(thisConfig,"Pause Key");
        CreateNewDrop(thisConfig,"Pause Key", 4, "Toggle")
        CreateNewText(thisConfig,"Pause Key");

        -- Heroic Leap
        CreateNewCheck(thisConfig,"Heroic Leap Key");
        CreateNewDrop(thisConfig,"Heroic Leap Key", 2, "Toggle2")
        CreateNewText(thisConfig,"Heroic Leap Key");

        -- Ravager
        CreateNewCheck(thisConfig,"Ravager Key");
        CreateNewDrop(thisConfig,"Ravager Key", 2, "Toggle2")
        CreateNewText(thisConfig,"Ravager Key");

        -- Wrapper
        CreateNewWrap(thisConfig,"---------- Buffs ---------");

        -- Shout
        CreateNewCheck(thisConfig,"Shout");
        CreateNewDrop(thisConfig, "Shout", 2, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
        CreateNewText(thisConfig,"Shout");

        -- Wrapper
        CreateNewWrap(thisConfig,"------ Cooldowns ------");

        -- Potion
        CreateNewCheck(thisConfig,"Use Potion");
        CreateNewText(thisConfig,"Use Potion");

        -- Recklessness
        CreateNewCheck(thisConfig,"Recklessness");
        CreateNewText(thisConfig,"Recklessness");

        -- Avatar
        CreateNewCheck(thisConfig,"Avatar");
        CreateNewText(thisConfig,"Avatar");

        -- Racial
        CreateNewCheck(thisConfig,"Racial (Orc / Troll)");
        CreateNewText(thisConfig,"Racial (Orc / Troll)");

        -- StormBolt
        CreateNewCheck(thisConfig,"StormBolt");
        CreateNewText(thisConfig,"StormBolt");

        -- Trinket
        CreateNewCheck(thisConfig,"Use Trinket");
        CreateNewText(thisConfig,"Use Trinket");

        -- Wrapper
        CreateNewWrap(thisConfig,"------- Defensive ------");

        -- Die by the Sword
        CreateNewCheck(thisConfig,"Die by the Sword");
        CreateNewBox(thisConfig, "Die by the Sword", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword");
        CreateNewText(thisConfig,"Die by the Sword");

        -- Rallying Cry
        CreateNewCheck(thisConfig,"Rallying Cry");
        CreateNewBox(thisConfig, "Rallying Cry", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry");
        CreateNewText(thisConfig,"Rallying Cry");

        -- Enraged Regeneration
        CreateNewCheck(thisConfig,"Enraged Regeneration");
        CreateNewBox(thisConfig, "Enraged Regeneration", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration");
        CreateNewText(thisConfig,"Enraged Regeneration");

        -- ImpendingVictory/Victory Rush
        CreateNewCheck(thisConfig,"Impending Victory");
        CreateNewBox(thisConfig, "Impending Victory", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)");
        CreateNewText(thisConfig,"Impending Victory");

        -- Vigilance Focus
        CreateNewCheck(thisConfig,"Vigilance on Focus");
        CreateNewBox(thisConfig, "Vigilance on Focus", 0, 100  , 5, 25, "% HP of Focustarget to use Vigilance on Focustarget");
        CreateNewText(thisConfig,"Vigilance on Focus");

        -- Def Stance
        CreateNewCheck(thisConfig,"Defensive Stance");
        CreateNewBox(thisConfig, "Defensive Stance", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance");
        CreateNewText(thisConfig,"Defensive Stance");

        -- Healthstone
        CreateNewCheck(thisConfig,"Healthstone");
        CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
        CreateNewText(thisConfig,"Healthstone");

        -- Wrapper
        CreateNewWrap(thisConfig,"-------- Interrupts --------");

        -- Pummel
        CreateNewCheck(thisConfig,"Pummel");
        CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
        CreateNewText(thisConfig,"Pummel");

        -- Disrupting Shout
        CreateNewCheck(thisConfig,"Disrupting Shout");
        CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.");
        CreateNewText(thisConfig,"Disrupting Shout");


        -- Wrapper
        CreateNewWrap(thisConfig,"---------- Misc -----------");

        -- Auto Bladestorm / DragonRoar Single Target
        CreateNewCheck(thisConfig,"Single BS/DR/RV");
        CreateNewText(thisConfig,"Single BS/DR/RV")

        -- Dummy DPS Test
        CreateNewCheck(thisConfig,"DPS Testing");
        CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
        CreateNewText(thisConfig,"DPS Testing");

        -- Healing/general/poke/hacks/tracking
        CreateGeneralsConfig();
        WrapsManager();

      end
    end
  end


end
