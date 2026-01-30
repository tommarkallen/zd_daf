//===========================================================================
// Intellect Devourer
//
// Based on "Trite" from Realm667
// Submitted: Ghastly_dragon
// Decorate: Ghastly_dragon
// Sounds: ID Software
// Sprites: Monolith, ID Software
// Sprite Edit: Captain Toenail
// Idea Base: Trite from Doom 3
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=240#credits-6
// Used under Realm667's free non-commercial use license. Do not sell.
//===========================================================================

class IntellectDevourer : Actor
{
    Default
    {
        //$Category Monsters/Illithids
        //$Title "Intellect Devourer"
        Species "Illithid";
        Monster;
        +FLOORCLIP;
        +DONTHURTSPECIES;
        +NOTARGET;
        Health 100;
        Speed 6;
        Mass 100;
        Radius 20;
        Height 25;
        Scale 0.55;
        PainChance 192;
        BloodColor "DarkGreen";
        MeleeDamage 2;
        MeleeThreshold 64;
        MaxTargetRange 160;
        MinMissileChance 10;
        Damage 2;
        SeeSound "IntellectDevourer/Sight";
        PainSound "IntellectDevourer/Pain";
        DeathSound "IntellectDevourer/Death";
        ActiveSound "IntellectDevourer/Active";
        MeleeSound "IntellectDevourer/MeleeHit";
        HitObituary "%o was nipped by an Intellect Devourer";
        Obituary "%o was nipped by an Intellect Devourer";
    }

    States
    {
    Spawn:
        TRIT A 1 A_Look;
        Loop;
    See:
        TRIT A 2 A_Chase;
        TRIT A 2 A_Chase;
        TRIT A 0 A_PlaySoundEx("IntellectDevourer/Step", "SoundSlot7", 0);
        TRIT BB 2 A_Chase("Melee", "Missile", 2);
        TRIT B 0 A_PlaySoundEx("IntellectDevourer/Step", "SoundSlot7", 0);
        TRIT CC 2 A_Chase;
        TRIT C 0 A_PlaySoundEx("IntellectDevourer/Step", "SoundSlot7", 0);
        TRIT DD 2 A_Chase("Melee", "Missile", 2);
        TRIT D 0 A_PlaySoundEx("IntellectDevourer/Step", "SoundSlot7", 0);
        Loop;
    Melee:
        TRIT A 6 A_FaceTarget;
        TRIT A 0 A_Jump(192, 2);
        TRIT A 0 A_PlaySound("IntellectDevourer/Attack");
        TRIT E 6 A_MeleeAttack;
        Goto See;
    Missile:
        TRIT A 0 A_Jump(128, "See");
        TRIT AAA 3 A_FaceTarget;
        TRIT F 0 A_PlaySound("IntellectDevourer/Attack");
        TRIT F 0 A_SkullAttack;
        TRIT F 10 ThrustThingZ(0, 6, 0, 1);
        TRIT E 8 A_Stop;
        Goto See;
    Web:
        TRIT F 0;
        TRIT F 0 A_ChangeFlag("LowGravity", 1);
        TRIT F 0 A_ChangeFlag("NoDamage", 1);
        TRIT F 0 A_ChangeFlag("NoPain", 1);
        TRIT F 0 A_PlaySound("IntellectDevourer/WebStart");
        TRIT F 1 A_CheckFloor(1);
        Goto Web+5;
        TRIT A 0 A_ChangeFlag("NoDamage", 0);
        TRIT A 0 A_ChangeFlag("NoPain", 0);
        TRIT A 0 A_ChangeFlag("LowGravity", 0);
        TRIT A 12 A_PlaySound("IntellectDevourer/WebEnd");
        Goto Spawn;
    Pain:
        TRIT E 3;
        TRIT E 3 A_Pain;
        Goto See;
    Death:
        TRIT G 5 A_Scream;
        TRIT H 0 A_PlaySoundEx("IntellectDevourer/Splat", "SoundSlot7", 0);
        TRIT H 5 A_NoBlocking;
        TRIT IJK 5;
        Stop;
    }
}

//==========Mapper Notes

//The Web state is activated through the ACS fuction SetActorState
//and is used to lower the Trite to the floor as though it was on a web.
//(Note that this only really helps if it's spawned above the floor.)
