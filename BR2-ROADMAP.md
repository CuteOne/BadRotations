# ROADMAP

## Code Standards
### Files
1. **FILES** should be descriptive of the functionality.  Examples: BRDebug contains functions related to debugging like print to chat, output to debug window, maybe logging to file.  If the code being developed relates to any form of debug logging it must exist within the BRDebug file.

### Code Annotation
1. Each module should be specific to a single type of functionality and be defined as a class using ---@class
2. Classes need to be initialized using the BRLoader:CreateModule([ModuleName]) method and be retrieved using the BRLoader:LoadModule([ModuleName]) method.
    Example:

```
local _,br,_ = ...

---@class BRDebug
local BRDebug = BRLoader:CreateModule("BRDebug")

---@type BRConstants
local BRConstants = BRLoader:LoadModule("BRConstants")

---@param message string @Message to log
---@return nil
function BRDebug:Log(message)
        br._G.print(BRConstants.colors.purple .. "[BR2] " .. BRConstants.colors.white .. message .. "|r")
end
```
   
3. Each method inside of the class must be annotated with ---@params, etc.  See documentation here: https://github.com/LuaLS/lua-language-server/wiki/Annotations

### Environment
1. Each file has three enivonment objects passed to which should be retrieved at the beginning of the file. These are assigned during injection.  The developer should primarily be concerned with the second argument which is the global br object.  The third is access directly to the unlocker but given the agnostic approach of all modules this should not be used within the core code.  Access to the unlocker should only be made in code within the "init' directory.   This is currently in play only during initial development and **WILL BE REMOVED** before general consumption.
```
local _,br,_ = ...
```

### Naming
3. "**br**" remains the global add-on variable
4.  **Functions** should be named with PascalCase. That is fully capitilized full words, example: RunSomethingReallyCool()
5.  **Variables** should be named with CamelCase. That is a lower case inital word followed by capitalized words.  example: br.someStorageVariable = nil

## Overall Goals
1. Make system compatible with classic, Cataclysm, and retail without separate builds or branches
2. Focus on human style rotation logic.  This will include randomized pulses, facing of targets, dynamic targeting, etc.
3. Support the three current Unlockers, Nil-Name, Tinkr, and Daemonic (if it ever resurfaces, currently not supported)
4. Focus on rotations only.  Don't port over any code that doesn't related to Damage, tank, or healing rotations. (i.e. no fishing, quest, movement, etc.)  This may change in the future but the first pass will attempt to reduce the addOn's footprint and reduce latency.
5. Remove dependency on manually reading the WOW table of contents file and instead handle injection of code in unlocker specific files.  Unlockers that do not support injecting code will not be supported.
6. Change settings files to JSON. All current unlockers support JSON code/decode.

## Future Nice-To-Haves
1. UI Improvements:  Object Browser, Object Highlighting/lines, Damage/DPS meter/graph,
2. UI Improvements:  wider configuration to avoid clipping
3. HTTP Request   :  Possibly allow loading of routine from a location

## Current Progress
- [x] Remove TOC
- [x] Move injection of files to unlocker specific code, minimize _BRLoader.lua code to three or four lines, just enough to spawn project unlocker initialization.
- [x] Specific unlocker loaders, configurations
- [x] Implement NilName Unlocker for initial development
- [x] Implement specific loading of files based on client version (Classic, Cata, Retail)
- [x] Implement Object Manager copy
- [ ] Re-do file injection to support pre/unlocked post/unlocked category
- [ ] Create TOC files, including per-client TOCs, maybe use scripting to build this so it's always up to date.
- [ ] Implement Object Browser for development
- [ ] Implement Settings class to handle global and rotation specific settings in JSON files
- [ ] Implement Object Filter for Units, and Unit tracking
- [ ] Implement Aura tracking
- [ ] Implement Spell system maintaining separation of client versions


