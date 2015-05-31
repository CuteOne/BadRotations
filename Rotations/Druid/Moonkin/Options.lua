if select(3, UnitClass("player")) == 11 then
	function MoonkinConfig()
		if currentConfig ~= "boomkin ragnar" then
			ClearConfig()
			thisConfig = 0

			CreateNewTitle(thisConfig,"boomkin |cffBA55D3by ragnar");

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Offensive")

				-- bosscheck
				CreateNewCheck(thisConfig,"isBoss")
				CreateNewText(thisConfig,"isBoss")

				if isKnown(26297) then
					CreateNewCheck(thisConfig,"Berserking")
					CreateNewText(thisConfig,"Berserking")
				end

				-- Celestial Alignment
				CreateNewCheck(thisConfig,"Celestial Alignment")
				CreateNewText(thisConfig,"Celestial Alignment")

				CreateNewCheck(thisConfig,"CA: Wrath","Cast Wrath instead of Starfire on Celestial Alignment")
				CreateNewText(thisConfig,"CA: Wrath")

				-- Incarnation
				CreateNewCheck(thisConfig,"Incarnation")
				CreateNewText(thisConfig,"Incarnation")

				-- onUse Trinkets
				CreateNewCheck(thisConfig,"Trinket 1")
				CreateNewText(thisConfig,"Trinket 1")
				CreateNewCheck(thisConfig,"Trinket 2")
				CreateNewText(thisConfig,"Trinket 2")


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Defensive")

				-- Rejuvenation
				CreateNewCheck(thisConfig,"Rejuvenation")
				CreateNewBox(thisConfig, "Rejuvenation", 0,100,2,60, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRejuvenation")
				CreateNewText(thisConfig,"Rejuvenation")

				-- Shield
				CreateNewCheck(thisConfig,"Healing Touch")
				CreateNewBox(thisConfig, "Healing Touch", 0,100,2,30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Touch")
				CreateNewText(thisConfig,"Healing Touch")

				-- Barkskin
				CreateNewCheck(thisConfig,"Barkskin")
				CreateNewBox(thisConfig, "Barkskin", 0,100,2,25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFBarkskin")
				CreateNewText(thisConfig,"Barkskin")

				-- Natures Vigil
				CreateNewCheck(thisConfig,"Natures Vigil")
				CreateNewText(thisConfig,"Natures Vigil")

				-- Healing Tonic
				CreateNewCheck(thisConfig,"Healing Tonic")
				CreateNewBox(thisConfig, "Healing Tonic", 0,100,2,25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealing Tonic")
				CreateNewText(thisConfig,"Healing Tonic")

			

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Boss Specific")

			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Multitarget")

				-- Sort EnemiesTable by HPabs
				-- CreateNewCheck(thisConfig,"sortByHPabs","Sort enemiesTable by descending health, so the highest absolute health unit will be dotted first.")
				-- CreateNewText(thisConfig,"sortByHPabs")

				-- Min Health
				CreateNewBox(thisConfig,"Min Health", 0.0, 7.5, 0.1, 0.1, "Minimum Health in |cffFF0000million HP|cffFFBB00.\nMin: 0 / Max: 7.5  / Interval: 0.1")
				CreateNewText(thisConfig,"Min Health")

				-- Max Targets
				-- CreateNewCheck(thisConfig,"Max Targets");
				CreateNewBox(thisConfig,"Max Targets", 1, 10, 1, 5, "Maximum count of Moonfire/Sunfire on Units.")
				CreateNewText(thisConfig,"Max Targets")

				-- Starfall Targets
				-- Auto Starfall
				--CreateNewCheck(thisConfig,"Starfall Charges","Automatic Starfall if enough charges")
				CreateNewBox(thisConfig,"Starfall Charges", 1, 10, 1, 2, "Minimum count of charges \nto use Starfall. \nMin: 0 / Max: 3 / Interval: 1")
				CreateNewText(thisConfig,"Starfall Charges")


			-- Wrapper -----------------------------------------
			CreateNewWrap(thisConfig,"|cffBA55D3Utilities")

				-- Pause Toggle
				CreateNewCheck(thisConfig,"Pause Toggle")
				CreateNewDrop(thisConfig,"Pause Toggle", 10, "Toggle2")
				CreateNewText(thisConfig,"Pause Toggle")

				-- Power Word: Fortitude
				CreateNewCheck(thisConfig,"MotW")
				CreateNewText(thisConfig,"MotW")

				-- Shadowform Outfight
				CreateNewCheck(thisConfig,"Boomkin Form")
				CreateNewText(thisConfig,"Boomkin Form")

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