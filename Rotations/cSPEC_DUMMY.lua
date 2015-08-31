--- __SPEC Class
-- Inherit from: ../../cCharacter.lua and ../c__CLASS
if select(2, UnitClass("player")) == "_CLASSNAME" then
    c__SPEC = {}

    -- Creates __CLASS with given specialisation
    function c__SPEC:new(spec)
        local self = cCharacter:new("__SPEC")

        -----------------
        --- VARIABLES ---
        -----------------

        self.profile = spec
        self.enemies = {
            yards5,
        }

        self.__SPECSpell = {}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.__CLASSSpell, self.__SPECSpell)


        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.updateOOC()
            self.classUpdateOOC()
            self.getClassGlyphs()
            self.getClassTalents()
        end

        --------------
        --- UPDATE ---
        --------------

        function self.update()
            self.classUpdate()

            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end

            self.getOptions()
            self.getBuffs()
            self.getDebuffs()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getEnemies()
            self.getRotation() -- cCharacter


            -- Start selected rotation
            self:startRotation()
        end

        -------------
        --- BUFFS ---
        -------------

        function self.getBuffs()
            --local getBuffRemain = getBuffRemain

            --self.buff. = getBuffRemain("player", self.spell.)
        end

        ---------------
        --- DEBUFFS ---
        ---------------

        function self.getDebuffs()
            --local getDebuffRemain, getDebuffDuration = getDebuffRemain, getDebuffDuration

            --self.debuff.         = getDebuffRemain(self.units.dyn5, self.spell.) or 0
        end

        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            --local getSpellCD = getSpellCD

            --self.cd.   = getSpellCD(self.spell.)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            --local hasGlyph = hasGlyph

            --self.glyph.   = hasGlyph()
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            --local isKnown = isKnown

            --self.talent.     = isKnown(self.spell.)
        end

        ---------------
        --- OPTIONS ---
        ---------------

        function self.createOptions()
            thisConfig = 0

            -- Title
            CreateNewTitle(thisConfig, "__SPEC __AUTHOR")

            -- Create Base and Class options
            self.createClassOptions()

            -- __SPEC options
            CreateNewWrap(thisConfig, "--- General ---")

            -- Rotation
            CreateNewDrop(thisConfig, "Rotation", 1, "Select Rotation.", "|cff00FF00STD")
            CreateNewText(thisConfig, "Rotation")

            --- PUT OPTIONS BELOW


            --- PUT OPTIONS ABOVE

            -- General Configs
            CreateGeneralsConfig();

            WrapsManager();
        end

        function self.getOptions()
            --self. = getValue(" ")
        end

        ---------------------
        --- DYNAMIC UNITS ---
        ---------------------

        function self.getDynamicUnits()
            --local dynamicTarget = dynamicTarget

            -- Normal
            --self.units.dyn20 = dynamicTarget(20, true)

            -- AoE
            --self.units.dyn20AoE = dynamicTarget(20, false)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                --self:__SPECrotationName()
                -- put different rotations below; dont forget to setup your rota in options
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        --------------
        --- SPELLS ---
        --------------

        -- Casts
        --function self.cast()
        --    return castSpell(_TARGET, _SPELL, false, false) == true or false
        --end


        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()

        -- Return
        return self
    end
end -- End Select