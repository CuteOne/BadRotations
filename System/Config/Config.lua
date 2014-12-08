
    
function CreateGeneralsConfig()
    --[[
	local myClassColor = classColors[select(3,UnitClass("player"))].hex

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"- |cffFF0011Enemies Engine "..myClassColor.."-")

    CreateNewText(thisConfig,"|cff63A4FFEngine"..myClassColor)

    -- exclude unsafe units
    CreateNewCheck(thisConfig,"Safe Damage Check","Check to prevent damage to targets you dont want to attack.",1)
    CreateNewText(thisConfig,"Safe Damage Check")

    -- Dont break CCs
    CreateNewCheck(thisConfig,"Don't break CCs","Check to prevent damage to targets that are CC.",1)
    CreateNewText(thisConfig,"Don't break CCs")

    CreateNewText(thisConfig,"|cff63A4FFDynamic Target"..myClassColor)

    -- allow dynamic targetting
    CreateNewCheck(thisConfig,"Dynamic Targetting", "|cffFFDD11Check if you want to use Dynamic Targetting, if unchecked only target will be attacked.", 1)
    CreateNewText(thisConfig,"Dynamic Targetting")

    -- enforce burn targets
    CreateNewCheck(thisConfig,"Wise Target", "|cffFFDD11Check if you want to use Wise Targetting, if unchecked, Target will be priorized.", 1)
    CreateNewDrop(thisConfig,"Wise Target", 1, "|cffFFDD11What would be your favorite target to damage on.", "|cffFF0000Lowest", "|cffFFDD11Highest")
    CreateNewText(thisConfig,"Wise Target")
    
    -- Allow Forced Burn
    CreateNewCheck(thisConfig,"Forced Burn","Check to allow forced Burn on specific units.",1)
    CreateNewText(thisConfig,"Forced Burn")

    -- Tank prio threat
    CreateNewCheck(thisConfig,"Tank Threat","Check add more priority to taregts you lost aggro on(tank only).",1)
    CreateNewText(thisConfig,"Tank Threat")


    CreateNewText(thisConfig,"|cff63A4FFInterrupts"..myClassColor)

    -- Interrupts Frame
    CreateNewCheck(thisConfig,"Interrupts Handler")
    CreateNewText(thisConfig,"Interrupts Handler")
    -- Interrupts Frame
    CreateNewCheck(thisConfig,"Interrupts Frame")
    CreateNewText(thisConfig,"Interrupts Frame")
    -- Only Known Units
    CreateNewCheck(thisConfig,"Only Known Units")
    CreateNewText(thisConfig,"Only Known Units")

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"- |cffFF0011Healing Engine "..myClassColor.."-")

    CreateNewText(thisConfig,"|cff63A4FFInclude Targets"..myClassColor)

    -- Heal Pets
    CreateNewCheck(thisConfig,"Heal Pets")
    CreateNewText(thisConfig,"Heal Pets")

    -- Special Heal
    CreateNewCheck(thisConfig,"Special Heal")
    CreateNewDrop(thisConfig,"Special Heal", 2, "|cffFFDD11Select wich targets you want to add to engine:Mouseover/Focus/Target Heal. \n|cffFF0000All: |cffFFDD11All targets. \n|cffFF0000Special: |cffFFDD11Only special Units.", "|cffFF0000All", "|cffFFDD11Special")
    CreateNewText(thisConfig,"Special Heal")

    CreateNewText(thisConfig,"|cff63A4FFSorting"..myClassColor)

    -- Sorting with the Role
    CreateNewCheck(thisConfig,"Sorting with Role","|cffFFBB00Sorting with the Role.")
    CreateNewText(thisConfig,"Sorting with Role")
    -- Special Priority
    CreateNewCheck(thisConfig,"Special Priority","|cffFFBB00Priorise Special targets.")
    CreateNewText(thisConfig,"Special Priority")

    CreateNewText(thisConfig,"|cff63A4FFUnit Health"..myClassColor)

    -- Blacklist
    CreateNewCheck(thisConfig,"Blacklist")
    CreateNewBox(thisConfig, "Blacklist", 0, 105  , 5, 105, "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list.")
    CreateNewText(thisConfig,"Blacklist")

    -- No Absorbs
    CreateNewCheck(thisConfig,"No Absorbs","Uncheck this if you want to prevent overhealing shielded units. If checked, it will add shieldBuffValue/4 to hp.")
    CreateNewText(thisConfig,"No Absorbs")

    -- No Incoming Heals
    CreateNewCheck(thisConfig,"No Incoming Heals","Uncheck this if you want to prevent overhealing units. If checked, it will add incoming health from other healers to hp.")
    CreateNewText(thisConfig,"No Incoming Heals")

    -- Overhealing Cancel Cast
    CreateNewCheck(thisConfig,"Overhealing Cancel")
    CreateNewBox(thisConfig, "Overhealing Cancel", 0, 200  , 5, 100, "|cffFFBB00Stop casting heal if target is going to have over this amount of HP after heal.")
    CreateNewText(thisConfig,"Overhealing Cancel")
    CreateNewText(thisConfig,"|cff63A4FFEngine"..myClassColor)

    -- Engine Debug
    CreateNewCheck(thisConfig,"Engine Debug")
    CreateNewText(thisConfig,"Engine Debug")

    -- Engine Refresh
    CreateNewCheck(thisConfig,"Engine Refresh")
    CreateNewBox(thisConfig, "Engine Refresh", 0, 1000  , 5, 0, "|cffFFBB00Time to wait before refreshing engine.")
    CreateNewText(thisConfig,"Engine Refresh")

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"- |cffFF0011General "..myClassColor.."-")

    CreateNewText(thisConfig,"|cff63A4FFAutomation goodies"..myClassColor)

    -- Auto-Sell/Repair
    CreateNewCheck(thisConfig,"Auto-Sell/Repair")
    CreateNewText(thisConfig,"Auto-Sell/Repair")

    -- Accept Queues
    CreateNewCheck(thisConfig,"Accept Queues")
    CreateNewText(thisConfig,"Accept Queues")


    -- Overlay Messages
    CreateNewCheck(thisConfig,"Overlay Messages", "|cffFFBB00Check this to enable Chat Overlay Messages.",1)
    CreateNewText(thisConfig,"Overlay Messages")

    CreateNewText(thisConfig,"|cff63A4FFDebug"..myClassColor)

    -- Debug
    CreateNewCheck(thisConfig,"Debug", "|cffFFBB00Check this to start |cffFFFFFFChat Debug |cffFFBB00of casted spells.")
    CreateNewText(thisConfig,"Debug")

    -- Debug Fail Casts
    CreateNewCheck(thisConfig,"Debug Fail Casts", "|cffFFBB00Check this to allow Fail Casts in |cffFFFFFFChat Debug.",1)
    CreateNewText(thisConfig,"Debug Fail Casts")

    CreateNewText(thisConfig,"|cff63A4FFcastSpell tweaks"..myClassColor)

    -- Latency Compensation
    CreateNewCheck(thisConfig,"Latency Compensation", "|cffFFBB00Check this to Compensate Latency in getSpellCD.",1)
    CreateNewText(thisConfig,"Latency Compensation")

     -- Allow Failcasts
    CreateNewCheck(thisConfig,"Allow Failcasts", "|cffFFBB00Check this to Allow Failcasts by skipping getSpellCD.",0)
    CreateNewText(thisConfig,"Allow Failcasts")

     -- Skip Distance Check
    CreateNewCheck(thisConfig,"Skip Distance Check", "|cffFFBB00Check this to Allow Skip Distance Check.",0)
    CreateNewText(thisConfig,"Skip Distance Check")

    CreateNewText(thisConfig,"|cff63A4FFOther features"..myClassColor)

    -- Auto Taunts
    CreateNewCheck(thisConfig,"Auto Taunts")
    CreateNewText(thisConfig,"Auto Taunts")

    -- Queue Casts
    CreateNewCheck(thisConfig,"Queues")
    CreateNewText(thisConfig,"Queue Casting")

    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"- |cffFF0011Profession Helper "..myClassColor.."-")

    -- Profession Helper
    CreateNewCheck(thisConfig,"useProfessionHelper", "Check to enable Profession Helper")
    CreateNewText(thisConfig,"Profession Helper")
    -- Loot Delay
    CreateNewBox(thisConfig,"LootDelay", 0, 10  , 1, 5, "Add delay for looting")
    CreateNewText(thisConfig,"Loot Delay")

    -- WoD Leather Scraps
    CreateNewCheck(thisConfig,"LeatherScraps")
    CreateNewText(thisConfig,"Leather Scraps")

    -- Mill WoD Herbs
    CreateNewCheck(thisConfig,"MillWoDHerbs", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Mill WoD Herbs")

    -- Mill MoP Herbs
    CreateNewCheck(thisConfig,"MillMoPHerbs", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Mill MoP Herbs")

    -- Mill Cata Herbs
    CreateNewCheck(thisConfig,"MillCataHerbs", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Mill Cata Herbs")

    -- Prospect WoD Ore
    CreateNewCheck(thisConfig,"ProspectWoDOre", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Prospect WoD Ore")

    -- Prospect MoP Ore
    CreateNewCheck(thisConfig,"ProspectMoPOre", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Prospect MoP Ore")

    -- Prospect Cata Ore
    CreateNewCheck(thisConfig,"ProspectCataOre", "Place any stack of Herbs that is not divisible by 5 as the last Stack of that kind of Herb in your bag.")
    CreateNewText(thisConfig,"Prospect Cata Ore")

    -- Disenchant JC Blues ilvl 415
    CreateNewCheck(thisConfig,"DisenchantMoPBluesJC", "Disenchant Crafted Jewelcrafting Neck/Ring ilvl 415")
    CreateNewText(thisConfig,"Dis JC MoP Blues")

    -- Disenchant JC Greens ilvl 384
    CreateNewCheck(thisConfig,"DisenchantMoPGreensJC", "Disenchant Crafted Jewelcrafting Neck/Ring ilvl 384")
    CreateNewText(thisConfig,"Dis JC MoP Greens")

    -- Disenchant Tailor Wrists ilvl 450
    CreateNewCheck(thisConfig,"DisenchantMoPBluesT", "Disenchant Crafted Tailor NWrists ilvl 450")
    CreateNewText(thisConfig,"Dis Tailor MoP Blues")

    -- Disenchant Tailor Wrists ilvl 384
    CreateNewCheck(thisConfig,"DisenchantMoPGreensT", "Disenchant Crafted Tailor Wrists ilvl 384")
    CreateNewText(thisConfig,"Dis Tailor MoP Greens")


    -- Wrapper -----------------------------------------
    CreateNewWrap(thisConfig,"- |cffFF0011PokeRotation "..myClassColor.."-")

    -- Poke Rotation
    CreateNewCheck(thisConfig,"PokeRotation", "|cffFFBB00Check this to start PokeRotation.")
    CreateNewText(thisConfig,"PokeRotation")

	CreateNewText(thisConfig,"In Battle")

	-- PetHeal Value
	CreateNewCheck(thisConfig,"Pet Heal")
	CreateNewBox(thisConfig, "Pet Heal", 1, 100  , 5, 60, "|cffFFBB00Set pet healing value")
	CreateNewText(thisConfig,"Pet Heal")

	-- Capture Value
	CreateNewCheck(thisConfig,"Pet Capture")
	CreateNewBox(thisConfig, "Pet Capture", 1, 4  , 1, 4, "|cffFFBB00Set pet Rarity Capture Treshold")
	CreateNewText(thisConfig,"Pet Capture")

	-- Number Of Pets Value
	CreateNewBox(thisConfig, "Number of Pets", 1, 3  , 1, 1, "|cffFFBB00Set number of pets of each kind to capture")
	CreateNewText(thisConfig,"Number of Pets")

	CreateNewText(thisConfig,"Out of Battle")

	--Revive Battle PetsValue
	CreateNewCheck(thisConfig,"Revive Battle Pets")
	CreateNewText(thisConfig,"Revive Battle Pets")

	--Auto Clicker Value
	CreateNewCheck(thisConfig,"Auto Clicker Range")
	CreateNewBox(thisConfig, "Auto Clicker Range", 0, 200  , 5, 30, "|cffFFBB00Set Auto Clicker range.")
	CreateNewText(thisConfig,"Auto Clicker Range")

	--Pet Leveling Value
	CreateNewCheck(thisConfig,"Pet Leveling")
	CreateNewBox(thisConfig, "Pet Leveling", 1, 25  , 1, 6, "|cffFFBB00Pet Leveling minimum pet level")
	CreateNewText(thisConfig,"Pet Leveling")

	--Pet Leveling Value
	CreateNewCheck(thisConfig,"Pet Leveling Max")
	CreateNewBox(thisConfig, "Pet Leveling Max", 1, 25  , 1, 6, "|cffFFBB00Pet Leveling maximum pet level")
	CreateNewText(thisConfig,"Pet Leveling Max")

	--Leveling Priority Value
	CreateNewCheck(thisConfig,"Leveling Priority")
	CreateNewDrop(thisConfig, "Leveling Priority", 1,"High" , "Low" , "HighWild", "LowWild")
	CreateNewText(thisConfig,"Leveling Priority")

	--Leveling Rarity Value
	CreateNewCheck(thisConfig,"Leveling Rarity")
	CreateNewBox(thisConfig, "Leveling Rarity", 1, 4  , 1, 4, "|cffFFBB00Set Leveling Rarity")
	CreateNewText(thisConfig,"Leveling Rarity")

	--Swap In Health Value
	CreateNewCheck(thisConfig,"Swap in Health")
	CreateNewBox(thisConfig, "Swap in Health", 1, 100  , 1, 60, "|cffFFBB00Minimum Health to Swap Pet in.")
	CreateNewText(thisConfig,"Swap in Health")

	--Swap Out Health Value
	CreateNewBox(thisConfig, "Swap Out Health", 1, 100  , 1, 30, "|cffFFBB00Set Swap Out Health Treshold")
	CreateNewText(thisConfig,"Swap Out Health")

	-- Pause Toggle
    CreateNewCheck(thisConfig,"Pause Toggle")
    CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle2")
    CreateNewText(thisConfig,"Pause Toggle")

   -- Bound
    CreateNewBound(thisConfig,"End")
    doneConfig = true ]]
end