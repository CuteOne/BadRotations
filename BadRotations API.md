# Development Informations.
### The Macros
* /power ---- Start/Stop Badboy Entirely
* /aoe ------- Toggles AoE Modes
* /cooldowns -- Toggles Cooldowns
* /pause ---- Stop attacking
### The Functions.
**Old standar UnitBuff**
***
`UnitBuffID(UnitID, SpellID, Filter) - 1/nil` Returns 1 if Buff found on target
`UnitDebuffID(UnitID, SpellID, Filter) - 1/nil` Returns 1 if Debuff found on target
**CAN - Booleans**
***
`canAttack(Unit1,Unit2) - Bool` Returns true if Unit1 can attack Unit2
`canDispel(Unit,spellID) - Bool` Retruns true if the Unit have a valid Dispel
`canHeal(Unit) - Bool` Returns true if we can heal that Unit
`canInterrupt(spellID,percentint) - Bool` Returns true if we can Interrupt that target
`canPrepare() - Bool` Returns true if ready to buff(ooc)
`canRun() - Bool` Returns true if we can Run profile(incombat)
`canUseItem(itemID) - Bool` Returns true if the item can be used
**CAST - Function Methods**
***
`castGround(Unit,SpellID,maxDistance)` Used to cast Spells on ground. Returns true if everything passes.
`castGroundBetween(Unit,SpellID,maxDistance) ` Used to ground cast between yourself and target. Returns true if everything passes.
`castHealGround(SpellID,Radius,Health,NumberOfPlayers)` Used to ground cast between lowest br.friend members. Returns true if everything passes.
[castSpell(Unit,SpellID,FacingCheck,MovementCheck,SpamAllowed,KnownSkip)](https://github.com/CuteOne/BadRotations/wiki/castSpell-Method#castspell) Used to cast Spells. Returns true if everything passes.
**GET - Mixed**
***
`getAllies(Target,Radius) - Table` Returns a table of the allies found within Radius of the target
`getBuffRemain(Unit,BuffID) - Num` Returns how long remain on this Unit buff.
`getBuffStacks(Unit,BuffID) - Num` Returns number of stacks of this Units buff.
`getCombatTime() - Num` Returns time since combat started.
`getCreatureType(Unit) - Bool` Returns true if Unit is not a pet battle or a totem.
`getCombo() - Num` Returns combo points on current target.
`getDebuffRemain(Unit,DebuffID) - Num` Returns how long remain on this Units Debuff.
`getDebuffStacks(Unit,DebuffID)  - Num` Returns number of stacks of this Units Debuff.
`getDistance(Unit1,Unit2) - Num` Returns distance to target in yards.
`getEnemies(Target,Radius) - Table` Returns a table of the Enemies found within Radius of the target
`getFacing(Unit1,Unit2)	- Bool` Returns true if Unit1 is facing Unit2
`getFallTime() - Num` Returns the time the character has been falling.
`getGround(Unit) - Bool` Returns true if ground is found under the target
`getHP(Unit) - Num` Returns Unit HP %
`getLineOfSight(Unit1,Unit2) - Bool` Returns true if the Unit1 can see Unit2
`getLowAllies(Value) - Num` Returns number of units under Value HP in br.friend
`getMana(Unit) - Num` Returns Unit Mana %
`getNumEnemies(Target,Radius) - Num` Returns number of Enemies found within Radius of the target
`getPetLineOfSight(Unit) - Bool` Returns true if our pet is in sight of target
`getPower(Unit) - Num` Returns Unit Power %
`getRegen(Unit) - Num` Returns power regen rate of Unit
`round2(num, idp) - Num` Used to round numbers
`getSpellCD(SpellID) - Num` Returns how long remain until the CD is ready
`getTimeToDie(unit) - Num` Returns approximative Time To Die for Unit
`getTimeToMax(Unit) - Num` Returns how long it will take until our ressources are maxed
`getTotemDistance(Unit1) - Num` Returns distance from totem to target
`getVengeance() - Num` Returns player vengeance(considers classes)
**HAS**
***
`hasGlyph(glyphid)` Returns true if we have this Glyph
**IS - Booleans**
***
`isAlive(Unit) - Bool` Returns true if Unit is alive
`isBoss() - Bool` Returns true if a boss is found in boss 1-2-3-4-5
`isBuffed(UnitID,SpellID,TimeLeft) - Bool` Rturns true if Unit have at least Timeleft remaining on SpellId Buff
`isCasting(SpellID,Unit) - Bool` Returns true if Unit is casting given spell
`isCastingSpell(spellID) - Bool` returns true if WE are casting spellid
`isDummy(Unit) - Bool` Returns true if Unit is a dummy
`isEnnemy(Unit) - Bool` Returns true if we can attack the Unit
`isGarrMCd(Unit) - Bool` Returns true if Unit if affected by Garrosh MC
`isInCombat(Unit) - Bool` Returns true if Unit is in combat
`isInMelee(Unit) - Bool` Returns true if we are withing 4 yard of the Unit
`isInPvP() - Bool` Returns true if we are in PvP
`isKnown(spellID) - Bool` Returns true if we know this spell(via spellbook check)
`isLooting() - Bool` Returns true if we are currently looting
`isMoving(Unit) - Num` Returns Unit movement speed
`IsMovingTime(time) - Bool` Returns true if we have been moving for time seconds
`isSpellInRange(SpellID,Unit) - Bool` Returns true spell is in Range of Unit
`isValidTarget(Unit) - Bool` Returns true if the target is valid
**Uncategorized - Mixed**
***
`makeEnemiesTable()` - does not return anything but create br.enemy that hold br.enemy[i].unit br.enemy[i].distance and br.enemy[i].hp of all enemies in 40 yards
`nDbDmg(tar, spellID, player) - Num` Returns tooltip damage
`pause() - Bool` Returns true if pause is engaged
`castingUnit() - Bool` Returns true is said unit is casting.
`useItem(itemID)` Use item via ID
`shouldStopCasting(SpellID) - Bool` Built into casts methods. Prevents spell locking.
**Config Queries - Mixed**
***
`isChecked(Value) - Bool` Returns true if Value Checkbox is checked in UI
`isSelected(Value) - Bool` Returns true if Value Checkbox is checked in UI and CD requirements are met.
`getValue(Value) - Num` Returns drop or box Value from UI
`CreateNewCheck(value, textString, tip1, state)`
- Used to create checkboxes in UI
1. value must always be thisConfig - Do not change
2. textString - the name of your option - String
3. tip1 - the tooltip displayed when the user mouseover the checkbox - String
4. state - the désired deployment state - Numeric 0(Unchecked)/1(Checked)
`CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)`
- Used to create valueboxes in UI
1. value must always be thisConfig - Do not change
2. textString - the name of your option - String
3. minValue - minimum value for this option
4. maxValue - maximum value for this option
5. step - how much you want to add/sub from the actual value when user wheel-up/down over the box
6. base - what is the base value for this option
`CreateNewDrop(value, textString, base, tip1, value1, value2, value3, value4, value5, value6, value7, value8, value9, value10)`
- Used to create selectors in UI. Assigning tip "Toggles" will use predefined toggles, values should be empty when doing so.
1. value must always be thisConfig - Do not change
2. textString - the name of your option - String
3. the tooltip displayed when the user mouseover the checkbox - String
4 and more. Selections enumeration - Strings