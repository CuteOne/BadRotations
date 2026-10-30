---
description: "Use when writing, editing, or reviewing BadRotations rotation profiles in Rotations/**/*.lua. Covers what a profile may touch, the profile API, casting, action lists, toggles, options and registration."
applyTo: "Rotations/**/*.lua"
---
# Rotation profile conventions

The guide for profile authors is [Rotations/Writing a profile.md](../../Rotations/Writing%20a%20profile.md), and the skeleton to start from is [Rotations/sample rotation.lua](../../Rotations/sample%20rotation.lua). Follow them; this file lists the rules an AI most often gets wrong.

## Stay at profile level

When helping someone with their own profile (unless they say they are working on BR itself):
- Write only their profile file, in `Rotations/<Class>/<Spec>/` (`Rotations/<Class>/<Class>/` on versions without specs), plus a support file of their own in `Rotations/<Class>/Support/` if they need one.
- Don't change `System/`, `Expansions/` (the spell lists included), `Libs/`, `Settings/`, `Types/`, `.github/` or other people's profiles. Reading them is fine.
- When BR seems to lack something, or a spell isn't in the class's list, tell the user what and why so they can report it. Don't work around it or extend BR.

## The profile environment

- A profile sees only the profile API by name (`cast`, `buff`, `debuff`, `cd`, `charges`, `unit`, `units`, `enemies`, `ui`, `module`, `power`, `talent`, `spell`, `has`, `use`, `equiped`, `pet`, `totem`, `glyph`, `heroTree`, `imbues`, `var`), `registerRotation`, `loadSupport` and Lua's standard library. No `br.`, no WoW API (`UnitHealth`, `C_Spell`, ...), no globals: any other name is an error.
- The API is built after the file loads. Call it only inside `toggles`, `options`, `runRotation` and the action lists, never at file level.
- Don't copy the API tables into locals or re-bind them each tick (old profiles did, from `br.player`). Keep only your own values as file-level `local`s.
- Use only functions from the guide, the sample, or the API reference (<https://cuteone.github.io/BadRotations/>, generated from `System/API/`). Don't invent functions.
- Spells, buffs and debuffs are named by their keys in the class's lists: `Expansions/<Version>/<CLASS>/Class.lua` (plus a spec file on Retail and MoP) and `Expansions/<Version>/Global.lua`, under `abilities`, `buffs` and `debuffs`. Use the key exactly as written there (`cast.lightningBolt`, not a spell ID or name).
- Leave the generated `-- Editor types:` block at the top of a profile as it is.

## Casting and action lists

- One call per action: `if cast.<spell>(unit) then return true end`. `cast.<spell>()` checks known, usable, power, cooldown, range, line of sight, facing and the GCD itself. Don't put `cast.able.<spell>()`, range, cooldown or power checks in front of it. Add only the conditions that are the player's choice ("under 20% health").
- `return true` ends the tick after one action, and every action list hands that `true` back to `runRotation`.
- `cast.able.<spell>()` asks without casting. Use it only to choose between spells.
- Don't check paused, mounted, flying, taxi or dead: BR doesn't run the rotation then, and checking it yourself breaks the pause exceptions. While the player casts, BR holds new casts; `cast.<spell>.whileCasting()` and `cast.cancel.<spell>()` are the exceptions.
- The enemy to attack is `enemy = units.get(40)` (or `units.get(5)` for melee range) at the top of `runRotation`. It is `nil` when there is none, so check `enemy` before using it. Use `enemies.get(8)` then `#enemies.yards8` to count enemies, and `ui.useAOE(8, 3)` for the Rotation toggle's AoE decision.
- Racials and trinkets: BR's Base Options use them. A profile that casts them itself (`cast.racial()`, `use.slot(13)`) takes them over automatically; no flag is needed.
- Debug output is `ui.debug("text")`, never `print`.

## Every level

A profile must play well from level 1 to max level. A spell not learned yet simply isn't cast. Where the rotation depends on one, ask `spell.<name>.known()` (or `talent.<name>` on Retail) and give a fallback. Don't hardcode thresholds that only make sense at max level.

## Toggles and options

- Keep the sample's four toggles (Rotation, Cooldown, Defensive, Interrupt) with their names and mode order: `ui.useAOE`, `ui.useCDs`, `ui.useDefensive`, `ui.useInterrupt` and `ui.mode.rotation == 4` (Off) read them. Add new toggles after them.
- Options: `ui.section`, `ui.checkbox`, `ui.spinner`, `ui.dropdown`, `ui.text`, each given only the fields that differ from the defaults (listed in the guide's Options section and in `System/UI/Elements/`). Read them with `ui.checked("Name")`, `ui.value("Name")` and `ui.alwaysCdNever("Name")`, using exactly the same names.
- Don't write a "Toggle Keys" section: `key =` on a toggle adds it.
- Never create settings files; BR writes them.

## Registration

The file ends with one `registerRotation({...})` holding `name` (unique for the spec), `specID`, `expansion` (exactly one of `"Retail"`, `"MOP"`, `"TBC"`, `"Classic"`, `"Forever"`), optional `author`, and `toggles`, `options`, `run`. Another game version needs another file. Spec IDs: <https://warcraft.wiki.gg/wiki/SpecializationID>; on versions without specs, copy it from another profile in the same folder.
