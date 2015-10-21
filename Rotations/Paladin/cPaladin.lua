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
	self.defaultSeal = 1 -- Uses first Seal as default if no one is specified in c_SPEC_.lua
	self.seal        = true
	self.paladinSpell = {
		crusaderStrike      = 35395,
        divineProtection    = 498,
		divineShield        = 642,
		eternalFlame        = 114163,
		executionSentence   = 114157,
		exorcism            = 879,
		fistOfJustice       = 105593,
		flashOfLight        = 19750,
		hammerOfJustice     = 853,
		hammerOfWrath       = 24275,
		holyAvenger         = 105809,
		holyPrism           = 114165,
		judgment            = 20271,
		layOnHands          = 633,
		lightsHammer        = 114158,
		rebuke              = 96231,
		repentance          = 20066,
		sacredShield        = 20925,
		sealOfRighteousness = 20154,
		sealOfThruth        = 31801,
        selflessHealer      = 85804,
        selflessHealerBuff  = 114250,
		wordOfGlory         = 85673,
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

		-- Seal check
		self.checkSeal()

		-- Blessing check
		self.castBlessing()
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
    function self.createClassOptionsOLD()
        -- Create Base Options
        self.createBaseOptions()

        -- Class Wrap
        CreateNewWrap(thisConfig, "--- Class Options ---")

        -- Blessing
        CreateNewCheck(thisConfig,"Blessings")
        CreateNewDrop(thisConfig,"Blessings",1,"|cffFFFFFFWhich blessing do you want to maintain on raid","|cff0374FEKings","|cffFFBC40Might","|cff00FF0DAuto")
        CreateNewText(thisConfig,"Blessings")

        -- Spacer
        CreateNewText(" ");
    end

    function self.createClassOptions()
        -- Create Base Options
        self.createBaseOptions()

        local section_class = createNewSection(bb.profile_window, "Class Options")
        createNewDropdown(section_class,"Blessings", {"Kings","Might","Auto"})
        checkSectionState(section_class)
    end
    --------------
    --- SPELLS ---
    --------------

    -- Casts given Seal
	function self.castSeal(seal)
		return castSpell("player",seal,true,false) == true or false
	end

    -- Checks if seal is applied; casts given seal or defaultSeal if not
	function self.checkSeal(seal)
		if self.seal == 0 then
			if seal == nil then
				seal = self.defaultSeal
			end
			if self.castSeal(seal) then return end
		else
			return false
		end
	end
	
    -- Common blessing selector(all specs)
	function self.castBlessing()
		-- if ability is selected
		if isChecked("Blessings") then
			-- if we just logged or reloaded, we dont want to spam cast it instantly so we define a timer
			if timerBlessing == nil then
				timerBlessing = GetTime()
			end
			if timerBlessing < GetTime() - 5 then
				doBlessings = true
			end
			if doBlessings ~= nil then
				-- after timer we find if we have other buffers in group via findBestBlessing
				local myBlessing = findBestBlessing()
				for i = 1,#nNova do
					local thisUnit = nNova[i]
					if thisUnit.hp < 250 and thisUnit.isPlayer and not UnitBuffID(thisUnit.unit,myBlessing) then
						if castSpell("player",myBlessing,true,false) then
							timerBlessing = GetTime() + random(10,20)
							doBlessings = nil
							return
						end
					end
				end
			end
		end
	end

    -- Finds best blessing based on group members
	function self.findBestBlessing()
		local modeBlessing = getValue("Blessings")
		local myBlessing = _BlessingOfKings
		-- if 3 and king buffer found buff might
		if modeBlessing == 3 then
			-- if theres a druide or monk or paladin, we do might.
			for i = 1, #nNova do
				local thisUnit = nNova[i]
				-- i think only these 3 class buff kings
				--local MemberClass = nNova[i].class
				if not UnitIsUnit("player",thisUnit.unit) and thisUnit.hp < 250 and thisUnit.isPlayer and
					(thisUnit.class == "DRUID" or thisUnit.class == "MONK" or thisUnit.class == "PALADIN") then
					myBlessing = _BlessingOfMight
					break
				end
			end
		-- if user selected a specific blessing we do it, if 2 selected, buff might, otherwise(1) buff kings
		elseif modeBlessing == 2 then
			myBlessing = _BlessingOfMight
		end
		return myBlessing
	end

    -- Return
	return self
end

end -- End Select Paladin