//===========================================================================
//
// ZDoom ZScript - Nightstalker
//
// Based on: "Obsidian Ravager" by DeVloek
// Sprites: DeVloek, Crate Entertainment
// Sprite Edit: DeVloek
// Sounds: Crate Entertainment
// Idea Base: Obsidian Ravager from Grim Dawn
//
//===========================================================================

class Nightstalker : Actor
{
	bool CanCastTrap;
	Default
	{
		//$Category Monsters/Undead
		//$Title "Nightstalker"
		Health 2000;
		Radius 24;
		Height 96;
		Mass 1000;
		Speed 14;
		PainChance 40;
		Monster;
		Species "Undead";
		Scale 0.7;
		MeleeRange 84;
		+FLOORCLIP;
		+MISSILEMORE;
		+MISSILEEVENMORE;
		+DONTGIB;
		+NOBLOODDECALS;
		BloodType "NightstalkerChunk";
		SeeSound "Nightstalker/alert";
		PainSound "Nightstalker/pain";
		DeathSound "Nightstalker/death";
		ActiveSound "Nightstalker/idle";
		Obituary "%o was killed by a Nightstalker.";
		HitObituary "%o was killed by a Nightstalker.";
		Tag "Nightstalker";
	}
	States
	{
	Spawn:
		NSTL IJK 10 A_Look;
		Loop;
	See:
		NSTL ABCDEFGH 7 A_Chase;
		Loop;
	Melee:
		NSTL L 1 A_FaceTarget;
		NSTL L 1 A_PlaySound("Nightstalker/swipe");
		NSTL L 4 A_FaceTarget;
		NSTL M 6 A_FaceTarget;
		NSTL NNN 2
		{
			A_FaceTarget();
			A_Recoil(-3);
		}
		NSTL O 12 A_CustomMeleeAttack(random(10, 15) * 7, "Nightstalker/melee");
		NSTL P 10;
		Goto See;
	Missile:
		TNT1 A 0
		{
			if (CanCastTrap==true && random(1,3)==1)
			{
				CanCastTrap = false;
				SetStateLabel("CastTrap");
			}
		}
		NSTL QR 5 A_FaceTarget;
		NSTL S 10 A_PlaySound("Nightstalker/attack");
		NSTL T 5 A_FaceTarget;
		TNT1 A 0
		{
			if (random(1,2)==1) SetStateLabel("Missile1");
		}
		Goto Missile2;
	CastTrap:
		NSTL R 10 A_FaceTarget;
		NSTL P 10 A_SpawnProjectile("NightstalkerTrapAttack");
		Goto See;
	Missile1:
		NSTL U 8
		{
			if(target)
			{
				int Dist = Distance3D(target);
				int zDiff = (self.pos.z - target.pos.z);
				if ((Dist < 250) || (zDiff < 0)) A_SpawnProjectile("NightstalkerBallNoGrav",59,0,0);
				else if (Dist < 400) A_SpawnProjectile("NightstalkerBall",59,0,0,CMF_OFFSETPITCH,Dist*-0.01);
				else if (Dist > 1000) A_SpawnProjectile("NightstalkerBall",59,0,0,CMF_OFFSETPITCH,-18);
				else A_SpawnProjectile("NightstalkerBall",59,0,0,CMF_OFFSETPITCH,Dist*-0.018);
			}
			A_Playsound("Nightstalker/missile");
			CanCastTrap = true;
		}
		NSTL V 8;
		Goto See;
	Missile2:
		NSTL U 8
		{
			if(target)
			{
				int Dist = Distance3D(target);
				int zDiff = (self.pos.z - target.pos.z);
				if ((Dist < 250) || (zDiff < 0))
				{
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(-14,-18));
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(14,18));
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(-8,-12));
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(8,12));
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(-2,-6));
					A_SpawnProjectile("NightstalkerBarrageNoGrav",59,0,random(2,6));
				}
				else if (Dist < 400)
				{
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-14,-18),CMF_OFFSETPITCH,(Dist*-0.01));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(14,18),CMF_OFFSETPITCH,(Dist*-0.01));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-8,-12),CMF_OFFSETPITCH,(Dist*-0.01));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(8,12),CMF_OFFSETPITCH,(Dist*-0.01));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-2,-6),CMF_OFFSETPITCH,(Dist*-0.01));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(2,6),CMF_OFFSETPITCH,(Dist*-0.01));
				}
				else if (Dist > 1000)
				{
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-14,-18),CMF_OFFSETPITCH,-18);
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(14,18),CMF_OFFSETPITCH,-18);
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-8,-12),CMF_OFFSETPITCH,-18);
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(8,12),CMF_OFFSETPITCH,-18);
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-2,-6),CMF_OFFSETPITCH,-18);
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(2,6),CMF_OFFSETPITCH,-18);
				}
				else
				{
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-14,-18),CMF_OFFSETPITCH,(Dist*-0.018));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(14,18),CMF_OFFSETPITCH,(Dist*-0.018));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-8,-12),CMF_OFFSETPITCH,(Dist*-0.018));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(8,12),CMF_OFFSETPITCH,(Dist*-0.018));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(-2,-6),CMF_OFFSETPITCH,(Dist*-0.018));
					A_SpawnProjectile("NightstalkerBarrage",59,0,random(2,6),CMF_OFFSETPITCH,(Dist*-0.018));
				}
				A_Playsound("Nightstalker/missile");
				CanCastTrap = true;
			}
		}
		NSTL V 8;
		Goto See;
	Pain:
		NSTL W  4;
		NSTL X  4 A_Pain;
		NSTL YZ 4;
		Goto See;
	Death:
		NSTK A 8;
		NSTK B 8 A_Scream;
		NSTK C 8;
		NSTK D 8 A_NoBlocking;
		NSTK E 8;
		NSTK F -1;
		Stop;
	Raise:
		NSTL F 8;
		NSTL EDCBA 8;
		Goto See;
	}
}

