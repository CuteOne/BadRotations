if select(3, UnitClass("player")) == 5 then
	function PriestDiscipline()

		if currentConfig ~= "Discipline ragnar" then
			DisciplineConfig()
			--DisciplineToggles()
			currentConfig = "Discipline ragnar"
		end
		-- Head End

		spell = {
			archangel = 81700,
			cascade = 121135,
			clarityOfWill = 152118,
			desperatePrayer = 19236,
			dispelMagi = 528,
			divineStar = 110774,
			fade = 586,
			fearWard = 6346,
			flashHeal = 2061,
			halo = 120517,
			heal = 2060,
			holyFire = 14914,
			holyNova = 132157,
			leapOfFaith = 73325,
			levitate = 1706,
			massDispel = 32375,
			mindbender = 123040,
			mindSear = 48045,
			painSupression = 33206,
			penance = 47540,
			powerInfusion = 10060,
			pwBarrier = 62618,
			pws = 17,
			pwSolace = 129250,
			pwsDebuff = 6788,
			PoH = 596,
			PoM = 33076,
			PoMBuff = 41635,
			purify = 527,
			savingGrace = 152116,
			spectralGuise = 112833,
			SWP = 589,
			shadowfiend = 34433,
			silence = 15487,
			spiritShell = 109964,
			smite = 585,
		}

		buff = {
			evangelism = {
				up = UnitBuffID("player",81661),
				remains = getBuffRemain("player",81661),
				stacks = getBuffStacks("player",81661),
			},
			archangel = {
				up = UnitBuffID("player",81700),
				remains = getBuffRemain("player",81700),
				cd = getSpellCD(81700),
			},
			empoweredAA = {
				up = UnitBuffID("player",172359),
				remains = getBuffRemain("player",172359),
			},
			borrowedTime = {
				up = UnitBuffID("player",59889),
				remains = getBuffRemain("player",59889),
			},
			wordOfMending = {
				up = UnitBuffID("player",155362),
				remains = getBuffRemain("player",155362),
				stacks = getBuffStacks("player",155362),
			},
		}

		debuff = {
		}

		player = {
			hp = getHP("player"),
			mana = getMana("player"),
			GCD = 1.5/(1+UnitSpellHaste("player")/100),
			spellpower = GetSpellBonusDamage(2),
			crit = GetCritChance(),
			mastery = GetMastery(),
			multistrike = GetMultistrike(),
		}

		health = {
			raidDeficitPercent = 0,
			raidDeficitAbsolute = 0,
			group1DeficitPercent = 0,
			group1DeficitAbsolute = 0,
			group2DeficitPercent = 0,
			group2DeficitAbsolute = 0,
			group3DeficitPercent = 0,
			group3DeficitAbsolute = 0,
			group4DeficitPercent = 0,
			group4DeficitAbsolute = 0,
		}

		heal = {
			pws = {
				shield = getTooltipSize(spell.pws),
			},
			CoW = {
				shield = getTooltipSize(spell.clarityOfWill),
			},
			penance = {
				heal = getTooltipSize(spell.penance)*2.96,
			},
			heal = {
				heal = getTooltipSize(spell.heal),
			},
			flashHeal = {
				heal = getTooltipSize(spell.flashHeal),
			},
			PoH = {
				heal = getTooltipSize(spell.PoH),
			},
			PoM = {
				heal = getTooltipSize(spell.PoM),
			},
			-- holyNova = {
			-- 	heal = getTooltipSize(spell.holyNova)*1.8795,
			-- },
		}

		talent = {
		}

		options = {
			cooldowns = {
				powerInfusion = {check=isChecked("Heal"),value=getValue("Heal")},
				mindbender = {check=isChecked("Heal"),value=getValue("Heal")},
				shadowfiend = {check=isChecked("Heal"),value=getValue("Heal")},

			},
			heal = {
				SmiteFiller = {check=isChecked("Smite Filler"),value=getValue("Smite Filler")},
				PWS = {check=isChecked("PW:Shield"),value=getValue("PW:Shield")},
				heal = {check=isChecked("Heal"),value=getValue("Heal")},
				flashHeal = {check=isChecked("Flash Heal"),value=getValue("Flash Heal")},
				penance = {check=isChecked("Penance"),value=getValue("Penance")},
			},
			utilities = {
				PWF = {check = isChecked("PW:Fortitude")},
			},
		}

		toggles = {
		}

		------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- CHECKS --------------------------------------------------------------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------------------------------------------------------------
		if canRun() ~= true or UnitInVehicle("Player") then return false end

		-- Mounted Check (except nagrand outpost mounts)
		if IsMounted("player") and not (UnitBuffID("player",164222) 
			or UnitBuffID("player",165803)) then 
			return false 
		end

		if _Queues == nil then
			_Queues = {
				[spell.archangel]  = false,
				[spell.cascade] = false,
			}
		end

		------------------------------------------------------------------------------------------------------
		-- Pause ---------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0)
			return
		end

		------------------------------------------------------------------------------------------------------
		-- Input / Keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- Always check/do -----------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		-- if enemiesTable then
		-- 	if enemiesTableTimer <= GetTime() - 0.5 then
		-- 		table.sort(enemiesTable, function(x,y)
		-- 			return x.hpabs and y.hpabs and x.hpabs > y.hpabs or false
		-- 		end)
		-- 	end
		-- end

		------------------------------------------------------------------------------------------------------
		-- Out of Combat -------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then
			-- Power Word: Fortitude
			if options.utilities.PWF.check then 
				--Raidbuff_Priest()
				RaidBuff(2,21562)
			end
		end -- Out of Combat end

		------------------------------------------------------------------------------------------------------
		-- In Combat -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isInCombat("player") or isInCombat("target") then

			------------------------------------------------------------------------------------------------------
			-- Dummy Test ----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if isChecked("DPS Testing") then
				if UnitExists("target") then
					if getCombatTime() >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
						StopAttack()
						ClearTarget()
						print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
					end
				end
			end

			------------------------------------------------------------------------------------------------------------------------------------------------------------
			-- Queued Spells -------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			if _Queues[spell.archangel] == true then
				ChatOverlay("Q - ARCHANGEL")
				if castArchangel() then return end
			end
			if _Queues[spell.cascade] == true then
				ChatOverlay("Q - CASCADE")
				if castCascadeAuto() then return end
			end

			------------------------------------------------------------------------------------------------------
			-- Defensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Offensive -----------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			
			------------------------------------------------------------------------------------------------------
			-- Do everytime --------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Rotation ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if select(1,UnitChannelInfo("player")) ~= "Penance" then
				-- Penance
					-- tank
					if castPenanceTank() then return end
					-- player
					if castPenancePlayer() then return end
					-- damage
					if castPenanceEnemy() then return end
				
				-- holy fire / power word: solace
				if getTalent(3,3) then
					if player.mana <= 98 then
						if castPWSolace() then return end
					end
				else
					if buff.evangelism.stacks<5 then
						if castHolyFire() then return end
					end
				end
				
				-- smite
				if buff.evangelism.stacks<5 then
					if castSmite() then return end
				end
				
				-- PWS
				if castPWSTank() then return end
				if castPWSPlayer() then return end
				
				-- PoM (maxPoM?)
				if getPoM()<1 then
					if castPoM() then return end
				end
				
				-- PoH on group with 3+ targets with minimal overheal

				-- flash heal
				if castFlashHeal() then return end
				
				-- heal
				if castHeal() then return end

				-- smite filler
				if options.heal.SmiteFiller.check then
					if player.mana >= options.heal.SmiteFiller.value then
						if castSmite() then return end
					end
				end	

			end
		end
	end
end