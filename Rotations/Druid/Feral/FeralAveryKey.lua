local rotationName = "AveryKey"

local function createToggles()
	-- Cooldown Button
	CooldownModes = {
	[1] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 1, icon = br.player.spell.berserk },
	[2] = { mode = "Off", value = 2 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.berserk }
	};
	CreateButton("Cooldown",1,0)
	-- Interrupt Button
	InterruptModes = {
	[1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.skullBash },
	[2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.skullBash }
	};
	CreateButton("Interrupt",2,0)     
end

local function createOptions()
	local optionTable
	local function rotationOptions()
		local section
		-- General Options
		section = br.ui:createSection(br.ui.window.profile, "General")
			-- Auto Targeting
			br.ui:createCheckbox(section,"Auto Targeting","Enable Auto Targeting")
			-- Auto Facing
			br.ui:createCheckbox(section,"Auto Facing","Enable Auto Facing")
			--Debug
			br.ui:createCheckbox(section,"Debug","Enable Debug")
			br.ui:checkSectionState(section)
		end
		optionTable = {{
		[1] = "Rotation Options",
		[2] = rotationOptions,
		}}
		return optionTable
	end

local function runRotation()
	--toggles
	UpdateToggle("Cooldown",0.25)
	UpdateToggle("Interrupt",0.25)

	--locals
	local inCombat 					= br.player.inCombat
	local combo 					= br.player.power.amount.comboPoints
	local bleed 					= br.player.bleed
	local incarnationBuff 			= UnitBuffID("player", 102543) 
	local power, powmax, powgen 	= br.player.power.amount.energy, br.player.power.energy.max, br.player.power.regen
	local mfTick 					= 20.0/(1+UnitSpellHaste("player")/100)/10
	local talent 					= br.player.talent
	local buff 						= br.player.buff
	local ttm 						= br.player.power.ttm
	local cd 						= br.player.cd
	local clearcast 				= br.player.buff.clearcast
	local gcd 						= br.player.gcd

	--Savage Roar Prowl
	if UnitExists("target") and UnitBuffID("player", 5215) ~= nil then
		if getDistance("player","target") < 5 then
			--Rake
			CastSpellByName(GetSpellInfo(1822),"target")
		end
	end
	if not inCombat then	
		--Prowl
		if UnitBuffID("player", 768) ~= nil and UnitBuffID("player", 5215) == nil then
			CastSpellByName(GetSpellInfo(5215))
		end
		elseif inCombat then	
		--Cat Form
		if UnitBuffID("player", 768) == nil then
			CastSpellByName(GetSpellInfo(768))
		end
		
		--auto_attack
		if UnitExists("target") and getDistance("target") < 5 then
			StartAttack()
		end
		
		--auto_target
		if isChecked("Auto Targeting") then
			if not UnitExists("target") or (UnitExists("target") and getDistance("player","target") > 8) then
				for i = 1, #getEnemies("player",5) do
					local thisUnit = getEnemies("player",5)[i]
					local distance = getDistance("player",thisUnit)
					if distance < 5 then
						StartAttack(thisUnit)									
					end
				end	
			end
		end
		
		--auto_face
		if isChecked("Auto Facing") then
			if UnitExists("target") and not getFacing("player","target") then
				FaceDirection(GetAnglesBetweenObjects("Player", "Target"), true)
			end
		end
		
		--Skull Bash
		if br.data.settings[br.selectedSpec].toggles["Interrupt"] == 1 then
			for i = 1, #getEnemies("player",13) do
				local thisUnit = getEnemies("player",13)[i]
				local distance = getDistance("player",thisUnit)						
				if distance < 13 and canInterrupt(thisUnit,100) then
					if isChecked("Debug") then Print("Skull Bash") end
					CastSpellByName(GetSpellInfo(106839),thisUnit)
				end
			end
		end
		
		local targetDistance = getDistance("player","target")
		--Berserk
		if br.data.settings[br.selectedSpec].toggles["Cooldown"] == 1 then			
			if buff.tigersFury and (buff.incarnationKingOfTheJungle or not talent.incarnationKingOfTheJungle) and targetDistance < 5 then
				if isChecked("Debug") then Print("Berserk") end
				CastSpellByName(GetSpellInfo(106951))
			end
		end
		
		--Tigers Fury
		if ((not clearcast and br.player.powerDeficit >= 60) or br.player.powerDeficit >= 80) and targetDistance < 5 then
			if isChecked("Debug") then Print("Tigers Fury") end
			CastSpellByName(GetSpellInfo(5217))
		end
		
		--Incarnation - King of the Jungle
		if br.data.settings[br.selectedSpec].toggles["Cooldown"] == 1 then
			if buff.remain.berserk < 10 and ttm > 1 and targetDistance < 5 then
				if isChecked("Debug") then Print("Incarnation - King of the Jungle") end
				CastSpellByName(GetSpellInfo(102543))
			end
		end
		
		--Trinkets
		if br.data.settings[br.selectedSpec].toggles["Cooldown"] == 1 then
			if canUse(13) and canTrinket(13) and targetDistance < 5 then
				if isChecked("Debug") then Print("/use 13") end
				RunMacroText("/use 13")
			end
			if canUse(14) and canTrinket(14) and targetDistance < 5 then
				if isChecked("Debug") then Print("/use 14") end
				RunMacroText("/use 14")
			end
		end

		--Ferocious Bite Rip Execute Refresh
		for i=1, #bleed.rip do
			local rip = bleed.rip[i]
			local thisUnit = rip.unit
			if rip.remain > 0 and rip.remain < 3 and getHP(thisUnit) < 25 then
				if isChecked("Debug") then Print("Ferocious Bite Rip Execute Refresh") end
				CastSpellByName(GetSpellInfo(1079),thisUnit)
			end
		end

		--Healing Touch Bloodtalons
		if talent.bloodtalons and buff.predatorySwiftness and (combo >= 4 or buff.remain.predatorySwiftness < 1.5) then
			if isChecked("Debug") then Print("Healing Touch Bloodtalons") end
			CastSpellByName(GetSpellInfo(5185),"player")
		end
		
		--Savage Roar If Down
		if not buff.savageRoar then
			if combo >= 1 then
				if isChecked("Debug") then Print("Savage Roar If Down") end
				CastSpellByName(GetSpellInfo(52610))
			end
		end

		--Thrash < 4.5 & Enemies >= 4
		for i=1, #bleed.thrash do
			local thrash = bleed.thrash[i]
			local thisUnit = thrash.unit
			local distance = getDistance("player",thisUnit)	
			if thrash.remain < 4.5 and distance < 8 and #getEnemies("player", 8) >= 4 then
				if isChecked("Debug") then Print("Thrash < 4.5 & Enemies >= 4") end
				CastSpellByName("Thrash")--GetSpellInfo(106830))	
			end
		end


		--Finishers
		if combo == 5 then					
			--Rip < 2 
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				local distance = getDistance("player",thisUnit)	
				if rip.remain < 2 and ttd(thisUnit) - rip.remain > 18 and (getHP(thisUnit) > 25 or rip.remain < 2) 
					and distance < 5 then
					if isChecked("Debug") then Print("Rip < 2") end
					CastSpellByName(GetSpellInfo(1079),thisUnit)
				end
			end
			--Ferocious Bite < 25
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				local distance = getDistance("player",thisUnit)	
				if power > 50 and getHP(thisUnit) <= 25 and rip.remain > 0 
					and distance < 5 then
					if isChecked("Debug") then Print("Ferocious Bite < 25") end
					CastSpellByName(GetSpellInfo(22568),thisUnit)
				end
			end
			--Rip < 7.2 & Current Rip Mult. > Rip Applied Mult.
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				local distance = getDistance("player",thisUnit)	
				if rip.remain < 7.2 and rip.calc > rip.applied and ttd(thisUnit) - rip.remain > 18 
					and distance < 5 then
					if isChecked("Debug") then Print("Rip < 7.2 & Current Rip Mult. > Rip Applied Mult.") end
					CastSpellByName(GetSpellInfo(1079),thisUnit)
				end
			end
			--Rip < 7.2 & Current Rip Mult. = Rip Applied Mult.
			for i=1, #bleed.rip do
				local rip = bleed.rip[i]
				local thisUnit = rip.unit
				local distance = getDistance("player",thisUnit)	
				if rip.remain < 7.2 and rip.calc == rip.applied 
					and (ttm<=1 or (not talent.bloodtalons)) 
					and ttd(thisUnit) - rip.remain > 18 
					and distance < 5 then
					if isChecked("Debug") then Print("Rip < 7.2 & Current Rip Mult. = Rip Applied Mult.") end
					CastSpellByName(GetSpellInfo(1079),thisUnit)
				end
			end
			--Savage Roar < 12.6
			if (ttm<=1 or buff.berserk or cd.tigersFury < 3) and buff.remain.savageRoar < 12.6 
				and getDistance("target") < 5 then
				if isChecked("Debug") then Print("Savage Roar < 12.6") end
				CastSpellByName(GetSpellInfo(52610))
			end
			--Ferocious Bite
			for i = 1, #getEnemies("player",5) do
				local thisUnit = getEnemies("player",5)[i]
				local distance = getDistance("player",thisUnit)	
				if (ttm <= 1 or buff.berserk or cd.tigersFury < 3) 
					and distance < 5 then
					if isChecked("Debug") then Print("Ferocious Bite") end
					CastSpellByName(GetSpellInfo(22568),thisUnit)
				end
			end
		end -- end finisher


		--Savage Roar < GCD
		if br.player.buff.remain.savageRoar < gcd then
			if combo >= 1 then
				if isChecked("Debug") then Print("Savage Roar < GCD") end
				CastSpellByName(GetSpellInfo(52610))
			end
		end


		--Maintain
		if combo < 5 then	
			--Rake < 3
			for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				local distance = getDistance("player",thisUnit)	
				if rake.remain < 3 
					and ((ttd(thisUnit) - rake.remain > 3 and #getEnemies("player", 8) < 3) or ttd(thisUnit) - rake.remain > 6) 
					and distance < 5 then
					if isChecked("Debug") then Print("Rake < 3") end
					CastSpellByName(GetSpellInfo(1822),thisUnit)
				end
			end
			--Rake < 4.5
			for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				local distance = getDistance("player",thisUnit)	
				if rake.remain < 4.5 
					and (rake.calc >= rake.applied or (talent.bloodtalons and (buff.bloodtalons or not buff.predatorySwiftness))) 
					and ((ttd(thisUnit) - rake.remain > 3 and #getEnemies("player", 8) < 3) or ttd(thisUnit) - rake.remain > 6) 
					and distance < 5 then
					if isChecked("Debug") then Print("Rake < 4.5") end
					CastSpellByName(GetSpellInfo(1822),thisUnit)
				end
			end 
			--Moonfire < 4.2
			if br.player.talent.lunarInspiration and power > 30 then
				for i=1, #bleed.moonfire do
					local moonfire = bleed.moonfire[i]
					local thisUnit = moonfire.unit
					local distance = getDistance("player",thisUnit)		
					if moonfire.remain < 4.2 and #getEnemies("player", 8) <= 5 and (ttd(thisUnit) - moonfire.remain) > (mfTick * 5)
						and distance < 40 then
						if isChecked("Debug") then Print("Moonfire < 4.2") end
						CastSpellByName(GetSpellInfo(8921),thisUnit)
					end
				end
			end      
			--Current Rake Mult. > Rake Applied Mult.
			for i=1, #bleed.rake do
				local rake = bleed.rake[i]
				local thisUnit = rake.unit
				local distance = getDistance("player",thisUnit)	
				if rake.calc > rake.applied and #getEnemies("player", 8) == 1 
					and ((ttd(thisUnit) - rake.remain > 3 and #getEnemies("player", 8) < 3) or ttd(thisUnit) - rake.remain > 6) 
					and distance < 5 then
					if isChecked("Debug") then Print("Current Rake Mult. > Rake Applied Mult.") end
					CastSpellByName(GetSpellInfo(1822),thisUnit)
				end
			end	
		end -- end maintain


		--Thrash < 4.5 & Enemies >= 2
		for i=1, #bleed.thrash do
			local thrash = bleed.thrash[i]
			local thisUnit = thrash.unit
			local distance = getDistance("player",thisUnit)	
			if thrash.remain < 4.5 and distance < 8 and #getEnemies("player", 8) >= 2 then
				if isChecked("Debug") then Print("Thrash < 4.5 & Enemies >= 2") end
				CastSpellByName("Thrash")--GetSpellInfo(106830))	
			end
		end
		
		
		--Generators
		if combo < 5 then				
			--Shred
			if #getEnemies("player", 8) <= 3 or (#getEnemies("player", 8) == 3 and incarnationBuff ~= nil) then		
				for i = 1, #getEnemies("player",5) do
					local thisUnit = getEnemies("player",5)[i]
					local distance = getDistance("player",thisUnit)
					if distance < 5 then
						if isChecked("Debug") then Print("Shred") end
						CastSpellByName(GetSpellInfo(5221),thisUnit)	
					end
				end
			end 			
			--Swipe			
			if #getEnemies("player", 8) >= 4 or (#getEnemies("player", 8) >= 3 and incarnationBuff == nil) then	
				for i = 1, #getEnemies("player",8) do
					local thisUnit = getEnemies("player",8)[i]
					local counter = 0
					if getFacing("player",thisUnit) == true then
						counter = counter + 1							
					end
					if counter >= 3 then
						if isChecked("Debug") then Print("Swipe") end
						CastSpellByName(GetSpellInfo(106785))	
						counter = 0
					end
				end
			end
		end -- end generator


	end --End In Combat
	
end -- End runRotation

local id = 103
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})