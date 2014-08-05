--[[ Built-In Macros ]]
--/power ------ Start/Stop Badboy Entirely
--/aoe -------- Toggles AoE Modes
--/cooldowns -- Toggles Cooldowns
--/pause ------ Stop attacking

--[[ function UnitBuffID(Unit, SpellID, Filter) ]]
---- Returns 1 if Buff found on target

--[[ function UnitDebuffID(Unit, SpellID, Filter) ]]
---- Returns 1 if Debuff found on target

--[[           ]]		  --[[]]		--[[]]     --[[]] 
--[[           ]]		 --[[  ]]		--[[  ]]   --[[]]
--[[]]				    --[[    ]] 		--[[    ]] --[[]]
--[[]]				   --[[      ]] 	--[[           ]]
--[[]]				  --[[        ]]	--[[           ]]
--[[           ]]	 --[[]]    --[[]]	--[[]]   --[[  ]]
--[[           ]]	--[[]]      --[[]]	--[[]]     --[[]]


--[[ function canAttack(Unit1,Unit2) ]]
---- Returns true if Unit1 can attack Unit2

--[[ function canDispel(Unit,spellID) ]]
---- Retrun true if the Unit have a valid Dispel

--[[ function canHeal(Unit) ]]
---- Returns true if we can heal that Unit

--[[ function canInterrupt(spellID,percentint) ]]
---- Returns true if we can Interrupt that target

--[[ function canPrepare() ]]
---- Returns true if ready to buff(ooc)

--[[ function canRun() ]]
---- Returns true if we can Run profile(incombat)

--[[ function canUse(itemID) ]]
---- returns true if the item can be used

--[[ function castGround(Unit,SpellID,maxDistance) ]]
---- Used to cast Spells on ground. Returns true if everything passes.

--[[ function castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip) ]]	
---- Used to cast Spells. Returns true if everything passes.


--[[           ]]   --[[           ]]    --[[           ]]
--[[           ]]   --[[           ]]    --[[           ]]
--[[]]              --[[]]        		       --[[ ]]
--[[]]   --[[  ]]	--[[           ]]          --[[ ]]
--[[]]     --[[]]	--[[]]        		       --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]
--[[           ]]   --[[           ]]          --[[ ]]

--[[ function getBuffRemain(Unit,BuffID) ]] 
---- Returns how long remain on this Unit's buff.

--[[ function getBuffStacks(Unit,BuffID) ]]
---- Returns number of stacks of this Unit's buff.

--[[ function getCombatTime()]]
---- Returns time since combat started.

--[[ function getCreatureType(Unit) ]]
---- Returns true if Unit is not a pet battle or a totem.

--[[ function getCombo() ]]			
---- Returns combo points on current target.

--[[ function getDebuffRemain(Unit,DebuffID) ]] 
---- Returns how long remain on this Unit's Debuff.

--[[ function getDebuffStacks(Unit,DebuffID)  ]]
---- Returns number of stacks of this Unit's Debuff.

--[[ function getDistance(Unit1,Unit2) ]]
---- Returns distance to target in yards.

--[[ function getFallTime() ]]	
---- Returns the time the character has been falling.

--[[ function getFacing(Unit1,Unit2) ]]	
---- Returns true if Unit1 is facing Unit2

--[[ function getHP(Unit) ]]	
---- Returns Unit HP %

--[[ function getMana(Unit) ]]	
---- Returns Unit Mana %

--[[ function getPower(Unit) ]]
---- Returns Unit Power %

--[[ function getTotemDistance(Unit1) ]]
---- Returns distance from totem to target

--[[ function getEnnemies(Target,Radius) ]]
---- Returns a table of the ennemies found within Radius of the target

--[[ function getNumEnnemies(Target,Radius) ]]
---- Returns number of ennemies found within Radius of the target

--[[ function getLineOfSight(Unit1,Unit2) ]]
---- Returns true if the Unit1 can see Unit2

