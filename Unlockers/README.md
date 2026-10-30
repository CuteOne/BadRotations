# Unlocker adapters

BadRotations (BR) reaches the game's protected and hidden functions through an **adapter**: a Lua file
that translates one unlocker's API into the functions BR expects. This page is BR's side of that
contract, for anyone adding support for an unlocker. That includes a private or personal one: you can
write your own adapter and loader without changing BR.

Player set-up for the supported unlockers is in [3rd Party Files/README.md](../3rd%20Party%20Files/README.md).

| Unlocker | Adapter | Loader |
|----------|---------|--------|
| NilName (NN) | [`nn.lua`](nn.lua) | [`3rd Party Files/NoName/_BRLoader.lua`](../3rd%20Party%20Files/NoName/_BRLoader.lua) |
| Daemonic | Daemonic's own: it writes `Unlockers/daemonic.lua` at launch | Daemonic's `BR-Loader.lua` |

## How BR picks an adapter

[`System/Unlockers.lua`](../System/Unlockers.lua) holds the adapters in priority order:
- adapters registered with `registerAdapter` come first, newest first;
- then the built-in ones: `NNUnlock`, `DaemonicUnlock`.

From the first pulse on, BR calls each adapter's unlock function in turn until one returns `true`. The
function is called again on later pulses until one does, so it must be cheap and quiet when its
unlocker isn't there.

