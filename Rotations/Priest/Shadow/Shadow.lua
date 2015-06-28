if select(3, UnitClass("player")) == 5 then
	function PriestShadow()

		if currentConfig ~= "Shadow ragnar" then
			ShadowConfig()
			ShadowToggles()
			currentConfig = "Shadow ragnar"
		end
		-- Head End


		if lastDP==nil then	lastDP=99 end
		if lastVT==nil then lastVT=99 end


		-- Sort enemiesTable by absolute HP
		--if isChecked("sortByHPabs") then
			if enemiesTable then
				if enemiesTableTimer <= GetTime() - 0.5 then
					table.sort(enemiesTable, function(x,y)
						return x.hpabs and y.hpabs and x.hpabs > y.hpabs or false
					end)
				end
			end
		--end

		local options = {
			-- Player values
			player = {
				GCD = 		1.5/(1+UnitSpellHaste("player")/100),
				php =		getHP("player"),
				ORBS = 		UnitPower("player", SPELL_POWER_SHADOW_ORBS),
				DPTIME = 	6.0/(1+UnitSpellHaste("player")/100),
				lastVT,
				lastDP,
				MBCD = 		getSpellCD(MB),
				SWDCD = 	getSpellCD(SWD),
				Bubble = 	isChecked("Bubble"),
				},
			-- Buttons
			buttons = {
				Defensive =		BadBoy_data['Defensive'],
				Halo =			BadBoy_data['Halo'],
				DoT =			BadBoy_data['DoT'],
				--Single =		BadBoy_data['Single'],
				--Rotation =	BadBoy_data['Rotation'],
				--Rotation =	1,
				Cooldowns =		BadBoy_data['Cooldowns'],
				Feather =		BadBoy_data['Feather'],
				BossHelper = 	BadBoy_data['BossHelper'],
			},
			-- isChecked
			isChecked = {
				-- Offensive
				isBoss = 			isChecked("isBoss"),
				Berserking = 		isChecked("Berserking"),
				Mindbender = 		isChecked("Mindbender"),
				Shadowfiend	= 		isChecked("Shadowfiend"),
				Trinket1 = 			isChecked("Trinket 1"),
				Trinket2 =	 		isChecked("Trinket 2"),
				SWDglyphed =		isChecked("SWD glyphed"),
				ScanOrbs = 			isChecked("Scan for Orbs"),
				ScanToF =			isChecked("Scan for ToF"),
				ThrowDP =			isChecked("ThrowDP"),
				-- Defensive
				Shield = 			isChecked("PW: Shield"),
				HealingTonic = 		isChecked("Healing Tonic"),
				DesperatePrayer = 	isChecked("Desperate Prayer"),
				FadeGlyph =			isChecked("Fade Glyph"),
				Dispersion =		isChecked("Dispersion"),
				Fade =				isChecked("Fade Aggro"),
				-- DoT Weave
				DoTWeave =			isChecked("DoTWeave"),
				SWP =				isChecked("SWP"),
				VT =				isChecked("VT"),
				-- Multitarget
				VTonTarget =		isChecked("VT on Target"),
				-- MultiSWP =			isChecked("Multi SWP"),
				-- MultiVT =			isChecked("Multi VT"),
				-- BossSWP =			isChecked("Boss SWP"),
				-- BossVT =			isChecked("Boss VT"),
				MindSear =			isChecked("MS Targets"),
				pushDP = 			isChecked("pushDP"),
				MSinsanity = 		isChecked("MSinsanity Key"),
				-- Bosshelper
				AutoGuise = 		isChecked("Auto Guise"),
				AutoMassDispel = 	isChecked("Auto Mass Dispel"),
				AutoDispel = 		isChecked("Auto Dispel"),
				AutoSilence = 		isChecked("Auto Silence"),
				AutoTarget = 		isChecked("Target Helper"),
				-- Utilities
				PWF = 				isChecked("PW: Fortitude"),
				Shadowform =		isChecked("Shadowform Outfight"),
				Feather =			isChecked("Angelic Feather"),
				BodyAndSoul = 		isChecked("Body And Soul"),
				Farmer = 			isChecked("Farmer"),
				SWPall = 			isChecked("SWP all"),
				LevelRotation =		isChecked("Level Rotation"),
				},
			-- Values
			values = {
				PWShield = 			getValue("PW: Shield"),
				HealingTonic =		getValue("Healing Tonic"),
				Dispersion	=		getValue("Dispersion"),
				Glyph = 			getValue("Fade Glyph"),
				MinHealth =			getValue("Min Health")*1000000,
				MaxTargets = 		getValue("Max Targets"),
				RefreshTime = 		getValue("Refresh Time"),
				VTRefresh =			4.5+1.5/(1+UnitSpellHaste("player")/100),
				SWPRefresh = 		5.4,
				MindSear = 			getValue("MS Targets"),
				DPon =				getValue("DP on Orbs"),
				PushTime = 			getValue("Push Time"),
				SWPall = 			getValue("SWP all"),
			},
			ASInsanity = {
				VTAll =				false,
			},
		}



		--------------
		-- Drawings --
		--------------
		


		-- correct twin ogrons options for SoD talent automatically
		--if getTalent(3,1) then options.isChecked.TwinOgrons=true end

		-- set if not set
		if options.player.lastVT==nil then options.player.lastVT=0 end
		if options.player.lastDP==nil then options.player.lastDP=99 end

		-------------
		-- TOGGLES --
		-------------

		-- Pause toggle
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end

		-- -- Focus Toggle
		-- if isChecked("Focus Toggle") and SpecificToggle("Focus Toggle") == 1 then
		-- 	RunMacroText("/focus mouseover");
		-- end

		-- -- Auto Resurrection
		-- if isChecked("Auto Rez") then
		-- 	if not isInCombat("player") and UnitIsDeadOrGhost("mouseover") and UnitIsFriend("player","mouseover") then
		-- 		if castSpell("mouseover",Rez,true,true) then return; end
		-- 	end
		-- end

		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- CHECKS --------------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------

			-- Ko'ragh Mind Controll Check
			if UnitDebuffID("player",163472) then return end

			-- Food/Invis Check
			if canRun() ~= true then return false end

			-- Mounted Check (except nagrand outpost mounts)
			if IsMounted("player") and not (UnitBuffID("player",164222) or UnitBuffID("player",165803)) then return false end

			if _Queues == nil then
				_Queues = {
					[Halo]  = false,
					[Cascade] = false,
					[DP] = false,
					[SF] = false,
					[MB] = false,
				}
			end

			if _Queues ~= nil then
				if _Queues[Halo] ~= true then 		_Queues[Halo]=false end
				if _Queues[Cascade] ~= true then 	_Queues[Cascade]=false end
				if _Queues[DP] ~= true then 		_Queues[DP]=false end
				if _Queues[SF] ~= true then 		_Queues[SF]=false end
				if _Queues[MB] ~= true then 		_Queues[MB]=false end
			end

		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- OUT OF COMBAT -------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------

			-- Power Word: Fortitude
			if not isInCombat("player") then
				if options.isChecked.PWF then 
					--Raidbuff_Priest()
					RaidBuff(2,21562)
				end
			end

			-- if not isInCombat("player") then
			-- 	if options.isChecked.PWF and (lastPWF == nil or lastPWF <= GetTime() - 5) then
			-- 		for i = 1, #nNova do
			-- 			if isPlayer(nNova[i].unit) == true 
			-- 				and not isBuffed(nNova[i].unit,{21562,109773,469,90364}) 
			-- 				and (UnitInRange(nNova[i].unit) 
			-- 					or UnitIsUnit(nNova[i].unit,"player")) then
			-- 				if castSpell("player",PWF,true) then lastPWF = GetTime(); return; end
			-- 			end
			-- 		end
			-- 	end
			-- end

			-- Boss detection
				-- not infight - reset current boss
				if UnitAffectingCombat("player")==false then
					currentBoss = nil
				end

				if UnitAffectingCombat("player") then
					if currentBoss==nil then
						currentBoss=UnitName("boss1")
					end
				end

		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- Shadowform and AutoSpeed Selfbuff -----------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------

			-- Shadowform outfight
			if not getBuffRemain("player",Shadowform) and options.isChecked.Shadowform then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-- Angelic Feather
			if isKnown(AngelicFeather) and options.buttons.Feather==2 then
				if getGround("player") and IsMovingTime(0.2) and getBuffRemain("player",AngelicFeatherBuff)<1 then
					--if options.isChecked.Feather and getGround("player") and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
					--if useFeather==true and IsMovingTime(0.2) and not UnitBuffID("player",AngelicFeatherBuff) then
					if castGround("player",AngelicFeather,30) then
						SpellStopTargeting()
						return
					end
				end
			end

			-- Body and Soul
			if isKnown(BodyAndSoul) then
				if options.isChecked.BodyAndSoul then
					if getGround("player") and IsMovingTime(0.75) and not UnitBuffID("player",PWS) and not UnitDebuffID("player",PWSDebuff) then
						if castSpell("player",PWS,true,false) then return; end
					end
				end
			end

			-- Farmer
			if options.isChecked.Farmer then
				if GetObjectExists("mouseover") then
					if getDebuffRemain("mouseover",SWP,"player")<=0 then
						if castSpell("mouseover",SWP,true,false) then return; end
					end
				end
			end

			-- SWP all
			if options.isChecked.SWPall then
				ChatOverlay("!! SWP all active !!")
				for i=1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local range = enemiesTable[i].distance
					local thisHP = enemiesTable[i].hpabs
					local maxRange = options.values.SWPall
					-- check for target and safeDoT
					if safeDoT(thisUnit) then
						if range < maxRange then
							if not UnitIsUnit("target",thisUnit) or targetAlso then
							-- check remaining time and minhealth
								if getDebuffRemain(thisUnit,SWP,"player")<=0 then
									if castSpell(thisUnit,SWP,true,false) then 
										return true
									end
								end
							end
						end
					end
				end
				--if LFU("first") then return end
			end

		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- IN COMBAT -----------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- AffectingCombat, Pause, Target, Dead/Ghost Check
		if UnitAffectingCombat("player") or UnitAffectingCombat("target") then

			-- Shadowform
			if not UnitBuffID("player",Shadowform) then
				if castSpell("player",Shadowform,true,false) then return; end
			end

			-- Bubble infight
			if options.player.Bubble then
				if PlayerHasToy(114227)==1 then
					if getBuffRemain("player",168657)<=0 then
						UseToyByName(tostring(select(1,GetItemInfo(114227))))
					end
				end
			end










			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Dummy Testing -------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print("____ " .. tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped ____")
					end
				end
			end


			--[[-----------------------------------------------------------------------------------------------------------------------------------------------]]


			if isChecked("disable Combat")==nil then


			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Queued Spells -------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			if _Queues[Halo] == true then
				ChatOverlay("Q - HALO")
				if castSpell("player",Halo,true,false) then return end
			end
			if _Queues[Cascade] == true then
				ChatOverlay("Q - CASCADE")
				if castSpell("target",Cascade,true,false) then return end
			end
			if _Queues[DP] == true then
				if options.player.ORBS < 3 then _Queues[DP] = false end
				ChatOverlay("Q - DP")
				if castSpell("target",DP,false,true) then return end
			end
			if _Queues[SF] == true or _Queues[Mindbender] == true then
				if castSpell("target",SF,true,false) then return end
				if castSpell("target",Mindbender,true,false) then return end
			end



				
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Defensives ----------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			ShadowDefensive(options)

			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Boss Specific -------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------

			BossHelper(options)
				

				------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- Offensives ----------------------------------------------------------------------------------------------------------------------------------------------
				------------------------------------------------------------------------------------------------------------------------------------------------------------
				if options.isChecked.isBoss and isBoss() then ShadowCooldowns(options) end
				if not options.isChecked.isBoss then ShadowCooldowns(options) end

				-- GCD Check
				if select(2,GetSpellCooldown(61304))>0 then
					return false
				end

				-- Some Spell specific checks for channels
					-- Do not Interrupt Searing Insanity
					if options.isChecked.MSinsanity then
						if SpecificToggle("MSinsanity Key") then
							if isChecked("Burst MSi") then
								SearingInsanity(options,false)
							else
								SearingInsanity(options,true)
							end
						end
						if UnitChannelInfo("player") == "Searing Insanity" then
							return
						end
					end

					-- -- pass if channeling mindflay
					-- if UnitChannelInfo("player")~=nil 
					-- 	and not select(1,UnitChannelInfo("player")) == "Mind Flay" then
					-- 	return false
					-- end

				-- if castingUnit() then return false; end
				
				-- -- Special Boss Mechanics
				-- if options.buttons.BossHelper == 2 then
				-- 	BossHelper()
				-- end

				--if getBuffRemain("player",MC,"player")>0 then return false end

				-- Execute
				-- CoP
				if getTalent(7,1) then 
					if ExecuteCoP(options) then return end
				end
				if getTalent(7,3) then 
					if ExecuteAS(options) then return end
				end

				LFOrbs(options)
				LFToF(options)

				-- if getHP("target")>20 then
				-- 	if options.buttons.DoT>=2 then DotEmAll(options) end
				-- 	if options.buttons.Rotation==1 and getTalent(7,1) then IcySingleWeave(options) end
				-- 	if options.buttons.Rotation==2 then IcyMultiTarget(options) end
				-- end

				------------------------------------------------------------------------------------------------------------------------------------------------------------
				--[[Level Rotation]]
				------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- if UnitLevel("player")<100 then
				-- 	-- Insanity
				-- 	if getBuffRemain("player",InsanityBuff)>0 then
				-- 		-- Check for current channel and cast Insanity
				-- 		if select(1,UnitChannelInfo("player")) == nil then
				-- 			if castSpell("target",MF,false,true) then return; end
				-- 		end
				-- 	end
				-- 	-- DP
				-- 	if castSpell("target",DP,false,true) then return end
				-- 	-- MB
				-- 	if castSpell("target",MB,false,true) then return end
				-- 	-- SoD Proc
				-- 	if getBuffStacks("player",SoDProc)>=1 then
				-- 		if castSpell("target",MSp,false,false) then return; end
				-- 	end
				-- 	-- Dots
				-- 	if throwSWP(options,true) then return end
				-- 	if refreshSWP(options,true) then return end
				-- 	if throwVT(options,true) then return end
				-- 	if refreshVT(options,true) then return end
				-- end



				-- Cop
				if getTalent(7,1) then
					-- Insanity
					if getTalent(3,3) then
						-- Clip Insanity
						ClipInsanity(options)

						------------------------------------------------------------------------------------------------------------------------------------------------------------
						--[[CoPInsanity(options)]]
						------------------------------------------------------------------------------------------------------------------------------------------------------------

						-- MB on CD
						if castSpell("target",MB,false,false) then return end
						
						-----------------
						-- DoT Weaving --
						-----------------
						-- apply SWP
							if noDoTWeave("target")==false then
								if options.player.ORBS==4 then
										if getSpellCD(MB)<=options.player.GCD then
											if not UnitDebuffID("target",SWP,"player") then
												if castSpell("target",SWP,true,false) then return end
											end
										end
								end
								-- apply VT
								if options.player.ORBS==5 then
									if not UnitDebuffID("target",VT,"player") and GetTime()-lastVT > 2*options.player.GCD then
										if castSpell("target",VT,true,true) then
											lastVT=GetTime()
											return
										end
									end
								end
							end
						----------------
						-- spend orbs --
						----------------
							-- DP 5
							if options.player.ORBS==5 then
								if getDebuffRemain("target",SWP,"player")>0 or options.isChecked.DoTWeave~=true or noDoTWeave("target")
								and getDebuffRemain("target",VT,"player")>0 or options.isChecked.DoTWeave~=true or noDoTWeave("target") then
									-- DP
									if GetTime()-lastDP>2 then
										if castSpell("target",DP,false,true) then
											lastDP=GetTime()
											return
										end
									end
								end
							end
							-- 6 Insanity Ticks
							if getBuffRemain("player",InsanityBuff)>0 then
								-- Check for current channel and cast Insanity
								if select(1,UnitChannelInfo("player")) == nil then
									if castSpell("target",MF,false,true) then return; end
								end
							end
							-- DP 3
							if options.player.ORBS==4 then
								if GetTime()-lastDP <= 8
								and GetTime()-lastDP >= 6 then
									if getBuffRemain("player",InsanityBuff)<=0 then
										if select(1,UnitChannelInfo("player")) == nil then
											if castSpell("target",DP,false,true) then return end
										end
									end
								end
							end

						--------------
						-- get orbs --
						--------------
						if getBuffRemain("player",InsanityBuff)<=0
						and GetTime()-lastDP > 8 then
							if not select(1,UnitChannelInfo("player")) ~= "Insanity" then
								-- small CDs
								if ShadowCooldownsSmall(options) then return end
								
								-- SWP
								if options.buttons.DoT==2 or options.buttons.DoT==4 then 
									throwSWP(options,false)
									refreshSWP(options,false)
								end

								-- VT
								if options.buttons.DoT==3 or options.buttons.DoT==4 then
									if throwVT(options,false) then return end
									if refreshVT(options,false) then return end
								end

								-- Mind Sear
								if options.isChecked.MindSear then
									if #getEnemies("target",10)>=options.values.MindSear then
										if select(1,UnitChannelInfo("player")) ~= "Mind Sear" then
											if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
												if castSpell("target",MS,false,true) then return; end
											end
										end
									end
								end

								-- Mind Spike
								if options.player.ORBS<5 then
									if castSpell("target",MSp,false,true) then return end
								end
							end
						end
					end -- getTalent(3,3)
					
					-- SoD
					if getTalent(3,1) then 
						--[[CoPSoD(options) not implemented]] 
					end
				end -- getTalent(7,1)

				-- AS
				if getTalent(7,3) then
					-- Insanity Talent
					if getTalent(3,3) then
						-- Clip Insanity
						ClipInsanity(options)
						------------------------------------------------------------------------------------------------------------------------------------------------------------
						--[[ASInsanity]]
						------------------------------------------------------------------------------------------------------------------------------------------------------------
						-- DP on 5 logic
						if options.player.ORBS==5 then
							if options.isChecked.pushDP then
								if castSpell("target",DP,true,false) then return end
							elseif not options.isChecked.pushDP then
								if getDebuffRemain("target",DP,player)<=0 then
									if castSpell("target",DP,true,false) then return end
								end
							end
						end

						-- MB on CD
						if options.player.ORBS<5 then
							if castSpell("target",MB,false,true) then return end
						end
						
						-- DP<5 - Hold Back DP to improve 4 set uptime
						if options.player.ORBS<=5 then
							if TierScan("T17")>=4 then
								if options.player.ORBS>=options.values.DPon or (getBuffRemain("player",MentalInstinct)<1.8 and getBuffRemain("player",MentalInstinct)>0) then
									if getBuffRemain("player",MentalInstinct)<2.8 then
										if castSpell("target",DP,true,false) then 
											return
										end
									end
								end
								-- DP on 3+ Orbs
							elseif TierScan("T17")<4 then
								if options.player.ORBS>=3 then
									-- check for running DP
									if getBuffRemain("player",InsanityBuff)<=0 then
										if castSpell("target",DP,true,false) then 
											return
										end
									end
								end
							end
						end

						if select(1,UnitChannelInfo("player")) ~= "Insanity" then
							-- SWP on MaxTargets
							if throwSWP(options,true) then return end

							-- Insanity
							if getBuffRemain("player",InsanityBuff)>0 then
								if select(1,UnitChannelInfo("player")) == nil then
									if castSpell("target",MF,false,true) then return; end
								end
							end

							-- Halo, Shadowfiend, Mindbender
							if ShadowCooldownsSmall(options) then return end
							--if options.isChecked.isBoss and isBoss() then ShadowCooldownsSmall(options) end
							--if not options.isChecked.isBoss then ShadowCooldownsSmall(options) end

							-- SWP refresh
							if refreshSWP(options,true) then return end

						
							-- VT on target
							if options.isChecked.VTonTarget then
								if getDebuffRemain("target",VT,"player")<=options.values.VTRefresh and GetTime()-lastVT > 2*options.player.GCD then
									if safeDoT("target") and safeVT("target") then
										if castSpell("target",VT,true,true) then
											lastVT=GetTime()
											return
										end
									end
								end
							end

							-- VT on all
							if options.buttons.DoT==3 or options.buttons.DoT==4 then
								if throwVT(options,true) then return end
							end
							-- Mind Sear
							if options.isChecked.MindSear then
								if #getEnemies("target",10)>=options.values.MindSear then
									if select(1,UnitChannelInfo("player")) ~= "Mind Sear" then
										if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
											if castSpell("target",MS,false,true) then return; end
										end
									end
								end
							end

							-- Insanity / MF
							if getSpellCD(MB)>0.5 then
								if select(1,UnitChannelInfo("player")) == nil then
									if castSpell("target",MF,false,true) then return; end
								end
							end
						end -- UnitChannel(Insanity)
					end -- getTalent(3,3)
					
					-- SoD Talent
					if getTalent(3,1) or getTalent(3,2) then
						------------------------------------------------------------------------------------------------------------------------------------------------------------
						--[[ASSoD & ASMindbender]]
						------------------------------------------------------------------------------------------------------------------------------------------------------------
						-- Halo, Shadowfiend, Mindbender
						if ShadowCooldownsSmall(options) then return end

						-- DP on 5 logic
						if options.player.ORBS==5 then
							if options.isChecked.pushDP then
								if castSpell("target",DP,true,false) then return end
							elseif not options.isChecked.pushDP then
								if getDebuffRemain("target",DP,player)<=0 then
									if castSpell("target",DP,true,false) then return end
								end
							end
						end
						
						-- DP<5 - Hold Back DP to improve 4 set uptime
						if options.player.ORBS<5 then
							if TierScan("T17")>=4 then
								if options.player.ORBS>=options.values.DPon or getBuffRemain("player",MentalInstinct)<1.8 then
									if getBuffRemain("player",MentalInstinct)<1.8 then
										if castSpell("target",DP,true,false) then 
											return
										end
									end
								end
								-- DP on 3+ Orbs
							elseif TierScan("T17")<4 then
								if options.player.ORBS>=3 then
									-- check for running DP
									if getBuffRemain("player",InsanityBuff)<=0 then
										if castSpell("target",DP,true,false) then 
											return
										end
									end
								end
							end
						end

						-- SoD Proc if moving
						if isMoving("player") then
							if getBuffStacks("player",SoDProc)>=1 then
								if castSpell("target",MSp,false,false) then return; end
							end
						end

						-- MB on CD
						if castSpell("target",MB,false,true) then return; end

						-- SWP on MaxTargets
						if throwSWP(options,true) then return end

						-- VT on MaxTargets
						if throwVT(options,true) then return end

						-- SoD Proc
						if getBuffStacks("player",SoDProc)>=1 then
							if castSpell("target",MSp,false,false) then return; end
						end

						-- SWP refresh
						if refreshSWP(options,true) then return end

						-- VT refresh
						if refreshVT(options,true) then return end

						-- Mind Sear
						if options.isChecked.MindSear then
							if #getEnemies("target",10)>=options.values.MindSear then
								if select(1,UnitChannelInfo("player")) ~= "Mind Sear" then
									if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
										if castSpell("target",MS,false,true) then return; end
									end
								end
							end
						end

						-- MF
						if select(1,UnitChannelInfo("player")) == nil then
							if castSpell("target",MF,false,true) then return; end
						end
					end -- getTalent(3,1)
				end -- getTalent(7,3)
			end -- disable combat option

			--[[-----------------------------------------------------------------------------------------------------------------------------------------------]]

		end -- AffectingCombat, Pause, Target, Dead/Ghost Check
	end
end
