--- Guardian Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
if select(2, UnitClass("player")) == "DRUID" then
    rakeApplied = {}
    ripApplied = {}
	cGuardian = {}
    cGuardian.rotations = {}

	-- Creates Guardian Druid
	function cGuardian:new()
		local self = cDruid:new("Guardian")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cGuardian.rotations
		
		-----------------
        --- VARIABLES ---
        -----------------
        self.bleed              = {}        -- Bleed/Moonfire Tracking
        self.bleed.rake         = {}        -- Rake Bleed
        self.bleed.rip          = {}        -- Rip Bleed
        self.bleed.thrash       = {}        -- Thrash Bleed
        self.bleed.moonfire     = {}        -- Moonfire Debuff
        self.charges.frac       = {}        -- Fractional Charges
        self.trinket            = {}        -- Trinket Procs
        self.enemies            = {
            yards5,
            yards8,
            yards13,
            yards20,
            yards40,
        }
		self.guardianArtifacts     = {
           
        }
        self.guardianBuffs         = {
            
        }
        self.guardianDebuffs       = {
            
        }
        self.guardianSpecials      = {
            
        }
        self.guardianTalents       = {
            
        }
        -- Merge all spell tables into self.spell
        self.guardianSpells = {}
        self.guardianSpells = mergeTables(self.guardianSpells,self.guardianArtifacts)
        self.guardianSpells = mergeTables(self.guardianSpells,self.guardianBuffs)
        self.guardianSpells = mergeTables(self.guardianSpells,self.guardianDebuffs)
        self.guardianSpells = mergeTables(self.guardianSpells,self.guardianSpecials)
        self.guardianSpells = mergeTables(self.guardianSpells,self.guardianTalents)
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.druidSpell, self.guardianSpells)
		
	------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
            self.getArtifacts()
            self.getArtifactRanks()
            self.getGlyphs()
            self.getTalents()
            -- self.getPerks() --Removed in Legion
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            -- self.guardian_bleed_table()
            self.getBleedUnits()
            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCharge()
            self.getCooldowns()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getTrinketProc()
            self.hasTrinketProc()
            self.getEnemies()
            self.getRecharges()
            self.getToggleModes()
            self.getCastable()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end

            -- Start selected rotation
            self:startRotation()
        end

    ---------------------
    --- DYNAMIC UNITS ---
    ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8 = dynamicTarget(8, true) -- Swipe
            self.units.dyn13 = dynamicTarget(13, true) -- Skull Bash

            -- AoE
            self.units.dyn8AoE = dynamicTarget(8, false) -- Thrash
        end

    -----------------
    --- ARTIFACTS ---
    -----------------

        function self.getArtifacts()
            local isKnown = isKnown

            --self.artifact.ashamanesBite     = isKnown(self.spell.ashamanesBite)
        end

        function self.getArtifactRanks()

        end

    --------------
    --- BLEEDS ---
    --------------
        function self.getSnapshotValue(dot)
            -- if dot ~= "rip" and dot ~= "rake" then return 0 end
            -- local multiplier        = 1.00
            -- local Bloodtalons       = 1.30
            -- local SavageRoar        = 1.40
            -- local TigersFury        = 1.15
            -- local RakeMultiplier    = 1
            -- local Incarnation       = 2
            -- local Prowl             = 2
            -- local Versatility       = GetCombatRatingBonus(29)

            -- -- Bloodtalons
            -- if UnitBuffID("player",155672) then
            --     multiplier = multiplier*Bloodtalons
            -- end
            -- -- Savage Roar
            -- if UnitBuffID("player",52610) then
            --     multiplier = multiplier*SavageRoar
            -- end
            -- -- Tigers Fury
            -- if UnitBuffID("player",5217) then
            --     multiplier = multiplier*TigersFury
            -- end

            -- -- rip
            -- if dot == "rip" then
            --     -- -- Versatility
            --     -- multiplier = multiplier*(1+Versatility*0.1)

            --     -- return rip
            --     return 5*multiplier
            -- end
            -- -- rake
            -- if dot == "rake" then
            --     -- Incarnation
            --     if UnitBuffID("player",102543) then
            --         RakeMultiplier = Incarnation
            --     end
            --     -- Prowl
            --     if UnitBuffID("player",5215) then
            --         RakeMultiplier = Prowl
            --     end
            --     -- return rake
            --     return multiplier*RakeMultiplier
            -- end
        end

        function self.getBleedUnits()
            -- if self.bleed == nil then
            --     self.bleed = {rake={},rip={},thrash={},moonfire={}}
            -- else
            --     table.wipe(self.bleed.rake)
            --     table.wipe(self.bleed.rip)
            --     table.wipe(self.bleed.thrash)
            --     table.wipe(self.bleed.moonfire)
            -- end                
            -- local enemies = getEnemies("player", 40)
            -- local getDebuffRemain = getDebuffRemain
            -- local getDebuffDuration = getDebuffDuration
            -- local rakeCalc = self.getSnapshotValue("rake")
            -- local ripCalc = self.getSnapshotValue("rip")
            -- local rakeDot = rakeDot
            -- local ripDot = ripDot
            -- -- Find Bleed Units
            -- if #enemies>0 then
            --     for i = 1, #enemies do
            --         -- Get Bleed Unit
            --         local thisUnit = enemies[i]
            --         local distance = getDistance(thisUnit)
            --         -- Get Bleed Remain
            --         local rakeRemain        = getDebuffRemain(thisUnit,self.spell.rakeDebuff,"player")
            --         local rakeDuration      = getDebuffDuration(thisUnit,self.spell.rakeDebuff,"player")
            --         local ripRemain         = getDebuffRemain(thisUnit,self.spell.ripDebuff,"player")
            --         local ripDuration       = getDebuffDuration(thisUnit,self.spell.ripDebuff,"player")
            --         local thrashRemain      = getDebuffRemain(thisUnit,self.spell.thrashDebuff,"player")
            --         local thrashDuration    = getDebuffDuration(thisUnit,self.spell.thrashDebuff,"player")
            --         local moonfireRemain    = getDebuffRemain(thisUnit,self.spell.guardianMoonfireDebuff,"player")
            --         local moonfireDuration  = getDebuffDuration(thisUnit,self.spell.guardianMoonfireDebuff,"player")
            --         -- Get Bleed Applied
            --         if rakeApplied[thisUnit]~=nil then 
            --             rakeDot = rakeApplied[thisUnit] --rake
            --         else
            --             rakeDot = 1
            --         end
            --         if ripApplied[thisUnit]~=nil then 
            --             ripDot = ripApplied[thisUnit] --rip
            --         else
            --             ripDot = 2.5
            --         end
            --         -- Get Bleed Percent
            --         local rakePercent = floor(rakeCalc/rakeDot*100+0.5)
            --         local ripPercent = floor(ripCalc/ripDot*100+0.5)
            --         -- Add Bleed Units
            --         if distance<5 then
            --             tinsert(self.bleed.rake,{unit = thisUnit, remain = rakeRemain, duration = rakeDuration, calc = rakeCalc, applied = rakeDot, percent = rakePercent})
            --             tinsert(self.bleed.rip,{unit = thisUnit, remain = ripRemain, duration = ripDuration, calc = ripCalc, applied = ripDot, percent = ripPercent})
            --         end
            --         if distance<8 then
            --             tinsert(self.bleed.thrash,{unit = thisUnit, remain = thrashRemain, duration = thrashDuration})
            --         end
            --         if distance<40 then
            --             tinsert(self.bleed.moonfire,{unit = thisUnit, remain = moonfireRemain, duration = moonfireDuration})
            --         end
            --     end
            -- end
        end
        
   	-------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
        	local UnitBuffID = UnitBuffID

        	-- self.buff.berserk                      = UnitBuffID("player",self.spell.berserkBuff)~=nil or false
        end

        function self.getBuffsDuration()
        	local getBuffDuration = getBuffDuration

        	-- self.buff.duration.berserk                     = getBuffDuration("player",self.spell.berserkBuff) or 0
        end

        function self.getBuffsRemain()
        	local getBuffRemain = getBuffRemain

        	-- self.buff.remain.berserk                    = getBuffRemain("player",self.spell.berserkBuff) or 0
        end

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

        end

        function self.hasTrinketProc()
            -- for i = 1, #self.trinket do
            --     if self.trinket[i]==true then return true else return false end
            -- end
        end

    ---------------
    --- DEBUFFS ---
    ---------------
        function self.getDebuffs()
        	local UnitDebuffID = UnitDebuffID

        	-- self.debuff.ashamanesFrenzy   = UnitDebuffID(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player")~=nil or false
		end

		function self.getDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			-- self.debuff.duration.ashamanesFrenzy    = getDebuffDuration(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player") or 0
		end

		function self.getDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			-- self.debuff.remain.ashamanesFrenzy  = getDebuffRemain(self.units.dyn5,self.spell.ashamanesFrenzyDebuff,"player") or 0
		end

    ---------------
    --- CHARGES ---
    ---------------

		function self.getCharge()
			local getCharges = getCharges
            local getChargesFrac = getChargesFrac
			local getBuffStacks = getBuffStacks

			-- self.charges.bloodtalons 	   = getBuffStacks("player",self.spell.bloodtalonsBuff,"player")
		end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            -- self.cd.ashamanesFrenzy                 = getSpellCD(self.spell.ashamanesFrenzy)
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm   		= hasGlyph(self.spell.catFormGlyph))
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            -- self.talent.predator                    = getTalent(1,1)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
        	local isKnown = isKnown

        	-- self.perk.enhancedBerserk 		= isKnown(self.spell.enhancedBerserk)
        end

    ---------------
    --- ENEMIES ---
    ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5 = #getEnemies("player", 5) -- Melee
            self.enemies.yards8 = #getEnemies("player", 8) -- Swipe/Thrash
            self.enemies.yards13 = #getEnemies("player", 13) -- Skull Bash
            self.enemies.yards20 = #getEnemies("player", 20) --Prowl
            self.enemies.yards40 = #getEnemies("player", 40) --Moonfire
        end

    -----------------
    --- RECHARGES ---
    -----------------
    
    	function self.getRecharges()
    		local getRecharge = getRecharge

    		-- self.recharge.forceOfNature = getRecharge(self.spell.forceOfNature)
    	end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            if self.rotations[bb.selectedProfile] ~= nil then
                self.rotations[bb.selectedProfile].toggles()
            else
                return
            end
        end

    ---------------
    --- OPTIONS ---
    ---------------
        
        -- Creates the option/profile window
        function self.createOptions()
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
            local profileTable = profileTable
            if self.rotations[bb.selectedProfile] ~= nil then 
                profileTable = self.rotations[bb.selectedProfile].options()
            else
                return
            end

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            bb.ui:createPagesDropdown(bb.ui.window.profile, optionTable)
            bb:checkProfileWindowStatus()
        end

    --------------
    --- SPELLS ---
    --------------

        function self.getCastable()

            -- self.castable.maim              = self.castMaim("target",true)
        end

 

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        --Target HP
        function thp(unit)
            return getHP(unit)
        end

        --Target Time to Die
        function ttd(unit)
            return getTimeToDie(unit)
        end

        --Target Distance
        function tarDist(unit)
            return getDistance(unit)
        end


        function useCDs()
            local cooldown = self.mode.cooldown
            if (cooldown == 1 and isBoss()) or cooldown == 2 then
                return true
            else
                return false
            end
        end

        function useAoE()
            local rotation = self.mode.rotation
            if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
                return true
            else
                return false
            end
        end

        function useDefensive()
            if self.mode.defensive == 1 then
                return true
            else
                return false
            end
        end

        function useInterrupts()
            if self.mode.interrupt == 1 then
                return true
            else
                return false
            end
        end

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

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cGuardian
end-- select Druid