//===========================================================================
//
// ZDoom ZScript - Nalfeshnee
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
        Mass 500;
        Speed 12;
        PainChance 144;
        BloodColor "70 AC 00";
        Obituary "%o was killed by a nalfeshnee.";
        SeeSound "Nalfeshnee/sight";
        PainSound "Nalfeshnee/pain";
        DeathSound "Nalfeshnee/death";
        ActiveSound "Nalfeshnee/active";
    }
    States
    {
    Spawn:
        NALF AB 10 A_Look;
        Loop;
    See:
        TNT1 A 0 A_JumpIfHealthLower(250, "Run");
        NALF ABCDEF 6 A_Chase;
        Loop;
    Run:
        TNT1 A 0 A_PlaySound("Nalfeshnee/sight");
        NALF AABBCCDDEEFF 2 A_Chase();
        NALF AABBCCDDEEFF 2 A_Chase();
        NALF AABBCCDDEEFF 2 A_Chase();
        Goto Missile;
    Missile:
        TNT1 A 0 A_JumpIfHealthLower(250, "Missile2");
        TNT1 A 0 A_Jump(90, 5);
        NALF H 6 A_FaceTarget;
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball1", 56, 0, -8);
        NALF I 6 A_CustomMissile("Nalfeshnee_Ball1", 56, 0, 8);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball1", 56, 0, 0);
        Goto See;
        NALF H 4 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, -16);
        NALF I 0 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, -8);
        NALF I 0 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, 0);
        NALF I 0 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, 8);
        NALF I 0 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, 16);
        NALF I 0 A_FaceTarget;
        NALF I 4 A_CustomMissile("Nalfeshnee_Ball2", 56, 0, 32);
        Goto See;
    Missile2:
        TNT1 A 0 A_Jump(90, 15);
        NALF H 6 A_FaceTarget;
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        NALF I 2 A_CustomMissile("Nalfeshnee_BallFire", 56, 0, random(-8, 8));
        Goto See;
        NALF H 16 A_FaceTarget;
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -64);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 64);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -56);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 56);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -48);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 48);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -40);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 40);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -32);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 32);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -24);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 24);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -16);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 16);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, -8);
        NALF I 0 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 8);
        NALF I 6 A_CustomMissile("Nalfeshnee_Ball3", 56, 0, 0);
        Goto See;
    Pain:
        TNT1 A 0 A_Jump(16, "Spread");
        NALF G 4 A_Pain;
        Goto See;
    Death:
        NALF R 8;
        NALF S 8 A_Scream;
        NALF TUVWX 6;
        NALF Y 6 A_NoBlocking;
        NALF Z -1;
        Stop;
    Spread:
        TNT1 A 0 A_SpawnItemEx("Nalfeshnee_Spread", 0, 0, 0, 0, 0, 0, 0, 128);
        TNT1 AAAAAAAAAAAAA 0 A_SpawnItemEx("Nalfeshnee_Sparkle", random(0, 16), random(0, 16), random(16, 48), 0, 0, 0, random(0, 359), 128);
        TNT1 AAAAA 0 A_SpawnItemEx("Nalfeshnee_Creature", 0, 0, random(16, 48), random(0, 8), random(0, 8), random(0, 8), random(0, 359), 0);
        TNT1 A 0 A_SetTranslucent(0.0);
        Goto Wander;
    Wander:
        TNT1 A 0 A_UnSetShootable;
        TNT1 A 0 A_ChangeFlag("NoPain", 1);
        TNT1 A 0 A_Jump(60, 5);
        TNT1 A 0 A_Jump(60, 15);
        TNT1 A 0 A_Jump(60, 25);
        TNT1 A 0 A_Jump(60, 35);
        TNT1 A 0 A_Jump(60, 45);
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 2 A_Wander;
        NALF A 3 A_Wander;
        NALF A 0 A_SetTranslucent(0.2);
        NALF B 3 A_Wander;
        NALF A 0 A_SetTranslucent(0.4);
        NALF C 3 A_Wander;
        NALF A 0 A_SetTranslucent(0.6);
        NALF D 3 A_Wander;
        NALF A 0 A_SetTranslucent(0.75);
        NALF E 3 A_Wander;
        NALF A 0 A_SetTranslucent(0.8);
        NALF F 3 A_Wander;
        NALF A 0 A_SetTranslucent(1.0);
        TNT1 A 0 A_SetShootable;
        TNT1 A 0 A_ChangeFlag("NoPain", 0);
        Goto See;
    }
}

