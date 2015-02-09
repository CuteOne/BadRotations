if select(3, UnitClass("player")) == 5 then

	-- get threat situation on player and return the number
	function getThreat()
		if UnitThreatSituation("player") ~= nil then
			return UnitThreatSituation("player")
		end
		-- 0 - Unit has less than 100% raw threat (default UI shows no indicator)
		-- 1 - Unit has 100% or higher raw threat but isn't mobUnit's primary target (default UI shows yellow indicator)
		-- 2 - Unit is mobUnit's primary target, and another unit has 100% or higher raw threat (default UI shows orange indicator)
		-- 3 - Unit is mobUnit's primary target, and no other unit has 100% or higher raw threat (default UI shows red indicator)
		return 0
	end

	-- Check if SWP is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getSWP()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,SWP,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	-- Check if VT is on 3 units or if #enemiesTable is <3 then on #enemiesTable
	function getVT()
		local counter = 0
		-- iterate units for SWP
		for i=1,#enemiesTable do
			local thisUnit = enemiesTable[i].unit
			-- increase counter for each SWP
			if (UnitAffectingCombat(thisUnit) or isDummy(thisUnit)) and UnitDebuffID(thisUnit,VT,"player") then
				counter=counter+1
			end
		end
		-- return counter
		return counter
	end

	function safeDoT(datUnit)
		local Blacklist = {
			"Volatile Anomaly",
			"Rarnok",
			--"Spore Shooter",
		}
		if datUnit == nil then return true end
			for i = 1, #Blacklist do
				if UnitName(datUnit) == Blacklist[i] then
					return false
				end
			end
			return true
		end
	end

	-- Units not to dotweave, just press damage
	function noDoTWeave(datUnit)
		local Blacklist = {
			--"Dungeoneer's Training Dummy",  -- Debug use only
			"Fortified Arcane Aberration",
			"Replicating Arcane Aberration",
			"Displacing Arcane Aberration",
			"Arcane Aberration",
			"Siegemaker",
			"Ore Crate",
			"Dominator Turret",
			"Grasping Earth",
		}
		if datUnit==nil then return false end
			for i = 1, #Blacklist do
				if UnitName(datUnit) == Blacklist[i] then
					return  true
				end
			return false
		end
	end
	--[[                    ]] -- General Functions end


	--[[                    ]] -- Defensives
		function ShadowDefensive(options)
			-- Shield
			if isChecked("PW: Shield") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("PW: Shield") then
				if castSpell("player",PWS,true,false) then return; end
			end

			-- Fade (Glyphed)
			if hasGlyph(GlyphOfFade) then
				if isChecked("Fade Glyph") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("Fade Glyph") then
					if castSpell("player",Fade,true,false) then return; end
				end
			end

			-- Fade (Aggro)
			if IsInRaid() ~= false then
				if isChecked("Fade Aggro") and BadBoy_data['Defensive']==2 and getThreat()>=3 then
					--if isChecked("Fade Aggro") and BadBoy_data['Defensive'] == 2 then
					if castSpell("player",Fade,true,false) then return; end
				end
			end

			-- Healthstone/HealPot
			if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and hasHealthPot() then
				if canUse(5512) then
					UseItemByName(tostring(select(1,GetItemInfo(5512))))
				elseif canUse(healPot) then
					UseItemByName(tostring(select(1,GetItemInfo(healPot))))
				end
			end

			-- Dispersion
			if isChecked("Dispersion") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("Dispersion") then
				if castSpell("player",Disp,true,false) then return; end
			end

			-- Desperate Prayer
			if isKnown(DesperatePrayer) then
				if isChecked("Desperate Prayer") and (BadBoy_data['Defensive'] == 2) and options.player.php <= getValue("Desperate Prayer") then
					if castSpell("player",DesperatePrayer,true,false) then return; end
				end
			end
		end
	--[[                    ]] -- Defensives end


	--[[                    ]] -- Cooldowns
		function ShadowCooldowns(options)
			-- MB on CD
			if options.buttons.Cooldowns == 2 then
				if castSpell("target",MB,false,false) then return; end
			end

			if getBuffRemain("player",InsanityBuff)<=0 then
				-- Mindbender
				if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
					if castSpell("target",Mindbender) then return; end
				end

				-- Shadowfiend
				if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
					if castSpell("target",SF,true,false) then return; end
				end

				-- -- Power Infusion
				-- if isKnown(PI) and options.buttons.Cooldowns == 2 and isChecked("Power Infusion") then
				-- 	if castSpell("player",PI) then return; end
				-- end

				-- Halo
				if isKnown(Halo) and options.buttons.Halo == 2 then
					if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
						if castSpell("player",Halo,true,false) then return; end
					end
				end

				-- Trinket 1
				if options.isChecked.Trinket1 and options.buttons.Cooldowns == 2 and canTrinket(13) then
					RunMacroText("/use 13")
				end

				-- Trinket 2
				if options.isChecked.Trinket2 and options.buttons.Cooldowns == 2 and canTrinket(14) then
					RunMacroText("/use 14")
				end

				-- Berserking (Troll Racial)
				--if not UnitBuffID("player",176875) then
				if isKnown(Berserking) and options.buttons.Cooldowns == 2 and options.isChecked.Berserking then
					if castSpell("player",Berserking,true,false) then return; end
				end
				--end
			end
		end
	--[[                    ]] -- Cooldowns end


	--[[                    ]] -- Execute start
		function Execute(options)
			if getHP("target")<=20 then
				-- ORBS>=3 -> DP
				if options.player.ORBS>=3 and getBuffRemain("player",InsanityBuff)<=options.player.GCD then
					if castSpell("target",DP,true,false) then return; end
				end

				-- MB
				if castSpell("target",MB,false,false) then return; end

				-- SWD
				if castSpell("target",SWD,true,false) then return; end

				-- MF Filler
				if select(1,UnitChannelInfo("player")) == nil and options.player.ORBS<3 then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	--[[                    ]] -- Execute end


	--[[                    ]] -- LF Orbs start
		function LFOrbs(options)
			if options.isChecked.ScanOrbs then
				--if getSpellCD(SWD)<=0 and UnitPower("player", SPELL_POWER_SHADOW_ORBS)<5 then
				if options.player.ORBS<5 then
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local hp = enemiesTable[i].hp
						--print("Scanned Unit:"..i)
						if hp<20 then
							if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then
							--print("ORBED on unit: ")
							return
						end
					end
				end
			end
		end
	--[[                    ]] -- LF Orbs end


	--[[                    ]] -- LF ToF
		function LFToF(options)
			if options.isChecked.ScanToF then
				--if getSpellCD(SWD)<=0 and UnitPower("player", SPELL_POWER_SHADOW_ORBS)<5 then
				if getBuffRemain("player",ToF)<options.player.GCD then
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local hp = enemiesTable[i].hp
						--print("Scanned Unit:"..i)
						if hp<35 then
							if getSpellCD(MB)==0 then
								if castSpell(thisUnit,MB,false,false) then return; end
							end
							if getSpellCD(MB)>0 then
								if castSpell(thisUnit,SWP,true,false) then return; end
							end
						end
					end
				end
			end
		end
	--[[                    ]] -- LF Orbs end


	--[[                    ]] -- Weave DotEmAll start
		function DotEmAll(options)
			-- experimental: only use on less than 4 orbs
			if options.player.ORBS<4 then
				-- Only DotEmAll if no InsanityBuff and not casting insanity
				if not UnitBuffID("player",InsanityBuff) or select(1,UnitChannelInfo("player")) == "Insanity" then
					--if getDebuffRemain("target",SWP,"player")<=options.values.SWPRefresh then
						-- Dot the bosses
						-- SWP on all bosses except target
						if options.buttons.DoT==2 or options.buttons.DoT==4 then
							if getSWP()<=options.values.MaxTargets then
								for i = 1, #enemiesTable do
									local thisUnit = enemiesTable[i].unit
									local thisHP = UnitHealth(enemiesTable[i].unit)
									--if isBoss(thisUnit) then
										if (not UnitIsUnit("target",thisUnit)) and safeDoT(thisUnit) then
											local swpRem = getDebuffRemain(thisUnit,SWP,"player")
											if swpRem<options.values.SWPRefresh and thisHP>options.values.MinHealth then
												--if UnitExists("focus") then thisUnit="focus" end
												if castSpell(thisUnit,SWP,true,false) then return; end
											end
										end
									--end
								end
							end
						end
					--end
					-- VT on all bosses except target
					if options.buttons.DoT==3 or options.buttons.DoT==4 then
						if getVT()<=options.values.MaxTargets then
							for i = 1, #enemiesTable do
								local thisUnit = enemiesTable[i].unit
								local thisHP = UnitHealth(enemiesTable[i].unit)
								--if isBoss(thisUnit) then
									if (not UnitIsUnit("target",thisUnit)) and safeDoT(thisUnit) then
										local vtRem = getDebuffRemain(thisUnit,VT,"player")
										if vtRem<options.values.VTRefresh and thisHP>options.values.MinHealth then
											--if UnitExists("focus") then thisUnit="focus" end
											if castSpell(thisUnit,VT,true,true) then
												options.player.lastVT=GetTime()
												return;
											end
										end
									end
								--end
							end
						end
					end
				end
			end
		end
	--[[                    ]] -- Weave DotEmAll end

	--[[                    ]] -- IcySingle DotWeave start
		function IcySingleWeave(options)
			-----------------
			-- DoT Weaving --
			-----------------
				if options.isChecked.DoTWeave and getTalent(3,3)
				  and (((not UnitExists("focus")) or UnitIsDead("focus")) or (options.isChecked.TwinOgrons~=true and UnitExists("focus"))) then
					--if getTalent(3,3) then
					-- function DoTWeaveBreak()
					-- 	local counter=0
					-- 	local factor=getValue("Weave Comp")/10
					-- 	if isChecked("SWP") then counter=counter+1 end
					-- 	if isChecked("VT") then counter=counter+1 end
					-- 	return counter*GCD*factor
					-- end
					-- local Break=DoTWeaveBreak()
					-- if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<Break then

					if noDoTWeave("target")==false then
						if options.player.ORBS>=4 and getSpellCD(MB)<=2*options.player.GCD then
							--if options.isChecked.SWP then
								if not UnitDebuffID("target",SWP,"player") then
									if castSpell("target",SWP,true,false) then return; end
								end
							--end
							--if options.isChecked.VT then
								if not UnitDebuffID("target",VT,"player") and GetTime()-lastVT > 2*options.player.GCD then
									if castSpell("target",VT,true,true) then
										--options.player.lastVT=GetTime()
										lastVT=GetTime()
										return
									end
								end
							--end
						end
					end
				end

			----------------
			-- spend orbs --
			----------------
				--DP if ORBS == 5
				--if isStanding(0.3) then
					if options.player.ORBS==5 then
						if getDebuffRemain("target",SWP,"player")>0 or options.isChecked.DoTWeave~=true or noDoTWeave("target")
						  or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus")) then
							if getDebuffRemain("target",VT,"player")>0 or options.isChecked.DoTWeave~=true  or noDoTWeave("target")
							  or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus")) then
								-- DP focus
								if options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus") then
									if castSpell("focus",DP,false,true) then
										lastDP=GetTime()
										return
									end
								end
								-- DP not focus
								--if ((not UnitExists("focus")) or UnitIsDead("focus")) then
									if castSpell("target",DP,false,true) then
										lastDP=GetTime()
										return
									end
								--end
							end
						end
					end
				--end

				-- -- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
				-- if options.player.ORBS>=3 and (GetTime()-lastDP<=options.player.DPTIME+2 or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus"))) then
				-- 	if options.isChecked.TwinOgrons and UnitExists("focus") then
				-- 		if getDebuffRemain("focus",DP,"player")<=0.3*options.player.DPTIME then
				-- 			if castSpell("focus",DP,false,true) then
				-- 				lastDP=GetTime()
				-- 				return
				-- 			end
				-- 		end
				-- 	end
				-- 	if not UnitExists("focus") then
				-- 		if getDebuffRemain("focus",DP,"player")<=0.3*options.player.DPTIME then
				-- 			if castSpell("target",DP,false,true) then return; end
				-- 		end
				-- 	end
				-- end


				-- ----------------
				-- -- spend orbs --
				-- ----------------
				-- 	--DP if ORBS == 5
				-- 	--if isStanding(0.3) then
				-- 		if options.player.ORBS==5 then
				-- 			if getDebuffRemain("target",SWP,"player")>0 or options.isChecked.SWP~=true or options.isChecked.DoTWeave~=true or options.isChecked.TwinOgrons then
				-- 				if getDebuffRemain("target",VT,"player")>0 or options.isChecked.VT~=true or options.isChecked.DoTWeave~=true or options.isChecked.TwinOgrons then
				-- 					if options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus") then
				-- 						if castSpell("focus",DP,false,true) then
				-- 							lastDP=GetTime()
				-- 							return
				-- 						end
				-- 					end
				-- 					if ((not UnitExists("focus")) or UnitIsDead("focus")) then
				-- 						if castSpell("target",DP,false,true) then
				-- 							lastDP=GetTime()
				-- 							return
				-- 						end
				-- 					end
				-- 				end
				-- 			end
				-- 		end
				-- 	--end

				-- -- DP3+ focus style
				-- if options.player.ORBS>=3 then
				-- 	if options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus") then
				-- 		if getBuffRemain("player",InsanityBuff)<=0.3*options.player.DPTIME then
				-- 			if castSpell("focus",DP,false,true) then return; end
				-- 		end
				-- 	end
				-- end

				-- -- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
				-- --if options.player.ORBS>=3 and ((GetTime()-lastDP<=options.player.DPTIME+2) or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus"))) then

				-- if options.player.ORBS>=3 and (GetTime()-lastDP<=options.player.DPTIME+2) then
				-- 	--if not UnitExists("focus") then
				-- 		if castSpell("target",DP,false,true) then return; end
				-- 	--end
				-- end


				-- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
				if options.player.ORBS>=3 and (GetTime()-lastDP<=options.player.DPTIME+2 or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus"))) then
					if options.isChecked.TwinOgrons and UnitExists("focus") then
						if getDebuffRemain("focus",DP,"player")<=0 then
							if castSpell("focus",DP,false,true) then
								lastDP=GetTime()
								return
							end
						end
					end
					if not UnitExists("focus") or (options.isChecked.TwinOgrons~=true and UnitExists("focus")) then
						if getBuffRemain("player",InsanityBuff)<=0 then
							if castSpell("target",DP,false,true) then return; end
						end
					end
				end

				-- Insanity if noChanneling
				if getTalent(3,3) then
					if UnitBuffID("player",InsanityBuff) and getBuffRemain("player",InsanityBuff)>0.7*options.player.GCD
						and (((not UnitExists("focus")) or UnitIsDead("focus")) or (options.isChecked.TwinOgrons~=true and UnitExists("focus"))) then
						if select(1,UnitChannelInfo("player")) == nil then
							if castSpell("target",MF,false,true) then return; end
						end
					end
				end

			--------------
			-- get orbs --
			--------------
				if (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus")) or (not UnitBuffID("player",InsanityBuff)) then
					-- MB on CD
					if castSpell("target",MB,false,false) then return; end

					-- Ko'ragh barrier<20% (finisher can be cast if barrier<20%)
					if GetUnitName("target")=="Ko'ragh" then
						if castSpell("target",SWD,true,false) then return; end
					end

					-- SoD MSp Procs
					if getBuffStacks("player",SoDProc)>=1 then
						if castSpell("target",MSp,false,false) then return; end
					end

					-- -- not used atm. multidotting by dotemall
					-- -- Dot the bosses (only if DotEmAll is OFF)
					-- -- SWP on all bosses except target
					-- if options.buttons.DoT==1 then
					-- 	if options.isChecked.BossSWP then
					-- 		if getSWP()<=options.values.MaxTargets then
					-- 			for i = 1, #enemiesTable do
					-- 				local thisUnit = enemiesTable[i].unit
					-- 				local thisHP = enemiesTable[i].hp
					-- 				if isBoss(thisUnit) then
					-- 					if not UnitIsUnit("target",thisUnit) then
					-- 						local swpRem = getDebuffRemain(thisUnit,SWP,"player")
					-- 						if swpRem<options.values.RefreshTime then
					-- 							if castSpell(thisUnit,SWP,true,false) then return; end
					-- 						end
					-- 					end
					-- 				end
					-- 			end
					-- 		end
					-- 	end

					-- 	-- VT on all bosses except target
					-- 	if options.isChecked.BossVT then
					-- 		if getVT()<=options.values.MaxTargets then
					-- 			for i = 1, #enemiesTable do
					-- 				local thisUnit = enemiesTable[i].unit
					-- 				local thisHP = enemiesTable[i].hp
					-- 				if isBoss(thisUnit) then
					-- 					if not UnitIsUnit("target",thisUnit) then
					-- 						local vtRem = getDebuffRemain(thisUnit,VT,"player")
					-- 						if vtRem<options.values.RefreshTime then
					-- 							if castSpell(thisUnit,VT,true,false) then
					-- 								options.player.lastVT=GetTime()
					-- 								return;
					-- 							end
					-- 						end
					-- 					end
					-- 				end
					-- 			end
					-- 		end
					-- 	end
					-- end

					if not select(1,UnitChannelInfo("player")) ~= "Insanity" then

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
						--if options.player.ORBS<5 and (getDebuffRemain("target",SWP,"player")<2*options.player.GCD or options.player.ORBS<2) then
						if not(#getEnemies("target",10)<options.values.MindSear and options.isChecked.MindSear) and options.player.ORBS<5 then
							if (getBuffRemain("player",InsanityBuff)<=0 and select(1,UnitChannelInfo("player")) ~= "Insanity")
							  or (options.isChecked.TwinOgrons and UnitExists("focus") and not UnitIsDead("focus")) then
								if castSpell("target",MSp,false,true) then return; end
							end
						end

						-- SWD glyphed
						if not getTalent(3,3) then
							if hasGlyph(GlyphOfSWD) and options.isChecked.SWDglyphed and getHP("target")>=20 then
								if castSpell("target",SWDG,true,false) then return; end
							end
						end
					end
				end
		end
	--[[                    ]] -- IcySingle DotWeave end


	--[[                    ]] -- IcySingle start
		-- function IcySingle()
		-- 	-- DP
		-- 	if options.player.ORBS>=5 then
		-- 		if UnitDebuffID("target",SWP,"player") and getDebuffRemain("target",SWP,"player")>options.player.DPTIME and UnitDebuffID("target",VT,"player") and getDebuffRemain("target",VT,"player")>options.player.DPTIME then
		-- 			if options.player.ORBS==5 then
		-- 				if castSpell("target",DP,false,true) then
		-- 					lastDP=GetTime()
		-- 					return
		-- 				end
		-- 			end
		-- 		end
		-- 	end

		-- 	-- Burn Down ORBS (options)
		-- 	-- if (ORBS>=3 and not isChecked("DP5")) and GetTime()-lastDP<=DPTIME then
		-- 	-- 	if castSpell("target",DP,false,true) then return; end
		-- 	-- end

		-- 	-- Burn Down ORBS (Toggle)
		-- 	if options.player.ORBS>=3 and BadBoy_data['Burn'] == 2 and getDebuffRemain("target",DP,"player")==0 then
		-- 		if castSpell("target",DP,false,true) then return; end
		-- 	end

		-- 	-- Ko'ragh barroier bug (he is "under20% life" while barrier is under 20%)
		-- 	if GetUnitName("target")=="Ko'ragh" then
		-- 		if castSpell("target",SWD,true,false) then return; end
		-- 	end

		-- 	-- MB
		-- 	if castSpell("target",MB,false,false) then return; end

		-- 	-- Insanity
		-- 	if getTalent(3,3) then
		-- 		if UnitBuffID("player",InsanityBuff) then
		-- 			if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
		-- 				if castSpell("target",MF,false,true) then return; end
		-- 			end
		-- 		end
		-- 	end

		-- 	-- MSp if SoD proc
		-- 	if getTalent(3,1) then
		-- 		if UnitBuffID("player",SoDProc) then
		-- 			if castSpell("target",MSp,false,true) then return; end
		-- 		end
		-- 	end

		-- 	-- Dot only if not burning
		-- 	if not UnitBuffID("player",InsanityBuff) then
		-- 		if getDebuffRemain("player",InsanityBuff)<=0 then
		-- 			-- SWP
		-- 			if getDebuffRemain("target",SWP,"player")<=5.4 then
		-- 				if castSpell("target",SWP,true,false) then return; end
		-- 			end

		-- 			-- VT
		-- 			if options.player.lastVT==nil or GetTime()-options.player.lastVT > 2 then
		-- 				if getDebuffRemain("target",VT,"player")<=4.5 then
		-- 					if castSpell("target",VT,true,true) then
		-- 						options.player.lastVT=GetTime()
		-- 						return
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	end

		-- 	-- MF Filler
		-- 	if options.player.ORBS<5 then
		-- 		if getSpellCD(MB)>0.2*options.player.GCD then
		-- 			if select(1,UnitChannelInfo("player")) == nil then
		-- 				if castSpell("target",MF,false,true) then return; end
		-- 			end
		-- 		end
		-- 	end
		-- end
	--[[                    ]] -- IcySingle end


	--[[                    ]] -- Dual Target start
		-- function IcyDualTarget()
		-- 	-----------------
		-- 	-- DoT Weaving --
		-- 	-----------------
		-- 		-- if ORBS==5 --> apply DoTs if targetHP>20
		-- 		if getTalent(3,3) then
		-- 			-- function DoTWeaveBreak()
		-- 			-- 	local counter=0
		-- 			-- 	local factor=getValue("Weave Comp")/10
		-- 			-- 	if isChecked("SWP") then counter=counter+1 end
		-- 			-- 	if isChecked("VT") then counter=counter+1 end
		-- 			-- 	return counter*GCD*factor
		-- 			-- end
		-- 			-- local Break=DoTWeaveBreak()
		-- 			-- if ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<Break then
		-- 			if options.player.ORBS>=4 and getHP("target")>20 and getSpellCD(MB)<2*options.player.GCD then
		-- 				if isChecked("SWP") then
		-- 					if not UnitDebuffID("target",SWP,"player") then
		-- 						if castSpell("target",SWP,true,false) then return; end
		-- 					end
		-- 				end
		-- 				if isChecked("VT") then
		-- 					if not UnitDebuffID("target",VT,"player") and GetTime()-options.player.lastVT > 2 then
		-- 						if castSpell("target",VT,true,true) then
		-- 							options.player.lastVT=GetTime()
		-- 							return
		-- 						end
		-- 					end
		-- 				end
		-- 			end
		-- 		end
		-- 	----------------
		-- 	-- spend orbs --
		-- 	----------------
		-- 		--DP if ORBS == 5
		-- 		--if isStanding(0.3) then
		-- 			if options.player.ORBS==5 then
		-- 				if castSpell("target",DP,false,true) then
		-- 					lastDP=GetTime()
		-- 					return
		-- 				end
		-- 			end
		-- 		--end

		-- 		-- DP if ORBS>=3 and lastDP<DPTIME and InsanityBuff<DPTICK
		-- 		if options.player.ORBS>=3 and GetTime()-lastDP<=options.player.DPTIME+2 then
		-- 			if castSpell("target",DP,false,true) then return; end
		-- 		end

		-- 		-- Insanity if noChanneling
		-- 		if getTalent(3,3) then
		-- 			if UnitBuffID("player",InsanityBuff) and getBuffRemain("player",InsanityBuff)>0.7*options.player.GCD then
		-- 				--if select(1,UnitChannelInfo("player")) == nil then
		-- 					if castSpell("target",MF,false,true) then return; end
		-- 				--end
		-- 			end
		-- 		end

		-- 	--------------
		-- 	-- get orbs --
		-- 	--------------
		-- 		if not UnitDebuffID("player",InsanityBuff) then
		-- 			-- MB on CD
		-- 			if select(1,UnitChannelInfo("player")) == nil then
		-- 				if castSpell("target",MB,false,false) then return; end
		-- 			end

		-- 			-- Dot the bosses
		-- 			-- SWP on all bosses except target
		-- 			if isChecked("Boss SWP") then
		-- 				for i = 1, #enemiesTable do
		-- 					local thisUnit = enemiesTable[i].unit
		-- 					if not UnitIsUnit("target",thisUnit) then
		-- 						if isBoss(thisUnit) then
		-- 							local swpRem = getDebuffRemain(thisUnit,SWP,"player")
		-- 							if swpRem<getRefreshTime then
		-- 								if castSpell(thisUnit,SWP,true,false) then return; end
		-- 							end
		-- 						end
		-- 					end
		-- 				end
		-- 			end

		-- 			-- VT on all bosses except target
		-- 			if isChecked("Boss VT") then
		-- 				for i = 1, #enemiesTable do
		-- 					local thisUnit = enemiesTable[i].unit
		-- 					if not UnitIsUnit("target",thisUnit) then
		-- 						if isBoss(thisUnit) then
		-- 							local vtRem = getDebuffRemain(thisUnit,VT,"player")
		-- 							if vtRem<getRefreshTime then
		-- 								if castSpell(thisUnit,VT,true,false) then
		-- 									options.player.lastVT=GetTime()
		-- 									return;
		-- 								end
		-- 							end
		-- 						end
		-- 					end
		-- 				end
		-- 			end

		-- 			-- Mind Spike
		-- 			if options.player.ORBS<5 and getBuffRemain("player",InsanityBuff)<=options.player.GCD and getSpellCD(MB)>0 then
		-- 				if castSpell("target",MSp,false,true) then return; end
		-- 			end

		-- 			-- SWD glyphed
		-- 			if not getTalent(3,3) then
		-- 				if hasGlyph(GlyphOfSWD) and isChecked("SWD glyphed") and getHP("target")>=20 then
		-- 					if castSpell("target",SWDG,true,false) then return; end
		-- 				end
		-- 			end
		-- 		end
		-- end
	--[[                    ]] -- Dual Target end


	--[[                    ]] -- IcyMultiTarget start
		function IcyMultiTarget(options)
			-- DP
			if options.player.ORBS>=3 then
				--if (getDebuffRemain("target",SWP,"player")>DPTIME or not isChecked("Multi SWP")) and (getDebuffRemain("target",VT,"player")>DPTIME or not isChecked("Multi VT")) then
					if getDebuffRemain("target",DP,"player")<=0 then
						if castSpell("target",DP,false,true) then return; end
					end
				--end
			end

			-- -- Burn Down ORBS (Toggle)
			-- if ORBS>=3 and BadBoy_data['Burn'] == 2 and getDebuffRemain("target",DP,"player")==0 then
			-- 	if castSpell("target",DP,false,true) then return; end
			-- end

			-- MB
			if options.player.ORBS<5 then
				if castSpell("target",MB,false,false) then return; end
			end

			-- -- Insanity with 2 targets
			-- if getTalent(3,3) then
			-- 	if #enemiesTable<=2 then
			-- 		if UnitBuffID("player",InsanityBuff) then
			-- 			if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
			-- 				if castSpell("target",MF,false,true) then return; end
			-- 			end
			-- 		end
			-- 	end
			-- end
			--if select(1,UnitChannelInfo("player")) == "Insanity" then return; end

			-- -- SWD on Unit in range and hp<20
			-- if getSpellCD(SWD)==0 and options.player.ORBS<5 then
			-- 	for i=1,#enemiesTable do
			-- 		local thisUnit = enemiesTable[i].unit
			-- 		if enemiesTable[i].hp<20 then
			-- 			if castSpell(thisUnit,SWD,true,false) then return; end
			-- 		end
			-- 	end
			-- end


			-- SWP
			--if options.isChecked.MultiSWP then
				if getSWP()<=options.values.MaxTargets then
					for i = 1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hp
						--if isBoss(thisUnit) then
							--if not UnitIsUnit("target",thisUnit) then
								local swpRem = getDebuffRemain(thisUnit,SWP,"player")
								if swpRem<options.values.SWPRefresh then
									if castSpell(thisUnit,SWP,true,false) then return; end
								end
							--end
						--end
					end
				end
			--end

			-- VT on all bosses except target
			--if options.isChecked.MultiVT then
				if getVT()<=options.values.MaxTargets then
					for i = 1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hp
						--if isBoss(thisUnit) then
							--if not UnitIsUnit("target",thisUnit) then
								local vtRem = getDebuffRemain(thisUnit,VT,"player")
								if vtRem<options.values.VTRefresh then
									if castSpell(thisUnit,VT,true,false) then
										options.player.lastVT=GetTime()
										return;
									end
								end
							--end
						--end
					end
				end
			--end

			-- -- SWP on max targets (options)
			-- if getSWP()<=getValue("Max Targets") then
			-- 	-- apply on current target before iterating
			-- 	if getDebuffRemain("target",SWP,"player")<getValue("Refresh Time") then
			-- 		if castSpell("target",SWP,true,false) then return; end
			-- 	end
			-- 	-- iterate the table if multiSWP
			-- 	if isChecked("Multi SWP") then
			-- 		for i = 1, #enemiesTable do
			-- 			local thisUnit = enemiesTable[i].unit
			-- 			local ttd = getTimeToDie(thisUnit)
			-- 			local swpRem = getDebuffRemain(thisUnit,SWP,"player")
			-- 			if (not isLongTimeCCed(thisUnit)) and swpRem<getValue("Refresh Time") then
			-- 				if castSpell(thisUnit,SWP,true,false) then return; end
			-- 			end
			-- 		end
			-- 	end
			-- end

			-- -- VT on Unit in range
			-- if getVT()<=getValue("Max Targets") then
			-- 	-- apply on current target before iterating
			-- 	if getDebuffRemain("target",VT,"player")<getValue("Refresh Time") and GetTime()-lastVT>2*GCD then
			-- 		if castSpell("target",VT,true,true) then
			-- 			lastVT=GetTime()
			-- 			return
			-- 		end
			-- 	end
			-- 	-- iterate the table if multiVT
			-- 	if isChecked("Multi VT") then
			-- 		for i = 1, #enemiesTable do
			-- 			local thisUnit = enemiesTable[i].unit
			-- 			local ttd = getTimeToDie(thisUnit)
			-- 			local vtRem = getDebuffRemain(thisUnit,VT,"player")
			-- 			if (not isLongTimeCCed(thisUnit)) and vtRem<getValue("Refresh Time") and GetTime()-lastVT>2*GCD then
			-- 				if castSpell(thisUnit,VT,true,true) then
			-- 					lastVT=GetTime()
			-- 					return
			-- 				end
			-- 			end
			-- 		end
			-- 	end
			-- end

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

			-- MF/Insanity
			--if getDebuffRemain("target",SWP,"player")<getValue("Refresh Time") then
				if options.player.ORBS<=5 and select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			--end
		end
	--[[                    ]] -- IcyMultiTarget end
end