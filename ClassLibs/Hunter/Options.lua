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
    CreateNewTitle(thisConfig,"Mavmins Marksmanship");

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Cooldowns->");

    -- Potions
    CreateNewCheck(thisConfig,"Potions","Check if you want to use Potions automatically");
    CreateNewText(thisConfig,"Potions");

    -- Racials
    CreateNewCheck(thisConfig,"Racials","Check if you want to use Bloodfury/Berserking/Arcane Torrent automatically");
    CreateNewText(thisConfig,"Racials");

    -- Rapid Fire
    CreateNewCheck(thisConfig,"Rapid Fire","Check if you want to use Rapid Fire automatically");
    CreateNewText(thisConfig,"Rapid Fire");

    -- Dire Beast
    CreateNewCheck(thisConfig,"Dire Beast","Check if you want to use Dire Beast automatically");
    CreateNewText(thisConfig,"Dire Beast");

    -- A Murder of Crows
    CreateNewCheck(thisConfig,"A Murder of Crows","Check if you want to use A Murder of Crows automatically");
    CreateNewText(thisConfig,"A Murder of Crows");

    -- Stampede
    CreateNewCheck(thisConfig,"Stampede","Check if you want to use Stampede automatically");
    CreateNewText(thisConfig,"Stampede");

    -- Glaive Toss
    CreateNewCheck(thisConfig,"Glaive Toss","Check if you want to use Glaive Toss automatically");
    CreateNewText(thisConfig,"Glaive Toss");

    -- Power Shot
    CreateNewCheck(thisConfig,"Power Shot","Check if you want to use Power Shot automatically");
    CreateNewText(thisConfig,"Power Shot");

    -- Barrage
    CreateNewCheck(thisConfig,"Barrage","Check if you want to use Barrage automatically");
    CreateNewText(thisConfig,"Barrage");

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Defensive->");

    -- Healthstone
    CreateNewCheck(thisConfig,"Healthstone/Potion");
    CreateNewBox(thisConfig, "Healthstone/Potion", 0, 100  , 5, 20, "|cffFFDD11At what %HP to use |cffFFFFFFHealthstone");
    CreateNewText(thisConfig,"Healthstone/Potion");

    -- Misdirection
    CreateNewCheck(thisConfig,"Misdirection");
    CreateNewDrop(thisConfig,"Misdirection", 2,"|cffFFDD11Sets target for |cffFFFFFFMisdirection |cffFFDD11on Aggro", "|cffFFDD11Pet", "|cffFFFF00Focus")
    CreateNewText(thisConfig,"Misdirection");

    -- Feign Death
    CreateNewCheck(thisConfig,"Feign Death");
    CreateNewBox(thisConfig, "Feign Death", 0, 100  , 5, 20, "|cffFFDD11At what %HP to use |cffFFFFFFFeign Death");
    CreateNewText(thisConfig,"Feign Death");

    -- Deterrence
    CreateNewCheck(thisConfig,"Deterrence");
    CreateNewBox(thisConfig, "Deterrence", 0, 100  , 5, 20, "|cffFFDD11At what %HP to use |cffFFFFFFDeterrence");
    CreateNewText(thisConfig,"Deterrence");

    -- Disengage
    CreateNewCheck(thisConfig,"Disengage");
    CreateNewBox(thisConfig, "Disengage", 0, 100  , 5, 20, "|cffFFDD11Auto use |cffFFFFFFDeterrence |cffFFDD11at set range");
    CreateNewText(thisConfig,"Disengage");

    -- Wrapper
    CreateNewWrap(thisConfig,"<-Pet->");

    -- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Summon");
    CreateNewDrop(thisConfig, "Auto Summon", 1, "|cffFFDD11Set to desired |cffFFFFFFPet to Whistle.", "|cffFFDD11Pet 1", "|cffFFDD11Pet 2", "|cffFFDD11Pet 3", "|cffFFDD11Pet 4", "|cffFFDD11Pet 5");
    CreateNewText(thisConfig,"Auto Summon");

    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet");
    CreateNewBox(thisConfig, "Mend Pet", 0, 100  , 5, 75, "|cffFFDD11Under what Pet %HP to use |cffFFFFFFMend Pet");
    CreateNewText(thisConfig,"Mend Pet");

    -- Intimidation
    CreateNewCheck(thisConfig,"Intimidation");
    CreateNewDrop(thisConfig,"Intimidation", 2,"|cffFFDD11Sets how you want |cffFFFFFFIntimidation |cffFFDD11to react.", "|cffFF0000Aggro", "|cff00FF00Interrupt", "|cffFFDD11Both")
    CreateNewText(thisConfig,"Intimidation");
    
    -- Wrapper
    CreateNewWrap(thisConfig,"<-Other->");

    CreateNewCheck(thisConfig,"Trap Launcher","Check if you want to use Trap Launcher");
    CreateNewText(thisConfig,"Trap Launcher");

    -- Explosive Trap
    CreateNewCheck(thisConfig,"Explosive Trap","Check if you want to use Explosive Trap in rotation");
    CreateNewText(thisConfig,"Explosive Trap");

    -- Exotic Munitions
    CreateNewCheck(thisConfig,"Exotic Munitions");
    CreateNewDrop(thisConfig, "Exotic Munitions", 1, "|cffFFDD11Set which ammo to use", "|cffFFDD11Incendiary", "|cffFFDD11Poison", "|cffFFDD11Frozen");
    CreateNewText(thisConfig,"Exotic Munitions");

    -- Auto-Aspect Toggle
    CreateNewCheck(thisConfig,"Auto-Cheetah");
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
function SurvConfig()
    thisConfig = 0
    -- Title
    CreateNewTitle(thisConfig,"Survival Avery");
	
	-- Wrapper
	CreateNewWrap(thisConfig,"Pet");
	
	-- Auto Call Pet Toggle
    CreateNewCheck(thisConfig,"Auto Call Pet");
    CreateNewDrop(thisConfig, "Auto Call Pet", 1, "Set to desired Pet to Whistle.", "Pet 1", "Pet 2", "Pet 3", "Pet 4", "Pet 5");
    CreateNewText(thisConfig,"Auto Call Pet");
    
    -- Mend Pet
    CreateNewCheck(thisConfig,"Mend Pet");
    CreateNewBox(thisConfig, "Mend Pet", 0, 100  , 5, 75, "Under what Pet %HP to use Mend Pet");
    CreateNewText(thisConfig,"Mend Pet");

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