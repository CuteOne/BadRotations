--- Feral Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
if select(2, UnitClass("player")) == "DRUID" then
    rakeApplied = {}
    ripApplied = {}
	cFeral = {}
    cFeral.rotations = {}

	-- Creates Feral Druid
	function cFeral:new()
		local self = cDruid:new("Feral")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFeral.rotations
		
		-----------------
        --- VARIABLES ---
        -----------------
        self.bleed              = {}        -- Bleed/Moonfire Tracking
        self.bleed.rake         = {}        -- Rake Bleed
        self.bleed.rip          = {}        -- Rip Bleed
        self.bleed.thrash       = {}        -- Thrash Bleed
        self.bleed.moonfire     = {}        -- Moonfire Debuff
        self.trinket            = {}        -- Trinket Procs
        self.enemies            = {
            yards5,
            yards8,
            yards13,
            yards20,
            yards40,
        }
		self.feralSpell         = {

			-- Ability - Crowd Control
			-- maim 								= 22570,

			-- Ability - Defensive
			-- heartOfTheWild 						= 108292,

			-- Ability - Forms
			-- clawsOfShirvallahForm 				= 171745,

			-- Ability - Offensive
			-- forceOfNature 						= 102703,
			-- incarnationKingOfTheJungle 			= 102543,
			-- rake 								= 1822,
			-- rip 								= 1079,
			-- savageRoar 							= 52610,
			-- swipe 								= 106785,
			-- tigersFury 							= 5217,
			-- thrash 								= 106830,

			-- Ability - Utility
			-- stampedingRoar 						= 77764,

			-- Buff - Defensive
			-- heartOfTheWildBuff 					= 108292,
			-- predatorySwiftnessBuff 				= 69369,

			-- Buff - Forms
			-- clawsOfShirvallahFormBuff 			= 171745,

			-- Buff - Offensive
			-- bloodtalonsBuff						= 145152,
			-- incarnationKingOfTheJungleBuff 		= 102543,
			-- savageRoarGlyphBuff 				= 174544,
			-- savageRoarNoGlyphBuff				= 52610,
			-- tigersFuryBuff 						= 5217,

			-- Buff - Utility
			-- stampedingRoarBuff 					= 77764,

			-- Debuff - Offensive
			-- rakeDebuff 							= 155722,
   --          rakeStunDebuff                      = 163505,
			-- ripDebuff 							= 1079,
			-- thrashDebuff 						= 106830,

			-- Glyphs
			-- catFormGlyph 						= 47180,
			-- ferociousBiteGlyph 					= 67598,
			-- maimGlyph 							= 159450,
			-- ninthLifeGlyph 						= 159444,
			-- rakeGlyph 							= 54821,
			-- savageRoarGlyph 					= 127540,
			-- savageryGlyph 						= 171752,

			-- Perks
			-- enhancedBerserk 					= 157269,
			-- enhancedProwl 						= 157274,
			-- enhancedRejuvenation 				= 157280,
			-- improvedRake 						= 157276,

			-- Talents
			-- bloodtalonsTalent 					= 155672,
			-- clawsOfShirvallahTalent 			= 171746,
			-- dreamOfCenariusTalent 				= 158497,
			-- forceOfNatureTalent 				= 102703,
			-- heartOfTheWildTalent 				= 108292,
			-- incarnationKingOfTheJungleTalet 	= 102543,
			-- lunarInspirationTalent				= 155580,
			-- soulOfTheForest 					= 158476,

		}
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.druidSpell, self.feralSpell)
		
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
            -- self.feral_bleed_table()
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
            --         local rakeRemain = getDebuffRemain(thisUnit,self.spell.rakeDebuff,"player")
            --         local ripRemain = getDebuffRemain(thisUnit,self.spell.ripDebuff,"player")
            --         local thrashRemain = getDebuffRemain(thisUnit,self.spell.thrashDebuff,"player")
            --         local moonfireRemain = getDebuffRemain(thisUnit,self.spell.moonfireDebuff,"player")
            --         -- Get Bleed Applied
            --         if rakeApplied[thisUnit]~=nil then 
            --             rakeDot = rakeApplied[thisUnit] --rake
            --         else
            --             rakeDot = 1
            --         end
            --         if ripApplied[thisUnit]~=nil then 
            --             ripDot = ripApplied[thisUnit] --rake
            --         else
            --             ripDot = 2.5
            --         end
            --         -- Get Bleed Percent
            --         local rakePercent = floor(rakeCalc/rakeDot*100+0.5)
            --         local ripPercent = floor(ripCalc/ripDot*100+0.5)
            --         -- Add Bleed Units
            --         if distance<5 then
            --             tinsert(self.bleed.rake,{unit = thisUnit, remain = rakeRemain, calc = rakeCalc, applied = rakeDot, percent = rakePercent})
            --             tinsert(self.bleed.rip,{unit = thisUnit, remain = ripRemain, calc = ripCalc, applied = ripDot, percent = ripPercent})
            --         end
            --         if distance<8 then
            --             tinsert(self.bleed.thrash,{unit = thisUnit, remain = thrashRemain})
            --         end
            --         if distance<40 then
            --             tinsert(self.bleed.moonfire,{unit = thisUnit, remain = moonfireRemain})
            --         end
            --     end
            -- end
        end
        
   	-------------
    --- BUFFS ---
    -------------

        function self.getBuffs()
        	local UnitBuffID = UnitBuffID

        	-- self.buff.heartOfTheWild               = UnitBuffID("player",self.spell.heartOfTheWildBuff)~=nil or false
        	-- self.buff.predatorySwiftness           = UnitBuffID("player",self.spell.predatorySwiftnessBuff)~=nil or false
        	-- self.buff.clawsOfShirvallahForm        = UnitBuffID("player",self.spell.clawsOfShirvallahFormBuff)~=nil or false
        	-- self.buff.incarnationKingOfTheJungle   = UnitBuffID("player",self.spell.incarnationKingOfTheJungleBuff)~=nil or false
        	-- self.buff.bloodtalons                  = UnitBuffID("player",self.spell.bloodtalonsBuff)~=nil or false
        	-- self.buff.savageRoar                   = (UnitBuffID("player",self.spell.savageRoarGlyphBuff) or UnitBuffID(player,self.spell.savageRoarNoGlyphBuff))~=nil or false
        	-- self.buff.tigersFury                   = UnitBuffID("player",self.spell.tigersFuryBuff)~=nil or false
        	-- self.buff.stampedingRoar               = UnitBuffID("player",self.spell.stampedingRoarBuff)~=nil or false
        end

        function self.getBuffsDuration()
        	local getBuffDuration = getBuffDuration

        	-- self.buff.duration.heartOfTheWild              = getBuffDuration("player",self.spell.heartOfTheWildBuff) or 0
        	-- self.buff.duration.predatorySwiftness          = getBuffDuration("player",self.spell.predatorySwiftnessBuff) or 0
        	-- self.buff.duration.incarnationKingOfTheJungle  = getBuffDuration("player",self.spell.incarnationKingOfTheJungleBuff) or 0
        	-- self.buff.duration.bloodtalons                 = getBuffDuration("player",self.spell.bloodtalonsBuff) or 0
        	-- self.buff.duration.savageRoar                  = getBuffDuration("player",self.spell.savageRoarGlyphBuff) or getBuffDuration(player,self.spell.savageRoarNoGlyphBuff) or 0
        	-- self.buff.duration.tigersFury                  = getBuffDuration("player",self.spell.tigersFuryBuff) or 0
        	-- self.buff.duration.stampedingRoar              = getBuffDuration("player",self.spell.stampedingRoarBuff) or 0
        end

        function self.getBuffsRemain()
        	local getBuffRemain = getBuffRemain

        	-- self.buff.remain.heartOfTheWild				= getBuffRemain("player",self.spell.heartOfTheWildBuff) or 0
        	-- self.buff.remain.predatorySwiftness 		= getBuffRemain("player",self.spell.predatorySwiftnessBuff) or 0
        	-- self.buff.remain.incarnationKingOfTheJungle = getBuffRemain("player",self.spell.incarnationKingOfTheJungleBuff) or 0
        	-- self.buff.remain.bloodtalons				= getBuffRemain("player",self.spell.bloodtalonsBuff) or 0
        	-- self.buff.remain.savageRoar					= getBuffRemain("player",self.spell.savageRoarGlyphBuff) or getBuffRemain(player,self.spell.savageRoarNoGlyphBuff) or 0
        	-- self.buff.remain.tigersFury					= getBuffRemain("player",self.spell.tigersFuryBuff) or 0
        	-- self.buff.remain.stampedingRoar 			= getBuffRemain("player",self.spell.stampedingRoarBuff) or 0
        end

        function self.getTrinketProc()
            local UnitBuffID = UnitBuffID

            -- self.trinket.WitherbarksBranch              = UnitBuffID("player",165822)~=nil or false --Haste Proc
            -- self.trinket.TurbulentVialOfToxin           = UnitBuffID("player",176883)~=nil or false --Mastery Proc
            -- self.trinket.KihrasAdrenalineInjector       = UnitBuffID("player",165485)~=nil or false --Mastery Proc
            -- self.trinket.GorashansLodestoneSpike        = UnitBuffID("player",165542)~=nil or false --Multi-Strike Proc
            -- self.trinket.DraenicPhilosophersStone       = UnitBuffID("player",157136)~=nil or false --Agility Proc
            -- self.trinket.BlackheartEnforcersMedallion   = UnitBuffID("player",176984)~=nil or false --Multi-Strike Proc
            -- self.trinket.MunificentEmblemOfTerror       = UnitBuffID("player",165830)~=nil or false --Critical Strike Proc
            -- self.trinket.PrimalCombatantsInsignia       = UnitBuffID("player",182059)~=nil or false --Agility Proc
            -- self.trinket.SkullOfWar                     = UnitBuffID("player",162915)~=nil or false --Critical Strike Proc
            -- self.trinket.ScalesOfDoom                   = UnitBuffID("player",177038)~=nil or false --Multi-Strike Proc
            -- self.trinket.LuckyDoubleSidedCoin           = UnitBuffID("player",177597)~=nil or false --Agility Proc
            -- self.trinket.MeatyDragonspineTrophy         = UnitBuffID("player",177035)~=nil or false --Haste Proc
            -- self.trinket.PrimalGladiatorsInsignia       = UnitBuffID("player",182068)~=nil or false --Agility Proc
            -- self.trinket.BeatingHeartOfTheMountain      = UnitBuffID("player",176878)~=nil or false --Multi-Strike Proc
            -- self.trinket.HummingBlackironTrigger        = UnitBuffID("player",177067)~=nil or false --Critical Stike Proc
            -- self.trinket.MaliciousCenser                = UnitBuffID("player",183926)~=nil or false --Agility Proc
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

        	-- self.debuff.rake 	= UnitDebuffID(self.units.dyn5,self.spell.rakeDebuff,"player")~=nil or false
         --    self.debuff.rakeStun= UnitDebuffID(self.units.dyn5,self.spell.rakeStunDebuff,"player")~=nil or false
        	-- self.debuff.rip 	= UnitDebuffID(self.units.dyn5,self.spell.ripDebuff,"player")~=nil or false
        	-- self.debuff.thrash 	= UnitDebuffID(self.units.dyn8AoE,self.spell.thrashDebuff,"player")~=nil or false
		end

		function self.getDebuffsDuration()
			local getDebuffDuration = getDebuffDuration

			-- self.debuff.duration.rake    = getDebuffDuration(self.units.dyn5,self.spell.rakeDebuff,"player") or 0
   --          self.debuff.duration.rakeStun= getDebuffDuration(self.units.dyn5,self.spell.rakeStunDebuff,"player") or 0
			-- self.debuff.duration.rip     = getDebuffDuration(self.units.dyn5,self.spell.ripDebuff,"player") or 0
			-- self.debuff.duration.thrash  = getDebuffDuration(self.units.dyn8AoE,self.spell.thrashDebuff,"player") or 0
		end

		function self.getDebuffsRemain()
			local getDebuffRemain = getDebuffRemain

			-- self.debuff.remain.rake      = getDebuffRemain(self.units.dyn5,self.spell.rakeDebuff,"player") or 0
   --          self.debuff.remain.rakeStun  = getDebuffRemain(self.units.dyn5,self.spell.rakeStunDebuff,"player") or 0
			-- self.debuff.remain.rip       = getDebuffRemain(self.units.dyn5,self.spell.ripDebuff,"player") or 0
			-- self.debuff.remain.thrash    = getDebuffRemain(self.units.dyn8AoE,self.spell.thrashDebuff,"player") or 0
		end

    ---------------
    --- CHARGES ---
    ---------------

		function self.getCharge()
			local getCharges = getCharges
			local getBuffStacks = getBuffStacks

			-- self.charges.forceOfNature 	= getCharges(self.spell.forceOfNature)
			-- self.charges.bloodtalons 	= getBuffStacks("player",self.spell.bloodtalonsBuff,"player")
		end
        
    -----------------
    --- COOLDOWNS ---
    -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            -- self.cd.maim 							= getSpellCD(self.spell.maim)
            -- self.cd.heartOfTheWild 					= getSpellCD(self.spell.heartOfTheWild)
            -- self.cd.incarnationKingOfTheJungle  	= getSpellCD(self.spell.incarnationKingOfTheJungle)
            -- self.cd.tigersFury 						= getSpellCD(self.spell.tigersFury)
            -- self.cd.stampedingRoar 					= getSpellCD(self.spell.stampedingRoar)
        end

    --------------
    --- GLYPHS ---
    --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            -- self.glyph.catForm   		= hasGlyph(self.spell.catFormGlyph)
            -- self.glyph.ferociousBite 	= hasGlyph(self.spell.ferociousBiteGlyph)
            -- self.glyph.maim 			= hasGlyph(self.spell.maimGlyph)
            -- self.glyph.ninthLife 		= hasGlyph(self.spell.ninthLifeGlyph)
            -- self.glyph.rake 			= hasGlyph(self.spell.rakeGlyph)
            -- self.glyph.savageRoar 		= hasGlyph(self.spell.savageRoarGlyph)
            -- self.glyph.savagery 		= hasGlyph(self.spell.savageryGlyph)
        end

    ---------------
    --- TALENTS ---
    ---------------

        function self.getTalents()
            local getTalent = getTalent

            -- self.talent.soulOfTheForest 			= getTalent(4.1)
            -- self.talent.incarnationKingOfTheJungle 	= getTalent(4,2)
            -- self.talent.forceOfNature 				= getTalent(4,3)
            -- self.talent.heartOfTheWild 				= getTalent(6,1)
            -- self.talent.dreamOfCenarius 			= getTalent(6,2)
            -- self.talent.lunarInspiration 			= getTalent(7,1)
            -- self.talent.bloodtalons 				= getTalent(7,2)
            -- self.talent.clawsOfShirvallah 			= getTalent(7,3)
        end

    -------------
    --- PERKS ---
    -------------

        function self.getPerks()
        	local isKnown = isKnown

        	-- self.perk.enhancedBerserk 		= isKnown(self.spell.enhancedBerserk)
        	-- self.perk.enhancedProwl 		= isKnown(self.spell.enhancedProwl)
        	-- self.perk.enhancedRejuvenation 	= isKnown(self.spell.enhancedRejuvenation)
        	-- self.perk.improvedRake 			= isKnown(self.spell.improvedRake)
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
            local BadBoy_data   = BadBoy_data

            self.mode.rotation  = BadBoy_data["Rotation"]
            self.mode.cooldown  = BadBoy_data["Cooldown"]
            self.mode.defensive = BadBoy_data["Defensive"]
            self.mode.interrupt = BadBoy_data["Interrupt"]
            self.mode.cleave    = BadBoy_data["Cleave"]
            self.mode.prowl     = BadBoy_data["Prowl"]
        end

        -- Create the toggle defined within rotation files
        function self.createToggles()
            GarbageButtons()
            self.rotations[bb.selectedProfile].toggles()
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
            local profileTable = self.rotations[bb.selectedProfile].options()

            -- Only add profile pages if they are found
            if profileTable then
                insertTableIntoTable(optionTable, profileTable)
            end

            -- Create pages dropdown
            bb.ui:createPagesDropdown(bb.ui.window.profile, optionTable)
            bb:checkProfileWindowStatus()
        end

    ------------------------------
    --- SPELLS - CROWD CONTROL ---
    ------------------------------

     --    -- Maim - Set target via thisUnit variable
    	-- function self.castMaim(thisUnit)
    	-- 	if self.level>=82 and self.power>35 and self.cd.maim==0 and self.comboPoints>0 and self.buff.catForm and hasThreat(thisUnit) and getDistance(thisUnit)<5 then
    	-- 		if castSpell(thisUnit,self.spell.maim,false,false,false) then return end
    	-- 	end
    	-- end

    --------------------------
    --- SPELLS - DEFENSIVE ---
    --------------------------

        -- -- Heart of the Wild
        -- function self.castHeartOfTheWild()
        --     if self.talent.heartOfTheWild and self.cd.heartOfTheWild==0 then
        -- 	   if castSpell("player",self.spell.heartOfTheWild,false,false,false) then return end
        --     end
        -- end

    ----------------------
    --- SPELLS - FORMS ---
    ----------------------

        -- -- Claws of Shirvallah
        -- function self.castClawsOfShirvallah()
        --     if self.talent.clawsOfShirvallah then
        -- 	   if castSpell("player",self.spell.clawsOfShirvallah,false,false,false) then return end
        --     end
        -- end

    --------------------------
    --- SPELLS - OFFENSIVE ---
    --------------------------

        -- -- Force of Nature
        -- function self.castForceOfNature(thisUnit)
        -- 	if self.talent.forceOfNature and self.charges.forceOfNature > 0 and hasThreat(thisUnit) and getDistance(thisUnit)<40 then
        -- 		if castSpell(thisUnit,self.spell.forceOfNature,false,false,false) then return end
        -- 	end
        -- end
        -- -- Incarnation: King of the Jungle
        -- function self.castIncarnationKingOfTheJungle()
        -- 	if self.talent.incarnationKingOfTheJungle and self.cd.incarnationKingOfTheJungle == 0 then
        -- 		if castSpell("player",self.spell.incarnationKingOfTheJungle,false,false,false) then return end
        -- 	end
        -- end
        -- -- Rake - Set target via thisUnit variable
        -- function self.castRake(thisUnit)
        -- 	if self.level>=6 and self.power > 35 and self.buff.catForm and (getDebuffDuration(thisUnit,self.spell.rakeDebuff,"player")>4 or getDebuffDuration(thisUnit,self.spell.rakeDebuff,"player")==0) and getDistance(thisUnit)<5 then
        -- 		if castSpell(thisUnit,self.spell.rake,false,false,false) then return end
        -- 	end
        -- end
        -- -- Rip - Set target via thisUnit variable
        -- function self.castRip(thisUnit)
        -- 	if self.level>=20 and self.power > 30 and self.buff.catForm and self.comboPoints>0 and getDistance(thisUnit)<5 then
        -- 		if castSpell(thisUnit,self.spell.rip,false,false,false) then return end
        -- 	end
        -- end
        -- -- Savage Roar
        -- function self.castSavageRoar()
        -- 	if self.level>=18 and self.power > 25 and (self.comboPoints>0 or self.glyph.savageRoar) and not self.glyph.savagery then
        -- 		if castSpell("player",self.spell.savageRoar,false,false,false) then return end
        -- 	end
        -- end
        -- -- Stampeding Roar
        -- function self.castStampedingRoar()
        --     if self.level>=84 and self.cd.stampedingRoar==0 then
        --         if castSpell("player",self.spell.stampedingRoar,false,false,false) then return end
        --     end
        -- end
        -- -- Swipe
        -- function self.castSwipe(thisUnit)
        -- 	if self.level>=22 and self.power > 45 and self.buff.catForm and getDistance(thisUnit)<8 then
        -- 		if castSpell(thisUnit,self.spell.swipe,false,false,false) then return end
        -- 	end
        -- end
        -- -- Thrash - Set target via thisUnit variable
        -- function self.castThrash(thisUnit)
        -- 	if self.level>=28 and self.power>50 and self.buff.catForm and hasThreat(thisUnit) and getDistance(thisUnit)<8 and BadBoy_data['Cleave']==1 and BadBoy_data['AoE'] < 3 then
        -- 		if castSpell(thisUnit,self.spell.thrash,false,false,false) then return end
        -- 	end
        -- end
        -- -- Tiger's Fury
        -- function self.castTigersFury()
        --     if self.level>=10 and self.cd.tigersFury==0 and self.powerDeficit>60 then
        --         if castSpell("player",self.spell.tigersFury,false,false,false) then return end
        --     end
        -- end

    ------------------------
    --- CUSTOM FUNCTIONS ---
    ------------------------
        -- --Target HP
        -- function thp(unit)
        --     return getHP(unit)
        -- end

        -- --Target Time to Die
        -- function ttd(unit)
        --     return getTimeToDie(unit)
        -- end

        -- --Target Distance
        -- function tarDist(unit)
        --     return getDistance(unit)
        -- end

        -- -- Calculate Ferocious Bite Damage
        -- function getFbDamage(cp)
        --     local cp = cp
        --     if cp == nil then cp = bb.player.comboPoints end 
        --     fbD = (UnitAttackPower("player")*4)*(cp/5)
        --     if bb.player.power>50 and bb.player.inCombat then
        --         return fbD*2
        --     else
        --         return fbD
        --     end
        -- end

        -- function useCDs()
        --     local cooldown = self.mode.cooldown
        --     if (cooldown == 1 and isBoss()) or cooldown == 2 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function useAoE()
        --     local rotation = self.mode.rotation
        --     if (rotation == 1 and #getEnemies("player",8) >= 3) or rotation == 2 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function useDefensive()
        --     if self.mode.defensive == 1 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function useInterrupts()
        --     if self.mode.interrupt == 1 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function useCleave()
        --     if self.mode.cleave==1 and self.mode.rotation < 3 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function useProwl()
        --     if self.mode.prowl==1 then
        --         return true
        --     else
        --         return false
        --     end
        -- end

        -- function outOfWater()
        --     if swimTime == nil then swimTime = 0 end
        --     if outTime == nil then outTime = 0 end
        --     if IsSwimming() then
        --         swimTime = GetTime()
        --         outTime = 0
        --     end
        --     if not IsSwimming() then
        --         outTime = swimTime
        --         swimTime = 0
        --     end
        --     if outTime ~= 0 and swimTime == 0 then
        --         return true
        --     end
        --     if outTime ~= 0 and IsFlying() then
        --         outTime = 0
        --         return false
        --     end
        -- end

    -----------------------------
    --- CALL CREATE FUNCTIONS ---
    -----------------------------

        -- Return
        return self
    end-- cFeral
end-- select Druid