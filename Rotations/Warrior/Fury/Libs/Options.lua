if select(3,UnitClass("player")) == 1 then

    function CreateTitle(string)
        return CreateNewTitle(thisConfig,string)
    end
    function CreateCheck(string,tip)
        if tip == nil then
            return CreateNewCheck(thisConfig,string)
        else
            return CreateNewCheck(thisConfig,string,tip)
        end
    end
    function CreateText(string)
        return CreateNewText(thisConfig,string)
    end
    function CreateWrap(string)
        return CreateNewWrap(thisConfig,string)
    end
    function CreateBox(string, minnum, maxnum, stepnum, defaultnum, tip)
        if tip == nil then
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum)
        else
            return CreateNewBox(thisConfig,string, minnum, maxnum, stepnum, defaultnum, tip)
        end
    end
    function CreateDrop(string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
        return CreateNewDrop(thisConfig, string, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)
    end

    function FuryOptions()
        if GetSpecialization() == 2 then    
            if Currentconfig ~= "Fury Warrior" then
                ClearConfig()
                thisConfig = 0
				
                -- Title
                CreateTitle("Fury Warrior")
				
                -- Spacer
                CreateText(" ")
                CreateWrap("--- General (Profile) ---")
					
					-- Automatic Aoe Toggle
					CreateCheck("AutoAoE","Check if you want to use automatic AoE, tarplus/minus wont do anything until you toggle this off");
					CreateText("Auto AoE") 
			
                -- Spacer
                CreateText(" ")
                CreateWrap("--- Cooldowns ---")

                -- Spacer
                CreateText(" ")
                CreateWrap("--- Defensive ---")

                    -- Healthstone
                    CreateCheck("Pot/Stoned")
                    CreateBox("Pot/Stoned", 0, 100, 5, 60, "Percent to Use At")
                    CreateText("Pot/Stoned")

                -- Spacer --
                CreateText(" ")
                CreateWrap("--- Interrupts ---")
       
                    -- Interrupt Percentage
                    CreateCheck("Interrupt At")
                    CreateBox("Interrupt At", 5, 95, 5, 0, "|cffFFFFFFCast Percent to Cast At")
                    CreateText("Interrupt At")

                -- Spacer
                CreateText(" ")
                CreateWrap("--- Toggle Keys ---")

                    -- Target Plus Key Toggle
					CreateCheck("Rotation Up","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)")
					CreateDrop("Rotation Up", 1, "Toggle")
					CreateText("Tar Plus")

					-- Target Minus Key Toggle
					CreateCheck("Rotation Down","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)")
					CreateDrop("Rotation Down", 2, "Toggle")
					CreateText("Tar Minus")

                    -- Interrupts Key Toggle
                    CreateCheck("Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.")
                    CreateDrop("Interrupt Mode", 6, "Toggle")
                    CreateText("Interrupts")

                -- General Configs
                CreateGeneralsConfig()
                WrapsManager()
            end
        end
    end
	
end