	----------------
	--[[ Auto Join]]
	Frame = CreateFrame("Frame")
	Frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	local function MerchantShow(self, event, ...)
		if getOptionCheck("Accept Queues") == true then
			if event == "LFG_PROPOSAL_SHOW" then
				readyToAccept = GetTime()
			end
		end
	end
	Frame:SetScript("OnEvent", MerchantShow)