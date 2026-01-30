//===========================================================================
// Succubus (converted from PyroSuccubus DECORATE)
// $Category Monsters/Tanar'ri
//
// Submitted: YuraoftheHairFan
// Decorate: YuraoftheHairFan, DavidRaven, AshuraTheChimera
// GLDefs: DavidRaven, Yuraofthehairfan
// Sounds: id Software, Blizzard, Midway
// Sprites: YuraoftheHairFan, Espi, Ebola, Vader
// Source: https://www.realm667.com/repository/beastiary/heretic-hexen-style#credits-52
// Used under Realm667's free non-commercial use license. Do not sell.
//===========================================================================

class Succubus : Actor
{
  Default
  {
    //$Category Monsters/Tanar'ri
    //$Title "Succubus"
    Monster;
    Species "Tanar'ri";
    +NOTARGET;
    +FLOORCLIP;
    RenderStyle "STYLE_Translucent";
    Scale 0.95;
    Radius 16;
    Height 50;
    Mass 700;
    Health 710;
    Speed 12;
    PainChance 95;
    Obituary "A succubus was too hot for %o.";
    SeeSound "succubus/sight";
    PainSound "succubus/pain";
    DeathSound "succubus/death";
    ActiveSound "succubus/active";
  }

  States
  {
    Spawn:
      SUC1 AB 10 Bright A_Look;
      Loop;
        See:
            TNT1 A 0 A_ChangeFlag("FLOAT", false);
            TNT1 A 0 A_ChangeFlag("NOGRAVITY", false);
            TNT1 A 0 A_ChangeFlag("DROPOFF", false);
            SUC1 AA 3 Bright A_Chase;
            SUC1 A 0 Bright A_SpawnItemEx("WalkFire1",0,0,0,1,0,0,0,128);
            SUC1 BB 3 Bright A_Chase;
            SUC1 B 0 Bright A_SpawnItemEx("WalkFire1",0,0,0,1,0,0,0,128);
            SUC1 CC 3 Bright A_Chase;
            SUC1 C 0 Bright A_SpawnItemEx("WalkFire1",0,0,0,1,0,0,0,128);
            SUC1 DD 3 Bright A_Chase;
            SUC1 D 0 Bright A_SpawnItemEx("WalkFire1",0,0,0,1,0,0,0,128);
            SUC1 A 0 {
                if (pos.z + height + 100 >= CeilingZ) {
                    SetStateLabel("See");
                } else if (random(0, 255) < 32) {
                    SetStateLabel("Grav");
                } else {
                    SetStateLabel("See");
                }
            }
            Loop;
        Grav:
            TNT1 A 0 {
                if (pos.z + height + 100 >= CeilingZ) {
                    SetStateLabel("See");
                }
                A_ChangeFlag("NOGRAVITY", true);
                A_ChangeFlag("DROPOFF", true);
                A_ChangeFlag("FLOAT", true);
            }
            Goto Fly;
    Fly:
      SUFY AA 4 Bright ThrustThingZ(0, 15, 0, 0);
      SUFY AABBCCDD 2 Bright;
      Goto Hover;
    Land:
      SUFY AA 4 Bright ThrustThingZ(0, -20, 0, 0);
      SUFY A 1 Bright A_CheckFloor("See");
      SUFY AABBCCDD 2 Bright;
      SUFY A 1 Bright A_CheckFloor("See");
      Goto Hover;
    Hover:
        SUFY AABBCCDD 2 Bright A_Chase;
        SUFY A 0 Bright A_Chase(null, "MissileF");
        SUFY A 0 Bright A_Jump(64, "Fly");
        SUFY A 0 Bright A_Jump(32, "Land");
        Loop;
    Missile:
      TNT1 A 0 A_Jump(85, "TripleShot");
      Goto QuadrupleShot;
        QuadrupleShot:
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 8 Bright A_ComboAttack;
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUC1 G 0 Bright A_ComboAttack;
            SUC1 G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUC1 E 8 Bright;
            Goto See;
        TripleShot:
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUC1 G 0 Bright A_ComboAttack;
            SUC1 G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUC1 E 8 Bright;
            Goto See;
        MissileF:
            TNT1 A 0 A_Jump(85, "TripleShotF");
            Goto QuadrupleShotF;
        QuadrupleShotF:
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 8 Bright A_ComboAttack;
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUFY G 0 Bright A_ComboAttack;
            SUFY G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUFY E 8 Bright;
            Goto Hover;
        TripleShotF:
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUFY G 0 Bright A_ComboAttack;
            SUFY G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUFY E 8 Bright;
            Goto Hover;
    Pain:
      SUC1 L 2 Bright;
      SUC1 L 2 Bright A_Pain;
      Goto See;
    Death:
      SUC1 M 7 Bright;
      SUC1 N 7 Bright A_Scream;
      SUC1 O 7 Bright;
      SUC1 P 7 A_NoBlocking;
      SUC1 QRST 7;
      SUC1 U -1;
      Stop;
    Raise:
      SUC1 UTSRQ 8 Bright;
      SUC1 P 0 A_PlaySoundEx("succubus/resurrected", "Voice");
      SUC1 PONM 8 Bright;
      Goto See;
  }
}

