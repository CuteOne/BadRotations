if select(3, UnitClass("player")) == 5 then
	function ShadowConfig()
		bb.ui.window.profile = bb.ui:createProfileWindow("Shadow")
		local section

		--   _____            _     _
		--  / ____|          | |   | |
		-- | |     ___   ___ | | __| | _____      ___ __  ___
		-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
		-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
		--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
		section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3Offensive")
			-- bosscheck
			bb.ui:createCheckbox(section,"isBoss","use CDs only on Boss Units")
			-- Power Infusion
			bb.ui:createCheckbox(section,"PI","Power Infusion")
			-- Shadowfiend / Mindbender
			bb.ui:createCheckbox(section,"MB/SF","Mindbender / Shadowfiend")
		bb.ui:checkSectionState(section)


		--  _____        __               _
		-- |  __ \      / _|             (_)
		-- | |  | | ___| |_ ___ _ __  ___ ___   _____
		-- | |  | |/ _ \  _/ _ \ '_ \/ __| \ \ / / _ \
		-- | |__| |  __/ ||  __/ | | \__ \ |\ V /  __/
		-- |_____/ \___|_| \___|_| |_|___/_| \_/ \___|
		section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3Defensive")
			-- Power Word: Shield
			bb.ui:createSpinner(section,"PW:S",30,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Desperate Prayer
			bb.ui:createSpinner(section,"Desperate Prayer",25,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Fade with glyph
			bb.ui:createSpinner(section,"Fade",40,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade")
			-- Healing Tonic
			bb.ui:createSpinner(section,"Healing Tonic",25,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Dispersion
			bb.ui:createSpinner(section,"Dispersion",20,0,100,1,"|cffFFFFFFhealth percent to cast at")
		bb.ui:checkSectionState(section)


		--  ____                  _    _      _
		-- |  _ \                | |  | |    | |
		-- | |_) | ___  ___ ___  | |__| | ___| |_ __   ___ _ __
		-- |  _ < / _ \/ __/ __| |  __  |/ _ \ | '_ \ / _ \ '__|
		-- | |_) | (_) \__ \__ \ | |  | |  __/ | |_) |  __/ |
		-- |____/ \___/|___/___/ |_|  |_|\___|_| .__/ \___|_|
		--                                     | |
		--                                     |_|
		section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3Bosshelper")
			-- -- Gorefiend SWP
			-- bb.ui:createCheckbox(section,"Gorefiend SWP","SWP every Corrupted Soul in Mythic")
			-- -- Auto Guise
			-- bb.ui:createCheckbox(section,"Auto Guise","Auto Spectral Guise on: \nBRF: Iron Maidens")
			-- -- Auto Mass Dispel
			-- bb.ui:createCheckbox(section,"Auto Mass Dispel","Auto Mass Dispel on: \nBRF: Operator Thogar")
			-- -- Auto Dispel
			-- bb.ui:createCheckbox(section,"Auto Dispel", "Auto Dispel on: \nBRF: Blast Furnace")
			-- -- Auto Silence
			-- bb.ui:createCheckbox(section,"Auto Silence", "Auto Silence on: \nBRF: Blast Furnace\nBRF: Operator Thogar")
			-- -- Target Helper
			-- bb.ui:createCheckbox(section,"Target Helper", "Assists to target the correct unit")
			-- Dot Test
			bb.ui:createCheckbox(section,"Test Stuff", "Do not use this!\n - Archimonde: dot all dogs")
			-- Auto Burn
			bb.ui:createCheckbox(section,"AutoBurn", "Auto target burn defined units like doomfire on archimonde")
		bb.ui:checkSectionState(section)


		--  _____       _        _   _
		-- |  __ \     | |      | | (_)
		-- | |__) |___ | |_ __ _| |_ _  ___  _ __
		-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \
		-- | | \ \ (_) | || (_| | |_| | (_) | | | |
		-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_|
		section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3Rotation")
			-- Ignore orbs for SWD
			bb.ui:createCheckbox(section,"SWD ignore Orbs","use SWD despite 5 Orbs")
			-- Max Targets
			bb.ui:createSpinnerWithout(section,"max dot targets",4,0,10,1,"|cffFFFFFFnumber of running dots of each")
			-- Mind Sear / Searing Insanity Key
			bb.ui:createDropdown(section,"Burst SI",bb.dropOptions.Toggle2,3,"Burst Searing Insanity")
			-- ttd SWP
			bb.ui:createSpinnerWithout(section,"ttd swp",13.5,0,13.5,0.25,"|cffFFFFFFSWP TTD:\nstandard (simcraft): 13.5s\nCast SWP only on a unit that lives longer than chosen value.")
			-- ttd VT
			bb.ui:createSpinnerWithout(section,"ttd vt",11.25,0,11.25,0.25,"|cffFFFFFFSWP TTD:\nstandard (simcraft): 11.25s + castTime\nCast VT only on a unit that lives longer than chosen value.")
		bb.ui:checkSectionState(section)


			--   _____      _____  
			--  / ____|    |  __ \ 
			-- | |     ___ | |__) |
			-- | |    / _ \|  ___/ 
			-- | |___| (_) | |     
			--  \_____\___/|_|     
			section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3CoP")
				-- DPx
				bb.ui:createSpinnerWithout(section,"DPx",3,3,5,1,"DP on x Orbs")
				-- Auto Focus
				bb.ui:createCheckbox(section,"AutoFocus","Focus units on CoP rotation automatically for offDot and offDP")
				-- OffSWP
				bb.ui:createCheckbox(section,"offSWP","offSWP AutoFocus unit")
				-- OffVT
				bb.ui:createCheckbox(section,"offVT","offVT AutoFocus unit")
				-- mfRefresh
				bb.ui:createSpinnerWithout(section,"mf Refresh",1.3,0,3,0.1,"|cffFFFFFFjust test stuff:\nmeasured in GCDs")
				bb.ui:createSpinner(section,"gap time",0.3,0,1,0.05,"|cffFFFFFFjust test stuff:\nmeasured in GCDs")
			bb.ui:checkSectionState(section)

			--            _____ 
			--     /\    / ____|
			--    /  \  | (___  
			--   / /\ \  \___ \ 
			--  / ____ \ ____) |
			-- /_/    \_\_____/ 
			section = bb.ui:createSection(bb.ui.window.profile,"|cffBA55D3AS")
				-- DumpDP
				bb.ui:createCheckbox(section,"DumpDP","always use DP if Orbs>=3")

			bb.ui:checkSectionState(section)

		--  _    _ _   _ _ _ _   _
		-- | |  | | | (_) (_) | (_)
		-- | |  | | |_ _| |_| |_ _  ___  ___
		-- | |  | | __| | | | __| |/ _ \/ __|
		-- | |__| | |_| | | | |_| |  __/\__ \
		--  \____/ \__|_|_|_|\__|_|\___||___/
		section = bb.ui:createSection(bb.ui.window.profile, "|cffBA55D3Utilities")
			-- Rotation
			--bb.ui:createDropdown(section, "Rotation", {"Choose rotation to use.","|cffBA55D3ravens","|cffBA55D3SimC"}, 1)
			-- Pause Toggle
			bb.ui:createDropdown(section,"Pause Toggle",bb.dropOptions.Toggle2,10)
			-- -- Dummy DPS Test
			-- bb.ui:createSpinner(section,DPS Testing",4,1,15,1,"Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
		bb.ui:checkSectionState(section)


		--[[ Rotation Dropdown ]]--
		bb.ui:createRotationDropdown(bb.ui.window.profile.parent,{"ravens v3beta by ragnar"})
		bb:checkProfileWindowStatus()
	end
end