class NightstalkerBall : Actor
{
	Default
	{
		Radius 5;
		Height 5;
		Speed 12;
		DamageFunction (random(10,12) * 6);
		Translation "112:127=176:191";
		Scale 1.4;
		Projectile;
		Gravity 0.2;
		-NOGRAVITY;
		+SEEKERMISSILE;
		+RANDOMIZE;
		DeathSound "Nightstalker/impact";
		Decal "NightstalkerBallScorch";
	}
	States
	{
	Spawn:
		BAL7 AAABBBAAABBB 2 BRIGHT A_SpawnItemEx("NightstalkerBallTrail", 0, 0, 0, 0, 0, 0, 0, SXF_TRANSFERTRANSLATION|SXF_TRANSFERPOINTERS);
		TNT1 A 0 BRIGHT A_NoGravity;
		TNT1 A 0 BRIGHT A_SeekerMissile(2, 3);
		Loop;
	Death:
		BAL7 C 0 BRIGHT A_NoGravity;
		BAL7 CDE 6 BRIGHT;
		Stop;
	}
}

class NightstalkerBallNoGrav : NightstalkerBall
{
	Default
	{
		+NOGRAVITY;
	}
}

class NightstalkerBarrage : NightstalkerBall
{
	Default
	{
		Radius 2;
		Height 2;
		DamageFunction (random(10,12) * 2);
		Scale 0.5;
		Decal "NightstalkerBarrageScorch";
	}
	States
	{
	Spawn:
		BAL7 AAAAAABBBBBBAAAAAABBBBBB 1 BRIGHT A_SpawnItemEx("NightstalkerBarrageTrail", -5, 0, 0, 0, 0, 0, 0, SXF_TRANSFERTRANSLATION|SXF_TRANSFERPOINTERS);
		TNT1 A 0 BRIGHT A_NoGravity;
		TNT1 A 0 BRIGHT A_SeekerMissile(1, 2);
		Goto See;
	See:
		BAL7 AAAAAA 1 BRIGHT A_SpawnItemEx("NightstalkerBarrageTrail", -5, 0, 0, 0, 0, 0, 0, SXF_TRANSFERTRANSLATION|SXF_TRANSFERPOINTERS);
		TNT1 A 0 BRIGHT A_SeekerMissile(1, 2);
		BAL7 BBBBBB 1 BRIGHT A_SpawnItemEx("NightstalkerBarrageTrail", -5, 0, 0, 0, 0, 0, 0, SXF_TRANSFERTRANSLATION|SXF_TRANSFERPOINTERS);
		TNT1 A 0 BRIGHT A_SeekerMissile(1, 2);
		Loop;
	}
}

