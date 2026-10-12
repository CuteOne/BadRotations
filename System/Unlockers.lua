local _, br = ...
br.unlockers = br.unlockers or {}
local unlockers = br.unlockers

br.unlockers.selected = "None"
-- The unlocker's own API table, set by its adapter (diagnostics list names from it)
br.unlockers.raw = nil

-- Unlocker adapters, in priority order. Each adapter file (Unlockers/*.lua)
-- defines br.unlockers:<fn>(): it sets up br._G and returns true only when its
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

    -- Called every pulse until an unlocker is found, so report only once.
    if not unlocked and not reportedNoUnlocker then
        reportedNoUnlocker = true
        br._G.print("No supported unlocker detected.")
    end

    if unlocked then
        -- Set Spell Queue Window to 400ms for smoother cast queueing.
        -- Save the player's original value first so we can restore it on logout.
        br.unlockers.origQueueWindow = br._G.C_CVar and br._G.C_CVar.GetCVar("SpellQueueWindow")
        br._G.RunMacroText("/console SpellQueueWindow 400")
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
