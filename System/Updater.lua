----------------------------------------------------------------------------------------------------
-- Variables
----------------------------------------------------------------------------------------------------
local cdnUrl = "https://cdn.badrotations.org/"
local apiUrl = "https://www.badrotations.org/"

local br = _G["br"]
br.updater = {}

local addonPath
local currentCommit
local purple = "|cffa330c9"
local isInitialized = false

----------------------------------------------------------------------------------------------------
-- Utilities
----------------------------------------------------------------------------------------------------
local function IsSettingChecked()
    return isChecked("Auto Check for Updates")
end

local function Print(msg)
   if msg == nil then return end
   print(br.classColor .. "[BadRotations] |cffFFFFFF" .. msg)
end

local function PrintError(msg)
   if msg == nil then return end
   print(br.classColor .. "[BadRotations] |cffff6666" .. msg)
end

local function RaidWarning(message)
    if isChecked("Overlay Messages") then
        RaidNotice_AddMessage(RaidWarningFrame, message, {r=1, g=0.3, b=0.1})
     end  
end

local function SendRequestAsync(url, OnComplete)
   SendHTTPRequest(url, nil, function(body, code, req, res, err)
         if type(OnComplete) == 'function' then
            OnComplete(body, code, req, res, err)
         end
   end, nil, 0)
end

----------------------------------------------------------------------------------------------------
-- Update
----------------------------------------------------------------------------------------------------
local function DownloadAsync(url, filePath)
   
   
end


function br.updater:Update()
    if not IsSettingChecked() then
        Print("Setting is disabled. To enable: Configuration > General > Auto Check for Updates")
    else
        Print("In-game updating coming Soon™")
    end
end
----------------------------------------------------------------------------------------------------
-- Check for Updates
----------------------------------------------------------------------------------------------------
local function SetLatestCommitAsync(OnComplete)   
   local url = apiUrl.."commits/latest"
   
   SendRequestAsync(url, function(body, code, req, res, err)
         latestCommit = body         
         
         if type(OnComplete) == 'function' then
            OnComplete(body, code, req, res, err)
         end     
   end)
end

local function CheckForUpdatesAsync(OnComplete)
   SetLatestCommitAsync(function()
         if currentCommit == latestCommit then
            if type(OnComplete) == 'function' then
                OnComplete()
             end
        end
         
         local url = apiUrl.."commits/diff/"..currentCommit
         SendRequestAsync(url, function(json)
               local aheadBy = json:match('"AheadBy":(.-),')
               local commitSection = json:match('"Commits":%[(.-)%]')
               
               Print("Local version: "..purple..currentCommit:sub(1, 7).." |cffFFFFFFLatest version: "..purple..latestCommit:sub(1, 7)..".")
               
               for commit in commitSection:gmatch('{(.-)}') do
                  local author = commit:match('"Author":"(.-)",')
                  local message = commit:match('"Message":"(.-)["\r\n]')  
                  
                  print("    "..purple..author..": |cffFFFFFF ".. message)
               end
               
            --    Print("BadRotations is currently "..purple..aheadBy.." |cffffffff".."versions out of date.\n"..
            --    "Please update for best performance via Git or "..purple.."/br update")               
            --    RaidWarning("BadRotations is currently " .. aheadBy .. " versions out of date.\nPlease update for best performance via Git or "..purple.."/br update")
                Print("BadRotations is currently "..purple..aheadBy.." |cffffffff".."versions out of date.\n"..
               "Please update for best performance.")               
               RaidWarning("BadRotations is currently " .. aheadBy .. " versions out of date.\nPlease update for best performance.")
               
               if type(OnComplete) == 'function' then
                OnComplete(json)
             end
         end)
   end)
end

-- Called on timer from System/Unlockers.lua after EWT has been loaded
function br.updater:CheckOutdated()
    if not IsSettingChecked() then return end

    br.updater:Initialize()
    if not isInitialized then return end
    CheckForUpdatesAsync()
end

----------------------------------------------------------------------------------------------------
-- Initialize
----------------------------------------------------------------------------------------------------
local function GetAddonName()
   for i = 1, GetNumAddOns() do
      local name, title = GetAddOnInfo(i)
      if title == purple.."BadRotations" then
         return name
      end
   end
end

local function InitCurrentCommit(latestCommit)
   local headFile = addonPath..".git\\refs\\heads\\master"
   local headContent = ReadFile(headFile)
   
   if headContent ~= nil then
      currentCommit = headContent
      return true
   end   
   
   -- Using Git, not GitHub can change the master branch to 'main'
   headFile = addonPath..".git\\refs\\heads\\main"
   headContent = ReadFile(headFile)
   
   if headContent ~= nil then
      currentCommit = headContent
      return true
   end
   
   currentCommit = latestCommit
   PrintError("Couldn't detect local Git master commit. ASSUMING latest version. Redownload may be needed if problems arise.")  
   Print("Version: "..purple..currentCommit:sub(1, 7))
   WriteFile(headFile, latestCommit, false, true)
   return false
end

local initRequested = false
function br.updater:Initialize()    
    if not IsSettingChecked() then return end

    if initRequested then return end
    initRequested = true
   addonPath = GetWoWDirectory() .. "\\Interface\\AddOns\\" .. GetAddonName() .. "\\"   

   SetLatestCommitAsync(function()
         local hadLocalVersion = InitCurrentCommit(latestCommit)
         if not hadLocalVersion then return end         
         if currentCommit == latestCommit then return end
         
         CheckForUpdatesAsync(function()
            isInitialized = true
         end)
   end)
end
