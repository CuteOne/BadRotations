if select(3, UnitClass("player")) == 5 and GetSpecialization()==3 then

	function OnOff()
		mainButton:Click()
	end

	--[[ reset Queue]]
	function resetQ()
		_Queues = nil
	end

	--[[ raidbuff ]]
	function Raidbuff_Priest()
		if not PWF_last_check or PWF_last_check + 5 < GetTime() then
			PWF_last_check = GetTime()
			PWF_unbuffedPlayers = {}
			--local unbuffedPlayers = PWF_unbuffedPlayers

			local StaminaTable = {"Power Word: Fortitude","Blood Pact","Commanding Shout"}
			if GetNumGroupMembers()==0 then
				if not UnitIsDeadOrGhost("player") then
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

	--[[ Looking for Unit ]]
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

	--[[ Looking for Unit ]]
	function LFU(datName)
		-- nil prevention
		if datName==nil then 
			return false
		end
		-- first in Table
		if datName=="first" then
			if enemiesTable[1] ~= nil then
				if enemiesTable[1].distance<40 then
					TargetUnit(enemiesTable[1].unit)
				end
			end
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

	--[[ Sort enemiesTable by distance ]]
	function sortByDistance()
		if enemiesTable then
			table.sort(enemiesTable, function(x,y)
				return x.distance and y.distance and x.distance > y.distance or false
			end)
		end
	end

	--[[ Searing Insanity ]]
	function SearingInsanity(options,withMB)
		-- Chat Overlay
		ChatOverlay("Searing Insanity active")
		-- MB 
		if withMB then
			if options.player.ORBS<3 then
				if castSpell("target",MB,false,false) then return; end
			end
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
		if getBuffRemain("player",InsanityBuff)>0 and getBuffRemain("player",InsanityBuff)<2*options.player.GCD then
			if select(1,UnitChannelInfo("player")) ~= nil then
				local cEnd = select(6,UnitChannelInfo("player"))
				local cRem = cEnd - GetTime()*1000
				-- Clip it
				if cRem<666 then
					if castSpell("target",MS,true,true) then return; end
				end
			end
		end
		-- Searing Insanity
		if getBuffRemain("player",InsanityBuff)>0 then
			if select(1,UnitChannelInfo("player")) ~= "Searing Insanity" then
				if castSpell("target",MS,true,true) then return; end
			end
		end
	end

	--[[ Clip Insanity ]]
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

	--[[ Kick Spell ]]
	function ShadowSimpleKick(datUnit,spellname)
		local thisUnit

		if datUnit==nil and UnitExists("target") then thisUnit = "target"
			elseif datUnit then	thisUnit = datUnit
			else return
		end

		if UnitChannelInfo(thisUnit) == spellname or UnitCastingInfo(thisUnit) == spellname then
			local notInterruptible
			-- cast remain
			if UnitChannelInfo(thisUnit) then 
				cRem = select(6,UnitChannelInfo(thisUnit)) - GetTime()*1000 
				interruptible = not select(9,UnitChannelInfo(thisUnit))
			end
			if UnitCastingInfo(thisUnit) then 
				cRem = select(6,UnitCastingInfo(thisUnit)) - GetTime()*1000 
				interruptible = not select(9,UnitCastingInfo(thisUnit))
			end
			-- random number
			local rndRemaining = math.random(200,500)
			-- kick
			if cRem <= rndRemaining and interruptible then
				-- try to kick in melee range
				if isKnown(ArcT) then
					if getSpellCD(ArcT) <= 0 and getDistance("player",thisUnit) < 8 then
						if castSpell(thisUnit,ArcT,true,false) then return end
					end
				end
				-- if unit is casting after melee try kick it with silence
				if UnitChannelInfo(thisUnit) or UnitCastingInfo(thisUnit) then
					if getSpellCD(Silence) <= 0 then
						if castSpell(thisUnit,Silence,true,false) then return end
					end
				end
			end
		end
	end


end -- Global end