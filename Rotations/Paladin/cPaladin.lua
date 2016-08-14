--- Paladin Class
-- Inherit from: ../cCharacter.lua
-- All Paladin specs inherit from cPaladin.lua
if select(3, UnitClass("player")) == 2 then
cPaladin = {}

-- Creates Paladin with given specialisation
function cPaladin:new(spec)
	local self = cCharacter:new("Paladin")

    -----------------
    --- VARIABLES ---
    -----------------

	self.profile     = spec
	self.holyPower   = 0
	self.paladinSpell = {
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

		-- Holy Power
		self.holyPower = UnitPower("player",9)

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
    -- Options which every Paladin should have
    function self.createClassOptions()
        -- Create Base Options
        -- self.createBaseOptions()

        local section = bb.ui:createSection(bb.ui.window.profile, "Class Options")
        bb.ui:createDropdown(section,"Blessings", {"Kings","Might","Auto"})
        bb.ui:checkSectionState(section)
    end
    --------------
    --- SPELLS ---
    --------------

	function self.castRebuke(thisUnit)
		if getDistance(thisUnit)<5 then
			if castSpell(thisUnit,self.spell.rebuke,false,false,false) then return end
		end
	end
    -- Return
	return self
end

end -- End Select Paladin