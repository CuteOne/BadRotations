local rotationName = "ForsoothVengeance"

---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    local RotationModes = {
        [1] = { mode = "On", value = 1 , overlay = "Rotation Enabled", tip = "Enable Rotation", highlight = 1, icon = br.player.spell.chaosStrike },
        [2] = {  mode = "Off", value = 4 , overlay = "Rotation Disabled", tip = "Disable Rotation", highlight = 0, icon = br.player.spell.chaosStrike }
    };
    br.ui:createToggle(RotationModes,"Rotation",1,0)
    -- Defensive Button
    local DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = select(2,br._G.GetItemSpell(br.player.items.legionHealthstone))},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = select(2,br._G.GetItemSpell(br.player.items.legionHealthstone))}
    };
    br.ui:createToggle(DefensiveModes,"Defensive",2,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -----------------------
        --- GENERAL OPTIONS ---
        -----------------------
        section = br.ui:createSection(br.ui.window.profile,  "General")
            -- Fel Crystal Fragments
            br.ui:createCheckbox(section, "Fel Crystal Fragments")
            -- Inquisitor's Menacing Eye
            br.ui:createCheckbox(section, "Inquisitor's Menacing Eye")
            -- Torment
            br.ui:createCheckbox(section, "Torment")
            -- Trinkets
            br.ui:createCheckbox(section, "Trinkets")
        br.ui:checkSectionState(section)
        -------------------------
        --- DEFENSIVE OPTIONS ---
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
            -- Basic Healing Module
            br.player.module.BasicHealing(section)
        br.ui:checkSectionState(section)
        ----------------------
        --- TOGGLE OPTIONS ---
        ----------------------
        section = br.ui:createSection(br.ui.window.profile,  "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdownWithout(section,  "Rotation Mode", br.dropOptions.Toggle,  4)
            --Defensive Key Toggle
            br.ui:createDropdownWithout(section,  "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section,  "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end

--------------
--- Locals ---
--------------
-- BR API Locals
local buff
local cast
local cd
local charges
local debuff
local enemies
local furyDeficit
local fury
local has
local module
local ui
local unit
local units
local use
local equiped
local talent
-- Profile Specific Locals
local actionList = {}
local var = {}
var.haltProfile = false
var.profileStop = false

--------------------
--- Action Lists ---
--------------------
-- Action List - Defensive
actionList.Defensive = function()
    if ui.useDefensive() then
        -- Basic Healing Module
        module.BasicHealing()
    end
end -- End Action List - Defensive

actionList.Interrupts = function()
    for i=1, #enemies.yards10 do
        local thisUnit = enemies.yards10[i]
        
        if cast.able.disrupt() and unit.interruptable(thisUnit,70) then
            if cast.disrupt() then ui.debug("Casting Disrupt [Interrupt]") return true end
        end
    end
end

-- Action List - Pre-Combat
actionList.PreCombat = function()
    if not unit.inCombat() and not br._G.IsMounted() then
        -- Fel Crystal Fragments
        if ui.checked("Fel Crystal Fragments") and not buff.felCrystalInfusion.exists() and use.able.felCrystalFragments() and has.felCrystalFragments() then
            if use.felCrystalFragments() then ui.debug("Using Fel Crystal Fragments") return true end
        end
        -- Inquisitor's Menacing Eye
        if ui.checked("Inquisitor's Menacing Eye") and not buff.gazeOfTheLegion.exists() and use.able.inquisitorsMenacingEye() then
            if use.inquisitorsMenacingEye() then ui.debug("Using Inquisitor's Menacing Eye") return true end
        end
        if unit.valid("target") then
            --  Throw Glaive for filler or when kiting
            if cast.able.throwGlaive() then
                cast.throwGlaive()
            end
            -- actions.precombat+=/sigil_of_flame
            if cast.able.sigilOfFlame() then
                cast.sigilOfFlame()
            end
            -- actions.precombat+=/immolation_aura
            if cast.able.immolationAura() then
                cast.immolationAura()
            end
            -- Start Attack
            -- actions=auto_attack
            if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                br._G.StartAttack(units.dyn5)
            end
        end
    end
end -- End Action List - PreCombat

actionList.maintenance = function()
    -- actions.maintenance=fiery_brand,if=(!ticking&active_dot.fiery_brand=0)|charges>=2|(full_recharge_time<=cast_time+gcd.remains)
    if cast.able.fieryBrand() and (not debuff.fieryBrand.exists() and debuff.fieryBrand.count() == 0) or charges.fieryBrand.count() >= 2 or (charges.fieryBrand.timeTillFull() <= cast.time.fieryBrand()+unit.gcd()) then
        cast.fieryBrand()
    end
    -- actions.maintenance+=/bulk_extraction,if=active_enemies>=(5-soul_fragments)
    if cast.able.bulkExtraction() and #enemies.yards5 >= (5-buff.soulFragments.stack()) then
        cast.bulkExtraction()
    end
    -- actions.maintenance+=/spirit_bomb,if=soul_fragments>=5
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 5 then
        cast.spiritBomb()
    end
    -- actions.maintenance+=/fracture,target_if=max:dot.fiery_brand.remains,if=active_enemies>1&buff.recrimination.up
    if cast.able.fracture(var.maxFieryBrand) and #enemies.yards5 > 1 then
        cast.fracture(var.maxFieryBrand)
    end
    -- actions.maintenance+=/fracture,if=(full_recharge_time<=cast_time+gcd.remains)
    if cast.able.fracture() and (charges.fracture.timeTillFull() <= cast.time.fracture()+unit.gcd()) then
        cast.fracture()
    end
    -- actions.maintenance+=/immolation_aura,if=!talent.fallout|soul_fragments<5
    if cast.able.immolationAura() and not talent.fallotu or buff.soulFragments.stack() < 5 then
        cast.immolationAura()
    end
    -- actions.maintenance+=/sigil_of_flame
    if cast.able.sigilOfFlame() then
        cast.sigilOfFlame()
    end
    -- actions.maintenance+=/metamorphosis,if=talent.demonic&!buff.metamorphosis.up&!cooldown.fel_devastation.up
    if br.isBoss() and unit.ttd() > 15 and talent.demonic and not buff.metamorphosis.exists() and not cd.felDevastation.ready() then
        cast.metamorphosis()
    end
end

actionList.single_target = function()
    -- actions.single_target=fel_devastation,if=!(talent.demonic&buff.metamorphosis.up)
    if cast.able.felDevastation() and not (talent.demonic and buff.metamorphosis.exists()) then
        cast.felDevastation()
    end
    -- actions.single_target+=/soul_carver
    if cast.able.soulCarver() then
        cast.soulCarver()
    end
    -- actions.single_target+=/the_hunt
    if cast.able.theHunt() then
        cast.theHunt()
    end
    -- actions.single_target+=/elysian_decree
    if cast.able.elysianDecree() then
        cast.elysianDecree()
    end
    -- actions.single_target+=/fracture,if=set_bonus.tier30_4pc&variable.fd&soul_fragments<=4&soul_fragments>=1
    if cast.able.fracture() and equiped(30) >= 4 and var.fd and buff.soulFragments.stack() <= 4 and buff.soulFragments.stack() >= 1 then
        cast.fracture()
    end
    -- actions.single_target+=/spirit_bomb,if=soul_fragments>=4
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 4 then
        cast.spiritBomb()
    end
    -- actions.single_target+=/soul_cleave,if=talent.focused_cleave
    if cast.able.soulCleave() and talent.focusedCleave then
        cast.soulCleave()
    end
    -- actions.single_target+=/spirit_bomb,if=variable.fd&soul_fragments>=3
    if cast.able.spiritBomb() and var.fd and buff.soulFragments.stack() >= 3 then
        cast.spiritBomb()
    end
    -- actions.single_target+=/fracture,if=soul_fragments<=3&soul_fragments>=1
    if cast.able.fracture() and buff.soulFragments.stack() <= 3 and buff.soulFragments.stack() >= 1 then
        cast.fracture()
    end
    -- actions.single_target+=/soul_cleave,if=soul_fragments<=1
    if cast.able.soulCleave() and buff.soulFragments.stack() <= 1 then
        cast.soulCleave()
    end
    -- actions.single_target+=/call_action_list,name=filler
    actionList.filler()
end

actionList.small_aoe = function()
    -- actions.small_aoe=fel_devastation,if=!(talent.demonic&buff.metamorphosis.up)
    if cast.able.felDevastation() and not (talent.demonic and buff.metamorphosis.exists()) then
        cast.felDevastation()
    end
    -- actions.small_aoe+=/the_hunt
    if cast.able.theHunt() then
        cast.theHunt()
    end
    -- actions.small_aoe+=/elysian_decree,if=(soul_fragments+variable.incoming_souls)<=2
    if cast.able.elysianDecree() and (buff.soulFragments.stack()+var.incoming_souls) <= 2 then
        cast.elysianDecree()
    end
    -- actions.small_aoe+=/soul_carver,if=(soul_fragments+variable.incoming_souls)<=3
    if cast.able.soulCarver() and (buff.soulFragments.stack()+var.incoming_souls) <= 3 then
        cast.soulCarver()
    end
    -- actions.small_aoe+=/fracture,if=soul_fragments<=3&soul_fragments>=1
    if cast.able.fracture() and buff.soulFragments.stack() <= 3 and buff.soulFragments.stack() >= 1 then
        cast.fracture()
    end
    -- actions.small_aoe+=/spirit_bomb,if=soul_fragments>=3
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 3 then
        cast.spiritBomb()
    end
    -- actions.small_aoe+=/soul_cleave,if=(talent.focused_cleave|(soul_fragments<=2&variable.incoming_souls=0))
    if cast.able.soulCleave() and (talent.focusedCleave or (buff.soulFragments.stack() <= 2 and var.incoming_souls == 0)) then
        cast.soulCleave()
    end
    -- actions.small_aoe+=/call_action_list,name=filler
    actionList.filler()
end

actionList.big_aoe = function()
    -- actions.big_aoe=spirit_bomb,if=(active_enemies<=7&soul_fragments>=4)|(active_enemies>7&soul_fragments>=3)
    if cast.able.spiritBomb() and (#enemies.yards5 <= 7 and buff.soulFragments.stack() >= 4) or (#enemies.yards5 > 7 and buff.soulFragments.stack() >= 3) then
        cast.spiritBomb()
    end
    -- actions.big_aoe+=/fel_devastation,if=!(talent.demonic&buff.metamorphosis.up)
    if cast.able.felDevastation() and not (talent.demonic and buff.metamorphosis.exists()) then
        cast.felDevastation()
    end
    -- actions.big_aoe+=/the_hunt
    if cast.able.theHunt() then
        cast.theHunt()
    end
    -- actions.big_aoe+=/elysian_decree,if=(soul_fragments+variable.incoming_souls)<=2
    if cast.able.elysianDecree() and (buff.soulFragments.stack() + var.incoming_souls) <= 2 then
        cast.elysianDecree()
    end
    -- actions.big_aoe+=/soul_carver,if=(soul_fragments+variable.incoming_souls)<=3
    if cast.able.soulCarver() and (buff.soulFragments.stack()+var.incoming_souls)<=3 then
        cast.soulCarver()
    end
    -- actions.big_aoe+=/fracture,if=soul_fragments>=2
    if cast.able.fracture() and buff.soulFragments.stack() >= 2 then
        cast.fracture()
    end
    -- actions.big_aoe+=/spirit_bomb,if=soul_fragments>=3
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 3 then
        cast.spiritBomb()
    end
    -- actions.big_aoe+=/soul_cleave,if=soul_fragments<=2&variable.incoming_souls=0
    if cast.able.soulCleave() and buff.soulFragments.stack() <= 2 and var.incoming_souls == 0 then
        cast.soulCleave()
    end
    -- actions.big_aoe+=/call_action_list,name=filler
    actionList.filler()
end

actionList.filler = function()
    -- actions.filler=sigil_of_flame
    if cast.able.sigilOfFlame() then
        cast.sigilOfFlame()
    end
    -- actions.filler+=/immolation_aura
    if cast.able.immolationAura() then
        cast.immolationAura()
    end
    -- actions.filler+=/fracture
    if cast.able.fracture() then
        cast.fracture()
    end
    -- actions.filler+=/shear
    if cast.able.shear() then
        cast.shear()
    end
    -- actions.filler+=/felblade
    if cast.able.felblade() then
        cast.felblade()
    end
    -- actions.filler+=/spirit_bomb,if=soul_fragments>=3
    if cast.able.spiritBomb() and buff.soulFragments.stack() >= 3 then
        cast.spiritBomb()
    end
    -- actions.filler+=/soul_cleave,if=soul_fragments<=1
    if cast.able.soulCleave() and buff.soulFragments.stack() <= 1 then
        cast.soulCleave()
    end
    -- actions.filler+=/throw_glaive,if=gcd.remains>=0.5*gcd.max
    if cast.able.throwGlaive() and unit.gcd() >= 0.5 * unit.gcd(true) then
        cast.throwGlaive()
    end
end

----------------
--- ROTATION ---
----------------
local function runRotation()
    ---------------------
    --- Define Locals ---
    ---------------------
    -- BR API Locals
    buff                                          = br.player.buff
    cast                                          = br.player.cast
    cd                                            = br.player.cd
    charges                                       = br.player.charges
    debuff                                        = br.player.debuff
    enemies                                       = br.player.enemies
    furyDeficit                                   = br.player.power.fury.deficit()
    fury                                          = br.player.power.fury.amount()
    has                                           = br.player.has
    module                                        = br.player.module
    ui                                            = br.player.ui
    unit                                          = br.player.unit
    units                                         = br.player.units
    use                                           = br.player.use
    equiped = br.player.equiped
    talent = br.player.talent
    -- General Locals
    var.haltProfile                                   = (unit.inCombat() and var.profileStop) or br._G.IsMounted() or br.pause() or ui.mode.rotation==4
    -- Units
    units.get(5) -- Makes a variable called, units.dyn5
    units.get(40)
    -- Enemies
    enemies.get(5)
    enemies.get(8)
    enemies.get(10)

    var.maxFieryBrand = "target"
    var.fieryBrandMax = 0
    for i = 1, #enemies.yards5 do
        local thisUnit = enemies.yards5[i]
        local thisValue = (debuff.fieryBrand.stack(thisUnit) + 1) / (debuff.fieryBrand.remains(thisUnit) + 1)
        if thisValue > var.fieryBrandMax then
            var.maxFieryBrand = thisUnit
            var.fieryBrandMax = thisValue
        end
    end

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if br.pause() then
        var.profileStop = false
    else
        ---------------------------------
        --- Out Of Combat - Rotations ---
        ---------------------------------
        -----------------
        --- Defensive ---
        -----------------
        if actionList.Defensive() then return true end
        ------------------
        --- Pre-Combat ---
        ------------------
        if actionList.PreCombat() then return true end
        -----------------------------
        --- In Combat - Rotations ---
        -----------------------------
        -- Check for combat
        if unit.valid("target") and cd.global.remain() == 0 then
            if unit.exists(units.dyn40) and unit.distance(units.dyn40) < 40 then
                -- Start Attack
                -- # Executed every time the actor is available.
                -- # When will the next fire damage cooldown be available?
                -- actions=variable,name=next_fire_cd_time,value=cooldown.fel_devastation.remains
                var.next_fire_cd_time = cd.felDevastation.remains()
                -- actions+=/variable,name=next_fire_cd_time,op=min,value=cooldown.soul_carver.remains,if=talent.soul_carver
                if talent.soulCarver then
                    var.next_fire_cd_time = cd.soulCarver.remains()
                end
                -- actions+=/variable,name=incoming_souls,op=reset
                var.incoming_souls = 0
                -- actions+=/variable,name=incoming_souls,op=add,value=2,if=prev_gcd.1.fracture&!buff.metamorphosis.up
                if cast.last.fracture(1) and not buff.metamorphosis.exists() then
                    var.incoming_souls = 2
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=3,if=prev_gcd.1.fracture&buff.metamorphosis.up
                if cast.last.fracture(1) and buff.metamorphosis.exists() then
                    var.incoming_souls = 3
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=2,if=talent.soul_sigils&(prev_gcd.2.sigil_of_flame|prev_gcd.2.sigil_of_silence|prev_gcd.2.sigil_of_chains|prev_gcd.2.elysian_decree)
                if talent.soulSigils and (cast.last.sigilOfFlame(2) or cast.last.sigilOfSilence(2) or cast.last.sigilOfChains(2) or cast.last.elysianDecree(2)) then
                    var.incoming_souls = 2
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=active_enemies>?3,if=talent.elysian_decree&prev_gcd.2.elysian_decree
                if talent.elysianDecree and cast.last.elysianDecree(2) then
                    var.incoming_souls = #enemies.yards5 > 3 and #enemies.yards5 or 3
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=0.6*active_enemies>?5,if=talent.fallout&prev_gcd.1.immolation_aura
                if talent.fallout and cast.last.immolationAura(1) then
                    var.incoming_souls = 0.6 * (#enemies.yards5 > 5 and #enemies.yards5 or 5)
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=active_enemies>?5,if=talent.bulk_extraction&prev_gcd.1.bulk_extraction
                if talent.bulkExtraction and cast.last.bulkExtraction(1) then
                    var.incoming_souls = #enemies.yards5 > 5 and #enemies.yards5 or 5
                end
                -- actions+=/variable,name=incoming_souls,op=add,value=3-(cooldown.soul_carver.duration-ceil(cooldown.soul_carver.remains)),if=talent.soul_carver&cooldown.soul_carver.remains>57
                if talent.soulCarver and cd.soulCarver.remains() > 57 then
                    var.incoming_souls = 3 - (cd.soulCarver.remains()-math.ceil(cd.soulCarver.remains()))
                end
                -- # Fiery Demise is up
                -- actions+=/variable,name=fd,value=talent.fiery_demise&dot.fiery_brand.ticking
                var.fd = talent.fieryDemise and debuff.fieryBrand.exists()
                -- actions+=/auto_attack
                -- actions=auto_attack
                if not br._G.IsAutoRepeatSpell(br._G.GetSpellInfo(6603)) and unit.exists(units.dyn5) and unit.distance(units.dyn5) < 5 then
                    br._G.StartAttack(units.dyn5)
                end
                -- actions+=/disrupt,if=target.debuff.casting.react
                actionList.Interrupts()
                -- actions+=/demon_spikes,use_off_gcd=1,if=!buff.demon_spikes.up&!cooldown.pause_action.remains
                if cast.able.demonSpikes() and not buff.demonSpikes.exists() then
                    cast.demonSpikes()
                end
                -- actions+=/call_action_list,name=externals
                -- actions+=/metamorphosis,use_off_gcd=1,if=talent.first_of_the_illidari&(trinket.beacon_to_the_beyond.cooldown.remains<10|fight_remains<=20|!equipped.beacon_to_the_beyond|fight_remains%%120>5&fight_remains%%120<30)
                if br.isBoss() and unit.ttd() > 15 and cast.able.metamorphosis() and talent.firstOfTheIllidari then
                    cast.metamorphosis()
                end
                -- actions+=/infernal_strike,use_off_gcd=1
                if cast.able.infernalStrike() then
                    cast.infernalStrike()
                end
                -- actions+=/potion
                -- actions+=/call_action_list,name=trinkets
                -- actions+=/call_action_list,name=maintenance
                actionList.maintenance()
                -- actions+=/run_action_list,name=single_target,if=active_enemies<=1
                if #enemies.yards5 <= 1 then
                    actionList.single_target()
                end
                -- actions+=/run_action_list,name=small_aoe,if=active_enemies>1&active_enemies<=5
                if #enemies.yards5 > 1 and #enemies.yards5 <= 5 then
                    actionList.small_aoe()
                end
                -- actions+=/run_action_list,name=big_aoe,if=active_enemies>=6
                if #enemies.yards5 >= 6 then
                    actionList.big_aoe()
                end
            end -- End In Combat Rotation
        end
    end -- Pause
end -- End runRotation
local id = 581
if br.rotations[id] == nil then br.rotations[id] = {} end
br._G.tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})