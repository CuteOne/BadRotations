if select(3, UnitClass("player")) == 5 then
	function ShadowConfig()
		if currentConfig ~= "Shadow ragnar" then
			ClearConfig()
			thisConfig = 0
			-- Title
			CreateNewTitle(thisConfig,"ravens v3beta |cffBA55D3by ragnar")


			--   _____            _     _                         
			--  / ____|          | |   | |                        
			-- | |     ___   ___ | | __| | _____      ___ __  ___ 
			-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
			-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
			--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
			CreateNewWrap(thisConfig,"|cffBA55D3Offensive")

			-- bosscheck
			CreateNewCheck(thisConfig,"isBoss","use CDs only on Boss Units")
			CreateNewText(thisConfig,"isBoss")

			-- Power Infusion
			CreateNewCheck(thisConfig,"PI","Power Infusion")
			CreateNewText(thisConfig,"PI")

			-- Shadowfien / Mindbender
			CreateNewCheck(thisConfig,"MB/SF","Mindbender / Shadowfiend")
			CreateNewText(thisConfig,"MB/SF")


			--  _____        __               _           
			-- |  __ \      / _|             (_)          
			-- | |  | | ___| |_ ___ _ __  ___ ___   _____ 
			-- | |  | |/ _ \  _/ _ \ '_ \/ __| \ \ / / _ \
			-- | |__| |  __/ ||  __/ | | \__ \ |\ V /  __/
			-- |_____/ \___|_| \___|_| |_|___/_| \_/ \___|
			CreateNewWrap(thisConfig,"|cffBA55D3Defensive")

			-- Shield
			CreateNewCheck(thisConfig,"PW:S","Power Word: Shield")
			CreateNewBox(thisConfig, "PW:S",0,100,1,75,"|cffFFFFFFhealth percent to cast at")
			CreateNewText(thisConfig,"PW:S")

			-- Desperate Prayer
			CreateNewCheck(thisConfig,"Desperate Prayer","Desperate Prayer Talent")
			CreateNewBox(thisConfig, "Desperate Prayer",0,100,1,30,"|cffFFFFFFhealth percent to cast at")
			CreateNewText(thisConfig,"Desperate Prayer")

			-- Fade with glyph
			CreateNewCheck(thisConfig,"Fade","glyphed fade: 10% Damage reduction")
			CreateNewBox(thisConfig, "Fade", 0, 100 , 2, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade")
			CreateNewText(thisConfig,"Fade")

			-- Healing Tonic
			CreateNewCheck(thisConfig,"Healing Tonic","Healing Tonic")
			CreateNewBox(thisConfig, "Healing Tonic",0,100,1,25,"|cffFFFFFFhealth percent to cast at")
			CreateNewText(thisConfig,"Healing Tonic")

			-- Dispersion
			CreateNewCheck(thisConfig,"Dispersion")
			CreateNewBox(thisConfig, "Dispersion",0,100,1,20,"|cffFFFFFFhealth percent to cast at")
			CreateNewText(thisConfig,"Dispersion")

			--  ____                  _    _      _                 
			-- |  _ \                | |  | |    | |                
			-- | |_) | ___  ___ ___  | |__| | ___| |_ __   ___ _ __ 
			-- |  _ < / _ \/ __/ __| |  __  |/ _ \ | '_ \ / _ \ '__|
			-- | |_) | (_) \__ \__ \ | |  | |  __/ | |_) |  __/ |   
			-- |____/ \___/|___/___/ |_|  |_|\___|_| .__/ \___|_|   
			--                                     | |              
			--                                     |_|              
			CreateNewWrap(thisConfig,"|cffBA55D3Bosshelper")

			-- Auto Guise
			CreateNewCheck(thisConfig,"Auto Guise", "Auto Spectral Guise on: \nBRF: Iron Maidens")
			CreateNewText(thisConfig,"Auto Guise")

			-- Auto Mass Dispel
			CreateNewCheck(thisConfig,"Auto Mass Dispel", "Auto Mass Dispel on: \nBRF: Operator Thogar")
			CreateNewText(thisConfig,"Auto Mass Dispel")

			-- Auto Dispel
			CreateNewCheck(thisConfig,"Auto Dispel", "Auto Dispel on: \nBRF: Blast Furnace")
			CreateNewText(thisConfig,"Auto Dispel")

			-- Auto Silence
			CreateNewCheck(thisConfig,"Auto Silence", "Auto Silence on: \nBRF: Blast Furnace\nBRF: Operator Thogar")
			CreateNewText(thisConfig,"Auto Silence")

			-- Target Helper
			CreateNewCheck(thisConfig,"Target Helper", "Assists to target the correct unit")
			CreateNewText(thisConfig,"Target Helper")

			-- Auto Burn
			CreateNewCheck(thisConfig,"AutoBurn", "Auto target burn defined units like doomfire on archimonde")
			CreateNewText(thisConfig,"AutoBurn")

			-- Gorefiend SWP
			CreateNewCheck(thisConfig,"Gorefiend SWP", "SWP every Corrupted Soul in Mythic")
			CreateNewText(thisConfig,"Gorefiend SWP")

			--  _____       _        _   _             
			-- |  __ \     | |      | | (_)            
			-- | |__) |___ | |_ __ _| |_ _  ___  _ __  
			-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \ 
			-- | | \ \ (_) | || (_| | |_| | (_) | | | |
			-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_|
			CreateNewWrap(thisConfig,"|cffBA55D3Rotation")

			-- Ignore orbs for SWD
			CreateNewCheck(thisConfig,"SWD ignore Orbs","use SWD despite 5 Orbs")
			CreateNewText(thisConfig,"SWD ignore Orbs")

			-- Max Targets
			CreateNewBox(thisConfig,"max dot targets", 0, 10, 1, 4, "|cffFFFFFFnumber of running dots of each")
			CreateNewText(thisConfig,"max dot targets")

			-- ttd SWP
			CreateNewBox(thisConfig,"ttd swp", 0, 13.5, 0.25, 13.5, "|cffFFFFFFSWP TTD:\nstandard (simcraft): 13.5s\nCast SWP only on a unit that lives longer than chosen value.")
			CreateNewText(thisConfig,"ttd swp")

			-- ttd VT
			CreateNewBox(thisConfig,"ttd vt", 0, 11.25, 0.25, 11.25, "|cffFFFFFFSWP TTD:\nstandard (simcraft): 11.25s + castTime\nCast VT only on a unit that lives longer than chosen value.")
			CreateNewText(thisConfig,"ttd vt")

			-- Mind Sear / Searing Insanity Key
			CreateNewCheck(thisConfig,"Burst SI", "Burst Searing Insanity")
			CreateNewDrop(thisConfig,"Burst SI", 3, "Toggle2")
			CreateNewText(thisConfig,"Burst SI")

			-- Auto Focus
			CreateNewCheck(thisConfig,"AutoFocus", "Focus units on CoP rotation autmatically for offDot and offDP")
			CreateNewText(thisConfig,"AutoFocus")

			


			--  _    _ _   _ _ _ _   _           
			-- | |  | | | (_) (_) | (_)          
			-- | |  | | |_ _| |_| |_ _  ___  ___ 
			-- | |  | | __| | | | __| |/ _ \/ __|
			-- | |__| | |_| | | | |_| |  __/\__ \
			--  \____/ \__|_|_|_|\__|_|\___||___/
			CreateNewWrap(thisConfig,"|cffBA55D3Utilities")

			-- Rotation
			CreateNewDrop(thisConfig,"Rotation",1,"Choose rotation to use.","|cffBA55D3ravens","|cffBA55D3SimC")
			CreateNewText(thisConfig,"Rotation")

			-- Pause Toggle
			CreateNewCheck(thisConfig,"Pause Toggle")
			CreateNewDrop(thisConfig,"Pause Toggle", 10, "Toggle2")
			CreateNewText(thisConfig,"Pause Toggle")

			-- -- Dummy DPS Test
			-- CreateNewCheck(thisConfig,"DPS Testing")
			-- CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 4, "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
			-- CreateNewText(thisConfig,"DPS Testing")


			-- General Configs ---------------------------------
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end