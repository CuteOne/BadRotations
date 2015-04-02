if select(3, UnitClass("player")) == 5 then

	-- raidbuff
	function Raidbuff_Priest()
		if not PWF_last_check or PWF_last_check + 5 < GetTime() then
			PWF_last_check = GetTime()
			PWF_unbuffedPlayers = {}
			--local unbuffedPlayers = PWF_unbuffedPlayers

			local StaminaTable = {"Power Word: Fortitude","Blood Pact","Commanding Shout"}
			if GetNumGroupMembers()==0 then
				if not UnitIsDeadOrGhost("player")  then
					local playerBuffed=false
					for auraIndex=1, #StaminaTable do
						local buffActive=UnitAura("player", StaminaTable[auraIndex])
						playerBuffed=playerBuffed or buffActive ~= nil
					end

					if not playerBuffed then
						local playerName=UnitName("player");
						--table.insert(unbuffedPlayers, playerName)
						if castSpell("player",PWF,true) then return; end
					end
					--return unbuffedPlayers[1] ~= nil
				end
			else
				for index=1, GetNumGroupMembers() do
					local name, _, subgroup, _, _, _, zone, online, isDead, _, _ = GetRaidRosterInfo(index)
					if online and not isDead and 1==IsSpellInRange(StaminaTable[1], "raid"..index) then
						local playerBuffed = false
						for auraIndex=1, #StaminaTable do
							local buffActive = UnitAura(("raid"..index), StaminaTable[auraIndex])
							playerBuffed = playerBuffed or buffActive ~= nil
						end
						if not playerBuffed then
							--table.insert(unbuffedPlayers, name)
							if castSpell("player",PWF,true) then return; end
						end
					end
				end
				--return unbuffedPlayers[1] ~= nil
			end
		end
	end

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

	-- Units not to dot with DoTEmAll
	function safeDoT(datUnit)
		local Blacklist = {
			-- Highmaul
			"Volatile Anomaly",
			-- Blackrock Foundry
			"Pack Beast",
		}
		-- nil Protection
		if datUnit == nil then 
			return true 
		end
		-- Iterate the blacklist
		for i = 1, #Blacklist do
			if UnitName(datUnit) == Blacklist[i] then
				return false
			end
		end
		-- unit is not in blacklist
		return true
	end

	function safeVT(datUnit)
		local Blacklist = {
			-- Blackrock Foundry
			"Grasping Earth",
		}
		-- nil Protection
		if datUnit == nil then 
			return true
		end
		-- Iterate the blacklist
		for i = 1, #Blacklist do
			if UnitName(datUnit) == Blacklist[i] then
				return false
			end
		end
		-- unit is not in blacklist
		return true
	end

	-- Units not to dotweave, just press damage
	function noDoTWeave(datUnit)
		local Blacklist = {
			-- Highmaul
			"Fortified Arcane Aberration",
			"Replicating Arcane Aberration",
			"Displacing Arcane Aberration",
			"Arcane Aberration",
			-- Blackrock Foundry
			"Siegemaker",
			"Ore Crate",
			"Dominator Turret",
			"Grasping Earth",
			"Cinder Wolf",
			"Iron Gunnery Sergeant",
			"Heavy Spear",
			"Aknor Steelbringer",
		}
		if datUnit==nil then return false end
			for i = 1, #Blacklist do
				if UnitName(datUnit) == Blacklist[i] then
					return  true
				end
			return false
		end
	end

	-- Looking for Unit
	-- not for use atm
	function LFU2(datName,rangeCheck)
		-- range Check: FALSE
		if rangeCheck==nil or rangeCheck>0 then
			if rangeCheck==nil then
				-- 1) check
				if UnitName("target")~=datName then
					TargetUnit(datName)
				end
				-- 2) return
				if UnitName("target")==datName then
					return true
				else
					return false
				end
			-- range check: TRUE
			elseif rangeCheck>0 then
				-- 1) check and target
				if UnitName("target")==datName and getDistance("player","target")<rangeCheck then
					return false
				elseif UnitName("target")~=datName and getDistance("player",datName)<=rangeCheck then
					TargetUnit(datName)
				end
				-- 2) return
				if UnitName("target")==datName then
					return true
				else
					return false
				end
			else
				return false
			end
		end
		return false
	end

	-- Looking for Unit
	function LFU(datName)
		-- nil prevention
		if datName==nil then 
			return false 
		end
		-- target specified Unit
		TargetUnit(datName)
		-- check and return
		if UnitName("target")==datName then
			return true
		else 
			return false
		end
	end

	-- Sort enemiesTable by distance
	function sortByDistance()
		if enemiesTable then
			table.sort(enemiesTable, function(x,y)
				return x.distance and y.distance and x.distance > y.distance or false
			end)
		end
	end
	--[[                    ]] -- General Functions end

	--[[                    ]] -- Defensives
		function ShadowDefensive(options)
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

			-- Healthstone/HealPot
			if isChecked("Healthstone") and getHP("player") <= getValue("Healthstone") and hasHealthPot() then
				if canUse(5512) then
					UseItemByName(tostring(select(1,GetItemInfo(5512))))
				elseif canUse(healPot) then
					UseItemByName(tostring(select(1,GetItemInfo(healPot))))
				end
			end

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
		end
	--[[                    ]] -- Defensives end

	--[[                    ]] -- Cooldowns
		function ShadowCooldowns(options)
			-- MB on CD
			if options.buttons.Cooldowns == 2 and getTalent(7,1) then
				if castSpell("target",MB,false,false) then return; end
			end

			--if getBuffRemain("player",InsanityBuff)<=0 then

				-- Trinket 1
				if options.isChecked.Trinket1 and options.buttons.Cooldowns == 2 and canTrinket(13) then
					RunMacroText("/use 13")
				end

				-- Trinket 2
				if options.isChecked.Trinket2 and options.buttons.Cooldowns == 2 and canTrinket(14) then
					RunMacroText("/use 14")
				end

				-- -- Halo
				-- if isKnown(Halo) and options.buttons.Halo == 2 then
				-- 	if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
				-- 		if castSpell("player",Halo,true,false) then return; end
				-- 	end
				-- end

				-- -- Mindbender
				-- if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
				-- 	if castSpell("target",Mindbender) then return; end
				-- end

				-- -- Shadowfiend
				-- if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
				-- 	if castSpell("target",SF,true,false) then return; end
				-- end

				-- -- Power Infusion
				-- if isKnown(PI) and options.buttons.Cooldowns == 2 and isChecked("Power Infusion") then
				-- 	if castSpell("player",PI) then return; end
				-- end

				-- Berserking (Troll Racial)
				--if not UnitBuffID("player",176875) then
				if isKnown(Berserking) and options.buttons.Cooldowns == 2 and options.isChecked.Berserking then
					if castSpell("player",Berserking,true,false) then return; end
				end
				--end
			--end
		end

		function ShadowCooldownsSmall(options)
			-- Halo
			if isKnown(Halo) and options.buttons.Halo == 2 then
				if getDistance("player","target")<=30 and getDistance("player","target")>=17 then
					if castSpell("player",Halo,true,false) then return; end
				end
			end

			-- Cascade
			if isKnown(Cascade) and options.buttons.Halo == 2 then
				if getDistance("player","target")>=28 and getDistance("player","target")<=40 then
					if castSpell("target",Cascade,true,false) then return; end
				end
			end

			if isBoss() and options.isChecked.isBoss
			or not options.isChecked.isBoss then
				-- Mindbender
				if isKnown(Mindbender) and options.buttons.Cooldowns == 2 and options.isChecked.Mindbender then
					if castSpell("target",Mindbender) then return; end
				end

				-- Shadowfiend
				if isKnown(SF) and options.buttons.Cooldowns == 2 and options.isChecked.Shadowfiend then
					if castSpell("target",SF,true,false) then return; end
				end
			end
		end
	--[[                    ]] -- Cooldowns end

	--[[                    ]] -- Execute CoP start
		function ExecuteCoP(options)
			if getHP("target")<=20 then
				-- ORBS>=3 -> DP
				if options.player.ORBS>=3 then
					if castSpell("target",DP,true,false) then return; end
				end

				-- MB
				if castSpell("target",MB,false,false) then return; end

				-- SWD
				if castSpell("target",SWD,true,false) then return; end

				-- SoD Proc
				if getBuffStacks("player",SoDProc)>=1 then
					if castSpell("target",MSp,false,false) then return; end
				end

				-- MF Filler
				if select(1,UnitChannelInfo("player")) == nil and options.player.ORBS<3 then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	--[[                    ]] -- Execute CoP end
	
	--[[                    ]] -- Execute AS start
		function ExecuteAS(options)
			if getHP("target")<=20 then
				-- DP on 3+ Orbs
				if options.player.ORBS>=3 then
					if castSpell("target",DP,true,false) then return; end
				end

				-- MB
				if castSpell("target",MB,false,true) then return; end

				-- SoD Proc
				if getBuffStacks("player",SoDProc)>=1 then
					if castSpell("target",MSp,false,false) then return; end
				end

				-- SWD
				if castSpell("target",SWD,true,false) then return; end

				-- Insanity if noChannel
				if getBuffRemain("player",InsanityBuff)>0 then
					-- Check for current channel and cast Insanity
					if select(1,UnitChannelInfo("player")) == nil then
						if castSpell("target",MF,false,true) then return; end
					end
				end

				-- SWP / VT
				if getTimeToDie("target")>25 then
					-- SWP
					if getDebuffRemain("target",SWP,"player")<options.values.SWPRefresh then
						if castSpell("target",SWP,true,false) then return; end
					end
					-- VT
					if getDebuffRemain("target",VT,"player")<=options.values.VTRefresh and GetTime()-lastVT > 2*options.player.GCD then
						if castSpell("target",VT,true,true) then 
							lastVT=GetTime()
							return
						end
					end
				end

				-- MF Filler
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	--[[                    ]] -- Execute AS end

	--[[                    ]] -- BossHelper start
		function BossHelper()
			-- Blackrock Foundry (T17)
			if GetRealZoneText()=="Blackrock Foundry" then
				-- Oregorger

				-- Hans & Franz
					if UnitName("boss1")=="Hans'gar" or UnitName("boss2")=="Hans'gar" or UnitName("boss1")=="Franzok" or UnitName("boss2")=="Franzok" then
						-- Auto Target Franz if in range, else target Hans
						if GetObjectExists("target")==false then 
							if LFU("Hans'gar") then return; end
						end
						if GetObjectExists("target")==false then 
							if LFU("Franzok") then return; end
						end
					end

				-- Beastlord Darmac
					if GetSubZoneText()=="Iron Assembly" then
						-- Pack Beast - Cascade
						if getTalent(6,1) then
							if getSpellCD(Cascade)<=0 then
								for i=1,#enemiesTable do
									local thisUnit = enemiesTable[i].unit
									if UnitName(thisUnit) == "Pack Beast" then
										if getDistance("player",thisUnit)<40 then
											if castSpell(thisUnit,Cascade,true,false) then return; end
										end
									end
								end
							end
						end
						-- target Beastlord Darmac
						if GetObjectExists("target")==false then 
							if LFU("Beastlord Darmac") then return; end
						end
						-- target Cruelfang
						if GetObjectExists("target")==false then 
							if LFU("Cruelfang") then return; end
						end
						-- target Dreadwing
						if GetObjectExists("target")==false then 
							if LFU("Dreadwing") then return; end
						end
						-- target Ironcrusher
						if GetObjectExists("target")==false then 
							if LFU("Ironcrusher") then return; end
						end
						-- target Faultine
						if GetObjectExists("target")==false then 
							if LFU("Faultine") then return; end
						end
					end
					
				-- Gruul
					if UnitName("boss1")=="Gruul" and GetObjectExists("target")==false then
						if LFU("Gruul") then return; end
					end

				-- Flamebender Ka'graz
					-- Cascade Dogs
					if UnitName("boss1")=="Flamebender Ka'graz" then
						if getTalent(6,1) then
							if getSpellCD(Cascade)<=0 then
								-- sort enemiesTable by distance
								sortByDistance()
								-- Cascade farest dog
								for i=1,#enemiesTable do
									local thisUnit = enemiesTable[i].unit
									if getDistance("player",thisUnit)<40 then
										--if UnitName(thisUnit) == "Cinder Wolf" then
											if castSpell(thisUnit,Cascade,true,false) then return; end
										--end
									end
								end
							end
						end
					end

				-- Operator Thogar
					if UnitName("boss1")=="Operator Thogar" then
						-- target Grom'kar Man-at-Arms
						if UnitName("target")~="Grom'kar Man-at-Arms" then
							if LFU("Grom'kar Man-at-Arms") then return; end
						end
						-- target Iron Gunnery Sergeant / SWD, DP, MB
						if UnitName("target")~="Iron Gunnery Sergeant" then
							if LFU("Grom'kar Man-at-Arms") then
								if getDistance("player","target")>=40 then
									RunMacroText("/targetlasttarget")
								end
							end
						end
						-- Halo/Cascade Reinforcements
						if (getSpellCD(Halo) and getTalent(6,3)) or (getSpellCD(Cascade) and getTalent(6,1)) then
							-- sort enemiesTable by distance
							sortByDistance()
							for i=1,#enemiesTable do
								local thisUnit = enemiesTable[i].unit
								if getDistance("player",thisUnit)<40 then
									if UnitName("Iron Raider") or UnitName("Iron Crack-Shot") then
										if getTalent(6,1) then
											if castSpell(thisUnit,Cascade,true,false) then return; end
										end
										if getTalent(6,3) then
											if castSpell(thisUnit,Halo,true,false) then return; end
										end
									end
								end
							end
						end
					end

				-- The Blast Furnace
					if GetSubZoneText()=="Slagworks" then
						if getTalent(6,1) then
							if getSpellCD(Cascade)<=0 then
								-- sort enemiesTable by distance
								sortByDistance()
								-- Cascade farest dog
								for i=1,#enemiesTable do
									local thisUnit = enemiesTable[i].unit
									if getDistance("player",thisUnit)<40 then
										--if UnitName(thisUnit) == "Cinder Wolf" then
											if castSpell(thisUnit,Cascade,true,false) then return; end
										--end
									end
								end
							end
						end
					end

				-- Kromog
					if UnitName("boss1")=="Kromog" then
						-- Cascade farest possible hand
						if getSpellCD(Cascade)<=0 then
							-- sort enemiesTable by distance
							sortByDistance()
							-- Cascade farest dog
							for i=1,#enemiesTable do
								local thisUnit = enemiesTable[i].unit
								if getDistance("player",thisUnit)<40 then
									if UnitName(thisUnit) == "Grasping Earth" then
										if castSpell(thisUnit,Cascade,true,false) then return; end
									end
								end
							end
						end
					end

				-- The Iron Maidens
					if UnitName("boss1")=="Marak the Blooded" or UnitName("boss1")=="Enforcer Sorka" or UnitName("boss1")=="Admiral Gar'an" then
						-- Automatic Target Dominator Turret
						if UnitName("target")~="Dominator Turret" then
							if LFU("Dominator Turret") then return; end
						end
					end

				-- Blackhand
			end
		end
	--[[                    ]] -- BossHelper end

	--[[                    ]] -- LF Orbs start
		function LFOrbs(options)
			if options.isChecked.ScanOrbs then
				if getSpellCD(SWD)<=0 then
					if options.player.ORBS<5 then
						for i=1,#enemiesTable do
							local thisUnit = enemiesTable[i].unit
							local hp = enemiesTable[i].hp
							if hp<20 then
								if castSpell(thisUnit,SWD,true,false,false,false,false,false,true) then return; end
							end
						end
					end
				end
			end
		end
	--[[                    ]] -- LF Orbs end

	--[[                    ]] -- LF ToF
		function LFToF(options)
			if options.isChecked.ScanToF then
				if getBuffRemain("player",ToF)<options.player.GCD then
					for i=1,#enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local hp = enemiesTable[i].hp
						if hp<35 then
							if getSpellCD(MB)>0 then
								if castSpell(thisUnit,SWP,true,false) then return; end
							end
						end
					end
				end
			end
		end
	--[[                    ]] -- LF Orbs end

	--[[                    ]] -- SWP
		-- refresh
		function refreshSWP(options,targetAlso)
			--if options.buttons.DoT==2 or options.buttons.DoT==4 then
				local SWPCount = getSWP()
				if SWPCount <= options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if not UnitIsUnit("target",thisUnit) or targetAlso then
								if UnitDebuffID(thisUnit,SWP,"player") then
									-- check remaining time and minhealth
									if getDebuffRemain(thisUnit,SWP,"player")<=options.values.SWPRefresh and thisHP>options.values.MinHealth then
										if castSpell(thisUnit,SWP,true,false) then return; end
									end
								end
							end
						end
					end
				end
			--end
		end
		
		-- apply
		function throwSWP(options,targetAlso)
			--if options.buttons.DoT==2 or options.buttons.DoT==4 then
				local SWPCount = getSWP()
				if SWPCount<options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if not UnitIsUnit("target",thisUnit) or targetAlso then
							-- check remaining time and minhealth
								if getDebuffRemain(thisUnit,SWP,"player")<=0 and thisHP>options.values.MinHealth then
									if castSpell(thisUnit,SWP,true,false) then return; end
								end
							end
						end
					end
				end
			--end
		end
	--[[                    ]] -- SWP

	--[[                    ]] -- VT
		function refreshVT(options,targetAlso)
			--if options.buttons.DoT==3 or options.buttons.DoT==4 then
				local VTCount = getVT()
				-- refresh VT
				if VTCount <= options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if safeVT(thisUnit) then
								if not UnitIsUnit("target",thisUnit) or targetAlso then
									if UnitDebuffID(thisUnit,VT,"player") then
										-- check remaining time and minhealth
										if getDebuffRemain(thisUnit,VT,"player")<=options.values.VTRefresh and thisHP>options.values.MinHealth then
											if castSpell(thisUnit,VT,true,true) then return; end
										end
									end
								end
							end
						end
					end
				end
			--end
		end
		
		function throwVT(options,targetAlso)
			--if options.buttons.DoT==3 or options.buttons.DoT==4 then
				local VTCount = getVT()
				if VTCount<options.values.MaxTargets then
					for i=1, #enemiesTable do
						local thisUnit = enemiesTable[i].unit
						local thisHP = enemiesTable[i].hpabs
						-- check for target and safeDoT
						if safeDoT(thisUnit) then
							if safeVT(thisUnit) then
								if not UnitIsUnit("target",thisUnit) or targetAlso then
									-- check remaining time and minhealth
									if getDebuffRemain(thisUnit,VT,"player")<=0 and thisHP>options.values.MinHealth then
										if castSpell(thisUnit,VT,true,true) then return; end
									end
								end
							end
						end
					end
				end
			--end
		end
	--[[                    ]] -- VT

	--[[                    ]] -- Searing Insanity
	function SearingInsanity(options)
		if options.isChecked.MSinsanity then
			if SpecificToggle("MSinsanity Key") then
				-- Chat Overlay
				ChatOverlay("Searing Insanity active")
				-- MB CoP Insanity
				if getTalent(7,1) and getTalent(3,3) and options.player.ORBS<3 then
					if castSpell("target",MB,false,false) then return; end
				end
				-- DP
				if options.player.ORBS>=3 then
					if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
						if getBuffRemain("player",InsanityBuff)<=0 then
							if castSpell("target",DP,true,false) then return; end
						end
					end
				end
				-- Clip it
				if getBuffRemain("player",InsanityBuff)>0 and getBuffRemain("player",InsanityBuff)<options.player.GCD then
					local cEnd = select(6,UnitChannelInfo("player"))
					local cRem = cEnd - GetTime()*1000
					-- Clip it
					if cRem<500 then
						if castSpell("target",MS,true,true) then return; end
					end
				end
				-- Searing Insanity
				if getBuffRemain("player",InsanityBuff)>0 then
					if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
						--if getBuffRemain("player",InsanityBuff)>0 then
							if castSpell("target",MS,true,true) then return; end
						--end
					end
				end
			end
		end
	end
	--[[                    ]] -- Searing Insanity

	--[[                    ]] -- Clip Insanity
	function ClipInsanity(options)
		if UnitChannelInfo("player") then
			if getBuffRemain("player",InsanityBuff)>0 and getBuffRemain("player",InsanityBuff)<options.player.GCD then
				local cEnd = select(6,UnitChannelInfo("player"))
				local cRem = cEnd - GetTime()*1000
				-- Clip it
				if cRem<500 then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	end
	--[[                    ]] -- Clip Insanity

	--[[                    ]] -- Throw DP start
		function ThrowDP()
			-- Throw DP on Highest HP unit
			if enemiesTable==nil then return "ERROR: Table == nil" end

			if #enemiesTable>=2 then
				for i=1, #enemiesTable do
					local thisUnit = enemiesTable[i].unit
					local thisHP = enemiesTable[i].hpabs
					local DPTime = 6.0/(1+UnitSpellHaste("player")/100)
					--if safeDoT(thisUnit) and not UnitIsUnit("target",thisUnit) then
					if safeDoT(thisUnit) then
						-- check remaining DP Time
						if getDebuffRemain(thisUnit,DP,"player")<=0.3*DPTime then
							if castSpell(thisUnit,DP,true,false) then return; end
						end
					end
				end
			end
		end
	--[[                    ]] -- Throw DP end

	--[[                    ]] -- CoP Insanity start
		function CoPInsanity(options)

			-- MB on CD
			if castSpell("target",MB,false,false) then return; end

			-----------------
			-- DoT Weaving --
			-----------------
			-- Option Check: DoT Weave
			if options.isChecked.DoTWeave then
				-- Unit Check: DoT Weave on Unit allowed?
				if noDoTWeave("target")==false then
					if options.player.ORBS>=4 and getSpellCD(MB)<=2*options.player.GCD then
						-- apply SWP
						if not UnitDebuffID("target",SWP,"player") then
							if castSpell("target",SWP,true,false) then return; end
						end
						-- apply VT
						if not UnitDebuffID("target",VT,"player") and GetTime()-lastVT > 2*options.player.GCD then
							if castSpell("target",VT,true,true) then
								--options.player.lastVT=GetTime()
								lastVT=GetTime()
								return
							end
						end
					end
				end
			end

			----------------
			-- spend orbs --
			----------------
			-- Check for 5 Orbs
			if options.player.ORBS==5 then
				-- Check for SWP, DoTweave option, noWeave Unit
				if getDebuffRemain("target",SWP,"player")>0 or options.isChecked.DoTWeave~=true or noDoTWeave("target") then
					-- Check for VT, DoTweave option, noWeave Unit
					if getDebuffRemain("target",VT,"player")>0 or options.isChecked.DoTWeave~=true or noDoTWeave("target") then
						-- DP on target
						if castSpell("target",DP,false,true) then
							lastDP=GetTime()
							return
						end
					end
				end
			end

			-- Check for >= 3 Orbs
			if UnitChannelInfo("player")~="Insanity" or getSpellCD(MB)<=1.5 then
				if options.player.ORBS>=3 then
					-- Check for last DP
					if GetTime()-lastDP<=options.player.DPTIME+2.2*options.player.GCD then
						-- Check that Insanity isnt on me
						--if getBuffRemain("player",InsanityBuff)<=0.3*options.player.DPTIME then
						if getBuffRemain("player",InsanityBuff)<=0 then
							-- DP on target
							if castSpell("target",DP,false,true) then return; end
						end
					end
				end
			end

			-- Insanity if noChannel
			if getBuffRemain("player",InsanityBuff)>=0.3*options.player.GCD then
				-- Check for current channel and cast Insanity
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end

			--------------
			-- get orbs --
			--------------
			-- only collect Orbs if no InsanityBuff
			if getBuffRemain("player",InsanityBuff)<=0 then
				-- only collect Orbs if not channeling insanity atm
				if not select(1,UnitChannelInfo("player")) ~= "Insanity" then
					-- Halo, Shadowfiend, Mindbender
					ShadowCooldownsSmall(options)
					--if options.isChecked.isBoss and isBoss() then ShadowCooldownsSmall(options) end
					--if not options.isChecked.isBoss then ShadowCooldownsSmall(options) end

					-- SWP
					if options.buttons.DoT==2 or options.buttons.DoT==4 then 
						throwSWP(options,false)
						refreshSWP(options,false)
					end

					-- VT
					if options.buttons.DoT==3 or options.buttons.DoT==4 then
						throwVT(options,false)
						refreshVT(options,false)
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
					if options.player.ORBS<5 and not (UnitChannelInfo("player")=="Insanity") then
						if #getEnemies("target",10)<options.values.MindSear and options.isChecked.MindSear
						or not options.isChecked.MindSear then
							if castSpell("target",MSp,false,true) then return; end
						end
					end
				end
			end
		end -- function end
	--[[                    ]] -- CoP Insanity end

	--[[                    ]] -- CoP SoD start
	function CoPSoD(options)
		----------------
		-- spend orbs --
		----------------
		-- Check for 3+ Orbs
		

	end -- function end
	--[[                    ]] -- CoP SoD end

	--[[                    ]] -- AS Insanity start
	function ASInsanity(options)

		-- DP: push or throw?
		if options.isChecked.DPmode then
			if options.player.ORBS==5 then
				-- Push DP
				if options.isChecked.DPmode==1 then
					if getDebuffRemain("target",DP,"player")<=options.values.PushTime then
						if castSpell("target",DP,true,false) then return; end
					end
				end
				-- Throw DP
				if options.isChecked.DPmode==2 then
					ThrowDP()
				end
			end
		end

		-- DP on 5 Orbs
		if options.player.ORBS==5 then
			if castSpell("target",DP,true,false) then return; end
		end

		-- Hold Back DP to improve 4 set uptime
		if TierScan("T17")>=4 then
			if options.player.ORBS>=options.values.DPon 
			or (getBuffRemain("player",MentalInstinct)<1.8*options.player.GCD and options.player.ORBS>=3) then
				if getBuffRemain("player",MentalInstinct)<1.8*options.player.GCD then
					if castSpell("target",DP,true,false) then return; end
				end
			end
		end

		-- DP on 3+ Orbs
		if TierScan("T17")<4 then
			if options.player.ORBS>=3 then
				-- check for running DP
				if getBuffRemain("player",InsanityBuff)<=0 then
					if castSpell("target",DP,true,false) then return; end
				end
			end
		end

		-- MB on CD
		if castSpell("target",MB,false,true) then return; end

		if select(1,UnitChannelInfo("player")) ~= "Insanity" then
			-- SWP on MaxTargets
			throwSWP(options,true)

			-- Insanity
			if getBuffRemain("player",InsanityBuff)>0 then
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end

			-- Halo, Shadowfiend, Mindbender
			ShadowCooldownsSmall(options)
			--if options.isChecked.isBoss and isBoss() then ShadowCooldownsSmall(options) end
			--if not options.isChecked.isBoss then ShadowCooldownsSmall(options) end

			-- SWP refresh
			refreshSWP(options,true)

		
			-- VT on target
			if options.isChecked.VTonTarget then
				if getDebuffRemain("target",VT,"player")<=options.values.VTRefresh and GetTime()-lastVT > 2*options.player.GCD then
					if castSpell("target",VT,true,true) then 
						lastVT=GetTime()
						return
					end
				end
			end

			-- VT on all
			if options.buttons.DoT==3 or options.buttons.DoT==4 then
				throwVT(options,true)
			end
			-- -- Mind Sear
			-- if options.isChecked.MindSear then
			-- 	if #getEnemies("target",10)>=options.values.MindSear then
			-- 		if select(1,UnitChannelInfo("player")) ~= "Mind Sear" then
			-- 			if select(1,UnitChannelInfo("player")) == nil or select(1,UnitChannelInfo("player")) == "Mind Flay" then
			-- 				if castSpell("target",MS,false,true) then return; end
			-- 			end
			-- 		end
			-- 	end
			-- end

			-- Insanity / MF
			if getSpellCD(MB)>0.5 then
				if select(1,UnitChannelInfo("player")) == nil then
					if castSpell("target",MF,false,true) then return; end
				end
			end
		end
	end
	--[[                    ]] -- AS Insanity end

	--[[                    ]] -- AS SoD start
	function ASSoD(options)

		-- DP: push or throw?
		if options.isChecked.DPmode then
			if options.player.ORBS==5 then
				-- Push DP
				if options.isChecked.DPmode==1 then
					if getDebuffRemain("target",DP,"player")<=options.values.PushTime then
						if castSpell("target",DP,true,false) then return; end
					end
				end
				-- Throw DP
				if options.isChecked.DPmode==2 then
					ThrowDP()
				end
			end
		end

		-- DP on 5 Orbs
		if options.player.ORBS==5 then
			if castSpell("target",DP,true,false) then return; end
		end

		-- Hold Back DP to improve 4 set uptime
		if TierScan("T17")>=4 then
			if options.player.ORBS>=options.values.DPon
			or (getBuffRemain("player",MentalInstinct)<1.8*options.player.GCD and options.player.ORBS>=3) then
				if getBuffRemain("player",MentalInstinct)<1.8*options.player.GCD then
					if castSpell("target",DP,true,false) then return; end
				end
			end
		end

		-- DP on 3+ Orbs
		if TierScan("T17")>=4 then
			-- check for options
			if options.player.ORBS>=options.values.DPon then
				-- DP
				if castSpell("target",DP,true,false) then return; end
			end
		end

		-- DP on 3+ Orbs
		if TierScan("T17")<4 then
			if options.player.ORBS>=3 then
				-- check for running DP
				if getBuffRemain("player",InsanityBuff)<=0 then
					if castSpell("target",DP,true,false) then return; end
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

		-- Halo, Shadowfiend, Mindbender
		ShadowCooldownsSmall(options)
		--if options.isChecked.isBoss and isBoss() then ShadowCooldownsSmall(options) end
		--if not options.isChecked.isBoss then ShadowCooldownsSmall(options) end

		-- SWP on MaxTargets
		throwSWP(options,true)

		-- VT on MaxTargets
		throwVT(options,true)

		-- SoD Proc
		if getBuffStacks("player",SoDProc)>=1 then
			if castSpell("target",MSp,false,false) then return; end
		end

		-- SWP refresh
		refreshSWP(options,true)

		-- VT refresh
		refreshVT(options,true)

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
	end
	--[[                    ]] -- AS SoD end



end -- Global end