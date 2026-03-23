# Sprite Naming — GZDoom / zd_daf

## GZDoom sprite lump format

```
<SPRT><FRAME><ROT>.png
```

- `SPRT` — 4-character sprite name (uppercase), e.g. `NALF`, `NAP1`, `NASP`
- `FRAME` — single letter A-Z
- `ROT` — rotation index:
  - `0` — no rotation (single image shown from all angles)
  - `1-8` — 8-direction sprite (standard Doom)
  - `1-9, A-G` — 16-direction sprite (A=10, B=11 ... G=16)

Mirrored pair shorthand: `NALFB2B8.png` means frame B, rotations 2 and 8 are mirrored — one file covers both directions.

Example filenames:
```
NALFA1.png      sprite=NALF, frame=A, rotation=1 (of 8)
NALFB2B8.png    sprite=NALF, frame=B, rotations 2+8 mirrored
NALFJ0.png      sprite=NALF, frame=J, no rotation
NAP1D0.png      sprite=NAP1, frame=D, no rotation
```

The ZScript States block references only the 4-char sprite name and frame letter:
```zscript
NALF A 10;      // displays NALFA1..NALFA8 depending on view angle
NALF J 8;       // displays NALFJ0 (no rotation)
```

---

## Choosing a new 4-char sprite prefix

- Use the first 4 characters of the new class name where possible: `Nalfeshnee` -> `NALF`
- For sub-actors/projectiles, use 2 chars for actor + 2 chars for type:
  - `Nalfeshnee` projectile sets: `NAP1`, `NAP2`
  - `Nalfeshnee` spirit creature: `NASP`
- Check existing prefixes in `zd_daf/sprites/` to avoid collisions
- Must be exactly 4 characters, uppercase

---

## Finding all sprites for a source prefix

List all PNGs in the source folder sorted by name, group by prefix:

```bash
ls C:/dev/zdoom/things/shadow_beast/*.png | sort
```

Build a rename table before copying:

| Source file | Destination file | Notes |
|---|---|---|
| BDEMA1.png | NALFA1.png | main walk frame A, rotation 1 |
| BDEMB2B8.png | NALFB2B8.png | mirrored pair |
| BDP1D0.png | NAP1D0.png | ball2 projectile, no rotation |
| BDSPAB2B8.png | NASPA2A8.png | creature spirit, frame A mirrored |

Apply the rename: swap the first N characters (prefix length) that match the old prefix for the new prefix. The rest of the filename is unchanged.

---

## File destinations in zd_daf

| File type | Destination |
|---|---|
| Sprite PNGs (all actors, all sub-actors) | `zd_daf/sprites/<monster_name>/` |
| Brightmap PNGs | `zd_daf/graphics/brightmaps/<monster_name>/` |
| Decal images | `zd_daf/graphics/decaldefs/<monster_name>/` |
| Sound OGGs | `zd_daf/sounds/<monster_name>/` |

**Critical:** Brightmaps and decal images must go in `graphics/`, not `sprites/`. GZDoom processes files in `sprites/` as sprite lumps and will mishandle other images placed there.

All sprite PNGs for a monster — including projectile and effect sub-actors — go in the same `sprites/<monster_name>/` subdirectory. Do not create separate subdirectories per sub-actor.

---

## Sound file renaming

Apply the same prefix rename logic to sound OGG filenames. If the source uses `BD*` prefix, map to `NA*`:

| Source OGG | Destination OGG | Sound namespace entry |
|---|---|---|
| BDMSIT1.ogg | NAMSIT1.ogg | `Nalfeshnee/sight` |
| BDMDTH1.ogg | NAMDTH1.ogg | `Nalfeshnee/death` |
| BDMPAN1.ogg | NAMPAN1.ogg | `Nalfeshnee/pain` |
| BDMIDL1.ogg | NAMIDL1.ogg | `Nalfeshnee/idle1` |
| BDPD1.ogg | NAPD1.ogg | `Nalfeshnee/pr1death` |
| BDPS1.ogg | NAPS1.ogg | `Nalfeshnee/pr1sight` |
| BDPSPR.ogg | NAPSPR.ogg | `Nalfeshnee/spread` |
| BDSPR1.ogg | NASPR1.ogg | `Nalfeshnee/spiritdth` |
| BDSPR2.ogg | NASPR2.ogg | `Nalfeshnee/spiritsit` |

All sound files go in `zd_daf/sounds/<monster_name>/` (flat, no subdirectories).

---

## Placeholder sprites for model-based actors

Model-based actors need sprite lumps for UDB's thing browser, but the sprites are invisible placeholders (the model drives the visual). If only one sprite exists for the base frame, copy it under every sprite name used in States:

```
PJKAA0.png  -> original
PJKBA0.png  -> copy of PJKAA0.png
PJKCA0.png  -> copy of PJKAA0.png
PJKDA0.png  -> copy of PJKAA0.png
```

Do NOT use `TNT1` as a substitute for missing sprites. TNT1 is a null sprite token that hides the actor from UDB's thing browser.

---

## Sprite folder structure summary

```
zd_daf/sprites/nalfeshnee/
    NALFA1.png  NALFB2B8.png  ...  (main actor)
    NAP1D0.png  NAP1E0.png    ...  (Ball2/Ball3/Sparkle)
    NAP2A1.png  NAP2B0.png    ...  (Ball1/BallFire)
    NASPA1.png  NASPB2B8.png  ...  (Creature spirit)

zd_daf/sounds/nalfeshnee/
    NAMSIT1.ogg  NAMDTH1.ogg  ...

zd_daf/graphics/brightmaps/nalfeshnee/  (if source includes brightmaps)
    NALFA1.png  ...
```
