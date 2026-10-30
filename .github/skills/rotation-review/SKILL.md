---
name: rotation-review
description: "Review a BadRotations rotation profile against the profile conventions and fix what's wrong. Use to review, audit, check or validate a rotation profile in Rotations/, or when a profile errors, never casts a spell, or plays badly at some level."
argument-hint: "path to the rotation file (or leave blank for the open file)"
---
# Rotation review

Checks a rotation profile against [the rotation conventions](../../instructions/rotation-conventions.instructions.md) and [Writing a profile.md](../../../Rotations/Writing%20a%20profile.md).

## Procedure

1. Take the file from the argument, or use the file open in the editor.
2. Read it in full. From its `registerRotation`, find the game version and class, and read that class's spell lists: `Expansions/<Version>/<CLASS>/Class.lua`, the spec's file there if there is one, and `Expansions/<Version>/Global.lua`.
3. Go through the checklist. For each problem, show the line, say what goes wrong in game, and show the fix.
4. Apply the fixes once the user agrees. Change only this profile (and its own support file). If a fix needs something BR doesn't offer, say so and suggest the user report it. Don't change BR's files.

## Checklist

### Environment
- [ ] No `br.`, no WoW API (`UnitHealth`, `GetSpellInfo`, `C_*`, ...), no globals. Only the profile API, `registerRotation`, `loadSupport` and Lua's standard library.
- [ ] No API call at file level: the API exists only inside `toggles`, `options`, `runRotation` and the action lists.
- [ ] No re-binding of API tables (`cast = br.player.cast`, `local buff = ...`). The tables are already there by name.
- [ ] No functions that aren't in the guide, the sample or the API reference (<https://cuteone.github.io/BadRotations/>, or `System/API/`).
- [ ] The `-- Editor types:` block at the top is untouched.

### Spells
- [ ] Every `cast.`, `buff.`, `debuff.`, `cd.`, `spell.` and `charges.` key is in the class's lists, spelled exactly the same (case-sensitive).

### Casting and action lists
- [ ] Each action is `if cast.<spell>(...) then return true end`, and each action list's `true` reaches `runRotation`.
- [ ] No `cast.able.<spell>()`, range, cooldown, power or known check in front of the same spell's `cast` (except a `known()` used to choose a fallback spell).
- [ ] No checks for paused, mounted, flying, taxi or dead. They override BR's pause exceptions.
- [ ] The enemy comes from `units.get(...)` and is checked for `nil` before use.
- [ ] Enemy counts use `enemies.get(N)` before `#enemies.yardsN`.
- [ ] No `print`; debug lines use `ui.debug`.

### Every level
- [ ] Where the rotation relies on a spell learned later (or a talent), there is a fallback for characters without it.
- [ ] Thresholds don't assume max-level resources or gear.

### Toggles and options
- [ ] The four standard toggles (Rotation, Cooldown, Defensive, Interrupt) come first, with their names and mode order as in the sample.
- [ ] Each `ui.checked` / `ui.value` / `ui.alwaysCdNever` name matches an option defined in `options`, capitals included.
- [ ] Option fields are the documented ones (`checked`, `value`, `min`, `max`, `step`, `checkbox`, `choices`, `tip`, ...). BR prints unknown fields in red at load.
- [ ] No hand-written "Toggle Keys" section.

### Registration
- [ ] One `registerRotation({...})` at the end, with `name`, `specID`, `expansion`, `toggles`, `options` and `run`.
- [ ] `expansion` is exactly one of `"Retail"`, `"MOP"`, `"TBC"`, `"Classic"`, `"Forever"`, and matches the spell lists the profile uses.
- [ ] `specID` matches the folder's spec, and `name` is unique among that spec's profiles for that version.

If `luac5.1` is installed, `luac5.1 -p <file>` catches syntax errors. For problems that only show in game, ask the user for `Logs/Errors.log`, `/br why <spell>` and the Rotation Log (see "Trying it in game" in the guide).
