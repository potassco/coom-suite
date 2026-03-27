class Blind (
    int: density;
    int: weight;
    int: area;
    var Engine: engine;

    constraint weight = area * density
)

class Engine (
    int: price
    int: maxLoad

    constraint count (b in Blind) (b.engine=this) <= 3;

    constraint sum(b in Blind) (b.engine=this)
)

set of new Blind: blinds;
set of new Engine: engines;
