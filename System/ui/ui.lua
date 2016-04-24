function ConstructUI()
	if configFunctions == nil then
		configFunctions = true
		-- we should keep all ui to resize in here so we can call them at once
		function ResizeUI(delta)
			local scale = BadBoy_data.BadBoyUI.optionsFrame.scale or 1
			if delta < 0 then
				if scale > 0.75 then
					scale = scale - 0.05
				end
			else
				if scale < 1 then
					scale = scale + 0.05
				end
			end
			BadBoy_data.BadBoyUI.optionsFrame.scale = scale
			optionsFrame:SetWidth(675*scale)
			optionsFrame:SetHeight(150*scale)
			debugFrame:SetWidth(200*scale)
			debugFrame:SetHeight(125*scale)
		end
		function getState(value)
			if value == nil then
				value = state or 0
				return value
			end
		end
		-- i will have 3 rows of 4 button, this could be extended to more if needed
		-- i will make an array that will hold the options, when we click the category button,
		-- it will chagee to the desired panel
		-- the first display should be remembered in the optionsFrame
		-- profile table will be loaded on spec change
		-- filled from the profile
		-- need name, tip , check or no, status or no, drop or no
		-- check should not be mandatory
		-- check status and drop insert into temp array
		--local value,status,statusMin,statusMax = option.name,option.status,option.statusMin,option.statusMax
		--local statusStep,statusBase = option.statusStep,option.statusBase
		-- these functions are called when a profile is loaded
		-- startup
		function ClearConfig()
			if BadBoy_data.options[bb.selectedSpec] == nil then
				BadBoy_data.options[bb.selectedSpec] = {}
			end
			tempTable = {}
			BadBoy_data.options[bb.selectedSpec].profile = {}
		end
		-- on first load, i want to gather the values from the currentProfile
		-- and push them into wtf if they were not there already
		-- when im making the profile for the first time, i will gather the values from profile
		-- when im remaking the profile, i will gather the values from the wtf
		-- wtf will be in BadBoy_data.options[bb.selectedSpec]
		-- my options are in the params
		-- take options from param to wtf on first pass
		-- status
		function CreateNewBox(value,textString,minValue,maxValue,step,base,tip1)
			tempTable.status = tip1
			tempTable.statusMin = minValue
			tempTable.statusMax = maxValue
			tempTable.statusStep = step
			if BadBoy_data.options[bb.selectedSpec][textString.."Status"] == nil then
				BadBoy_data.options[bb.selectedSpec][textString.."Status"] = base
			else
				base = BadBoy_data.options[bb.selectedSpec][textString.."Status"]
			end
			tempTable.statusBase = base
		end
		-- dropdown
		function CreateNewDrop(value,textString,base,tip1,value1,value2,value3,value4,value5,value6,value7,value8,value9,value10)
			tempTable.dropdown = textString
			tempTable.dropTip = tip1
			tempTable.dropOptions = {
				[1] = value1 or nil,
				[2] = value2 or nil,
				[3] = value3 or nil,
				[4] = value4 or nil,
				[5] = value5 or nil,
				[6] = value6 or nil,
				[7] = value7 or nil,
				[8] = value8 or nil,
				[9] = value9 or nil,
				[10] = value10 or nil,
			}
			if BadBoy_data.options[bb.selectedSpec][textString.."Drop"] == nil then
				BadBoy_data.options[bb.selectedSpec][textString.."Drop"] = base
			else
				base = BadBoy_data.options[bb.selectedSpec][textString.."Drop"]
			end
			tempTable.base = base
		end
		-- checkbox
		function CreateNewCheck(value,textString,tip1,base)
			tempTable.check = true
			if BadBoy_data.options[bb.selectedSpec][textString.."Check"] == nil then
				BadBoy_data.options[bb.selectedSpec][textString.."Check"] = base
			else
				base = BadBoy_data.options[bb.selectedSpec][textString.."Check"]
			end
			tempTable.checkBase = base or 0
			tempTable.tip = tip1
		end
		-- new title and text need to insert in real array
		function CreateNewTitle(value,textString)
			BadBoy_data.options[bb.selectedSpec].profile = {}
			tempTable = {}
			if textString == nil then
				textString = value
			end
			tempTable.title = textString
			tempTable.name = textString
			BadBoy_data.options[bb.selectedSpec].profile[#BadBoy_data.options[bb.selectedSpec].profile+1] = tempTable
			tempTable = {}
		end
		function CreateNewText(value,textString)
			if textString == nil then
				textString = value
			end
			tempTable.name = textString
			BadBoy_data.options[bb.selectedSpec].profile[#BadBoy_data.options[bb.selectedSpec].profile+1] = tempTable
			tempTable = {}
		end
		-- wrap separation
		function CreateNewWrap(value,textString)
			if textString == nil then
				textString = value
			end
			tempTable.name = textString
			tempTable.wrap = textString
			BadBoy_data.options[bb.selectedSpec].profile[#BadBoy_data.options[bb.selectedSpec].profile+1] = tempTable
			if BadBoy_data.options[bb.selectedSpec][textString.."Wrapper"] == nil then
				BadBoy_data.options[bb.selectedSpec][textString.."Wrapper"] = true
			end
			tempTable = {}
		end
		-- end of profile
		function CreateNewBound(value,textString)
			if textString == nil then
				textString = value
			end
			tempTable.name = textString
			BadBoy_data.options[bb.selectedSpec].profile[#BadBoy_data.options[bb.selectedSpec].profile+1] = tempTable
			tempTable = {}
		end
		-- this is called at the end, we could use it to trigger value that state that the current spec is loaded into memory
		function WrapsManager()
			BadBoy_data.options[bb.selectedSpec].profile.name = BadBoy_data.options[bb.selectedSpec].profile[1].name
			createProfile()
			replaceWraps(BadBoy_data.options[bb.selectedSpec].profile.name)
			refreshOptions()
		end
		function createProfile()
			--if currentProfile ~= nil and currentProfile ~= BadBoy_data.options[bb.selectedSpec].profile then
			--	_G[currentProfileName.."Frame"]:Hide()
			--end
			--currentProfile = BadBoy_data.options[bb.selectedSpec].profile
			--currentProfileName = currentProfile[1].name
			--if currentProfile ~= nil and _G[currentProfileName.."Frame"] and BadBoy_data.options[bb.selectedSpec].profile[1].name ~= BadBoy_data.options[bb.selectedSpec].profile then
            --    _G[currentProfileName.."Frame"]:Hide()--_G[currentProfileName.."Frame"]:Show()
			--end
			--frameCreation(currentProfileName,270,400)
			--local scale = BadBoy_data.BadBoyUI.optionsFrame.scale
			--for i = 1, #currentProfile do
			--	local ypos = (-27*i)+27
			--	local thisOption = currentProfile[i]
			--	if thisOption.wrap ~= nil then
			--		-- wrap
			--		itemName = thisOption.wrap
			--		createWrapper(currentProfileName,itemName,7*scale,(ypos)*scale-5,i)
			--	elseif thisOption.title ~= nil then
			--		-- title
			--		itemName = thisOption.title
			--		createTitleString(currentProfileName,itemName,7*scale,(ypos)*scale)
			--	elseif thisOption.name ~= nil then
			--		-- text
			--		itemName = thisOption.name
			--		createTextString(currentProfileName,itemName,30*scale,ypos*scale-10,25*scale,158*scale,i)
			--	end
			--	if thisOption.dropdown ~= nil then
			--		-- dropdown
			--		createDropDownMenu(currentProfileName,thisOption,186*scale,ypos*scale-10,i)
			--	end
			--	if thisOption.check ~= nil then
			--		-- check                1               2             3         4          5
			--		createCheckBox(currentProfileName,thisOption,7*scale,ypos*scale-10,thisOption.checkBase)
			--	end
			--	if thisOption.status ~= nil then
			--		-- status
			--		createStatusBar(currentProfileName,thisOption,186*scale,ypos*scale-10,i)
			--	end
			--end
			--_G[currentProfileName.."Frame"]:SetHeight(#currentProfile*27*scale+13)
		end
		local colorBlue = "|cff00CCFF"
		local colorGold = "|cffFFDD11"
		local colorGreen = "|cff00FF00"
		local colorRed = "|cffFF0011"
		local colorWhite = "|cffFFFFFF"
		local colorGold = "|cffFFDD11"
		BadBoy_data.BadBoyUI.optionsFrame.options = {
			selected = "Enemies Engine",
			["General"] = {
				[1] = {
					checkbase = false,
					check = true,
					name = "Debug Frame",
					tip = "Display Debug Frame.",
				},
				[2] = {
					checkbase = true,
					check = true,
					name = "Display Failcasts",
					tip = "Dispaly Failcasts in Debug."
				},
				[3] = {
					checkbase = true,
					check = true,
					name = "Queue Casting",
					tip = "Allow Queue Casting on some profiles."
				},
				[5] = {
					checkbase = true,
					check = true,
					name = "Auto Loot",
					tip = "Check to allow auto-looting.",
					status = "|cffFFBB00Loot Delay.",
					statusBase = 0.5,
					statusMin = 0.1,
					statusMax = 3,
					statusStep = 0.1,
				},
				[6] = {
					checkbase = true,
					check = true,
					name = "Auto-Sell/Repair",
					tip = "Automatically sells grays and repais when you open a repairman trade."
				},
				[7] = {
					checkbase = true,
					check = true,
					name = "Accept Queues",
					tip = "Automatically sells grays and repais when you open a repairman trade."
				},
				[8] = {
					checkbase = true,
					check = true,
					name = "Overlay Messages",
					tip = "Check to enable chat overlay messages."
				},
				[9] = {
					checkbase = true,
					check = true,
					name = "Start/Stop BadBoy",
					tip = "Uncheck to prevent BadBoy pulsing."
				},
			},
			["Enemies Engine"] = {
				[1] = {
					checkbase = true,
					check = true,
					name = "Dynamic Targetting",
					tip = "Check this to allow dynamic targetting. If unchecked, profile will only attack current target."
				},
				[2] = {
					checkbase = true,
					check = true,
					name = "Wise Target",
					tip = "|cffFFDD11Check if you want to use Wise Targetting, if unchecked there will be no priorisation from hp.",
					dropBase = 1,
					dropdown = "Choose Units to prioritize. Lowest Units or Highest Units.",
					dropOptions = {
						[1] = "Highest",
						[2] = "Lowest",
						[3] = "abs Highest"
					}
				},
				[3] = {
					checkbase = true,
					check = true,
					name = "Forced Burn",
					tip = "Check to allow forced Burn on specific whitelisted units."
				},
				[4] = {
					checkbase = true,
					check = true,
					name = "Avoid Shields",
					tip = "Check to avoid attacking shielded units."
				},
				[5] = {
					checkbase = false,
					check = true,
					name = "Tank Threat",
					tip = "Check add more priority to taregts you lost aggro on(tank only)."
				},
				[6] = {
					checkbase = true,
					check = true,
					name = "Safe Damage Check",
					tip = "Check to prevent damage to targets you dont want to attack."
				},
				[7] = {
					checkbase = true,
					check = true,
					name = "Don't break CCs",
					tip = "Check to prevent damage to targets that are CC."
				},
				[8] = {
					checkbase = true,
					check = true,
					name = "Skull First",
					tip = "Check to enable focus skull dynamically."
				},
				[9] = {
					checkbase = true,
					check = true,
					name = "Interrupts Handler",
					tip = "Check this to allow Interrupts Handler.",
					dropBase = 1,
					dropdown = "Choose who you want to interupt.",
					dropOptions = {
						[1] = colorRed.."Target",
						[2] = colorBlue.."T/M",
						[3] = colorGold.."T/M/F",
						[4] = colorGreen.."All"
					},
					dropTip = colorWhite.."Select prefered targets:"..
					colorRed.."\nTarget(Only current Target)"..
					colorBlue.."\nT/M(Only Target/Mouse)"..
					colorGold.."\nT/M/F(Target/Mouse/Focus)"..
					colorGreen.."\nAll(Any available in range)"
				},
				[10] = {
					checkbase = false,
					check = true,
					name = "Only Known Units",
					tip = "Check this to interrupt only on known units using whitelist."
				},
				[11] = {
					checkbase = true,
					check = true,
					name = "Crowd Control",
					tip = "Check to use crowd controls on select units/buffs."
				},
				[12] = {
					checkbase = true,
					check = true,
					name = "Enrages Handler",
					tip = "Check this to allow Enrages Handler.",
				--dropbase = 4,
				--dropdown = "Choose who you want to tranquilize.",
				--dropOptions = {
				--    [1] = colorRed.."Target",
				--    [2] = colorBlue.."T/M",
				--    [3] = colorGold.."T/M/F",
				--    [4] = colorGreen.."All"
				--},
				}
			--[[[11] = {



                        checkbase = false,



                        check = true,



                        name = "Interrupts Frame",



                        tip = "Check this to display Interrupts Frame."



                    },]]
			},
			["Healing Engine"] = {
				[1] = {
					checkbase = false,
					check = true,
					name = "Heal Pets",
					tip = "Check this to Heal Pets."
				},
				[2] = {
					checkbase = true,
					check = true,
					name = "Special Heal",
					tip = "Check this to Heal Special Whitelisted Units.",
					dropBase = 1,
					dropdown = "Choose who you want to Heal.",
					dropOptions = {
						[1] = colorRed.."Target",
						[2] = colorBlue.."T/M",
						[3] = colorGold.."T/M/F",
						[4] = colorGreen.."T/F"
					},
					dropTip = colorWhite.."Select prefered targets:"..
					colorRed.."\nTarget(Only current Target)"..
					colorBlue.."\nT/M(Only Target/Mouse)"..
					colorGold.."\nT/M/F(Target/Mouse/Focus)"..
					colorGreen.."\nT/F(Target/Focus)"
				},
				[3] = {
					checkbase = true,
					check = true,
					name = "Sorting with Role",
					tip = "Sorting with the Role."
				},
				[4] = {
					checkbase = false,
					check = true,
					name = "Prioritize Special Targets",
					tip = "Prioritize Special targets(mouseover/target/focus).",
					dropBase = 1,
					dropdown = "Choose Which Special Units to consider.",
					dropOptions = {
						[1] = "Special",
						[2] = "All"
					},
				},
				[5] = {
					checkbase = true,
					check = true,
					name = "Blacklist",
					status = "|cffFFBB00How much |cffFF0000%HP|cffFFBB00 do we want to add to |cffFFDD00Blacklisted |cffFFBB00units. Use /Blacklist while mouse-overing someone to add it to the black list.",
					statusBase = 95,
					statusMin = 0,
					statusMax = 100,
					statusStep = 5,
				},
				[6] = {
					checkbase = false,
					check = true,
					name = "Ignore Absorbs",
					tip = "Check this if you want to ignore absorb shields. If checked, it will add shieldBuffValue/4 to hp. May end up as overheals, disable to save mana."
				},
				[7] = {
					checkbase = false,
					check = true,
					name = "Incoming Heals",
					tip = "If checked, it will add incoming health from other healers to hp. Uncheck this if you want to prevent overhealing units."
				},
				[8] = {
					checkbase = false,
					check = true,
					name = "Overhealing Cancel",
					--"Harmoney SotF", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney.")
					status = "Set Desired Threshold at which you want to prevent your own casts.",
					statusBase = 95,
					statusMin = 0,
					statusMax = 100,
					statusStep = 5,
					tip = "Check to prevent overhealing."
				},
				[9] = {
					checkbase = false,
					check = true,
					name = "Healing Debug",
					tip = "Check to display Healing Engine Debug."
				},
				[10] = {
					checkbase = false,
					check = false,
					name = "Debug Refresh",
					status = "Set desired Healing Engine Debug Table refresh for rate in ms.",
					statusBase = 500,
					statusMin = 0,
					statusMax = 1000,
					statusStep = 25,
					tip = "Debug Table Refresh throttle(ms)."
				},
                -- TODO: Dispel delay
                [11] = {
                	checkbase = false,
                	check = true,
                	name = "Dispel delay",
                	status = "Set desired dispel delay in % of debuff duration.\n|cffFF0000Will randomise around the value you set.",
                	statusBase = 15,
                	statusMin = 5,
                	statusMax = 90,
                	statusStep = 1,
                	tip = "Dispel delay in % of debuff duration"
                },
				[12] = {
					checkbase = true,
					check = true,
					name = "HE Active",
					tip = "Enable the Healing Engine."
				},
			},
			["Other Features"] = {
				[1] = {
					checkbase = false,
					check = true,
					name = "Profession Helper",
					--"Harmoney SotF", 0, 100  , 5, 40, "|cffFFBB00Under what |cffFF0000%HP|cffFFBB00 to use |cffFFFFFFRegrowth|cffFFBB00 to refresh Harmoney.")
					status = "Set Desired Recast Delay.",
					statusBase = 0.5,
					statusMin = 0,
					statusMax = 1,
					statusStep = .1,
					tip = "Check to enable Professions Helper."
				},
				[2] = {
					checkbase = false,
					check = true,
					name = "Prospect Ores",
					tip = "Prospect Desired Ores.",
					dropBase = 4,
					dropdown = "Which ores?.",
					dropOptions = {
						[1] = "WoD",
						[2] = "MoP",
						[3] = "Cata",
						[4] = "All"
					},
				},
				[3] = {
					checkbase = false,
					check = true,
					name = "Mill Herbs",
					tip = "Mill Desired Herbs.",
					dropBase = 4,
					dropdown = "Which ores?.",
					dropOptions = {
						[1] = "WoD",
						[2] = "MoP",
						[3] = "Cata",
						[4] = "All"
					},
				},
				[4] = {
					checkbase = false,
					check = true,
					name = "Disenchant",
					tip = "Disenchant Cata blues/greens."
				},
				[5] = {
					checkbase = false,
					check = true,
					name = "Leather Scraps",
					tip = "Combine leather scraps."
				},
				[6] = {
					checkbase = false,
					check = true,
					name = "Salvage",
					status = "Set Desired waiting after full inventory.",
					statusBase = 10,
					statusMin = 5,
					statusMax = 30,
					statusStep = 1,
					tip = "Check to enable Salvage Helper."
				},
			}
		}
		-- options buttons interation, set the one clicked white and others gray
		function radioGeneral(parent,value)
			local generalRadios = {"General","Enemies Engine","Healing Engine","Other Features"}
			for i = 1, 4 do
				local thisButton = generalRadios[i]
				if thisButton == value then
					_G["options"..thisButton.."Button"].texture:SetTexture(175/255,175/255,175/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
				else
					_G["options"..thisButton.."Button"].texture:SetTexture(BadBoy_data.BadBoyUI.optionsFrame.color.r/255,BadBoy_data.BadBoyUI.optionsFrame.color.g/255,BadBoy_data.BadBoyUI.optionsFrame.color.b/255,BadBoy_data.BadBoyUI.optionsFrame.color.a)
				end
			end
		end
		-- create frames
		frameCreation("options",791,147)
		frameCreation("debug",300,265,"|cffFF001EDebug")
		for i = 1, 10 do
			createRow("debug",i,"")
		end
		-- create my options, i will do cycles to lay the buttons from the array
		-- the frame of options should always wear the same name, be reused and pulse info when selection change only
		function createOptions(value)
			local ypos,verticalButtons = 0,4
			for i = 1, 12 do
				ypos = ypos + 1
				if BadBoy_data.BadBoyUI.optionsFrame.options[value]
					and BadBoy_data.BadBoyUI.optionsFrame.options[value][i] ~= nil then
					local thisOption,xpos = BadBoy_data.BadBoyUI.optionsFrame.options[value][i],math.floor((i-1)/4)*260
					createCheckBox("options",thisOption,(xpos+7),(ypos*-27)-10)
					local textWidth = 155
					if thisOption.status ~= nil then
						-- create a statusbar if one declared -- (parent,value,x,y,textString)
						createStatusBar("options",thisOption,(xpos+189),(ypos*-27)-10)
					elseif thisOption.dropdown ~= nil then
						createDropDownMenu("options",thisOption,(xpos+189),(ypos*-27)-10)
					else
						textWidth = 240
					end
					createTextString("options",thisOption.name,(xpos+35),(ypos*-27)-11,25,textWidth)
				end
				if ypos >= 3.5 then
					ypos = 0
				end
			end
		end
		function refreshOptions()
			local generalRadios = {"General","Enemies Engine","Healing Engine","Other Features"}
			for i = 1, 4 do
				-- thisButton is name of parent button
				local thisButton = generalRadios[i]
				-- if i have saved options for thisButton
				if BadBoy_data.BadBoyUI.optionsFrame.options[thisButton] ~= nil then
					-- iterate corresponding frames
					for j = 1, 12 do
						-- current option selected
						local thisOption = BadBoy_data.BadBoyUI.optionsFrame.options[thisButton][j]
						if thisOption ~= nil then
							-- name of the option
							local name = thisOption.name
							-- actual profile options
							local profileOptions = BadBoy_data.options[bb.selectedSpec]
							if profileOptions ~= nil then
								-- if i have values saved for a checkbox
								if profileOptions[name.."Check"] == 1 then
									_G["options"..name.."Check"].texture:SetTexture(125/255,125/255,125/255,1)
								else
									_G["options"..name.."Check"].texture:SetTexture(45/255,45/255,45/255,1)
								end
								-- if i have values for a statusbar
								if thisOption.status ~= nil then
									if profileOptions[name.."Status"] ~= nil then
										_G["options"..name.."Status"]:SetValue(profileOptions[name.."Status"])
										_G["options"..name.."StatusText"]:SetText(profileOptions[name.."Status"])
									end
									-- or if i have values for a
								elseif thisOption.dropdown ~= nil then
									if profileOptions[name.."Drop"] ~= nil then
										local textDisplay
										textDisplay = thisOption.dropOptions[profileOptions[name.."Drop"]]
										_G["options"..name.."DropText"]:SetText(textDisplay,nil,nil,nil,nil,false)
									end
								end
							end
						end
					end
				end
			end
		end
		-- if we uncheck the option panel, all options should hide and other options appear.
		-- hide existing array of options
		function optionsShow(button)
			local generalRadios = {"General","Enemies Engine","Healing Engine","Other Features"}
			for i = 1, 4 do
				if button ~= generalRadios[i] then
					local thisOptionPanel = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]]
					if thisOptionPanel ~= nil then
						for j = 1, 12 do
							local thisOption = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]][j]
							if thisOption ~= nil then
								local value = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]][j].name
								_G["options"..value.."Check"]:Hide()
								_G["options"..value.."TextFrame"]:Hide()
								if thisOption.status ~= nil then
									_G["options"..value.."Status"]:Hide()
								end
								if thisOption.dropdown ~= nil then
									_G["options"..value.."Drop"]:Hide()
								end
							end
						end
					end
				else
					local thisOptionPanel = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]]
					if thisOptionPanel ~= nil then
						for j = 1, 12 do
							local thisOption = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]][j]
							if thisOption ~= nil then
								local value = BadBoy_data.BadBoyUI.optionsFrame.options[generalRadios[i]][j].name
								_G["options"..value.."Check"]:Show()
								_G["options"..value.."TextFrame"]:Show()
								if thisOption.status ~= nil then
									_G["options"..value.."Status"]:Show()
								end
								if thisOption.dropdown ~= nil then
									_G["options"..value.."Drop"]:Show()
								end
							end
						end
					end
				end
			end
		end
	end
	-- ui category boutons
	-- width 791
	-- 7 + 189 + 7 + 189 + 7 + 190 + 7 + 190 + 7
	-- generate general options
	-- 7 - 196 - 203 - 392 - 399 - 588 591
	createButton("options","General",7,-5,"General")
	createOptions("General")
	createButton("options","Enemies Engine",203,-5,"Enemies Engine")
	createOptions("Enemies Engine")
	createButton("options","Healing Engine",399,-5,"Healing Engine")
	createOptions("Healing Engine")
	createButton("options","Other Features",591,-5,"Other Features")
	createOptions("Other Features")
	if BadBoy_data.options.selected == nil then
		BadBoy_data.options.selected = "General"
	end
	_G["options"..BadBoy_data.options.selected.."Button"]:Click()
    optionsFrame:Hide()
	if BadBoy_data.options[bb.selectedSpec] and BadBoy_data.options[bb.selectedSpec]["optionsFrame"] ~= true then
		optionsFrame:Hide()
	end
	-- if frames ar already loaded we only have to bring them back shown so we will
	-- 1 create a dummy var that is set to false on profile load.
	-- 2 all frames of options will trigger their own check once loaded.
	-- 3 when clicked different options,
	-- 1 we hide all the related windows.
	-- 2 pulse selected options. create or show.
	-- this used to be loaded at the end of the profile
	function CreateGeneralsConfig()
	end
	--end
end
