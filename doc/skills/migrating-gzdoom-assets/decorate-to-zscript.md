# DECORATE to ZScript Conversion — zd_daf

ZScript is syntactically stricter than DECORATE. Every known conversion pitfall is listed here.

---

## Class structure

DECORATE:
```
ACTOR Nalfeshnee 19110
{
    Monster
    +FLOORCLIP
    Health 500
    States { ... }
}
```

ZScript:
```zscript
class Nalfeshnee : Actor
{
    Default
    {
        //$Category Monsters/Tanar'ri
        //$Title "Nalfeshnee"
        Monster;
        Species "Tanar'ri";
        +FLOORCLIP;
        Health 500;
        ...
    }
    States
    {
    Spawn:
        ...
    }
}
```

Key structural changes:
- `ACTOR Foo N { }` becomes `class Foo : Actor { Default { } States { } }` — DoomEdNum N goes in MAPINFO
- Every property and flag line ends with `;`
- `MONSTER` keyword becomes `Monster;`
- `PROJECTILE` keyword becomes `Projectile;`

---

## Flag syntax

All flags need semicolons. The `+`/`-` prefix is preserved:

```zscript
+FLOORCLIP;   -SOLID;       +NOGRAVITY;    +FLOAT;
+RIPPER;      +RANDOMIZE;   +SPAWNSOUNDSOURCE;
+ROLLSPRITE;  +ROLLCENTER;  +FLOATBOB;     +FORCEXYBILLBOARD;
+COUNTKILL;   -SHOOTABLE;   +NOCLIP;       +DONTTHRUST;
+NORADIUSDMG; +SOLID;       +NODAMAGE;     +NOTARGET;
```

---

## Property syntax

Properties also need semicolons. Most names are identical to DECORATE:

```zscript
Health 500;
Radius 40;
Height 80;
Mass 500;
Speed 12;
PainChance 144;
BloodColor "70 AC 00";
Obituary "%o was killed by a nalfeshnee.";
SeeSound "Nalfeshnee/sight";
PainSound "Nalfeshnee/pain";
DeathSound "Nalfeshnee/death";
ActiveSound "Nalfeshnee/active";
Alpha 1.0;
Scale 1.4;
FloatBobStrength 1.0;
FloatBobPhase 0;
RenderRadius 2500;
DamageFactor "Ice", 0.5;
DamageFactor "BFGSplash", 0.15;
```

---

## Mistake #17: String-valued Default properties require quotes

DECORATE accepts bare identifiers for type-valued properties. ZScript requires string literals.

| DECORATE (invalid in ZScript) | ZScript (correct) |
|---|---|
| `RenderStyle Add` | `RenderStyle "Add";` |
| `DamageType Poison` | `DamageType "Poison";` |
| `Decal MummyScorch` | `Decal "MummyScorch";` |
| `Decal PlasmaScorchLower` | `Decal "PlasmaScorchLower";` |
| `Species Tanar'ri` | `Species "Tanar'ri";` |

**Error symptom:** `Unknown identifier 'Add'` / `Unknown identifier 'Poison'` / `Unknown identifier 'MummyScorch'` during compile.

**Rule:** Any Default property that takes a name or type value (not a number, not a color hex string, not a sound path) needs double quotes in ZScript.

---

## Mistake #18: A_Chase(0, 0) on multistate definition lines

DECORATE: Integer `0` means "no state" (suppress melee or missile jump). Valid syntax.
ZScript: Integer `0` is a state index offset. Forbidden on multistate definition lines.

A multistate definition line defines multiple frames at once using repeated or sequential letters:
```zscript
NALF AABBCCDDEEFF 2 A_Chase(0, 0);   // ERROR: 12-frame multistate
NALF ABCDEF 4 A_Chase(0, 0);          // ERROR: 6-frame multistate
NALF A 4 A_Chase(0, 0);               // OK: single-frame, no multistate
```

**Fix:** Replace `A_Chase(0, 0)` with `A_Chase()`. The default arguments are already `null`/`null`, which is the correct ZScript equivalent.

**Error symptom:** `State jumps with index cannot be used on multistate definitions`

**Applies to:** Any action function with integer state-index arguments called on a multi-frame state line.

---

## A_Jump integer offset on multistate lines

Same restriction applies to `A_Jump(probability, intIndex)` when `intIndex` is an integer. This form is a state offset jump, forbidden on multi-frame lines.

Safe usage — `A_Jump` with integer on single-frame `TNT1 A 0` lines:
```zscript
TNT1 A 0 A_Jump(90, 5);    // OK: single-frame TNT1 line
TNT1 A 0 A_Jump(60, "Run"); // OK: label-form jump
```

---

## Retaining DECORATE-compat action functions

These DECORATE-compatibility functions work unchanged in ZScript — do not rewrite them:
- `A_CustomMissile`
- `A_CustomMeleeAttack`
- `A_BishopMissileWeave`
- `A_SpawnItemEx`
- `A_PlaySound`
- `A_SetTranslucent`
- `A_ChangeFlag`
- `A_UnSetShootable` / `A_SetShootable`

