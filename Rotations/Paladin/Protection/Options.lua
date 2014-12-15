if select(3,UnitClass("player")) == 2 then

	function PaladinProtOptions()
		ClearConfig()
		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Protection Gabbz")

		-- Wrapper
		CreateNewWrap(thisConfig,"-----  Gabbz -----")

		if isKnown(_LightsHammer) then
			-- Light's Hammer
			CreateNewCheck(thisConfig,"Light's Hammer","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFLight's Hammer|cffFFBB00.",1)
			CreateNewDrop(thisConfig, "Light's Hammer", 1, "CD")
			CreateNewText(thisConfig,"Light's Hammer")
		end

		-- Word Of Glory Party
		CreateNewCheck(thisConfig,"Word Of Glory On Self","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFWord of Glory|cffFFBB00 on self.",1)
		CreateNewBox(thisConfig, "Word Of Glory On Self", 0, 100, 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to heal self with \n|cffFFFFFFWords Of Glory")
		CreateNewText(thisConfig,"Word Of Glory On Self")

		-- LoH options
		generalPaladinOptions()

		CreateNewCheck(thisConfig,"Hand Of Freedom","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand Of Freedom|cffFFBB00.",1)
		CreateNewDrop(thisConfig, "Hand Of Freedom", 1,"uNDER WICH conditions do we use Hand of Freedom on self.","Whitelist")
		CreateNewText(thisConfig,"Hand Of Freedom")

		-- Wrapper Interrupt
		CreateNewWrap(thisConfig,"------ Interrupt -------")

		CreateNewCheck(thisConfig,"Rebuke","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFRebuke|cffFFBB00.",1)
		CreateNewBox(thisConfig, "Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
		CreateNewText(thisConfig,"Rebuke")

		CreateNewCheck(thisConfig,"Avengers Shield Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing AS as Interrupt|cffFFBB00.",1)
		CreateNewBox(thisConfig, "Avengers Shield Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFAS as interrupt.")
		CreateNewText(thisConfig,"Avengers Shield Interrupt")

		CreateNewCheck(thisConfig,"Arcane Torrent Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing Arcane Torrent as Interrupt|cffFFBB00.",1)
		CreateNewBox(thisConfig, "Arcane Torrent Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFArcane Torrent as interrupt.")
		CreateNewText(thisConfig,"Arcane Torrent Interrupt")

		CreateNewCheck(thisConfig,"Gabbz Debug","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFDebugging|cffFFBB00.",1)
		CreateNewDrop(thisConfig, "Gabbz Debug", 1, "On")
		CreateNewText(thisConfig,"Gabbz Debug")


		-- General Configs
		CreateGeneralsConfig()

		WrapsManager()
	end
end