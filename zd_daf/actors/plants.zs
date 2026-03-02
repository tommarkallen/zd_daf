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
