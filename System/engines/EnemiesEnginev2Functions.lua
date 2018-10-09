local function AddUnit(thisUnit,thisTable)
	local unit = {
		unit = thisUnit,
		name = UnitName(thisUnit),
		guid = UnitGUID(thisUnit),
		id = GetObjectID(thisUnit),
	}
	rawset(thisTable, thisUnit, unit)
end

-- Update Pet
local function UpdatePet(thisUnit)
	if br.player.spell.buffs.demonicEmpowerment ~= nil then
		demoEmpBuff = UnitBuffID(thisUnit,br.player.spell.buffs.demonicEmpowerment) ~= nil
	else
		demoEmpBuff = false
	end
	local unitCount = #getEnemies(thisUnit,10) or 0
	local pet 		= br.player.pet.list[thisUnit]
	pet.deBuff = demoEmpBuff
	pet.numEnemies = unitCount
end

-- Check Critter
local function IsCritter(checkID)
	local numPets = C_PetJournal.GetNumPets(false)
	for i=1,numPets do
		local _, _, _, _, _, _, _, name, _, _, petID = C_PetJournal.GetPetInfoByIndex(i, false)
		if checkID == petID then return true end
	end
	return false
end

function updateOM()
	local startTime = debugprofilestop()
	local inCombat = UnitAffectingCombat("player")
	local omCounter = 0
	local fmod = math.fmod
	local loopSet = floor(GetFramerate()) or 0
	-- if isChecked("Disable Object Manager") and (inCombat or not isChecked("Auto Loot")) then
	-- 	if next(br.enemiesv2) ~= nil then br.enemiesv2 = {} end
	-- 	return
	-- end
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.objects.targets = 0
	end
	-- Cycle OM
	local objectCount = FireHack~=nil and GetObjectCount() or 0
	if objectCount > 0 then
		local playerObject = GetObjectWithGUID(UnitGUID("player"))
		if objectIndex == nil or objectIndex >= objectCount then objectIndex = 1 end
		for i = objectIndex, objectCount do
			objectIndex = objectIndex + 1
			omCounter = omCounter + 1
			if omCounter == 1 then cycleTime = debugprofilestop() end
			-- define our unit
			local thisUnit = GetObjectWithIndex(i)
				if GetUnitIsVisible(thisUnit) and getDistance(thisUnit) < 50
					and (UnitReaction(thisUnit,"player") < 5 or UnitCreator(thisUnit) == playerObject) and (not UnitIsDeadOrGhost(thisUnit) or CanLootUnit(UnitGUID(thisUnit)))
				then
					br.debug.cpu.enemiesEngine.objects.targets = br.debug.cpu.enemiesEngine.objects.targets + 1
					local enemyUnit = unitSetup:new(thisUnit)
					if enemyUnit then tinsert(br.enemiesv2, enemyUnit) end
				end
			if isChecked("Debug Timers") then
				br.debug.cpu.enemiesEngine.objects.cycleTime = debugprofilestop()-cycleTime
			end
			-- objectIndex = objectIndex + 1
			if fmod(objectIndex,loopSet) == 0 then objectIndex = objectIndex + 1; break end
		end
	end
	refreshStored = true
	-- Debugging
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.objects.currentTime = debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.totalIterations = br.debug.cpu.enemiesEngine.objects.totalIterations + 1
		br.debug.cpu.enemiesEngine.objects.elapsedTime = br.debug.cpu.enemiesEngine.objects.elapsedTime + debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.objects.averageTime = br.debug.cpu.enemiesEngine.objects.elapsedTime / br.debug.cpu.enemiesEngine.objects.totalIterations
	end
	br.enemiesv2:Update()
	getOMUnitsv2()
end

