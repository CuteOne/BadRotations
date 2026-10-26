# BadRotations — Agent Guidelines

BadRotations is a World of Warcraft combat rotation automation addon (requires a Lua Unlocker). It supports **Classic, TBC, MOP, Retail, and Forever** expansions.

See [README.md](README.md) for project background and profile status. **API source of truth:** the live module files in `System/API/` are authoritative — when you need to know how an API call works, open the relevant `System/API/*.lua` module and read it. `BadRotations API.md` is legacy documentation; do **not** rely on it for signatures, arguments, or behavior. Profile code should call functions defined in `System/API/`; if a needed function doesn't exist there (and isn't purely profile-specific logic), prefer adding it to the appropriate API module over implementing it inline.

---

## Architecture

The codebase follows strict **layers** — each calls only the one below it (`.tests/layering_check.lua` enforces it):

| Layer | Path | Role |
|------|------|------|
| Profiles | `Rotations/` | Run with the profile API as their environment and reach nothing else: no `br`, no game API |
| Profile API | `br.api.profile` | The tables profiles use (`cast`, `buff`, `cd`, `unit`, `enemies`, `ui`, …), built by the `br.api.build.*` builders in `System/API/`; they call `br.functions` (and the engines and readers) |
| Functions | `br.functions.*` | Range checks, aura scans, unit queries, casting (`System/Functions/`), with the engines and readers; they call `br.game` |
| Game | `br.game` | The game's API as BR sees it: BR's own versions, polyfills, the unlocker, the client (`Expansions/Layers.lua`); write against the modern API. Polyfills (`br.client.polyfills`, `Expansions/Polyfills.lua`) give the modern API where a client lacks it; code calls `br.game`, not them |

The runner, `br.runner` (`System/Loader/Rotation.lua`), sits beside the profile API: it builds it, keeps the spec's compiled spell lists (`br.runner.spells`) and per-tick state (`br.runner.state`), and runs the selected rotation each tick.

**Key directories:**

