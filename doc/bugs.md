
## Deprecated DONTHURTSPECIES

`intellect_devourer.zs` line 24: `Deprecated flag 'DONTHURTSPECIES' used, deprecated since 0.0.0`

Non-fatal warning. No fix needed until a replacement is identified.

## Deprecated LOWGRAVITY

`goristro.zs` lines 127, 154: `Deprecated flag 'LOWGRAVITY' used, deprecated since 4.13.0`

**Findings (from GZDoom actor.zs source):**
- `LOWGRAVITY` flag is deprecated since 4.13.0
- `GravityFactor` does **not** exist as a property in 4.14.2 (causes hard compile error)
- The correct replacement is the `Gravity` property (native double, default 1.0)
- `A_LowGravity()` sets `Gravity = 0.125` at runtime — equivalent to the old flag behavior
- In Default blocks: use `Gravity 0.125;` to replace `+LOWGRAVITY;`

**Fix:** Replace `+LOWGRAVITY;` with `Gravity 0.125;` in Default block. Applied to goristro.zs.

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
