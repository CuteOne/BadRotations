# Setting up BadRotations with your unlocker

BadRotations (BR) runs through a **Lua unlocker**, a separate program that lets addons like BR use game
functions normal addons can't. BR doesn't include one. This page shows how to set BR up with the
unlockers it supports, and what the files in this folder are for.

## What's in this folder

| Folder | What it is |
|--------|------------|
| `Media` | BR's icons and fonts. Every unlocker needs this copied into the game (step 2 below). |
| `NoName` | The loader file for the NilName unlocker. |
| `Tinkr` | The loader file for the Tinkr unlocker. |

## 1. Get BadRotations

Download BR with the green **Code → Download ZIP** button on
[BR's GitHub page](https://github.com/CuteOne/BadRotations) and extract it, or clone it with git or
[GitHub Desktop](https://desktop.github.com/), which makes updating a single click.

**The folder must be called exactly `BadRotations`**, capitals included. A downloaded ZIP extracts as
`BadRotations-master`, so rename it.

Where the folder goes depends on your unlocker (step 3).

## 2. Copy the Media folder (every unlocker)

Copy the `Media` folder from here (`BadRotations/3rd Party Files/Media`) into your game's `AddOns`
folder, so you have:

```
World of Warcraft\<game version>\Interface\AddOns\Media
```

`<game version>` is the folder of the game you play, such as `_retail_`, `_classic_era_` or
`_anniversary_`. Do this for each game version you use BR on.

WoW only loads pictures and fonts from its own `Interface` folder. Without this step, BR still works,
but its windows have no icons and use the game's default font.

## 3. Set up your unlocker

### Daemonic (Windows)

Get it from [daemonic.cc](https://daemonic.cc/); read the product FAQ there before buying.

1. Put the `BadRotations` folder in the same folder as the Daemonic program.
2. Download [BR-Loader.lua](https://daemonic.cc/downloads/BR-Loader.lua) from Daemonic's site and put it
   in that same folder.
3. Start the game through Daemonic.

### NilName (Windows)

Get it from [nilname.com](https://nilname.com).

1. In the folder with the NilName files, make a folder called `scripts` (if there isn't one), and put
   the `BadRotations` folder inside it: `scripts\BadRotations`.
2. Copy `_BRLoader.lua` from `BadRotations\3rd Party Files\NoName` into the `scripts` folder.
3. Start the game through NilName.

### Tinkr (macOS)

Get it from [tinkr.site](https://tinkr.site/).

1. In the folder with the Tinkr files, make a folder called `scripts` (if there isn't one), and put the
   `BadRotations` folder inside it: `scripts/BadRotations`.
2. Copy `_BRLoader.lua` from `BadRotations/3rd Party Files/Tinkr` into the `scripts` folder.
3. Start the game through Tinkr.

### Other unlockers

BR's support for each unlocker lives in `BadRotations/Unlockers/`. If yours isn't listed here, ask on
[BR's Discord](https://discord.gg/VE7V7Mz) whether it works and how to load BR with it.

## 4. In game

Log in. Chat says "Initializing Please Wait...", then BR's button appears on the minimap. Type `/br` to
turn BR on or off. The [README](../README.md#using-br) explains the rest.

## Updating without losing your settings

Your settings (`BadRotations/Settings/`) and logs (`BadRotations/Logs/`) live **inside** the
`BadRotations` folder, so update over the top of it:
- **git or GitHub Desktop:** pull. Your settings and logs aren't part of the download, so they're kept.
- **ZIP:** extract the new download over your `BadRotations` folder, replacing files, after renaming it
  from `BadRotations-master` as before.

**Don't delete the `BadRotations` folder to install a fresh copy.** That deletes your settings for every
character. If you must start fresh, copy `BadRotations/Settings` somewhere safe first and put it back
afterwards.

When an update changes the `Media` folder, copy it into the game again (step 2).

## Something not working?

See [Reporting problems](../README.md#reporting-problems) in the README. Include `Session.log` and
`Errors.log` from `BadRotations/Logs/`.
