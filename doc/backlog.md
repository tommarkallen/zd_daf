
## New Features

### Goristro A_BossDeath — boss teleporter special

The Goristro death sequence currently ends with a permanent corpse (`GORI P -1`).
The original Superdemon called `A_BossDeath` on the final death frame, which fires
GZDoom's boss-death special (tag 666 exits, WolfSS-style telefrag triggers, etc.).

**To restore:** add `A_BossDeath()` on the `GORI P -1` line in `actors/goristro.zs`
and wire a matching boss-death trigger in the map (linedef special 666 or equivalent
MAPINFO episode boss setup). No actor change is needed beyond restoring the call.

**Dependency:** requires a map-side boss teleporter or exit trigger set up for the
Goristro's DoomEdNum (19116) before this is meaningful.

## Refactoring
