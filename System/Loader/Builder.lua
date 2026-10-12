local _, br = ...
--- Builder
-- Creates br.player for the current spec. Core calls br.loader.builder:new().
br.loader.builder = br.loader.builder or {}
local builder = br.loader.builder

-- Builds br.player for the given spec: a Player object (Player.lua) with the selected
-- rotation, its compiled spell lists and the profile API.
function builder:new(spec, specName)
    local loadStart = br._G.debugprofilestop()
    local self = br.loader.Player:new(spec)
    self.profile = specName or "Initial"

    -- Rotation files are loaded by the Bootstrap ROTATIONS stage before the player is built.
    -- Select the previously chosen rotation, or the first available one
    local rotations = br.loader.rotations[spec]
    if rotations ~= nil and br.loader.selectedProfile ~= nil and rotations[br.loader.selectedProfile] then
        self.rotation = rotations[br.loader.selectedProfile]
    elseif rotations ~= nil then
        br._G.print("No Previously Selected Rotation, Defaulting To: " .. rotations[1].name)
        self.rotation = rotations[1]
    else
        br._G.print("No Rotations Found!")
        return
    end

    -- Its own copy: the spell compiler adds the spell lists' items to it
    self.items = {}
    for name, id in pairs(br.lists.items) do self.items[name] = id end
    self.pets  = br.lists.pets

    -- Compile spell lists and build the profile API
    if spec == br.loader.selectedSpecID and (self.talent == nil or self.cast == nil) then
        self:rebuild()
    end

    br.debug.cpu:updateDebug(loadStart, "rotation.loadTime")
    return self
end
