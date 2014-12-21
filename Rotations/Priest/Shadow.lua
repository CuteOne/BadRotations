if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig();
			ShadowToggles();
			currentConfig = "Shadow ragnar";
		end
		-- Head End


		-- Locals / Globals--
			GCD = 1.5/(1+UnitSpellHaste("player")/100)
			--hasTarget = UnitExists("target")
			--hasMouse = UnitExists("mouseover")
			php = getHP("player")
			-- thp = getHP("target")
			ORBS = UnitPower("player", SPELL_POWER_SHADOW_ORBS)

			MBCD = getSpellCD(MB)
			SWDCD = getSpellCD(SWD)

			-- DP
			DPTIME = 6.0/(1+UnitSpellHaste("player")/100)
			DPTICK = DPTIME/6
			-- SWP (18sec)
			SWPTICK = 18.0/(1+UnitSpellHaste("player")/100)/6
			-- VT (15sec)
			VTTICK = 16.0/(1+UnitSpellHaste("player")/100)/5
			VTCASTTIME = 1.5/(1+UnitSpellHaste("player")/100)

			if lastVT==nil then lastVT=0 end
			if lastDP==nil then	lastDP=99 end

			-- Set Enemies Table
			if BadBoy_data['AoE'] == 3 and (myEnemiesTableTimer == nil or myEnemiesTableTimer <= GetTime() - 1) then
				makeEnemiesTable(40)
				myEnemiesTableTimer = GetTime()
			end



			-- Buttons
			ButtonDefensive = 	BadBoy_data['Defensive']
			ButtonHalo = 		BadBoy_data['Halo']
			ButtonDoT =			BadBoy_data['DoT']
			ButtonSingle =		BadBoy_data['Single']
			ButtonAoE = 		BadBoy_data['AoE']
			ButtonCooldowns =	BadBoy_data['Cooldowns']
			ButtonFeather = 	BadBoy_data['Feather']

			-- Options
				--isChecked
					-- Offensive
					useBerserking =		 	isChecked("Berserking")
					if isKnown(Mindbender) then
						useMindbender = 	isChecked("Mindbender")
					else
						useShadowfiend	= 	isChecked("Shadowfiend")
					end
					useTrinket1 = 			isChecked("Trinket 1")
					useTrinket2	= 			isChecked("Trinket 2")
					if hasGlyph(GlyphOfSWD) then
											isChecked("SWD glyphed")
					end
					useScanOrbs	= 			isChecked("Scan for Orbs")
					-- Defensive
					useShield = 			isChecked("PW: Shield")
					useHealthstone	= 		isChecked("Healthstone")
					if isKnown(DesperatePrayer) then
						useDesperatePrayer = isChecked("Desperate Prayer")
					end 
					useDispersion =			isChecked("Dispersion")
					if hasGlyph(GlyphOfFade) then
						useFadeGlyph =		isChecked("Fade Glyph")
					end
					useFade =				isChecked("Fade Aggro")
					-- DoT Weave
					useSWP =				isChecked("SWP")
					useVT =					isChecked("VT")
					-- Multidot
					useMultiSWP =			isChecked("Multi SWP")
					useMultiVT =			isChecked("Multi VT")
					useBossSWP =			isChecked("Boss SWP")
					useBossVT =				isChecked("Boss VT")
					-- Utilities
					usePWF = 				isChecked("PW: Fortitude")
					useShadowform =			isChecked("Shadowform Outfight")
					if isKnown(AngelicFeather) then
						useFeather =		isChecked("Angelic Feather")
					end
					if isKnown(BodyAndSoul) then
						useBodyAndSoul = 	isChecked("Body And Soul")
					end

				-- getValue
					-- Defensive
					getPWShield = 			getValue("PW: Shield")
					getHealthstone =		getValue("Healthstone")
					getDispersion	=		getValue("Dispersion")
					getGlyph = 				getValue("Fade Glyph")
					-- Multidot
					getMinHealth =			getValue("Min Health")*1000000
					getMaxTargets = 		getValue("Max Targets")
					getRefreshTime = 		getValue("Refresh Time")


		-------------
		-- TOGGLES --
		-------------

		-- Pause toggle
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end

		-- Focus Toggle
		if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
			RunMacroText("/focus mouseover");
		end

		-- -- Auto Resurrection
		-- if isChecked("Auto Rez") then
		-- 	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		-- 		if castSpell("mouseover",Rez,true,true) then return; end
		-- 	end
		-- end

		------------
		-- CHECKS --
		------------

		-- Food/Invis Check
		if canRun() ~= true then return false;
		end

		-- Mounted Check
		if IsMounted("player") then return false;
		end

		-- Do not Interrupt "player" while GCD (61304)
		if getSpellCD(61304) > 0 then return false;
		end

		-------------------
		-- OUT OF COMBAT --
		-------------------

		-- Power Word: Fortitude
		if not isInCombat("player") then
			if usePWF and (lastPWF == nil or lastPWF <= GetTime() - 5) then
				for i = 1, #nNova do
			  		if isPlayer(nNova[i].unit) == true and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) and (UnitInRange(nNova[i].unit) or UnitIsUnit(nNova[i].unit,"player")) then
			  			if castSpell("player",PWF,true) then lastPWF = GetTime(); return; end
					end
				end
			end
		end

		---------------------------------------
		-- Shadowform and AutoSpeed Selfbuff --
		---------------------------------------

		-- Shadowform outfight
		if not UnitBuffID("player",Shadowform) and useShadowform==true then
			if castSpell("player",Shadowform,true,false) then return; end
		end

		-- Angelic Feather
		if isKnown(AngelicFeather) and ButtonFeather==2 then
			if useFeather==true and getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
			--if useFeather==true and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
				if castGround("player",AngelicFeather,30) then
					SpellStopTargeting();
					return;
				end
			end
		end

		-- Body and Soul
		if isKnown(BodyAndSoul) then 
			if useBodyAndSoul==true then
				if getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",PWS) and not UnitDebuffID("player",PWSDebuff) then
					if castSpell("player",PWS,true,false) then return; end
				end
			end
		end

		---------------
		-- IN COMBAT --
		---------------
		-- AffectingCombat, Pause, Target, Dead/Ghost Check
		if UnitAffectingCombat("player") or UnitAffectingCombat("target") then

			-- Shadowform
			if not UnitBuffID("player",Shadowform) then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-------------------
			-- Dummy Testing --
			-------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print("____ " .. tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped ____")
					end
				end
			end


			----------------
			-- Defensives --
			----------------
			ShadowDefensive()

			----------------
			-- Offensives --
			----------------
			ShadowCooldowns()

			-----------------------
			-- Rotation Decision --
			-----------------------
			-- if isChecked("AutoTarget") then
			-- 	noTargetTargetMainTankTarget()
			-- end
			
			-- Single target
			if ButtonAoE == 1 then
				Execute()
				LFOrbs()
				if getHP("target")>20 then
					if ButtonDoT>=2 then DotEmAll() end
					if ButtonSingle==1 then IcySingle() end
					if ButtonSingle==2 then IcySingleWeave() end
				end
			end

			-- Dual Target
			if ButtonAoE == 2 then
				Execute()
				LFOrbs()
				if getHP("target")>20 then IcyDualTarget() end
			end
			
			-- 3+ Targets
			if ButtonAoE == 3 then 
				Execute()
				LFOrbs()
				if getHP("target")>20 then IcyMultiTarget() end
			end
			
			-- Auto
			-- if BadBoy_data['AoE'] == 3 then
			-- 	if #enemiesTable<2 then 
			-- 	if #enemiesTable>=2 and #enemiesTable<3 then Icy23Targets() end
			-- 	if #enemiesTable>=4





			--if BadBoy_data['AoE'] == 3 then Icy4AndMore() end
			-- Auto
			-- if BadBoy_data['AoE'] == 4 then
			-- 	-- singletarget
			-- 	if #enemiesTable==1 then
			-- 		-- weave=1, trad=2
			-- 		if getValue("SingleRota")==1 then IcySingleWeave() end
			-- 		if getValue("SingleRota")==2 then IcySingle() end
			-- 	end
			-- 	-- 2-3 targets
			-- 	
			-- 	-- 4+ targets
			-- 	if #enemiesTable>4 then Icy4AndMore() end
			-- end


		end -- AffectingCombat, Pause, Target, Dead/Ghost Check
	end
end