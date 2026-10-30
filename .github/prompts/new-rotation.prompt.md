---
description: "Write a new BadRotations rotation profile from the sample rotation. Use when someone wants a profile for their class, spec and game version."
argument-hint: "game version, class and spec, e.g. TBC Shaman"
agent: "agent"
---
Write a new BadRotations (BR) profile for the user, following [Writing a profile.md](../../Rotations/Writing%20a%20profile.md) and the [rotation conventions](../instructions/rotation-conventions.instructions.md). Stay at profile level: write only the new profile file.

1. **Ask** for anything the user hasn't said yet. Ask everything in one message:
   - the game version: Retail, MOP, TBC, Classic or Forever;
   - class and spec (only the class on versions without specs);
   - their level, or "levelling";
   - what they do most (solo questing, dungeons, raids, PvP) and their role;
   - how it should play, as plain rules, best first;
   - a profile name, and their name as author.
2. **Read** the class's spell lists: `Expansions/<Version>/<CLASS>/Class.lua`, the spec's file there if there is one, and `Expansions/<Version>/Global.lua`. Every spell, buff and debuff you use must be a key in them. If one of the user's rules needs a spell that isn't listed, or something the profile API doesn't offer, say so and leave that rule out. Don't add it to BR.
3. **Find the folder and spec ID.** The folder is `Rotations/<Class>/<Spec>/`, or `Rotations/<Class>/<Class>/` on versions without specs. Spell the folder the way `System/Lists/Specs.lua` does. Copy `specID` from another profile there for the same version. If there is none, use <https://warcraft.wiki.gg/wiki/SpecializationID>. On versions without specs, if no profile shows it, leave `000` and tell the user that BR prints the number in chat after `/reload`.
4. **Copy** [sample rotation.lua](../../Rotations/sample%20rotation.lua) to `<folder>/<ProfileName>.lua`, then fill it in:
   - Keep its layout and four toggles. Use the class's own spells for the toggle icons.
   - Turn each of the user's rules into lines in the action lists, `if cast.<spell>(...) then return true end`, with a short plain-English note above each.
   - Remove the sample's example options and add the user's own.
   - Fill in `name`, `specID`, `expansion` and `author` in `registerRotation`.
5. **Check** the file against the conventions before handing it over:
   - every key is in the lists;
   - no `br.` or WoW API;
   - no API call at file level;
   - no `cast.able` or range checks in front of a cast;
   - a fallback wherever a spell may not be learned yet at the user's level.

   If `luac5.1` is installed, `luac5.1 -p <file>` catches syntax errors.

Then tell the user:
- the file's path;
- that `/reload` in game makes the profile appear in the rotation list;
- which rules you left out, and why.

Point them to "Trying it in game" in the guide for testing, and ask them to paste back any error from `Logs/Errors.log` and what `/br why <spell>` says about a spell that never goes out.
