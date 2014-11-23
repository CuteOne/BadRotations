if select(3,UnitClass("player")) == 6 then

function BloodOptions()

    ClearConfig();

    thisConfig = 0;
    -- Title
    CreateNewTitle(thisConfig,"Blood CodeMyLife");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Buffs -----");

    -- Horn of Winter
    if isKnown(_HornOfWinter) then
    	CreateNewCheck(thisConfig,"Horn of Winter");
    	CreateNewText(thisConfig,"Horn of Winter");
    end

    -- Blood Presence
    if isKnown(_BloodPresence) then
    	CreateNewCheck(thisConfig,"Presence");
        CreateNewDrop(thisConfig, "Presence", 1, "Choose Presence to use.", "|cffFF0000Blood", "|cff00EEFFFrost")
    	CreateNewText(thisConfig,"Presence");
	else
        CreateNewCheck(thisConfig,"Frost Presence");
        CreateNewText(thisConfig,"Frost Presence");
    end
    -- Bone Shield
    if isKnown(_BoneShield) then
	    CreateNewCheck(thisConfig,"Bone Shield");
	    CreateNewText(thisConfig,"Bone Shield");
	end

    -- Wrapper
    CreateNewWrap(thisConfig,"----- Cooldowns -----")

    -- Raise Dead
    CreateNewCheck(thisConfig,"Raise Dead");
    CreateNewDrop(thisConfig, "Raise Dead", 1, "CD")
    CreateNewText(thisConfig,"Raise Dead");

    -- Wrapper
    CreateNewWrap(thisConfig,"----- DPS Tweaks -----")

    -- Death And Decay
    if isKnown(_DeathAndDecay) then
	    CreateNewCheck(thisConfig,"Death And Decay");
	    CreateNewDrop(thisConfig, "Death And Decay", 1, "CD")
	    CreateNewText(thisConfig,"Death And Decay");
	end

    -- Wrapper
    CreateNewWrap(thisConfig,"------ Defensive -------");

    -- Anti-Magic Shell
    if isKnown(_AntiMagicShell) then
	    CreateNewCheck(thisConfig,"Anti-Magic Shell");
	    CreateNewBox(thisConfig, "Anti-Magic Shell", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFAnti-Magic Shell");
	    CreateNewText(thisConfig,"Anti-Magic Shell");
	end

    -- Conversion
    if isKnown(_Conversion) then
    	CreateNewCheck(thisConfig,"Conversion");
    	CreateNewBox(thisConfig, "Conversion", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFConversion");
    	CreateNewText(thisConfig,"Conversion");
    end

    -- Dancing Rune Weapon
    if isKnown(_DancingRuneWeapon) then
    	CreateNewCheck(thisConfig,"Dancing Rune Weapon");
   	 	CreateNewBox(thisConfig, "Dancing Rune Weapon", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDancing Rune Weapon");
    	CreateNewText(thisConfig,"Dancing Rune Weapon");
	end

    -- Empower Rune Weapon
    if isKnown(_EmpowerRuneWeapon) then
    	CreateNewCheck(thisConfig,"Empower Rune Weapon");
   	 	CreateNewBox(thisConfig, "Empower Rune Weapon", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEmpower Rune Weapon");
    	CreateNewText(thisConfig,"Empower Rune Weapon");
	end

    -- Icebound Fortitude
    if isKnown(_IceboundFortitude) then
	    CreateNewCheck(thisConfig,"Icebound Fortitude");
	    CreateNewBox(thisConfig, "Icebound Fortitude", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFIcebound Fortitude");
	    CreateNewText(thisConfig,"Icebound Fortitude");
	end

    -- Rune Tap
    if isKnown(_RuneTap) then
	    CreateNewCheck(thisConfig,"Rune Tap");
	    CreateNewBox(thisConfig, "Rune Tap", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFRune Tap");
	    CreateNewText(thisConfig,"Rune Tap");
	end

    -- Vampiric Blood
    if isKnown(_VampiricBlood) then
	    CreateNewCheck(thisConfig,"Vampiric Blood");
	    CreateNewBox(thisConfig, "Vampiric Blood", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFVampiric Blood");
	    CreateNewText(thisConfig,"Vampiric Blood");
	end

   -- Wrapper
    CreateNewWrap(thisConfig,"-------- Healing -------");

    -- Death Siphon
    CreateNewCheck(thisConfig,"Death Siphon");
    CreateNewBox(thisConfig, "Death Siphon", 0, 100  , 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDeath Siphon");
    CreateNewText(thisConfig,"Death Siphon");


    -- Wrapper
    CreateNewWrap(thisConfig,"-------- Utilities -------");

    -- Mind Freeze
    if isKnown(_MindFreeze) then
	    CreateNewCheck(thisConfig,"Mind Freeze");
	    CreateNewBox(thisConfig, "Mind Freeze", 0, 100  , 5, 35 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFMind Freeze.");
	    CreateNewText(thisConfig,"Mind Freeze");
	end

    -- General Configs
    CreateGeneralsConfig();

    WrapsManager();
end

end