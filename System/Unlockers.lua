local _, br = ...
br.unlockers = br.unlockers or {}
local unlockers = br.unlockers

br.unlockers.selected = "None"
-- The unlocker's own API table, set by its adapter (diagnostics list names from it)
br.unlockers.raw = nil
-- The unlocker's protected call, protect(fn, ...), on clients with secret values: BR's scripts,
-- timers and hooks run inside it so they may use those values (System/Secrets.lua). An adapter sets
-- it when its unlocker has one, as soon as its file loads (BR's frames get events before the first
-- pulse picks the adapter; Unlockers/daemonic.lua loads before this file, so it isn't reset here).
-- Without it, BR pauses on values it can't use.

-- Unlocker adapters, in priority order. Each adapter file (Unlockers/*.lua)
-- defines br.unlockers:<fn>(): it sets up its functions (written into br.game, they land in
-- br.unlockers.api, Expansions/Flavours.lua) and returns true only when its
-- unlocker is present, and returns false quietly otherwise. Detection and the
-- "no unlocker" case are handled here, not by any adapter.
local adapters = {
    { name = "NN",       fn = "NNUnlock" },
    { name = "Tinkr",    fn = "TinkrUnlock" },
    { name = "Daemonic", fn = "DaemonicUnlock" },
}
local reportedNoUnlocker = false

-- Adapters that don't ship with BR (loaded alongside it by their unlocker)
-- register here. They're tried before the built-in ones, since they are only
-- present when their unlocker explicitly loaded them.
function unlockers:registerAdapter(name, unlock)
    table.insert(adapters, 1, { name = name, unlock = unlock })
end

-- What BR expects from an adapter's file functions (in br.game). Unlockers/ewt.txt is the API BR was
-- first built on; this is the part of it BR relies on now:
--   ReadFile(path)                    the file's text, or nil when it doesn't exist
--   WriteFile(path, text, append)     writes the file; append adds the text to its end
--   CreateDirectory(path)             makes the folder
--   DirectoryExists(path)             whether the folder exists
--   GetDirectoryFiles(pattern)        the names of the files matching "folder\*.lua"
--   GetWoWDirectory()                 the folder BR's own folder is found from (misc:getAddonPath)
-- An adapter whose unlocker appends by itself sets unlockers.nativeAppend; for the others append
-- is done here, by reading the file and writing it back with the text added.
unlockers.nativeAppend = false
-- Once, when the adapter is picked (loadUnlockerAPI runs until one is)
local function emulateAppend()
    local write, read = br.api.base.WriteFile, br.api.base.ReadFile
    if unlockers.nativeAppend or write == nil or read == nil then return end
    br.api.overrides.WriteFile = function(path, text, append, ...)
        if append then
            local ok, current = pcall(read, path)
            if ok and type(current) == "string" then text = current .. text end
        end
        return write(path, text, false, ...)
    end
end

function unlockers:loadUnlockerAPI()
    local unlocked = false
    for _, adapter in ipairs(adapters) do
        local unlock = adapter.unlock or unlockers[adapter.fn]
        if unlock ~= nil and unlock(unlockers) then
            unlockers.selected = adapter.name
            unlocked = true
            break
        end
    end
    if unlocked then emulateAppend() end

    -- Called every pulse until an unlocker is found, so report only once.
    if not unlocked and not reportedNoUnlocker then
        reportedNoUnlocker = true
        br.game.print("No supported unlocker detected.")
    end

    if unlocked then
        -- Set Spell Queue Window to 400ms for smoother cast queueing.
        -- Save the player's original value first so we can restore it on logout.
        br.unlockers.origQueueWindow = br.game.C_CVar and br.game.C_CVar.GetCVar("SpellQueueWindow")
        br.game.RunMacroText("/console SpellQueueWindow 400")
        -- MEDIA PATH: the client only loads textures and fonts from its own Interface folder (paths
        -- to BR's own folder fail with "file not found", measured on Forever). The "3rd Party Files/Media"
        -- folder is copied to Interface\AddOns\Media; BR installed as a normal addon has its own copy.
        local DiesalStyle = LibStub("DiesalStyle-1.0")
        if DiesalStyle.SetMediaPath then
            DiesalStyle:SetMediaPath("Interface\\AddOns\\Media\\", "Interface\\AddOns\\BadRotations\\Libs\\DiesalStyle-1.0\\Media\\")
            DiesalStyle:ReloadMedia()
        end
    end
    return unlocked
end

-- On logout (and /reload): give the player back the Spell Queue Window BR changed
br.lifecycle:onLogout(10, "spell queue window", function()
    if unlockers.origQueueWindow then
        br.game.RunMacroText("/console SpellQueueWindow " .. unlockers.origQueueWindow)
    end
end)