class SuccubusWalk : Actor
{
    Default
    {
        //$Category Monsters/Tanar'ri
        //$Title "Succubus - Walking"
        Obituary "A succubus was too hot for %o.";
        Health 200;
        Radius 16;
        Height 50;
        Mass 200;
        Speed 12;
        Scale 0.95;
        MissileType "FireBall1";
        DamageFactor "Ice", 2;
        DamageFactor "Fire", 0;
        PainChance 95;
        SeeSound "succubus/sight";
        PainSound "succubus/pain";
        DeathSound "succubus/death";
        ActiveSound "succubus/active";
        RenderStyle "STYLE_Translucent";
        Alpha 1.0;
        Monster;
        +NOTARGET;
        +FLOORCLIP;
        Species "Tanar'ri";
    }

    States
    {
        Spawn:
            SUC1 AB 10 Bright A_Look;
            Loop;
        See:
            SUC1 AA 3 Bright A_Chase;
            SUC1 A 0 Bright A_SpawnItemEx("WalkFire1", 0, 0, 0, 1, 0, 0, 0, 128);
            SUC1 BB 3 Bright A_Chase;
            SUC1 B 0 Bright A_SpawnItemEx("WalkFire1", 0, 0, 0, 1, 0, 0, 0, 128);
            SUC1 CC 3 Bright A_Chase;
            SUC1 C 0 Bright A_SpawnItemEx("WalkFire1", 0, 0, 0, 1, 0, 0, 0, 128);
            SUC1 DD 3 Bright A_Chase;
            SUC1 D 0 Bright A_SpawnItemEx("WalkFire1", 0, 0, 0, 1, 0, 0, 0, 128);
            Loop;
        Missile:
            TNT1 A 0 A_Jump(85, "TripleShot");
            Goto QuadrupleShot;
        QuadrupleShot:
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 8 Bright A_ComboAttack;
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUC1 G 0 Bright A_ComboAttack;
            SUC1 G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUC1 E 8 Bright;
            Goto See;
        TripleShot:
            SUC1 E 8 Bright A_FaceTarget;
            SUC1 F 8 Bright A_FaceTarget;
            SUC1 G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUC1 G 0 Bright A_ComboAttack;
            SUC1 G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUC1 E 8 Bright;
            Goto See;
        Pain:
            SUC1 L 2 Bright;
            SUC1 L 2 Bright A_Pain;
            Goto See;
        Death:
            SUC1 M 7 Bright;
            SUC1 N 7 Bright A_Scream;
            SUC1 O 7 Bright;
            SUC1 P 7 A_NoBlocking;
            SUC1 QRST 7;
            SUC1 U -1;
            Stop;
        Raise:
            SUC1 UTSRQ 8 Bright;
            SUC1 P 0 A_PlaySoundEx("succubus/resurrected", "Voice");
            SUC1 PONM 8 Bright;
            Goto See;
    }
}

class SuccubusFly : Actor
{
    Default
    {
        //$Category Monsters/Tanar'ri
        //$Title "Succubus - Flying"
        Obituary "A succubus was too hot for %o.";
        Health 200;
        Radius 16;
        Height 50;
        Mass 200;
        Speed 12;
        Scale 0.95;
        MissileType "FireBall1";
        DamageFactor "Ice", 2;
        DamageFactor "Fire", 0;
        PainChance 95;
        SeeSound "succubus/sight";
        PainSound "succubus/pain";
        DeathSound "succubus/death";
        ActiveSound "succubus/active";
        RenderStyle "STYLE_Translucent";
        Alpha 1.0;
        Monster;
        +NOTARGET;
        +FLOORCLIP;
        +NOGRAVITY;
        +FLOAT;
        Species "Tanar'ri";
    }

