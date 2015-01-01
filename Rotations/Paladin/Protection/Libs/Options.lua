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
			CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
			CreateNewText(thisConfig,"Light's Hammer")
		end

		-- Word Of Glory Party
		CreateNewCheck(thisConfig,"Word Of Glory On Self","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFWord of Glory|cffFFBB00 on self.",1)
		CreateNewBox(thisConfig,"Word Of Glory On Self",0,100,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to heal self with \n|cffFFFFFFWords Of Glory")
		CreateNewText(thisConfig,"Word Of Glory On Self")

		-- LoH options
		generalPaladinOptions()

		CreateNewCheck(thisConfig,"Hand Of Freedom","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand Of Freedom|cffFFBB00.",1)
		CreateNewDrop(thisConfig,"Hand Of Freedom",1,"uNDER WICH conditions do we use Hand of Freedom on self.","Whitelist")
		CreateNewText(thisConfig,"Hand Of Freedom")

		-- Wrapper Interrupt
		CreateNewWrap(thisConfig,"------ Interrupt -------")

		CreateNewCheck(thisConfig,"Rebuke","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFRebuke|cffFFBB00.",1)
		CreateNewBox(thisConfig,"Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
		CreateNewText(thisConfig,"Rebuke")

		CreateNewCheck(thisConfig,"Avengers Shield Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing AS as Interrupt|cffFFBB00.",1)
		CreateNewBox(thisConfig,"Avengers Shield Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFAS as interrupt.")
		CreateNewText(thisConfig,"Avengers Shield Interrupt")

		CreateNewCheck(thisConfig,"Arcane Torrent Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing Arcane Torrent as Interrupt|cffFFBB00.",1)
		CreateNewBox(thisConfig,"Arcane Torrent Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFArcane Torrent as interrupt.")
		CreateNewText(thisConfig,"Arcane Torrent Interrupt")

		CreateNewCheck(thisConfig,"Gabbz Debug","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFDebugging|cffFFBB00.",1)
		CreateNewText(thisConfig,"Gabbz Debug")

		CreateNewWrap(thisConfig,"------ Defensive -------")

		CreateNewCheck(thisConfig,"Divine Protection","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFDivine Protection.",1)
		CreateNewBox(thisConfig,"Divine Protection",0,100,1,65,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
		CreateNewText(thisConfig,"Divine Protection")

		CreateNewCheck(thisConfig,"Ardent Defender","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFArdent Defender.",1)
		CreateNewBox(thisConfig,"Ardent Defender",0,100,1,20,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFArdent Defender")
		CreateNewText(thisConfig,"Ardent Defender")

		CreateNewCheck(thisConfig,"Guardian Of Ancient Kings","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFGuardian Of Ancients Kings.",1)
		CreateNewBox(thisConfig,"Guardian Of Ancient Kings",0,100,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian Of Ancients Kings")
		CreateNewText(thisConfig,"Guardian Of Ancient Kings")

		CreateNewWrap(thisConfig,"-- Rotation Management --")

		CreateNewBox(thisConfig,"Max DPS HP",51,100,1,70,"|cffFFBB00Over what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFMaximum DPS Rotation")
		CreateNewText(thisConfig,"Max DPS HP")

		CreateNewBox(thisConfig,"Max Survival HP",0,50,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFMaximum Survival Rotation")
		CreateNewText(thisConfig,"Max Survival HP")

		-- General Configs
		CreateGeneralsConfig()

		WrapsManager()
	end
end