//===========================================================================
//
// ZDoom ZScript - HornedDevil
//
// Based on: "Hell Duke" from Realm667 Beastiary
// DECORATE: Amuscaria, flyingbrick
// GLDefs: SkyMarshall, SamVision
// Sounds: Raven Software, Monolith Productions, DBThanatos
// Sprites: Amuscaria, Raven Software
// Realm667 free-use with credit
//
//===========================================================================

// Internal armor buffer given to the HornedDevil on spawn.
// Never placed in a map — TNT1 spawn state keeps it invisible.
class HornedDevil_Armor : BasicArmorPickup
{
	Default
	{
		Armor.SavePercent 100;
		Armor.SaveAmount 500;
	}
	States
	{
	Spawn:
		TNT1 A 0;
		Stop;
	}
}

class HornedDevil : Actor
{
	Default
	{
		//$Category Monsters/Baatezu
		//$Title "Horned Devil"
		Monster;
		Species "Baatezu";
		+BOSS;
		+MISSILEMORE;
		+ALLOWPAIN;
		+NOTARGET;
		Health 3500;
		Radius 40;
		Height 110;
		Mass 1000;
		Speed 16;
		PainChance 20;
		MeleeRange 72;
		Tag "Horned Devil";
		SeeSound "HornedDevil/sight";
		DeathSound "HornedDevil/death";
		Obituary "%o was blasted away by the Horned Devil.";
	}

	float user_LaunchAngle;

	States
	{
	Spawn:
		HORN A 0;
		HORN A 1 A_SetInventory("HornedDevil_Armor", 1);
		HORN AB 10 A_Look;
		Goto Spawn+2;
	See:
		HORN A 3 A_PlaySound("Cyberdemon/Hoof", CHAN_BODY);
		HORN ABB 3 A_Chase;
		HORN C 3 A_PlaySound("Cyberdemon/Hoof", CHAN_BODY);
		HORN CDD 3 A_Chase;
		Loop;
	Missile:
		HORN E 0 A_Jump(80, "Missile2");
		HORN E 6 A_FaceTarget;
		HORN F 12 Bright A_CustomMissile("HornedDevil_Shot", 60, -24);
		HORN E 12 A_FaceTarget;
		HORN F 12 Bright A_CustomMissile("HornedDevil_Shot", 60, -24);
		HORN E 12 A_FaceTarget;
		HORN F 12 Bright A_CustomMissile("HornedDevil_Shot", 60, -24);
		Goto See;
	Missile2:
		HORN Q 0 A_JumpIfCloser(368, "Missile");
		HORN Q 0 { user_LaunchAngle = FRandom(-35, 10); }
		HORN Q 6 A_FaceTarget;
		HORN R 12 Bright A_SpawnProjectile("HornedDevil_Nade", 78, -27, 0, CMF_ABSOLUTEPITCH, user_LaunchAngle);
		HORN Q 12 A_FaceTarget;
		HORN R 12 Bright A_SpawnProjectile("HornedDevil_Nade", 78, -27, 0, CMF_ABSOLUTEPITCH, user_LaunchAngle);
		HORN Q 12 A_FaceTarget;
		HORN R 12 Bright A_SpawnProjectile("HornedDevil_Nade", 78, -27, 0, CMF_ABSOLUTEPITCH, user_LaunchAngle);
		Goto See;
	Melee:
		HORN ST 8 A_FaceTarget;
		HORN U 8 A_CustomMeleeAttack(17 * Random(1, 10), "baron/melee");
		HORN U 0 A_CustomMissile("HornedDevil_Hit", 32);
		Goto See;
	Pain:
		HORN G 10 A_Pain;
		Goto See;
	Death:
		HORN H 10 Bright;
		HORN I 10 Bright A_Scream;
		HORN JKL 10 Bright;
		HORN M 10 Bright A_NoBlocking;
		HORN NO 10 Bright;
		HORN P 30;
		HORN P -1 A_BossDeath;
		Stop;
	}
}

class HornedDevil_RedPuff : Actor
{
	Default
	{
		Radius 0;
		Height 1;
		RenderStyle "Add";
		Alpha 0.85;
		+NOGRAVITY;
		+NOBLOCKMAP;
		+FORCEXYBILLBOARD;
	}
	States
	{
	Spawn:
		TNT1 A 3 Bright;
		HRPF ABCDE 3 Bright;
		Stop;
	}
}

class HornedDevil_RedPuff2 : HornedDevil_RedPuff
{
	States
	{
	Spawn:
		TNT1 A 3 Bright;
		HRPX EFGHI 3 Bright;
		Stop;
	}
}

class HornedDevil_IrePuff : HornedDevil_RedPuff
{
	States
	{
	Spawn:
		TNT1 A 3 Bright;
		HRFX ABCDEF 3 Bright;
		Stop;
	}
}

class HornedDevil_Shot : Actor
{
	Default
	{
		Radius 11;
		Height 8;
		Damage 20;
		Speed 20;
		RenderStyle "Add";
		Alpha 1.0;
		SeeSound "HornedDevil/shotfire";
		DeathSound "HornedDevil/shotdeath";
		Projectile;
		+THRUGHOST;
		+FORCEXYBILLBOARD;
		+EXPLODEONWATER;
	}
	States
	{
	Spawn:
		HRSH ABCD 3 Bright A_SpawnItemEx("HornedDevil_IrePuff", 0, 0, 0, 0, 0, 0, 0, 8);
		Loop;
	Death:
		HRSH E 4 Bright A_Explode(128, 128, 1);
		HRSH FFFFFFFFFFFF 0 Bright A_SpawnItemEx("HornedDevil_RedPuff2", 0, 0, 0, 3, 0, FRandom(-5, 5), FRandom(0, 360), 0, 0);
		HRSH F 4 Bright A_SpawnItemEx("HornedDevil_RedPuff2", 0, 0, 0, 3, 0, FRandom(-5, 5), FRandom(0, 360), 0, 0);
		HRSH GHI 4 Bright;
		Stop;
	}
}

class HornedDevil_Nade : HornedDevil_Shot
{
	Default
	{
		Damage 25;
		BounceCount 3;
		Reactiontime 35;
		Gravity 0.5;
		SeeSound "HornedDevil/nadebounce";
		BounceSound "HornedDevil/nadecasual";
		BounceType "Hexen";
		Obituary "%o couldn't dodge %k's hell-bomb.";
		+DONTBOUNCEONSHOOTABLES;
		-NOGRAVITY;
	}
	States
	{
	Spawn:
		HRGR ABC 3 Bright A_SpawnItemEx("HornedDevil_RedPuff", 0, 0, 0, 0, 0, 0, 0, 8);
		HRGR A 0 Bright A_CountDown;
		Loop;
	Death:
		HRGR D 0 A_NoGravity;
		HRGR D 3 Bright;
		HRGR E 3 Bright A_Explode(144, 144, 1, 0, 32);
		HRGR FGHIJKLM 3 Bright;
		Stop;
	}
}

class HornedDevil_Hit : Actor
{
	Default
	{
		Projectile;
		Radius 0;
		Height 1;
		Speed 0;
		RenderStyle "None";
		+PUFFONACTORS;
		+PUFFGETSOWNER;
		+LOOKALLAROUND;
		+NOEXTREMEDEATH;
	}
	States
	{
	Spawn:
		TNT1 A 1;
		TNT1 A 3 Bright A_Explode(24, 128, 0, 0, 128);
		Stop;
	Crash:
		TNT1 A 3 A_PlaySound("HornedDevil/meleehit", CHAN_BODY);
		Stop;
	}
}