function getOMUnitsv2()
	local startTime = debugprofilestop()
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.units.targets = 0
	end
	-- Clean Up
	-- Units
	for k, v in pairs(br.units) do if not unitSetup.cache[br.units[k].unit] or unitSetup.cache[br.units[k].unit].enemyListCheck == false then br.units[k] = nil end end
	-- Pets
	if br.player ~= nil and br.player.pet ~= nil and br.player.pet.list ~= nil then
		for k,v in pairs(br.player.pet.list) do if not unitSetup.cache[br.player.pet.list[k].unit] or not GetObjectExists(br.player.pet.list[k].unit) then br.player.pet.list[k] = nil end end
	end
	-- Lootables
	for k, v in pairs(br.lootable) do
		local hasLoot,canLoot = CanLootUnit(br.lootable[k].guid)
		if not hasLoot or not GetObjectExists(br.lootable[k].unit) then br.lootable[k] = nil end
	end
	-- Enemies
	for k, v in pairs(br.enemy) do if not unitSetup.cache[br.enemy[k].unit] or unitSetup.cache[br.enemy[k].unit].enemyListCheck == false or unitSetup.cache[br.enemy[k].unit].isValidUnit == false then br.enemy[k] = nil end end
	-- Cycle the Object Manager
	local omCounter = 0;
	if br.enemiesv2 ~= nil then
		local playerObject = GetObjectWithGUID(UnitGUID("player"))
		for i=1, #br.enemiesv2 do
			thisUnit = br.enemiesv2[i].unit
			omCounter = omCounter + 1
			if isChecked("Debug Timers") and omCounter == 1 then cycleTime = debugprofilestop() end
			-- Units
			if br.units[thisUnit] == nil and br.enemiesv2[i].enemyListCheck == true then
				br.debug.cpu.enemiesEngine.units.targets = br.debug.cpu.enemiesEngine.units.targets + 1
				AddUnit(thisUnit,br.units)
				if isChecked("Debug Timers") then
					br.debug.cpu.enemiesEngine.units.addTime = debugprofilestop()-startTime or 0
				end
			end
			--Enemies
			if br.enemy[thisUnit] == nil and br.enemiesv2[i].isValidUnit == true and br.enemiesv2[i].enemyListCheck == true then
				AddUnit(thisUnit,br.enemy)
				if isChecked("Debug Timers") then
					br.debug.cpu.enemiesEngine.enemy.targets = br.debug.cpu.enemiesEngine.enemy.targets + 1
					br.debug.cpu.enemiesEngine.enemy.addTime = debugprofilestop()-startTime or 0
				end
			end
			-- Pet Info
			if br.player ~= nil then
				if br.player.pet == nil then br.player.pet = {} end
				if br.player.pet.list == nil then br.player.pet.list = {} end
				if br.player.pet.list[thisUnit] == nil and not isCritter(GetObjectID(thisUnit))
					and (UnitCreator(thisUnit) == playerObject or GetObjectID(thisUnit) == 11492)
				then
					AddUnit(thisUnit,br.player.pet.list)
					if UnitAffectingCombat("pet") or UnitAffectingCombat("player") then UpdatePet(thisUnit) end
				end
			end
			-- Lootable
			if br.lootable[thisUnit] == nil then
				local hasLoot,canLoot = CanLootUnit(UnitGUID(thisUnit))
				if hasLoot and canLoot then
					AddUnit(thisUnit,br.lootable)
				end
			end
			-- Debug Cycle Time
			if isChecked("Debug Timers") then
				br.debug.cpu.enemiesEngine.units.cycleTime = debugprofilestop()-cycleTime
			end
		end
	end
	-- Debugging
	if isChecked("Debug Timers") then
		br.debug.cpu.enemiesEngine.units.currentTime = debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.units.totalIterations = br.debug.cpu.enemiesEngine.units.totalIterations + 1
		br.debug.cpu.enemiesEngine.units.elapsedTime = br.debug.cpu.enemiesEngine.units.elapsedTime + debugprofilestop()-startTime
		br.debug.cpu.enemiesEngine.units.averageTime = br.debug.cpu.enemiesEngine.units.elapsedTime / br.debug.cpu.enemiesEngine.units.totalIterations
	end
end

function getTargetUnit()
	local targetGUID = ObjectGUID("target")
	if targetGUID then
		for i = 1, #br.enemiesv2 do
			if br.enemiesv2[i].guid == targetGUID then
				return br.enemiesv2[i]
			end
		end
	end
	for i = 1, #br.enemiesv2 do
		if br.enemiesv2[i].isValidUnit == true then
			return br.enemiesv2[i]
		end
	end
	return nil
end
