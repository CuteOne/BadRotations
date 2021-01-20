function br:AcceptQueues()
	if getOptionCheck("Accept Queues") then
		-- Accept Queues
		if randomReady == nil then
			randomReady = math.random(8,15)
		end
		-- add some randomness
		if readyToAccept and readyToAccept <= GetTime() - 5 then
			AcceptProposal(); readyToAccept = nil; randomReady = nil
		end
	end
end