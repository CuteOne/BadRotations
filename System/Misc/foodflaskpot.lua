local _, br = ...
br.misc.foodflaskpot = br.misc.foodflaskpot or {}
local foodflaskpot = br.misc.foodflaskpot

local agilityPotion = br.player.potion.wod.agilityBasic
local intellectPotion = br.player.potion.wod.intellectBasic
local strengthPotion = br.player.potion.wod.strengthBasic
local armorPotion = br.player.potion.wod.armorBasic
local agilityPotionBuff = br.player.potion.wod.buff.agility
local intellectPotionBuff = br.player.potion.wod.buff.intellect
local strengthPotionBuff = br.player.potion.wod.buff.strength
local armorPotionBuff = br.player.potion.wod.buff.armor

local agilityFlask = br.player.flask.wod.agilityBig
local intellectFlask = br.player.flask.wod.intellectBig
local strengthFlask = br.player.flask.wod.strengthBig
local staminaFlask = br.player.flask.wod.staminaBig
local agilityFlaskBuff = br.player.flask.wod.buff.agilityBig
local intellectFlaskBuff = br.player.flask.wod.buff.intellectBig
local strengthFlaskBuff = br.player.flask.wod.buff.strengthBig
local staminaFlaskBuff = br.player.flask.wod.buff.staminaBig

local agilityFood = 0
local intellectFood = 0
local strengthFood = 0
local staminaFood = 0
local agilityFoodBuff = 0
local intellectFoodBuff = 0
local strengthFoodBuff = 0
local staminaFoodBuff = 0

