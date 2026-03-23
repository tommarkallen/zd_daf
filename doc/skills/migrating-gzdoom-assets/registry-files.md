# Registry File Integration — zd_daf

How to wire a new actor into the five registry files after migration.

---

## zscript.zs

Supports `#include`. Add the new actor file in the correct faction comment block:

```zscript
// Demons - Tanar'ri
#include "actors/succubus.zs"
#include "actors/nalfeshnee.zs"
```

Faction sections in `zd_daf/zscript.zs`:
- `// Weapons`
- `// Models`
- `// Characters`
- `// Demons - Tanar'ri`
- `// Daemons - Chaos Daemons`
- `// Abberations - Illithids`
- `// Furniture`

---

## GLDEFS

Supports `#include`. Add alongside the faction's other entries in `zd_daf/GLDEFS`:

```
// Monsters
#include "actors/succubus.gldefs"
#include "actors/nalfeshnee.gldefs"
```

Create one `.gldefs` file per monster at `zd_daf/actors/<monster_name>.gldefs`.

GLDEFS file format with banner (per coding_standards.md):
```
//===========================================================================
//
// GZDoom GLDefs - Nalfeshnee
//
//===========================================================================

PointLight NalfFire
{
    color 0.3 0.9 0.1
    size 80
}

PulseLight NalfBall11
{
    color 0.2 1.0 0.2
    size 60
    secondarySize 40
    interval 0.5
}

Object Nalfeshnee
{
    Frame NALFI { light NalfFire }
}

Object Nalfeshnee_Ball1
{
    Frame NAP2A { light NalfBall11 }
    Frame NAP2B { light NalfBall11 }
    Frame NAP2C { light NalfBall11 }
}
```

Light types:
- `PointLight` — static point light
- `PulseLight` — oscillates between `size` and `secondarySize` at `interval`
- `FlickerLight` — random on/off flicker
- `SectorLight` — follows sector light level

GLDEFS light names must be unique across the entire PK3. Use a monster-specific prefix (`NalfFire`, `NalfBall11`, etc.) to avoid collisions.

---

## SNDINFO

Does **not** support `#include`. Append new entries directly at the bottom of `zd_daf/SNDINFO`, preceded by a banner:

```
//===========================================================================
//
// ZDoom SndInfo - Nalfeshnee
//
//===========================================================================

Nalfeshnee/attack       NAMATK1
Nalfeshnee/death        NAMDTH1
Nalfeshnee/idle1        NAMIDL1
Nalfeshnee/idle2        NAMIDL2
$random Nalfeshnee/active { Nalfeshnee/idle2 Nalfeshnee/idle1 }
Nalfeshnee/pain         NAMPAN1
Nalfeshnee/sight        NAMSIT1
Nalfeshnee/pr1death     NAPD1
Nalfeshnee/pr1sight     NAPS1
Nalfeshnee/pr2death     NAPD2
Nalfeshnee/pr2sight     NAPS2
Nalfeshnee/spread       NAPSPR
Nalfeshnee/spiritsit    NASPR2
Nalfeshnee/spiritdth    NASPR1
```

Format:
- `Namespace/name    LUMPTOK` — maps namespace path to OGG lump (filename without `.ogg`)
- `$random Alias { Entry1 Entry2 ... }` — random alias that picks one entry each play

ZScript actor properties that reference these:
- `SeeSound "Nalfeshnee/sight";`
- `PainSound "Nalfeshnee/pain";`
- `DeathSound "Nalfeshnee/death";`
- `ActiveSound "Nalfeshnee/active";`

---

## MAPINFO

Does **not** support `#include`. DoomEdNum entries are written directly into the `DoomEdNums` block. Multiple `DoomEdNums` blocks are valid — GZDoom merges them.

### DoomEdNum ranges

