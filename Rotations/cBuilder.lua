br.loader = {}
function br.loader:new(spec,specName)
    local loadStart = debugprofilestop()
    br.loader.rotations = {}
    for k, v in pairs(br.rotations) do
        if spec == k then
            for i = 1, #v do
                tinsert(br.loader.rotations, v[i])
            end
        end
    end
    local self = cCharacter:new(tostring(select(1,UnitClass("player"))))
    local player = "player" -- if someone forgets ""

    self.profile = specName

    -- Mandatory !
    self.rotations = br.loader.rotations

    -- Spells From Spell Table
    for unitClass , classTable in pairs(br.idList) do
        if unitClass == select(2,UnitClass('player')) or unitClass == 'Shared' then
            for spec, specTable in pairs(classTable) do
                if spec == GetSpecializationInfo(GetSpecialization()) or spec == 'Shared' then
                    for spellType, spellTypeTable in pairs(specTable) do
                        if self.spell[spellType] == nil then self.spell[spellType] = {} end
                        for spellRef, spellID in pairs(spellTypeTable) do
                            self.spell[spellType][spellRef] = spellID
                            if not IsPassiveSpell(spellID) 
                                and (spellType == 'abilities' or spellType == 'artifacts' or spellType == 'talents') 
                            then
                                if self.spell.abilities == nil then self.spell.abilities = {} end
                                self.spell.abilities[spellRef] = spellID
                                self.spell[spellRef] = spellID
                            end
                        end
                    end
                end
            end
        end        
    end

    -- Update Talent Info
    local function getTalentInfo()
        br.activeSpecGroup = GetActiveSpecGroup()
        if self.talent == nil then self.talent = {} end
        for r = 1, 7 do --search each talent row
            for c = 1, 3 do -- search each talent column
            -- Cache Talent IDs for talent checks
                local _,_,_,selected,_,talentID = GetTalentInfo(r,c,br.activeSpecGroup)
                -- Compare Row/Column Spell Id to Talent Id List for matches
                for k,v in pairs(self.spell.talents) do
                    if v == talentID then
                        -- Add All Matches to Talent List for Boolean Checks
                        self.talent[k] = selected
                        -- Add All Active Ability Matches to Ability/Spell List for Use Checks
                        if not IsPassiveSpell(v) then
                            self.spell['abilities'][k] = v
                            self.spell[k] = v
                        end
                    end
                end
            end
        end
    end
    
    -- Update Talent Info on Init and Talent Change
    getTalentInfo()
    local cframe = CreateFrame("FRAME")
    cframe:RegisterUnitEvent("PLAYER_TALENT_UPDATE")
    -- Update Talent Info
    function cframe:OnEvent(event, arg1, arg2, arg3, arg4, arg5)
        if event == "PLAYER_TALENT_UPDATE" then
            getTalentInfo() 
        end
    end
    cframe:SetScript("OnEvent", cframe.OnEvent)

    -- if not UnitAffectingCombat("player") then
    -- Build Artifact Info
    for k,v in pairs(self.spell.artifacts) do
        if not self.artifact[k] then self.artifact[k] = {} end
        local artifact = self.artifact[k]

        artifact.enabled = function() 
            return hasPerk(v)
        end
        artifact.rank = function()
            return getPerkRank(v)
        end
    end

    -- Update Power       
    if not self.power then self.power = {} end
    self.power.list     = {
        mana            = SPELL_POWER_MANA, --0,
        rage            = SPELL_POWER_RAGE, --1,
        focus           = SPELL_POWER_FOCUS, --2,
        energy          = SPELL_POWER_ENERGY, --3,
        comboPoints     = SPELL_POWER_COMBO_POINTS, --4,
        runes           = SPELL_POWER_RUNES, --5,
        runicPower      = SPELL_POWER_RUNIC_POWER, --6,
        soulShards      = SPELL_POWER_SOUL_SHARDS, --7,
        astralPower     = SPELL_POWER_LUNAR_POWER, --8,
        holyPower       = SPELL_POWER_HOLY_POWER, --9,
        altPower        = SPELL_POWER_ALTERNATE_POWER, --10,
        maelstrom       = SPELL_POWER_MAELSTROM, --11,
        chi             = SPELL_POWER_CHI, --12,
        insanity        = SPELL_POWER_INSANITY, --13,
        obsolete        = 14,
        obsolete2       = 15,
        arcaneCharges   = SPELL_POWER_ARCANE_CHARGES, --16,
        fury            = SPELL_POWER_FURY, --17,
        pain            = SPELL_POWER_PAIN, --18,
    }
    for k, v in pairs(self.power.list) do
        if not self.power[k] then self.power[k] = {} end
        local power = self.power[k]

        power.amount = function()
            if select(2,UnitClass("player")) == "DEATHKNIGHT" and v == 5 then
                local runeCount = 0
                for i = 1, 6 do
                    runeCount = runeCount + GetRuneCount(i)
                end
                return runeCount
            else
                return getPower("player",v)
            end
        end
        power.deficit = function()
            return getPowerMax("player",v) - getPower("player",v)
        end
        power.frac = function()
            if select(2,UnitClass("player")) == "DEATHKNIGHT" and v == 5 then
                local runeCount = 0
                for i = 1, 6 do
                    runeCount = runeCount + GetRuneCount(i)
                end
                return runeCount + math.max(runeCDPercent(1),runeCDPercent(2),runeCDPercent(3),runeCDPercent(4),runeCDPercent(5),runeCDPercent(6))
            else
                return 0
            end
        end
        power.max = function()
            return getPowerMax("player",v)
        end
        power.percent = function()
            if getPowerMax("player",v) == 0 then
                return 0
            else    
                return ((getPower("player",v) / getPowerMax("player",v)) * 100)
            end
        end
        power.regen = function()
            return getRegen("player")
        end
        power.ttm = function()
            return getTimeToMax("player")
        end
    end

    -- Build Buff Info
    for k,v in pairs(self.spell.buffs) do
        if k ~= "rollTheBones" then
            if self.buff[k] == nil then self.buff[k] = {} end
            local buff = self.buff[k]
            buff.cancel = function(thisUnit,sourceUnit)
                if thisUnit == nil then thisUnit = 'player' end
                if sourceUnit == nil then sourceUnit = 'player' end
                if UnitBuffID(thisUnit,v,sourceUnit) ~= nil then
                    RunMacroText("/cancelaura "..GetSpellInfo(v))
                    -- CancelUnitBuff(thisUnit,v,sourceUnit)
                end
            end
            buff.exists = function(thisUnit,sourceUnit)
                if thisUnit == nil then thisUnit = 'player' end
                if sourceUnit == nil then sourceUnit = 'player' end
                return UnitBuffID(thisUnit,v,sourceUnit) ~= nil
            end
            buff.duration = function(thisUnit,sourceUnit)
                if thisUnit == nil then thisUnit = 'player' end
                if sourceUnit == nil then sourceUnit = 'player' end
                return getBuffDuration(thisUnit,v,sourceUnit)
            end
            buff.remain = function(thisUnit,sourceUnit)
                if thisUnit == nil then thisUnit = 'player' end
                if sourceUnit == nil then sourceUnit = 'player' end
                return math.abs(getBuffRemain(thisUnit,v,sourceUnit))
            end
            buff.stack = function(thisUnit,sourceUnit)
                if thisUnit == nil then thisUnit = 'player' end
                if sourceUnit == nil then sourceUnit = 'player' end
                return getBuffStacks(thisUnit,v,sourceUnit)
            end
            buff.refresh = function(thisUnit,sourceUnit)
                return buff.remain(thisUnit,sourceUnit) <= buff.duration(thisUnit,sourceUnit) * 0.3
            end
            buff.count = function()
                return tonumber(getBuffCount(v))
            end
        end
    end
    -- Build Debuff Info
    function self.getSnapshotValue(dot)
        -- Feral Bleeds
        if GetSpecializationInfo(GetSpecialization()) == 103 then
            local multiplier        = 1.00
            local Bloodtalons       = 1.30
            -- local SavageRoar        = 1.40
            local TigersFury        = 1.15
            local RakeMultiplier    = 1
            -- Bloodtalons
            if self.buff.bloodtalons.exists() then multiplier = multiplier*Bloodtalons end
            -- Savage Roar
            -- if self.buff.savageRoar.exists() then multiplier = multiplier*SavageRoar end
            -- Tigers Fury
            if self.buff.tigersFury.exists() then multiplier = multiplier*TigersFury end
            -- rip
            if dot == self.spell.debuffs.rip then
                -- -- Versatility
                -- multiplier = multiplier*(1+Versatility*0.1)
                -- return rip
                return 5*multiplier
            end
            -- rake
            if dot == self.spell.debuffs.rake then
                -- Incarnation/Prowl
                if self.buff.incarnationKingOfTheJungle.exists() or self.buff.prowl.exists() then
                    RakeMultiplier = 2
                end
                -- return rake
                return multiplier*RakeMultiplier
            end
            return 0
        end
    end

    for k,v in pairs(self.spell.debuffs) do
        if self.debuff[k] == nil then self.debuff[k] = {} end
        local debuff = self.debuff[k]
        debuff.exists = function(thisUnit,sourceUnit)
            if thisUnit == nil then thisUnit = 'target' end
            if sourceUnit == nil then sourceUnit = 'player' end
            return UnitDebuffID(thisUnit,v,sourceUnit) ~= nil
        end
        debuff.duration = function(thisUnit,sourceUnit)
            if thisUnit == nil then thisUnit = 'target' end
            if sourceUnit == nil then sourceUnit = 'player' end
            return getDebuffDuration(thisUnit,v,sourceUnit) or 0
        end
        debuff.remain = function(thisUnit,sourceUnit)
            if thisUnit == nil then thisUnit = 'target' end
            if sourceUnit == nil then sourceUnit = 'player' end
            return math.abs(getDebuffRemain(thisUnit,v,sourceUnit))
        end
        debuff.stack = function(thisUnit,sourceUnit)
            if thisUnit == nil then thisUnit = 'target' end
            if sourceUnit == nil then sourceUnit = 'player' end
            if getDebuffStacks(thisUnit,v,sourceUnit) == 0 and UnitDebuffID(thisUnit,v,sourceUnit) ~= nil then
                return 1
            else
                return getDebuffStacks(thisUnit,v,sourceUnit)
            end
        end
        debuff.refresh = function(thisUnit,sourceUnit)
            if thisUnit == nil then thisUnit = 'target' end
            if sourceUnit == nil then sourceUnit = 'player' end
            return debuff.remain(thisUnit,sourceUnit) <= debuff.duration(thisUnit,sourceUnit) * 0.3
        end
        debuff.count = function()
            return tonumber(getDebuffCount(v))
        end
        debuff.remainCount = function(remain)
            return tonumber(getDebuffRemainCount(v,remain))
        end
        if spec == 103 then
            debuff.calc = function()
                return self.getSnapshotValue(v)
            end
            debuff.applied = function(thisUnit)
                return debuff.bleed[thisUnit] or 0
            end
        end
    end
    
    self.units = function(range,aoe)
        if aoe == nil then aoe = false end
        if aoe then
            return dynamicTarget(range, false)
        else
            return dynamicTarget(range, true)
        end
    end

    self.enemies = function(range,unit,checkInCombat)
        if unit == nil then unit = "player" end
        if checkInCombat == nil then checkInCombat = false end
        return getEnemies(unit,range,checkInCombat)
    end

    -- Cycle through Items List
    for k,v in pairs(self.spell.items) do
        if self.use == nil then self.use = {} end -- Use Item Functions
        if self.equiped == nil then self.equiped = {} end -- Use Item Debugging
        if self.charges[k] == nil then self.charges[k] = {} end -- Item Charge Functions 

        local charges = self.charges[k]
        charges.exists = function()
            return itemCharges(v) > 0
        end
        charges.count = function()
            return itemCharges(v)
        end

        self.use[k] = function(slotID)
            if slotID == nil then
                if canUse(v) then return useItem(v) else return end
            else
                if canUse(slotID) then return useItem(slotID) else return end
            end
        end
        self.equiped[k] = function(slotID)
            if slotID == nil then 
                return hasEquiped(v)
            else
                return hasEquiped(v,slotID)
            end
        end
    end
    self.use.slot = function(slotID)
        if canUse(slotID) then return useItem(slotID) else return end
    end

    -- if UnitDebuffID("player", 240447) ~= nil and (getCastTime(v) + 0.15) > getDebuffRemain("player",240447) then end
    -- Cycle through Abilities List
    for k,v in pairs(self.spell.abilities) do
        if self.cast            == nil then self.cast               = {} end        -- Cast Spell Functions
        if self.cast.debug      == nil then self.cast.debug         = {} end        -- Cast Spell Debugging
        if self.cast.able       == nil then self.cast.able          = {} end        -- Cast Spell Available
        if self.cast.cost       == nil then self.cast.cost          = {} end        -- Cast Spell Cost
        if self.cast.current    == nil then self.cast.current       = {} end        -- Cast Spell Current
        if self.cast.last       == nil then self.cast.last          = {} end        -- Cast Spell Last
        if self.cast.regen      == nil then self.cast.regen         = {} end        -- Cast Spell Regen
        if self.cast.time       == nil then self.cast.time          = {} end        -- Cast Spell Time
        if self.charges[k]      == nil then self.charges[k]         = {} end        -- Spell Charge Functions 
        if self.cd[k]           == nil then self.cd[k]              = {} end        -- Spell Cooldown Functions 

        -- Build Spell Charges
        local charges = self.charges[k]
        charges.exists = function()
            return getCharges(v) > 0
        end
        charges.count = function()
            return getCharges(v)
        end
        charges.frac = function()
            return getChargesFrac(v)
        end
        charges.max = function()
            return getChargesFrac(v,true)
        end
        charges.recharge = function()
            return getRecharge(v)
        end
        charges.timeTillFull = function()
            return getFullRechargeTime(v)
        end

        -- Build Spell Cooldown
        local cd = self.cd[k]
        cd.exists = function()
            return getSpellCD(v) > 0
        end
        cd.remain = function()
            return getSpellCD(v)
        end

        -- Build Cast Funcitons
        self.cast[k] = function(thisUnit,debug,minUnits,effectRng)
            return createCastFunction(thisUnit,debug,minUnits,effectRng,v,k)
        end

        self.cast.able[k] = function()
            return self.cast[v](nil,"debug")
        end

        self.cast.cost[k] = function()
            return getSpellCost(v)
        end

        self.cast.current[k] = function(spellID,unit)
            if spellID == nil then spellID = v end
            if unit == nil then unit = "player" end
            return isCastingSpell(spellID,unit)
        end

        self.cast.last[k] = function()
            return lastSpellCast == v
        end

        self.cast.regen[k] = function()
            return getCastingRegen(v)
        end

        self.cast.time[k] = function()
            return getCastTime(v)
        end
    end

