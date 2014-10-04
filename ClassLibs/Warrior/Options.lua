if select(3, UnitClass("player")) == 1 then

function WarriorArmsConfig()
if currentConfig ~= "Arms Avery/Chumii" then
ClearConfig();
thisConfig = 0;
-- Title
CreateNewTitle(thisConfig,"Arms |cffFF0000Avery/Chumii");

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

-- Heroic Leap
CreateNewCheck(thisConfig,"HeroicLeapKey");
CreateNewDrop(thisConfig,"HeroicLeapKey", 2, "Toggle2")
CreateNewText(thisConfig,"Heroic Leap Key");

-- Wrapper 
CreateNewWrap(thisConfig,"---------- Buffs ---------");

-- Shout
CreateNewCheck(thisConfig,"Shout");
CreateNewDrop(thisConfig, "Shout", 1, "Choose Shout to use.", "|cffFFBB00Command", "|cff0077FFBattle")
CreateNewText(thisConfig,"Shout");

-- Shout OOC
CreateNewCheck(thisConfig, "ShoutOOC","Uncheck this if you want to use the selected Shout only while in combat");
CreateNewText(thisConfig, "Shout out of Combat");

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

-- Die by the Sword
CreateNewCheck(thisConfig,"DiebytheSword");
CreateNewBox(thisConfig, "DiebytheSword", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFDie by the Sword");
CreateNewText(thisConfig,"DiebytheSword");

-- Rallying Cry
CreateNewCheck(thisConfig,"RallyingCry");
CreateNewBox(thisConfig, "RallyingCry", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRallying Cry");
CreateNewText(thisConfig,"RallyingCry");

-- Shield Wall
CreateNewCheck(thisConfig,"ShieldWall");
CreateNewBox(thisConfig, "ShieldWall", 0, 100  , 5, 25, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFShield Wall");
CreateNewText(thisConfig,"ShieldWall");

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

-- Bladestorm ST
CreateNewCheck(thisConfig, "AutoBladestorm","Uncheck if you want to cast Bladestorm manually in Single Target Rotation");
CreateNewText(thisConfig, "Bladestorm Single Target");

-- DragonRoar ST
CreateNewCheck(thisConfig, "AutoDragonRoar","Uncheck if you want to cast Dragon Roar manually in Single Target Rotation");
CreateNewText(thisConfig, "Dragon Roar Single Target");

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
CreateNewBox(thisConfig, "Pummel", 0, 100  , 5, 25 , "Over what % of cast we want to Pummel.");
CreateNewText(thisConfig,"Pummel");

-- Disrupting Shout
CreateNewCheck(thisConfig,"Disrupting Shout","Check if you want to use Disrupting Shout automatically");
CreateNewBox(thisConfig, "Disrupting Shout", 0, 100  , 5, 25 , "Over what % of cast we want to Disrupting Shout.");
CreateNewText(thisConfig,"Disrupting Shout");

if isKnown(QuakingPalm) then
-- Quaking Palm
CreateNewCheck(thisConfig,"Quaking Palm","Check if you want to use Quaking Palm automatically");
CreateNewBox(thisConfig, "Quaking Palm", 0, 100  , 5, 25 , "Over what % of cast we want to Quaking Palm.");
CreateNewText(thisConfig,"Quaking Palm");   
end    

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
--CreateNewCheck(thisConfig,"Autoface","Check if you want to enable auto facing the target");
--CreateNewText(thisConfig,"Autoface");

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

-- Heroic Leap
CreateNewCheck(thisConfig,"HeroicLeapKey");
CreateNewDrop(thisConfig,"HeroicLeapKey", 2, "Toggle2")
CreateNewText(thisConfig,"Heroic Leap Key");

-- Demo Banner
CreateNewCheck(thisConfig,"DemoBannerKey");
CreateNewDrop(thisConfig,"DemoBannerKey", 5, "Toggle2")
CreateNewText(thisConfig,"Demo Banner Key");

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

-- Shout OOC
CreateNewCheck(thisConfig, "ShoutOOC","Uncheck this if you want to use the selected Shout only while in combat");
CreateNewText(thisConfig, "Shout out of Combat");

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
