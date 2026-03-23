# Coding Standards

## File Extensions

Use the full lump name as the file extension for all ZDoom/GZDoom definition files. This matches community convention, is self-documenting, and allows editors (such as the GZDoom ZScript VS Code extension) to apply syntax highlighting automatically without project-specific configuration.

| Format | Extension |
|---|---|
| ZDoom DecalDef | `.decaldef` |
| GZDoom GLDefs | `.gldefs` |
| ZDoom Mapinfo | `.mapinfo` |
| ZDoom SndInfo | `.sndinfo` |
| ZDoom ZScript | `.zs` |

Avoid shorthand extensions like `.dd`, `.gl`, or `.snd` — these are ambiguous and non-standard.

### pk3 directory

Everything below the ./zd_daf/ sub directory should be treated like a GZDoom PK3.

Files at the top of the ./zd_daf/ sub directory such as MAPINFO, DECALDEF, SNDINFO and CREDITS are considered the "root lumps" of the PK3.

### `#include` support by lump type

GZDoom's lump parsers vary in capability. Only some support `#include`:

| Lump | `#include` | Strategy |
|---|---|---|
| `zscript.zs` | Yes | Keep actor code in `actors/`, `#include` from root |
| `GLDEFS` | Yes | Keep GL definitions in `actors/`, `#include` from root |
| `MAPINFO` | No | Write directly into this file |
| `SNDINFO` | No | Write directly into this file |
| `DECALDEF` | No | Write directly into this file |

### pk3 directory semantics

GZDoom pk3 directory names are semantically meaningful — files are processed based on which folder they sit in, not just their extension.

- `sprites/` — processed as sprites (equivalent to WAD `S_START`/`S_END`). Only put sprite images here.
- `graphics/` — processed as generic textures/patches. Brightmap and decal images must go here, not in `sprites/`, or GZDoom will process them incorrectly.
- `sounds/` — processed as sound files.

## Comment Conventions

All five lump formats support C++ style `//` line comments. Use these consistently across all file types.

| Format | Comment syntax |
|---|---|
| `.zs` | `//` |
| `.gldefs` | `//` |
| `MAPINFO` | `//` |
| `DECALDEF` | `//` |
| `SNDINFO` | `//` |

Use a `//===...===` banner (75 `=` characters) to open each file and to separate major sections within a file. The banner content should identify the format name and monster name:

```
//===========================================================================
//
// ZDoom SndInfo - Mind Flayer
//
//===========================================================================
```

## Credits and Attribution

Master credits in the monster-specific `.zs` file, and copy them into the single root `CREDITS` lump.

**Why:** Attribution stays co-located with the code it describes. When a monster folder is copied into a new pk3, the credits travel with it automatically. A root `CREDITS` lump is useful for crediting the mod as a whole.

The `.zs` file header should include a credits block immediately after the file-type banner:

```
//===========================================================================
//
// ZDoom ZScript
//
//===========================================================================

//===========================================================================
// Monster Name
//
// Based on: "<Original name>" from <Source>
// Submitted: <Author>
// Code: <Author>
// GLDefs: <Author>
// Sounds: <Author(s)>
// Sprites: <Author(s)>
// Sprite Edit: <Author>
// Source: <URL>
// <License note>
//===========================================================================
```

## Monster Folder Structure

The general structure of files for a monster are:

```
  GLDEFS                                # #include "actors/example_monster/example_monster.gldefs"
  zscript.zs                            # #include "actors/example_monster/example_monster.zs"
  DECALDEF                              # written directly — no #include support, each monster separated by comments block
  MAPINFO                               # written directly — no #include support
  SNDINFO                               # written directly — no #include support, each monster separated by comments block

  actors/
    example_monster.zs                  # ZScript actor definitions
    example_monster.gldefs              # GLDefs definitions
  graphics/
    brightmaps/
      example_monster/                  # brightmap PNG textures
    decaldefs/
      example_monster/                  # decal graphic files (no extension)
  sounds/
    example_monster/                    # OGG sound files
  sprites/
    example_monster/                    # sprite PNGs
      projectiles/                      # projectile sprite PNGs
      <variant>/                        # other sub-actors with their own sprites
```
