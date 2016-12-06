-- SimC Rotation
-- Based on Version: unknown
-- Improved by Defmaster with T18 logic
-- if select(3, UnitClass("player")) == 2 then
--     local rotationName = "ProtCuteOne"
--     local rotationSpec = "Protection"

-- function cProtection:protectionSimC()
-- -- Locals
-- 	local player,holyPower,seal,recharge,cast = "player",self.holyPower,self.seal,self.recharge,self.cast
-- 	local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
-- 	local isChecked,enemies,units,eq,getCombatTime = isChecked,self.enemies,self.units,self.eq,getCombatTime
-- 	local lastSpellCast = lastSpellCast

--     -- OOC Action List
--     local function actionList_OOC()
--         -- Buffs logic
--         cast.Buffs()

--         -- TEST PRE PULL
--         if br.DBM:getPulltimer(2) then
--             useItem(109220)
--             cast.SacredShield()
--         end
--     end

--     local function actionList_Interrupts()
--         --Rebuke
--         if isChecked("Rebuke") then
--             for i=1, #getEnemies("player",5) do
--                 local thisUnit = getEnemies("player",5)[i]
--                 if canInterrupt(thisUnit,getOptionValue("Rebuke")) then
--                     if self.castRebuke(thisUnit) then return end
--                 end
--             end
--         end
--     end


--     -- Special DMG cheasing with T18 Class Trinket
--     -- TODO: improve by only iterate 1 time through buffs with buff list
--     local function actionList_T18cancelShields()
--         -- Cancel Powerword:Shield, 2T18 Buff, Sacred Shield, (Clarity of Will)
--         if eq.t18_classTrinket and self.health > getValue("Trinket % Trigger") and isChecked("Trinket % Trigger") and mode.classTrinket == 1 then
--             if protPaladinClassTrinketProc == nil or GetTime()-12 > protPaladinClassTrinketProc then
--                 if isChecked("Cancel Power Word: Shield") then cancelBuff(17) end
--                 if isChecked("Cancel Clarity of Will") then cancelBuff(152118) end
--                 if isChecked("Cancel Sacred Shield") then cancelBuff(65148) end
--                 if isChecked("Cancel Avenger's Reprieve") then cancelBuff(185676) end
--             end
--         end
--     end

--     -- inCombat Action List
--     local function actionList_inCombat()
--         -- make sure we have a seal(often removed by changing talents/glyph)
--         -- Default: Insight
--         if seal == 0 then
--             if cast.Seal(2) then
--                 return
--             end
--         end

--         cast.survival()

--         --if cast.Interrupts() then
--         --    return
--         --end

--         -- we use defensive moves regardless of rotation
--         -- actions+=/divine_protection,if=time<5|!talent.seraphim.enabled|(buff.seraphim.down&cooldown.seraphim.remains>5&cooldown.seraphim.remains<9)
--         if getCombatTime() < 5 or not talent.seraphim or (buff.seraphim == 0 and cd.seraphim > 5 and cd.seraphim < 9) then
--             cast.DivineProtection()
--         end
--         -- actions+=/guardian_of_ancient_kings,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down)
--         if getCombatTime() < 5 or (buff.holyAvenger == 0 and buff.shieldOfTheRighteous == 0 and buff.divineProtection == 0) then
--             cast.GuardianOfAncientKings()
--         end
--         -- actions+=/ardent_defender,if=time<5|(buff.holy_avenger.down&buff.shield_of_the_righteous.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down)
--         if getCombatTime() < 5  or (buff.holyAvenger == 0 and buff.shieldOfTheRighteous == 0 and buff.divineProtection == 0 and buff.guardianOfAncientKings == 0) then
--             cast.ArdentDefender()
--         end
--         -- actions+=/potion,name=draenic_armor,if=buff.shield_of_the_righteous.down&buff.seraphim.down&buff.divine_protection.down&buff.guardian_of_ancient_kings.down&buff.ardent_defender.down
        

