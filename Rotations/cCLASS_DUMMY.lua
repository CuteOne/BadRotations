--- __CLASS Class
-- Inherit from: ../cCharacter.lua
-- All Class specs inherit from this file
if select(2, UnitClass("player")) == "_CLASSNAME" then
    c__CLASS = {}

    -- Creates Paladin with given specialisation
    function c__CLASS:new(spec)
        local self = cCharacter:new("__CLASS")

        -----------------
        --- VARIABLES ---
        -----------------

        self.profile = spec
        self.__CLASSSpell = {}


        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.classUpdateOOC()
            -- Call baseUpdateOOC()
            self.baseUpdateOOC()
            self.getClassGlyphs()
            self.getClassTalents()
        end

        --------------
        --- UPDATE ---
        --------------

        function self.classUpdate()
            -- Call baseUpdate()
            self.baseUpdate()
            self.getClassOptions()
            self.getClassBuffs()
            self.getClassDebuffs()
            self.getClassCooldowns()
        end

        -------------
        --- BUFFS ---
        -------------

        function self.getClassBuffs()
            --local getBuffRemain = getBuffRemain

            --self.buff. = getBuffRemain("player", self.spell.)
        end

        ---------------
        --- DEBUFFS ---
        ---------------

        function self.getClassDebuffs()
            --local getDebuffRemain, getDebuffDuration = getDebuffRemain, getDebuffDuration

            --self.debuff.         = getDebuffRemain(self.units.dyn5, self.spell.) or 0
        end

        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getClassCooldowns()
            --local getSpellCD = getSpellCD

            --self.cd.   = getSpellCD(self.spell.)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getClassGlyphs()
            --local hasGlyph = hasGlyph

            --self.glyph.   = hasGlyph()
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getClassTalents()
            --local isKnown = isKnown

            --self.talent.     = isKnown(self.spell.)
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createClassOptions()
            -- Create Base Options
            self.createBaseOptions()

            -- Class Wrap
            CreateNewWrap(thisConfig, "--- Class Options ---")

            --- PUT OPTIONS BELOW


            --- PUT OPTIONS ABOVE

            -- Spacer
            CreateNewText(" ");
        end

        function self.getClassOptions()
            --self. = getValue(" ")
        end

        --------------
        --- SPELLS ---
        --------------

        -- Casts
        --function self.cast()
        --    return castSpell(_TARGET, _SPELL, false, false) == true or false
        --end


        -- Return
        return self
    end
end -- End Select