------------------
--- OOC UPDATE ---
------------------

    function self.updateOOC()
        -- Call baseUpdateOOC()
        self.baseUpdateOOC()
    end

--------------
--- UPDATE ---
--------------

    function self.update()
        -- Call baseUpdate()
        self.baseUpdate()
        self.getBleeds()
        -- self.getPetInfo()
        self.getToggleModes()
        -- Start selected rotation
        self:startRotation()
    end

---------------
--- BLEEDS  ---
---------------
    function self.getBleeds()
        if spec == 103 then
            for k, v in pairs(self.debuff) do
                if k == "rake" or k == "rip" then
                    if self.debuff[k].bleed == nil then self.debuff[k].bleed = {} end
                    for l, w in pairs(self.debuff[k].bleed) do
                        if not UnitAffectingCombat("player") or UnitIsDeadOrGhost(l) then
                            self.debuff[k].bleed[l] = nil
                        elseif not self.debuff[k].exists(l) then
                            self.debuff[k].bleed[l] = 0
                        end
                    end
                end
            end
        end
    end

---------------
--- TOGGLES ---
---------------

    function self.getToggleModes()

        self.mode.rotation      = br.data.settings[br.selectedSpec].toggles["Rotation"]
        self.mode.cooldown      = br.data.settings[br.selectedSpec].toggles["Cooldown"]
        self.mode.defensive     = br.data.settings[br.selectedSpec].toggles["Defensive"]
        self.mode.interrupt     = br.data.settings[br.selectedSpec].toggles["Interrupt"]
    end

    -- Create the toggle defined within rotation files
    function self.createToggles()
        GarbageButtons()
        if self.rotations[br.selectedProfile] ~= nil then
            self.rotations[br.selectedProfile].toggles()
        else
            return
        end
    end