--[[ function getGround(Unit) ]]
---- Returns true if ground is found under the target

--[[ function getPetLineOfSight(Unit) ]]
---- Returns true if our pet is in sight of target

--[[ function getSpellCD(SpellID) ]]
---- Returns how long remain until the CD is ready

--[[ function round2(num, idp) ]]
---- Used to round numbers

--[[ function getTimeToDie(unit) ]]
---- Returns approximative Time To Die for Unit

--[[ function getTimeToMax(Unit) ]]
---- Returns how long it will take until our ressources are maxed

--[[ function getRegen(Unit) ]]
---- Returns power regen rate of Unit

--[[]]	   --[[]]		  --[[]]		--[[           ]]
--[[]]	   --[[]]		 --[[  ]]		--[[           ]]
--[[           ]]	    --[[    ]]		--[[ ]]
--[[           ]]	   --[[      ]] 	--[[           ]]
--[[           ]]	  --[[        ]]			  --[[ ]]
--[[]]	   --[[]]	 --[[]]    --[[]]	--[[           ]]
--[[]]	   --[[]]	--[[]]      --[[]]	--[[           ]]

--[[ function hasGlyph(glyphid) ]]
---- Returns true if we have this Glyph

--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]
	 --[[ ]]		--[[ ]]
	 --[[ ]]		--[[           ]]	
	 --[[ ]]				  --[[ ]]
--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]

--[[ function isAlive(Unit) ]]
---- Returns true if Unit is alive

--[[ function isBoss() ]]
---- Returns true if a boss is found in boss 1-2-3-4-5

--[[ function isBuffed(UnitID,SpellID,TimeLeft) ]]
---- Rturns true if Unit have at least Timeleft remaining on SpellId Buff

--[[ function isCasting(Unit) ]]
---- Returns true if Unit is casting

--[[ function isCastingSpell(spellID) ]]
---- returns true if we are casting spellid

--[[ function isDummy(Unit) ]]
---- Returns true if Unit is a dummy

--[[ function isEnnemy(Unit) ]]
---- Returns true if we can attack the Unit


--[[ function isGarrMCd(Unit) ]]
---- Returns true if Unit if affected by Garrosh MC

--[[ function isInCombat(Unit) ]]
---- Returns true if Unit is in combat

--[[ function isInMelee(Unit) ]]
---- Returns true if we are withing 4 yard of the Unit

--[[ function isInPvP() ]]
---- Returns true if we are in PvP

--[[ function isKnown(spellID) ]]
---- Returns true if we know this spell(via spellbook check)

--[[ function isLooting() ]]
---- Returns true if we are currently looting

--[[ function isMoving(Unit) ]]
---- Returns Unit movement speed

--[[ function IsMovingTime(time) ]]
---- Returns true if we have been moving for time seconds

--[[ function isSpellInRange(SpellID,Unit) ]]
---- Returns true spell is in Range of Unit

--[[ function isValidTarget(Unit) ]]
---- Returns true if the target is valid

--[[ function nDbDmg(tar, spellID, player) ]]
---- Returns tooltip damage

--[[ function pause() --Pause ]]
---- returns true if pause is engaged

--[[ function useItem(itemID) ]]
---- Uses item via ID

--[[           ]]	--[[           ]]	--[[           ]]
--[[           ]]	--[[           ]]	--[[           ]]
--[[]]				--[[]]				--[[]] 
--[[]]				--[[           ]] 	--[[]]	 --[[  ]]
--[[]]				--[[		   ]]	--[[]]     --[[]]
--[[           ]]	--[[]]				--[[           ]]
--[[           ]]	--[[]]      		--[[           ]]

-- if isChecked("Debug") then
--[[ function isChecked(Value) ]]
---- Returns true if Value Checkbox is checked in UI

--[[ function isSelected(Value) ]]
---- Returns true if Value Checkbox is checked in UI and CD requirements are met.

--[[ function getValue(Value) ]]
---- Returns drop or box Value from UI

