--playerHasBuff(x) @param spellID # returns true if player has buff x
function foodflaskpot:playerHasBuff(spellID)
	local buffs, i = {}, 1
	local buff = br.functions.aura:UnitBuff("player", i)
	while buff do
		buffs[#buffs + 1] = buff
		i = i + 1
		buff = select(10, br.functions.aura:UnitBuff("player", i))
		if buff ~= nil then
			if buff == spellID then return true end
		end
	end
	return false
end

--getClass # returns class as string
function foodflaskpot:getClass()
	local myClass = "nil"
	local class = select(3, br._G.UnitClass("player"))
	if class == 1 then   -- Warrior
		myClass = "Warrior"
	elseif class == 2 then -- Paladin
		myClass = "Paladin"
	elseif class == 3 then -- Hunter
		myClass = "Hunter"
	elseif class == 4 then -- Rogue
		myClass = "Rogue"
	elseif class == 5 then -- Priest
		myClass = "Priest"
	elseif class == 6 then -- DeathKnight
		myClass = "DeathKnight"
	elseif class == 7 then -- Shaman
		myClass = "Shaman"
	elseif class == 8 then -- Mage
		myClass = "Mage"
	elseif class == 9 then -- Warlock
		myClass = "Warlock"
	elseif class == 10 then -- Monk
		myClass = "Monk"
	elseif class == 11 then -- Druid
		myClass = "Druid"
	end
	return myClass
end

--getClassType # returns class type as string
function foodflaskpot:getClassType()
	local classType = "nil"
	local myClass = br.misc.foodflaskpot:getClass()
	local mySpec = br._G.C_SpecializationInfo.GetSpecialization()
	--Agility
	if myClass == "Hunter"
		or myClass == "Rogue"
		or (myClass == "Shaman" and mySpec == 2)
		or (myClass == "Monk" and mySpec == 3)
		or (myClass == "Druid" and mySpec == 2) then
		classType = "agilityClass"
		--Intellect
	elseif (myClass == "Paladin" and mySpec == 1)
		or myClass == "Priest"
		or (myClass == "Shaman" and (mySpec == 1 or mySpec == 3))
		or myClass == "Mage"
		or myClass == "Warlock"
		or (myClass == "Monk" and mySpec == 2)
		or (myClass == "Druid" and (mySpec == 1 or mySpec == 4)) then
		classType = "intellectClass"
		--Strength
	elseif (myClass == "Warrior" and (mySpec == 1 or mySpec == 2))
		or (myClass == "Paladin" and mySpec == 3)
		or (myClass == "DeathKnight" and (mySpec == 2 or mySpec == 3)) then
		classType = "strengthClass"
		--Stamina
	elseif (myClass == "Warrior" and mySpec == 3)
		or (myClass == "Paladin" and mySpec == 2)
		or (myClass == "DeathKnight" and mySpec == 1)
		or (myClass == "Monk" and mySpec == 1)
		or (myClass == "Druid" and mySpec == 3) then
		classType = "staminaClass"
	end
	return classType
end

--playerHasItem(x) @param itemID # returns true if player has item x
function foodflaskpot:playerHasItem(itemID)
	if itemID == nil then return false end
	local itemFound = false
	for i = 0, 4 do                                 --Let's look at each bag
		local numBagSlots = C_Container.GetContainerNumSlots(i)
		if numBagSlots > 0 then                     --Only look for slots if bag present
			for x = 1, numBagSlots do               --Let's look at each bag slot
				local bagItemID = C_Container.GetContainerItemID(i, x)
				if tostring(bagItemID) == tostring(itemID) then --Compare bagItemID to parameter
					itemFound = true
				end
			end
		end
	end
	return itemFound
end

--playerCanUseItem(x) @param itemID # returns true if player can use item x
function foodflaskpot:playerCanUseItem(itemID)
	if itemID == nil then return false end
	if br.misc.foodflaskpot:playerHasItem(itemID) then
		if br._G.C_Container.GetItemCooldown(itemID) == 0 then
			return true
		end
	end
	return false
end

--usePotion(x) @param skipSurvivability # if x is true skips armor potion
function foodflaskpot:usePotion(skipSurvivability)
	if skipSurvivability == nil then skipSurvivability = false end
	local classType = br.misc.foodflaskpot:getClassType()
	--Agility
	if classType == "agilityClass" then
		if br.misc.foodflaskpot:playerCanUseItem(agilityPotion) then
			if br.misc.foodflaskpot:playerHasBuff(agilityPotionBuff) == false then
				br.functions.item:useItem(agilityPotion)
				return true
			end
		end
		--Intellect
	elseif classType == "intellectClass" then
		if br.misc.foodflaskpot:playerCanUseItem(intellectPotion) then
			if br.misc.foodflaskpot:playerHasBuff(intellectPotionBuff) == false then
				br.functions.item:useItem(intellectPotion)
				return true
			end
		end
		--Strength
	elseif classType == "strengthClass" or (classType == "staminaClass" and skipSurvivability == true) then
		if br.misc.foodflaskpot:playerCanUseItem(strengthPotion) then
			if br.misc.foodflaskpot:playerHasBuff(strengthPotionBuff) == false then
				br.functions.item:useItem(strengthPotion)
				return true
			end
		end
		--Armor
	elseif classType == "staminaClass" and skipSurvivability == false then
		if br.misc.foodflaskpot:playerCanUseItem(armorPotion) then
			if br.misc.foodflaskpot:playerHasBuff(armorPotionBuff) == false then
				br.functions.item:useItem(armorPotion)
				return true
			end
		end
	end
	return false
end

--useFlask(x) @param skipSurvivability # if x is true skips stamina flask
function foodflaskpot:useFlask(skipSurvivability)
	if skipSurvivability == nil then skipSurvivability = false end
	local classType = br.misc.foodflaskpot:getClassType()
	--Agility
	if classType == "agilityClass" then
		if br.misc.foodflaskpot:playerCanUseItem(agilityFlask) then
			if br.misc.foodflaskpot:playerHasBuff(agilityFlaskBuff) == false then
				br.functions.item:useItem(agilityFlask)
				return true
			end
		end
		--Intellect
	elseif classType == "intellectClass" then
		if br.misc.foodflaskpot:playerCanUseItem(intellectFlask) then
			if br.misc.foodflaskpot:playerHasBuff(intellectFlaskBuff) == false then
				br.functions.item:useItem(intellectFlask)
				return true
			end
		end
		--Strength
	elseif classType == "strengthClass" or (classType == "staminaClass" and skipSurvivability == true) then
		if br.misc.foodflaskpot:playerCanUseItem(strengthFlask) then
			if br.misc.foodflaskpot:playerHasBuff(strengthFlaskBuff) == false then
				br.functions.item:useItem(strengthFlask)
				return true
			end
		end
		--Stamina
	elseif classType == "staminaClass" and skipSurvivability == false then
		if br.misc.foodflaskpot:playerCanUseItem(staminaFlask) then
			if br.misc.foodflaskpot:playerHasBuff(staminaFlaskBuff) == false then
				br.functions.item:useItem(staminaFlask)
				return true
			end
		end
	end
	return false
end

--useFood(x) @param skipSurvivability # if x is true skips stamina food
function foodflaskpot:useFood(skipSurvivability)
	if skipSurvivability == nil then skipSurvivability = false end
	local classType = br.misc.foodflaskpot:getClassType()
	--Agility
	if classType == "agilityClass" then
		if br.misc.foodflaskpot:playerCanUseItem(agilityFood) then
			if br.misc.foodflaskpot:playerHasBuff(agilityFoodBuff) == false then
				br.functions.item:useItem(agilityFood)
				return true
			end
		end
		--Intellect
	elseif classType == "intellectClass" then
		if br.misc.foodflaskpot:playerCanUseItem(intellectFood) then
			if br.misc.foodflaskpot:playerHasBuff(intellectFoodBuff) == false then
				br.functions.item:useItem(intellectFood)
				return true
			end
		end
		--Strength
	elseif classType == "strengthClass" or (classType == "staminaClass" and skipSurvivability == true) then
		if br.misc.foodflaskpot:playerCanUseItem(strengthFood) then
			if br.misc.foodflaskpot:playerHasBuff(strengthFoodBuff) == false then
				br.functions.item:useItem(strengthFood)
				return true
			end
		end
		--Stamina
	elseif classType == "staminaClass" and skipSurvivability == false then
		if br.misc.foodflaskpot:playerCanUseItem(staminaFood) then
			if br.misc.foodflaskpot:playerHasBuff(staminaFoodBuff) == false then
				br.functions.item:useItem(staminaFood)
				return true
			end
		end
	end
	return false
end
