//===========================================================================
// Illithid - Mind Witness
//
// Based on a Realm667 asset
// Source: https://www.realm667.com/repository/beastiary/doom-style#credits-12
// Used under Realm667's free non-commercial use license. Do not sell.
// See CREDITS file for details.
//===========================================================================

class MindWitness : Actor
{
  Default
  {
    //$Category Monsters/Illithids
    //$Title "Mind Witness"
    Monster;
	Species "Illithid";
    +NOGRAVITY;
    +FLOAT;
    +FLOATBOB;

    Scale 0.9;
    Radius 24;
    Height 64;

    Health 160;
    Speed 12;
    Mass 400;
    PainChance 150;
    MeleeDamage 6;
    MissileHeight 36;
    MissileType "MindWitnessBall";

    SeeSound "mindwitness/sight";
    ActiveSound "mindwitness/active";
    PainSound "mindwitness/pain";
    DeathSound "mindwitness/death";
    MeleeSound "mindwitness/melee";
    AttackSound "mindwitness/attack";

    Obituary "%o suffered psychic trauma from a Mind Witness's eye rays.";
    HitObituary "%o had %p mind erased by a Mind Witness.";

  }

  States
  {
  Spawn:
    ACNB A 1 A_Look;
    Loop;
  See:
    ACNB A 2 A_Chase;
    Loop;
  Melee:
    ACNB AB 5;
    ACNB C 6 A_MeleeAttack;
    Goto See;
  Missile:
    ACNB B 20 Bright A_FaceTarget;
    ACNB C 4 Bright A_MissileAttack;
    ACNB B 4 Bright;
    TNT1 A 0 A_Jump(32, "See");
    ACNB D 0 A_SpidRefire;
    Goto Missile+1;
  Pain:
    ACNF I 2;
    ACNF I 2 A_Pain;
    Goto See;
  Death:
    ACNB D 0 A_ChangeFlag("FLOATBOB", false);
    ACNB D 0 A_Scream;
    ACNB D 6 A_Fall;
    ACNB D 1;
    Wait;
  Crash:
    ACNB EFG 6;
    ACNB H -1;
    Stop;
  Raise:
    ACNB HGFEDA 8;
    ACNB A 0 A_ChangeFlag("FLOATBOB", true);
    Goto See;
  }

}

class MindWitnessBall : Actor
{
  Default
  {
    Radius 13;
    Height 8;
    Speed 22;
    Damage 3;
    Projectile;
    +RANDOMIZE
    RenderStyle "STYLE_Add";
    Alpha 0.8;
    SeeSound "mindwitness/attack";
    DeathSound "deepone/firehit";
  }
  States
  {
  Spawn:
    OLDP AB 3 Bright;
    Loop;
  Death:
    OLDP C 0 A_Scream;
    OLDP CDEF 4 Bright;
    Stop;
  }
}
