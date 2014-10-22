if select(3,UnitClass("player")) == 6 then
--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[        ]]
--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[         ]]
--[[]]	   --[[]]	--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]    --[[]]
--[[         ]]		--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]
--[[]]	   --[[]]	--[[]]				--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	  --[[]]
--[[           ]]	--[[]]				--[[           ]]	--[[           ]]	--[[         ]]
--[[           ]] 	--[[           ]]	--[[           ]]	--[[           ]]	--[[        ]]

function BloodOptions()

	--[[This function will create a Value Box.]]
	--[[Crée une Value Box.]]
	-- function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)

	--[[This function will create a Check Box.]]
	--[[Crée une Check Box]]
	-- function CreateNewCheck(value, textString, tip1)

	--[[This function will create a Menu, up to 10 values can be passed.]]
	--[[Cette fonction crée une MenuBox, jusqu'à 10 valeurs peuvent y être passées.]]
	-- function CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)

	--[[This function will create the TextString.]]
	--[[This function must always be last, it will increase table row.]]
	--[[Toujours terminer avec un Text pour augmenter de rangée]]
	-- function CreateNewText(value, textString)

	--[[This function will create the Title String.]]
	--[[This function will use table row #1.]]
	--[[Cette fonction utilise la rangée du Haut]]
	-- function CreateNewTitle(value, textString)

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

    -- Strangulate
    if isKnown(_Strangulate) then
	    CreateNewCheck(thisConfig,"Strangulate");
	    CreateNewBox(thisConfig, "Strangulate", 0, 100  , 5, 35 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFStrangulate.");
	    CreateNewText(thisConfig,"Strangulate");
	end


    -- General Configs
    CreateGeneralsConfig();

    WrapsManager();
end

function FrostOptions()
if currentConfig ~= "Frost Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Frost |cffFF0000Chumii");

-- Wrapper
CreateNewWrap(thisConfig,"-------- General Rotation --------");

-- Pause Toggle
CreateNewCheck(thisConfig,"Pause Toggle");
CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
CreateNewText(thisConfig,"Pause Key");

-- Death and Decay
CreateNewCheck(thisConfig,"DnD_Key");
CreateNewDrop(thisConfig,"DnD_Key", 2, "Toggle2")
CreateNewText(thisConfig,"Death and Decay Key");

-- Dummy DPS Test
CreateNewCheck(thisConfig,"DPS Testing");
CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
CreateNewText(thisConfig,"DPS Testing");

-- General Configs
CreateGeneralsConfig();

WrapsManager();
end
end

--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]] 	--[[           ]]	--[[           ]]
--[[]]	  			--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]				     --[[ ]]
--[[         ]]		--[[         ]]	    --[[]]	   --[[]]	--[[           ]]		 --[[ ]]
--[[       	 ]]		--[[        ]]		--[[]]	   --[[]]			   --[[]]	 	 --[[ ]]
--[[]]				--[[]]	  --[[]]	--[[           ]]	--[[           ]]	 	 --[[ ]]
--[[]] 				--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]

--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[         ]] 	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[]]	   --[[]]	--[[           ]] 	--[[]]				--[[]]	  --[[]]
--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[           ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[]]	   --[[]]	--[[           ]]	 --[[         ]]	--[[]]	   --[[]]	--[[]]				   --[[    ]]
--[[]]	   --[[]]	--[[           ]]	--[[           ]]	--[[]]	   --[[]]	--[[]]			  		 --[[]]
--[[           ]]	--[[]]	 --[[  ]]	--[[]]	   --[[]]	--[[           ]]	--[[           ]]		 --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	 --[[         ]]	--[[           ]]		 --[[]]


end