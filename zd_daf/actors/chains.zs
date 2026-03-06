// 3X (triple-length) chain variants
class Chain3xStraight : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain 3x Straight"
        Radius 8;
        Height 2;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class Chain3xStraightMiddle : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain 3x Straight (middle origin)"
        Radius 8;
        Height 2;
        -SOLID
        +NOINTERACTION
        +NOCLIP
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

// Single-length chain variants
class ChainStraightNospikes : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain Straight (no spikes)"
        Radius 8;
        Height 2;
        -SOLID
        +NOGRAVITY
        +NOINTERACTION
        +NOCLIP
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class ChainCurvedNospikes : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain Curved (no spikes)"
        Radius 8;
        Height 2;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class ChainStraight : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain Straight"
        Radius 8;
        Height 2;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class ChainCurved : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain Curved"
        Radius 8;
        Height 2;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}

class ChainCurvedRR : Actor {
    Default {
        //$Category "Models/Chains"
        //$Title "Chain Curved (large renderradius)"
        Radius 8;
        Height 2;
        RenderRadius 512;
        -SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            NO3D A -1;
            Stop;
    }
}
