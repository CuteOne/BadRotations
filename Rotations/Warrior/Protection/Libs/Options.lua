if select(3, UnitClass("player")) == 1  then

	function WarriorProtOptions()
		ClearConfig()
		
		local myColor = "|cffC0C0C0"
		local redColor = "|cffFF0011"
		local whiteColor = "|cffFFFFFF"
		local myClassColor = classColors[select(3,UnitClass("player"))].hex
		local function generateWrapper(wrapName)
			CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
		end
		
		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Protection |cffFF0000Cpoworks");

		-- Wrapper
		generateWrapper("Buffs")
		
		-- Shout
		CreateNewCheck(thisConfig,"Shout")
		CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
		CreateNewText(thisConfig,"Shout")
		
		-- Rotation
		CreateNewDrop(thisConfig, "Stance", 1, "Choose Stance to use.", "|cffFFBB00Gladiator", "|cff0077FFProtection")
		CreateNewText(thisConfig, "Stance")
		

		-- Wrapper
		generateWrapper("Cooldowns")
		
		-- Bladestorm
		if isKnown(46924) then
			CreateNewCheck(thisConfig,"Auto Bladestorm","Use Bladestorm automatically", 1);
			CreateNewText(thisConfig,"Auto Bladestorm");
		end
		
		-- DragonRoar
		if isKnown(118000) then
			CreateNewCheck(thisConfig,"Auto Dragon Roar","Use Dragon Roar automatically", 1);
			CreateNewText(thisConfig,"Auto Dragon Roar");
		end 
		
		-- Ravager
		if isKnown(152277) then
			CreateNewCheck(thisConfig,"Auto Ravager","Use Ravager automatically", 1);
			CreateNewText(thisConfig,"Auto Ravager");
		end
		
		-- Bloodbath
		if isKnown(12292) then
			CreateNewCheck(thisConfig,"Auto Bloodbath","Use Bloodbath automatically", 1);
			CreateNewText(thisConfig,"Auto Bloodbath");
		end
		
		-- Avatar
		if isKnown(107574) then
			CreateNewCheck(thisConfig,"Auto Avatar","Use Avatar automatically", 1);
			CreateNewText(thisConfig,"Auto Avatar");
		end
		
		-- Racial
		CreateNewCheck(thisConfig,"Racial (Orc / Troll)")
		CreateNewText(thisConfig,"Racial (Orc / Troll)")
		
		-- Dummy DPS Test
		CreateNewCheck(thisConfig,"DPS Testing");
		CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
		CreateNewText(thisConfig,"DPS Testing");
		
		-- Wrapper
		generateWrapper("Defensive")

		-- Shield Block / Barrier
		CreateNewDrop(thisConfig, "Block or Barrier", 1, "Use Shield Block or Shield Barrier", "|cffFFBB00Block", "|cff0077FFBarrier")
		CreateNewText(thisConfig,"Block or Barrier")
		
		
		CreateNewCheck(thisConfig,"Last Stand","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFLast Stand.",1)
		CreateNewBox(thisConfig,"Last Stand",0,100,1,20,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLast Stand")
		CreateNewText(thisConfig,"Last Stand")

		CreateNewCheck(thisConfig,"Shield Wall","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFShield Wall.",1)
		CreateNewBox(thisConfig,"Shield Wall",0,100,5,25,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFShield Wall")
		CreateNewText(thisConfig,"Shield Wall")

		CreateNewCheck(thisConfig,"Enraged Regeneration","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFEnraged Regeneration.",1)
		CreateNewBox(thisConfig, "Enraged Regeneration", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration");
		CreateNewText(thisConfig,"Enraged Regeneration")

		-- ImpendingVictory/Victory Rush
		CreateNewCheck(thisConfig,"Impending Victory","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFImpending Victory.",1)
		CreateNewBox(thisConfig, "Impending Victory", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)");
		CreateNewText(thisConfig,"Impending Victory")

		-- Healthstone
		CreateNewCheck(thisConfig,"Healthstone")
		CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
		CreateNewText(thisConfig,"Healthstone")

		-- Safeguard Focus
		CreateNewCheck(thisConfig,"Safeguard at Focus")
		CreateNewBox(thisConfig, "Safeguard at Focus", 0, 100  , 5, 25, "% HP of Focustarget to Safeguard at Focustarget");
		CreateNewText(thisConfig,"Safeguard at Focus")

		-- Vigilance Focus
		CreateNewCheck(thisConfig,"Vigilance on Focus")
		CreateNewBox(thisConfig, "Vigilance on Focus", 0, 100  , 5, 25, "% HP of Focustarget to use Vigilance on Focustarget");
		CreateNewText(thisConfig,"Vigilance on Focus")
		
		-- Wrapper
		generateWrapper("Keys")

		-- Pause Toggle
		CreateNewCheck(thisConfig,"Pause Key")
		CreateNewDrop(thisConfig,"Pause Key", 4, "Toggle")
		CreateNewText(thisConfig,"Pause Key")

		-- Heroic Leap
		CreateNewCheck(thisConfig,"Heroic Leap Key")
		CreateNewDrop(thisConfig,"Heroic Leap Key", 2, "Toggle2")
		CreateNewText(thisConfig,"Heroic Leap Key")

		-- Mocking Banner
		CreateNewCheck(thisConfig,"Mocking Banner Key")
		CreateNewDrop(thisConfig,"Mocking Banner Key", 7, "Toggle2")
		CreateNewText(thisConfig,"Mocking Banner Key")		

		

		CreateGeneralsConfig();
		WrapsManager();

	end
end
