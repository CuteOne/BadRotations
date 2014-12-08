if select(3,UnitClass("player")) == 2 then

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

	function PaladinProtOptions()
		ClearConfig()
		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Protection Gabbz")
		-- Wrapper
		--CreateNewWrap(thisConfig,"----- Buffs -----")

		-- Blessing
		--CreateNewCheck(thisConfig,"Blessing")
		--CreateNewText(thisConfig,"Blessing")

		-- Righteous Fury
		--CreateNewCheck(thisConfig,"Righteous Fury")
		--CreateNewText(thisConfig,"Righteous Fury")

		-- Seal
		--CreateNewCheck(thisConfig,"Seal")
		--CreateNewDrop(thisConfig, "Seal", 1, "Choose Seal to use.", "|cffFFDD11Insight", "|cff00FBEETruth", "|cff00EE00Swap")
		--CreateNewText(thisConfig,"Seal")

		-- Wrapper
		--CreateNewWrap(thisConfig,"----- Cooldowns -----")

		-- Avenging Wrath
		--CreateNewCheck(thisConfig,"Avenging Wrath")
		--CreateNewDrop(thisConfig, "Avenging Wrath", 1, "CD")
		--CreateNewText(thisConfig,"Avenging Wrath")

		--if isKnown(_HolyAvenger) then
			-- Holy Avenger
		--	CreateNewCheck(thisConfig,"Holy Avenger")
		--	CreateNewDrop(thisConfig, "Holy Avenger", 1, "CD")
		--	CreateNewText(thisConfig,"Holy Avenger")
		--elseif isKnown(_SanctifiedWrath) then
			-- Sanctified Wrath
		--	CreateNewCheck(thisConfig,"Sanctified Wrath")
		--	CreateNewDrop(thisConfig, "Sanctified Wrath", 1, "CD")
		--	CreateNewText(thisConfig,"Sanctified Wrath")
		--end

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

		-- Lay On Hands on yourself
		CreateNewCheck(thisConfig,"Lay On Hands Self","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFLay on Hands|cffFFBB00 on Self.",1)
		CreateNewBox(thisConfig, "Lay On Hands Self", 0, 100, 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands on your self")
		CreateNewText(thisConfig,"Lay On Hands Self")

		-- Lay On Hands on Party
		CreateNewCheck(thisConfig,"Lay On Hands Party","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFLay on Hands|cffFFBB00 on Party.",0)
		CreateNewBox(thisConfig, "Lay On Hands Party", 0, 100, 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands on your Party")
		CreateNewText(thisConfig,"Lay On Hands Party")

		CreateNewCheck(thisConfig,"Hand Of Freedom","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand Of Freedom|cffFFBB00.",1)
		CreateNewDrop(thisConfig, "Hand Of Freedom", 1,"uNDER WICH conditions do we use Hand of Freedom on self.","Whitelist")
		CreateNewText(thisConfig,"Hand Of Freedom")

		-- Hand of Sacrifice
		--CreateNewCheck(thisConfig,"Hand Of Sacrifice","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand of Sacrifice|cffFFBB00.",1)
		--CreateNewBox(thisConfig, "Hand Of Sacrifice", 0, 100  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
		--CreateNewText(thisConfig,"Hand Of Sacrifice")

		-- Cast Hand of Salvation
		--CreateNewCheck(thisConfig,"Hand Of Salvation Self","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand of Salvation|cffFF0000 on Self.",0)
		--CreateNewBox(thisConfig, "Hand Of Salvation Self", 0, 100  , 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Salvation on Self")
		--CreateNewText(thisConfig,"Hand Of Salvation Self")

		-- Cast Hand of Salvation Party
		--CreateNewCheck(thisConfig,"Hand Of Salvation Party","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFHand of Salvation|cffFFBB00 on Party.",1)
		--CreateNewBox(thisConfig, "Hand Of Salvation Party", 0, 100  , 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Salvation on Party")
		--CreateNewText(thisConfig,"Hand Of Salvation Party")

		-- Crowd Control
		--CreateNewCheck(thisConfig,"Crowd Control","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFCrowd Control|cffFFBB00.",1)
		--CreateNewDrop(thisConfig, "Crowd Control", 1, "CD") -- TODO: We should hae other options, never is the checking of the box, always, whitelist, on health(self), condition
		--CreateNewText(thisConfig,"Crowd Control")

		-- Wrapper Interrupt
		CreateNewWrap(thisConfig,"------ Interrupt -------")

		CreateNewCheck(thisConfig,"Rebuke","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFRebuke|cffFFBB00.",1)
		CreateNewBox(thisConfig, "Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
		CreateNewText(thisConfig,"Rebuke")

		CreateNewCheck(thisConfig,"Avengers Shield Interrupt","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable \n|cffFFFFFFusing AS as Interrupt|cffFFBB00.",1)
		CreateNewBox(thisConfig, "Avengers Shield Interrupt",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFAS as interrupt.")
		CreateNewText(thisConfig,"Avengers Shield Interrupt")

		--CreateNewCheck(thisConfig,"LoH Targets")
		--CreateNewDrop(thisConfig, "LoH Targets", 1, "|cffFF0000Wich Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands", "|cffFF0000Me.Only", "|cffFFDD11Me.Prio", "|cff00FBEETank/Heal","|cff00FF00All")
		--CreateNewText(thisConfig,"LoH Targets")

		-- Word Of Glory Party
		--CreateNewCheck(thisConfig,"Word Of Glory On Party")
		--CreateNewBox(thisConfig, "Word Of Glory On Party", 0, 100, 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to heal Party with \n|cffFFFFFFWords Of Glory")
		--CreateNewText(thisConfig,"Word Of Glory On Party")


		-- Wrapper
		--CreateNewWrap(thisConfig,"------ Defensive -------")

		-- Guardian of Ancient Kings
		--CreateNewCheck(thisConfig,"GotAK Prot")
		--CreateNewBox(thisConfig, "GotAK Prot", 0, 100, 1, 30, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFGuardian of Ancient Kings")
		--CreateNewText(thisConfig,"GotAK Prot")

		-- Divine Protection
		--CreateNewCheck(thisConfig,"Divine Protection")
		--CreateNewBox(thisConfig, "Divine Protection", 0, 100, 1, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
		--CreateNewText(thisConfig,"Divine Protection")

		-- Ardent Defender
		--CreateNewCheck(thisConfig,"Ardent Defender")
		--CreateNewBox(thisConfig, "Ardent Defender", 0, 100, 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFArdent Defender")
		--CreateNewText(thisConfig,"Ardent Defender")


		-- Cast Divine Shield
		--CreateNewCheck(thisConfig,"Divine Shield")
		--CreateNewBox(thisConfig, "Divine Shield", 0, 100, 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Shield")
		--CreateNewText(thisConfig,"Divine Shield")

		-- Cast Hand of Protection
		--CreateNewCheck(thisConfig,"Hand Of Protection Self")
		--CreateNewBox(thisConfig, "Hand Of Protection Self", 0, 100  , 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Protection Self")
		--CreateNewText(thisConfig,"Hand Of Protection Self")

		-- Cast Hand of Salvation
		--CreateNewCheck(thisConfig,"Hand Of Salvation Self")
		--CreateNewBox(thisConfig, "Hand Of Salvation Self", 0, 100  , 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Salvation Self")
		--CreateNewText(thisConfig,"Hand Of Salvation Self")

		-- Cast Hand of Protection on Friend
		--CreateNewCheck(thisConfig,"Hand Of Protection Friend")
		--CreateNewBox(thisConfig, "Hand Of Protection Friend", 0, 100  , 1, 20, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Protection Friend")
		--CreateNewText(thisConfig,"Hand Of Protection Friend")

		-- Wrapper
		--CreateNewWrap(thisConfig,"-------- Healing -------")

		-- Tier 3 talents
		--if isKnown(_SacredShield) then
		--	CreateNewCheck(thisConfig,"Sacred Shield")
		--	CreateNewBox(thisConfig, "Sacred Shield", 0, 100  , 1, 95, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
		--	CreateNewText(thisConfig,"Sacred Shield")
		--	CreateNewCheck(thisConfig,"Sacred Vengeance")
		--	CreateNewBox(thisConfig, "Sacred Vengeance", 5, 500  , 5, 350, "|cffFF0000Value*1000\n|cffFFBB00Vengeance gain needed to recast \n|cffFFFFFFSacred Shield")
		--	CreateNewText(thisConfig,"Sacred Vengeance")
		--elseif isKnown(_SelflessHealer) then
		--	CreateNewCheck(thisConfig,"Selfless Healer")
		--	CreateNewBox(thisConfig, "Selfless Healer", 0, 100  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
		--	CreateNewText(thisConfig,"Selfless Healer")

		--else
		--	CreateNewCheck(thisConfig,"Self Flame")
		--	CreateNewBox(thisConfig, "Self Flame", 0, 100  , 1, 75, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Self")
		--	CreateNewText(thisConfig,"Self Flame")
		--	CreateNewCheck(thisConfig,"Eternal Flame")
		--	CreateNewBox(thisConfig, "Eternal Flame", 0, 100  , 1, 35, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
		--	CreateNewText(thisConfig,"Eternal Flame")
		--end
		--if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
		--	CreateNewCheck(thisConfig,"Self Glory")
		--	CreateNewBox(thisConfig, "Self Glory", 0, 100  , 1, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Self")
		--	CreateNewText(thisConfig,"Self Glory")
		--	CreateNewCheck(thisConfig,"Word Of Glory")
		--	CreateNewBox(thisConfig, "Word Of Glory", 0, 100  , 1, 70, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
		--	CreateNewText(thisConfig,"Word Of Glory")
		--end

		--if isKnown(_HandOfPurity) == true then
		--	CreateNewCheck(thisConfig,"Hand of Purity")
		--	CreateNewBox(thisConfig, "Hand of Purity", 0, 100  , 1, 50, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
		--	CreateNewText(thisConfig,"Hand of Purity")
		--end



		-- Wrapper
		--CreateNewWrap(thisConfig,"-------- Utilities -------")

		-- General Configs
		CreateGeneralsConfig()

		WrapsManager()
	end

















	function PaladinHolyOptions()
		ClearConfig()
		local myColor = "|cffC0C0C0"
		local redColor = "|cffFF0011"
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

		-- General Configs
		CreateGeneralsConfig()

		WrapsManager()
	end


















	function PaladinRetOptions()

		local myColor = "|cffC0C0C0"
		local redColor = "|cffFF0011"
		local myClassColor = classColors[select(3,UnitClass("player"))].hex
		local function generateWrapper(wrapName)
			CreateNewWrap(thisConfig,myClassColor.."-"..redColor.." "..wrapName.." "..myClassColor.."-")
		end

		ClearConfig()

		thisConfig = 0
		-- Title
		CreateNewTitle(thisConfig,"Retribution Gabbz & CML")

		-- Wrapper
		generateWrapper("Buffs")

		-- Blessing
		CreateNewCheck(thisConfig,"Blessing")
		CreateNewText(thisConfig,"Blessing")

		-- Seal
		CreateNewCheck(thisConfig,"Seal")
		CreateNewDrop(thisConfig,"Seal",1,"Choose Seal to use.","|cffFFDD11Insight","|cff00FBEETruth","|cff00EE00Swap")
		CreateNewText(thisConfig,"Seal")

		-- Wrapper
		generateWrapper("Coooldowns")

		-- Avenging Wrath
		CreateNewCheck(thisConfig,"Avenging Wrath")
		CreateNewDrop(thisConfig,"Avenging Wrath",1,"CD")
		CreateNewText(thisConfig,"Avenging Wrath")

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
		generateWrapper("DPS Teaks")

		if isKnown(_LightsHammer) then
			-- Light's Hammer
			CreateNewCheck(thisConfig,"Light's Hammer")
			CreateNewDrop(thisConfig,"Light's Hammer",1,"CD")
			CreateNewText(thisConfig,"Light's Hammer")
		end

		-- Wrapper
		generateWrapper("Defensive")

		-- Divine Protection
		CreateNewCheck(thisConfig,"Divine Protection")
		CreateNewBox(thisConfig,"Divine Protection",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFDivine Protection")
		CreateNewText(thisConfig,"Divine Protection")

	   -- Wrapper
		generateWrapper("Healing")

		-- Tier 3 talents
		if isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Sacred Shield")
			CreateNewBox(thisConfig,"Sacred Shield",0,100,1,95,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSacred Shield")
			CreateNewText(thisConfig,"Sacred Shield")
		elseif isKnown(_SelflessHealer) then
			CreateNewCheck(thisConfig,"Selfless Healer")
			CreateNewBox(thisConfig,"Selfless Healer",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFSelfless Healer on Raid")
			CreateNewText(thisConfig,"Selfless Healer")
		else
			CreateNewCheck(thisConfig,"Self Flame")
			CreateNewBox(thisConfig,"Self Flame",0,100,1,75,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Self")
			CreateNewText(thisConfig,"Self Flame")
			CreateNewCheck(thisConfig,"Eternal Flame")
			CreateNewBox(thisConfig,"Eternal Flame",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFEternal Flame on Raid")
			CreateNewText(thisConfig,"Eternal Flame")
		end

		if isKnown(_SelflessHealer) or isKnown(_SacredShield) then
			CreateNewCheck(thisConfig,"Self Glory")
			CreateNewBox(thisConfig,"Self Glory",0,100,1,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Self")
			CreateNewText(thisConfig,"Self Glory")
			CreateNewCheck(thisConfig,"Word Of Glory")
			CreateNewBox(thisConfig,"Word Of Glory",0,100,1,70,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFWord Of Glory on Raid")
			CreateNewText(thisConfig,"Word Of Glory")
		end

		if isKnown(_HandOfPurity) == true then
			CreateNewCheck(thisConfig,"Hand of Purity")
			CreateNewBox(thisConfig,"Hand of Purity",0,100,1,50,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand of Purity")
			CreateNewText(thisConfig,"Hand of Purity")
		end

		CreateNewCheck(thisConfig,"Lay On Hands")
		CreateNewBox(thisConfig,"Lay On Hands",0,100,1,12,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFLay On Hands")
		CreateNewText(thisConfig,"Lay On Hands")

		CreateNewCheck(thisConfig,"LoH Targets")
		CreateNewDrop(thisConfig,"LoH Targets",1,"|cffFF0000Wich Targets\n|cffFFBB00We want to use \n|cffFFFFFFLay On Hands","|cffFF0000Me.Only","|cffFFDD11Me.Prio","|cff00FBEETank/Heal","|cff00FF00All")
		CreateNewText(thisConfig,"LoH Targets")

		CreateNewCheck(thisConfig,"Hand Of Sacrifice")
		CreateNewBox(thisConfig,"Hand Of Sacrifice",0,100,1,35,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use \n|cffFFFFFFHand Of Sacrifice")
		CreateNewText(thisConfig,"Hand Of Sacrifice")

		-- Wrapper
		generateWrapper("Utilities")

		-- Rebuke
		CreateNewCheck(thisConfig,"Rebuke")
		CreateNewBox(thisConfig,"Rebuke",0,100,5,35,"|cffFFBB00Over what % of cast we want to \n|cffFFFFFFRebuke.")
		CreateNewText(thisConfig,"Rebuke")

		-- General Configs
		CreateGeneralsConfig()
		WrapsManager()
	end
end