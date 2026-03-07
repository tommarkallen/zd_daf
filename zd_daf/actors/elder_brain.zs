//===========================================================================
// Illithid - Elder Brain
//
// Based on "WaterBossHead" from Elementalism by DrKubiac
// Sprites: DrKubiac
// Migrated and renamed for zd_daf. Death state simplified (dependent
// actors BloodBoop, BossNeckMlem, Waterdeathball not migrated).
//===========================================================================

class ElderBrain : Actor
{
    Default
    {
        //$Category "Monsters/Illithids"
        //$Title "Elder Brain"
        Radius 70;
        Height 130;
        +NOCLIP;
        +SHOOTABLE;
        +NOGRAVITY;
        +ROLLSPRITE;
        +ROLLCENTER;
        +FLOATBOB;
        +DONTTHRUST;
        +FORCEXYBILLBOARD;
        +COUNTKILL;
        +NORADIUSDMG;
        FloatBobPhase 0;
        FloatBobStrength 1.0;
        Species "Illithid";
        DamageFactor "Ice", 0.5;
        DamageFactor "BFGSplash", 0.15;
        Health 1000000;
    }
    States
    {
    Spawn:
        WBSS A 1 A_RadiusThrust(5000, 256, RTF_NOTMISSILE, 64);
        Loop;
    Death:
        TNT1 A 0;
        Stop;
    }
}
