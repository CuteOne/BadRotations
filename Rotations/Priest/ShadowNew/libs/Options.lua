if select(3, UnitClass("player")) == 5 then
	function ShadowConfig()
		if currentConfig ~= "Shadow ragnar" then
			ClearConfig()
			thisConfig = 0
			-- Title
			CreateNewTitle(thisConfig,"ravens v2 |cffBA55D3by ragnar")


			----------------------------------------------------
			-- Offensive ---------------------------------------
			----------------------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Offensive")

			-- bosscheck
			CreateNewCheck(thisConfig,"isBoss","use cooldowns only on boss units")
			CreateNewText(thisConfig,"isBoss")

			-- Power Infusion
			CreateNewCheck(thisConfig,"Power Infusion","use Power Infusion")
			CreateNewText(thisConfig,"Power Infusion")

			-- Troll Racial
			if isKnown(26297) then
			CreateNewCheck(thisConfig,"Berserking","use Berserking (Troll Racial)")
			CreateNewText(thisConfig,"Berserking")
			end

			-- Shadowfien / Mindbender
			CreateNewCheck(thisConfig,"Shadowfiend/Mindbender","use Shadowfiend or Mindbender")
			CreateNewText(thisConfig,"Shadowfiend/Mindbender")

			-- onUse Trinkets
			CreateNewCheck(thisConfig,"Trinket 1","use Trinket 1 if on use")
			CreateNewText(thisConfig,"Trinket 1")
			CreateNewCheck(thisConfig,"Trinket 2","use Trinket 1 if on use")
			CreateNewText(thisConfig,"Trinket 2")

			-- LF ToF
			CreateNewCheck(thisConfig,"Scan for ToF", "Scan all enemies to get ToF (not implemented atm)")
			CreateNewText(thisConfig,"Scan for ToF")


			----------------------------------------------------
			-- Defensive ---------------------------------------
			----------------------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Defensive")

			-- Shield
			CreateNewCheck(thisConfig,"PW: Shield")
			CreateNewBox(thisConfig, "PW: Shield", 0,100,2,90, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield")
			CreateNewText(thisConfig,"PW: Shield")

			-- Healthstone
			CreateNewCheck(thisConfig,"Healing Tonic")
			CreateNewBox(thisConfig, "Healing Tonic", 0,100,2,25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Tonic")
			CreateNewText(thisConfig,"Healing Tonic")

			-- Desperate Prayer
			CreateNewCheck(thisConfig,"Desperate Prayer")
			CreateNewBox(thisConfig, "Desperate Prayer", 0,100,2,30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDesperate Prayer")
			CreateNewText(thisConfig,"Desperate Prayer")

			-- Dispersion
			CreateNewCheck(thisConfig,"Dispersion")
			CreateNewBox(thisConfig, "Dispersion", 0,100,2,20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDispersion")
			CreateNewText(thisConfig,"Dispersion")

			-- Fade DMG reduction (with glyph)
			CreateNewCheck(thisConfig,"Fade Glyph")
			CreateNewBox(thisConfig, "Fade Glyph", 0, 100 , 2, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade")
			CreateNewText(thisConfig,"Fade Glyph")


			-- Fade (aggro reduction)
			CreateNewCheck(thisConfig,"Fade Aggro", "|cffFFBB00Fade on Aggression |cffFF0000(only in group or raid)")
			CreateNewText(thisConfig,"Fade Aggro")


			----------------------------------------------------
			--  Bosshelper  ------------------------------------
			----------------------------------------------------
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

			-- Auto Silence
			CreateNewCheck(thisConfig,"Target Helper", "Assists to target the correct unit")
			CreateNewText(thisConfig,"Target Helper")


			----------------------------------------------------
			-- Rotation ----------------------------------------
			----------------------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Rotation")

			-- DoTWeave
			CreateNewCheck(thisConfig,"DoTWeave","DoTWeave on CoP")
			CreateNewText(thisConfig,"DoTWeave")

			-- VT on Target
			CreateNewCheck(thisConfig,"VT on Target","VT on current target (AS)")
			CreateNewText(thisConfig,"VT on Target")

			-- Ignore orbs for SWD
			CreateNewCheck(thisConfig,"SWD ignore Orbs","SWD with 5 orbs.")
			CreateNewText(thisConfig,"SWD ignore Orbs")

			-- Min Health
			CreateNewBox(thisConfig,"Min Health", 0.0, 7.5, 0.1, 1.5, "Minimum Health in |cffFF0000million HP|cffFFBB00.\nMin: 0 / Max: 7.5+  / Interval: 0.1")
			CreateNewText(thisConfig,"Min Health")

			-- Max Targets
			CreateNewBox(thisConfig,"Max Targets", 1, 15, 1, 5, "Maximum count of SWP/VT on Units. \nMin: 1 / Max: 15 / Interval: 1")
			CreateNewText(thisConfig,"Max Targets")

			-- Hold orbs back
			CreateNewBox(thisConfig,"DP on Orbs", 3, 5, 1, 4, "Start DP on 3 Orbs for faster DMG.\nStart DP on 4 Orbs should improve Damage and uptime of Mental Instinct.\nStart on 5 Orbs should improve T17-4pc more than on 4 Orbs.")
			CreateNewText(thisConfig,"DP on Orbs")

			-- Auto MindSear
			CreateNewCheck(thisConfig,"MS Targets","Automatic use of Mind Sear as filler instead of Mind Flay / Mind Spike")
			CreateNewBox(thisConfig,"MS Targets", 1, 10, 1, 4, "Minimum count of enemies around target to use Mind Sear\nMin: 1 / Max: 10+ / Interval: 1)")
			CreateNewText(thisConfig,"MS Targets")

			-- Mind Sear Key
			CreateNewCheck(thisConfig,"MSinsanity Key", "Searing Insanity current target while pressing the key")
			CreateNewDrop(thisConfig,"MSinsanity Key", 3, "Toggle2")
			CreateNewText(thisConfig,"MSinsanity Key")

			-- Burst MSi
			CreateNewCheck(thisConfig,"Burst MSi","MSi rotation without interruption\nuse it for short living Adds")
			CreateNewText(thisConfig,"Burst MSi")


			----------------------------------------------------
			-- Utilities ---------------------------------------
			----------------------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Utilities")

			-- Rotation
			CreateNewDrop(thisConfig,"Rotation",1,"Choose rotation to use.","|cffBA55D3ravens")
			CreateNewText(thisConfig,"Rotation")

			--SWP Farm
			CreateNewCheck(thisConfig,"Dot Farm","SWP all in range.")
			CreateNewText(thisConfig,"Dot Farm")

			-- Pause Toggle
			CreateNewCheck(thisConfig,"Pause Toggle")
			CreateNewDrop(thisConfig,"Pause Toggle", 10, "Toggle2")
			CreateNewText(thisConfig,"Pause Toggle")

			--Power Word: Fortitude
			CreateNewCheck(thisConfig,"PW: Fortitude")
			CreateNewText(thisConfig,"PW: Fortitude")

			-- Dummy DPS Test
			CreateNewCheck(thisConfig,"DPS Testing")
			CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 4, "Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
			CreateNewText(thisConfig,"DPS Testing")


			-- General Configs ---------------------------------
			CreateGeneralsConfig()
			WrapsManager()
		end
	end
end