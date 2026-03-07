class Barrel1 : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Barrel"
        Radius 16;
        Height 48;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            BAR1 A -1;
            Stop;
    }
}

class FloorSkeleton : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Floor Skeleton"
        Radius 8;
        Height 32;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NADA A -1;
            Stop;
    }
}

class FloorSkeletonRibs : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Floor Skeleton Ribs"
        Radius 8;
        Height 16;
        Scale 1.5;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NADA A -1;
            Stop;
    }
}

// Animated shackles (swinging md3)
class ShackleOpen : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Shackle Open (animated)"
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            NB3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            NC3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            ND3D ABCDEFGHIJLKMNOPQRSTUVW 2;
            Loop;
    }
}

class ShackleClosed : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Shackle Closed (animated)"
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            NB3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            NC3D ABCDEFGHIJLKMNOPQRSTUVWXYZ 2;
            ND3D ABCDEFGHIJLKMNOPQRSTUVW 2;
            Loop;
    }
}

// Static shackles (single frame)
class ShackleOpenStatic : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Shackle Open (static)"
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            SHAO A -1;
            Stop;
    }
}

class ShackleClosedStatic : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Shackle Closed (static)"
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            SHCL A -1;
            Stop;
    }
}

class Tablet : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Tablet"
        Radius 4;
        Height 56;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class MassiveStalactite : Actor {
    Default {
        //$Category "Models/Rocks"
        //$Title "Massive Stalactite"
        Radius 64;
        Height 64;
        RenderRadius 2500;
        +NOGRAVITY
    }
    States {
        Spawn:
            BAR1 A -1;
            Stop;
    }
}

class PumpJack : Actor {
    Default {
        //$Category "Models/Props"
        //$Title "Pump Jack"
        Radius 64;
        Height 128;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            PJKA ABCDEFGHIJKLMNOPQRSTUVWXYZ 2;
            PJKB ABCDEFGHIJKLMNOPQRSTUVWXYZ 2;
            PJKC ABCDEFGHIJKLMNOPQRSTUVWXYZ 2;
            PJKD A 2;
            Loop;
    }
}
