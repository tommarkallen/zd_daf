class MindFlayer : Actor
{
	Default
	{
		Health 1000;
		Radius 30;
		Height 88;
		Scale 1.3;
		Mass 1000;
		Speed 12;
		BloodColor "purple";
        // Translation "112:127=192:207";
		PainChance 80;
		MeleeDamage 20;
		MeleeRange 64;

		SeeSound "mindflayer/sight";
		PainSound "mindflayer/pain";
		DeathSound "mindflayer/death";
		ActiveSound "mindflayer/active";
		MeleeSound "mindflayer/melee";

		Obituary "%o was driven mad by a Mind Flayer.";
		HitObituary "%o got whiplashed by a Mind Flayer.";

		Monster;
		+FLOORCLIP;
		+BOSSDEATH;
		+MISSILEMORE;
	}

	States
	{
	Spawn:
		CUTH DD 6 A_Look;
		Loop;

	See:
		CUTH ABCD 6 A_Chase;
		Loop;

	Melee:
		CUTH E 0 A_FaceTarget;
		CUTH E 6 A_PlaySound("mindflayer/meleegrowl");
		CUTH F 6 A_FaceTarget;
		CUTH G 2 A_MeleeAttack;
		CUTH HI 2;
		Goto See;

	Missile:
		CUTH J 0 A_JumpIfCloser(32, "Melee");
		CUTH J 8 A_FaceTarget;

		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("MindFlayerBall", 42, 15, random(-20,20));

		CUTH K 8 Bright A_CPosRefire;
		Goto See;

	Pain:
		CUTH L 0 A_TakeInventory("squidinviso", 255);
		CUTH L 2 A_SetRenderStyle(1.0, STYLE_Normal);
		CUTH L 2 A_Pain;
		Goto See;

	Death:
		CUTH M 0 A_SetRenderStyle(1.0, STYLE_Normal);
		CUTH M 0 A_Jump(128, "AltDeath");
		CUTH M 10;
		CUTH N 10 A_Scream;
		CUTH O 10;
		CUTH P 10 A_NoBlocking;
		CUTH Q -1;
		Stop;

	AltDeath:
		CUTH R 5;
		CUTH S 5 A_Scream;
		CUTH T 5;
		CUTH U 5 A_NoBlocking;
		CUTH V 5;
		CUTH W -1;
		Stop;

	Raise:
		CUTH PONM 8;
		Goto See;
	}
}

class MindFlayerBall : Actor
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 18;
		Damage 4;

		Projectile;
		+RANDOMIZE;
		+ROCKETTRAIL;
		+SEEKERMISSILE;

		RenderStyle "STYLE_Add";
		Alpha 0.75;

		SeeSound "mindflayer/fire";
		DeathSound "mindflayer/firehit";
	}

	States
	{
	Spawn:
		OLDP AB 3 Bright
		{
			A_Tracer();
			A_BishopMissileWeave();
		}
		Loop;

	Death:
		OLDP C 0 A_Scream;
		OLDP CDEF 4 Bright;
		Stop;
	}
}

class squidinviso : Inventory
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
	}
}
