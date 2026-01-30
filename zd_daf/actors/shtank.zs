//===========================================================================
// Shtank
//
// Based on "Shotgun Monk" from Realm667
// Submitted: TyrannotitanFan
// Code: TyrannotitanFan
// Sounds: Monolith Productions
// Sprites: Monolith Productions
// GLDefs: Gothic
// Idea Base: Cultists from Blood
// Source: https://www.realm667.com/repository/beastiary/other-style#credits-33
// Used under Realm667's free non-commercial use license. Do not sell.
//===========================================================================

class Shtank : Actor
{
    Default
    {
        //$Category Characters/Players
        //$Title "Shtank"
        Monster;
        Species "PlayerCharacter";
        +FLOORCLIP;
        Scale 0.6;
        Radius 20;
        Height 56;
        Health 60;
        Speed 10;
        Mass 100;
        PainChance 100;
        Obituary "%o got 'Maranax Pallexed' by Shtank.";
        DropItem "Shell";
        
        SeeSound "shtank/sight";
        PainSound "shtank/pain";
        DeathSound "shtank/death";
        ActiveSound "shtank/active";
        AttackSound "shtank/attack";
    }

    States
    {
    Spawn:
        MARA P 2 A_Look;
        Loop;
    See:
        MARA A 4 A_Chase;
        MARA B 4 A_Chase;
        MARA C 4 A_Chase;
        MARA D 4 A_Chase;
        MARA E 4 A_Chase;
        Loop;
    Missile:
        MARA G 0 A_Jump(50, "Dynamite");
        MARA G 6 Bright A_FaceTarget;
        MARA P 6 A_CustomBulletAttack(5, 4, 3, 4, "BulletPuff", 0);
        MARA P 6 A_CPosRefire;
        Goto See;
    Dynamite:
        MARA R 4 A_PlaySound("shtank/toss");
        MARA S 4;
        MARA T 4 A_SpawnProjectile("Dynamit");
        MARA U 4;
        Goto See;
    Pain:
        MARA F 3 A_Pain;
        Goto See;
    Death:
        MARA H 4 A_Scream;
        MARA I 4 A_NoBlocking;
        MARA J 4;
        MARA K 4;
        MARA L 4;
        MARA M 4;
        MARA N 4;
        MARA O -1;
        Stop;
    XDeath:
        MARD A 4 A_XScream;
        MARD B 4 A_NoBlocking;
        MARD C 4;
        MARD D 4;
        MARD E 4;
        MARD F 4;
        MARD G -1;
        Stop;
    }
}
class Dynamit : Actor
{
        Default
        {
                Radius 8;
                Height 8;
                Speed 25;
                Scale 0.8;
                Projectile;
                -NOGRAVITY;
                +RANDOMIZE;
                +DEHEXPLOSION;
                +GrenadeTrail;
                BounceType "Doom";
                Gravity 0.5;
                Damage 10;
                DeathSound "shtank/explodcl";
                BounceSound "shtank/land";
                Obituary "%o tried to use a burning dynamite as a Flare.";
        }

        States
        {
        Spawn:
                DYNA A 3 Bright NoDelay A_StartSound("shtank/tntfuse", 7, CHANF_LOOPING);
                DYNA B 3 Bright;
                DYNA C 3 Bright;
                DYNA D 3 Bright;
                DYNA E 3 Bright;
                DYNA F 3 Bright;
                DYNA G 3 Bright;
                DYNA H 3 Bright;
                Loop;
        Death:
                TNT1 A 0 A_SetScale(0.8);
                TNT1 A 0 A_StopSound(7);
                DYEX A 2 Bright A_Explode;
                DYEX B 2 Bright;
                DYEX C 2 Bright;
                DYEX D 2 Bright;
                DYEX E 2 Bright;
                DYEX F 2 Bright;
                DYEX G 2 Bright;
                DYEX H 2 Bright;
                DYEX I 2 Bright;
                DYEX J 2 Bright;
                DYEX K 2 Bright;
                DYEX L 2 Bright;
                DYEX M 2 Bright;
                Stop;
        }
}