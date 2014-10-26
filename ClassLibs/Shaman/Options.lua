if select(3,UnitClass("player")) == 7 then
--[[           ]]	--[[]]				--[[           ]]
--[[           ]]	--[[]]				--[[           ]]
--[[]]				--[[]]				--[[]]
--[[           ]]	--[[]]				--[[           ]]
--[[]]				--[[]]				--[[]]
--[[           ]]	--[[]]				--[[           ]]
--[[           ]] 	--[[           ]]	--[[           ]]

--[[This function will create a Value Box.]]
-- function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)

--[[This function will create a Check Box.]]
-- function CreateNewCheck(value, textString, tip1)

--[[This function will create a Menu, up to 10 values can be passed.]]
-- function CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)

--[[This function will create the TextString.
This function must always be last, it will increase table row.]]
-- function CreateNewText(value, textString)

--[[This function will create the Title String.
This function will use table row #1.]]
-- function CreateNewTitle(value, textString)

function ElementalConfig()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"Elemental CodeMyLife");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- Buffs -----");

        -- Flametongue Weapon
        CreateNewCheck(thisConfig,"Flametongue Weapon");
        CreateNewText(thisConfig,"Flametongue Weapon");

        -- Lightning Shield
        CreateNewCheck(thisConfig,"Lightning Shield");
        CreateNewText(thisConfig,"Lightning Shield");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- Cooldowns -----")

        -- Ascendance
        CreateNewCheck(thisConfig,"Ascendance");
        CreateNewDrop(thisConfig, "Ascendance", 1, "CD")
        CreateNewText(thisConfig,"Ascendance");

        -- Fire Elemental
        CreateNewCheck(thisConfig,"Fire Elemental");
        CreateNewDrop(thisConfig, "Fire Elemental", 1, "CD")
        CreateNewText(thisConfig,"Fire Elemental");

        -- Stormlash
        CreateNewCheck(thisConfig,"Stormlash");
        CreateNewDrop(thisConfig, "Stormlash", 1, "CD")
        CreateNewText(thisConfig,"Stormlash");

        -- Unleash Element
        CreateNewCheck(thisConfig,"Unleash Element");
        CreateNewDrop(thisConfig, "Unleash Element", 1, "CD")
        CreateNewText(thisConfig,"Unleash Element");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- DPS Tweaks -----")

        -- EarthQuake
        CreateNewCheck(thisConfig,"EarthQuake");
        CreateNewDrop(thisConfig, "EarthQuake", 1, "CD")
        CreateNewText(thisConfig,"EarthQuake");

        -- Thunderstorm
        CreateNewCheck(thisConfig,"Thunderstorm");
        CreateNewDrop(thisConfig, "Thunderstorm", 1, "CD")
        CreateNewText(thisConfig,"Thunderstorm");

        -- Wrapper
        CreateNewWrap(thisConfig,"------ Defensive -------");

        -- Astral Shift
        CreateNewCheck(thisConfig,"Astral Shift");
        CreateNewBox(thisConfig, "Astral Shift", 0, 100  , 5, 30, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit");
        CreateNewText(thisConfig,"Astral Shift");

        -- Healing Stream
        CreateNewCheck(thisConfig,"Healing Stream");
        CreateNewBox(thisConfig, "Healing Stream", 0, 100  , 5, 50, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream");
        CreateNewText(thisConfig,"Healing Stream");

        -- Healing Rain
        CreateNewCheck(thisConfig,"Healing Rain");
        CreateNewBox(thisConfig, "Healing Rain", 0, 100  , 5, 50, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream");
        CreateNewText(thisConfig,"Healing Rain");

        -- Shamanistic Rage
        CreateNewCheck(thisConfig,"Shamanistic Rage");
        CreateNewBox(thisConfig, "Shamanistic Rage", 0, 100  , 5, 70, "|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage");
        CreateNewText(thisConfig,"Shamanistic Rage");

        -- Wrapper
        CreateNewWrap(thisConfig,"-------- Utilities -------");

        -- Healing Surge Toggle
        CreateNewCheck(thisConfig,"Healing Surge Toggle");
        CreateNewDrop(thisConfig,"Healing Surge Toggle", 4, "Toggle2")
        CreateNewText(thisConfig,"Healing Surge Toggle");

        -- Pause Toggle
        CreateNewCheck(thisConfig,"Pause Toggle");
        CreateNewDrop(thisConfig,"Pause Toggle", 3, "Toggle2")
        CreateNewText(thisConfig,"Pause Toggle");

        -- Standard Interrupt
        CreateNewCheck(thisConfig,"Wind Shear");
        CreateNewBox(thisConfig, "Wind Shear", 0, 100  , 5, 35 , "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.");
        CreateNewText(thisConfig,"Wind Shear");

        -- General Configs
        CreateGeneralsConfig();

        WrapsManager();
    --end
end
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]		  --[[]]		--[[]]	   --[[]]	--[[   		   ]]	--[[           ]]
--[[           ]]	--[[  ]]   --[[]]	--[[]]	   --[[]]		 --[[  ]] 		--[[  ]]   --[[]]	--[[   		   ]]	--[[           ]]
--[[]]				--[[    ]] --[[]]	--[[]]	   --[[]]	    --[[    ]]		--[[    ]] --[[]]	--[[]]				--[[]]
--[[           ]]	--[[           ]]	--[[           ]]	   --[[      ]] 	--[[           ]]	--[[]]				--[[           ]]
--[[]]				--[[   		   ]]	--[[]]	   --[[]]	  --[[        ]]	--[[   		   ]]	--[[]]				--[[]]
--[[           ]]	--[[]]	 --[[  ]]	--[[]]	   --[[]]	 --[[]]    --[[]]	--[[]]	 --[[  ]]	--[[   		   ]]	--[[           ]]
--[[           ]] 	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[]]      --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[           ]]

function EnhancementConfig()
    function titleOp(string)
        return CreateNewTitle(thisConfig,string);
    end
    function checkOp(string,tip)
        if tip == nil then
            return CreateNewCheck(thisConfig,string);
        else
            return CreateNewCheck(thisConfig,string,tip);
        end
    end
    function textOp(string)
        return CreateNewText(thisConfig,string);
    end
    function wrapOp(string)
        return CreateNewWrap(thisConfig,string);
    end
    function boxOp(string, minnum, maxnum, stepnum, defaultnum, tip)
        if tip == nil then
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum);
        else
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip);
        end
    end
    function dropOp(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
        return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10);
    end

