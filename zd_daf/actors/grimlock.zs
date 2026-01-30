
//===========================================================================
// Grimlock
//
// Based on "Wraith" from Realm667
// Original submission: Eriance
// Decorate: Eriance
// Sounds: Eriance, id Software
// Sprites: Eriance, id Software
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=60#credits-8
// Used under Realm667's free non-commercial use license. Do not sell.
//===========================================================================

class Grimlock : Actor
{
    Default
    {
        //$Category Monsters/Illithids
        //$Title "Grimlock"
        Monster;
        Species "Illithid";
        +FLOORCLIP;
        Health 150;
        Speed 12;
        Mass 200;
        Radius 22;
        Height 56;
        PainChance 64;
        MeleeDamage 4;
        Obituary "%o was slashed by a Grimlock.";
        HitObituary "%o was slashed by a Grimlock.";
        SeeSound "Grimlock/Sight";
        PainSound "Grimlock/Pain";
        DeathSound "Grimlock/Death";
        MeleeSound "Imp/Melee";
    }

    States
    {
    Spawn:
        3WRT A 1;
        3WRT A 0 A_JumpIf(Args[0] > 0, "Spawn2");
        3WRT A 0 A_JumpIfInventory("GrimlockTeleporting", 1, "StopTeleport");
        3WRT A 1 A_Look;
        Goto Spawn+1;
    Spawn2:
        3WRT A 0 A_JumpIfInventory("GrimlockTeleporting", 1, "StopTeleport");
        3WRT A 1 A_LookEx(8, 0, 0, 0, 0, "Teleport");
        Loop;
    StopTeleport:
        3WRT A 0 A_SpawnItem("TeleportFog");
        3WRT A 0 A_ChangeFlag("Invulnerable", false);
        3WRT A 0 A_SetShootable;
        3WRT A 0 A_ChangeFlag("NonShootable", false);
        3WRT A 0 A_ChangeFlag("Shootable", true);
        3WRT A 0 A_ChangeFlag("NoTeleport", false);
        3WRT A 0 A_ChangeFlag("NoRadiusDMG", false);
        3WRT A 0 A_TakeInventory("GrimlockTeleporting", 1);
        Goto Spawn;
    See:
        3WRT B 2 A_Chase;
        3WRT BBCCCDDDEEE 2 A_Chase;
        3WRT B 0 A_JumpIf(Args[1] > 0, 1);
        Goto See+1;
        3WRT B 0 A_Jump(16, "Missile");
        Goto See+1;
    Melee:
        3WRT A 0 A_JumpIfInventory("GrimlockTeleporting", 1, 5);
        3WRT A 6 A_FaceTarget;
        3WRT F 5 A_FaceTarget;
        3WRT G 0 A_PlayWeaponSound("Grimlock/Attack");
        3WRT G 8 A_MeleeAttack;
        Goto See;
        3WRT A 0 A_SpawnItem("TeleportFog");
        3WRT A 0 A_ChangeFlag("Invulnerable", false);
        3WRT A 0 A_SetShootable;
        3WRT A 0 A_ChangeFlag("NonShootable", false);
        3WRT A 0 A_ChangeFlag("Shootable", true);
        3WRT A 0 A_ChangeFlag("NoTeleport", false);
        3WRT A 0 A_ChangeFlag("NoRadiusDMG", false);
        3WRT A 0 A_ChangeFlag("DropOff", false);
        3WRT A 0 A_TakeInventory("GrimlockTeleporting", 1);
        3WRT F 5 A_FaceTarget;
        3WRT G 0 A_PlayWeaponSound("Grimlock/Attack");
        3WRT G 8 A_MeleeAttack;
        Goto See;
    Missile:
        3WRT A 0 A_JumpIfCloser(128, 2);
        3WRT A 0 A_JumpIfCloser(1024, 2);
        3WRT A 0;
        Goto See;
        3WRT A 0 A_Jump(128, "Teleport");
        Goto See;
    Teleport:
        3WRT AAA 6 A_FaceTarget;
        TNT1 A 0 A_GiveInventory("GrimlockTeleporting", 1);
        TNT1 A 0 A_SpawnItem("TeleportFog");
        TNT1 A 0 A_ChangeFlag("Invulnerable", true);
        TNT1 A 0 A_ChangeFlag("NonShootable", true);
        TNT1 A 0 A_ChangeFlag("NoTeleport", true);
        TNT1 A 0 A_ChangeFlag("NoRadiusDMG", true);
        TNT1 A 0 A_ChangeFlag("DropOff", true);
        TNT1 A 0 A_UnSetShootable;
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAA 0 A_ExtChase(1, 0, 0, 0);
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAA 0 A_ExtChase(1, 0, 0, 0);
        TNT1 A 1 A_ExtChase(1, 0, 0, 0);
        3WRT A 0 A_SpawnItem("TeleportFog");
        3WRT A 0 A_ChangeFlag("Invulnerable", false);
        3WRT A 0 A_SetShootable;
        3WRT A 0 A_ChangeFlag("NonShootable", false);
        3WRT A 0 A_ChangeFlag("Shootable", true);
        3WRT A 0 A_ChangeFlag("NoTeleport", false);
        3WRT A 0 A_ChangeFlag("NoRadiusDMG", false);
        3WRT A 0 A_ChangeFlag("DropOff", false);
        3WRT A 0 A_TakeInventory("GrimlockTeleporting", 1);
        3WRT AA 6 A_FaceTarget;
        Goto See;
    Pain:
        3WRT A 4;
        3WRT A 4 A_Pain;
        Goto See;
    Death:
        3WRT H 8;
        3WRT I 8 A_Scream;
        3WRT J 6;
        3WRT K 6 A_NoBlocking;
        3WRT L -1;
        Stop;
    Raise:
        TROO LKJIH 8;
        Goto See;
    }
}

class GrimlockTeleporting : Inventory
{
    Default
    {
        Inventory.MaxAmount 1;
    }
}
