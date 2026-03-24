
## Deprecated DONTHURTSPECIES

`intellect_devourer.zs` line 24: `Deprecated flag 'DONTHURTSPECIES' used, deprecated since 0.0.0`

Non-fatal warning. No fix needed until a replacement is identified.

## Deprecated MISSILEMORE / MISSILEEVENMORE

`nightstalker.zs`: `Deprecated flag 'MISSILEMORE' used, deprecated since 4.13.0`

**Findings (from Doomworld ID24 thread, page 19):**
- `MISSILEMORE` halves the monster's perceived distance to target for range checks
- `MISSILEEVENMORE` divides perceived distance by 8
- These are **not** direct probability flags — they affect P_CheckMissileRange, not firing chance
- `MinMissileChance` (GZDoom Default property) controls firing probability directly but is a different mechanism
- `MissileChance` does **not** exist in GZDoom 4.14.2 (causes hard compile error)
- No exact scalar replacement exists in GZDoom 4.14.2 for the distance-perception behavior

**Decision:** Keep `+MISSILEMORE` and `+MISSILEEVENMORE` as-is. Warnings are non-fatal. Revisit if GZDoom adds a proper replacement property.
