// Dark rocks (skin: ZKHXRK03 from zoon_tex)
class RocksDark1 : Actor {
    Default {
        //$Category "Models/Rocks"
        //$Title "RocksDark1"
        Radius 8;
        Height 64;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            CDRA A -1;
            Stop;
    }
}

class RocksDark2 : Actor {
    Default {
        //$Category "Models/Rocks"
        //$Title "RocksDark2"
        Radius 8;
        Height 64;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            CDRB A -1;
            Stop;
    }
}

class RocksDark3 : Actor {
    Default {
        //$Category "Models/Rocks"
        //$Title "RocksDark3"
        Radius 8;
        Height 64;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            CDRC A -1;
            Stop;
    }
}

class RocksDark4 : Actor {
    Default {
        //$Category "Models/Rocks"
        //$Title "RocksDark4"
        Radius 8;
        Height 64;
        +SOLID
        +NOGRAVITY
    }
    States {
        Spawn:
            CDRD A -1;
            Stop;
    }
}

// Variant 2: skin SLROCK1 from aa_tex (brown, earthy grain)
class RocksBrown1 : RocksDark1 { Default { //$Title "RocksBrown1"
} }
class RocksBrown2 : RocksDark2 { Default { //$Title "RocksBrown2"
} }
class RocksBrown3 : RocksDark3 { Default { //$Title "RocksBrown3"
} }
class RocksBrown4 : RocksDark4 { Default { //$Title "RocksBrown4"
} }

// Variant 3: skin SLROCK22 from elementalism_tex (near-black, obsidian)
class RocksBlack1 : RocksDark1 { Default { //$Title "RocksBlack1"
} }
class RocksBlack2 : RocksDark2 { Default { //$Title "RocksBlack2"
} }
class RocksBlack3 : RocksDark3 { Default { //$Title "RocksBlack3"
} }
class RocksBlack4 : RocksDark4 { Default { //$Title "RocksBlack4"
} }

// Green rocks: same meshes, skin ds_gras1 from darksouls_tex
class RocksGreen1 : RocksDark1 { Default { //$Title "RocksGreen1"
} }
class RocksGreen2 : RocksDark2 { Default { //$Title "RocksGreen2"
} }
class RocksGreen3 : RocksDark3 { Default { //$Title "RocksGreen3"
} }
class RocksGreen4 : RocksDark4 { Default { //$Title "RocksGreen4"
} }
