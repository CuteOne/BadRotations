if select(3, UnitClass("player")) == 1 then

function WarriorArmsConfig()
if currentConfig ~= "Arms Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Arms |cffFF0000Chumii");

-- Wrapper
CreateNewWrap(thisConfig,"---------- Keys ----------");

-- Pause Toggle
CreateNewCheck(thisConfig,"Pause Toggle");
CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle")
CreateNewText(thisConfig,"Pause Key");

-- Single/Multi Toggle Up
CreateNewCheck(thisConfig,"Rotation Up","Switch through Rotation Mode (Single Target / Multi Target / Auto AoE)");
CreateNewDrop(thisConfig,"Rotation Up", 3, "Toggle")
CreateNewText(thisConfig,"Rotation Up");

-- Single/Multi Toggle Down
CreateNewCheck(thisConfig,"Rotation Down","Switch through Rotation Mode ( Auto AoE / Multi Target / Single Target)");
CreateNewDrop(thisConfig,"Rotation Down", 1, "Toggle")
CreateNewText(thisConfig,"Rotation Down");

--Cooldown Key Toggle
CreateNewCheck(thisConfig,"Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Cooldown Mode", 3, "Toggle")
CreateNewText(thisConfig,"Cooldowns");

--Defensive Key Toggle
CreateNewCheck(thisConfig,"Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Defensive Mode", 6, "Toggle")
CreateNewText(thisConfig,"Defensive");

--Interrupts Key Toggle
CreateNewCheck(thisConfig,"Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Interrupt Mode", 6, "Toggle")
CreateNewText(thisConfig,"Interrupts");

-- Heroic Leap
CreateNewCheck(thisConfig,"HeroicLeapKey");
CreateNewDrop(thisConfig,"HeroicLeapKey", 2, "Toggle")
CreateNewText(thisConfig,"Heroic Leap Key");

-- Wrapper
CreateNewWrap(thisConfig,"---------- Buffs ---------");

