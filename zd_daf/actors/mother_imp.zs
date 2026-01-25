class BlueImp : DoomImp
{
	Default
	{
		Scale 0.5;
		Radius 16;
		Height 32;
		Health 20;
		Speed 10;
		Translation "64:79=192:207";
	}
	States
	{
	Missile:
		TROO EF 5 A_Facetarget;
		TROO G 4 A_CustomComboAttack("BlueImpBall", 24, 5 * random(2,5), "imp/melee");
		Goto See;
	}
}

class BlueImpBall : DoomImpBall
{
	Default
	{
		Radius 3;
		Height 4;
		Scale 0.5;
		Damage 2;
		Translation "208:223=192:196";
	}
}

class MotherImp : Actor
{
	Default
	{
		Health 120;
		Radius 32;
		Height 64;
		Scale 1.3;
		Mass 100;
		Speed 8;
		PainChance 125;
		Monster;
		+FLOORCLIP
		SeeSound "imp/sight";
		PainSound "imp/pain";
		DeathSound "imp/death";
		ActiveSound "imp/active";
		HitObituary "Scratched by a MotherImp";
		Obituary "Burned by a MotherImp";
	}
	
	States
	{
		Spawn:
			PRIM AB 10 A_Look;
			Loop;
		See:
			PRIM A 6;
			Goto Missile;
		See2:
			PRIM AABBCCDD 3 A_Chase;
			Loop;
		Melee:
		Missile:
			PRIM EF 8 A_Facetarget;
			PRIM G 6 A_CustomComboAttack("DoomImpBall", 38, 6 * random(2,5), "imp/melee");
			TNT1 A 0 A_Jump(127, "Missile");
			Goto See2;
		Pain:
			PRIM H 2 A_Pain;
			Goto See2;
		Death:
			PRIM I 8;
			PRIM J 8 A_Scream;
			PRIM K 6 A_Noblocking;
			PRIM L 0 A_SpawnItemEx(
				"BlueImp",
				-12, 0, 10,
				 4, 0, 8,
				0,
				SXF_NOCHECKPOSITION
			);

			PRIM L 0 A_SpawnItemEx(
				"BlueImp",
				 12, 0, 10,
				-4, 0, 8,
				0,
				SXF_NOCHECKPOSITION
			);
			PRIM M -1;
			Stop;
		XDeath:
			PRIM N 5;
			PRIM O 5 A_XScream;
			PRIM P 5;
			PRIM Q 5 A_NoBlocking;
			PRIM RST 5;
			PRIM U -1;
			Stop;
		Raise:
			PRIM ML 8;
			PRIM KJI 6;
			Goto See;
	}
}
