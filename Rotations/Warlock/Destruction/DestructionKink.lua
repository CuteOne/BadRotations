local rotationName = "KinkDestruction"
local VerNum = "1.2.7"
local colorOrange = "|cffFF7C0A"
---------------
--- Toggles ---
---------------
local function createToggles()
    -- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.chaosBolt},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.rainOfFire},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.immolate},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)

    -- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonInfernal},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonInfernal},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonInfernal}
    };
    CreateButton("Cooldown",2,0)

    -- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)

    -- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.fear}
    };
    CreateButton("Interrupt",4,0)

    CataclysmModes = {
        [1] = { mode = "On", value = 1 , overlay = "Cataclysm Enabled", tip = "Will Use Cataclysm in Rotation.", highlight = 1, icon = br.player.spell.cataclysm},
        [2] = { mode = "Off", value = 2 , overlay = "Cataclysm Disabled", tip = "Will Not Use Cataclysm in Rotation.", highlight = 0, icon = br.player.spell.cataclysm}
    };
    CreateButton("Cataclysm",5,0)

    --Pet summon
    PetSummonModes = {
        [1] = { mode = "1", value = 1 , overlay = "Imp", tip = "Summon Imp", highlight = 1, icon = br.player.spell.summonImp },
        [2] = { mode = "2", value = 2 ,overlay = "Voidwalker", tip = "Summon Voidwalker", highlight = 1, icon = br.player.spell.summonVoidwalker },
        [3] = { mode = "3", value = 3 , overlay = "Felhunter", tip = "Summon Felhunter", highlight = 1, icon = br.player.spell.summonFelhunter },
        [4] = { mode = "4", value = 4 , overlay = "Succubus", tip = "Summon Succubus", highlight = 1, icon = br.player.spell.summonSuccubus },
        [5] = { mode = "None", value = 5 , overlay = "No pet", tip = "Dont Summon any Pet", highlight = 0, icon = br.player.spell.conflagrate }
    };
    CreateButton("PetSummon",6,0)
    
    -- Burning Rush button
    BurningRushModes = {
        [1] = { mode = "On", value = 1 , overlay = "Burning Rush Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.burningRush},
        [2] = { mode = "Off", value = 2 , overlay = "Burning Rush Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.burningRush}
    };
    CreateButton("BurningRush",1,1)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
        -- General Options
            section = br.ui:createSection(br.ui.window.profile,  colorOrange .. "Destruction " .. ".:|:. " .. " General " .. "Ver" ..colorOrange .. VerNum .. ".:|:. ")
            -- Multi-Target Units
            br.ui:createSpinnerWithout(section, "Multi-Target Units", 3, 1, 25, 1, "|cffFFBB00Health Percentage to use at.")

            -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC","|cffFFFFFFAMR"}, 1, "|cffFFFFFFSet APL Mode to use.")

            -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")

            -- Pig Catcher
            br.ui:createCheckbox(section, "Pig Catcher")

        -- -- Pre-Pull Timer
        --     br.ui:createSpinner(section, "Pre-Pull Timer",  5,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- -- Opener
        --     br.ui:createCheckbox(section,"Opener")
            -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")

            -- Fel Domination
            br.ui:createCheckbox(section, "Fel Domination", "|cffFFFFFF Toggle the auto casting of Fel Donmination")

            -- Pet - Auto Attack/Passive
            br.ui:createCheckbox(section, "Pet - Auto Attack/Passive")

        -- -- Grimoire of Service
        --     br.ui:createDropdownWithout(section, "Grimoire of Service - Pet", {"Imp","Voidwalker","Felhunter","Succubus","Felguard","None"}, 1, "|cffFFFFFFSelect pet to Grimoire.")
        --     br.ui:createDropdownWithout(section,"Grimoire of Service - Use", {"|cff00FF00Everything","|cffFFFF00Cooldowns","|cffFF0000Never"}, 1, "|cffFFFFFFWhen to use Grimoire Ability.")
            -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 5, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")

        --     br.ui:createSpinnerWithout(section, "Multi-Dot HP Limit", 5, 0, 10, 1, "|cffFFFFFFHP Limit that DoTs will be cast/refreshed on.")
        --     br.ui:createSpinnerWithout(section, "Immolate Boss HP Limit", 10, 1, 20, 1, "|cffFFFFFFHP Limit that Immolate will be cast/refreshed on in relation to Boss HP.")
            -- Cataclysm
            br.ui:createCheckbox(section, "Cataclysm")

            -- Use Essence
            br.ui:createCheckbox(section, "Curse of Tongues")
            
            -- Use Essence
            br.ui:createCheckbox(section, "Curse of Weakness")


            -- Cataclysm Units
            br.ui:createSpinnerWithout(section, "Cataclysm Units", 1, 1, 10, 1, "|cffFFFFFFNumber of Units Cataclysm will be cast on.")

            -- Cata with CDs
            br.ui:createCheckbox(section,"Ignore Cataclysm units when using CDs")

            -- Cataclysm Target
            br.ui:createDropdownWithout(section, "Cataclysm Target", {"Target", "Best"}, 1, "|cffFFFFFFCataclysm target")

            -- Predict movement
            br.ui:createCheckbox(section, "Predict Movement (Cata)", "|cffFFFFFF Predict movement of units for cataclysm (works best in solo/dungeons)")

            -- Rain of Fire
            br.ui:createSpinner(section, "Rain of Fire", 3, 1, 5, 1, "|cffFFFFFFUnit Count Minimum that Rain of Fire will be cast on.")

        -- -- Life Tap
        --     br.ui:createSpinner(section, "Life Tap", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- -- Chaos Bolt
        --     br.ui:createSpinnerWithout(section, "Chaos Bolt at Shards", 3, 2, 5, 1, "|cffFFFFFFNumber of Shards to use Chaos Bolt At.")
        br.ui:checkSectionState(section)
        -- Cooldown Options
      section = br.ui:createSection(br.ui.window.profile, colorOrange .. "CDs" .. ".:|:. " ..colorOrange .. " Cooldowns")
            -- Racial
            br.ui:createCheckbox(section,"Racial")

            -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")

            -- Summon Infernal
            br.ui:createCheckbox(section,"Summon Infernal")

        br.ui:checkSectionState(section)
        -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, colorOrange .. "DEF" .. ".:|:. " ..colorOrange .. " Defensive")
            -- Soulstone
		    br.ui:createDropdown(section, "Soulstone", {"|cffFFFFFFTarget","|cffFFFFFFMouseover","|cffFFFFFFTank", "|cffFFFFFFHealer", "|cffFFFFFFHealer/Tank", "|cffFFFFFFAny", "|cffFFFFFFPlayer"},
            1, "|cffFFFFFFTarget to cast on")

            -- Healthstone
            br.ui:createSpinner(section, "Health Funnel Cancel Cast",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cancel At")
            
            -- Healthstone
            br.ui:createSpinner(section, "Drain Life Cancel Cast",  85,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cancel At")

            -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Create Healthstone
            br.ui:createCheckbox(section,"Create Healthstone", "|cffFFFFFFToggle the creation of healthstones")

            -- Shadow Bulwark
            br.ui:createSpinner(section, "Shadow Bulwark",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            
            -- Demonic Gateway
            br.ui:createDropdown(section, "Demonic Gateway", br.dropOptions.Toggle, 6)

            -- Demonic Circle Summon
            br.ui:createDropdown(section, "Demonic Circle Summon", br.dropOptions.Toggle, 6)

            -- Demonic Circle Teleport
            br.ui:createDropdown(section, "Demonic Circle Teleport", br.dropOptions.Toggle, 6)

            -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");

            -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end

            -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            
            -- Mortal Coil 
            br.ui:createSpinner(section, "Mortal Coil",  23,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")

            -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel (Demon)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Demon to Cast At")
            br.ui:createSpinnerWithout(section, "Health Funnel (Player)", 50, 0, 100, 5, "|cffFFFFFFHealth Percent of Player to Cast At")

            -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")

            -- Devour Magic
            br.ui:createDropdown(section,"Devour Magic", {"|cffFFFF00Selected Target","|cffFFBB00Auto"}, 1, "|ccfFFFFFFTarget to Cast On")

        br.ui:checkSectionState(section)
        -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
            br.ui:createDropdown(section, "Shadowfury Key", br.dropOptions.Toggle, 6)
            -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
        -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
            -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
            -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
            -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
            -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
            -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
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
local debug
local enemies
local equiped
local essence
local flying, swimming, moving
local gcdMax
local has
local healPot
local inCombat
local item
local level
local mode
local opener
local ui
local pet
local php
local pullTimer
local race
local racial
local shards
local spell
local talent
local traits
local ttd
local units
local use

-- General Locals
local castSummonId = 0
local combatTime
local flashover
local havocRemain = 0
local infernalCast = GetTime()
local infernalRemain = 0
local inferno
local internalInferno
local lastSpell
local lastTargetX, lastTargetY, lastTargetZ = 0, 0, 0
local lucidDreams
local okToDoT
local petPadding = 2
local poolShards = false
local summonId = 0
local summonPet
local tanks = getTanksTable()
local targetMoveCheck = false

if br.lastImmo == nil then br.lastImmo = "player" end
if br.pauseTime == nil then br.pauseTime = GetTime() end

local immoTick = tonumber((select(1, GetSpellDescription(348):match("%d+"))))
if immoTick ~= nil then
    if (select(2, IsInInstance()) == "party" or select(2, IsInInstance()) == "raid") then
        immoTick = immoTick * 50
    else
        immoTick = immoTick *5
    end
end

-----------------
--- Functions ---
-----------------
    -- spellqueue ready
    local function SpellQueueReady()
        --Check if we can queue cast
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end
        -- spell usable check
    local function spellUsable(spellID)
        if isKnown(spellID) and not select(2, IsUsableSpell(spellID)) and getSpellCD(spellID) == 0 then
            return true
        end
        return false
    end


local diminishReturns ={} 
if not DiminishEHTable then DiminishEHTable={} end
if not DiminishEventHandler then DiminishEventHandler = {} end
if not DiminishEventHandlerLog then
    Diminish_DiminishEventHandlerLog = CreateFrame('Frame')
    Diminish_DiminishEventHandlerLog:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
 function OnSuccessfulCast(self, event, ...)
  local type, _, sourceGUID, _, _, _,  destGUID, _ = select(2, ...)
  if (event=="COMBAT_LOG_EVENT_UNFILTERED") then
  			
  		local castSpellID= {2139,44572,8122,5484,1499 }
  			for i=1,#castSpellID do
  			if castSpellID[i] ==select(12, ...) then
            if (type=="SPELL_CAST_SUCCESS") then
            table.insert(DiminishEventHandlerTable,{SpellID=select(12, ...), Time = GetTime(), UnitSource = sourceGUID ,UnitDest = destGUID })
	     	end
	     	end
	     	end
	     	if (type=="SPELL_CAST_SUCCESS") then
            table.insert(DiminishEHTable,{SpellID=select(12, ...), Time = GetTime(), UnitSource = sourceGUID ,UnitDest = destGUID })
	     	end
	     local auraSpellID = {118,61305,28272,61721,61780,28271,82691,2637,99,1499,19386,113724,115078,20066,9484,1776,6770,51514,6358,115268,58963,107079,
			96294,339,16689,102359,136634,50245,4167,90327,54706,122,33395,116706,114404,87194,115197,64695,63685,107566,
			108194,91800,91797,108200,22570,9005,5211,102795,113801,117526,24394,90337,50519,56626,44572,118271,119392,119381,122242,120086,853,119072,105593,1833,408,118905,30283,103131,22703,132168,107570,20549,
			5782,1513,105421,10326,8122,113792,2094,5484,5246,115268,
			91644,50541,117368,64044,51722,118093,58960,676,
			47476,81261,34490,55021,102051,116709,31935,15487,703,24259,115782,112869,6552,129597,
			33786}
        	for i=1,#auraSpellID do
        	if auraSpellID[i]==select(12, ...) then
	      	if (type=="SPELL_AURA_APPLIED") then
           	table.insert(DiminishEventHandlerDRTable,{SpellID=select(12, ...), Time = GetTime(), UnitSource = sourceGUID ,UnitDest = destGUID })
	      	end
	      	if (type=="SPELL_AURA_REFRESH") then
           	table.insert(DiminishEventHandlerDRTable,{SpellID=select(12, ...), Time = GetTime(), UnitSource = sourceGUID ,UnitDest = destGUID })
	      	end
	      	end
	      	end
	      


	      
	
        			
  end
 end

 Diminish_DiminishEventHandlerLog:SetScript('OnEvent', OnSuccessfulCast)

    DiminishEventHandlerLog = true
end




function clearCEH()
table.sort(DiminishEHTable,function(x,y) return y.Time<x.Time end)
for j=1,#DiminishEventHandlerDRTable do
for i=1,#DiminishEventHandlerDRTable do

	local time=DiminishEventHandlerDRTable[i].Time 
	if GetTime()- time > 45
	then
	table.remove(DiminishEventHandlerDRTable,i)
	break
	end

end
end
for j=1,#DiminishEHTable do
for i=1,#DiminishEHTable do

	local time=DiminishEHTable[i].Time 
	if GetTime()- time > 2
	then
	table.remove(DiminishEHTable,i)
	break
	end

end
end
for j=1,#DiminishEventHandlerTable do
for i=1,#DiminishEventHandlerTable do

	local time=DiminishEventHandlerTable[i].Time 
	if GetTime()-time > 60
	then
	table.remove(DiminishEventHandlerTable,i)
	break
	end

end
end

end

function whatClass(t)
local playerClass, englishClass = UnitClass(t)
return englishClass
end



function DiminishDRInfo(Target,DR)
DiminishDRCount = 0
ytime = 0
if DR == nil then return 0 end
local DiminishDRtrack = {
			{DR = "poly",SpellID={118,61305,28272,61721,61780,28271,82691,2637,99,1499,19386,113724,115078,20066,9484,1776,6770,51514,6358,115268,58963,107079}},
			{DR = "root",SpellID={96294,339,16689,102359,136634,50245,4167,90327,54706,122,33395,116706,114404,87194,115197,64695,63685,107566}},
			{DR = "stun",SpellID={108194,91800,91797,108200,22570,9005,5211,102795,113801,117526,24394,90337,50519,56626,44572,118271,119392,119381,122242,120086,853,119072,105593,1833,408,118905,30283,103131,22703,132168,107570,20549}},
			{DR = "fear",SpellID={5782,1513,105421,10326,8122,113792,2094,5484,5246,115268}},	
			{DR = "disarm",SpellID={91644,50541,117368,64044,51722,118093,58960,676}},
			{DR = "silence",SpellID={47476,81261,34490,55021,102051,116709,31935,15487,703,24259,115782,112869,6552,129597}},				
			{DR = "cyclone",SpellID={33786}}
			  }
	for i=1,#DiminishDRtrack do
		if DR == DiminishDRtrack[i].DR
		then
			for j=1, #DiminishDRtrack[i].SpellID do
					for y=1, #DiminishEventHandlerDRTable do
						if DiminishEventHandlerDRTable[y].UnitDest == UnitGUID(Target)
						and	DiminishDRtrack[i].SpellID[j] == DiminishEventHandlerDRTable[y].SpellID
						and GetTime() - DiminishEventHandlerDRTable[y].Time < 18.5
						then
						ytime = DiminishEventHandlerDRTable[y].Time
						DiminishDRCount = DiminishDRCount + 1
						end
					end
						for z=1, #DiminishEventHandlerDRTable do
							if DiminishEventHandlerDRTable[z].UnitDest == UnitGUID(Target)
							and	DiminishDRtrack[i].SpellID[j] == DiminishEventHandlerDRTable[z].SpellID
							and ytime - DiminishEventHandlerDRTable[z].Time < 18.5
							and ytime - DiminishEventHandlerDRTable[z].Time > 0
							then
							DiminishDRCount = DiminishDRCount + 1
							end
					end
			end
		end
    end
 return DiminishDRCount
end


function DiminishSpellInfo(Target,SpellIDs)
local DiminishCDtrack = {
			{class = "MAGE", SpellID=2139, Timer = 24},
			{class = "MAGE", SpellID=44572, Timer = 30},
			{class = "PRIEST", SpellID=8122, Timer = 30},
			{class = "WARLOCK", SpellID=5484, Timer = 40},
			{class = "HUNTER", SpellID=1499, Timer = 40}
			  }
	for i=1,#DiminishCDtrack do
		if whatClass(Target) == DiminishCDtrack[i].class
		and DiminishCDtrack[i].SpellID == SpellIDs
		then 
		return true
		end
    end
end


function DiminishSpellInfoTime(Target,SpellIDs)
local DiminishCDtrack = {
			{class = "MAGE", SpellID=2139, Timer = 24},
			{class = "MAGE", SpellID=44572, Timer = 30},
			{class = "PRIEST", SpellID=8122, Timer = 30},
			{class = "WARLOCK", SpellID=5484, Timer = 40},
			{class = "HUNTER", SpellID=1499, Timer = 40}
			  }
	for i=1,#DiminishCDtrack do
		if whatClass(Target) == DiminishCDtrack[i].class
		and DiminishCDtrack[i].SpellID == SpellIDs
		then return DiminishCDtrack[i].Timer
		end
	end
end


function DiminishCDTracker(Target,SpellID)
if type(SpellID) == "number" then SpellID = { SpellID } end 
for i=1,#SpellID do 
 	for y=1, #DiminishEventHandlerTable do
	if DiminishSpellInfo(Target,SpellID[i])
	and 
	UnitGUID(Target) == DiminishEventHandlerTable[y].UnitSource
	and SpellID[i] == DiminishEventHandlerTable[y].SpellID
	and GetTime() - DiminishEventHandlerTable[y].Time < DiminishSpellInfoTime(Target,SpellID[i])
	then
	return true
	end
	end
end
return false
end


function DiminishEHStime(t,s,time)
	for y=1, #DiminishEHTable do
	if UnitGUID(t) == DiminishEHTable[y].UnitSource
	and s == DiminishEHTable[y].SpellID
	and GetTime() - DiminishEHTable[y].Time < time
	then
	return true
	end
	end
end

function DiminishEHDtime(t,s,time)
	for y=1, #DiminishEHTable do
	if UnitGUID(t) == DiminishEHTable[y].UnitDest
	and s == DiminishEHTable[y].SpellID
	and GetTime() - DiminishEHTable[y].Time < time
	then
	return true
	end
	end
end


------------------------------------------------------

function GroupInfo()
 table.sort(members, function(x,y) return CalculateHP(x) < CalculateHP(y) end)
 end

--------------------------------------------------

function CastClick()
  if IsMouseButtonDown(1) and MainMenuBar:IsShown() then 
    local mousefocus = GetMouseFocus() 
    if mousefocus and mousefocus.feedback_action 
    then SpellCancelQueuedSpell() PQR_DelayRotation(1) end
  end
end

--------------------------------------------------

function IsHealer(t)
local class = select(2, UnitClass(t))
if (class == "DRUID" or class =="PALADIN" or class =="PRIEST" or class =="MONK" or class =="SHAMAN")
and UnitPowerMax(t) >= 290000
and not UnitBuffID(t, 24858)
and not UnitBuffID(t, 15473)
and not UnitBuffID(t, 324)
then
return true
end
end


    local function isMelee(unit)
        if unit == nil then unit = "target" end
        local class = select(2, UnitClass(unit))
        if (class == "DRUID" or class =="PALADIN" or class =="WARRIOR" or class =="MONK" or class =="SHAMAN" or class =="DEATHKNIGHT" or class =="ROGUE" or class =="DEMONHUNTER" )and UnitPowerMax(unit) < 70000 then
            return true
        end
    end

--------------------------------------------------
function inRange(t,spellID)
if UnitExists(t)
and IsSpellInRange(GetSpellInfo(spellID),t) == 1
	then
		return true
	end
end






--------------------
--- Action Lists ---
--------------------
local actionList = {}
-- Action List - Extras
actionList.Extras = function()
    -- Dummy Test
    if ui.checked("DPS Testing") then
        if GetObjectExists("target") then
            if getCombatTime() >= (tonumber(ui.value("DPS Testing"))*60) and isDummy() then
                StopAttack()
                ClearTarget()
                if ui.checked("Pet Management") then
                    PetStopAttack()
                    PetFollow()
                end
                Print(tonumber(ui.value("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                profileStop = true
            end
        end
    end -- End Dummy Test
    if isChecked("Pig Catcher") then
        bossHelper()
    end

    -- Demonic Gateway
    if SpecificToggle("Demonic Gateway") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DG Delay", 1) and CastSpellByName(GetSpellInfo(spell.demonicGateway),"cursor") then br.addonDebug("Casting Demonic Gateway") return end 
        if IsAoEPending() then CancelPendingSpell() end
    end

    -- Demonic Circle: Summon
    if SpecificToggle("Demonic Circle Summon") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DC Delay", 1) then cast.demonicCircle("player") br.addonDebug("Demonic Circle (Summon)") return true end 
    end
    -- Demonic Circle: Teleport
    if SpecificToggle("Demonic Circle Teleport") and not GetCurrentKeyBoardFocus() then
        if br.timer:useTimer("DC Delay", 1) and buff.demonicCircle.exists() then cast.demonicTeleport("player") br.addonDebug("Demonic Circle (Summon)") return true end 
    end
end

-- Action List - Defensive
actionList.Defensive = function()
    if useDefensive() then
        -- Pot/Stoned
        if ui.checked("Pot/Stoned") and inCombat and (use.able.healthstone() or canUseItem(healPot))
            and (hasHealthPot() or has.healthstone()) and php <= ui.value("Pot/Stoned")
        then
            if use.able.healthstone() then
                if use.healthstone() then debug("Using Healthstone") return true end
            elseif canUseItem(healPot) then
                useItem(healPot)
                debug("Using Health Potion")
            end
        end

        -- Soulstone
        if isChecked("Soulstone") and not moving and inCombat and br.timer:useTimer("Soulstone", 4) then
            if
                getOptionValue("Soulstone") == 1 and -- Target
                    UnitIsPlayer("target") and
                    UnitIsDeadOrGhost("target") and
                    GetUnitIsFriend("target", "player")
                then
                if cast.soulstone("target", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end
            if
                getOptionValue("Soulstone") == 2 and -- Mouseover
                    UnitIsPlayer("mouseover") and
                    UnitIsDeadOrGhost("mouseover") and
                    GetUnitIsFriend("mouseover", "player")
                then
                if cast.soulstone("mouseover", "dead") then
                    br.addonDebug("Casting Soulstone")
                    return true
                end
            end
            if getOptionValue("Soulstone") == 3 then -- Tank
                for i = 1, #tanks do
                    if UnitIsPlayer(tanks[i].unit) and UnitIsDeadOrGhost(tanks[i].unit) and GetUnitIsFriend(tanks[i].unit, "player") and getDistance(tanks[i].unit) <= 40 then
                        if cast.soulstone(tanks[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if getOptionValue("Soulstone") == 4 then -- Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if getOptionValue("Soulstone") == 5 then -- Tank/Healer
                for i = 1, #br.friend do
                    if
                        UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") and
                            (UnitGroupRolesAssigned(br.friend[i].unit) == "HEALER" or br.friend[i].role == "HEALER" or br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK")
                        then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
            if getOptionValue("Soulstone") == 6 then -- Any
                for i = 1, #br.friend do
                    if UnitIsPlayer(br.friend[i].unit) and UnitIsDeadOrGhost(br.friend[i].unit) and GetUnitIsFriend(br.friend[i].unit, "player") then
                        if cast.soulstone(br.friend[i].unit, "dead") then
                            br.addonDebug("Casting Soulstone")
                            return true
                        end
                    end
                end
            end
        end

                    -- Mortal Coil
            if ui.checked("Mortal Coil") and php <= ui.value("Mortal Coil") then
                if cast.mortalCoil() then br.addonDebug("Casting Mortal Coil") return true end
            end

        -- Heirloom Neck
        if ui.checked("Heirloom Neck") and php <= ui.value("Heirloom Neck") then
            if use.able.heirloomNeck() and item.heirloomNeck ~= 0
                and item.heirloomNeck ~= item.manariTrainingAmulet
            then
                if use.heirloomNeck() then debug("Using Heirloom Neck") return true end
            end
        end

        -- Gift of the Naaru
        if ui.checked("Gift of the Naaru") and php <= ui.value("Gift of the Naaru")
            and php > 0 and race == "Draenei"
        then
            if cast.racial() then debug("Casting Racial: Gift of the Naaru") return true end
        end

        -- Dark Pact
        if ui.checked("Dark Pact") and php <= ui.value("Dark Pact") then
            if cast.darkPact() then debug("Casting Dark Pact") return true end
        end

        -- Drain Life
        if ui.checked("Drain Life") and php <= ui.value("Drain Life") and isValidTarget("target") and not isCastingSpell(spell.drainLife) then
            if cast.drainLife() then debug("Casting Drain Life") return true end
        end

        -- Health Funnel
        if not moving and ui.checked("Health Funnel (Demon)") and getHP("pet") <= ui.value("Health Funnel (Demon)") and getHP("player") >= ui.value("Health Funnel (Player)") and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
            if cast.healthFunnel() then debug("Casting Health Funnel") return true end
        end

        -- Unending Resolve
        if ui.checked("Unending Resolve") and php <= ui.value("Unending Resolve") and inCombat then
            if cast.unendingResolve() then debug("Casting Unending Resolve") return true end
        end

        -- Devour Magic
        if isChecked("Devour Magic") and (pet.active.id() == 417 or pet.active.id() == 78158) then
            if getOptionValue("Devour Magic") == 1 then
                if canDispel("target",spell.devourMagic) and GetObjectExists("target") then
                    CastSpellByName(GetSpellInfo(spell.devourMagic),"target") br.addonDebug("Casting Devour Magic") return true 
                end
            elseif getOptionValue("Devour Magic") == 2 then
                for i = 1, #enemies.yards30 do
                    local thisUnit = enemies.yards30[i]
                    if canDispel(thisUnit,spell.devourMagic) then
                        CastSpellByName(GetSpellInfo(spell.devourMagic),thisUnit) br.addonDebug("Casting Devour Magic") return true 
                    end
                end
            end
        end
    end -- End Defensive Toggle
end

-- Action List - Interrupts
actionList.Interrupts = function()
    if useInterrupts() and (pet.active.id() == 417 or pet.active.id() == 78158) then
        for i=1, #enemies.yards30 do
            local thisUnit = enemies.yards30[i]
            if canInterrupt(thisUnit,ui.value("Interrupt At")) then
                if pet.active.id() == 417 then
                    if cast.spellLock(thisUnit) then return true end
                elseif pet.active.id() == 78158 then
                    if cast.shadowLock(thisUnit) then return true end
                end
            end
        end
    end -- End useInterrupts check
end

-- Action List - Cooldowns
actionList.Cooldowns = function()
    if useCDs() then
        -- Immolate
        -- immolate,if=talent.grimoire_of_supremacy.enabled&remains<8&cooldown.summon_infernal.remains<4.5
        if UnitHealth("target") >= immoTick and ttd("target") >= 9 and not moving and cast.able.immolate() and okToDoT and not cast.last.immolate() and (talent.grimoireOfSupremacy
            and debuff.immolate.remain("target") <= 10 and cd.summonInfernal.remain() < 4.5)
        then
            if cast.immolate() then debug("Cast Immolate [CD]") return true end
        end
        -- Conflagrate
        -- conflagrate,if=talent.grimoire_of_supremacy.enabled&cooldown.summon_infernal.remains<4.5&!buff.backdraft.up&soul_shard<4.3
        if cast.able.conflagrate() and (talent.grimoireOfSupremacy and cd.summonInfernal.remain() < 4.5
            and not buff.backdraft.exists() and shards < 4.3)
        then
            if cast.conflagrate() then debug("Cast Conflagrate [CD]") return true end
        end
        -- Item - Azshara's Font of Power
        -- use_item,name=azsharas_font_of_power,if=cooldown.summon_infernal.up|cooldown.summon_infernal.remains<=4
        if ui.checked("Trinkets") and equiped.azsharasFontOfPower() and use.able.azsharasFontOfPower()
            and (cd.summonInfernal.remain() == 0 or cd.summonInfernal.remain() <= 4)
        then
            if use.azsharasFontOfPower() then debug("Using Azshara's Font of Power [CD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD]") return true end
        end
        -- Azerite Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=pet.infernal.active
        if cast.able.guardianOfAzeroth() and (pet.infernal.active()) then
            if cast.guardianOfAzeroth() then debug("Cast Guardian Of Azeroth [CD]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=pet.infernal.active&(pet.infernal.remains<20.5|pet.infernal.remains<22&soul_shard>=3.6|!talent.grimoire_of_supremacy.enabled)
        if cast.able.darkSoulInstability() and (pet.infernal.active()
            and (infernalRemain < 20.5 or infernalRemain < 22 and shards >= 3.6
                or not talent.grimoireOfSupremacy))
        then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD]") return true end
        end
        -- Azerite Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=pet.infernal.active&(pet.infernal.remains<15.5|soul_shard<3.5&(buff.dark_soul_instability.up|!talent.grimoire_of_supremacy.enabled&dot.immolate.remains>12))
        if cast.able.memoryOfLucidDreams() and (pet.infernal.active()
            and (infernalRemain < 15.5 or shards < 3.5 and (buff.darkSoulInstability.exists()
                or not talent.grimoireOfSupremacy and debuff.immolate.remain("target") > 12)))
        then
            if cast.memoryOfLucidDreams() then debug("Cast Memory Of Lucid Dreams [CD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=target.time_to_die>cooldown.summon_infernal.duration+30
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (ttd("target") > cd.summonInfernal.duration() + 30) and getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - High TTD]") return true end
        end
        -- Azerite Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=time>30&target.time_to_die>cooldown.guardian_of_azeroth.duration+30
        if cast.able.guardianOfAzeroth() and (combatTime > 30 and ttd("target") > cd.guardianOfAzeroth.duration() + 30) then
            if cast.guardianOfAzeroth() then debug("Cast Guardian Of Azeroth [CD - High TTD]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains>target.time_to_die
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (talent.darkSoulInstability
            and cd.darkSoulInstability.remain() > ttd("target")) and getDistance("target") <= 30
        then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - Dark Soul]") return true end
        end
        -- Azerite Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=cooldown.summon_infernal.remains>target.time_to_die
        if cast.able.guardianOfAzeroth() and (cd.summonInfernal.remain() > ttd("target")) then
            if cast.guardianOfAzeroth() then debug("Cast Guardian Of Azeroth [CD - Infernal]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=cooldown.summon_infernal.remains>target.time_to_die&pet.infernal.remains<20.5
        if cast.able.darkSoulInstability() and (cd.summonInfernal.remain() > ttd("target")
            and infernalRemain < 20.5)
        then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD - Infernal]") return true end
        end
        -- Azerite Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=cooldown.summon_infernal.remains>target.time_to_die&(pet.infernal.remains<15.5|buff.dark_soul_instability.up&soul_shard<3)
        if cast.able.memoryOfLucidDreams() and (cd.summonInfernal.remain() > ttd("target")
            and (infernalRemain < 15.5 or buff.darkSoulInstability.exists() and shards < 3))
        then
            if cast.memoryOfLucidDreams() then debug("Cast Memory Of Lucid Dreams [CD - Infernal]") return true end
        end
        -- Summon Infernal
        -- summon_infernal,if=target.time_to_die<30
        if br.timer:useTimer("Infernal Delay", 2) and ui.checked("Summon Infernal") and (ttd("target") < 30) and getDistance("target") <= 30 then
            if cast.summonInfernal(nil,"aoe",1,8) then infernalCast = GetTime() debug("Cast Summon Infernal [CD - Low TTD]") return true end
        end
        -- Azerite Essence - Guardian of Azeroth
        -- guardian_of_azeroth,if=target.time_to_die<30
        if cast.able.guardianOfAzeroth() and (ttd("target") < 30) then
            if cast.guardianOfAzeroth() then debug("Cast Guardian Of Azeroth [CD - Low TTD]") return true end
        end
        -- Dark Soul: Instability
        -- dark_soul_instability,if=target.time_to_die<21&target.time_to_die>4
        if cast.able.darkSoulInstability() and (ttd("target") < 21 and ttd("target") > 4) then
            if cast.darkSoulInstability() then debug("Cast Dark Soul Instability [CD - Low TTD]") return true end
        end
        -- Azerite Essence - Memory of Lucid Dreams
        -- memory_of_lucid_dreams,if=target.time_to_die<16&target.time_to_die>6
        if cast.able.memoryOfLucidDreams() and (ttd("target") < 16 and ttd("target") > 6) then
            if cast.memoryOfLucidDreams() then debug("Cast Memory of Lucid Dreams [CD - Low TTD]") return true end
        end
        -- Azerite Essence - Blood of the Enemy
        -- blood_of_the_enemy
        if cast.able.bloodOfTheEnemy() then
            if cast.bloodOfTheEnemy() then debug("Cast Blood of the Enemy [CD]") return true end
        end
        -- Azerite Essence - Worldvein Resonance
        -- worldvein_resonance
        if cast.able.worldveinResonance() then
            if cast.worldveinResonance() then debug("Cast Worldvein Resonance [CD]") return true end
        end
        -- Azerite Essence - Ripple in Space
        -- ripple_in_space
        if cast.able.rippleInSpace() then
            if cast.rippleInSpace() then debug("Cast Ripple In Space [CD]") return true end
        end
        -- Potion
        -- -- potion,if=pet.infernal.active|target.time_to_die<30
        -- if cast.able.potion() and (pet.infernal.active or ttd(units.dyn40) < 30) then
        --     if cast.potion() then return true end
        -- end
        -- Racial - Troll
        -- berserking,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() and (not talent.grimoireOfSupremacy
            or (not essence.memoryOfLucidDreams.major or buff.memoryOfLucidDreams.remain())
            and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
            or ttd("target") <= 15 and race == "Troll")
        then
            if cast.racial() then debug("Cast Berserking [CD]") return true end
        end
        -- Racial - Orc
        -- blood_fury,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() and (not talent.grimoireOfSupremacy
            or (not essence.memoryOfLucidDreams.major or buff.memoryOfLucidDreams.remain())
            and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
            or ttd("target") <= 15 and race == "Orc")
        then
            if cast.racial() then debug("Cast Blood Fury [CD]") return true end
        end
        -- Racial - Dark Iron Dwarf
        -- fireblood,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|(!essence.memory_of_lucid_dreams.major|buff.memory_of_lucid_dreams.remains)&(!talent.dark_soul_instability.enabled|buff.dark_soul_instability.remains))|target.time_to_die<=15
        if ui.checked("Racial") and cast.able.racial() and (pet.infernal.active() and (not talent.grimoireOfSupremacy
            or (not essence.memoryOfLucidDreams.major or buff.memoryOfLucidDreams.remain())
            and (not talent.darkSoulInstability or buff.darkSoulInstability.remain()))
            or ttd("target") <= 15 and race == "DarkIronDwarf")
        then
            if cast.racial() then debug("Cast Fireblood [CD]") return true end
        end
        -- Item - General
        -- use_items,if=pet.infernal.active&(!talent.grimoire_of_supremacy.enabled|pet.infernal.remains<=20)|target.time_to_die<=20
        if ui.checked("Trinkets") then
            local mainHand = GetInventorySlotInfo("MAINHANDSLOT")
            if canUseItem(mainHand) and equiped.neuralSynapseEnhancer(mainHand) then
                use.slot(mainHand)
                br.addonDebug("Using Neural Synapse Enhancer")
            end
            for i = 13, 14 do
                if use.able.slot(i) and not (equiped.azsharasFontOfPower(i) or equiped.pocketSizedComputationDevice(i)
                    or equiped.rotcrustedVoodooDoll(i) or equiped.shiverVenomRelic(i) or equiped.aquipotentNautilus(i)
                    or equiped.tidestormCodex(i) or equiped.vialOfStorms(i)) and ((pet.infernal.active()
                    and (not talent.grimoireOfSupremacy or infernalRemain <= 20)) or ttd("target") <= 20)
                then
                    if use.slot(i) then debug("Using Trinket in slot "..i.." [CD]") return true end
                end
            end
        end
        -- Item - Pocketsized Computation Device
        -- use_item,name=pocketsized_computation_device,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.pocketSizedComputationDevice() and debuff.immolate.remain() >= 20
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.pocketSizedComputationDevice() then debug("Using Pocket Sized Computation Device: Cyclotronic Blast [CD]") return true end
        end
        -- Item - Rotcrusted Voodoo Doll
        -- use_item,name=rotcrusted_voodoo_doll,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.rotcrustedVoodooDoll() and debuff.immolate.remain() >= 5
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.rotcrustedVoodooDoll() then debug("Using Rotcrusted Voodoo Doll [CD]") return true end
        end
        -- Item - Shiver Venom Relic
        -- use_item,name=shiver_venom_relic,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.shiverVenomRelic() and debuff.immolate.remain() >= 5
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.shiverVenomRelic() then debug("Using Shiver Venom Relic [CD]") return true end
        end
        -- Item - Aquipotent Nautilus
        -- use_item,name=aquipotent_nautilus,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.aquipotentNautilus() and debuff.immolate.remain() >= 5
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.aquipotentNautilus() then debug("Using Aquipotent Nautilus [CD]") return true end
        end
        -- Item - Tidestorm Codex
        -- use_item,name=tidestorm_codex,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.tidestormCodex() and debuff.immolate.remain() >= 5
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.tidestormCodex() then debug("Using Tidestorm Codex [CD]") return true end
        end
        -- Item - Vial of Storms
        -- use_item,name=vial_of_storms,if=dot.immolate.remains>=5&(cooldown.summon_infernal.remains>=20|target.time_to_die<30)
        if ui.checked("Trinkets") and equiped.vialOfStorms() and debuff.immolate.remain() >= 5
            and (cd.summonInfernal.remain() >= 20 or ttd("target") < 30)
        then
            if use.vialOfStorms() then debug("Using Vial Of Storms [CD]") return true end
        end
    end
end

-- Action List - Aoe
actionList.Aoe = function()
    -- Rain Of Fire
    -- rain_of_fire,if=pet.infernal.active&(buff.crashing_chaos.down|!talent.grimoire_of_supremacy.enabled)&(!cooldown.havoc.ready|active_enemies>3)
    if (pet.infernal.active()
        and (not buff.crashingChaos.exists() or not talent.grimoireOfSupremacy)
        and (cd.havoc.exists())) and getDistance("target") <= 40
    then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [AOE - Infernal]") return true end
    end

    -- Channel Demonfire
    -- channel_demonfire,if=dot.immolate.remains>cast_time
    if not moving and cast.able.channelDemonfire() and (debuff.immolate.remain("target") > cast.time.channelDemonfire()) then
        if cast.channelDemonfire() then debug("Cast Channel Demonfire [AOE]") return true end
    end

    -- Immolate
    -- immolate,cycle_targets=1,if=remains<5&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
    if not moving and cast.able.immolate() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if okToDoT and UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and  (debuff.immolate.remain(thisUnit) <= 10 and (not ui.checked("Cataclysm") or not talent.cataclysm 
            or cd.cataclysm.remain() > debuff.immolate.remain(thisUnit))) 
            then
                if not GetUnitIsUnit(thisUnit,br.lastImmo) then
                    if cast.immolate(thisUnit) then debug("Cast Immolate [AOE]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                else
                    if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 6.5 then
                        if cast.immolate(thisUnit) then debug("Cast Immolate [AOE Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                    end
                end
            end
        end
    end

    -- Call Action List - Cooldowns
    -- call_action_list,name=cds
    if actionList.Cooldowns() then return true end

    -- Havoc
    -- havoc,cycle_targets=1,if=!(target=self.target)&active_enemies<4
    if cast.able.havoc() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if ttd(thisUnit) > 10 and (not (GetUnitIsUnit("target",thisUnit)) and #enemies.yards40f < 4) then
                if cast.havoc(thisUnit) then debug("Cast Havoc [AOE - Less than 4]") return true end
            end
        end
    end

    -- Chaos Bolt
    -- chaos_bolt,if=talent.grimoire_of_supremacy.enabled&pet.infernal.active&(havoc_active|talent.cataclysm.enabled|talent.inferno.enabled&active_enemies<4)
    if not moving and #enemies.yards8t < ui.value("Rain of Fire")  and cast.timeSinceLast.chaosBolt() > gcdMax
        and (talent.grimoireOfSupremacy and (pet.infernal.active() or not useCDs())
        and (debuff.havoc.count() > 0  or talent.cataclysm or talent.inferno and #enemies.yards40 < 4))
    then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [AOE]") return true end
    end

    -- Rain of Fire
    -- rain_of_fire
    if ui.checked("Rain of Fire") and getDistance("target") <= 40 and #enemies.yards8t >= ui.value("Rain of Fire") then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [AOE]") return true end
    end

    -- Azerite Essence - Focused Azerite Beam
    -- focused_azerite_beam
    if essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remains() <= gcdMax and ((essence.focusedAzeriteBeam.rank < 3 and not moving) 
        or essence.focusedAzeriteBeam.rank >= 3) and getFacing("player","target") and (getEnemiesInRect(10,25,false,false) >= 3 or (useCDs() and (getEnemiesInRect(10,40,false,false) >= 1 or (getDistance("target") < 6 and isBoss("target")))))
    then
        if cast.focusedAzeriteBeam() then br.addonDebug("Casting Focused Azerite Beam") return end
    end

    -- Azerite Essence - Purifying Blath
    -- purifying_blast
    if cast.able.purifyingBlast() then
        if cast.purifyingBlast() then debug("Cast Purifying Blast [AOE]") return true end
    end

    -- Havoc
    -- havoc,cycle_targets=1,if=!(target=self.target)&(!talent.grimoire_of_supremacy.enabled|!talent.inferno.enabled|talent.grimoire_of_supremacy.enabled&pet.infernal.remains<=10)
    if cast.able.havoc() then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            if ttd(thisUnit) > 10 and (not (GetUnitIsUnit("target",thisUnit)) and (not talent.grimoireOfSupremacy
                or not talent.inferno or talent.grimoireOfSupremacy and infernalRemain <= 10))
            then
                if cast.havoc(thisUnit) then debug("Cast Rain Of Fire [AOE]") return true end
            end
        end
    end

    -- Incinerate
    -- incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up&soul_shard<5-0.2*active_enemies
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax
        and (talent.fireAndBrimstone and buff.backdraft.exists() and shards < 5 - 0.2 * #enemies.yards40f)
    then
        if cast.incinerate() then debug("Cast Incinerate [AOE - Fire And Brimstone]") return true end
    end

    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [AOE]") return true end
    end

    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down
    if cast.able.conflagrate() and (not buff.backdraft.exists()) then
        if cast.conflagrate() then debug("Cast Conflagrate [AOE]") return true end
    end

    -- Shadowburn
    -- shadowburn,if=!talent.fire_and_brimstone.enabled
    if cast.able.shadowburn() and (not talent.fireAndBrimstone) then
        if cast.shadowburn() then debug("Cast Shadowburn [AOE]") return true end
    end

    -- Azerite Essence - Concentrated Flame
    -- concentrated_flame,if=!dot.concentrated_flame_burn.remains&!action.concentrated_flame.in_flight&active_enemies<5
    if cast.able.concentratedFlame() and (not debuff.concentratedFlame.remain("target")
        and not cast.last.concentratedFlame() and #enemies.yards40f < 5)
    then
        if cast.concentratedFlame() then debug("Cast Concentrated Flame [AOE]") return true end
    end

    -- Incinerate
    -- incinerate
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
        if cast.incinerate() then debug("Cast Incinerate [AOE]") return true end
    end
end

-- Action List - GosupInfernal
actionList.GosupInfernal = function()
    -- Rain of Fire
    -- rain_of_fire,if=soul_shard=5&!buff.backdraft.up&buff.memory_of_lucid_dreams.up&buff.grimoire_of_supremacy.stack<=10
    if ui.checked("Rain of Fire") and #enemies.yards8t >= ui.value("Rain of Fire")
        and (shards == 5 and not buff.backdraft.exists() and buff.memoryOfLucidDreams.exists()
        and buff.grimoireOfSupremacy.stack() <= 10) and getDistance("target") <= 40
    then
        if br.timer:useTimer("RoF Delay", 1) and cast.rainOfFire(nil,"aoe",1,8,true) then debug("Cast Rain Of Fire [GosupInfernal]") return true end
    end

    -- Chaos Bolt
    -- chaos_bolt,if=buff.backdraft.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (buff.backdraft.exists()) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Backdraft]") return true end
    end

    -- chaos_bolt,if=soul_shard>=4.2-buff.memory_of_lucid_dreams.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (shards >= 4.2 - lucidDreams) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - High Shards]") return true end
    end

    -- chaos_bolt,if=!cooldown.conflagrate.up
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (not cd.conflagrate.exists()) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Conflagrate]") return true end
    end

    -- chaos_bolt,if=cast_time<pet.infernal.remains&pet.infernal.remains<cast_time+gcd
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
        and (cast.time.chaosBolt() < infernalRemain and infernalRemain < cast.time.chaosBolt() + gcdMax)
    then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [GosupInfernal - Infernal]") return true end
    end

    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down&buff.memory_of_lucid_dreams.up&soul_shard>=1.3
    if cast.able.conflagrate() and (not buff.backdraft.exists()
        and buff.memoryOfLucidDreams.exists() and shards >= 1.3)
    then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - Lucid Dreams]") return true end
    end

    -- conflagrate,if=buff.backdraft.down&!buff.memory_of_lucid_dreams.up&(soul_shard>=2.8|charges_fractional>1.9&soul_shard>=1.3)
    if cast.able.conflagrate() and (not buff.backdraft.exists() and not buff.memoryOfLucidDreams.exists()
        and (shards >= 2.8 or charges.conflagrate.frac() > 1.9 and shards >= 1.3))
    then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - High Charges]") return true end
    end

    -- conflagrate,if=pet.infernal.remains<5
    if cast.able.conflagrate() and (infernalRemain < 5) then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - Infernal Low]") return true end
    end
    
    -- conflagrate,if=charges>1
    if cast.able.conflagrate() and (charges.conflagrate.count() > 1) then
        if cast.conflagrate() then debug("Cast Conflagrate [GosupInfernal - More Than 1 Charge]") return true end
    end

    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [GosupInfernal]") return true end
    end

    -- Shadowburn
    -- shadowburn
    if cast.able.shadowburn() then
        if cast.shadowburn() then debug("Cast Shadowburn [GosupInfernal]") return true end
    end

    -- Incinerate
    -- incinerate
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
        if cast.incinerate() then debug("Cast Incinerate [GosupInfernal]") return true end
    end
end

-- Action List - Havoc
actionList.Havoc = function()
    -- Conflagrate
    -- conflagrate,if=buff.backdraft.down&soul_shard>=1&soul_shard<=4
    if cast.able.conflagrate() and ((not buff.backdraft.exists() or charges.conflagrate.count() == 2)
        and shards >= 1 and shards <= 4)
    then
        if cast.conflagrate() then debug("Cast Conflagrate [Havoc]") return true end
    end
    -- Immolate
    -- immolate,if=talent.internal_combustion.enabled&remains<duration*0.5|!talent.internal_combustion.enabled&refreshable
    if not moving and UnitHealth("target") >= immoTick and ttd("target") >= 9 and cast.able.immolate() and okToDoT and not cast.last.immolate()
        and (talent.internalCombustion and debuff.immolate.remain("target") < debuff.immolate.duration() * 0.5
            or not talent.internalCombustion and debuff.immolate.refresh("target"))
    then
        if cast.immolate() then debug("Cast Immolate [Havoc]") return true end
    end
    -- Chaos Bolt
    -- chaos_bolt,if=cast_time<havoc_remains
    if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax and (cast.time.chaosBolt() < havocRemain) then
        if cast.chaosBolt() then debug("Cast Chaos Bolt [Havoc]") return true end
    end
    -- Soul Fire
    -- soul_fire
    if not moving and cast.able.soulFire() then
        if cast.soulFire() then debug("Cast Soul Fire [Havoc]") return true end
    end
    -- Shadowburn
    -- shadowburn,if=active_enemies<3|!talent.fire_and_brimstone.enabled
    if cast.able.shadowburn() and (#enemies.yards40 < 3 or not talent.fireAndBrimstone) then
        if cast.shadowburn() then debug("Cast Shadowburn [Havoc]") return true end
    end
    -- Incinerate
    -- incinerate,if=cast_time<havoc_remains
    if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax and (cast.time.incinerate() < havocRemain) then
        if cast.incinerate() then debug("Cast Incinerate [Havoc]") return true end
    end
end

-- Action List - Opener
actionList.Opener = function()

end

-- Action List - PreCombat
actionList.PreCombat = function()
    if ui.checked("Fel Domination") and inCombat and not GetObjectExists("pet") or UnitIsDeadOrGhost("pet") and cd.felDomination.remain() <= gcdMax then
        if cast.felDomination() then br.addonDebug("Fel Domination") return true end
    end
    -- Summon Pet
    -- summon_pet
    if ui.checked("Pet Management") 
    and not (IsFlying() or IsMounted()) 
    and (not inCombat or buff.felDomination.exists())
    and (not moving or buff.felDomination.exists())
    and GetTime() - br.pauseTime > 0.5 and level >= 5
        and br.timer:useTimer("summonPet", 1)and not moving
    then
        if mode.petSummon == 5 and pet.active.id() ~= 0 then
            PetDismiss()
        end
        if (pet.active.id() == 0 or pet.active.id() ~= summonId) and (lastSpell ~= castSummonId
            or pet.active.id() ~= summonId or pet.active.id() == 0)
        then
            if mode.petSummon == 1 then
                if cast.summonImp("player") then castSummonId = spell.summonImp return true end
            elseif mode.petSummon == 2 then
                if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker return true end
            elseif mode.petSummon == 3 then
                if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter return true end
            elseif mode.petSummon == 4  then
                if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus return true end
            end
        end
    end

    if solo then
        -- Burning Rush
        if buff.burningRush.exists() and not moving or buff.burningRush.exists() and php <= ui.value("Burning Rush Health") then RunMacroText("/cancelaura Burning Rush") br.addonDebug("Canceling Burning Rush") return true end 

        if mode.burningRush ~= 2 and br.timer:useTimer("Burning Rush Delay", getOptionValue("Burning Rush Delay")) and moving and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end

        if mode.burningRush == 3 and br.timer:useTimer("Burning Rush Delay", getOptionValue("Burning Rush Delay")) and not buff.burningRush.exists() and php > ui.value("Burning Rush Health") + 5 then if cast.burningRush() then br.addonDebug("Casting Burning Rush") return true end end
    end  

    --if UnitChannelInfo("player") == GetSpellInfo(spell.healthFunnel) and php >= ui.value ("Health Funnel Cancel Cast") then SpellStopCasting() return true end 
    --if UnitChannelInfo("player") == GetSpellInfo(spell.drainLife) and php >= ui.value("Drain Life Cancel Cast") then SpellStopCasting() return true end


        if not moving and not inCombat and isChecked("Soulstone") and getOptionValue("Soulstone") == 7 then -- Player
            if not UnitIsDeadOrGhost("player") and not moving and not inCombat then
                if cast.soulstone("player") then br.addonDebug("Casting Soulstone [Player]" ) return true end
            end
        end

        -- Create Healthstone
        if not moving and not inCombat and ui.checked("Create Healthstone") then
            if GetItemCount(5512) < 1 and br.timer:useTimer("CH", 5) then
                if cast.createHealthstone() then br.addonDebug("Casting Create Healthstone" ) return true end
            end
         end

    if not inCombat and isValidUnit("target") and getDistance("target") < 40 and getFacing("player","target") then
        -- Grimoire Of Sacrifice
        -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
        if cast.able.grimoireOfSacrifice() and (talent.grimoireOfSacrifice) then
            if cast.grimoireOfSacrifice() then debug("Cast Grimoire Of Sacrifice [Pre-Pull]") return true end
        end

        -- Pre-Pot
        -- potion
        -- Soul Fire
        -- soul_fire
        if not moving and talent.soulFire and cast.able.soulFire() and not cast.last.soulFire()  then
            if cast.soulFire("target") then debug("Cast Soul Fire [Pre-Pull]") return true end
        end

        -- Incinerate
        -- incinerate,if=!talent.soul_fire.enabled
        if not moving and not talent.soulFire and br.timer:useTimer("incDelay", 2.0) then
            if cast.incinerate("target") then debug("Cast Incinerate [Pre-Pull]") return true end
        end

        -- Conflagrate
        if moving and cast.able.conflagrate() and (not talent.soulFire) and not cast.last.conflagrate() then
            if cast.conflagrate("target") then debug("Cast Conflagrate [Pre-Pull]") return true end
        end
    end
end


actionList.ST = function()
    -- Havoc
    -- call_action_list,name=havoc,if=havoc_active&active_enemies<5-talent.inferno.enabled+(talent.inferno.enabled&talent.internal_combustion.enabled)
            if debuff.havoc.count() > 0 and #enemies.yards40f < 5 - inferno + internalInferno then
                if actionList.Havoc() then return true end
            end

        if level < 60 then
            -- Decimating Bolt
            if spellUsable(313347) and select(2,GetSpellCooldown(313347)) <= gcdMax and not moving and ttd("target") < 15 then if CastSpellByName(GetSpellInfo(313347)) then return true end end 

                -- Kyrian: Scouring Tithe
            if spellUsable(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax  and not moving and ttd(thisUnit) < 18 and shards >= 4.5 and debuff.havoc.exists(thisUnit) then if CastSpellByName(GetSpellInfo(313347),thisUnit) then return true end end 
        end
           
            -- Curse of Weakness
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ui.checked("Curse of Weakness") and ttd(thisUnit) >= 6 and not UnitIsDeadOrGhost(thisUnit) and isMelee(thisUnit) and GetObjectExists(thisUnit) and UnitCanAttack(thisUnit,"player") and UnitIsPlayer(thisUnit) then 
                        if cast.curseOfWeakness(thisunit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                    return true
                        end
                    end
                end

            -- Curse of Tongues
            for i = 1, #enemies.yards40f do
                local unit = enemies.yards40f[i]
                if ui.checked("Curse of Tongues") and ttd(unit) >= 6 and not UnitIsDeadOrGhost(unit) and isMelee(thisUnit)and GetObjectExists(unit) and UnitCanAttack(unit,"player") and UnitIsPlayer(unit) then
                    if cast.curseOfTongues(unit) then 
                    --br.addonDebug("[Action:PvP] Curse of Tongues" .. " | Name: " .. name .. " | Class: ".. class .. " | Level:" .. UnitLevel(unit) .. " | Race: " .. select(1,UnitRace(unit))) 
                    return true
                    end
                end
            end


            -- Cataclysm
            -- cataclysm,if=!(pet.infernal.active&dot.immolate.remains+1>pet.infernal.remains)|spell_targets.cataclysm>1|!talent.grimoire_of_supremacy.enabled
            if br.timer:useTimer("Cata Delay", 2) and mode.cataclysm == 1 and ui.checked("Cataclysm") and not moving and cd.cataclysm.remain() <= gcdMax and (not (pet.infernal.active()
            and debuff.immolate.remain("target") + 1 > infernalRemain) or (#enemies.yards8t >= ui.value("Cataclysm Units")
            or (useCDs() and ui.checked("Ignore Cataclysm units when using CDs"))) or not talent.grimoireOfSupremacy)
            then
                if ui.value("Cataclysm Target") == 1 then
                    if ui.checked("Predict Movement (Cata)") then
                        if cast.cataclysm("target","ground",1,8,true) then
                            debug("Cast Catacylsm [Main - Target Predict]") return true
                        end
                    elseif not moving or targetMoveCheck then
                        if cast.cataclysm("target", "ground") then
                            debug("Cast Catacylsm [Main - Target]") return true
                        end
                    end
                elseif ui.value("Cataclysm Target") == 2 then
                    if useCDs() and ui.checked("Ignore Cataclysm units when using CDs") then
                        if ui.checked("Predict Movement (Cata)") then
                            if cast.cataclysm("best",false,1,8,true) then
                                debug("Cast Catacylsm [Main - Best Single Predict]") return true
                            end
                        else
                            if cast.cataclysm("best",false,1,8) then
                                debug("Cast Catacylsm [Main - Best Single]") return true
                            end
                        end
                    else
                        if ui.checked("Predict Movement (Cata)") then
                            if cast.cataclysm("best",false,ui.value("Cataclysm Units"),8,true) then
                                debug("Cast Catacylsm [Main - Best Min Predict]") return true
                            end
                        else
                            if cast.cataclysm("best",false,ui.value("Cataclysm Units"),8) then
                                debug("Cast Catacylsm [Main - Best Min]") return true
                            end
                        end
                    end
                end
                --if cast.cataclysm() then debug("Cast Cataclysm [Main]") return true end
            end

            -- Call Action List - AOE
            -- call_action_list,name=aoe,if=active_enemies>2
            if ((mode.rotation == 1 and #enemies.yards40f >= ui.value("Multi-Target Units")) or (mode.rotation == 2 and #enemies.yards40f > 0)) then
                if actionList.Aoe() then return true end
            end

            -- Immolate
            -- immolate,cycle_targets=1,if=refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
            if not moving and cast.able.immolate() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if okToDoT and UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and (debuff.immolate.remain(thisUnit) < 6 and (not ui.checked("Cataclysm") or not talent.cataclysm 
                    or cd.cataclysm.remain() > debuff.immolate.remain(thisUnit) or #enemies.yards8t < ui.value("Cataclysm Units"))) 
                    then
                        if not GetUnitIsUnit(thisUnit,br.lastImmo) then
                            if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                        else
                            if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 4.5 then
                                if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                            end
                        end
                    end
                end
            end

            -- Immolate
            -- immolate,cycle_targets=1,if=refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
          --[[ if not moving and cast.able.immolate() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if okToDoT and UnitHealth(thisUnit) >= immoTick and ttd(thisUnit) >= 9 and (debuff.corruption.remains(thisUnit) < 7) 
                    then
                        if not GetUnitIsUnit(thisUnit,br.lastImmo) then
                            if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                        else
                            if br.lastImmoCast == nil or GetTime() - br.lastImmoCast > 4.5 then
                                if cast.immolate(thisUnit) then debug("Cast Immolate [Main - Multi Same Target]") br.lastImmo = thisUnit; br.lastImmoCast = GetTime() return true end
                            end
                        end
                    end
                end
            end--]]



            -- immolate,if=talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains<duration*0.5
            if not moving and UnitHealth("target") >= immoTick and ttd("target") >= 9 and cast.able.immolate() and okToDoT and not cast.last.immolate() and (talent.internalCombustion
                and cast.inFlight.chaosBolt() and debuff.immolate.remain("target") < debuff.immolate.duration() * 0.5)
            then
                if cast.immolate() then debug("Cast Immolate [Main]") return true end
            end

            -- Call Action List - Cooldowns
            -- call_action_list,name=cds
            if actionList.Cooldowns() then return true end
            -- focused_azerite_beam,if=!pet.infernal.active|!talent.grimoire_of_supremacy.enabled
            if essence.focusedAzeriteBeam.active and cd.focusedAzeriteBeam.remains() <= gcdMax and ((essence.focusedAzeriteBeam.rank < 3 and not moving) 
                or essence.focusedAzeriteBeam.rank >= 3) and getFacing("player","target") and (getEnemiesInRect(10,25,false,false) >= 3 or (useCDs() and (getEnemiesInRect(10,40,false,false) >= 1 or (getDistance("target") < 6 and isBoss("target")))))
                and (not pet.infernal.active() or not talent.grimoireOfSupremacy)
            then
                if cast.focusedAzeriteBeam() then br.addonDebug("Casting Focused Azerite Beam") return end
            end

            -- Azerite Essence - The Unbound Force
            -- the_unbound_force,if=buff.reckless_force.react
            if cast.able.theUnboundForce() and (buff.recklessForce.exists()) then
                if cast.theUnboundForce() then debug("Cast The Unbound Force") return true end
            end

            -- Azerite Essence - Purifying Blast
            -- purifying_blast
            if cast.able.purifyingBlast() then
                if cast.purifyingBlast() then debug("Cast Purifying Blast") return true end
            end
            if essence.reapingFlames.active and cd.reapingFlames.remain() <= gcdMax then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    local thisHP = getHP(thisUnit)
                    if ((essence.reapingFlames.rank >= 2 and thisHP > 80) or thisHP <= 20 or getTTD(thisUnit,20) > 30) then
                        if cast.reapingFlames(thisUnit) then debug("Casting Reaping Flames") return true end
                    end
                end
            end

            -- Azerite Essence - Concentrated Flame
            -- concentrated_flame,if=!dot.concentrated_flame_burn.remains&!action.concentrated_flame.in_flight
            if essence.concentratedFlame.active and php < 50 and cd.concentratedFlame.remain() <= gcdMax then
                if cast.concentratedFlame("player") then debug("Cast Concentrated Flame (Heal)") return true end
            end
            if essence.concentratedFlame.active and not debuff.concentratedFlame.exists("target") and cd.concentratedFlame.remains() <= gcdMax then
                if cast.concentratedFlame("target") then debug("Cast Concentrated Flame") return true end
            end

            
            --actions.covenant=impending_catastrophe,if=cooldown.summon_darkglare.remains<10|cooldown.summon_darkglare.remains>50
            ---------------------------0--------------------
            -- Impending Catastrophe : Venthyr -------------
            ------------------------------------------------
            --321792
            if not moving and spellUsable(321792) and IsSpellKnown(321792) and select(2,GetSpellCooldown(321792)) <= gcdMax then
                if CastSpellByName(GetSpellInfo(321792)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end


            --actions.covenant+=/decimating_bolt,if=cooldown.summon_darkglare.remains>5&(debuff.haunt.remains>4|!talent.haunt.enabled)
            ---------------------------0--------------------
            -- Decimating Bolt : Necrolord -----------------
            ------------------------------------------------
            if not moving and spellUsable(325289) and IsSpellKnown(325289) and select(2,GetSpellCooldown(325289)) <= gcdMax then
                if CastSpellByName(GetSpellInfo(325289)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end


            --actions.covenant+=/soul_rot,if=cooldown.summon_darkglare.remains<5|cooldown.summon_darkglare.remains>50|cooldown.summon_darkglare.remains>25&conduit.corrupting_leer.enabled
            ------------------------------------------------
            -- Soul Rot : Night Fae ------------------------
            ------------------------------------------------
            if useCDs() and not moving and spellUsable(325640) and IsSpellKnown(325640) and select(2,GetSpellCooldown(325640)) <= gcdMax then
                if CastSpellByName(GetSpellInfo(325640)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end

            ------------------------------------------------
            -- Scouring Tithe : Kyrian ---------------------
            ------------------------------------------------
            if not moving and spellUsable(312321) and IsSpellKnown(312321) and select(2,GetSpellCooldown(312321)) <= gcdMax then
                if CastSpellByName(GetSpellInfo(312321)) then br.addonDebug("[Action:Rotation] Soul Rot (SOul Rot Active)") return true end
            end


            -- Channel Demonfire
            -- channel_demonfire
            if not moving and cast.able.channelDemonfire() then
                if cast.channelDemonfire() then debug("Cast Channel Demonfire [Main]") return true end
            end

            -- Havoc
            -- havoc,cycle_targets=1,if=!(target=self.target)&(dot.immolate.remains>dot.immolate.duration*0.5|!talent.internal_combustion.enabled)&(!cooldown.summon_infernal.ready|!talent.grimoire_of_supremacy.enabled|talent.grimoire_of_supremacy.enabled&pet.infernal.remains<=10)
            if cast.able.havoc() then
                for i = 1, #enemies.yards40f do
                    local thisUnit = enemies.yards40f[i]
                    if ttd(thisUnit) > 10 and (not (GetUnitIsUnit("target",thisUnit))
                        and (debuff.immolate.remain(thisUnit) > debuff.immolate.duration() * 0.5 
                        or not talent.internalCombustion) and (cd.summonInfernal.exists()
                        or not talent.grimoireOfSupremacy or talent.grimoireOfSupremacy and infernalRemain <= 10))
                    then
                        if cast.havoc(thisUnit) then debug("Cast Havoc [Main - Multi]") return true end
                    end
                end
            end

            -- Call Action List - Gosup Infernal
            -- call_action_list,name=gosup_infernal,if=talent.grimoire_of_supremacy.enabled&pet.infernal.active
            if talent.grimoireOfSupremacy and pet.infernal.active() then
                if actionList.GosupInfernal() then return true end
            end

            -- Soul Fire
            -- soul_fire
            if not moving and cast.able.soulFire() then
                if cast.soulFire() then debug("Cast Soul Fire [Main]") return true end
            end

            -- Conflagrate
            -- conflagrate,if=buff.backdraft.down&soul_shard>=1.5-0.3*talent.flashover.enabled&!variable.pool_soul_shards
            if cast.able.conflagrate() and ((not buff.backdraft.exists() or charges.conflagrate.count() == 2)
                and shards >= 1.5 - 0.3 * flashover and not poolShards)
            then
                if cast.conflagrate() then debug("Cast Conflagrate [Main]") return true end
            end

            -- Shadow Burn
            -- shadowburn,if=soul_shard<2&(!variable.pool_soul_shards|charges>1)
            if cast.able.shadowburn() and (shards < 2 and (not poolShards or charges.shadowburn.count() > 1)) then
                if cast.shadowburn() then debug("Cast Shadowburn [Main]") return true end
            end

            -- Chaos Bolt
            -- chaos_bolt,if=(talent.grimoire_of_supremacy.enabled|azerite.crashing_chaos.enabled)&pet.infernal.active|buff.dark_soul_instability.up|buff.reckless_force.react&buff.reckless_force.remains>cast_time
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and ((talent.grimoireOfSupremacy or traits.crashingChaos.active) and pet.infernal.active() 
                or buff.darkSoulInstability.exists() or buff.recklessForce.exists()
                and buff.recklessForce.remain() > cast.time.chaosBolt())
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Supremacy or Crashing Chaos]") return true end
            end

            -- chaos_bolt,if=buff.backdraft.up&!variable.pool_soul_shards&!talent.eradication.enabled
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and (buff.backdraft.exists() and not poolShards and not talent.eradication)
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Backdraft]") return true end
            end

            -- chaos_bolt,if=!variable.pool_soul_shards&talent.eradication.enabled&(debuff.eradication.remains<cast_time|buff.backdraft.up)
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and (not poolShards and talent.eradication
                and (debuff.eradication.remain("target") < cast.time.chaosBolt() or buff.backdraft.exists()))
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - Eradiaction]") return true end
            end

            -- chaos_bolt,if=(soul_shard>=4.5-0.2*active_enemies)&(!talent.grimoire_of_supremacy.enabled|cooldown.summon_infernal.remains>7)
            if not moving  and cast.timeSinceLast.chaosBolt() > gcdMax
                and ((shards >= 4.5 - 0.2 * #enemies.yards40f)
                and (not talent.grimoireOfSupremacy or (cd.summonInfernal.remain() > 7 or not useCDs())))
            then
                if cast.chaosBolt() then debug("Cast Chaos Bolt [Main - High Shards]") return true end
            end

            -- Conflagrate
            -- conflagrate,if=charges>1
            if cast.able.conflagrate() and (charges.conflagrate.count() > 1) then
                if cast.conflagrate() then debug("Cast Conflagrate [Main - More Than 1]") return true end
            end

            -- Incinerate
            -- incinerate
            if not moving and cast.able.incinerate() and cast.timeSinceLast.incinerate() > gcdMax then
                if cast.incinerate() then debug("Cast Incinerate [Main]") return true end
            end
end


-- Action List - PreCombat
actionList.Rotation = function()


    if SpellQueueReady() then

       if actionList.ST() then return true end 

    end


end


----------------
--- ROTATION ---
----------------
local function runRotation()
    --------------------------------------
    --- Load Additional Rotation Files ---
    --------------------------------------
    if actionList.PetManagement == nil then
        loadSupport("PetCuteOne")
        actionList.PetManagement = br.rotations.support["PetCuteOne"]
    end

    --------------
    --- Locals ---
    --------------
    -- BR API
    buff                               = br.player.buff
    cast                               = br.player.cast
    cd                                 = br.player.cd
    charges                            = br.player.charges
    debuff                             = br.player.debuff
    debug                              = br.addonDebug
    enemies                            = br.player.enemies
    equiped                            = br.player.equiped
    essence                            = br.player.essence
    flying, swimming, moving           = IsFlying(), IsSwimming(), GetUnitSpeed("player")>0
    gcdMax                             = br.player.gcdMax
    has                                = br.player.has
    healPot                            = getHealthPot()
    inCombat                           = br.player.inCombat
    inInstance                         = br.player.instance=="party"
    inRaid                             = br.player.instance=="raid"
    item                               = br.player.items
    level                              = br.player.level
    mode                               = br.player.ui.mode
    opener                             = br.player.opener
    ui                                 = br.player.ui
    pet                                = br.player.pet
    php                                = br.player.health

    pullTimer                          = PullTimerRemain()
    race                               = br.player.race
    racial                             = br.player.getRacial()
    shards                             = br.player.power.soulShards.frac()
    spell                              = br.player.spell
    talent                             = br.player.talent
    traits                             = br.player.traits
    ttd                                = getTTD
    units                              = br.player.units
    use                                = br.player.use

    -- General API
    combatTime                         = getCombatTime()
    flashover                          = talent.flashover and 1 or 0
    inferno                            = talent.inferno and 1 or 0
    internalInferno                    = (talent.inferno and talent.internalCombustion) and 1 or 0
    lastSpell                          = lastSpellCast
    lucidDreams                        = buff.memoryOfLucidDreams.exists() and 1 or 0
    summonPet                          = ui.value("Summon Pet")
    
    -- Get Best Unit for Range
    -- units.get(range, aoe)
    units.get(40)
    if range == nil then range = {} end
    range.dyn40 = getDistance("target") < 40
    
    -- Get List of Enemies for Range
    -- enemies.get(range, from unit, no combat, variable)
    enemies.get(8,"target")
    enemies.get(30)
    enemies.get(40)
    enemies.get(40,"player",true) -- makes enemies.yards40nc
    enemies.get(40,"player",false,true) -- makes enemies.yards40f
    
    -- General Vars
    if leftCombat == nil then leftCombat = GetTime() end
    if profileStop == nil then profileStop = false end
    if not inCombat and not UnitExists("target") and profileStop == true then
        profileStop = false
    end
    okToDoT = debuff.immolate.count() < ui.value("Multi-Dot Limit")
    
    -- spellqueue ready
    local function SpellQueueReady()
        --Check if we can queue cast
        local castingInfo = {UnitCastingInfo("player")}
        if castingInfo[5] then
            if (GetTime() - ((castingInfo[5] - tonumber(C_CVar.GetCVar("SpellQueueWindow")))/1000)) < 0 then
                return false
            end
        end
        return true
    end
  
    -- SimC Variables
    -- Pool Shards
    -- variable,name=pool_soul_shards,value=active_enemies>1&cooldown.havoc.remains<=10|cooldown.summon_infernal.remains<=15&(talent.grimoire_of_supremacy.enabled|talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15)|talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15&(cooldown.summon_infernal.remains>target.time_to_die|cooldown.summon_infernal.remains+cooldown.summon_infernal.duration>target.time_to_die)
    poolShards =  #enemies.yards40 > 1 and cd.havoc.remain() <= 10 or cd.summonInfernal.remain() <= 15
        and (talent.grimoireOfSupremacy or talent.darkSoulInstability and cd.darkSoulInstability.remain() <= 15)
            or talent.darkSoulInstability and cd.darkSoulInstability.remain() <= 15
            and (cd.summonInfernal.remain() > ttd("target") or cd.summonInfernal.remain() +
            cd.summonInfernal.duration() > ttd("target"))
    
    -- Pet Data
    if mode.petSummon == 1 and HasAttachedGlyph(spell.summonImp) then summonId = 58959
    elseif mode.petSummon == 1 then summonId = 416
    elseif mode.petSummon == 2 and HasAttachedGlyph(spell.summonVoidwalker) then summonId = 58960
    elseif mode.petSummon == 2 then summonId = 1860
    elseif mode.petSummon == 3 then summonId = 417
    elseif mode.petSummon == 4 then summonId = 1863 end
    if talent.grimoireOfSacrifice then petPadding = 5 end

    infernalRemain = max(0,(infernalCast + 30) - GetTime())

    if #enemies.yards40f > 0 then
        for i = 1, #enemies.yards40f do
            local thisUnit = enemies.yards40f[i]
            local thisRemain = debuff.havoc.remain(thisUnit)
            if thisRemain > havocRemain then
                havocRemain = thisRemain
            end
        end
    end

    ---Target move timer
    if lastTargetX == nil then lastTargetX, lastTargetY, lastTargetZ = 0,0,0 end
    targetMoveCheck = targetMoveCheck or false
    if br.timer:useTimer("targetMove", 0.8) or combatTime < 0.2 then
        if GetObjectExists("target") then
            local currentX, currentY, currentZ = GetObjectPosition("target")
            local targetMoveDistance = math.sqrt(((currentX-lastTargetX)^2)+((currentY-lastTargetY)^2)+((currentZ-lastTargetZ)^2))
            lastTargetX, lastTargetY, lastTargetZ = GetObjectPosition("target")
            if targetMoveDistance < 3 then targetMoveCheck = true else targetMoveCheck = false end
        end
    end

    -- ChatOverlay("Shards: "..tostring(shards))

    ---------------------
    --- Begin Profile ---
    ---------------------
    -- Profile Stop | Pause
    if not inCombat and not UnitExists("target") and profileStop==true then
        profileStop = false
    elseif inCombat and IsAoEPending() then
        SpellStopTargeting()
        br.addonDebug("Canceling Spell")
        return false
    elseif (inCombat and profileStop==true) or pause() or mode.rotation==4 then
        br.pauseTime = GetTime()
        return true
    else

        -----------------
        --- Pet Logic ---
        -----------------
        if actionList.PetManagement() then return true end
        -----------------------
        --- Extras Rotation ---
        -----------------------
        if actionList.Extras() then return true end
        --------------------------
        --- Defensive Rotation ---
        --------------------------
        if actionList.Defensive() then return true end
        ------------------------------
        --- Out of Combat Rotation ---
        ------------------------------
        if actionList.PreCombat() then return true end
        --------------------------
        --- In Combat Rotation ---
        --------------------------
        if inCombat and isValidUnit("target") then
            if actionList.Interrupts() then return true end
            if isChecked("Shadowfury Key") and SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus() then
                if CastSpellByName(GetSpellInfo(spell.shadowfury),"cursor") then br.addonDebug("Casting Shadow Fury") return end 
            end


            if actionList.Rotation() then return true end 

        end -- End Combat
    end -- End Rotation Logic
end -- End Rotation File
local id = 267
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
