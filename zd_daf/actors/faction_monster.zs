//===========================================================================
//
// Faction Monster
//
// FIXME: Attempt to override non-existent virtual function isHostile
//
// 0 = neutral, 1 = Illithid
// 2 = Demon (Tanar'ri), 3 = Devil (Baatezu), 4 = Daemon (Yugoloth)
// 5 = Demon (Obyrith), 6 = Daemon (Chaos)
//===========================================================================

class FactionMonster : Actor
{
	int FactionID;

    override bool IsEnemy(Actor other)
    {
        if (other == null) 
            return false;

        let fm = FactionMonster(other);
        if (fm != null)
        {
            return fm.FactionID != FactionID;
        }

        return super.IsEnemy(other);
    }
}