| Range | Category |
|---|---|
| 15000-15001 | Weapons (Flashlight, QuakeAxe) |
| 18000-18041 | Models/props (seaweed, rocks, pump jack, etc.) |
| 18042+ | Next available model/prop |
| 19000-19004 | Party characters (Das, DasDog, Fiddler, Shtank) |
| 19100 | Succubus |
| 19110 | Nalfeshnee |
| 19111+ | Next available Tanar'ri demon |
| 19500-19510 | Illithids + Aberrations (MindFlayer=19500, ElderBrain=19504, Grimlock=19510) |
| 19511+ | Next available illithid |
| 19600 | PinkHorror |
| 19700-19701 | BlueImp, MotherImp |
| 20000+ | Furniture/structures |

### Pre-reserved entries

Many entries exist as commented-out lines in MAPINFO. Uncomment these rather than adding new lines:

```
DoomEdNums
{
    // Demons - Tanar'ri
    19100 = Succubus
    19110 = Nalfeshnee      // was: // 19110 = Nalfeshnee
    // 19111 = (next Tanar'ri)
    // 19112 = (next Tanar'ri)
}
```

Search the file for the class name before adding new entries — `grep -i "Nalfeshnee" zd_daf/MAPINFO`.

### Common MAPINFO error

`Unknown property 'title'` — this is a DECORATE-style property. GZDoom MAPINFO uses `levelname`:

```
// Wrong:
map HIVE01 "Hive" { title = "Illithid Hive"; }

// Correct:
map HIVE01 "Hive" { levelname = "Illithid Hive"; }
```

---

## MODELDEF

Supports `#include`. Models go in `zd_daf/models/defs/<category>.modeldef`. Add to `zd_daf/MODELDEF` via `#include`.

### Style 1 — Path directive (skins inside models/skins/)

```
Model Seaweed1
{
    Path "models"
    Model 0 "seaweed.md3"
    Skin 0 "skins/seaweed.png"
    Scale 1.0 1.0 1.0
    DONTCULLBACKFACES
    USEACTORPITCH
    USEACTORROLL
    FrameIndex NO3D A 0 0
    FrameIndex NO3D B 0 1
    ...
}
```

### Style 2 — Full PK3-root paths (skins from textures/ or mixed)

```
Model RocksDark1
{
    Model 0 "models/rocks1.md3"
    Skin 0 "textures/zoon_tex/ZKHXRK03.png"
    Scale 1.0 1.0 1.0
    USEACTORPITCH
    USEACTORROLL
    FrameIndex CDRA A 0 0
}
```

Use Style 2 when the skin comes from `textures/` — the `Path` directive also applies to Skin paths and would break them.

### Multi-surface MD3 (no Skin lines)

```
Model PumpJack
{
    Model 0 "models/pump_jack.md3"
    Scale 50 50 50
    DONTCULLBACKFACES
    USEACTORPITCH
    USEACTORROLL
    FrameIndex PJKA A 0 0
    FrameIndex PJKA B 0 1
    ...
    FrameIndex PJKD A 0 79
}
```

GZDoom resolves skins from paths embedded in the MD3 shader strings. No `Skin` lines needed. If GLDEFS material blocks are provided, their `material texture "..."` paths must match the embedded strings exactly.

### Standard flags

Always include these in every MODELDEF block:
- `DONTCULLBACKFACES` — required for thin geometry (chains, foliage, flat surfaces)
- `USEACTORPITCH` — all props and models
- `USEACTORROLL` — all props and models (zd_daf convention)

Do not copy `offset 0 0 0` lines from source files — zero offset is implicit.

### FrameIndex anomalies

Some source MODELDEF files have authoring bugs (skipped frame indices, duplicate indices). Copy them verbatim — correcting them would change the visual animation rhythm.

---

## CREDITS

Append to `zd_daf/CREDITS`:

```
Nalfeshnee
  Based on "Shadow Beast" from Realm667 Beastiary
  Source: https://www.realm667.com/repository/beastiary/heretic-hexen-style/713-shadow-beast
  DECORATE: Tormentor667
  GLDefs: Ghastly_dragon
  Sprites: Raven Software, edited by Rolls, Tormentor667
  Sounds: Croteam
  Realm667 free-use with credit
```

Also include credits in the per-monster `.zs` file header (coding_standards.md requires this).
