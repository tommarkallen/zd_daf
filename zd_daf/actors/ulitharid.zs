//===========================================================================
// Illithid - Ulitharid
//
// Based on "Deep One" from Realm667
// Original submission: Dr. Doctor
// Decorate: Dr. Doctor
// Sounds: Acclaim Entertainment
// Sprites: ID Software, Looking Glass Studios (fireballs)
// Sprite Edit: Dr. Doctor
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=60#credits-9
// Used under Realm667's free non-commercial use license. Do not sell.
//===========================================================================

class Ulitharid : Actor
{
	Default
	{
    	//$Category Monsters/Illithids
    	//$Title "Ulitharid"
		Monster;
		Species "Illithid";
		+FLOORCLIP;
		+BOSSDEATH;

		Scale 1.3;
		Radius 30;
		Height 88;

		Health 990;
		Speed 14;
		Mass 800;
		PainChance 80;
		MeleeDamage 20;
		MeleeRange 96;

		BloodColor "purple";
        Translation "112:127=192:207";

		Obituary "%o's mind was shattered by an Ulitharid.";
		HitObituary "%o's brain was extracted by an Ulitharid.";

		SeeSound "mindflayer/sight";
		PainSound "mindflayer/pain";
		DeathSound "mindflayer/death";
		ActiveSound "mindflayer/active";
		MeleeSound "mindflayer/melee";

	}

	States
	{
	Spawn:
		CUTH DD 6 A_Look;
		Loop;

	See:
		CUTH A 3;	
		CUTH A 0 A_JumpIfCloser(128, "Melee");
		Goto Missile;

	See2:
		CUTH AABBCCDD 3 A_Chase;
		Loop;

	Melee:
		CUTH E 0 A_FaceTarget;
		CUTH E 3 Fast A_PlaySound("mindflayer/meleegrowl");
		CUTH F 3 A_FaceTarget;
		CUTH G 2 Fast A_MeleeAttack;
		CUTH HI 2;
		Goto See2;

	Missile:
		CUTH J 0 A_JumpIfCloser(128, "Melee");
		CUTH J 8 A_FaceTarget;

		CUTH K 1 A_SpawnProjectile("UlitharidBigBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));
		CUTH J 0 A_FaceTarget;
		CUTH K 1 A_SpawnProjectile("UlitharidBall", 42, 15, angle = random(-30,30));

		CUTH K 8 Bright A_CPosRefire;
		Goto See2;

	Pain:
		CUTH L 0 A_TakeInventory("UlitharidInviso", 255);
		CUTH L 2 A_SetRenderStyle(1.0, STYLE_Normal);
		CUTH L 2 A_Pain;
		Goto See2;

	Death:
		CUTH M 0 A_SetRenderStyle(1.0, STYLE_Normal);
		CUTH M 0 A_Jump(128, "AltDeath");
		CUTH M 10;
		CUTH N 10 A_Scream;
		CUTH O 10;
		CUTH P 10 A_NoBlocking;
		CUTH P 0 A_SpawnItemEx(
				"IntellectDevourer",
				-12, random(-10,10), 10,
				 4, random(-10,10), 8,
				0,
				SXF_NOCHECKPOSITION
			);
		CUTH P 0 A_SpawnItemEx(
				"IntellectDevourer",
				12, random(-10,10), 10,
				 4, random(-10,10), 8,
				0,
				SXF_NOCHECKPOSITION
			);
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

class UlitharidBall : Actor
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

class UlitharidBigBall : Actor
{
	Default
	{
		Radius 26;
		Height 16;
		Scale 2.0;
		Speed 10;
		Damage 16;
		Translation "112:127=192:207";

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

class UlitharidInviso : Inventory
{
	Default
	{
		Inventory.Amount 0;
		Inventory.MaxAmount 1;
	}
}
