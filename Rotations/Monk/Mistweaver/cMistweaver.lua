if select(2,UnitClass("player")) == "MONK" then

  cMistweaver = {}

  -- Creates Mistweaver Monk
    function cMistweaver:new()
        local self = cMonk:new("Mistweaver")

        local player = "player" -- if someone forgets ""
        local isSoothing        = UnitChannelInfo("player") == GetSpellInfo(_SoothingMist) or nil;

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
            yards40,
        }
        self.mistweaverSpell = {
            
            -- Ability - Healing
            chiExplosion                    = 152174,
            detonateChi                     = 115460,
            envelopingMist                  = 124682,
            legacyoftheEmperor              = 115921,
            lifeCocoon                      = 116849,
            manaTea                         = 123761,
            mistExpelHarm                   = 147489,
            renewingMist                    = 115151,
            revival                         = 115310,
            soothingMist                    = 115175,
            thunderFocusTea                 = 116680,
            uplift                          = 116670,

            -- Buff - Offensive
            legacyoftheEmperorBuff          = 115921,
            renewingMistBuff                = 119611,
            craneZealBuff                   = 127722,

            -- Buff - Stacks
            manaTeaStacks                   = 115867,
            vitalMistsStacks                = 118647,

            -- Glyphs
            manaTeaGlyph                    = 123763,
            targetedExplusionGlyph          = 146950,        

            -- Perks

            -- Talent
            chiExplosionTalent              = 152174,
            renewingMistTalent              = 173841,
            
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.monkSpell, self.mistweaverSpell)


        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

            self.getGlyphs()
            self.getTalents()
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
            self.getCharges()
            self.getEnemies()
            self.getRotation()
            self.getClassCooldowns()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc


            -- Start selected rotation
            self:startRotation()
        end

        -------------
        --- BUFFS ---
        -------------

        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.craneZeal     = UnitBuffID("player",self.spell.craneZealBuff)~=nil or false
            self.buff.renewingMist  = UnitBuffID("player",self.spell.renewingMistBuff)~=nil or false
            self.buff.soothingMist  = UnitChannelInfo("player") == GetSpellInfo(self.spell.soothingMist) or nil;
        end

        function self.getClassCooldowns()
        local getSpellCD = getSpellCD

        self.cd.chiBrew         = getSpellCD(self.spell.chiBrew)
        self.cd.manaTea         = getSpellCD(self.spell.manaTea)
    end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

            self.glyph.manaTea = hasGlyph(self.spell.manaTeaGlyph)
            self.glyph.mistExpelHarm = hasGlyph(self.spell.targetedExplusionGlyph)
        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

            self.talent.chiExplosion = getTalent(7,2)
            self.talent.renewingMist = getTalent(7,3)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = #getEnemies("player", 5)
            self.enemies.yards8     = #getEnemies("player", 8)
            self.enemies.yards12    = #getEnemies("player", 12)
            self.enemies.yards40    = #getEnemies("player", 40)
        end


        ---------------
        --- CHARGES ---
        ---------------

        function self.getCharges()
          local getCharges = getCharges
          local getBuffStacks = getBuffStacks
          self.charges.manaTea = getBuffStacks("player",self.spell.manaTeaStacks,"player") or 0
          self.charges.vitalMists = getBuffStacks("player",self.spell.vitalMistsStacks,"player") or 0
          self.charges.renewingMist = getCharges(self.spell.renewingMist) or 0
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:MistweaverKuu()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end
    
        -------------
        -- OPTIONS --
        -------------

        function self.createOptions()
            bb.profile_window = createNewProfileWindow("Mistweaver")
            local section

            -- Create Base and Class options
            self.createClassOptions()

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Buffs")
            -- Stance
            createNewDropdown(section,  "Stance", { "|cff00FF55Serpent", "|cff0077FFCrane"},  1,  "Choose Stance to use.")
            -- Legacy of the Emperor
            createNewCheckbox(section,"Legacy of the Emperor")
            --Jade Serpent Statue
            createNewCheckbox(section,"Jade Serpent Statue (Left Shift)")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Cooldowns")
            -- Revival
            createNewSpinner(section, "Revival", 20, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFRevival")
            -- Revival People
            createNewSpinner(section,  "Revival People",  5,  0 , 25 ,  1,  "How many people need to be at the % to activate.")
            -- Life Coccon
            createNewSpinner(section, "Life Cocoon", 15, 0, 100, 5, "Under what |cffFF0000%HP to use |cffFFFFFFLife Cocoon")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Healing")
            -- Nature's Cure
            createNewDropdown(section, "Detox", { "|cffFFDD11MMouse", "|cffFFDD11MRaid", "|cff00FF00AMouse", "|cff00FF00ARaid"},  1,  "MMouse:|cffFFFFFFMouse / Match List. \nMRaid:|cffFFFFFFRaid / Match List. \nAMouse:|cffFFFFFFMouse / All. \nARaid:|cffFFFFFFRaid / All.")
            -- Mana Tea
            createNewSpinner(section, "Mana Tea", 90, 0 , 100, 5,  "Under what |cffFF0000%MP to use |cffFFFFFFMana Tea.")
            -- Chi Wave
            createNewSpinner(section,  "Chi Wave",  55,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFChi Wave.")
            -- Enveloping Mist
            createNewSpinner(section,  "Enveloping Mist",  45,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFEnveloping Mist.")
            -- Renewing Mist
            createNewCheckbox(section,  "Renewing Mist")
            -- Soothing Mist
            createNewSpinner(section,  "Soothing Mist",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSoothing Mist.")
            -- Surging Mist
            createNewSpinner(section,  "Surging Mist",  65,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSurging Mist.")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "AoE Healing")
            -- Uplift
            createNewSpinner(section,  "Uplift",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFUplift.")
            -- Uplift People
            createNewSpinner(section,  "Uplift People",  5,  0 , 25 ,  5,  "How many people need to be at the % to activate.")
            -- Spinning Crane Kick/RJW
            createNewSpinner(section,  "Spinning Crane Kick",  75,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFSCK.")
            checkSectionState(section)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Defensive")
            -- Expel Harm
            createNewSpinner(section,  "Expel Harm",  80,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFExpel Harm")
            -- Fortifying Brew
            createNewSpinner(section,  "Fortifying Brew",  30,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFFortifying Brew")
            -- Healthstone
            createNewSpinner(section,  "Healthstone",  20,  0,  100  ,  5,  "Under what |cffFF0000%HP to use |cffFFFFFFHealthstone")
            checkSectionState(section)
    
            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Toggles")
            -- Pause Toggle
            createNewDropdown(section, "Pause Toggle", bb.dropOptions.Toggle2,  3)

            -- Wrapper -----------------------------------------
            section = createNewSection(bb.profile_window, "Utilities")
            -- Spear Hand Strike
            createNewSpinner(section,  "Spear Hand Strike",  60 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFSpear Hand Strike.")
            -- Paralysis
            createNewSpinner(section,  "Paralysis",  30 ,  0,  100  ,  5,  "Over what % of cast we want to \n|cffFFFFFFParalysis.")
            checkSectionState(section)

            --[[ Rotation Dropdown ]]--
            createNewRotationDropdown(bb.profile_window.parent, {"Kuukuu"})
            bb:checkProfileWindowStatus()
        end

        --------------
        --- SPELLS ---
        --------------
        -- Change Stance
        function self.castChangeStance()
          local myStance = GetShapeshiftForm()
          if getValue("Stance") == 1 and myStance ~= 1 then
            if castSpell("player",115070,true) then return; end
          elseif getValue("Stance") == 2 and myStance ~= 2 then
            if castSpell("player",103985,true) then return; end
          end
        end
        -- Chi Brew
        function self.castChiBrew()
            if self.charges.chiBrew >= 1 then
                if castSpell("player", self.spell.chiBrew, false) then return end
            end
        end
        -- Chi Explosion
        function self.castChiExplosion()
        end
        --Chi Wave
        function self.castHealingChiWave(unit)
          if self.talent.chiWave and self.cd.chiWave == 0 then
            if castSpell(unit, self.spell.chiWave, true) then return end
          end
        end

        -- Detonate Chi
        function self.castDetonateChi()
        end
        -- Enveloping Mist
        function self.castEnvelopingMist(unit)
          if self.chi.count >= 3 then
              if castSpell(unit, self.spell.envelopingMist, true) then 
                return; 
              end
          end
        end
        --Expel Harm Heal
        function self.castHealingExpelHarm(unit)
          if self.glyph.mistExpelHarm then
            if castSpell(unit,self.spell.mistExpelHarm, true) then return; end
          end
        end
        -- Legacy of the Emperor
        function self.castLegacyoftheEmperor()
            if self.instance=="none" and not isBuffed("player",{115921,20217,1126,90363}) then
                if castSpell("player",self.spell.legacyoftheEmperor,false,false,false) then return end
            else
                local totalCount = GetNumGroupMembers()
                local currentCount = currentCount or 0
                local needsBuff = needsBuff or 0
                for i=1,#nNova do
                    local thisUnit = nNova[i].unit
                    local distance = getDistance(thisUnit)
                    local dead = UnitIsDeadOrGhost(thisUnit)
                    if distance<30 then
                        currentCount = currentCount+1
                    end
                    if not isBuffed(thisUnit,{115921,20217,1126,90363}) and not dead then
                        needsBuff = needsBuff+1
                    end
                end
                if currentCount>=totalCount and needsBuff>0 then
                    if castSpell("player",self.spell.legacyoftheEmperor,false,false,false) then return end
                end
            end
        end
        --Life Cocoon
        function self.castLifeCocoon(unit)
          if castSpell(unit, self.spell.lifeCocoon,true) then return; end
        end
        -- Mana Tea
        function self.castManaTea()
            if self.glyph.manaTea and self.cd.manaTea == 0 then
              if castSpell("player",self.spell.manaTea,false) then return; end
            end
        end
        -- Renewing Mist
        function self.castRenewingMist(unit)
            if self.talent.renewingMist and self.charges.renewingMist > 0 and getMana("player") > 4 then
              if castSpell("player",self.spell.thunderFocusTea,false) then end
              if castSpell(unit,self.spell.renewingMist,true) then return; end
            elseif not self.talent.renewingMist then
              if castSpell("player",self.spell.thunderFocusTea,false) then end
              if castSpell(unit,self.spell.renewingMist,true) then return; end
            end
        end
        -- Revival
        function self.castRevival()
          if castSpell("player",self.spell.revival,false) then return; end
        end
        -- Soothing Mist
        function self.castSoothingMist(unit)
          if getMana("player") >= 12 then
            if not self.buff.soothingMist then
              if castSpell(unit,self.spell.soothingMist,true) then return end
            end
          end
        end
        -- Spinning Crane Kick/RJW
        function self.castHealingSpinningCraneKick()
          if self.talent.rushingJadeWind then
            if castSpell("player",self.spell.rushingJadeWind,false) then return end
          else
            if castSpell("player",self.spell.spinningCraneKick,false) then return end     
          end
        end
        -- Surging Mist
        function self.castHealingSurgingMist(unit)
           if castSpell(unit, self.spell.surgingMist,true) then return end
        end
        -- Uplift
        function self.castUplift()
          if self.chi.count >= 2 then
            if castSpell("player",self.spell.uplift,false) then return end
          elseif self.charges.chiBrew >= 1 and self.chi.count < 2 then
            if castSpell("player",self.spell.chiBrew) then
                if castSpell("player",self.spell.uplift) then return end
            end
          end
        end
        -----------------------------
        --- CALL CREATE FUNCTIONS ---
        -----------------------------

        self.createOptions()


        -- Return
        return self

    end --cMistweaver

end -- select Monk
