if select(3, UnitClass("player")) == 1 then

	function WarriorArmsConfig()
		if currentConfig ~= "Arms Warrior" then
			ClearConfig();
			thisConfig = 0;
			-- Title
			CreateNewTitle(thisConfig,"Arms Warrior");
			
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
			
			-- Wrapper
			CreateNewWrap(thisConfig,"Other");

			-- Show more
			CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
			CreateNewText(thisConfig,"Show More");

			-- Healing/general/poke/hacks/tracking
			if isChecked("Showmore") == true then
				CreateGeneralsConfig();
				WrapsManager();
			end
		end
	end

	function WarriorFuryConfig()
		if currentConfig ~= "Fury Warrior" then
			ClearConfig();
			thisConfig = 0;

			-- Title
			CreateNewTitle(thisConfig,"Fury Warrior");
			
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
			
			-- Wrapper
			CreateNewWrap(thisConfig,"Other");

			--showmore
			CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
			CreateNewText(thisConfig,"Show More");

			-- Healing/general/poke/hacks/tracking
			if isChecked("Showmore") == true then
				CreateGeneralsConfig();
				WrapsManager();
			end
		end
	end

	function WarriorProtConfig()
		if currentConfig ~= "Protection Warrior" then
			ClearConfig();
			thisConfig = 0;
			-- Title
			CreateNewTitle(thisConfig,"Protection Warrior");

			-- Show more
			CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
			CreateNewText(thisConfig,"Show More");

			-- Healing/general/poke/hacks/tracking
			if isChecked("Showmore") == true then
				CreateGeneralsConfig();
				WrapsManager();
			end
		end
	end

end