-- BadRotations loader for NN (NilName). Copy it into NN's scripts folder, next to the BadRotations folder
-- (see 3rd Party Files/README.md). It runs BR's Lua files in BadRotations.toc's order, then BR's NN adapter;
-- every file gets (Nn, br) as its arguments. BR starts itself once its files have run.
-- BR's icons and fonts come from the copied Media folder, not from here.
local Nn = ...
local root = "/scripts/BadRotations/"
local FileExists, ReadFile = _G["FileExists"], _G["ReadFile"]

local tocPath = root .. "BadRotations.toc"
if not FileExists(tocPath) then
    print("BadRotations: " .. tocPath .. " does not exist")
    return
end

local br = {}
local function run(file)
    Nn:Require(root .. file, br)
end

for line in ReadFile(tocPath):gmatch("[^\r\n]+") do
    local file = line:match("^%s*(.-)%s*$")
    -- Lua files only, and not the toc's adapters: the one for NN is added below
    if file:sub(1, 1) ~= "#" and file:find("%.lua$") and not file:find("^Unlockers[\\/]") then
        run((file:gsub("\\", "/"):gsub("%.lua$", "")))
    end
end
run("Unlockers/nn")
