Class Uzumaki : Actor {
	Default {
        //$Category "Models/Architecture"
        //$Title "Uzumaki"
		Radius 16;
		Height 0;

		+NOGRAVITY
		+SOLID
		+INVULNERABLE
		+NODAMAGE
		+SHOOTABLE
		+NOTAUTOAIMED
		+NEVERTARGET
		+DONTTHRUST
		
	}

	States {
		Spawn:
			PLAY A -1;
			Stop;
	}
}