-- Config Panel
    --if not doneConfig then
        thisConfig = 0
        -- Title
        titleOp("Cpoworks Enhancement");
                -- Spacer
        textOp(" ");
        wrapOp("--- General ---");

            -- Death Cat
            --checkOp("Death Cat Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFthis mode when running through low level content where you 1 hit kill mobs.");
            --textOp("Death Cat Mode");

            -- Mark Of The Wild
            --checkOp("Mark of the Wild","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFautomatic Mark of Wild usage. When enabled rotation will scan party/raid groups and cast if anyone in range in missing a similar buff.");
            --textOp(tostring(select(1,GetSpellInfo(mow))));

            -- Dummy DPS Test
            checkOp("DPS Testing","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFtimed tests on Training Dummies. This mode stops the rotation after the specified time if the target is a Training Dummy.");
            boxOp("DPS Testing", 5, 60, 5, 5, "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
            textOp("DPS Testing");

            -- Single/Multi Toggle
            checkOp("Rotation Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFRotation Mode Key Toggle|cffFFBB00.");
            dropOp("Rotation Mode", 1, "Toggle")
            textOp("Rotation Mode");

        -- Spacer
        textOp(" ");
        wrapOp("--- Cooldowns ---");
        --dropOp("Cooldown Key", 1, "Toggle")

            -- Agi Pot
            checkOp("Agi-Pot");
            textOp("Agi-Pot");

            -- Flask / Crystal
            checkOp("Flask / Crystal");
            textOp("Flask / Crystal");

			-- Earth  Ele
            checkOp("Earth  Ele");
            textOp("Earth  Ele");

        -- Spacer
        textOp(" ");
        wrapOp("--- Defensive ---");

            -- Healthstone
            checkOp("Pot/Stoned");
            boxOp("Pot/Stoned", 0, 100, 5, 60);
            textOp("Pot/Stoned");

            -- Barkskin
            --checkOp("Barkskin");
            --boxOp("Barkskin", 0, 100, 5, 50);
            --textOp(tostring(select(1,GetSpellInfo(bar))));

            -- Survival Instincts
            --checkOp("Survival Instincts");
            --boxOp("Survival Instincts", 0, 100, 5, 40);
            --textOp(tostring(select(1,GetSpellInfo(si))));

            -- Frenzied Regeneration
            --checkOp("Frenzied Regen");
            --boxOp("Frenzied Regen", 0, 100, 5, 30);
            --textOp(tostring(select(1,GetSpellInfo(fr))));

        -- Spacer --
        textOp(" ");
        wrapOp("--- Interrupts ---");

            -- Skull Bash
            --checkOp("Skull Bash")
            --textOp(tostring(select(1,GetSpellInfo(sb))))

            -- Mighty Bash
            --checkOp("Mighty Bash")
            --textOp(tostring(select(1,GetSpellInfo(mb))))

            -- Maim
            --checkOp("Maim")
            --textOp(tostring(select(1,GetSpellInfo(ma))))


            -- Standard Interrupt
            checkOp("Interrupts");
            boxOp("Interrupts", 5, 95, 5, 0);
            textOp("Interrupt At");


        -- General Configs
        CreateGeneralsConfig();

        WrapsManager();
    --end
end
--[[           ]]	--[[           ]]	--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]	--[[           ]]	--[[           ]]
--[[]]	   --[[]]	--[[]]				--[[]]					 --[[ ]]		--[[]]	   --[[]]
--[[           ]]	--[[           ]]	--[[           ]]		 --[[ ]]		--[[]]	   --[[]]
--[[        ]]		--[[]]						   --[[]]		 --[[ ]]		--[[]]	   --[[]]
--[[]]	  --[[]]	--[[           ]]	--[[           ]]		 --[[ ]]		--[[           ]]
--[[]]	   --[[]]	--[[           ]] 	--[[           ]]		 --[[ ]]		--[[           ]]

