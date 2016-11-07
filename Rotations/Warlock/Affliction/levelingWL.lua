-- if select(3, UnitClass("player")) == 9 then
--     function cAffliction:levelingWL()
--         -- Locals
--         local mouse = "mouseover"
--         local buff,cd,mode,talent,glyph,gcd = self.buff,self.cd,self.mode,self.talent,self.glyph,self.gcd
--         local isChecked,enemies,units,eq,getCombatTime = isChecked,self.enemies,self.units,self.eq,getCombatTime
--         local spell = self.spell

--         -- Summon Demon
--         if self.summonDemon() then end

--         -- Mouseover Corruption
--         if ObjectExists(mouse) and UnitCanAttack("player", mouse) and not UnitDebuffID(mouse, spell.corruption_debuff, "player") then
--             castSpell(mouse, spell.corruption, true, false)
--         end

--         -- Mouseover Agony
--         if ObjectExists(mouse) and UnitCanAttack("player", mouse) and not UnitDebuffID(mouse, spell.agony, "player") then
--             castSpell(mouse, spell.agony, true, false)
--         end

--         -- Mouseover UA
--         if ObjectExists(mouse) and UnitCanAttack("player", mouse) and not UnitDebuffID(mouse, spell.unstable_affliction, "player") then
--             --castSpell(mouse, spell.unstable_affliction, true, false)
--         end
--     end
-- end


