//===========================================================================
// Fiddler (Undead Hunter Conversion)
//
// Based on "Undead Hunter" from Realm667
// Submitted: Icytux
// Decorate: Icytux
// GLDefs: Icytux
// Sounds: Icytux, Raven Software
// Sprites: Raven Software
// Sprite Edit: Icytux
// Idea Base: Undead Priest
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=240#credits-9
//===========================================================================

class Fiddler : Actor
{
    Default
    {
        //$Category Characters/Players
        Species "PlayerCharacter";
        Monster;
        +FLOORCLIP;

        Scale 1.0;
        Radius 22;
        Height 56;
        Health 120;
        Speed 14;
        Mass 100;
        PainChance 70;

        Obituary "%o was the prey for a Fiddler.";
        SeeSound "fiddler/activate";
        PainSound "fiddler/pain";
        DeathSound "fiddler/death";
        ActiveSound "fiddler/active";
        Tag "Fiddler";
        DropItem "Shotgun", 256;
    }

    States
    {
    Spawn:
        DEHU AB 10 A_Look;
        Loop;
    See:
        DEHU AABBCCDD 2 A_Chase;
        Loop;
    Missile:
        DEHU E 8 A_FaceTarget;
        DEHU F 6 Bright {
            A_PlaySound("weapons/shotgf");
            A_CustomBulletAttack(3, 2, 1, 20, "BulletPuff");
        }
        DEHU E 8;
        Goto See;
    Pain:
        DEHU G 2;
        DEHU G 2 A_Pain;
        Goto See;
    Death:
        DEHU H 5;
        DEHU I 5 A_Scream;
        DEHU J 5 A_NoBlocking;
        DEHU KLM 5;
        DEHU N -1;
        Stop;
    XDeath:
        DEHU O 5 A_XScream;
        DEHU P 5 A_PlaySound("fiddler/xdeath");
        DEHU Q 5 A_NoBlocking;
        DEHU RSTUV 5;
        DEHU W -1;
        Stop;
    Raise:
        DEHU MLKJIH 3;
        Goto See;
    }
}
