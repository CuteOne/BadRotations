if select(3, UnitClass("player")) == 3 then

-- Config Panel
function BeastConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Beastmaster CodeMyLife");

    -- Wrapper
    CreateNewWrap(thisConfig,"--- Pet Management ---");

    -- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Call Pet");
    CreateNewDrop(thisConfig, "Auto Call Pet", 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.", "|cffFFDD11Pet 1", "|cffFFDD11Pet 2", "|cffFFDD11Pet 3", "|cffFFDD11Pet 4", "|cffFFDD11Pet 5");
    CreateNewText(thisConfig,"Auto Call Pet");

    -- Intimidation
    CreateNewCheck(thisConfig,"Intimidation");
    CreateNewDrop(thisConfig,"Intimidation", 2,"|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.", "|cffFF0000Me.Aggro", "|cff00FF00Always")
    CreateNewText(thisConfig,"Intimidation");
    
    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet");
    CreateNewBox(thisConfig, "Mend Pet", 0, 100  , 5, 75, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet");
    CreateNewText(thisConfig,"Mend Pet");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Cooldowns -----");

    -- Stampede
    CreateNewCheck(thisConfig,"Stampede");
    CreateNewDrop(thisConfig,"Stampede", 2, "CD")
    CreateNewText(thisConfig,"Stampede");

    -- Bestial Wrath
    CreateNewCheck(thisConfig,"Bestial Wrath");
    CreateNewDrop(thisConfig,"Bestial Wrath", 3, "CD")
    CreateNewText(thisConfig,"Bestial Wrath");

    -- Rapid Fire
    CreateNewCheck(thisConfig,"Rapid Fire");
    CreateNewDrop(thisConfig,"Rapid Fire", 2, "CD")
    CreateNewText(thisConfig,"Rapid Fire");

    -- Focus Fire
    CreateNewCheck(thisConfig,"Focus Fire");
    CreateNewDrop(thisConfig,"Focus Fire", 3, "CD")
    CreateNewText(thisConfig,"Focus Fire");

    -- Dire Beast
    CreateNewCheck(thisConfig,"Dire Beast");
    CreateNewBox(thisConfig, "Dire Beast", 0, 120, 5, 65, "|cffFFDD11Focus/120 to use |cffFFFFFFDire Beast.");
    CreateNewText(thisConfig,"Dire Beast");


    -- Wrapper
    CreateNewWrap(thisConfig,"----- DPS Tweaks -----");

    -- Hunter's Mark
    CreateNewCheck(thisConfig,"Hunters Mark");
    CreateNewBox(thisConfig, "Hunters Mark", 1, 10 , 1, 3, "|cffFFDD11Time to wait before |cffFFFFFFHunter's Mark.");
    CreateNewText(thisConfig,"Hunter's Mark");

    -- Serpent Sting
    CreateNewCheck(thisConfig,"Serpent Sting");
    CreateNewText(thisConfig,"Serpent Sting");

    -- Explosive Trap
    CreateNewCheck(thisConfig,"Explosive Trap");
    CreateNewDrop(thisConfig,"Explosive Trap", 2,"|cffFFDD11Sets how you want |cffFFFFFFExplosive Trap |cffFFDD11to react.", "|cffFF0000Never", "|cffFFDD113 mobs", "|cff00FF00Always")
    CreateNewText(thisConfig,"Explosive Trap");

    -- Wrapper
    CreateNewWrap(thisConfig,"------ Defensive -------");

    -- Misdirection
    CreateNewCheck(thisConfig,"Misdirection");
    CreateNewDrop(thisConfig,"Misdirection", 2,"|cffFFDD11Sets how you want |cffFFFFFFMisdirection |cffFFDD11to react.", "|cffFF0000Me.Aggro", "|cffFFDD11Any.Aggro", "|cffFFFF00Enforce", "|cff00FF00Always")
    CreateNewText(thisConfig,"Misdirection");

    -- Feign Death
    CreateNewCheck(thisConfig,"Feign Death");
    CreateNewBox(thisConfig, "Feign Death", 0, 100  , 5, 20, "|cffFFDD11Under what %HP to use |cffFFFFFFFeign Death");
    CreateNewText(thisConfig,"Feign Death");

    -- Deterrence
    CreateNewCheck(thisConfig,"Deterrence");
    CreateNewBox(thisConfig, "Deterrence", 0, 100  , 5, 20, "|cffFFDD11Under what %HP to use |cffFFFFFFDeterrence");
    CreateNewText(thisConfig,"Deterrence");


    -- Wrapper
    CreateNewWrap(thisConfig,"-------- Utilities -------");

    -- Auto-Aspect Toggle
    CreateNewCheck(thisConfig,"Auto-Cheetah");
    CreateNewBox(thisConfig, "Auto-Cheetah", 1, 10, 1, 3, "|cffFFDD11How long do you want to run before enabling |cffFFFFFFAspect of the Cheetah.");
    CreateNewText(thisConfig,"Auto-Cheetah");

    -- Standard Interrupt
    CreateNewCheck(thisConfig,"Counter Shot");
    CreateNewBox(thisConfig, "Counter Shot", 0, 100  , 5, 35 , "|cffFFDD11Over what % of cast we want to |cffFFFFFFCounter Shot.");
    CreateNewText(thisConfig,"Counter Shot");


    -- General Configs
    CreateGeneralsConfig();

    WrapsManager();
end

-- Config Panel
function MarkConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Survival Avery");

    -- Wrapper
    CreateNewWrap(thisConfig,"Pet Management");

    -- General Configs
    CreateGeneralsConfig();
    WrapsManager();
end

-- Config Panel
function SurvConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Survival Avery");

	-- Wrapper
	CreateNewWrap(thisConfig,"AoE");

	--automatic aoe
	CreateNewCheck(thisConfig,"AutoAoE","Check if you want to use automatic AoE, tarplus/minus wont do anything until you toggle this off");
	CreateNewText(thisConfig,"Auto AoE"); 

	-- tar+
	CreateNewCheck(thisConfig,"Rotation Up","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
	CreateNewDrop(thisConfig,"Rotation Up", 1, "Toggle")
	CreateNewText(thisConfig,"Tar Plus");

	-- tar-
	CreateNewCheck(thisConfig,"Rotation Down","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
	CreateNewDrop(thisConfig,"Rotation Down", 2, "Toggle")
	CreateNewText(thisConfig,"Tar Minus");

    -- General Configs
    CreateGeneralsConfig();
    WrapsManager();
end

end