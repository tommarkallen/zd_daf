---
name: migrating-gzdoom-assets
description: Migrates GZDoom assets (monsters, props, decorations) from external source folders (Realm667, Elementalism, custom) into the zd_daf project. Handles sprite/sound renaming, DECORATE-to-ZScript conversion, GLDEFS dynamic lights, and registry file integration. Use when the user asks to migrate, port, import, or add a monster, prop, or decoration to zd_daf.
---

# GZDoom Asset Migration — zd_daf

Migrates monsters, props, and decorations from external source folders into `zd_daf/`.

## Reference files

- **[sprite-naming.md](sprite-naming.md)** — GZDoom sprite format, rotation conventions, rename rules, file destinations
- **[decorate-to-zscript.md](decorate-to-zscript.md)** — Full DECORATE-to-ZScript conversion rules and known pitfalls
- **[registry-files.md](registry-files.md)** — MAPINFO, SNDINFO, GLDEFS, zscript.zs integration patterns
- **[common-mistakes.md](common-mistakes.md)** — All known migration mistakes to check before testing

---

## Before starting: required information

Ask for anything not already provided:

```
Pre-migration checklist:
- [ ] Source folder path (e.g. C:/dev/zdoom/things/shadow_beast)
- [ ] Original actor class name(s) (e.g. ShadowBeast, ShadowBeast_Ball1)
- [ ] New name in zd_daf (e.g. Nalfeshnee)
- [ ] Sprite prefix rename strategy (e.g. BDEM -> NALF, BDP1 -> NAP1)
- [ ] Faction / UDB category (e.g. Monsters/Tanar'ri, Models/Props)
- [ ] DoomEdNum — check MAPINFO for next available in the faction range
- [ ] Credits (original author, code, sprites, sounds, license)
```

Do not proceed until all items are confirmed. A wrong DoomEdNum or sprite prefix is expensive to fix retroactively.

---

## Step 1: Determine asset type

Read the source folder structure. Check for `.md3` or `.obj` model files and MODELDEF entries.

**Sprite-only** (most Realm667 monsters): no model file, no MODELDEF entry. Needs: sprites + ZScript + SNDINFO + GLDEFS + MAPINFO only.

**Model-based** (props like PumpJack, decorations): has `.md3`/`.obj`. Also needs: MODELDEF + skins + optional PBR maps.

To confirm sprite-only: grep the source MODELDEF files for the class name. If no match: sprite-only.

---

## Step 2: Build rename map

Construct a complete rename map before touching any files. Show it to the user for approval.

| Old sprite prefix | New sprite prefix | Used by |
|---|---|---|
| BDEM | NALF | Main actor |
| BDP1 | NAP1 | Projectile/effect sub-actors |

| Old sound file | New sound file |
|---|---|
| BDMSIT1.ogg | NAMSIT1.ogg |

| Old class name | New class name |
|---|---|
| ShadowBeast | Nalfeshnee |
| ShadowBeast_Ball1 | Nalfeshnee_Ball1 |

| Old GLDEFS light name | New GLDEFS light name |
|---|---|
| SBeastFire | NalfFire |

See [sprite-naming.md](sprite-naming.md) for naming conventions and destination folders.

---

## Step 3: Execute migration

Work through this checklist in order:

```
Migration checklist:
- [ ] 1. Copy + rename sprites -> zd_daf/sprites/<monster_name>/
         (brightmaps -> zd_daf/graphics/brightmaps/<monster_name>/)
- [ ] 2. Copy + rename sounds -> zd_daf/sounds/<monster_name>/
- [ ] 3. [MODEL ONLY] Copy model -> zd_daf/models/<name>.md3 (snake_case)
- [ ] 4. [MODEL ONLY] Copy skins -> zd_daf/models/skins/<name>.png
- [ ] 5. [MODEL ONLY] Copy normal/specular maps -> zd_daf/materials/
- [ ] 6. Create zd_daf/actors/<monster_name>.zs (convert DECORATE -> ZScript)
- [ ] 7. Create zd_daf/actors/<monster_name>.gldefs (if source has GLDEFS)
- [ ] 8. Add #include to zd_daf/zscript.zs in correct faction section
- [ ] 9. Add #include to zd_daf/GLDEFS (if .gldefs created)
- [ ] 10. Append sound block to zd_daf/SNDINFO
- [ ] 11. Add or uncomment DoomEdNum in zd_daf/MAPINFO
- [ ] 12. [MODEL ONLY] Add MODELDEF block to appropriate .modeldef file
- [ ] 13. Update zd_daf/CREDITS with attribution
```

See [decorate-to-zscript.md](decorate-to-zscript.md) for ZScript conversion rules.
See [registry-files.md](registry-files.md) for file formats and integration patterns.

---

## Step 4: Test and fix errors

Ask the user to load in GZDoom and provide the console log. Common patterns:

| Error message | Cause | Reference |
|---|---|---|
| `Unknown identifier 'Add'` | `RenderStyle Add` needs quotes | [decorate-to-zscript.md](decorate-to-zscript.md) #17 |
| `Unknown identifier 'Poison'` | `DamageType Poison` needs quotes | [decorate-to-zscript.md](decorate-to-zscript.md) #17 |
| `State jumps with index cannot be used on multistate` | `A_Chase(0, 0)` on a multistate line | [decorate-to-zscript.md](decorate-to-zscript.md) #18 |
| `Unable to find sprite lump XXXX` | Missing sprite PNG(s) | [common-mistakes.md](common-mistakes.md) #1 |
| `Expected a token` | `//$Title` swallowing closing braces | [common-mistakes.md](common-mistakes.md) #3 |
| `Unknown property 'title'` | Wrong MAPINFO syntax (use `levelname`) | [registry-files.md](registry-files.md) |
| `Deprecated flag 'DONTHURTSPECIES'` | Old flag name — replace with `+DONTHURTSPECIES;` in Default | [decorate-to-zscript.md](decorate-to-zscript.md) |

Also test in UDB: verify the actor appears under the correct `//$Category` in the Things browser.

---

## Step 5: Novel scenarios

If you encounter a migration situation not covered by the reference files:

1. **Stop and ask the user** how they want it handled before proceeding.
2. Describe the scenario clearly: what the source does, what the target expects, what options exist.
3. After resolving, **document the new pattern** in `doc/context/migrating_assets_from_other_pk3.md` as a new numbered entry.
4. **Update this skill** if the pattern will recur — add it to the relevant reference file and note it in [common-mistakes.md](common-mistakes.md).

Do not assume and proceed. An incorrect guess is harder to fix than a brief pause to ask.

---

## Step 6: Post-migration updates

After the user confirms the migration works in GZDoom and UDB:

```
Post-migration checklist:
- [ ] Update DoomEdNum registry in doc/context/migrating_assets_from_other_pk3.md
- [ ] Add any new mistakes or patterns to doc/context/migrating_assets_from_other_pk3.md
- [ ] Update this skill if new patterns were identified
- [ ] Update memory at C:/Users/tomma/.claude/projects/c--dev-zd-daf/memory/ if DoomEdNum ranges changed
```

The context document is the ground truth for future migrations. Keep it accurate.
