# Common Migration Mistakes — zd_daf

Known pitfalls to check before and after the first GZDoom test. Numbered to match entries in `doc/context/migrating_assets_from_other_pk3.md`.

---

## Sprite / asset issues

**#1 Missing sprite lumps**
Symptom: `Unable to find sprite lump XXXX used by actor`
Fix: Copy all rotation variants of every sprite name used in States. Check for mirrored pair filenames (`B2B8`, `C3C7`, etc.) — one file counts as two rotations. Do NOT use `TNT1` as a substitute — it hides the actor from UDB's thing browser.

**#2 Wrong model path — leaving source prefix**
Symptom: Model doesn't appear in-game.
Fix: Style 1 MODELDEF uses `Path "models"` + relative name. Style 2 uses full `"models/name.md3"`. Do not leave the `Models/` prefix copied from elementalism source files.

**#3 //$Title comment swallowing closing braces**
Symptom: `Expected a token`
The `//` comment consumes everything to end-of-line including `} }` on the same line.
Fix: Put closing braces on the next line:
```zscript
// BROKEN:
class Foo : Bar { Default { //$Title "Foo" } }

// CORRECT:
class Foo : Bar { Default { //$Title "Foo"
} }
```

**#4 Skin variant subclass has no MODELDEF block**
Symptom: Variant renders with the parent class skin.
Fix: Every subclass needs its own `Model <ClassName> { ... }` block in the modeldef. MODELDEF does not inherit.

**#5 Missing FrameIndex entries**
Symptom: Model loads but is frozen on frame 0.
Fix: Copy ALL FrameIndex lines from the source modeldef for that model. Count frames carefully.

---

## ZScript conversion issues

**#6 DECORATE syntax not converted to ZScript**
Symptom: Various compile errors — `ACTOR Foo`, missing semicolons, bare identifiers.
Fix: Convert class structure (`ACTOR` -> `class : Actor`), add semicolons to all properties and flags, drop DoomEdNum from the class definition. See also **#17** and **#18** for the two most common specific pitfalls.

**#7 Class name starts with a digit**
Symptom: ZScript compile error.
Fix: Prefix with a word: `3X_chain_straight` -> `Chain3xStraight`.

**#17 DECORATE string-valued properties missing quotes**
Symptom: `Unknown identifier 'Add'` / `Unknown identifier 'Poison'` / `Unknown identifier 'MummyScorch'`
Cause: DECORATE accepts bare identifiers for type-valued properties; ZScript requires string literals.
Fix:
```zscript
RenderStyle "Add";
DamageType "Poison";
Decal "MummyScorch";
Decal "PlasmaScorchLower";
Species "Tanar'ri";
```
Affects: `RenderStyle`, `DamageType`, `Decal`, `Species`, and any Default property that takes a name/type value rather than a number or sound path.

**#18 A_Chase(0, 0) on multistate definition lines**
Symptom: `State jumps with index cannot be used on multistate definitions`
Cause: ZScript treats integer `0` as a state index offset, forbidden on multi-frame state lines.
Fix: Replace `A_Chase(0, 0)` with `A_Chase()`. Default args are already null/null.
Applies to any action function with integer state-index arguments on a line that defines multiple frames (e.g. `NALF AABBCCDDEEFF 2`).

---

## Registry / integration issues

**#8 Omitting DONTCULLBACKFACES for thin geometry**
Symptom: Chains, foliage, or flat surfaces disappear when viewed from certain angles.
Fix: Add `DONTCULLBACKFACES` to the MODELDEF block.

**#9 Forgetting to add DoomEdNum**
Symptom: Actor doesn't appear in UDB Things browser.
Fix: Add entry to the correct faction block in `zd_daf/MAPINFO`. Check for a pre-reserved commented-out entry first.

**#10 CamelCase filename for model or skin**
Symptom: Model fails to load (case-sensitive on Linux, silently wrong on Windows).
Fix: Rename to `snake_case`. Search all `.modeldef` files for the old name before renaming.

**#11 Multi-surface MD3 skin folder name doesn't match embedded shader strings**
Symptom: `unable to load skin models/skins/<name>/...`
Fix: Skin folder name must exactly match the path embedded in the MD3 shader strings. Use a hex editor to find embedded paths: search for `models/skins/` in the binary — shader strings are plain ASCII.

**#12 GLDEFS file not included in zd_daf/GLDEFS**
Symptom: Dynamic lights silently not applied (flat shading only, no error).
Fix: Add `#include "actors/<name>.gldefs"` in `zd_daf/GLDEFS`.

**#13 Sprite-only actor treated as model-based**
Symptom: Time wasted searching for a MODELDEF entry that doesn't exist.
Fix: Grep the source MODELDEF files for the class name first. If no match: sprite-only. Just copy sprites, write ZScript class, add DoomEdNum.

**#14 Death state spawns actors not present in zd_daf**
Symptom: ZScript compile error or broken runtime behaviour.
Fix: Strip the Death state to `TNT1 A 0; Stop;` for the initial migration. Restore later once dependent actors are also migrated.

**#15 Wrong Species string**
Symptom: Monsters damage their own faction or don't group correctly.
Fix: Use the faction's established Species value. Check existing actors in `zd_daf/actors/` for the correct string (`"Illithid"`, `"Tanar'ri"`, etc.). Do not use source-specific species that don't exist in zd_daf (e.g. `"WBoss"`).

**#16 DamageFactor for custom damage types**
Symptom: Silent no-op or compile warning.
Fix: Drop non-standard DamageFactor lines. Keep only standard GZDoom types (`"Ice"`, `"Fire"`, `"BFGSplash"`, etc.). Source-specific types like `"WBossDamage"` don't exist in zd_daf.

---

## Model pipeline issues

**#X GLDEFS material texture path must match embedded skin path exactly**
Symptom: PBR materials silently not applied (flat shading only, no error, no warning).
The path in `material texture "..."` must match what GZDoom resolves for that surface. For multi-surface MD3s this is the path embedded in the MD3 shader strings.
Fix: Read the embedded shader strings with a hex editor. If they use `PumpJack/` (CamelCase), the GLDEFS path must also use `PumpJack/`.

**#X Sprites in graphics/ instead of sprites/**
Symptom: Actor renders as a flat 2D square (sprite misprocessed as texture).
Fix: Regular sprite PNGs must be in `zd_daf/sprites/<folder>/`. Only brightmaps and decal images go in `zd_daf/graphics/`.

**#X SNDINFO or DECALDEF edited as if #include is supported**
Symptom: Entries in separate files are silently ignored.
Fix: `SNDINFO`, `DECALDEF`, and `MAPINFO` do not support `#include`. Write directly into the root lump file. Only `zscript.zs` and `GLDEFS` support `#include`.

---

## When encountering a new mistake

1. Note the exact error message and the cause.
2. Document it in `doc/context/migrating_assets_from_other_pk3.md` with a new numbered entry.
3. Add a condensed entry to this file.
4. If the skill's SKILL.md error table doesn't cover it, add a row there too.
