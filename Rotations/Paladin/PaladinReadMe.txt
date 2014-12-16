Heres the Paladin layout:
All paladin stuff in Rotation/Paladin folder. This folder includes:

- Holy Folder
-- Functions.lua -- Functions specific to Holy
-- Options.lua -- Options for Holy
-- Spell List.lua -- Spells functions specific to Holy

- Protection folder
-- Functions.lua -- Functions specific to Protection
-- Options.lua -- Options for Protection
-- Spell List.lua -- Spells functions specific to Protection

- Retribution folder
-- Functions.lua -- Functions specific to Retribution
-- Options.lua -- Options for Retribution
-- Spell List.lua -- Spells functions specific to Retribution

Functions.lua -- General paladin functions -- ie: holy power calculation(include divine purp & holy avenger)
Options.lua -- General paladin options -- ie: we should place there the hands, wog, loh etc
SpellLits.lua -- Spells functions used by more than one class -- ie: we should place there the hands, wog, loh etc


-- BadBoy Paladins Profiles Informations

Current Status
Protection 	Raid ready/dynamic
Holy		Testing/polishing
Retribution	Raid ready/dynamic


Protection
Todos:
Continued Clean Up
* Healing Toggle:
	Currently there is 3 different options, no heal, heal self and heal all. However is there a option really to not heal?
	Eternal flame playstyle is at this stage most common way and we should always have the HoT on us. We should not use HP for the initial heal, that is more
	for the Word Of Glory healing. Enhancing current Eternal Flame would be to be able to cast the HoT on secondary target mainly or select prioritised targets.
	Doing a blanket style of healing is kind of overkill.

	The Word of Glory healing is more checking most injured and heal them if they are belov a threshold.
	Why are checking for more then 3 and not 5 stacks of Bastion?
Supported Playstyles