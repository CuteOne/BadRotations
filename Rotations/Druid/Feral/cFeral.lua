--- Feral Class
-- Inherit from: ../cCharacter.lua and ../cDruid.lua
cFeral = {}
cFeral.rotations = {}

-- Creates Feral Druid
function cFeral:new()
    if GetSpecializationInfo(GetSpecialization()) == 103 then
		local self = cDruid:new("Feral")

		local player = "player" -- if someone forgets ""

        -- Mandatory !
        self.rotations = cFeral.rotations
        
    -----------------
    --- VARIABLES ---
    -----------------

        self.spell.spec                 = {}
        self.spell.spec.abilities       = {
            ashamanesFrenzy             = 210722,
            berserk                     = 106951,
            brutalSlash                 = 202028,
            elunesGuidance              = 202060,
            ferociousBite               = 22568,
            incarnationKingOfTheJungle  = 102543,
            maim                        = 22570,
            moonfireFeral               = 155625,
            rake                        = 1822,
            removeCorruption            = 2782,
            renewal                     = 108238,
            rip                         = 1079,
            savageRoar                  = 52610,
            shred                       = 5221,
            skullBash                   = 106839,
            stampedingRoar              = 106898,
            survivalInstincts           = 61336,
            swipe                       = 106785, --213764,
            thrash                      = 106830, --106832,
            tigersFury                  = 5217,
        }
        self.spell.spec.artifacts       = {
            ashamanesBite               = 210702,
            ashamanesEnergy             = 210579,
            ashamanesFrenzy             = 210722,
            attunedToNature             = 210590,
            fangsOfTheFirst             = 214911,
            feralInstinct               = 210631,
            feralPower                  = 210571,
            hardenedRoots               = 210638,
            honedInstinct               = 210557,
            openWounds                  = 210666,
            powerfulBite                = 210575,
            protectionOfAshamane        = 210650,
            razorFangs                  = 210570,
            scentOfBlood                = 210663,
            shadowThrash                = 210676,
            sharpenedClaws              = 210637,
            shredderFangs               = 214736,
            tearTheFlesh                = 210593,
        }
        self.spell.spec.buffs           = {
            berserk                     = 106951,
            bloodtalons                 = 145152,
            clearcasting                = 135700,
            incarnationKingOfTheJungle  = 102543,
            predatorySwiftness          = 69369,
            savageRoar                  = 52610,
            stampedingRoar              = 77764,
            survivalInstincts           = 61336,
            tigersFury                  = 5217,
        }
        self.spell.spec.debuffs         = {
            ashamanesFrenzy             = 210723,
            ashamanesRip                = 210705,
            moonfireFeral               = 155625,
            rake                        = 155722,
            rip                         = 1079,
            thrash                      = 106832,
        }
        self.spell.spec.glyphs          = {

        }
        self.spell.spec.talents         = {
            balanceAffinity             = 197488,
            bloodScent                  = 202022,
            bloodtalons                 = 155672,
            brutalSlash                 = 202028,
            elunesGuidance              = 202060,
            guardianAffinity            = 217615,
            incarnationKingOfTheJungle  = 102543,
            jaggedWounds                = 202032,
            lunarInspiration            = 155580,
            momentOfClarity             = 155577,
            predator                    = 202021,
            renewal                     = 108238,
            restorationAffinity         = 197492,
            sabertooth                  = 202031,
            savageRoar                  = 52610,
            soulOfTheForest             = 158476,
        }
        -- Merge all spell ability tables into self.spell
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.spell.class.abilities, self.spell.spec.abilities)
		
	------------------
    --- OOC UPDATE ---
    ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()
        end

    --------------
    --- UPDATE ---
    --------------

        function self.update()

            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end
            cFileBuild("spec",self)
            self.getToggleModes()

            -- Start selected rotation
            self:startRotation()
        end

    ---------------
    --- TOGGLES ---
    ---------------

        function self.getToggleModes()

            self.mode.rotation  = bb.data["Rotation"]
            self.mode.cooldown  = bb.data["Cooldown"]
            self.mode.defensive = bb.data["Defensive"]
            self.mode.interrupt = bb.data["Interrupt"]
            self.mode.cleave    = bb.data["Cleave"]
            self.mode.prowl     = bb.data["Prowl"]
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

        -- Calculate Ferocious Bite Damage
        function getFbDamage(cp)
            local weaponDPS = (select(2,UnitDamage("player")) - select(1,UnitDamage("player"))) / 2
            local weaponDMG = (weaponDPS + UnitAttackPower("player") / 3.5) 
            local cp = cp
            if cp == nil then cp = bb.player.comboPoints end 
            fbD = 0.749 * cp * UnitAttackPower("player") * (1 + (bb.player.power - 25) / 25)
            if bb.player.inCombat then
                return fbD
            else
                return 0
            end
        end

        function useCleave()
            if self.mode.cleave==1 and self.mode.rotation < 3 then
                return true
            else
                return false
            end
        end

        function useProwl()
            if self.mode.prowl==1 then
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
    end-- cFeral
end-- select Druid