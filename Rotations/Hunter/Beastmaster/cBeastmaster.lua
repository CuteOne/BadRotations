--- Beastmaster Class
-- Inherit from: ../cCharacter.lua and ../cHunter.lua
-- All Paladin specs inherit from cHunter.lua
if select(3, UnitClass("player")) == 3 then

    cBeastmaster = {}
    -- Contains the rotations
    cBeastmaster.rotations = {}

    -- Creates Beastmaster Hunter
    function cBeastmaster:new()
        local self = cHunter:new("Beastmaster")

        local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cBeastmaster.rotations

        self.cast = {}
        self.enemies = {

        }
        self.beastmasterSpell = {

        }

        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.hunterSpell, self.beastmasterSpell)


        -- Update OOC
        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

            self.getGlyphs()
            self.getTalents()
        end

        -- Update
        function self.update()
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getBuffs()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getEnemies()
            self.getOptions()

            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then
                return
            end


            -- Start selected rotation
            self:startRotation()
        end



        -- Buff updates
        function self.getBuffs()
            local getBuffRemain,UnitBuffID = getBuffRemain,UnitBuffID

        end

        -- Cooldown updates
        function self.getCooldowns()
            local getSpellCD = getSpellCD

        end

        -- Glyph updates
        function self.getGlyphs()
            local hasGlyph = hasGlyph

        end

        -- Talent updates
        function self.getTalents()
            local isKnown = isKnown

        end

        -- Update Dynamic units
        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Throttle dynamic target updating
            if bb.timer:useTimer("dynTarUpdate", self.dynTargetTimer) then
                -- Normal

                -- AoE
            end
        end

        -- Update Number of Enemies around player
        function self.getEnemies()
            local getEnemies = getEnemies

        end

        -- Updates toggle data
        function self.getToggleModes()
            local BadBoy_data   = BadBoy_data

            self.mode.aoe       = BadBoy_data["AoE"]
            self.mode.cooldowns = BadBoy_data["Cooldowns"]
            self.mode.defensive = BadBoy_data["Defensive"]
        end

        ---------------------------------------------------------------
        -------------------- OPTIONS ----------------------------------
        ---------------------------------------------------------------

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()

            self.rotations[bb.selectedProfile].toggles()
        end

        -- Creates the option/profile window
        -- you should not need to do anything here
        -- todo: check if its possible to put that into cCharacter to remove redundancy
        function self.createOptions()
            -- Create Profile Window
            bb.ui.window.profile = bb.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            bb.ui:createRotationDropdown(bb.ui.window.profile.parent, names)

            -- Create Base and Class option table
            local optionTable = {
                {
                    [1] = "Base Options",
                    [2] = self.createBaseOptions,
                },
                {
                    [1] = "Class Options",
                    [2] = self.createClassOptions,
                },
            }
            -- Get profile defined options
            local profileTable = self.rotations[bb.selectedProfile].options()
            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end
            -- Create pages dropdown
            bb.ui:createPagesDropdown(bb.ui.window.profile, optionTable)

            bb:checkProfileWindowStatus()
        end

        -- todo: -> get the info within profile file, as they are rotation dependend
        function self.getOptions()

        end

        ---------------------------------------------------------------
        -------------------- Spell functions --------------------------
        ---------------------------------------------------------------

        -- Avenger's Shield
        --function self.cast.AvengersShield()
        --    return castSpell(self.units.dyn30,self.spell.avengersShield,false,false) == true or false
        --end


        -- Return
        return self
    end
end