---------------
--- OPTIONS ---
---------------

    -- Class options
    -- Options which every Rogue should have
    -- function self.createClassOptions()
    --     -- Class Wrap
    --     local section = br.ui:createSection(br.ui.window.profile,  "Class Options", "Nothing")
    --     br.ui:checkSectionState(section)
    -- end
    -- Create Spell Index
    -- function self.createSpellIndex()
    --     section = br.ui:createSection(br.ui.window.profile,  "Spells - Uncheck to prevent bot use")
    --     for k,v in pairs(self.spell.abilities) do
    --         if v ~= 61304 and v ~= 28880 and v ~= 58984 and v ~= 107079 then
    --             br.ui:createCheckbox(section, "Use: "..tostring(GetSpellInfo(v)),"|cFFED0000 WARNING!".."|cFFFFFFFF Unchecking spell may cause rotation to not function correctly or at all.",true)
    --         end
    --     end
    -- end
     -- Creates the option/profile window
    function self.createOptions()
        -- if br.ui:closeWindow("profile")
        for i = 1, #br.data.settings[br.selectedSpec] do
            local thisProfile = br.data.settings[br.selectedSpec][i]
            if thisProfile ~= br.data.settings[br.selectedSpec][br.selectedProfile] then
                br.ui:closeWindow("profile")
            end
        end
        if br.data.settings[br.selectedSpec][br.selectedProfile] == nil then br.data.settings[br.selectedSpec][br.selectedProfile] = {} end
        br.ui:createProfileWindow(self.profile)

        -- Get the names of all profiles and create rotation dropdown
        local names = {}
        for i=1,#self.rotations do
            -- if spec == self.rotations[i].spec then
                tinsert(names, self.rotations[i].name)
            -- end
        end

        br.ui:createRotationDropdown(br.ui.window.profile.parent, names)

        -- Create Base and Class option table
        local optionTable = {
            {
                [1] = "Base Options",
                [2] = self.createBaseOptions,
            },
            -- {
            --     [1] = "Spell Index",
            --     [2] = self.createSpellIndex,
            -- },
        }

        -- Get profile defined options
        local profileTable = profileTable
        if self.rotations[br.selectedProfile] ~= nil then
            profileTable = self.rotations[br.selectedProfile].options()
        else
            return
        end

        -- Only add profile pages if they are found
        if profileTable then
            insertTableIntoTable(optionTable, profileTable)
        end

        -- Create pages dropdown
        br.ui:createPagesDropdown(br.ui.window.profile, optionTable)

        -- br:checkProfileWindowStatus()
        br.ui:checkWindowStatus("profile")
    end