class NightstalkerBarrageNoGrav : NightstalkerBarrage
{
	Default
	{
		+NOGRAVITY;
	}
}

class NightstalkerBallTrail : Actor
{
	Default
	{
		RenderStyle "Translucent";
		Alpha 0.5;
		+NOGRAVITY;
		+RANDOMIZE;
	}
	States
	{
	Spawn:
		BAL7 AB 4 BRIGHT A_FadeOut(0.15);
		Loop;
	}
}

class NightstalkerBarrageTrail : NightstalkerBallTrail
{
	Default
	{
		Scale 0.3;
	}
	States
	{
	Spawn:
		BAL7 AB 4 BRIGHT A_FadeOut(0.2);
		Loop;
	}
}

class NightstalkerChunk : Actor
{
	Default
	{
		Scale 0.3;
		Gravity 0.5;
		+NOBLOCKMAP;
		+NOTELEPORT;
	}
	States
	{
	Spawn:
		NOBC ABCDEFGH 4;
		Stop;
	}
}

class NightstalkerTrapAttack : Actor
{
	bool trapped;
	Default
	{
		Radius 5;
		Height 5;
		Speed 256;
		Damage 0;
		Projectile;
		+SEEKERMISSILE;
	}
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
	}
	override int SpecialMissileHit(actor victim)
	{
		if (victim && target && (victim != target))
		{
			if (trapped != 1)
			{
				victim.A_Playsound("Nightstalker/trapspawn");
				victim.A_SpawnItemEx("NightstalkerTrap1", 16, -32, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap2", 32, -16, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap3", 32, 16, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap4", 16, 32, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap1", -16, 32, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap2", -32, 16, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap3", -32, -16, -32, 0, 0, 0, 0);
				victim.A_SpawnItemEx("NightstalkerTrap4", -16, -32, -32, 0, 0, 0, 0);
				trapped = 1;
			}
		}
		return 1;
	}
	States
	{
	Spawn:
		TNT1 A 1 A_SeekerMissile(90, 90);
		Loop;
	Death:
		TNT1 A 0;
		Stop;
	}
}

class NightstalkerTrap1 : ThrustFloorUp
{
	Default
	{
		Scale 0.4;
		Radius 6;
		Height 52;
		DeathSound "Nightstalker/trapdeath";
		Health 30;
		+NOTELEPORT;
		+SOLID;
		+SHOOTABLE;
		+DONTTHRUST;
		+NOBLOODDECALS;
		BloodType "NightstalkerChunk";
	}
	States
	{
	Spawn:
		NOT1 ABC 2;
		Goto See;
	See:
		NOT1 DDDD 32;
		Goto Death;
	Death:
		NOT1 C 3 A_Scream;
		NOT1 BA 3 A_ParticleDust();
		TNT1 A 0;
		Stop;
	}
}

class NightstalkerTrap2 : NightstalkerTrap1
{
	States
	{
	Spawn:
		NOT2 ABC 2;
		Goto See;
	See:
		NOT2 DDDD 32;
		Goto Death;
	Death:
		NOT2 C 3 A_Scream;
		NOT2 BA 3 A_ParticleDust();
		TNT1 A 0;
		Stop;
	}
}

class NightstalkerTrap3 : NightstalkerTrap1
{
	States
	{
	Spawn:
		NOT3 ABC 2;
		Goto See;
	See:
		NOT3 DDDD 32;
		Goto Death;
	Death:
		NOT3 C 3 A_Scream;
		NOT3 BA 3 A_ParticleDust();
		TNT1 A 0;
		Stop;
	}
}

class NightstalkerTrap4 : NightstalkerTrap1
{
	States
	{
	Spawn:
		NOT4 ABC 2;
		Goto See;
	See:
		NOT4 DDDD 32;
		Goto Death;
	Death:
		NOT4 C 3 A_Scream;
		NOT4 BA 3 A_ParticleDust();
		TNT1 A 0;
		Stop;
	}
}

Extend Class NightstalkerTrap1
{
	void A_ParticleDust()
	{
		A_SpawnParticle("black", SPF_RELATIVE, 70, 50, 0, 0, 0, 0, 0, 0, 0.5, 0, 0, 0, 0.5, -1, 3);
	}
}