---

## Skin variant subclass: closing brace pitfall

The `//$Title` comment swallows the rest of the line, including closing braces.

```zscript
// BROKEN — braces swallowed by the comment:
class RocksBrown1 : RocksDark1 { Default { //$Title "RocksBrown1" } }

// CORRECT — closing braces on the next line:
class RocksBrown1 : RocksDark1 { Default { //$Title "RocksBrown1"
} }
```

**Error symptom:** `Expected a token`

---

## Species tag

Controls friendly-fire grouping between actors of the same faction. Use the faction's established value — check existing actors in `zd_daf/actors/` to confirm:

- Tanar'ri faction: `Species "Tanar'ri";`
- Illithid faction: `Species "Illithid";`

---

## GZDoom metadata comments

These UDB editor hints go inside the `Default` block:

```zscript
//$Category Monsters/Tanar'ri
//$Title "Nalfeshnee"
```

Available categories in zd_daf:
- `Monsters/Illithids`
- `Monsters/Tanar'ri`
- `Models/Rocks`
- `Models/Props`
- `Models/Plants`
- `Models/Chains`

---

## DoomEdNum handling

Drop the DoomEdNum from the class definition entirely. It goes in `zd_daf/MAPINFO`:

```
// In MAPINFO DoomEdNums block:
19110 = Nalfeshnee
```

Writing `class Nalfeshnee : Actor 19110` is DECORATE syntax and will cause a ZScript compile error.

---

## ZScript class name rules

- Cannot start with a digit: `3X_chain_straight` -> `Chain3xStraight`
- Use CamelCase throughout
- MODELDEF block name must match the ZScript class name exactly (CamelCase)
- DoomEdNum entries in MAPINFO use the ZScript class name

---

## ZScript file header format

Every `.zs` actor file opens with credits per `doc/coding_standards.md`:

```zscript
//===========================================================================
//
// ZDoom ZScript - Nalfeshnee
//
// Based on: "Shadow Beast" from Realm667 Beastiary
// Source: https://www.realm667.com/...
// DECORATE: Tormentor667
// GLDefs: Ghastly_dragon
// Sprites: Raven Software
// Sprite Edit: Rolls, Tormentor667
// Sounds: Croteam
// Realm667 free-use with credit
//===========================================================================
```

Use a 75-character `//===...===` banner. The same credits go in `zd_daf/CREDITS`.

---

## Deprecated flags

Some old DECORATE flags have been renamed. Replace on sight:

| DECORATE flag | ZScript replacement |
|---|---|
| `DONTHURTSPECIES` (bare) | `+DONTHURTSPECIES;` |

GZDoom will log `Deprecated flag 'DONTHURTSPECIES' used` as a warning (not an error), but it is cleaner to update.

---

## ZScript actor patterns: quick reference

Monster (sprite-only, standard walking AI):
```zscript
class Nalfeshnee : Actor
{
    Default
    {
        //$Category Monsters/Tanar'ri
        //$Title "Nalfeshnee"
        Monster;
        Species "Tanar'ri";
        +FLOORCLIP;
        Health 500;
        Radius 40;
        Height 80;
    }
    States
    {
    Spawn:
        NALF AB 10 A_Look;
        Loop;
    See:
        NALF ABCDEF 6 A_Chase;
        Loop;
    Death:
        NALF R 8;
        NALF S 8 A_Scream;
        NALF TUVWX 6;
        NALF Y 6 A_NoBlocking;
        NALF Z -1;
        Stop;
    }
}
```

Projectile:
```zscript
class Nalfeshnee_Ball1 : Actor
{
    Default
    {
        Alpha 1.0;
        RenderStyle "Add";
        Speed 15;
        Radius 10;
        Height 6;
        Damage 5;
        DamageType "Poison";
        Projectile;
        +SPAWNSOUNDSOURCE;
        SeeSound "Nalfeshnee/pr1sight";
        DeathSound "Nalfeshnee/pr1death";
        Decal "MummyScorch";
    }
    States
    {
    Spawn:
        NAP2 ABC 4 Bright;
        Loop;
    Death:
        NAP2 DE 4 Bright;
        NAP2 FGH 3 Bright;
        Stop;
    }
}
```

Static prop (model-based):
```zscript
class RocksDark1 : Actor
{
    Default
    {
        //$Category Models/Rocks
        //$Title "RocksDark1"
        Radius 8;
        Height 64;
        +SOLID;
        +NOGRAVITY;
    }
    States
    {
    Spawn:
        CDRA A -1;
        Stop;
    }
}
```

Animated model:
```zscript
class Seaweed1 : Actor
{
    Default
    {
        //$Category Models/Plants
        //$Title "Seaweed1"
        Radius 8;
        Height 64;
        -SOLID;
        +NOGRAVITY;
    }
    States
    {
    Spawn:
        NO3D ABCDEFGHIJKLMNOPQRSTUVWXYZ 4;
        NB3D ABCDEFGHIJKLMNO 4;
        Loop;
    }
}
```
