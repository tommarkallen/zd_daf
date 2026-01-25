//===========================================================================
//
// Blue Horror
//
//===========================================================================

class BlueHorror : Demon
{
    Default
    {
        Scale 0.6;
        Radius 16;
        Height 32;
        Health 20;
        Speed 10;
        BloodColor "purple";
        Translation "16:31=80:95", "32:47=192:207", "169:184=192:207";
    }
}

//===========================================================================
//
// Pink Horror
//
//===========================================================================

class PinkHorror : Actor
{
    Default
    {
        Health 150;
        Radius 30;
        Height 56;
        Scale 1.1;
        Mass 100;
        Speed 10;
        Translation "32:46=250:254";
        PainChance 180;
        Monster;
        +FLOORCLIP
        SeeSound "demon/sight";
        PainSound "demon/pain";
        DeathSound "demon/death";
        ActiveSound "demon/active";
        HitObituary "$OB_DEMONHIT";
        Obituary "$OB_DEMONHIT";
    }
    
    States
    {
        Spawn:
            SARG AB 10 A_Look;
            Loop;
        See:
            SARG AABBCCDD 2 Fast A_Chase;
            Loop;
        Melee:
            SARG EF 8 Fast A_FaceTarget;
            SARG G 8 Fast A_SargAttack;
            Goto See;
        Pain:
            SARG H 2 Fast;
            SARG H 2 Fast A_Pain;
            Goto See;
        Death:
            SARG I 8;
            SARG J 8 A_Scream;
            SARG K 4;
            SARG L 4 A_NoBlocking;
            SARG M 2 A_SpawnItemEx(
                "BlueHorror",
                -12, random(-10,10), 8,
                 4, random(-10,10), 8,
                0,
                SXF_NOCHECKPOSITION
            );

            SARG M 2 A_SpawnItemEx(
                "BlueHorror",
                 12, random(-10,10), 8,
                -4, random(-10,10), 8,
                0,
                SXF_NOCHECKPOSITION
            );
            SARG N -1;
            Stop;
        XDeath:
            SARG N 5;
            SARG O 5 A_XScream;
            SARG P 5;
            SARG Q 5 A_NoBlocking;
            SARG RST 5;
            SARG U -1;
            Stop;
        Raise:
            SARG N 5;
            SARG MLKJI 5;
            Goto See;
    }
}
