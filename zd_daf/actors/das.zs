//===========================================================================
// Das (Marauder Conversion)
//
// Based on "Marauder" from Realm667
// Submitted: OkDoomer174
// Code: Spectre, OkDoomer174
// Sounds: id Software (Doom Eternal)
// Sprites: id Software, David G/It'sNatureToDie, Xim, Scalliano, Mattbratt11, Mryayayify, Spectre
// Sprite Edit: Spectre, Craneo
// Idea Base: Marauder from Doom Eternal
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=120#credits-25
//===========================================================================

class Das : Actor
{
	Default
	{
    	//$Category Characters/Players
    	//$Title "Das"
		Species "PlayerCharacter";
		Monster;
		+BOSS;
		+FLOORCLIP;
		+NOTARGET;
		+MISSILEMORE;
		+MISSILEEVENMORE;

		Scale 1.0;
		Radius 20;
		Height 56;
		Health 800;
		Speed 25;
		Mass 800;
		PainChance 256;
		MeleeRange 100;
		GibHealth 100;

		Obituary "%o was slaughtered by Das.";
		SeeSound "das/speech";
		PainSound "das/pain";
		DeathSound "das/death";
		ActiveSound "das/speech";
		Tag "Das";
	}

	States
	{
	Spawn:
		MRAU A 0 A_ChangeFlag("NORADIUSDMG", 1);
		MRAU A 0 A_ChangeFlag("NOBLOOD", 1);
		MRAU A 0 A_ChangeFlag("NODAMAGE", 1);
		MRAU AB 10 A_Look;
		Loop;
	See:
		MRAU A 0 A_TakeInventory("ShieldDown");
		MRAU A 0 Bright A_ChangeFlag("NORADIUSDMG", 1);
		MRAU A 0 Bright A_ChangeFlag("NOBLOOD", 1);
		MRAU A 0 A_ChangeFlag("NODAMAGE", 1);
		MRAU A 2 A_Chase;
		MRAU A 0 A_FaceTarget;
		MRAU A 2 A_Chase;
		MRAU A 0 A_FaceTarget;
		MRAU B 2 A_Chase;
		MRAU B 0 A_FaceTarget;
		MRAU B 2 A_Chase;
		MRAU B 0 A_FaceTarget;
		MRAU C 2 A_Chase;
		MRAU C 0 A_FaceTarget;
		MRAU C 2 A_Chase;
		MRAU C 0 A_FaceTarget;
		MRAU D 2 A_Chase;
		MRAU D 0 A_FaceTarget;
		MRAU D 2 A_Chase;
		MRAU D 0 A_FaceTarget;
		MRAU A 0 Bright A_TakeInventory("DontMeleeAgain");
		Loop;
	Missile:
        MRAU U 0 A_JumpIfInventory("DogCharge", 3, "MissileDog");
		MRAU U 0 A_JumpIfCloser(200, "MissileSSG");
		MRAU U 0 A_JumpIfCloser(300, "MissileCharge");
		// Axe attack
		MRAU U 7 A_FaceTarget;
		MRAU V 7 A_CustomMissile("DasAxe");
		Goto See;
	MissileDog:
		MRAU U 0 A_TakeInventory("DogCharge");
		MRAU U 7 A_FaceTarget;
        MRAU V 0 A_PlaySound("dog/sight");
        MRAU V 7 A_SpawnItemEx("DasDog", 
            xofs: 64,
            zofs: 0,        
            flags: SXF_NOCHECKPOSITION | SXF_SETMASTER
        );
		Goto See;
	MissileSSG:
		MRAU E 0 Bright A_GiveInventory("ShieldDown", 1);
		MRAU E 0 Bright A_ChangeFlag("NORADIUSDMG", 0);
		MRAU E 0 Bright A_ChangeFlag("NOBLOOD", 0);
		MRAU E 0 Bright A_ChangeFlag("NODAMAGE", 0);
		MRAU E 7 A_FaceTarget;
		MRAU F 0 Bright A_PlaySound("weapons/sshotf");
		MRAU F 5 Bright A_CustomBulletAttack(8, 7, 5, 3);
		MRAU E 5 A_FaceTarget;
		Goto See;
	MissileCharge:
		MRAU W 0 Bright A_JumpIfInventory("DontMeleeAgain", 1, "See");
		MRAU W 0 Bright A_GiveInventory("DontMeleeAgain");
		MRAU W 0 Bright A_GiveInventory("ShieldDown");
		MRAU W 0 Bright A_ChangeFlag("NORADIUSDMG", 0);
		MRAU W 0 Bright A_ChangeFlag("NOBLOOD", 0);
		MRAU W 0 Bright A_ChangeFlag("NODAMAGE", 0);
		MRAU W 0 Bright A_PlaySound("das/charge");
		MRAU W 0 Bright A_Recoil(-10);
		MRAU W 4 Bright A_FaceTarget;
		MRAU W 0 Bright A_Recoil(-10);
		MRAU W 4 Bright A_FaceTarget;
		MRAU W 0 Bright A_Recoil(-10);
		MRAU W 4 Bright A_FaceTarget;
		MRAU W 0 Bright A_Recoil(-10);
		MRAU V 6 A_CustomMeleeAttack(random(1,8)*15, "das/melee");
        MRAU V 0 A_GiveInventory("DogCharge");
		Goto See;
	Pain:
		MRAU X 0 A_ChangeFlag("NOPAIN", 1);
		MRAU X 0 A_JumpIfInventory("ShieldDown", 1, "PainReal");
		MRAU X 0 A_ChangeFlag("NOPAIN", 0);
		MRAU X 35;
		MRAU X 0 A_GiveInventory("DogCharge");
		MRAU G 0 A_ChangeFlag("NOPAIN", 0);
		Goto See;
	PainReal:
		MRAU G 20 A_Pain;
		MRAU G 0 A_TakeInventory("ShieldDown");
		MRAU G 0 Bright A_ChangeFlag("NORADIUSDMG", 1);
		MRAU G 0 Bright A_ChangeFlag("NOBLOOD", 1);
		MRAU G 0 A_ChangeFlag("NODAMAGE", 1);
		MRAU G 0 A_ChangeFlag("NOPAIN", 0);
		Goto See;
	Pain.Telefrag:
	Pain.Massacre:
		MRAU G 0 A_Die("Extreme");
	Death:
		MRAU H 5;
		MRAU I 5 A_Scream;
		MRAU J 5 A_NoBlocking;
		MRAU KLM 5;
		MRAU N -1;
		Stop;
	XDeath:
		MRAU O 5;
		MRAU P 5 A_XScream;
		MRAU Q 5 A_NoBlocking;
		MRAU RS 5;
		MRAU T -1 A_BossDeath;
		Stop;
	}
}