An unlock function:
- returns `false` quietly when its unlocker isn't present;
- otherwise writes its functions into `br.game` (they land in `br.unlockers.functions`, one of
  `br.game`'s layers, [`Expansions/Layers.lua`](../Expansions/Layers.lua)) and returns `true`.

```lua
br.unlockers:registerAdapter("MyUnlocker", function(unlockers) ... return true end)
```

`registerAdapter` exists once `System/Unlockers.lua` has run, so call it from a file loaded after BR's
toc files (see [Loading BR](#loading-br)).

Once an adapter is picked, BR:
- sets `br.unlockers.selected` to its name and `br.unlocked` to true;
- checks every function in `br.unlockers.needed` and lists the ones neither the adapter nor the client
  provides in `br.unlockers.missing`;
- writes both to `Logs/Session.log`;
- sets the Spell Queue Window to 400 ms (restored on logout) and points BR's UI media at
  `Interface\AddOns\Media`.

## Objects

BR passes units around as either:
- **unit tokens**: `"player"`, `"target"`, `"mouseover"`, `"party1"`, ...;
- **objects**: whatever your object manager returns for a unit or game object.

Every function below that takes a unit must accept both. So must the game's own unit functions as BR
reads them through `br.game` (`UnitHealth`, `UnitCanAttack`, `UnitAura`, ...), with your unlocker's
versions written into `br.game` where the client's don't take objects.

**One object, one value.** `GetObjectWithIndex`, `GetObjectWithGUID`, `ObjectPointer`, `UnitTarget` and
`UnitCreator` must give the same value for the same object, so that it:
- compares equal with `==`;
- works as a table key, at least for the rest of the frame.

BR keys its enemy and damage tables by these values and compares them (for example
`UnitCreator(pet) == ObjectPointer("player")`). The two shipped approaches:
- NN: its object;
- Daemonic: the object's GUID string.

## Functions BR needs

These are in `br.unlockers.needed` (`System/Unlockers.lua`), and Session.log names any that are
missing. `object` means an object or a unit token.

### Object manager

| Function | Returns |
|----------|---------|
| `GetObjectCount()` | How many objects there are. Takes the snapshot `GetObjectWithIndex` reads, so read the object list once here. |
| `GetObjectWithIndex(index)` | The object at that index, 1 to the count; nil past the end |
| `GetObjectWithGUID(guid)` | The object with that GUID, or nil |
| `ObjectPointer(object)` | The object for a unit token (or the object itself), or nil when there is none |
| `ObjectExists(object)` | Whether it exists |
| `ObjectIsUnit(object)` | Whether it's a unit (object type 5) |
| `ObjectIsGameObject(object)` | Whether it's a game object (types 8 and 11) |
| `ObjectID(object)` | Its creature or game object ID (number) |
| `ObjectName(object)` | Its name |

### Positions and unit fields

| Function | Returns |
|----------|---------|
| `ObjectPosition(object)` | `x, y, z` in world yards; nil when unknown |
| `ObjectFacing(object)` | The direction it faces, in radians from 0 to 2π |
| `UnitTarget(unit)` | The unit it is targeting (not its cast's destination), or nil |
| `UnitCreator(unit)` | Its creator or summoner (a pet's owner, a totem's shaman), or nil |
| `UnitBoundingRadius(unit)` | Its bounding radius, yards |
| `UnitCombatReach(unit)` | Its combat reach, yards |
| `TraceLine(x1, y1, z1, x2, y2, z2, flags)` | `x, y, z` where the line first hits something, or **nil when it hits nothing** |

`TraceLine` flags, combined with `bit.bor`, as BR uses them:

| Flag | Hits |
|------|------|
| `0x1` | doodads (M2) |
| `0x10` | buildings (WMO) |
| `0x100` | terrain |
| `0x100000` | entities |

Line of sight is `0x10 + 0x100`.

### Ground spells and the screen

| Function | Does |
|----------|------|
| `IsAoEPending()` | Whether a ground-targeted spell is waiting for its click |
| `CancelPendingSpell()` | Cancels that |
| `ClickPosition(x, y, z)` | Clicks the ground at that world position, placing the pending spell |
| `GetMousePosition()` | The cursor's screen position, `x, y`, as `ScreenToWorld` takes it |
| `ScreenToWorld(x, y)` | The world position, `x, y, z`, under that screen position |

### Actions

| Function | Does |
|----------|------|
| `ObjectInteract(object)` | Interacts with it (loot, talk, open) |

BR also calls these game functions, which are protected. Your adapter either:
- writes unlocked versions of them into `br.game` (as `nn.lua` does through NN's `Unlock`); or
- lets BR run untainted, so it can call the client's own (see `protect` below).

`AcceptProposal`, `AscendStop`, `CancelShapeshiftForm`, `CastPetAction`, `CastShapeshiftForm`, `CastSpellByID`,
`CastSpellByName`, `ClearTarget`, `DeleteCursorItem`, `DestroyTotem`, `JumpOrAscendStart`,
`MoveBackwardStart`, `MoveBackwardStop`, `PetAssistMode`, `PetAttack`, `PetDefensiveAssistMode`,
`PetDefensiveMode`, `PetFollow`, `PetPassiveMode`, `PetStopAttack`, `RunMacroText`, `SpellStopCasting`,
`SpellStopTargeting`, `StartAttack`, `TargetUnit`, `InteractUnit`, `UseContainerItem`, `UseItemByName`.

`CastSpellByName(name, unit)` and `CastSpellByID(id, unit)` are sent with `unit` nil when the game
should choose (yourself, or your target). Don't drop those calls.

### Files

BR keeps its settings and logs in its own folder, so it reads and writes files there.

| Function | Does |
|----------|------|
| `ReadFile(path)` | The file's text, or nil when it doesn't exist |
| `WriteFile(path, text, append)` | Writes the file; with `append`, adds `text` to its end (see `nativeAppend`) |
| `CreateDirectory(path)` | Makes the folder |
| `DirectoryExists(path)` | Whether the folder exists |
| `GetDirectoryFiles(pattern)` | A list of the names (not paths) of the files matching `"folder\*.lua"`; an empty list when there are none |
| `GetWoWDirectory()` | The folder that holds the `BadRotations` folder. If it contains `_retail_`, BR is taken to be in `<it>\Interface\AddOns` instead. |

### Optional

BR does without these:

| Function | Returns | Without it |
|----------|---------|------------|
| `UnitFlags(unit)` | The unit flags field (a number) | no checks that need unit flags |
| `WorldToScreen(x, y, z)` | `sx, sy`: offsets from the top-left of `UIParent`, scaled by its scale, `sy` negative downwards; nil when off screen | no drawings (Tracker, line-of-sight lines) |
| `FaceDirection(radians)` | — | no `/br disengage` |

BR doesn't turn or move the character, except in a profile mode the player turns on (a step back with a
jump that cancels a movement spell's animation, `cast:withMoveAnimationCancel`).

## Other fields an adapter sets

| Field | Set when |
|-------|----------|
| `br.unlockers.protect` | Your unlocker has a protected call, `protect(fn, ...)`, that runs `fn` untainted. On clients with secret values (Retail since Midnight, WoW Forever), BR then runs its frame scripts, timers and hooks inside it, so it can use those values ([`System/Secrets.lua`](../System/Secrets.lua)). Set it when your file loads, not in the unlock function: BR's frames get events before the first pulse. Without it, BR pauses on values it can't use, unless your functions unwrap them (as `nn.lua` does). |
| `br.unlockers.nativeAppend` | Your `WriteFile` appends by itself. Otherwise BR appends by reading the file and writing it back. |
| `br.unlockers.raw` | Your unlocker's own API table, for diagnostics. |

## Loading BR

An unlocker that runs scripts from its own folder needs a **loader**, a small Lua file that runs BR's
files. [`3rd Party Files/NoName/_BRLoader.lua`](../3rd%20Party%20Files/NoName/_BRLoader.lua) is the model.
It does three things:
1. Reads `BadRotations.toc`.
2. Runs each Lua file the toc lists, once, in the toc's order, skipping lines that start with `#` and the
   toc's `Unlockers\` lines. Every file gets `(anything, br)` as its arguments, with `br` the same table
   for all of them; each file starts with `local _, br = ...`.
3. Runs your adapter last.

Your loader doesn't call anything to start BR: BR starts itself once its files have run, on the first
frame after login ([`System/Bootstrap.lua`](../System/Bootstrap.lua)).

Unlockers that load BR as a normal addon (from `Interface\AddOns`, through the toc) can instead add the
adapter to the toc, after `System\Unlockers.lua`.

**Media.** The client loads textures and fonts only from its own `Interface` folder. Players copy
`3rd Party Files/Media` to `Interface\AddOns\Media`, and BR's UI reads it from there. A loader doesn't
need to handle media.

## A minimal adapter

```lua
-- MyUnlocker adapter: run after BR's toc files, with (anything, br) as its arguments
local _, br = ...
local api = MyUnlockerAPI -- however your unlocker exposes its functions

-- A protected call is set as soon as the file loads
if api and api.CallProtected then br.unlockers.protect = api.CallProtected end

br.unlockers:registerAdapter("MyUnlocker", function(unlockers)
    if api == nil then return false end
    local game = br.game

    local objects = {}
    game.GetObjectCount = function() objects = api.GetObjects() return #objects end
    game.GetObjectWithIndex = function(index) return objects[index] end
    game.GetObjectWithGUID = api.GetObjectByGUID
    game.ObjectPointer = api.GetObject
    -- ... every function in "Functions BR needs" ...

    game.TraceLine = function(...)
        local x, y, z = api.TraceLine(...)
        if not x then return nil end -- nil, not false, when nothing is hit
        return x, y, z
    end

    unlockers.nativeAppend = true -- only if api's WriteFile appends
    unlockers.raw = api
    return true
end)
```

## Testing an adapter

- **`Logs/Session.log`**, written when a profile first loads. It has a line naming the adapter BR picked
  and whether it has a protected call, appends to files, and runs on a client with secret values. A
  second line, `unlocker lacks ...`, lists any needed functions it doesn't provide.
- **`/br range`**, with a target selected. It compares BR's distance and melee checks with the game's own
  answers, which exercises `ObjectPosition`, `UnitCombatReach` and `UnitBoundingRadius`.
- **`/br target`**: how BR scored the enemies around you, from your object manager.
- **`Logs/Errors.log`**: Lua errors, with the file and line.
