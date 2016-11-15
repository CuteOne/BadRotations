--- Hunter Class
-- Inherit from: ../cCharacter.lua
-- All Hunter specs inherit from cHunter.lua
if select(3, UnitClass("player")) == 3 then
    cHunter = {}

    -- Creates Hunter with given specialisation
    function cHunter:new(spec)
        local self = cCharacter:new("Hunter")

        -----------------
        --- VARIABLES ---
        -----------------

        self.profile     = spec
        self.spell = {

        }

        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.classUpdateOOC()
            -- Call baseUpdateOOC()
            self.baseUpdateOOC()
        end

        --------------
        --- UPDATE ---
        --------------

        function self.classUpdate()
            -- Call baseUpdate()
            self.baseUpdate()

        end

        -------------
        --- BUFFS ---
        -------------

        ---------------
        --- DEBUFFS ---
        ---------------

        -----------------
        --- COOLDOWNS ---
        -----------------

        --------------
        --- GLYPHS ---
        --------------

        ---------------
        --- TALENTS ---
        ---------------

        ---------------
        --- OPTIONS ---
        ---------------

        -- Class options
        -- Options which every Hunter should have
        function self.createClassOptions()
            -- Create Base Options
            self.createBaseOptions()

            local section = br.ui:createSection(br.ui.window.profile, "Class Options", "Nothing")

            br.ui:checkSectionState(section)
        end
        --------------
        --- SPELLS ---
        --------------


        -- Return
        return self
    end

end -- End Select Hunter