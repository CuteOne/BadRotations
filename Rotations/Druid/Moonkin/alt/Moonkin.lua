if select(3, UnitClass("player")) == 11 then

	function DruidMoonkin()
		-- Spell List
		_barkskin           = 22812
		_celestialAlignment = 112071
		_forceOfNature      = 33831
		_healingTouch       = 5185
		_incarnationboom    = 102560
		_markOfTheWild      = 1126
		_moonfire           = 8921
		_moonkinForm        = 24858
		_naturesVigil       = 124974
		_rejuvenation       = 774
		_solarBeam          = 78675
		_starfall           = 48505
		_starfire           = 2912
		_starsurge          = 78674
		_stellarFlare       = 152221
		_sunfire            = 93402
		_wrath              = 5176
		_moonfiredebuff = 164812
		_sunfiredebuff = 164815

		if currentConfig ~= "Moonkin CodeMyLife" then
			MoonkinToggles()
			MoonkinConfig()
			currentConfig = "Moonkin CodeMyLife"
		end
		MoonkinFunctions()
		GroupInfo();
		------------------------------------------------------------------------------------------------------
		-- Locals --------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		local php                                     = getHP("player")
		local thp                                     = getHP("target")
		local owl                                     = UnitBuffID("player",_moonkinForm)
		local ttd                                     = getTimeToDie("target")
		local eclipseDirection                        = GetEclipseDirection()
		local eclipseEnergy                           = UnitPower("player",8)
		local bcelestialAlignment                     = UnitBuffID("player",_celestialAlignment)
		local bincarnation                            = UnitBuffID("player",_incarnationboom)
		local blunarEmpowerment                       = UnitBuffID("player",164547)
		local blunarEmpowermentStacks                 = getBuffStacks("player",164547)
		local blunarPeak                              = UnitBuffID("player",171743)
		local bsolarEmpowerment                       = UnitBuffID("player",164545)
		local bsolarEmpowermentStacks                 = getBuffStacks("player",164545)
		local bsolarPeak                              = UnitBuffID("player",171744)
		local bstarfall                               = UnitBuffID("player",_starfall)
		local bcelestialAlignmentremain               = getBuffRemain("player",_celestialAlignment)
		local bincarnationremain                      = getBuffRemain("player",_incarnationboom)
		local blunarEmpowermentremain                 = getBuffRemain("player",164547)
		local blunarPeakremain                        = getBuffRemain("player",171743)
		local bsolarEmpowermentremain                 = getBuffRemain("player",164545)
		local bsolarPeakremain                        = getBuffRemain("player",171744)
		local bstarfallremain                         = getBuffRemain("player",_starfall)
		local incarnationcd                           = getSpellCD(_incarnationboom)
		local forceOfNatureStacks                     = GetSpellCharges(_forceOfNature)
		local surgeStacks,_,surgeTime                 = GetSpellCharges(_starsurge)
		local surgeRechargetime                       = getRecharge(_starsurge)
		local starfireOverlayed                       = IsSpellOverlayed(2912)
		local starfirecasttime                        = (select(4, GetSpellInfo(2912))/1000)
		local wrathOverlayed                          = IsSpellOverlayed(5176)
		local wrathcasttime                           = (select(4, GetSpellInfo(5176))/1000)
		local forceOfNatureStacks,_,forceOfNatureTime = GetSpellCharges(_forceOfNature)
		local castingStarsurge                        = 0
		local lastStarsurge                           = 0
		------------------------------------------------------------------------------------------------------
		-- Food/Invis Check ----------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if canRun() ~= true or UnitInVehicle("Player") then
			return false
		end
		------------------------------------------------------------------------------------------------------
		-- Pause ---------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isChecked("Pause Toggle") and SpecificToggle("Pause Toggle") == true then
			ChatOverlay("|cffFF0000BadBoy Paused", 0); return;
		end
		------------------------------------------------------------------------------------------------------
		-- Input / Keys --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------

		------------------------------------------------------------------------------------------------------
		-- Always check --------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		-- actions.precombat+=/mark_of_the_wild,if=!aura.str_agi_int.up
		if isChecked("Mark of the Wild") and not hasmouse and not (IsFlying() or IsMounted()) and not stealth then -- and not isInCombat("player")
			for i = 1, #members do --members
				if not isBuffed(members[i].Unit,{115921,20217,1126,90363,159988,160017,160077})
					and (#bb.friend==select(5,GetInstanceInfo())
					or select(2,IsInInstance())=="none"
					or (select(2,IsInInstance())=="party" and not UnitInParty("player")))
			then
				if castSpell("player",mow,true,false,false) then return end
			end
		end
		end
		-- actions.precombat+=/moonkin_form
		if isChecked("Moonkin Form") then
			if not owl then
				if castSpell("player",_moonkinForm,true,false) then
					return
				end
			end
		end

		boomOpener()
		------------------------------------------------------------------------------------------------------
		-- Out of Combat -------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if not isInCombat("player") then

		end -- Out of Combat end
		------------------------------------------------------------------------------------------------------
		-- In Combat -----------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------------------
		if isInCombat("player") then
			if UnitCastingInfo("player") == GetSpellInfo(_starsurge) then
				castingStarsurge = GetTime()
			end
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
			------------------------------------------------------------------------------------------------------
			-- Defensive Cooldowns -------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			--Natures Vigil
			if isChecked("Natures Vigil") then
				if castSpell("player",_naturesVigil,true,false) then
					return
				end
			end
			-- Rejuvenation
			if isChecked("Rejuvenation") and php <= getValue("Rejuvenation") then
				if castSpell("player",_rejuvenation,true,false) then
					return
				end
			end
			--Barkskin
			if isChecked("Barkskin") and php <= getValue("Barkskin") then
				if castSpell("player",_barkskin,true,false) then
					return
				end
			end
			--Healing Touch
			if isChecked("Healing Touch") and php <= getValue("Healing Touch") and isStanding(0.3) then
				if castSpell("player",_healingTouch,false,true) then
					return
				end
			end
			-- Healthstone / Potion
			if isChecked("Healthstone / Potion") == true and php <= getValue("Healthstone / Potion")
				and isInCombat("player") and hasHealthPot() then
				if canUse(5512) then
					UseItemByName(tostring(select(1,GetItemInfo(5512))))
				elseif canUse(healPot) then
					UseItemByName(tostring(select(1,GetItemInfo(healPot))))
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Offensive Cooldowns -------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			-- actions+=/berserking,if=buff.celestial_alignment.up
			if isChecked("Racial") then
				if select(2, UnitRace("player")) == "Troll" then
					if castSpell("player",26297,true) then
						return;
					end
				end
			end
			--On use Trinkets
			if isChecked("Use Trinket") then
				if canTrinket(13) and useBoomCDs() then
					RunMacroText("/use 13")
					if IsAoEPending() then
						local X,Y,Z = GetObjectPosition(Unit)
						ClickPosition(X,Y,Z,true)
					end
				end
				if canTrinket(14) and useBoomCDs() then
					RunMacroText("/use 14")
					if IsAoEPending() then
						local X,Y,Z = GetObjectPosition(Unit)
						ClickPosition(X,Y,Z,true)
					end
				end
			end
			-- actions+=/force_of_nature,if=trinket.stat.intellect.up|charges=3|target.time_to_die<21
			if forceOfNatureStacks == 3 then
				if castSpell(dynamicTarget(40,true),_forceOfNature,false,false) then
					return
				end
			end
			------------------------------------------------------------------------------------------------------
			-- Do everytime --------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------
			-- Rotation ------------------------------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------
			if openerstarted == false then
				if not useBoomAoE() then
					ChatOverlay("Single", 0)
					--Moving Filler
					if isMoving("player") and IsMovingTime(1) and not hasfox() then
						if castSpell("target",_moonfire,false,false) then
							return
						end
					end
					--starsurge
					if lastStarsurge < GetTime() - 2 and castingStarsurge < GetTime() - 0.5 then
						if not blunarEmpowerment
							and (eclipseEnergy < -20 and eclipseDirection == "sun")
							or (eclipseEnergy < -80 and eclipseDirection == "moon") then
							if castSpell(dynamicTarget(40,true),_starsurge,false,false) then
								return
							end
						end
						if not bsolarEmpowerment
							and (eclipseEnergy > -20 and eclipseDirection == "sun")
							or (eclipseEnergy > 80 and eclipseDirection == "moon") then
							if castSpell(dynamicTarget(40,true),_starsurge,false,false) then
								return
							end
						end
						if (surgeStacks == 2 and surgeRechargetime < 6) or surgeStacks == 3 then
							if castSpell(dynamicTarget(40,true),_starsurge,false,false) then
								return
							end
						end
					end --lastStarsurge end
					-- CA
					if useBoomCDs() and isChecked("Celestial Alignment") then
						if eclipseChangeTimer() < 8 or ttd < 20 then
							if castSpell("player",_celestialAlignment,true) then
								return
							end
						end
					end
					-- incarnation
					if useBoomCDs() and isChecked("Incarnation") then
						if castSpell("player",_incarnationboom,true) then
							return
						end
					end
					--sunfire
					if getSunfireStatus() then
						if sunfireremain(dynamicTarget(40,true)) < 4 then
							if castSpell(dynamicTarget(40,true),_moonfire,false,false) then
								return
							end
						end
					end
					-- stellar flare
					if getTalent(7,2) then
						if eclipseEnergy > -30 and eclipseEnergy < 30 and getDebuffRemain(dynamicTarget(40,true),_stellarFlare,"player") < 7 then
							if castSpell(dynamicTarget(40,true),_stellarFlare,false,true) then
								return
							end
						end
					end
					--moonfire
					if not getSunfireStatus() then
						if (moonfireremain(dynamicTarget(40,true)) < 4)
							or (bcelestialAlignment and bcelestialAlignmentremain <= 2 and moonfireremain(dynamicTarget(40,true)) < 12) then
							if castSpell(dynamicTarget(40,true),_moonfire,false,false) then
								return
							end
						end
					end
					--filler
					if (eclipseDirection == "sun" and eclipseEnergy >= -20) or (eclipseDirection == "moon" and eclipseEnergy >= 20) then
						if castSpell(dynamicTarget(40,true),_wrath,false,true) then
							return
						end
					else
						if castSpell(dynamicTarget(40,true),_starfire,false,true) then
							return
						end
					end
				end -- not use BoomAoE() end

				if useBoomAoE() then
					--Moving Filler
					if isMoving("player") and IsMovingTime(1) and not hasfox() then
						if castSpell(dynamicTarget(40,true),_moonfire,false,false) then
							return
						end
					end
					-- CA
					if useBoomCDs() and isChecked("Celestial Alignment") then
						if eclipseChangeTimer() < 8 or ttd < 20 then
							if castSpell("player",_celestialAlignment,true) then
								return
							end
						end
					end
					-- incarnation
					if useBoomCDs() and isChecked("Incarnation") then
						if castSpell("player",_incarnationboom,true) then
							return
						end
					end
					--sunfire spread
					if getSunfireStatus() then
						if useMultidot() then
							if castSunfireCycle("All",8) then
								return
							end
						end
						if not useMultidot() then
							if sunfireremain(dynamicTarget(40,true)) < 4 then
								if castSpell(dynamicTarget(40,true),_moonfire,false,false) then
									return
								end
							end
						end
					end
					--starfall
					if useStarfall() then
						if not bstarfall then
							if castSpell("player",_starfall,true,false) then
								return
							end
						end
					end
					-- stellar flare
					if getTalent(7,2) then
						if eclipseEnergy > -30 and eclipseEnergy < 30 and getDebuffRemain("target",_stellarFlare,"player") < 7 then
							if castSpell(dynamicTarget(40,true),_stellarFlare,false,true) then
								return
							end
						end
					end
					--moonfire spread
					if not getSunfireStatus() then
						if useMultidot() then
							if castDotCycle("All",8921,40,false,false,12) then
								return
							end
						end
						if not useMultidot() then
							if moonfireremain(dynamicTarget(40,true)) < 12 then
								if castSpell(dynamicTarget(40,true),_moonfire,false,false) then
									return
								end
							end
						end
						-- for i = 1, #bb.enemy do
						--   local thisUnit = bb.enemy[i].unit
						--   local mfRem = getDebuffRemain(thisUnit,_moonfire,"player")
						--   if mfRem < 12 then
						--     if castSpell(thisUnit,_moonfire,false,false) then
						--       return
						--     end
						--   end
						-- end
					end
					--filler
					if (eclipseDirection == "sun" and eclipseEnergy >= -20) or (eclipseDirection == "moon" and eclipseEnergy >= 20) then
						if castSpell(dynamicTarget(40,true),_wrath,false,true) then
							return
						end
					else
						if castSpell(dynamicTarget(40,true),_starfire,false,true) then
							return
						end
					end
				end -- use BoomAoE() end
			end --if openerstarted == false end


		end -- In Combat end
	end -- DruidMoonkin()
end --select class end




