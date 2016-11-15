--- Resto Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
if select(2, UnitClass("player")) == "DRUID" then
	cResto = {}
    cResto.rotations = {}

	-- Creates Resto Druid
	function cResto:new()
		local self = cDruid:new("Resto")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cResto.rotations
		
		-----------------
        --- VARIABLES ---
        -----------------
        self.trinket            = {}        -- Trinket Procs
		self.restoSpell         = {

			-- Ability - Crowd Control
			cyclone 							= 33786,

			-- Ability - Defensive
            lifebloom                           = 33763,
            rejuvenation                        = 774,
            healingTouch                        = 5185,
            regrowth                            = 8936,
            wildGrowth                          = 48438,
            swiftmend                           = 18562,
			heartOfTheWild 						= 108294,

			-- Ability - Forms
            incarnationTreeOfLife               = 33891,

			-- Ability - Offensive
			forceOfNature 						= 102693,

			-- Ability - Utility
			stampedingRoar 						= 77764,

			-- Buff - Defensive
			heartOfTheWildBuff 					= 108294,
			clearCastingBuff      				= 16870,

			-- Buff - Forms
            incarnationTreeOfLifeBuff           = 117679,

			-- Buff - Offensive

			-- Buff - Utility
			stampedingRoarBuff 					= 77764,

			-- Debuff - Offensive

			-- Glyphs
			wildGrowthGlyph 					= 62970,

			-- Perks

			-- Talents
			dreamOfCenariusTalent 				= 158504,
			forceOfNatureTalent 				= 102693,
            germinationTalent                   = 155675,
			heartOfTheWildTalent 				= 108294,
			incarnationTreeOfLifeTalent       	= 33891,
			momentOfClarityTalent				= 155577,
            naturesVigilTalent                  = 124974,
            rampantGrowthTalent                 = 155834,
			soulOfTheForest 					= 158478,

		}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.druidSpell, self.restoSpell)
		
	------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getGlyphs()
            self.getTalents()
            self.getPerks()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCharge()
            self.getCooldowns()
            self.getTrinketProc()
            self.hasTrinketProc()
            self.getRecharges()
            self.getToggleModes()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end

            -- Start selected rotation
            self:startRotation()
        end
     
   	-------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
        	local UnitBuffID = UnitBuffID

        	self.buff.heartOfTheWild               = UnitBuffID("player",self.spell.heartOfTheWildBuff)~=nil or false
            self.buff.stampedingRoar               = UnitBuffID("player",self.spell.stampedingRoarBuff)~=nil or false
        end

        function self.getBuffsDuration()
        	local getBuffDuration = getBuffDuration

        	self.buff.duration.heartOfTheWild              = getBuffDuration("player",self.spell.heartOfTheWildBuff) or 0
            self.buff.duration.stampedingRoar              = getBuffDuration("player",self.spell.stampedingRoarBuff) or 0
        end

        function self.getBuffsRemain()
        	local getBuffRemain = getBuffRemain

        	self.buff.remain.heartOfTheWild				= getBuffRemain("player",self.spell.heartOfTheWildBuff) or 0
            self.buff.remain.stampedingRoar 			= getBuffRemain("player",self.spell.stampedingRoarBuff) or 0
        end

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

        end

        function self.hasTrinketProc()
            for i = 1, #self.trinket do
                if self.trinket[i]==true then return true else return false end
            end
        end

    ---------------
    --- CHARGES ---
    ---------------

		function self.getCharge()
			local getCharges = getCharges
			local getBuffStacks = getBuffStacks

			self.charges.forceOfNature 	= getCharges(self.spell.forceOfNature)
        end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.heartOfTheWild 					= getSpellCD(self.spell.heartOfTheWild)
            self.cd.incarnationTreeOfLife  	        = getSpellCD(self.spell.incarnationTreeOfLife)
            self.cd.stampedingRoar 					= getSpellCD(self.spell.stampedingRoar)
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.wildGrowth   	= hasGlyph(self.spell.wildGrowthGlyph)
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.soulOfTheForest 			= getTalent(4.1)
            self.talent.incarnationTreeOfLife 	    = getTalent(4,2)
            self.talent.forceOfNature 				= getTalent(4,3)
            self.talent.heartOfTheWild 				= getTalent(6,1)
            self.talent.dreamOfCenarius 			= getTalent(6,2)
            self.talent.naturesVigil                = getTalent(6,3)
            self.talent.momentOfClarity    			= getTalent(7,1)
            self.talent.germination 				= getTalent(7,2)
            self.talent.rampantGrowth 	     		= getTalent(7,3)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
        	local isKnown = isKnown

        end

    -----------------
    --- RECHARGES ---
    -----------------
    
    	function self.getRecharges()
    		local getRecharge = getRecharge

    		self.recharge.forceOfNature = getRecharge(self.spell.forceOfNature)
    	end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()
            local data   = br.data

            self.mode.rotation  = data["Rotation"]
            self.mode.cooldown  = data["Cooldown"]
            self.mode.defensive = data["Defensive"]
            self.mode.interrupt = data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            self.rotations[br.selectedProfile].toggles()
        end

    ---------------
    --- OPTIONS ---
    ---------------
        
        -- Creates the option/profile window
        function self.createOptions()
            br.ui.window.profile = br.ui:createProfileWindow(self.profile)

            -- Get the names of all profiles and create rotation dropdown
            local names = {}
            for i=1,#self.rotations do
                tinsert(names, self.rotations[i].name)
            end
            br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

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
            local profileTable = self.rotations[br.selectedProfile].options()

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            br.ui:createPagesDropdown(br.ui.window.profile, optionTable)
            br:checkProfileWindowStatus()
        end

    ------------------------------
    --- SPELLS - CROWD CONTROL ---
    ------------------------------


    --------------------------
    --- SPELLS - DEFENSIVE ---
    --------------------------

        -- Heart of the Wild
        function self.castHeartOfTheWild()
            if self.talent.heartOfTheWild and self.cd.heartOfTheWild==0 then
        	   if castSpell("player",self.spell.heartOfTheWild,false,false,false) then return end
            end
        end

    ----------------------
    --- SPELLS - FORMS ---
    ----------------------

    --------------------------
    --- SPELLS - OFFENSIVE ---
    --------------------------


        -- Stampeding Roar
        function self.castStampedingRoar()
            if self.level>=84 and self.cd.stampedingRoar==0 then
                if castSpell("player",self.spell.stampedingRoar,false,false,false) then return end
            end
        end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        function outOfWater()
            if swimTime == nil then swimTime = 0 end
            if outTime == nil then outTime = 0 end
            if IsSwimming() then
                swimTime = GetTime()
                outTime = 0
            end
            if not IsSwimming() then
                outTime = swimTime
                swimTime = 0
            end
            if outTime ~= 0 and swimTime == 0 then
                return true
            end
            if outTime ~= 0 and IsFlying() then
                outTime = 0
                return false
            end
        end
        function buffRemain(unit, spellID, source)
            if UnitBuffID(unit,spellID,source) ~= nil then
                return (select(7,UnitBuffID(unit,spellID,source)) - GetTime())
            end
            return 0
        end
        function canCast(unit, distance, facing, movement, standing)
        if facing == nil then facing = true end
        if movement == nil then movement = false end
        if standing == nil then standing = false end
            if GetObjectExists(unit) and UnitIsVisible(unit) and not UnitIsDeadOrGhost(unit) then
                if facing == false or unit == "player" or (facing == true and getFacing("player",unit) == true) then
                    if movement == false or (movement == true and isMoving("player") ~= true) then
                        if standing == false or (standing == true and isStanding(0.3)) then
                            if getDistance("player",unit) <= distance then
                                return true
                            end
                        end
                    end
                end
            end
        return false
        end
        --faceUnit(br.friend[i].unit)   
        function faceUnit(unit)
            if unit ~= "player" then
                if getFacing("player",unit) == false and isMoving("player") ~= true then
                    FaceDirection(GetAnglesBetweenObjects("Player", unit), true)    
                end
            end
        end
        function unitHP(unit)
            return 100*UnitHealth(unit)/UnitHealthMax(unit)
        end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cResto
end-- select Druid