//===========================================================================
// Sahuagin
//
// Based on a Realm667 asset
// Source: https://www.realm667.com/repository/beastiary/doom-style?start=180#credits-35
// Used under Realm667's free non-commercial use license. Do not sell.
// See CREDITS file for details.
//===========================================================================

class Sahuagin : Actor
{
	   Default
	   {
		   //$Category Monsters/Illithids
		   //$Title "Sahuagin"
		   Monster;
		   Species "Illithid";
		   +FLOORCLIP;
		   RenderStyle "STYLE_Normal";

		   Radius 20;
		   Height 60;
           
		   Health 100;
		   Speed 12;

		   Obituary "%o was slain by a sahuagin.";
		   HitObituary "%o was shredded by a sahuagin.";

		   SeeSound "imp/sight";
		   PainSound "imp/pain";
		   DeathSound "imp/death";
		   ActiveSound "imp/active";
	   }

	States
	{
	Spawn:
		SIMP AB 8 A_Look;
		Loop;
	See:
		SIMP AABBCCDD 4 A_Chase;
		Loop;
	Melee:
	Missile:
		SIMP EF 8 A_FaceTarget;
		SIMP G 8 A_CustomComboAttack("SahuaginFireball",40,4,"imp/melee");
		Goto See;
	Pain:
		SIMP H 4 A_Pain;
		SIMP H 4;
		Goto See;
	Death:
		SIMP I 6;
		SIMP J 6 A_Scream;
		SIMP KL 6;
		SIMP M 6 A_Fall;
		SIMP M -1;
		Stop;
	XDeath:
		SIMP N 6;
		SIMP O 6 A_XScream;
		SIMP P 6;
		SIMP Q 6 A_Fall;
		SIMP RST 6;
		SIMP U -1;
		Stop;
	Raise:
		SIMP LKJI 5;
		Goto See;
	}
}

class SahuaginFireball : Actor
{
	Default
	{
		Radius 8;
		Height 16;
		Speed 20;
		Damage 4;
		SeeSound "imp/attack";
		DeathSound "imp/shotx";
		Decal "PlasmaScorchLower";
		Projectile;
		RenderStyle "STYLE_Add";
	}

	States
	{
	Spawn:
		SIBA AB 8;
		Loop;
	Death:
		SIBA CDE 5;
		Stop;
	}
}
