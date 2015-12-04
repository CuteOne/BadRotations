if select(3, UnitClass("player")) == 5 then
	function ShadowConfig()
		bb.profile_window = createNewProfileWindow("Shadow")
		local section

		--   _____            _     _
		--  / ____|          | |   | |
		-- | |     ___   ___ | | __| | _____      ___ __  ___
		-- | |    / _ \ / _ \| |/ _` |/ _ \ \ /\ / / '_ \/ __|
		-- | |___| (_) | (_) | | (_| | (_) \ V  V /| | | \__ \
		--  \_____\___/ \___/|_|\__,_|\___/ \_/\_/ |_| |_|___/
		section = createNewSection(bb.profile_window,"|cffBA55D3Offensive")
			-- bosscheck
			createNewCheckbox(section,"isBoss","use CDs only on Boss Units")
			-- Power Infusion
			createNewCheckbox(section,"PI","Power Infusion")
			-- Shadowfiend / Mindbender
			createNewCheckbox(section,"MB/SF","Mindbender / Shadowfiend")
		checkSectionState(section)


		--  _____        __               _
		-- |  __ \      / _|             (_)
		-- | |  | | ___| |_ ___ _ __  ___ ___   _____
		-- | |  | |/ _ \  _/ _ \ '_ \/ __| \ \ / / _ \
		-- | |__| |  __/ ||  __/ | | \__ \ |\ V /  __/
		-- |_____/ \___|_| \___|_| |_|___/_| \_/ \___|
		section = createNewSection(bb.profile_window,"|cffBA55D3Defensive")
			-- Power Word: Shield
			createNewSpinner(section,"PW:S",30,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Desperate Prayer
			createNewSpinner(section,"Desperate Prayer",25,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Fade with glyph
			createNewSpinner(section,"Fade",40,0,100,2,"|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFFade")
			-- Healing Tonic
			createNewSpinner(section,"Healing Tonic",25,0,100,1,"|cffFFFFFFhealth percent to cast at")
			-- Dispersion
			createNewSpinner(section,"Dispersion",20,0,100,1,"|cffFFFFFFhealth percent to cast at")
		checkSectionState(section)


		--  ____                  _    _      _
		-- |  _ \                | |  | |    | |
		-- | |_) | ___  ___ ___  | |__| | ___| |_ __   ___ _ __
		-- |  _ < / _ \/ __/ __| |  __  |/ _ \ | '_ \ / _ \ '__|
		-- | |_) | (_) \__ \__ \ | |  | |  __/ | |_) |  __/ |
		-- |____/ \___/|___/___/ |_|  |_|\___|_| .__/ \___|_|
		--                                     | |
		--                                     |_|
		section = createNewSection(bb.profile_window,"|cffBA55D3Bosshelper")
			-- -- Gorefiend SWP
			-- createNewCheckbox(section,"Gorefiend SWP","SWP every Corrupted Soul in Mythic")
			-- -- Auto Guise
			-- createNewCheckbox(section,"Auto Guise","Auto Spectral Guise on: \nBRF: Iron Maidens")
			-- -- Auto Mass Dispel
			-- createNewCheckbox(section,"Auto Mass Dispel","Auto Mass Dispel on: \nBRF: Operator Thogar")
			-- -- Auto Dispel
			-- createNewCheckbox(section,"Auto Dispel", "Auto Dispel on: \nBRF: Blast Furnace")
			-- -- Auto Silence
			-- createNewCheckbox(section,"Auto Silence", "Auto Silence on: \nBRF: Blast Furnace\nBRF: Operator Thogar")
			-- -- Target Helper
			-- createNewCheckbox(section,"Target Helper", "Assists to target the correct unit")
			-- Dot Test
			createNewCheckbox(section,"Test Stuff", "Do not use this!\n - Archimonde: dot all dogs")
			-- Auto Burn
			createNewCheckbox(section,"AutoBurn", "Auto target burn defined units like doomfire on archimonde")
		checkSectionState(section)


		--  _____       _        _   _
		-- |  __ \     | |      | | (_)
		-- | |__) |___ | |_ __ _| |_ _  ___  _ __
		-- |  _  // _ \| __/ _` | __| |/ _ \| '_ \
		-- | | \ \ (_) | || (_| | |_| | (_) | | | |
		-- |_|  \_\___/ \__\__,_|\__|_|\___/|_| |_|
		section = createNewSection(bb.profile_window,"|cffBA55D3Rotation")
			-- Ignore orbs for SWD
			createNewCheckbox(section,"SWD ignore Orbs","use SWD despite 5 Orbs")
			-- Max Targets
			createNewSpinnerWithout(section,"max dot targets",4,0,10,1,"|cffFFFFFFnumber of running dots of each")
			-- Mind Sear / Searing Insanity Key
			createNewDropdown(section,"Burst SI",bb.dropOptions.Toggle2,3,"Burst Searing Insanity")
			-- ttd SWP
			createNewSpinnerWithout(section,"ttd swp",13.5,0,13.5,0.25,"|cffFFFFFFSWP TTD:\nstandard (simcraft): 13.5s\nCast SWP only on a unit that lives longer than chosen value.")
			-- ttd VT
			createNewSpinnerWithout(section,"ttd vt",11.25,0,11.25,0.25,"|cffFFFFFFSWP TTD:\nstandard (simcraft): 11.25s + castTime\nCast VT only on a unit that lives longer than chosen value.")
		checkSectionState(section)


			--   _____      _____  
			--  / ____|    |  __ \ 
			-- | |     ___ | |__) |
			-- | |    / _ \|  ___/ 
			-- | |___| (_) | |     
			--  \_____\___/|_|     
			section = createNewSection(bb.profile_window,"|cffBA55D3CoP")
				-- DPx
				createNewSpinnerWithout(section,"DPx",3,3,5,1,"DP on x Orbs")
				-- Auto Focus
				createNewCheckbox(section,"AutoFocus","Focus units on CoP rotation automatically for offDot and offDP")
				-- OffSWP
				createNewCheckbox(section,"offSWP","offSWP AutoFocus unit")
				-- OffVT
				createNewCheckbox(section,"offVT","offVT AutoFocus unit")
				-- mfRefresh
				createNewSpinnerWithout(section,"mf Refresh",1.3,0,3,0.1,"|cffFFFFFFjust test stuff:\nmeasured in GCDs")
				createNewSpinner(section,"gap time",0.3,0,1,0.05,"|cffFFFFFFjust test stuff:\nmeasured in GCDs")
			checkSectionState(section)

			--            _____ 
			--     /\    / ____|
			--    /  \  | (___  
			--   / /\ \  \___ \ 
			--  / ____ \ ____) |
			-- /_/    \_\_____/ 
			section = createNewSection(bb.profile_window,"|cffBA55D3AS")
				-- DumpDP
				createNewCheckbox(section,"DumpDP","always use DP if Orbs>=3")

			checkSectionState(section)

		--  _    _ _   _ _ _ _   _
		-- | |  | | | (_) (_) | (_)
		-- | |  | | |_ _| |_| |_ _  ___  ___
		-- | |  | | __| | | | __| |/ _ \/ __|
		-- | |__| | |_| | | | |_| |  __/\__ \
		--  \____/ \__|_|_|_|\__|_|\___||___/
		section = createNewSection(bb.profile_window, "|cffBA55D3Utilities")
			-- Rotation
			--createNewDropdown(section, "Rotation", {"Choose rotation to use.","|cffBA55D3ravens","|cffBA55D3SimC"}, 1)
			-- Pause Toggle
			createNewDropdown(section,"Pause Toggle",bb.dropOptions.Toggle2,10)
			-- -- Dummy DPS Test
			-- createNewSpinner(section,DPS Testing",4,1,15,1,"Set to desired time for test in minutes.\nMin: 1 / Max: 15 / Interval: 1")
		checkSectionState(section)


		--[[ Rotation Dropdown ]]--
		createNewRotationDropdown(bb.profile_window.parent,{"ravens v3beta by ragnar"})
		bb:checkProfileWindowStatus()
	end
end