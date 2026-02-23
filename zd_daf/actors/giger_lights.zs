class HRCeilingLight : Actor
{
	Default
	{
		Height 32;
		Scale 0.27;
		+NOGRAVITY;
		+SPAWNCEILING;
	}
	States
	{
	Spawn:
		HRCL A -1;
		Stop;
	}
}

class HRFloorLamp : Actor
{
	Default
	{
		Height 48;
		Scale 0.38;
		Radius 24;
		+SOLID;
	}
	States
	{
	Spawn:
		HRL2 A -1;
		Stop;
	}
}

class HRTallLight : Actor
{
	Default
	{
		Height 128;
		Scale 0.60;
		Radius 32;
		+SOLID;
	}
	States
	{
	Spawn:
		HRLT A -1;
		Stop;
	}
}

class HRPillar : Actor
{
	Default
	{
		Height 128;
		Scale 0.60;
		Radius 16;
		+SOLID;
	}
	States
	{
	Spawn:
		HRPL A -1;
		Stop;
	}
}

class Reactor : Actor
{
	Default
	{
		Height 192;
		Scale 0.60;
		Radius 80;
		+SOLID;
	}
	States
	{
	Spawn:
		RCTR A -1;
		Stop;
	}
}

class HRLadder : Actor
{
	Default
	{
		Scale 0.50;
		+NOGRAVITY;
	}
	States
	{
	Spawn:
		LADR A -1;
		Stop;
	}
}

class HRNerve : Actor
{
	Default
	{
		Height 8;
		Scale 0.50;
		Radius 8;
	}
	States
	{
	Spawn:
		NRVE A -1;
		Stop;
	}
}

class HRPillar2 : Actor
{
	Default
	{
		Height 128;
		Scale 0.58;
		Radius 8;
		+SOLID;
	}
	States
	{
	Spawn:
		HRP2 A -1;
		Stop;
	}
}

class HRConsole : Actor
{
	Default
	{
		Height 48;
		Scale 0.40;
		Radius 16;
		+SOLID;
	}
	States
	{
	Spawn:
		HRCS A -1;
		HRCS B -1;
		HRCS C -1;
		HRCS D -1;
		Stop;
	}
}

class HRConduit : Actor
{
	Default
	{
		Height 128;
		Scale 0.56;
		Radius 24;
		+SOLID;
	}
	States
	{
	Spawn:
		HRCD A -1;
		HRCD B -1;
		HRCD C -1;
		HRCD D -1;
		HRCD E -1;
		HRCD F -1;
		Stop;
	}
}