function RestorationConfig()
    --if not doneConfig then
        thisConfig = 0
        -- Title
        CreateNewTitle(thisConfig,"|cff00EEFFRestoration |cffFF0000CodeMyLife");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- Buffs -----");

        -- Earthliving Weapon
        CreateNewCheck(thisConfig,"Earthliving Weapon");
        CreateNewText(thisConfig,"Earthliving Weapon");

        -- Water Shield
        CreateNewCheck(thisConfig,"Water Shield");
        CreateNewText(thisConfig,"Water Shield");


        -- Wrapper
        CreateNewWrap(thisConfig,"----- Healing -----")

        CreateNewCheck(thisConfig,"Healing Wave","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHealing Wave|cffFFBB00.",1);
        CreateNewBox(thisConfig, "Healing Wave", 0, 100  , 5, 85, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Wave.");
        CreateNewText(thisConfig,"Healing Wave");

        CreateNewCheck(thisConfig,"Healing Surge","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHealing Surge|cffFFBB00.",1);
        CreateNewBox(thisConfig, "Healing Surge", 0, 100  , 5, 40, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Surge.");
        CreateNewText(thisConfig,"Healing Surge");

        CreateNewCheck(thisConfig,"Chain Heal","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFChain Heal|cffFFBB00.",1);
        CreateNewBox(thisConfig, "Chain Heal", 0, 100  , 5, 70, "|cffFFBB00Under what %HP to use |cffFFFFFFChain Heal on 3 targets.");
        CreateNewText(thisConfig,"Chain Heal");



        -- Wrapper
        CreateNewWrap(thisConfig,"----- Cooldowns -----")

        -- Ascendance
        CreateNewCheck(thisConfig,"Ascendance");
        CreateNewDrop(thisConfig, "Ascendance", 1, "CD")
        CreateNewText(thisConfig,"Ascendance");

        -- Fire Elemental
        CreateNewCheck(thisConfig,"Fire Elemental");
        CreateNewDrop(thisConfig, "Fire Elemental", 1, "CD")
        CreateNewText(thisConfig,"Fire Elemental");

        -- Stormlash
        CreateNewCheck(thisConfig,"Stormlash");
        CreateNewDrop(thisConfig, "Stormlash", 1, "CD")
        CreateNewText(thisConfig,"Stormlash");

        -- Wrapper
        CreateNewWrap(thisConfig,"----- DPS Tweaks -----")

        -- Unleash Element
        CreateNewCheck(thisConfig,"Unleash Element");
        CreateNewDrop(thisConfig, "Unleash Element", 1, "CD")
        CreateNewText(thisConfig,"Unleash Element");

        -- EarthQuake
        CreateNewCheck(thisConfig,"EarthQuake");
        CreateNewDrop(thisConfig, "EarthQuake", 1, "CD")
        CreateNewText(thisConfig,"EarthQuake");

        -- Thunderstorm
        CreateNewCheck(thisConfig,"Thunderstorm");
        CreateNewDrop(thisConfig, "Thunderstorm", 1, "CD")
        CreateNewText(thisConfig,"Thunderstorm");

        -- Wrapper
        CreateNewWrap(thisConfig,"------ Defensive -------");

        -- Astral Shift
        CreateNewCheck(thisConfig,"Astral Shift");
        CreateNewBox(thisConfig, "Astral Shift", 0, 100  , 5, 30, "|cffFFBB00Under what %HP to use |cffFFFFFFAstral Shit");
        CreateNewText(thisConfig,"Astral Shift");

        -- Healing Stream
        CreateNewCheck(thisConfig,"Healing Stream");
        CreateNewBox(thisConfig, "Healing Stream", 0, 100  , 5, 50, "|cffFFBB00Under what %HP to use |cffFFFFFFHealing Stream");
        CreateNewText(thisConfig,"Healing Stream");

        -- Shamanistic Rage
        CreateNewCheck(thisConfig,"Shamanistic Rage");
        CreateNewBox(thisConfig, "Shamanistic Rage", 0, 100  , 5, 70, "|cffFFBB00Under what %HP to use |cffFFFFFFShamanistic Rage");
        CreateNewText(thisConfig,"Shamanistic Rage");

        -- Wrapper
        CreateNewWrap(thisConfig,"-------- Utilities -------");

        -- Standard Interrupt
        CreateNewCheck(thisConfig,"Wind Shear");
        CreateNewBox(thisConfig, "Wind Shear", 0, 100  , 5, 35 , "|cffFFBB00Over what % of cast we want to |cffFFFFFFWind Shear.");
        CreateNewText(thisConfig,"Wind Shear");


        -- General Configs
        CreateGeneralsConfig();

        WrapsManager();
    --end
end
--[[           ]]	--[[]]	   --[[]]	--[[]]	   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[  ]]   --[[]]	--[[   		   ]]	--[[   		   ]]	--[[   		   ]]	--[[           ]]	--[[  ]]   --[[]]
--[[]]				--[[]]	   --[[]]	--[[    ]] --[[]]   --[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[    ]] --[[]]
--[[           ]]	--[[]]	   --[[]]	--[[           ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[           ]]
--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]	--[[]]					 --[[ ]]			 --[[ ]]		--[[]]	   --[[]]	--[[   		   ]]
--[[]]	   			--[[           ]]	--[[]]	 --[[  ]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	 --[[  ]]
--[[]]	   			--[[           ]]	--[[]]	   --[[]]	--[[   		   ]]		 --[[ ]]		--[[   		   ]]	--[[           ]]	--[[]]	   --[[]]







end