class DasAxe : Actor
{
	Default
	{
		Scale 1.4;
		Radius 14;
		Height 12;
		Speed 25;
		Damage 8;
		Projectile;
		-NOBLOCKMAP;
		-ACTIVATEIMPACT;
		-ACTIVATEPCROSS;
		+WINDTHRUST;
		SeeSound "axe/see";
		DeathSound "axe/death";
	}
	States
	{
	Spawn:
		SPAX A 3 Bright A_PlaySound("axe/see");
		SPAX BC 3 Bright;
		Loop;
	Death:
		SPAX DEF 6 Bright;
		Stop;
	}
}

class DasDog : Actor
{
	Default
	{
    	//$Category Characters/Players
    	//$Title "Das's Dog"
		Monster;
        Species "PlayerCharacter";
        Health 200;
		Speed 20;
		PainChance 0;
		Radius 15;
		Height 35;
		Mass 100;
		RenderStyle "STYLE_Add";

		+NOBLOOD;
		+JUMPDOWN;
		+DONTFALL;
		+NOICEDEATH;
		Obituary "%o was slaughtered by Das's Dog.";
		SeeSound "dog/sight";
		DeathSound "dasdog/death";
	}
	States
	{
	Spawn:
		MDOG AB 10 Bright A_Look;
		Loop;
	See:
		MDOG AABBCCDD 2 Bright A_Chase;
		Loop;
	Melee:
		MDOG EF 4 Bright A_FaceTarget;
		MDOG G 4 Bright A_SargAttack;
		Goto See;
	Death:
		MDOG I 0 A_Scream;
		MDOG I 8 A_NoBlocking;
		MDOG J 8;
		MDOG K 8;
		MDOG L -1;
		Stop;
	}
}

class DontMeleeAgain : Inventory
{
	Default { +INVENTORY.UNDROPPABLE; Inventory.MaxAmount 1; }
}

class ShieldDown : Inventory
{
	Default { +INVENTORY.UNDROPPABLE; Inventory.MaxAmount 1; }
}

class DogCharge : Inventory
{
	Default { +INVENTORY.UNDROPPABLE; Inventory.MaxAmount 3; }
}