//===========================================================================
// Nalfeshnee_Spread
//===========================================================================

class Nalfeshnee_Spread : Actor
{
    Default
    {
        Radius 1;
        Height 1;
        Damage 0;
        Speed 0;
        Projectile;
    }
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_PlaySound("Nalfeshnee/spread");
        NALF JKLMNOP 8;
        NALF Q 70;
        NALF QQQQQQQQQQ 1 A_FadeOut(0.1);
        Stop;
    }
}

//===========================================================================
// Nalfeshnee_Creature
//===========================================================================

class Nalfeshnee_Creature : Actor
{
    Default
    {
        Alpha 1.0;
        RenderStyle "Add";
        Speed 16;
        Monster;
        -SOLID;
        -SHOOTABLE;
        +FLOAT;
        +NOGRAVITY;
    }
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_PlaySound("Nalfeshnee/spiritsit");
        Goto See;
    See:
        TNT1 A 0 A_Jump(60, 5);
        TNT1 A 0 A_Jump(60, 15);
        TNT1 A 0 A_Jump(60, 25);
        TNT1 A 0 A_Jump(60, 35);
        TNT1 A 0 A_Jump(60, 45);
        NASP ABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABABAB 2 A_Chase;
        Goto Death;
    Melee:
        NASP AB 2 A_CustomMeleeAttack(5);
        Goto See;
    Death:
        TNT1 A 0 A_PlaySound("Nalfeshnee/spiritdth");
        NASP EFGHIJ 5;
        Stop;
    }
}

//===========================================================================
// Nalfeshnee_Sparkle
//===========================================================================

class Nalfeshnee_Sparkle : Actor
{
    Default
    {
        Alpha 1.0;
        RenderStyle "Add";
        Radius 1;
        Height 1;
        Damage 0;
        Speed 0;
        Projectile;
        Scale 1.0;
    }
    States
    {
    Spawn:
        TNT1 A 0;
        TNT1 A 0 A_Jump(128, 4);
        TNT1 A 0 A_Jump(128, 2);
        NAP1 GHI 5;
        Stop;
    }
}

//===========================================================================
// Nalfeshnee_BallFire
//===========================================================================

class Nalfeshnee_BallFire : Actor
{
    Default
    {
        Alpha 1.0;
        RenderStyle "Add";
        Speed 15;
        Radius 10;
        Height 6;
        Damage 1;
        DamageType "Poison";
        Projectile;
        +SPAWNSOUNDSOURCE;
        +RIPPER;
        SeeSound "Nalfeshnee/pr1death";
        Decal "MummyScorch";
    }
    States
    {
    Spawn:
        NAP2 DEFGH 5 Bright;
        Goto Death;
    Death:
        TNT1 A 0;
        Stop;
    }
}

//===========================================================================
// Nalfeshnee_Ball1
//===========================================================================

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

//===========================================================================
// Nalfeshnee_Ball2
//===========================================================================

class Nalfeshnee_Ball2 : Actor
{
    Default
    {
        Alpha 1.0;
        RenderStyle "Add";
        Radius 8;
        Height 6;
        Damage 2;
        Speed 16;
        Projectile;
        +RANDOMIZE;
        SeeSound "Nalfeshnee/pr2sight";
        DeathSound "Nalfeshnee/pr2death";
        Decal "PlasmaScorchLower";
    }
    States
    {
    Spawn:
        NAP1 D 1 A_BishopMissileWeave;
        NAP1 E 1 A_BishopMissileWeave;
        Loop;
    Death:
        NAP1 FGHI 3;
        Stop;
    }
}

//===========================================================================
// Nalfeshnee_Ball3
//===========================================================================

class Nalfeshnee_Ball3 : Actor
{
    Default
    {
        Alpha 1.0;
        Scale 1.4;
        RenderStyle "Add";
        Radius 8;
        Height 6;
        Damage 10;
        Speed 20;
        Projectile;
        +RANDOMIZE;
        SeeSound "Nalfeshnee/pr2sight";
        DeathSound "Nalfeshnee/pr2death";
        Decal "PlasmaScorchLower";
    }
    States
    {
    Spawn:
        NAP1 DEDEDEDED 2 A_BishopMissileWeave;
        NAP1 ED 2 A_BishopMissileWeave;
        TNT1 A 0 A_FadeOut(0.20);
        Goto Spawn+9;
    Death:
        NAP1 FGHI 3;
        Stop;
    }
}
