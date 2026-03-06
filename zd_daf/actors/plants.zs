class Anemone01 : Actor {
    Default {
        //$Category "Models/Plants"
        //$Title "Anemone01"
        Radius 12;
        Height 24;

        +SOLID
		+NODAMAGE
		+NOTARGET
		+NOGRAVITY
    }
    States {
		Spawn:
			PLAY A -1;
			Stop;
    }
}

class Anemone02 : Actor
{
    Default
    {
        //$Category "Models/Plants"
        //$Title "Anemone02"
        Radius 12;
        Height 24;

        +SOLID
		+NODAMAGE
		+NOTARGET
		+NOGRAVITY
    }

    States
    {
    Spawn:
        PLAY A -1;
        Stop;
    }
}

class Anemone03 : Actor
{
    Default
    {
        //$Category "Models/Plants"
        //$Title "Anemone03"
        Radius 12;
        Height 24;

        +SOLID
		+NODAMAGE
		+NOTARGET
		+NOGRAVITY
    }

    States
    {
    Spawn:
        PLAY A -1;
        Stop;
    }
}

class Seaweed1 : Actor
{
    Default
    {
        //$Category "Models/Plants"
        //$Title "Seaweed1"
        Radius 8;
        Height 64;

        +NODAMAGE
        +NOTARGET
        +NOGRAVITY
    }

    States
    {
    Spawn:
        NO3D ABCDEFGHIJKLMNOPQRSTUVWXYZ 4;
        NB3D ABCDEFGHIJKLMNO 4;
        Loop;
    }
}

class Seaweed2 : Actor
{
    Default
    {
        //$Category "Models/Plants"
        //$Title "Seaweed2"
        Radius 8;
        Height 32;

        +NODAMAGE
        +NOTARGET
        +NOGRAVITY
    }

    States
    {
    Spawn:
        NO3D ABCDEFGHIJKLMNOPQRSTUVWXYZ 4;
        NB3D ABCDEFGHIJKLMN 4;
        Loop;
    }
}

class Seaweed3 : Actor
{
    Default
    {
        //$Category "Models/Plants"
        //$Title "Seaweed3"
        Radius 8;
        Height 64;

        +NODAMAGE
        +NOTARGET
        +NOGRAVITY
    }

    States
    {
    Spawn:
        NO3D ABCDEFGHIJKLMNOPQRSTUVWXYZ 4;
        NB3D ABCDEFGHIJKLMN 4;
        Loop;
    }
}