--         -------------------------------------------------------------------------------------------------------------------------------
--         -------------------------------------------------------------------------------------------------------------------------------
--         -------------------------------------------------------------------------------------------------------------------------------
--         -------------------------------------------------------------------------------------------------------------------------------
        
--         -- # This section covers off-GCD spells.
--         -- actions+=/holy_avenger
--         cast.HolyAvenger()
--         -- actions+=/seraphim
--         cast.Seraphim()
--         -- actions+=/shield_of_the_righteous,if=buff.divine_purpose.react
--         if buff.divinePurpose > 0 then
--             cast.holyPowerConsumers()
--         end
--         -- actions+=/shield_of_the_righteous,if=buff.holy_avenger.remains>time_to_hpg&(!talent.seraphim.enabled|cooldown.seraphim.remains>time_to_hpg)
--         if (holyPower == 5 or (holyPower >= 3 and buff.holyAvenger > gcd))
--                 and (not talent.seraphim or cd.seraphim > 5) or (holyPower >= 3 and buff.bastionOfGlory > 0 and buff.bastionOfGlory < 3) then
--             cast.holyPowerConsumers()
--         end

--         -- # GCD-bound spells start here
--         if talent.empoweredSeals then
--             -- actions+=/seal_of_insight,if=!seal.insight&buff.uthers_insight.remains<cooldown.judgment.remains
--             if seal ~= 2 and buff.uthersInsight < recharge.judgment and (mode.empS == 1 or mode.empS == 3) then
--                 if cast.Seal(2) then
--                     return
--                 end
--             end
--             -- actions+=/seal_of_righteousness,if=!seal.righteousness&buff.uthers_insight.remains>cooldown.judgment.remains&buff.liadrins_righteousness.down
--             if seal ~= 1 and buff.uthersInsight > recharge.judgment
--                     and buff.liadrinsRighteousness < recharge.judgment and (mode.empS == 1 or mode.empS == 2) then
--                 if cast.Seal(1) then
--                     return
--                 end
--             end
--         end
--         -- actions+=/avengers_shield,if=buff.grand_crusader.react&active_enemies>1&!glyph.focused_shield.enabled
--         if (buff.grandCrusader > 0 and self.aroundTarget7Yards > 1 and not glyph.focusedShield) or
--                 (eq.t18_2pc and not buff.holyAvenger)  or
--                 (eq.t18_2pc and buff.holyAvenger and buff.grandCrusader > 0)
--         then
--             if cast.AvengersShield() then
--                 return
--             end
--         end
--         -- actions+=/hammer_of_the_righteous,if=active_enemies>=3
--         if self.aroundTarget7Yards >= 3 then
--             if cast.HammerOfTheRighteous() then
--                 return
--             end
--         else
--             -- actions+=/crusader_strike
--             if cast.CrusaderStrike() then
--                 return
--             end
--         end
--         -- actions+=/wait,sec=cooldown.crusader_strike.remains,if=cooldown.crusader_strike.remains>0&cooldown.crusader_strike.remains<=0.35
--         if cd.crusaderStrike < 0.35 and getDistance("player",units.dyn5) < 5 and self.unitInFront then
--             return
--         end
--         -- actions+=/judgment,cycle_targets=1,if=glyph.double_jeopardy.enabled&last_judgment_target!=target
--         -- actions+=/judgment
--         if cast.Jeopardy() then
--             return
--         end
--         -- actions+=/wait,sec=cooldown.judgment.remains,if=cooldown.judgment.remains>0&cooldown.judgment.remains<=0.35
--         if cd.judgment < 0.35 then
--             return
--         end
--         -- actions+=/avengers_shield,if=active_enemies>1&!glyph.focused_shield.enabled
--         if self.aroundTarget7Yards > 1 and not glyph.focusedShield then
--             if cast.AvengersShield() then
--                 return
--             end
--         end
--         -- actions+=/holy_wrath,if=talent.sanctified_wrath.enabled
--         if talent.sanctifiedWrath then
--             if cast.HolyWrath() then
--                 return
--             end
--         end
--         -- actions+=/avengers_shield,if=buff.grand_crusader.react
--         if buff.grandCrusader > 0 then
--             if cast.AvengersShield() then
--                 return
--             end
--         end
--         -- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<2
--         if buff.sacredShield < 2 then
--             if cast.SacredShield() then
--                 return
--             end
--         end
--         -- actions+=/holy_wrath,if=glyph.final_wrath.enabled&target.health.pct<=20
--         if glyph.finalWrath and getHP(units.dyn8AoE) <= 20 then
--             if cast.HolyWrath() then
--                 return
--             end
--         end
--         -- actions+=/avengers_shield
--         if cast.AvengersShield() then
--             return
--         end
--         -- actions+=/lights_hammer,if=!talent.seraphim.enabled|buff.seraphim.remains>10|cooldown.seraphim.remains<6
--         if cast.LightsHammer() then
--             return
--         end
--         -- actions+=/holy_prism,if=!talent.seraphim.enabled|buff.seraphim.up|cooldown.seraphim.remains>5|time<5
--         if cast.HolyPrism() then
--             return
--         end
--         -- actions+=/consecration,if=target.debuff.flying.down&active_enemies>=3
--         if enemies.yards9 >=3 then
--             if cast.Consecration() then
--                 return
--             end
--         end
--         -- actions+=/execution_sentence,if=!talent.seraphim.enabled|buff.seraphim.up|time<12
--         if cast.ExecutionSentence() then
--             return
--         end
--         -- actions+=/hammer_of_wrath
--         if cast.HammerOfWrath() then
--             return
--         end
--         -- actions+=/sacred_shield,if=target.dot.sacred_shield.remains<8
--         if buff.sacredShield < 8 then
--             if cast.SacredShield() then
--                 return
--             end
--         end
--         -- actions+=/consecration,if=target.debuff.flying.down
--         if cast.Consecration() then
--             return
--         end
--         -- actions+=/holy_wrath
--         if cast.HolyWrath() then
--             return
--         end
--         -- Seals
--         if talent.empoweredSeals then
--             -- actions+=/seal_of_insight,if=!seal.insight&buff.uthers_insight.remains<=buff.liadrins_righteousness.remains
--             if seal ~= 2 then
--                 if buff.uthersInsight <= buff.liadrinsRighteousness and (mode.empS == 1 or mode.empS == 3) then
--                     if cast.Seal(2) then
--                         return
--                     end
--                 end
--             end
--             -- actions+=/seal_of_righteousness,if=!seal.righteousness&buff.liadrins_righteousness.remains<=buff.uthers_insight.remains
--             if seal ~= 1 then
--                 if buff.liadrinsRighteousness <= buff.uthersInsight and (mode.empS == 1 or mode.empS == 2) then
--                     if cast.Seal(1) then
--                         return
--                     end
--                 end
--             end
--         end
--         -- actions+=/sacred_shield
--         if cast.SacredShield() then
--             return
--         end
--     end


--     -- OOC Rotation
--     if not self.inCombat then
--         if actionList_OOC() then return true end
--     end

--     -- inCombat Rotation
--     if self.inCombat then
--         actionList_Interrupts()
--         actionList_T18cancelShields()
--         if actionList_inCombat() then return true end
--     end

-- end -- Main rota function

--     function cProtection:protectionSimC_createToggles()
local rotationName = "ProtCuteOne"
local rotationSpec = "Protection"
local function createToggles()

end

local function createOptions()
    local optionTable

    local function rotationOptions()

    end
end
local function runRotation()
    if br.timer:useTimer("debugProtection", math.random(0.15,0.3)) then

    end
end
local id = 66
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})