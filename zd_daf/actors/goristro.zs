//===========================================================================
//
// ZScript - Goristro
//
// Based on "Super Demon" from Realm667 Beastiary
// Code: Xim, Molten Ice
// GLDefs: Xim
// Sounds: id Software, 3D Realms
// Sprites: id Software, edited by Molten Ice, Xim, David G, Craneo, JoeyTD
// Idea base: Cyberdemon, Baron Of Hell
//
//===========================================================================

class Goristro : Actor
{
    Default
    {
        //$Title "Goristro"
        //$Category "Monsters/Tanar'ri"

        Health 3500;
        Radius 40;
        Height 110;
        Mass 1000;
        Speed 15;
        PainChance 20;
        SeeSound "cyber/sight";
        PainSound "cyber/pain";
        DeathSound "Goristro/death";
        ActiveSound "cyber/active";
        Obituary "%o was crushed by a Goristro.";
        Species "Tanar'ri";

        Monster;
        +BOSS;
        +FLOORCLIP;
        +NORADIUSDMG;
        +DONTMORPH;
        +MISSILEMORE;
    }

    States
    {
        Spawn:
            GORI AB 10 A_Look;
            Loop;
        See:
            GORI A 3 A_Hoof;
            GORI ABBCC 3 A_Chase;
            GORI D 3 A_Hoof;
            GORI D 3;
            Loop;
        Missile:
            GORI Q 0 A_Jump(128, "Missile2");
            GORI QR 4 A_FaceTarget;
            GORI S 8 A_CustomMissile("GoristroBall", 54);
            GORI QR 4 A_FaceTarget;
            GORI S 8 A_CustomMissile("GoristroBall", 54);
            GORI QR 4 A_FaceTarget;
            GORI S 9 A_CustomMissile("GoristroBall", 54);
            Goto See;
        Missile2:
            GORI EF 6 A_FaceTarget;
            GORI GG 0 A_CustomMissile("GoristroBall", 54, 0, -10);
            GORI GG 0 A_CustomMissile("GoristroBall", 54, 0, -5);
            GORI GG 0 A_CustomMissile("GoristroBall", 54, 0, 5);
            GORI GG 0 A_CustomMissile("GoristroBall", 54, 0, 10);
            GORI G 10 A_CustomMissile("GoristroBall", 54, 0);
            Goto See;
        Pain:
            GORI H 10 A_Pain;
            Goto See;
        Death:
            GORI I 4 A_StartSound("Goristro/snarl", CHAN_5);
            GORI J 4 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GORI J 4 A_Scream;
            GORI KKKK 1 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GORI L 2 A_CustomMissile("GoristroArm", 54, -50, -50);
            GORI L 2 A_CustomMissile("GoristroLeg", 24, 50, 25);
            GORI MN 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GORI O 7 A_StartSound("Goristro/crash");
            GORI PPPPPPP 1 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GORI P 7 A_NoBlocking;
            GORI P -1;
    }
}

class GoristroBall : Actor
{
    Default
    {
        Radius 6;
        Height 16;
        Speed 16;
        Damage 15;
        Scale 1.5;
        RenderStyle "Add";
        SeeSound "baron/attack";
        DeathSound "baron/shotx";
        Decal "BigScorch";
        Projectile;
        +RANDOMIZE;
    }

    States
    {
        Spawn:
            GORB AB 1 Bright;
            Loop;
        Death:
            GORB CDE 6 Bright;
            Stop;
    }
}

class GoristroArm : Actor
{
    Default
    {
        Radius 10;
        Height 8;
        Speed 1;
        Damage 1;
        Scale 1;
        Projectile;
        -NOGRAVITY;
        Gravity 0.125;
    }

    States
    {
        Spawn:
            GOPH A 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOPH B 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOPH C 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            Goto Death;
        Death:
            GOPH D 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOPH E -1 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
    }
}

class GoristroLeg : Actor
{
    Default
    {
        Radius 10;
        Height 8;
        Speed 1;
        Damage 1;
        Scale 1;
        Projectile;
        -NOGRAVITY;
        Gravity 0.125;
    }

    States
    {
        Spawn:
            GOP2 A 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOP2 B 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOP2 C 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            Goto Death;
        Death:
            GOP2 D 5 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
            GOP2 E -1 A_CustomMissile("Blood", 0, 0, random(-80, -100), 2, random(45, 80));
    }
}
