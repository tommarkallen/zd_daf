Ready for review
Select text to add comments on the plan
Plan: Migrate Shadow Beast as Nalfeshnee
Context
Migrating C:\dev\zdoom\things\shadow_beast into zd_daf as the Nalfeshnee (Type IV Tanar'ri demon).

DoomEdNum 19110 is pre-reserved in MAPINFO under // Demons - Tanar'ri — just uncomment it
Species and category match the existing Succubus: Species "Tanar'ri", //$Category Monsters/Tanar'ri
Source uses DECORATE syntax → must be converted to ZScript
Sprite-only monster (no model, no MODELDEF)
8 classes total: main actor + 7 helper actors (projectiles, effects, spirit)
Rename Map
Sprite Prefixes
Old	New	Used by
BDEM	NALF	Main actor (walk/attack/death/spread frames)
BDP2	NAP2	Nalfeshnee_Ball1, Nalfeshnee_BallFire
BDP1	NAP1	Nalfeshnee_Ball2, Nalfeshnee_Ball3, Nalfeshnee_Sparkle
BDSP	NASP	Nalfeshnee_Creature
Sound Files (BD → NA prefix replacement)
Old filename	New filename
BDMATK1.ogg	NAMATK1.ogg
BDMDTH1.ogg	NAMDTH1.ogg
BDMIDL1.ogg	NAMIDL1.ogg
BDMIDL2.ogg	NAMIDL2.ogg
BDMPAN1.ogg	NAMPAN1.ogg
BDMSIT1.ogg	NAMSIT1.ogg
BDPD1.ogg	NAPD1.ogg
BDPD2.ogg	NAPD2.ogg
BDPS1.ogg	NAPS1.ogg
BDPS2.ogg	NAPS2.ogg
BDPSPR.ogg	NAPSPR.ogg
BDSPR1.ogg	NASPR1.ogg
BDSPR2.ogg	NASPR2.ogg
Sound Namespace
"shadowbeast/..." → "Nalfeshnee/..."

Class Names
Old	New
ShadowBeast	Nalfeshnee
ShadowBeast_Spread	Nalfeshnee_Spread
ShadowBeast_Creature	Nalfeshnee_Creature
ShadowBeast_Sparkle	Nalfeshnee_Sparkle
ShadowBeast_BallFire	Nalfeshnee_BallFire
ShadowBeast_Ball1	Nalfeshnee_Ball1
ShadowBeast_Ball2	Nalfeshnee_Ball2
ShadowBeast_Ball3	Nalfeshnee_Ball3
GLDEFS Light Names
Old	New
SBeastFire	NalfFire
SBeastBall11–16	NalfBall11–16
SBeastBall21–25	NalfBall21–25
SBeastCreature1–7	NalfCreature1–7
Step-by-Step Execution
1. Copy + rename sprites → zd_daf/sprites/nalfeshnee/
Copy all PNGs from C:\dev\zdoom\things\shadow_beast\ applying prefix renames:

BDEM*.png → NALF*.png (e.g. BDEMA1.png → NALFA1.png, BDEMB2B8.png → NALFB2B8.png, etc.)
BDP2*.png → NAP2*.png
BDP1*.png → NAP1*.png
BDSP*.png → NASP*.png
Full sprite inventory to rename:

NALF: A–G (5 rotations each: 1, 2A8, 3A7, 4A6, 5), H+I (5 rotations: 1, 5, 6H4/6I4, 7H3/7I3, 8H2/8I2), J0–Z0 (single rotation)
NAP2: A–C (5 rotations), D0–H0 (single rotation)
NAP1: D0–I0 (single rotation)
NASP: A–B (5 rotations), E0–J0 (single rotation)
2. Copy + rename sounds → zd_daf/sounds/nalfeshnee/
Copy all OGGs applying the BD→NA rename from the table above.

3. Create zd_daf/actors/nalfeshnee.zs
Convert DECORATE to ZScript. Full file structure:

//===========================================================================
// ZDoom ZScript
//===========================================================================

//===========================================================================
// Nalfeshnee
//
// Based on: "Shadow Beast" from Realm667 Beastiary
// Source: https://www.realm667.com/repository/beastiary/heretic-hexen-style/713-shadow-beast
// DECORATE: Tormentor667
// GLDefs: Ghastly_dragon
// Sprites: Raven Software
// Sprite Edit: Rolls, Tormentor667
// Sounds: Croteam
// Realm667 free-use with credit
//===========================================================================

class Nalfeshnee : Actor { ... }
class Nalfeshnee_Spread : Actor { ... }
class Nalfeshnee_Creature : Actor { ... }
class Nalfeshnee_Sparkle : Actor { ... }
class Nalfeshnee_BallFire : Actor { ... }
class Nalfeshnee_Ball1 : Actor { ... }
class Nalfeshnee_Ball2 : Actor { ... }
class Nalfeshnee_Ball3 : Actor { ... }
DECORATE → ZScript conversion rules applied:

ACTOR Foo N { } → class Foo : Actor { Default { } States { } } (DoomEdNum dropped; goes in MAPINFO)
Semicolon after every property and flag line
MONSTER → Monster; | PROJECTILE → Projectile;
+FloorClip → +FLOORCLIP; | -SOLID → -SOLID; | -SHOOTABLE → -SHOOTABLE;
+FLOAT → +FLOAT; | +NOGRAVITY → +NOGRAVITY;
+RIPPER → +RIPPER; | +Randomize → +RANDOMIZE; | +SPAWNSOUNDSOURCE → +SPAWNSOUNDSOURCE;
Bloodcolor → BloodColor | Renderstyle Add → RenderStyle Add;
Alpha 1.0 → Alpha 1.0; | Scale 1.4 → Scale 1.4;
Decal MummyScorch → Decal MummyScorch; | Decal PlasmaScorchLower → Decal PlasmaScorchLower;
All sprite tokens in States: BDEM→NALF, BDP2→NAP2, BDP1→NAP1, BDSP→NASP
All "shadowbeast/..." sound strings → "Nalfeshnee/..."
All spawned class names "ShadowBeast_*" → "Nalfeshnee_*"
A_CustomMissile kept as-is (DECORATE compat function, preserves exact projectile behaviour)
Add to Nalfeshnee Default: //$Category Monsters/Tanar'ri, //$Title "Nalfeshnee", Species "Tanar'ri";
Note on Obituary: Update to "%o was killed by a nalfeshnee."

4. Create zd_daf/actors/nalfeshnee.gldefs
Convert GLDEFS.txt with banner header per coding_standards.md:

//===========================================================================
// GZDoom GLDefs - Nalfeshnee
//===========================================================================
Rename all light definitions (SBeast* → Nalf*) and all Object/Frame references:

Object ShadowBeast → Object Nalfeshnee, frame BDEMI → NALFI
Object ShadowBeast_Ball1 → Object Nalfeshnee_Ball1, frames BDP2A–H → NAP2A–H
Object ShadowBeast_BallFire → Object Nalfeshnee_BallFire, same frame renames
Object ShadowBeast_Ball2 → Object Nalfeshnee_Ball2, frames BDP1D–I → NAP1D–I
Object ShadowBeast_Ball3 → Object Nalfeshnee_Ball3, same frame renames
Object ShadowBeast_Creature → Object Nalfeshnee_Creature, frames BDSP* → NASP*
5. Modify zd_daf/zscript.zs
Add #include "actors/nalfeshnee.zs" in the Tanar'ri section (alongside Succubus).

6. Modify zd_daf/GLDEFS
Add #include "actors/nalfeshnee.gldefs" in the Monsters section.

7. Modify zd_daf/SNDINFO
Append a new Nalfeshnee section following the banner convention:

//===========================================================================
// ZDoom SndInfo - Nalfeshnee
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
8. Modify zd_daf/MAPINFO
Uncomment line // 19110 = Nalfeshnee in the // Demons - Tanar'ri block.

Files Modified Summary
File	Action
zd_daf/sprites/nalfeshnee/	Create dir, copy 75 renamed PNGs
zd_daf/sounds/nalfeshnee/	Create dir, copy 13 renamed OGGs
zd_daf/actors/nalfeshnee.zs	Create — 8 ZScript classes
zd_daf/actors/nalfeshnee.gldefs	Create — dynamic lights
zd_daf/zscript.zs	Add 1 #include line
zd_daf/GLDEFS	Add 1 #include line
zd_daf/SNDINFO	Append Nalfeshnee sound block
zd_daf/MAPINFO	Uncomment 19110 = Nalfeshnee
Verification
Load zd_daf/ in GZDoom — no ZScript compile errors
Open UDB — Nalfeshnee appears under Monsters/Tanar'ri in thing browser
Place in map and test:
Sight → chases player with NALF A–F walk animation
Above 250 HP: fires Nalfeshnee_Ball1 triple-shot (green orbs)
Below 250 HP: Run state → rapid Nalfeshnee_BallFire spray, or Nalfeshnee_Ball3 fan
~6% pain chance: Spread state → fades out, spawns 5 Creatures + sparkles + spread ring, wanders, fades back in
Creatures float, chase, melee attack, die with NASP E–J sequence
Death: NALF R–Z sequence, becomes non-blocking at Y frame
Verify green dynamic glow on projectiles and creatures
Confirm no missing sprite lump warnings in GZDoom console