| Path | Purpose |
|------|---------|
| `BadRotations.lua` | First file: BR's tables and `br.lifecycle` (start / frame / tick / power-off / logout steps that modules register) |
| `Expansions/` | The client layer: `Layers.lua` (`br.game`'s layers), `Flavours.lua` (which client, its game rules), `Polyfills.lua` (the modern API where a client lacks it); `{Retail,MOP,TBC}/Functions.lua` hold code only that client needs; each flavour folder holds its spell lists |
| `System/Bootstrap.lua` | The startup stages, from entering the world to running: unlocker → spell lists → rotations → profile → settings → build → UI → running |
| `System/Core.lua` | The rotating body: one frame loop running the frame and tick steps (`br.core`) |
| `System/API/` | 20 API modules (Buff, Cast, CD, Unit, Spell, Enemies, Power, Talent, …) |
| `System/Engines/` | Game systems: EnemiesEngine, HealingEngine, Tracker, LootEngine |
| `System/Readers/` | Event readers: the combat log and other game events |
| `System/Loader/` | `ProfileLoader` (finds/runs rotation files in the profile API, `registerRotation`, `loadSupport`), `SpellCompiler` (spell lists, talents, ranks), `ProfileAPI` (`br.api.profile`: the profile environment and its build), `ProfileUI` (options window pages, toggle bar), `Rotation` (`br.runner`: the runner and its per-tick update) |
| `System/UI/` | Windows, option elements (`Elements/`: `br.ui:section`, `br.ui:checkbox`, `br.ui:spinner`, `br.ui:dropdown`, …), toggles (`Toggles/`: `br.ui:toggle`), settings storage (`SettingsManagement`) |
| `Rotations/{Class}/{Spec}/` | Rotation profile Lua files |
| `Settings/{Flavour}/{Class}/{Spec}/` | Saved settings per flavour and spec/profile |
| `Libs/` | Third-party libs (LibStub, DiesalGUI, LibSharedMedia) |
| `Unlockers/` | Unlocker integrations (daemonic, nn, tinkr) |

---

## Rotation Files

**Location:** `Rotations/{Class}/{Spec}/{ProfileName}.lua`  
**Reference example:** [Rotations/sample rotation.lua](Rotations/sample%20rotation.lua)

Every rotation file **must** follow this structure (order matters):

```lua
local rotationName = "AuthorName"

local function toggles()
    -- Toggle bar buttons (see "Toggles and Options" below)
    ui.toggle("Rotation", { key = "RightShift", modes = {
        { name = "Auto", icon = "whirlwind", overlay = "Automatic Rotation", tip = "..." },
        { name = "Off",  icon = "enragedRegeneration", overlay = "DPS Rotation Disabled", tip = "..." },
    } })
end

local function options()
    -- The Rotation Options page: sections and options (see "Toggles and Options" below)
    local section = ui.section("General")
    ui.checkbox(section, "Some Option", { checked = true, tip = "..." })
end

-- The profile API is there by name (cast, buff, unit, ui, var, ...); keep your own names local
local energy

-- Action lists return true if a spell was cast (stops fallthrough)
local actionList = {}
actionList.PreCombat  = function() ... end
actionList.Interrupt  = function() ... end
actionList.Defensive  = function() ... end
actionList.Cooldown   = function() ... end
actionList.SlayerMt   = function() ... end  -- Main rotation

local function runRotation()
    energy = power.energy()         -- per-tick values
    units.get(5); enemies.get(8)    -- build dynamic tables

    if actionList.Defensive() then return true end
    if unit.inCombat() and unit.valid("target") then
        if actionList.Interrupt() then return true end
        ...
    end
end

-- Registration — BR loads every file in the class/spec folder; each file registers itself.
-- Spec IDs: https://wowpedia.fandom.com/wiki/SpecializationID
registerRotation({
    name      = rotationName,
    specID    = 250,              -- or a list, e.g. { 250, 251 }
    expansion = "Retail",         -- "Retail", "MOP", "TBC", "Classic", "Forever", or a list
    author    = "AuthorName",     -- optional README metadata: author, patch, coverage, status, readiness
    toggles   = toggles,
    options   = options,
    run       = runRotation,
})
```

**Rules:**
- Action lists **must return `true`** after a successful cast.
- Always call `unit.valid("target")` before targeting operations.
- Use `ui.debug("msg")` for debug prints (tied to the "Enable Debug" option).
- Spell references: number `123456`, string `"Fireball"`, or ranked table `{123456, 123457}` (highest known rank is auto-selected).
- A profile sees only the profile API: the tables in `System/API/` by name (`cast`, `buff`, `debuff`, `cd`, `charges`, `unit`, `units`, `enemies`, `ui`, `module`, `power`, `talent`, `spell`, `has`, `use`, `equiped`, `pet`, `totem`, `glyph`, `heroTree`, `imbues`, `var`), `registerRotation`, `loadSupport` and Lua's standard library (`System/Loader/ProfileAPI.lua`). No `br`, no game API: reading any other name, or setting a global, is an error that names the line (`.tests/profile_env_check.lua` checks every profile). If a profile needs something the API lacks, add it to the API (and Functions below it).
- `var` keeps values between ticks, is shared with the support files the profile loads, and starts empty for each spec.
- The API is built after the profile files load, so nothing at file level may call it (`local t = ui.time()` at the top errors); call it in `toggles`, `options` and `run`.
- Register with `registerRotation` only — it validates the definition and offers the rotation only when `specID` and `expansion` match the player. Optional flags: `actsWhileCasting`, and `handlesRacials` / `handlesTrinkets` when the rotation uses racials / trinkets itself (the shared modules then don't).
- README metadata (`author`, `patch`, `coverage`, `status`, `readiness`) lives in the registration table; `.github/scripts/update_readme.py` reads it from there.
- Support files (e.g. Hunter pets) return their table (`return { options = ..., run = ... }`); the profile loads one at the top with `local petSupport = loadSupport("PetCuteOne")`.
- Rotations retired when profiles moved to the profile API (they didn't convert cleanly) are in `Rotations/Retired.zip`, with the reasons in its `RETIRED.txt`.

### Toggles and Options

Rotations build their toggle bar and options with short methods on their `ui` (`System/API/UI.lua`, which hands them to `br.ui`). Each takes a name, then a table of only the settings that differ from the defaults. Every method lives in its element's file with a `---@class` block listing each field and its default (VS Code with the Lua extension autocompletes them).

| Method | File | Required | Notable fields (defaults) |
|--------|------|----------|---------------------------|
| `ui.toggle(name, {...})` | `System/UI/Toggles/ToggleFunctions.lua` | `modes` (each needs `name`) | mode: `icon` (spell key or ID), `overlay`, `tip`, `highlight` (first mode only); `key` (None), `row` (0), `col` (next free) |
| `ui.section(name, {...})` | `System/UI/Elements/Section.lua` | name | `tip`, `window` (profile window); returns the section |
| `ui.checkbox(section, name, {...})` | `Elements/Checkbox.lua` | name | `checked` (false), `tip` |
| `ui.spinner(section, name, {...})` | `Elements/Spinner.lua` | name | `value` (min), `min` (0), `max` (100), `step` (5), `checkbox` (true), `checked` (false), `tip`, `boxTip` |
| `ui.doubleSpinner(section, name, {...})` | `Elements/Spinner.lua` | `first`, `second` | each `{ value, min, max, step, tip }`; `checkbox` (true), `checked` (false) |
| `ui.dropdown(section, name, {...})` | `Elements/Dropdown.lua` | `choices` (list, or a `ui.dropOptions` name) | `value` (choice text or position; first), `checkbox` (true), `checked` (false), `tip`, `boxTip` |
| `ui.text(section, text)` | `Elements/Text.lua` | — | — |

- Spinners and dropdowns get a checkbox (enable/disable) unless `checkbox = false`.
- The rotation reads them with `ui.checked("Name")`, `ui.value("Name")` and `ui.mode.<toggle>` (e.g. `ui.mode.rotation`).
- `options` is the function that builds the Rotation Options page. For several pages, `options` is a list instead: `{ { "Page Name", buildFunction }, ... }`.
- BR adds a "Toggle Keys" section (one keybind per `key`) to the first page, restores each section's collapsed state, and shows plain tips in white (coloured text is kept as written).
- Module options (`module.BasicHealing(section)`) can sit between the short methods.
- The runtime check of a key option is `ui.toggleKey("Name")` (true while its key is held).
- BR's own windows use the same methods on `br.ui` (`br.ui:section`, `br.ui:checkbox`, …): Bot Options (`System/UI/Windows/Config.lua`), Base Options (`System/Loader/ProfileUI.lua`) and module options (`System/API/Module.lua`). Every window page restores its sections' collapsed state when it finishes building (`System/UI/Elements/PageDropdown.lua`).
- Mistakes (a missing name or required field, an unknown or mistyped field, a dropdown value that isn't a choice) print in red with the rotation's file and line; that entry is skipped and the rest loads.

---

## Settings Files

BR writes these itself (`System/UI/SettingsManagement.lua`); rotations never create settings files.

| File | Holds | Shared by |
|------|-------|-----------|
| `Settings/<Flavour>/Characters/<Realm>-<Name>/BotOptions.lua` | Bot Options window, window layout | that character |
| `Settings/<Flavour>/Characters/<Realm>-<Name>/<Spec>/BaseOptions.lua` | Base Options page | that character + spec |
| `Settings/<Flavour>/<Class>/<Spec>/<Profile>/settings.lua` | Rotation Options pages + toggle states | every character of that class |
| `Settings/<Flavour>/<Class>/<Spec>/selection.lua` | The selected profile | that class + spec |
| `Settings/<Flavour>/<Class>/<Spec>/<Profile>/Snapshots/<Name>/` | "Load Saved Profiles" sets (Solo, Dungeon, M+ Dungeon, Raid): Base + Rotation Options | every character of that class |
| `Settings/<Flavour>/Exported Settings/<Class>/<Spec>/<Profile>/` | Export/Import: copies of all three files | — |

Each WoW flavour keeps its own settings under `Settings/<Flavour>/`, named by `br.client.flavour` (Retail, Classic, TBC, MOP, Forever), so profiles of the same name in different flavours never share a file. Files from before the split (directly under `Settings/`) are read until the flavour has its own copy and are left in place; new characters are only seeded from characters of the same flavour.

In memory they are merged into `br.data.settings[spec][slot][page][option .. " Check" / " Status" / " Drop"]`, where `page` is the section's storage name. Each save keeps `.bak1`–`.bak3` backups and refuses saves that look like lost settings (mostly empty, or most customised options back at their defaults). Loading a snapshot or an import replaces the live files (the replaced ones become `.bak1`); snapshots and exports in the old single-file format (`savedSettings.lua`) are converted when loaded.

At the end of startup BR runs every options page once without building frames (`settingsManagement:registerAllOptions`, using `br.ui.elementOptions.withoutFrames`) so every option registers its page and default; `cleanSettings` then removes saved settings no option owns.

---

## Key API Modules (`br.api.profile`)

| Name in profiles | Module file | Common calls |
|-------------|-------------|--------------|
| `cast` | `System/API/Cast.lua` | `cast.fireball("target")`, `cast.able.fireball("target")` |
| `buff` | `System/API/Buff.lua` | `buff.combustion.exist()`, `.remain()`, `.stack()` |
| `debuff` | `System/API/Debuff.lua` | Same signature as `buff` but for hostile auras |
| `cd` | `System/API/CD.lua` | `cd.pyroblast.remain()`, `.active()` |
| `unit` | `System/API/Unit.lua` | `unit.hp("target")`, `.distance()`, `.inCombat()`, `.valid()` |
| `enemies` | `System/API/Enemies.lua` | `enemies.get(8)` → `enemies.yards8[i]` |
| `power` | `System/API/Power.lua` | `power.mana.current()`, `.deficit()` |
| `talent` | `System/API/Talent.lua` | `talent.talentName` (boolean) |
| `ui` | `System/API/UI.lua` | `ui.checked("option")`, `.value("option")`, `.mode[]` |
| `units` | `System/API/Units.lua` | `units.get(5)` → `units.dyn5`; `units.friends` (group members) |
| `pet` | `System/API/Pet.lua` | `pet.active.exists()`, `pet.attack(unit)`, `pet.setMode("passive")` |

**Casting:** write the profile's own conditions, then `cast.<spell>()`. The cast system runs every check itself (known, usable, power, cooldown, unit, range, sight, facing) and the Rotation Log records why a cast it refused didn't go out, so `cast.able.<spell>()` isn't needed before it. Use `cast.able` only to ask without casting (choosing between spells, or deciding to leave a form first); its refusals are only counted in a fight's summary, never logged as rows.

---

## Lua Conventions

- Addon namespace: `local _, br = ...` — never pollute globals. BR's tables are declared in `BadRotations.lua`.
- Module registration pattern: `br.functions.X = br.functions.X or {}`.
- Method syntax: use `:` for self-methods, `.` for stateless helpers.
- `System/API/` files contain **only** API functions — no `local function` helpers; put those in `System/Functions/` (API factories are `br.api.build.*` builders, each filling its table in `br.api.profile`). Within each builder, functions are **sorted alphabetically**, because the API docs are generated from these files.
- Per-tick player state lives in `br.runner.state` (`gcd`, `gcdMax`, `health`, `inCombat`, `instance`, position); profiles use the API (`unit.inCombat()`, `unit.instance()`, `unit.hp()`) instead.
- When renaming or moving an API, update every caller in the repo; do not leave compatibility aliases or shims.

---

## Editor Types

`Types/ProfileAPI/` holds type definitions for the Lua language server (VS Code: the "Lua" extension by sumneko), so profiles get completion and hover docs for the profile API: `cast.` lists every spell key, `buff.<key>.` its functions, `unit.hp(` its parameters. The files are generated from the `--- ` doc blocks in `System/API/` (each names its function with `@function`; per-key parts in angle brackets, e.g. `@function buff.<spell>.exists`), the profile environment in `System/Loader/ProfileAPI.lua` and every flavour's spell lists. After changing any of those, run `luajit Types/generate.lua` from the BR folder and commit the result. The game never loads `Types/`.

## No Build Step

The addon loads directly as Lua files — no compilation or bundling needed. API documentation can be generated with `config.ld` (LDoc). There are no automated tests.

To add a new rotation: create `Rotations/{Class}/{Spec}/{Name}.lua` (on expansions without specs, `Rotations/{Class}/{Class}/`) ending with the `registerRotation` block above. `System/Loader/ProfileLoader.lua` loads every file in that folder, and the registration decides whether the rotation is offered for the player's spec and expansion.