    States
    {
        Spawn:
            SUFY ABCD 10 Bright A_Look;
            Loop;
        See:
            SUFY AABBCCDDAABBCCDD 2 Bright A_Chase;
            Loop;
        Missile:
            TNT1 A 0 A_Jump(85, "TripleShot");
            Goto QuadrupleShot;
        QuadrupleShot:
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 8 Bright A_ComboAttack;
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUFY G 0 Bright A_ComboAttack;
            SUFY G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUFY E 8 Bright;
            Goto See;
        TripleShot:
            SUFY E 8 Bright A_FaceTarget;
            SUFY F 8 Bright A_FaceTarget;
            SUFY G 0 Bright A_CustomMissile("FireBall1", 27, 0, 8);
            SUFY G 0 Bright A_ComboAttack;
            SUFY G 8 Bright A_CustomMissile("FireBall1", 27, 0, -8);
            SUFY E 8 Bright;
            Goto See;
        Pain:
            SUC1 L 2 Bright;
            SUC1 L 2 Bright A_Pain;
            Goto See;
        Death:
            SUC1 M 7 Bright;
            SUC1 N 7 Bright A_Scream;
            SUC1 O 7 Bright;
            SUC1 P 7 A_NoBlocking;
            SUC1 QRST 7;
            SUC1 U -1;
            Stop;
        Raise:
            SUC1 UTSRQ 8 Bright;
            SUC1 P 0 A_PlaySoundEx("succubus/resurrected", "Voice");
            SUC1 PONM 8 Bright;
            Goto See;
    }
}

class FireBall1 : Actor
{
    Default
    {
        Radius 8;
        Height 8;
        Speed 15;
        Damage 16;
        DamageType "Fire";
        Projectile;
        +RANDOMIZE;
        RenderStyle "STYLE_Add";
        Alpha 0.7;
        SeeSound "weapons/succbrn";
        DeathSound "weapons/succxxpl";
        Decal "BaronScorch";
    }
    States
    {
        Spawn:
            BRB2 AB 1 Bright A_SpawnItemEx("SuccubusTail", 0, 0, 0, 0, 0, 0, 0, 128);
            Loop;
        Death:
            BRBA K 0 A_CustomMissile("Fire2", 4, 2, 0);
            BRBA KLMNOPQRSTUVWX 3 Bright A_Die;
            Stop;
    }
}

//********************

class Fire2 : Actor
{
    Default
    {
        +NOCLIP;
        +MISSILE;
        +DROPOFF;
        DamageType "Fire";
        +RANDOMIZE;
        Scale 1.5;
        Speed 1;
        Damage 3;
        RenderStyle "STYLE_Add";
        Alpha 0.67;
        ExplosionDamage 9;
        ExplosionRadius 64;
    }
    States
    {
        Spawn:
            TNT1 A 8;
            FRTF A 3 Bright;
            FRTF A 0 A_Explode;
            FRTF B 3 Bright;
            FRTF B 0 A_Explode;
            FRTF C 3 Bright;
            FRTF C 0 A_Explode;
            FRTF C 0;
            FRTF C 0 A_Jump(191, 4);
            FRTF C 0 A_CustomMissile("Fire2", 0, 24, 0);
            FRTF C 0 A_CustomMissile("Fire2", 0, 0, 0);
            FRTF C 0 A_CustomMissile("Fire2", 0, -24, 0);
            FRTF DEFGHIJKLMNO 3 Bright;
            Stop;
    }
}

//********************

class Fire1 : Actor
{
    Default
    {
        +NOCLIP;
        +MISSILE;
        +DROPOFF;
        Speed 2;
        Damage 3;
    }
    States
    {
        Spawn:
            TNT1 A 10 A_CustomMissile("Fire2", 0, 0, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, -16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 0, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, -16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 0, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, -16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 0, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, -16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 0, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, 16, 0);
            TNT1 A 10 A_CustomMissile("Fire2", 0, -16, 0);
            Stop;
    }
}

class WalkFire1 : Actor
{
    Default
    {
        +NOCLIP;
        +MISSILE;
        +DROPOFF;
        +RANDOMIZE;
        Scale 1.5;
        Speed 1;
        RenderStyle "STYLE_Add";
        Alpha 0.67;
    }
    States
    {
        Spawn:
            NULL A 8;
            FRTF A 3 Bright;
            FRTF A 0;
            FRTF B 3 Bright;
            FRTF B 0;
            FRTF C 3 Bright;
            FRTF C 0;
            FRTF C 0;
            FRTF DEFGHIJKLMNO 3 Bright;
            Stop;
    }
}

class SuccubusTail : Actor
{
    Default
    {
        Projectile;
        Scale 1.1;
        RenderStyle "STYLE_Add";
        +NOCLIP;
        Alpha 0.4;
    }
    States
    {
        Spawn:
            PYTL ABCDEFGHI 1 Bright;
            Stop;
    }
}