-- Shout
CreateNewCheck(thisConfig,"Shout");
CreateNewDrop(thisConfig, "Shout", 2, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
CreateNewText(thisConfig,"Shout");

-- Wrapper
CreateNewWrap(thisConfig,"------ Cooldowns ------");

-- Potion
CreateNewCheck(thisConfig,"usePot");
CreateNewText(thisConfig,"Use Potion");

-- Bloodbath
CreateNewCheck(thisConfig,"useBloodbath");
CreateNewText(thisConfig,"Bloodbath");

-- Recklessness
CreateNewCheck(thisConfig,"useRecklessness");
CreateNewText(thisConfig,"Recklessness");

-- Avatar
CreateNewCheck(thisConfig,"useAvatar");
CreateNewText(thisConfig,"Avatar");

-- Racial
CreateNewCheck(thisConfig,"useRacial");
CreateNewText(thisConfig,"Racial (Orc / Troll)");

-- Wrapper
CreateNewWrap(thisConfig,"------- Defensive ------");

-- Die by the Sword
CreateNewCheck(thisConfig,"DiebytheSword");
CreateNewBox(thisConfig, "DiebytheSword", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword");
CreateNewText(thisConfig,"DiebytheSword");

-- Rallying Cry
CreateNewCheck(thisConfig,"RallyingCry");
CreateNewBox(thisConfig, "RallyingCry", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry");
CreateNewText(thisConfig,"RallyingCry");

-- Enraged Regeneration
CreateNewCheck(thisConfig,"EnragedRegeneration");
CreateNewBox(thisConfig, "EnragedRegeneration", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration");
CreateNewText(thisConfig,"Enraged Regeneration");

-- ImpendingVictory/Victory Rush
CreateNewCheck(thisConfig,"ImpendingVictory");
CreateNewBox(thisConfig, "ImpendingVictory", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)");
CreateNewText(thisConfig,"Impending Victory");

-- Vigilance Focus
CreateNewCheck(thisConfig,"VigilanceFocus");
CreateNewBox(thisConfig, "VigilanceFocus", 0, 100  , 5, 25, "% HP of Focustarget to use Vigilance on Focustarget");
CreateNewText(thisConfig,"Vigilance on Focus");

-- Def Stance
CreateNewCheck(thisConfig,"DefensiveStance");
CreateNewBox(thisConfig, "DefensiveStance", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDefensive Stance");
CreateNewText(thisConfig,"DefensiveStance");

-- Healthstone
CreateNewCheck(thisConfig,"Healthstone");
CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
CreateNewText(thisConfig,"Healthstone");

-- Wrapper
CreateNewWrap(thisConfig,"-------- Interrupts --------");

-- Pummel
CreateNewCheck(thisConfig,"Pummel");
CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
CreateNewText(thisConfig,"Pummel");

-- Disrupting Shout
CreateNewCheck(thisConfig,"Disrupting Shout");
CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.");
CreateNewText(thisConfig,"Disrupting Shout");

if isKnown(QuakingPalm) then
-- Quaking Palm
CreateNewCheck(thisConfig,"Quaking Palm");
CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
CreateNewText(thisConfig,"Quaking Palm");
end

-- Wrapper
CreateNewWrap(thisConfig,"---------- Misc -----------");

-- Auto Bladestorm / DragonRoar Single Target
CreateNewCheck(thisConfig,"StormRoarST","Dragonroar automatically in Single Target Rotation");
CreateNewText(thisConfig,"Dragonroar ST")

-- Auto Bladestorm / DragonRoar Multi Target
CreateNewCheck(thisConfig,"StormRoar","Use Bladestorm/Dragonroar automatically in Multi Target Rotation");
CreateNewText(thisConfig,"Bladestorm/Dragonroar")

-- Dummy DPS Test
CreateNewCheck(thisConfig,"DPS Testing");
CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
CreateNewText(thisConfig,"DPS Testing");

-- Show more
CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
CreateNewText(thisConfig,"Show More");

-- Healing/general/poke/hacks/tracking
if isChecked("Showmore") == true then
CreateGeneralsConfig();
WrapsManager();
end

end
end

function WarriorFuryConfig()
if currentConfig ~= "Fury Avery/Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Fury Warrior");

-- Wrapper
CreateNewWrap(thisConfig,"Buffs");

-- battle Shout
CreateNewCheck(thisConfig,"Battle","Check if you want to use Battle Shout out of combat");
CreateNewText(thisConfig,"Battle Shout");

--commanding shout
CreateNewCheck(thisConfig,"Commanding","Check if you want to use Commanding Shout out of combat and in the rotation");
CreateNewText(thisConfig,"Commanding Shout");

-- Wrapper
CreateNewWrap(thisConfig,"Cooldowns");

-- Recklessness
CreateNewCheck(thisConfig,"Recklessness","Check if you want to use Recklessness automatically");
CreateNewDrop(thisConfig, "Recklessness", 1, "Use Recklessness always or on boss", "Always", "Boss")
CreateNewText(thisConfig,"Recklessness");

-- SkullBanner
CreateNewCheck(thisConfig,"SkullBanner","Check if you want to use Skull Banner automatically");
CreateNewDrop(thisConfig, "SkullBanner", 1, "Use Skull Banner always or on boss", "Always", "Boss")
CreateNewText(thisConfig,"SkullBanner");

-- Racial
CreateNewCheck(thisConfig,"Racials","Check if you want to use Racials automatically");
CreateNewDrop(thisConfig, "Racials", 1, "Use Racial always or on boss", "Always", "Boss")
CreateNewText(thisConfig,"Racials");

-- Gloves
CreateNewCheck(thisConfig,"Gloves","Check if you want to use Gloves automatically");
CreateNewDrop(thisConfig, "Gloves", 1, "Use Gloves always or on boss", "Always", "Boss")
CreateNewText(thisConfig,"Gloves");

--Shattering Throw
CreateNewCheck(thisConfig,"Shattering Throw","Check if you want to use Shattering Throw in the rotation");
CreateNewText(thisConfig,"Shattering Throw");

-- Wrapper
CreateNewWrap(thisConfig,"Talents");

-- DragonRoar
CreateNewCheck(thisConfig,"DragonRoar","Check if you want to use dragon roar manually - left alt");
CreateNewText(thisConfig,"Dragon Roar");

-- Bladestorm
CreateNewCheck(thisConfig,"Bladestorm","Check if you want to use bladestorm manually - left alt");
CreateNewText(thisConfig,"Bladestorm");

--single target bladestorm
CreateNewCheck(thisConfig,"STBladestorm","Check if you want to enable single target bladestorm");
CreateNewText(thisConfig,"STBladestorm");

-- Wrapper
CreateNewWrap(thisConfig,"Defensives");

--def stance
CreateNewCheck(thisConfig,"DefensiveStance");
CreateNewBox(thisConfig, "DefensiveStance", 0, 100  , 5, 25, "Under what %HP to use Defensive Stance");
CreateNewText(thisConfig,"DefensiveStance");

-- Die by the Sword
CreateNewCheck(thisConfig,"DiebytheSword");
CreateNewBox(thisConfig, "DiebytheSword", 0, 100  , 5, 50, "Under what %HP to use Die by the Sword");
CreateNewText(thisConfig,"DiebytheSword");

-- Shield Wall
CreateNewCheck(thisConfig,"ShieldWall");
CreateNewBox(thisConfig, "ShieldWall", 0, 100  , 5, 30, "Under what %HP to use Shield Wall");
CreateNewText(thisConfig,"ShieldWall");

-- Healthstone
CreateNewCheck(thisConfig,"Healthstone","Check if you want to use Healthstones automatically");
CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 40, "What %HP to use Healthstone");
CreateNewText(thisConfig,"Healthstone");

-- Wrapper
CreateNewWrap(thisConfig,"Utilities");

-- Charge
CreateNewCheck(thisConfig,"Charge","Check if you want to use charge when out of range");
CreateNewText(thisConfig,"Charge");

--Heroic Leap
CreateNewCheck(thisConfig,"HeroicLeap","Check if you want to use the heroic leap key, middle mouse button");
CreateNewText(thisConfig,"Heroic Leap");

-- Wrapper
CreateNewWrap(thisConfig,"Interrupts");

-- Pummel
CreateNewCheck(thisConfig,"Pummel","Check if you want to use Pummel automatically");
CreateNewText(thisConfig,"Pummel");

-- Disrupting Shout
CreateNewCheck(thisConfig,"Disrupting Shout","Check if you want to use Disrupting Shout automatically");
CreateNewText(thisConfig,"Disrupting Shout");

if isKnown(QuakingPalm) then
-- Quaking Palm
CreateNewCheck(thisConfig,"Quaking Palm","Check if you want to use Quaking Palm automatically");
CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 25 , "Over what % of cast we want to Quaking Palm.");
CreateNewText(thisConfig,"Quaking Palm");
end

CreateNewCheck(thisConfig,"Interrupt Mode","Toggle to turn interrupts on or off");
CreateNewDrop(thisConfig,"Interrupt Mode", 5, "Toggle")
CreateNewText(thisConfig,"Interrupt Tog.");

-- Wrapper
CreateNewWrap(thisConfig,"AoE");

--automatic aoe
CreateNewCheck(thisConfig,"AutoAoE","Check if you want to use automatic AoE, tarplus/minus wont do anything until you toggle this off");
CreateNewText(thisConfig,"Auto AoE");

-- tar+
CreateNewCheck(thisConfig,"Rotation Up","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
CreateNewDrop(thisConfig,"Rotation Up", 1, "Toggle")
CreateNewText(thisConfig,"Tar Plus");

-- tar-
CreateNewCheck(thisConfig,"Rotation Down","Switch through Rotation Modes (1 target/2 targets/3 targets/4+targets)");
CreateNewDrop(thisConfig,"Rotation Down", 2, "Toggle")
CreateNewText(thisConfig,"Tar Minus");

-- Wrapper
CreateNewWrap(thisConfig,"Other");

--CreateNewCheck(thisConfig,"MouseClick","Check if you want to have the mouse click when you have a clickable spell up, ex: demo banner, raid markers");
--CreateNewText(thisConfig,"Mouse Click");

--autoface
CreateNewCheck(thisConfig,"Autoface","Check if you want to enable auto facing the target");
CreateNewText(thisConfig,"Autoface");

--autotarget
CreateNewCheck(thisConfig,"Autotarget","Check if you want to enable auto targeting");
CreateNewText(thisConfig,"Autotarget");

--disable vehicle check
CreateNewCheck(thisConfig,"Vehicle","Check if you want to disable vehicle checking, fights like raigonn, klaxxi");
CreateNewText(thisConfig,"Disable Vehicle Check");

--showmore
CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
CreateNewText(thisConfig,"Show More");

-- Healing/general/poke/hacks/tracking
if isChecked("Showmore") == true then
CreateGeneralsConfig();
WrapsManager();
end

end
end

function WarriorProtConfig()
if currentConfig ~= "Protection Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Protection |cffFF0000Chumii");

-- Wrapper
CreateNewWrap(thisConfig,"---------- Keys ----------");

-- Pause Toggle
CreateNewCheck(thisConfig,"Pause Toggle");
CreateNewDrop(thisConfig,"Pause Toggle", 4, "Toggle2")
CreateNewText(thisConfig,"Pause Key");

-- Single/Multi Toggle Up
CreateNewCheck(thisConfig,"Rotation Up","Switch through Rotation Mode (Single Target / Multi Target / Auto AoE)");
CreateNewDrop(thisConfig,"Rotation Up", 3, "Toggle2")
CreateNewText(thisConfig,"Rotation Up");

-- Single/Multi Toggle Down
CreateNewCheck(thisConfig,"Rotation Down","Switch through Rotation Mode ( Auto AoE / Multi Target / Single Target)");
CreateNewDrop(thisConfig,"Rotation Down", 1, "Toggle2")
CreateNewText(thisConfig,"Rotation Down");

--Cooldown Key Toggle
CreateNewCheck(thisConfig,"Cooldown Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFCooldown Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Cooldown Mode", 3, "Toggle2")
CreateNewText(thisConfig,"Cooldowns");

--Defensive Key Toggle
CreateNewCheck(thisConfig,"Defensive Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFDefensive Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Defensive Mode", 6, "Toggle2")
CreateNewText(thisConfig,"Defensive");

--Interrupts Key Toggle
CreateNewCheck(thisConfig,"Interrupt Mode","|cff15FF00Enables|cffFFFFFF/|cffD60000Disable |cffFFFFFFInterrupt Mode Toggle Key|cffFFBB00.");
CreateNewDrop(thisConfig,"Interrupt Mode", 6, "Toggle2")
CreateNewText(thisConfig,"Interrupts");

-- Heroic Leap
CreateNewCheck(thisConfig,"HeroicLeapKey");
CreateNewDrop(thisConfig,"HeroicLeapKey", 2, "Toggle2")
CreateNewText(thisConfig,"Heroic Leap Key");

-- Mocking Banner
CreateNewCheck(thisConfig,"MockingBannerKey");
CreateNewDrop(thisConfig,"MockingBannerKey", 7, "Toggle2")
CreateNewText(thisConfig,"Mocking Banner Key");

-- Wrapper
CreateNewWrap(thisConfig,"---------- Buffs ---------");

-- Shout
CreateNewCheck(thisConfig,"Shout");
CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
CreateNewText(thisConfig,"Shout");

-- Wrapper
CreateNewWrap(thisConfig,"------ Cooldowns ------");

-- Recklessness
CreateNewCheck(thisConfig,"Recklessness");
CreateNewDrop(thisConfig, "Recklessness", 1, "Use Recklessness always or only on Boss/Dummy", "|cffFFBB00Always", "|cff0077FFBoss")
CreateNewText(thisConfig,"Recklessness");

-- SkullBanner
CreateNewCheck(thisConfig,"SkullBanner");
CreateNewDrop(thisConfig, "SkullBanner", 1, "Use Skull Banner always or only on Boss/Dummy", "|cffFFBB00Always", "|cff0077FFBoss")
CreateNewText(thisConfig,"SkullBanner");

-- Avatar
CreateNewCheck(thisConfig,"Avatar");
CreateNewDrop(thisConfig, "Avatar", 1, "Use Avatar always or only on Boss/Dummy", "|cffFFBB00Always", "|cff0077FFBoss")
CreateNewText(thisConfig,"Avatar");

-- Racial
CreateNewCheck(thisConfig,"Racial");
CreateNewDrop(thisConfig, "Racial", 1, "Use Racial always or only on Boss/Dummy", "|cffFFBB00Always", "|cff0077FFBoss")
CreateNewText(thisConfig,"Racial (Orc / Troll)");

-- Wrapper
CreateNewWrap(thisConfig,"------- Defensive ------");

-- Shield Block / Barrier
CreateNewDrop(thisConfig, "BlockBarrier", 1, "Use Shield Block or Shield Barrier", "|cffFFBB00Block", "|cff0077FFBarrier")
CreateNewText(thisConfig,"Block or Barrier");

-- Last Stand
CreateNewCheck(thisConfig,"LastStand");
CreateNewBox(thisConfig, "LastStand", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFLast Stand");
CreateNewText(thisConfig,"Last Stand");

-- Rallying Cry
CreateNewCheck(thisConfig,"RallyingCry");
CreateNewBox(thisConfig, "RallyingCry", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry");
CreateNewText(thisConfig,"Rallying Cry");

-- Shield Wall
CreateNewCheck(thisConfig,"ShieldWall");
CreateNewBox(thisConfig, "ShieldWall", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield Wall");
CreateNewText(thisConfig,"Shield Wall");

-- Enraged Regeneration
CreateNewCheck(thisConfig,"EnragedRegeneration");
CreateNewBox(thisConfig, "EnragedRegeneration", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFEnraged Regeneration");
CreateNewText(thisConfig,"Enraged Regeneration");

-- ImpendingVictory/Victory Rush
CreateNewCheck(thisConfig,"ImpendingVictory");
CreateNewBox(thisConfig, "ImpendingVictory", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFImpending Victory (Victory Rush)");
CreateNewText(thisConfig,"Impending Victory");

-- Healthstone
CreateNewCheck(thisConfig,"Healthstone");
CreateNewBox(thisConfig, "Healthstone", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFHealthstone");
CreateNewText(thisConfig,"Healthstone");

-- Safeguard Focus
CreateNewCheck(thisConfig,"SafeguardFocus");
CreateNewBox(thisConfig, "SafeguardFocus", 0, 100  , 5, 25, "% HP of Focustarget to Safeguard at Focustarget");
CreateNewText(thisConfig,"Safeguard at Focus");

-- Vigilance Focus
CreateNewCheck(thisConfig,"VigilanceFocus");
CreateNewBox(thisConfig, "VigilanceFocus", 0, 100  , 5, 25, "% HP of Focustarget to use Vigilance on Focustarget");
CreateNewText(thisConfig,"Vigilance on Focus");

-- Wrapper
CreateNewWrap(thisConfig,"-------- Interrupts --------");

-- Pummel
CreateNewCheck(thisConfig,"Pummel");
CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFPummel.");
CreateNewText(thisConfig,"Pummel");

-- Disrupting Shout
CreateNewCheck(thisConfig,"Disrupting Shout");
CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 60 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFDisrupting Shout.");
CreateNewText(thisConfig,"Disrupting Shout");

if isKnown(QuakingPalm) then
-- Quaking Palm
CreateNewCheck(thisConfig,"Quaking Palm");
CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 30 , "|cffFFBB00Over what % of cast we want to \n|cffFFFFFFQuaking Palm.");
CreateNewText(thisConfig,"Quaking Palm");
end

-- Wrapper
CreateNewWrap(thisConfig,"---------- Misc -----------");

-- Auto Bladestorm / DragonRoar
CreateNewCheck(thisConfig,"StormRoar","Use Bladestorm/Dragonroar automatically");
CreateNewText(thisConfig,"Auto Bladestorm/Dragonroar")

-- Charge
CreateNewCheck(thisConfig,"Charge");
CreateNewText(thisConfig,"Charge");

-- Dummy DPS Test
CreateNewCheck(thisConfig,"DPS Testing");
CreateNewBox(thisConfig,"DPS Testing", 1, 15, 1, 5, "Set to desired time for test in minutes. Min: 1 / Max: 15 / Interval: 1");
CreateNewText(thisConfig,"DPS Testing");

-- Show more
CreateNewCheck(thisConfig,"Showmore","Check if you want the options for Healing/General/Poke/Hacks/Tracking - Reload after checking");
CreateNewText(thisConfig,"Show More");

-- Healing/general/poke/hacks/tracking
if isChecked("Showmore") == true then
CreateGeneralsConfig();
WrapsManager();
end
end
end
end