------------------------
--- CUSTOM FUNCTIONS ---
------------------------

    function useAoE()
        local rotation = self.mode.rotation
        if (rotation == 1 and #self.enemies(8) >= 3) or rotation == 2 then
            return true
        else
            return false
        end
    end

    function useCDs()
        local cooldown = self.mode.cooldown
        if (cooldown == 1 and isBoss()) or cooldown == 2 then
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

    function useMfD()
        if self.mode.mfd == 1 then
            return true
        else
            return false
        end
    end

    function useRollForTB()
        if self.mode.RerollTB == 1 then
            return true
        else
            return false
        end
    end

     function useRollForOne()
        if self.mode.RollForOne == 1  then
            return true
        else
            return false
        end
    end

    function ComboMaxSpend()
        return br.player.talent.deeperStrategem and 6 or 5
    end

    function ComboSpend()
        return math.min(br.player.power.comboPoints.amount(), ComboMaxSpend())
    end

    function mantleDuration()
        if hasEquiped(144236) then
            --if br.player.buff.masterAssassinsInitiative.remain("player") > 100 or br.player.buff.masterAssassinsInitiative.remain("player") < 0 then
            if br.player.buff.masterAssassinsInitiative.exists("player") and (getBuffRemain("player",235027) > 100 or getBuffRemain("player",235027) < 100) then
                return br.player.cd.global.remain() + 5
            else
                --return br.player.buff.masterAssassinsInitiative.remain("player")
                if getBuffRemain("player",235027) >= 0 and getBuffRemain("player",235027) < 0.1 then
                    return 0
                else
                    return getBuffRemain("player",235027)
                end
            end
        else
            return 0
        end
    end

    function BleedTarget()
        return (br.player.debuff.garrote.exists("target") and 1 or 0) + (br.player.debuff.rupture.exists("target") and 1 or 0) + (br.player.debuff.internalBleeding.exists("target") and 1 or 0)
    end

    -- Debugging
        br.debug.cpu.rotation.loadTime = debugprofilestop()-loadStart
-----------------------------
--- CALL CREATE FUNCTIONS ---
-----------------------------
    -- Return
    return self
end --End function
