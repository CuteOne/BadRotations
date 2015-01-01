if select(3,UnitClass("player")) == 2 then

	function optionsLayOnHands()
		-- Lay on Hands
		CreateNewCheck(thisConfig,"Lay On Hands")
		CreateNewBox(thisConfig,"Lay On Hands",0,100,1,12,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")
		CreateNewText(thisConfig,"Lay On Hands")

		-- Lay on Hands Targets 1- me only 2- me prio 3- tank and heal 4- all
		CreateNewCheck(thisConfig,"LoH Targets")
		CreateNewDrop(thisConfig,"LoH Targets",1,"|cffFF0000Wich Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands","|cffFF0000Me.Only","|cffFFDD11Me.Prio","|cff00FBEETank/Heal","|cff00FF00All")
		CreateNewText(thisConfig,"LoH Targets")
	end

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
		optionsLayOnHands()

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

	function PaladinHolyOptions()
		ClearConfig()
		local myColor = ""
		local redColor = ""
		local myClassColor = classColors[select(3,UnitClass("player"))].hex
		local function myWrapper(Value)
			CreateNewWrap(thisConfig,"---"..redColor.." "..Value.." "..myClassColor.."---")
		end
		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Holy Gabbz & CodeMyLife")

-- Buffs
		myWrapper("Buffs")

-- Blessing
		CreateNewCheck(thisConfig,"Blessing","Normal",1)
		CreateNewDrop(thisConfig,"Blessing",1,"Select wich blessing you want to use.","|cff006AFFKings","|cffFFAE00Might")
		CreateNewText(thisConfig,myColor.."Blessing")

		-- Seal
		CreateNewCheck(thisConfig,"Seal Of Insight","Normal",1)
		CreateNewText(thisConfig,myColor.."Seal Of Insight")

-- Cooldowns
		myWrapper("Cooldowns")

		-- Guardian of Ancient Kings
		CreateNewCheck(thisConfig,"GotAK Holy")
		CreateNewBox(thisConfig,"GotAK Holy",0,100,1,30,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian of Ancient Kings")
		CreateNewText(thisConfig,myColor.."GotAK Holy")

		-- Avenging Wrath
		CreateNewCheck(thisConfig,"Avenging Wrath")
		CreateNewDrop(thisConfig,"Avenging Wrath", 1,"CD")
		CreateNewText(thisConfig,myColor.."Avenging Wrath")

		if isKnown(_HolyAvenger) then
			-- Holy Avenger
			CreateNewCheck(thisConfig,"Holy Avenger")
			CreateNewDrop(thisConfig,"Holy Avenger",1,"CD")
			CreateNewText(thisConfig, myColor.."Holy Avenger")
		elseif isKnown(_SanctifiedWrath) then
			-- Sanctified Wrath
			CreateNewCheck(thisConfig,"Sanctified Wrath")
			CreateNewDrop(thisConfig,"Sanctified Wrath",1,"CD")
			CreateNewText(thisConfig,myColor.."Sanctified Wrath")
		end

		if isKnown(_LightsHammer) then
			-- Light's Hammer
			CreateNewCheck(thisConfig,"Light's Hammer")
			CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
			CreateNewText(thisConfig,myColor.."Light's Hammer")
		end

-- Defensive
		myWrapper("Defensive")

		-- Divine Protection
		CreateNewCheck(thisConfig,"Divine Protection Holy","Normal",1)
		CreateNewBox(thisConfig,"Divine Protection Holy",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
		CreateNewText(thisConfig,myColor.."Divine Protection Holy")

-- Healing
		myWrapper("Healing")

		CreateNewCheck(thisConfig,"Critical Health Level","Normal",1)
		CreateNewBox(thisConfig,"Critical Health Level",0,100,1,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFfast heals")
		CreateNewText(thisConfig,myColor.."Critical Health Level")


		CreateNewCheck(thisConfig, "Beacon Of Light","Normal",1)
		CreateNewDrop(thisConfig, "Beacon Of Light", 2, "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic", "TANK","FOCUS","WISE")
		CreateNewText(thisConfig, myColor.."Beacon Of Light")

		-- Beacon of Faith
		if isKnown(_BeaconOfFaith) then
			CreateNewCheck(thisConfig, "Beacon Of Faith","Normal",1)
			CreateNewDrop(thisConfig, "Beacon Of Faith", 2, "Choose mode:\nTank - Always on tank\nFocus - Always on focus.\nWise - Dynamic", "TANK","FOCUS","WISE")
			CreateNewText(thisConfig, myColor.."Beacon Of Faith")
		end

		-- Holy Light
		CreateNewCheck(thisConfig,"Holy Light","Normal",1)
		CreateNewBox(thisConfig,"Holy Light",0,100,1,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Light")
		CreateNewText(thisConfig,myColor.."Holy Light")

		-- Flash Of Light
		CreateNewCheck(thisConfig,"Flash Of Light","Normal",1)
		CreateNewBox(thisConfig,"Flash Of Light",0,100,1,40,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFFlash Of Light")
		CreateNewText(thisConfig,myColor.."Flash Of Light")

		-- Holy Shock
		CreateNewCheck(thisConfig,"Holy Shock","Normal",1)
		CreateNewBox(thisConfig,"Holy Shock",0,100,1,90,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Shock")
		CreateNewText(thisConfig,myColor.."Holy Shock")

		-- Tier 3 talents
		if isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Sacred Shield","Normal",1)
			CreateNewBox(thisConfig,"Sacred Shield",0,100,1,95,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
			CreateNewText(thisConfig,myColor.."Sacred Shield")
		elseif isKnown(_SelflessHealer) then
			CreateNewCheck(thisConfig,"Selfless Healer","Normal",1)
			CreateNewBox(thisConfig,"Selfless Healer",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
			CreateNewText(thisConfig,myColor.."Selfless Healer")
		else
			CreateNewCheck(thisConfig,"Eternal Flame","Normal",1)
			CreateNewBox(thisConfig,"Eternal Flame",0,100,1,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
			CreateNewText(thisConfig,myColor.."Eternal Flame")
		end
		if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Word Of Glory","Normal",1)
			CreateNewBox(thisConfig,"Word Of Glory",0,100,1,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
			CreateNewText(thisConfig,myColor.."Word Of Glory")
		end

		-- Tier 6 talents
		if isKnown(_HolyPrism) then
			CreateNewCheck(thisConfig, "Holy Prism","Normal",1)
			CreateNewBox(thisConfig, "Holy Prism", 0, 100  , 1, 95, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Prism")
			CreateNewText(thisConfig, myColor.."Holy Prism")
			-- Mode, cast always as heal or always as damage or dynamic
			CreateNewCheck(thisConfig, "Holy Prism Mode","Normal",1)
			CreateNewDrop(thisConfig, "Holy Prism Mode", 2, "Choose mode:\nFriend - Heal with damage\nEnemy - Damage with heal.\nWise - Dynamic", "Friend", "Enemy","WISE")
			CreateNewText(thisConfig, myColor.."Holy Prism Mode")
		elseif isKnown(_LightsHammer) then
			CreateNewCheck(thisConfig, "Lights Hammer","Normal",1)
			CreateNewBox(thisConfig, "Lights Hammer", 0, 100  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLights Hammer")
			CreateNewText(thisConfig, myColor.."Lights Hammer")
		else
			CreateNewCheck(thisConfig, "Execution Sentence","Normal",1)
			CreateNewBox(thisConfig, "Execution Sentence", 0, 100  , 1, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFExecution Sentence")
			CreateNewText(thisConfig, myColor.."Execution Sentence")
		end
		if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
			CreateNewCheck(thisConfig, "Word Of Glory","Normal",1)
			CreateNewBox(thisConfig, "Word Of Glory", 0, 100  , 1, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
			CreateNewText(thisConfig, myColor.."Word Of Glory")
		end


		if isKnown(_HandOfPurity) == true then
			CreateNewCheck(thisConfig,"Hand of Purity","Normal",1)
			CreateNewBox(thisConfig,"Hand of Purity",0,100,1,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
			CreateNewText(thisConfig,myColor.."Hand of Purity")
		end

		CreateNewCheck(thisConfig,"Lay On Hands","Normal",1)
		CreateNewBox(thisConfig,"Lay On Hands",0,100,1,12,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")
		CreateNewText(thisConfig,myColor.."Lay On Hands")

		CreateNewCheck(thisConfig,"LoH Targets","Normal",1)
		CreateNewDrop(thisConfig,"LoH Targets",1,"|cffFF0000Wich Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands", "|cffFF0000Me.Only", "|cffFFDD11Me.Prio", "|cff00FBEETank/Heal","|cff00FF00All")
		CreateNewText(thisConfig,myColor.."LoH Targets")

		CreateNewCheck(thisConfig,"Hand Of Sacrifice","Normal",1)
		CreateNewBox(thisConfig,"Hand Of Sacrifice",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
		CreateNewText(thisConfig,myColor.."Hand Of Sacrifice")

-- AoE Healing
		myWrapper("AoE Healing")

		CreateNewCheck(thisConfig,"HR Missing Health","Normal",1)
		CreateNewBox(thisConfig,"HR Missing Health",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
		CreateNewText(thisConfig,myColor.."HR Missing Health")

		CreateNewBox(thisConfig,"HR Units",0,25,1,3,"|cffFFBB00Minimum number of |cffFF0000%Units|cffFFBB00 to use \n|cffFFFFFFHoly Radiance")
		CreateNewText(thisConfig,myColor.."HR Units")

-- Utilities
		myWrapper("Utilities")

		-- Rebuke
		CreateNewCheck(thisConfig,"Rebuke")
		CreateNewBox(thisConfig,"Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
		CreateNewText(thisConfig,myColor.."Rebuke")

		-- Nature's Cure
        CreateNewCheck(thisConfig,"Dispell")
        CreateNewDrop(thisConfig,"Dispell", 1, "|cffFFBB00MMouse:|cffFFFFFFMouse / Match List. \n|cffFFBB00MRaid:|cffFFFFFFRaid / Match List. \n|cffFFBB00AMouse:|cffFFFFFFMouse / All. \n|cffFFBB00ARaid:|cffFFFFFFRaid / All.",
            "|cffFFDD11MMouse",
            "|cffFFDD11MRaid",
            "|cff00FF00AMouse",
            "|cff00FF00ARaid")
        CreateNewText(thisConfig,"Dispell")

		-- General Configs
		CreateGeneralsConfig()

		WrapsManager()
	end

	function PaladinRetOptions()

		local myColor = "|cffC0C0C0"
		local redColor = "|cffFF0011"
		local whiteColor = "|cffFFFFFF"
		local myClassColor = classColors[select(3,UnitClass("player"))].hex
		local function generateWrapper(wrapName)
			CreateNewWrap(thisConfig,whiteColor.."- "..redColor..wrapName..whiteColor.." -")
		end

		ClearConfig()

		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Retribution Gabbz & CML")

		-- Wrapper
		generateWrapper("Buffs")

		-- Blessing
		CreateNewCheck(thisConfig,"Blessing")
		CreateNewDrop(thisConfig,"Blessing",1,"|cffFFFFFFWich blessing do you want to maintain on raid","|cff0374FEKings","|cffFFBC40Might","|cff00FF0DAuto")
		CreateNewText(thisConfig,"Blessing")

		-- Wrapper
		generateWrapper("Coooldowns")

		-- Avenging Wrath
		CreateNewCheck(thisConfig,"Avenging Wrath")
		CreateNewDrop(thisConfig,"Avenging Wrath",1,"CD")
		CreateNewText(thisConfig,"Avenging Wrath")

		if isKnown(_LightsHammer) then
			-- Light's Hammer
			CreateNewCheck(thisConfig,"Light's Hammer")
			CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
			CreateNewText(thisConfig,"Light's Hammer")
		end

		if isKnown(_HolyAvenger) then
			-- Holy Avenger
			CreateNewCheck(thisConfig,"Holy Avenger")
			CreateNewDrop(thisConfig,"Holy Avenger",1,"CD")
			CreateNewText(thisConfig,"Holy Avenger")
		elseif isKnown(_SanctifiedWrath) then
			-- Sanctified Wrath
			CreateNewCheck(thisConfig,"Sanctified Wrath")
			CreateNewDrop(thisConfig,"Sanctified Wrath",1,"CD")
			CreateNewText(thisConfig,"Sanctified Wrath")
		end

		-- Wrapper
		generateWrapper("Defensive")

		-- Divine Protection
		CreateNewCheck(thisConfig,"Divine Protection",1)
		CreateNewBox(thisConfig,"Divine Protection",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
		CreateNewText(thisConfig,"Divine Protection")

		-- Divine Shield
		CreateNewCheck(thisConfig,"Divine Shield",1)
		CreateNewBox(thisConfig,"Divine Shield",0,100,1,10,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Shield")
		CreateNewText(thisConfig,"Divine Shield")

	   -- Wrapper
		generateWrapper("Healing")



		if isKnown(_HandOfPurity) == true then
			CreateNewCheck(thisConfig,"Hand of Purity")
			CreateNewBox(thisConfig,"Hand of Purity",0,100,1,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
			CreateNewText(thisConfig,"Hand of Purity")
		end
		-- Hand of Sacrifice
		CreateNewCheck(thisConfig,"Hand Of Sacrifice")
		CreateNewBox(thisConfig,"Hand Of Sacrifice",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
		CreateNewText(thisConfig,"Hand Of Sacrifice")

		-- LoH options
		optionsLayOnHands()

		-- Tier 3 talents
		if isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Sacred Shield")
			CreateNewBox(thisConfig,"Sacred Shield",0,100,5,95,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
			CreateNewText(thisConfig,"Sacred Shield")
		elseif isKnown(_SelflessHealer) then
			CreateNewCheck(thisConfig,"Selfless Healer")
			CreateNewBox(thisConfig,"Selfless Healer",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
			CreateNewText(thisConfig,"Selfless Healer")
		else
			CreateNewCheck(thisConfig,"Self Flame")
			CreateNewBox(thisConfig,"Self Flame",0,100,5,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Self")
			CreateNewText(thisConfig,"Self Flame")
			CreateNewCheck(thisConfig,"Eternal Flame")
			CreateNewBox(thisConfig,"Eternal Flame",0,100,5,20,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
			CreateNewText(thisConfig,"Eternal Flame")
		end

		if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Self Glory")
			CreateNewBox(thisConfig,"Self Glory",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Self")
			CreateNewText(thisConfig,"Self Glory")
			CreateNewCheck(thisConfig,"Word Of Glory")
			CreateNewBox(thisConfig,"Word Of Glory",0,100,5,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFWord Of Glory on Raid")
			CreateNewText(thisConfig,"Word Of Glory")
		end

		-- Wrapper
		generateWrapper("Utilities")

		-- Rebuke
		CreateNewCheck(thisConfig,"Rebuke",1,redColor.."Check" ..whiteColor.."to use "..redColor.."Rebuke"..whiteColor..".")
		CreateNewBox(thisConfig,"Rebuke",0,100,5,35,redColor.."Over what % of cast"..whiteColor.." we want to use "..redColor.."Rebuke"..whiteColor..".")
		CreateNewText(thisConfig,redColor.."Rebuke")

		-- General Configs
		CreateGeneralsConfig()
		WrapsManager()
	end
end