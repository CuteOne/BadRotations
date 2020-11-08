local addonName
local addonPath
local currentCommit
local latestCommit
local cdnUrl = "https://cdn.badrotations.org/"
local apiUrl = "https://www.badrotations.org/"

local f = CreateFrame('frame')
local isInitialized = false

local fileList = {}
local isBusy = false
local downloadIndex = 0
local lastUpdateTime

local updateRequested = false

local br = _G["br"]

-- Add files here to keep them from being overridden.
local ignoreFileList = {
    --["System\\SlashCommands.lua"] = "",
    --["Updater.lua"] = ""
}

local function Print(msg)
	if msg == nil then return end
	print(br.classColor .. "[BadRotations] |cffFFFFFF" .. msg)
end

local function DownloadFile(filePath)
    if filePath == nil or addonPath == nil then return end
    if ignoreFileList[filePath] ~= nil then return end

    isBusy = true

    -- Change slashes and encode spaces
    local requestUrl = cdnUrl .. latestCommit .. "/" .. filePath:gsub("\\", "/"):gsub(" ", "%%20")
    
    -- Rename the .toc file to match a changed addon name
    if filePath == "BadRotations.toc" then
        filePath = addonName .. ".toc"
    end
        
    Print("Downloading (" .. downloadIndex .. " / " .. #fileList .. ") " .. string.format("%.1f%%", (downloadIndex / #fileList) * 100) .. "\n    " .. filePath)

    -- Relies on EWT
    SendHTTPRequest(requestUrl, nil, function(body)        
        local localPath = addonPath .. "\\" .. filePath
        localPath = localPath:gsub("/", "\\")
        WriteFile(localPath, body, false, true)
        isBusy = false
    end, nil, 0x2)
end

-- Called from /br reinstall
function br.Reinstall()
    isBusy = true
    fileList = {}

    local fileListPath = cdnUrl .. latestCommit .. "/AllFiles.txt"
    Print("Getting list of files from: " .. fileListPath)

    SendHTTPRequest(fileListPath, nil, function(body)
        for s in body:gmatch("[^\r\n]+") do
            table.insert(fileList, s)
        end

        downloadIndex = 1
        isBusy = false
        Print("Finished getting list: " .. #fileList .. " files")
    end, nil, false)
end

-- Called from /br confirm
function br.Confirm()
    if not updateRequested then
        Print("Check for updates with /br update")
    end

    isBusy = true
    SendHTTPRequest(apiUrl.."update/diff/"..currentCommit, nil, function(json)          
        fileList = {}
        local changedFilesSection = json:match('"ChangedFiles":%[(.-)]')
        for file in changedFilesSection:gmatch('"(.-)"') do
            if file ~= "BadRotations.toc" then 
                table.insert(fileList, file)
            end
        end
        
        downloadIndex = 1
        lastUpdateTime = GetTime()
        isBusy = false
    end, nil, false)
end

-- Called from /br update
function br.Update()
    isBusy = true
    SendHTTPRequest(apiUrl.."version", nil, function(commitSha)
        latestCommit = commitSha
        if latestCommit == currentCommit then
            Print("Already up to date.")
            lastUpdateTime = GetTime()
            isBusy = false
            return
        end

        Print("|cffFF0000WARNING TO DEVS: |cffFFFFFFThis does not use Git and will override any pending file changes.\n|cffFFFFFFType |cff008C80/br confirm |cffFFFFFFto continue with in-game update.")
        updateRequested = true
        isBusy = false
    end, nil, false)
end

-- Called on timer
local function CheckForUpdates()
    isBusy = true
    SendHTTPRequest(apiUrl .. "version", nil, function(commitSha)
        latestCommit = commitSha

        if latestCommit ~= currentCommit then
            SendHTTPRequest(apiUrl .. "update/diff/" .. currentCommit, nil, function(json)
                local aheadBy = json:match('"AheadBy":(.-),')
                local commitSection = json:match('"Commits":%[(.-)%]')
                
                Print("BadRotations is currently |cff008C80" .. aheadBy .. " |cffFFFFFFversions out of date.\nLocal version: |cff008C80"..currentCommit.." |cffFFFFFFLatest version: |cff008C80"..latestCommit..".")

                for commit in commitSection:gmatch('{(.-)}') do
                    local sha = commit:match('"Sha":"(.-)",')
                    local message = commit:match('"Message":"(.-)["\r\n]')                    
                    print("|cff008C80  "..sha..": |cffFFFFFF ".. message)
                end

                Print("Please update for best performance via Git or |cff008C80/br update")

                if isChecked("Overlay Messages") then
                    local outdatedMessage = "BadRotations is currently " .. aheadBy .. " versions out of date.\nPlease update for best performance via Git or |cff008C80/br update"
                    RaidNotice_AddMessage(RaidWarningFrame, outdatedMessage, {r=1, g=0.3, b=0.1})
                end
                
                lastUpdateTime = GetTime()
                isBusy = false            
            end, nil, false)
        else
            lastUpdateTime = GetTime()
            isBusy = false            
        end
    end, nil, false)
end

local function GetAddonName()
    for i = 1, GetNumAddOns() do
        local name, title = GetAddOnInfo(i)
        if title == "|cffa330c9BadRotations" then
            return name
        end
    end
end

local function GetCurrentCommit()
    local fetchHeadFile = addonPath .. ".git\\FETCH_HEAD"
    local headContent = ReadFile(fetchHeadFile);

    if headContent == nil then
        Print("Couldn't get Git commit version. Reinstalling may be needed, from Git or /br reinstall")
        return ""
    end

    return headContent:sub(1, 7)
end

local function Init()
    addonName = GetAddonName()
    addonPath = GetWoWDirectory() .. "\\Interface\\AddOns\\" .. addonName .. "\\"
    currentCommit = GetCurrentCommit()

    Print("Current version: "..currentCommit)
    CheckForUpdates()
    isInitialized = true
end

f:SetScript("OnUpdate", function()
    -- ewt isn't loaded or don't need to do anything
    if GetObjectCount == nil or isBusy then return end

    -- Need to initialize 
    if not isInitialized then Init() return end

    -- Already downloading or doing something
    if isBusy then return end

    -- Check for updates every 5 minutes
    if (GetTime() - lastUpdateTime) > 300 then
        CheckForUpdates()
        return
    end

    -- Nothing to download
    if #fileList < 1 or downloadIndex == 0 then return end

    -- Done downloading, reset
    if downloadIndex > #fileList then
        fileList = {}
        downloadIndex = 0
        Print("Finished downloading. /reload to apply updates.")
        --RunMacroText("/reload")
    end
    
    -- Download the next file in the list
    DownloadFile(fileList[downloadIndex])
    downloadIndex = downloadIndex + 1
end)
