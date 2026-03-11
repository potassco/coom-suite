#### Problem

```
product {
	1..* Item items
	1..* Cluster clusters
}

structure Item {
	reference Cluster cluster
	bool withPrevious
}

structure Cluster {
	reference 1..3 Item items
}
```

#### Benötigte Constraints

- Cluster Erzeugung, abhängig von `withPrevious`
- Cluster Zugehörigkeit (`reference`), sequenzielle Ordnung
  (`item[i].cluster <= item[i+1].cluster`)!
- Cluster Kardinalität (`1..3`)
- Bidirektionale Referenzen

## Modellierungsalternativen / Sprachkonstrukte\#

### Stand Heute

```
behavior clusterAssignment {
    // Item 0 always starts a new cluster
    require items[0].withPrevious = false
    require items[0].cluster = clusters[0]

    // Item 1
    condition items[1].withPrevious = true
    require items[1].cluster = items[0].cluster

    condition items[1].withPrevious = false
    require items[1].cluster = clusters[1]

    // Item 2, predecessor had withPrevious=true (same cluster as item 1)
    condition items[2].withPrevious = true
    require items[2].cluster = items[1].cluster

    // Item 2, predecessor had withPrevious=false (new cluster)
    condition items[2].withPrevious = false
    condition items[1].withPrevious = false
    require items[2].cluster = clusters[2]

    condition items[2].withPrevious = false
    condition items[1].withPrevious = true
    require items[2].cluster = clusters[1]
}
```

#### All-Quantifikator `for item in items`

- Alleine vermutlich nicht ausreichend, Referenz auf Nachfolger / Index
  erforderlich
- Möglicherweise kombinierbar mit `next(item)` oder `previous(item)` innerhalb
  Block?

```
behavior {
    for item in items {
	    // First item must start a new cluster
        condition !previous(item)
        require item.cluster = clusters[0]

		// If withPrevious is true, share the previous item's cluster
        condition previous(item)
        condition item.withPrevious = true
        require item.cluster = previous(item).cluster

		// If withPrevious is false (and not first), start a new cluster
        condition previous(item)
        condition item.withPrevious = false
        require item.cluster = clusters[index(previous(item).cluster) + 1]
        // ALTERNATIV ohne index?
        require item.cluster = next(previous(item).cluster)
    }
}
```

Erfordert entweder `index()` -> Index-Quantifizierung oder Generalisierung von
`next()` auf beliebige Sequenzen (außerhalb der quantifizierten Variable).
Letzteres hat unklare Semantik wenn:

- Referenzen auf Elemente aus unterschiedlichen Listen
- Die selbe Instanz innerhalb verschiedener Sequenzen auftaucht

Alternativ interne Heuristik für sequenzielle Zuweisung?

#### Index-Quantifizierung `for i in 0..count(items)`

- Ausreichend, allerdings verboser und fehleranfälliger, Semantik unklarer

```
behavior {
    for i in 0..count(items) - 1 {
        // First item: cluster index is 0
        condition i = 0
        require items[i].clusterIndex = 0
        require items[i].withPrevious = false

        // withPrevious = true: same cluster index as predecessor
        condition i > 0
        condition items[i].withPrevious = true
        require items[i].clusterIndex = items[i - 1].clusterIndex

        // withPrevious = false: increment cluster index
        condition i > 0
        condition items[i].withPrevious = false
        require items[i].clusterIndex = items[i - 1].clusterIndex + 1

        // Wire up the reference using the computed index
        require items[i].cluster = clusters[items[i].clusterIndex]
    }

    // Total clusters needed
    require count(clusters) = items[last].clusterIndex + 1
}
```

- Loop bounds sind Solver-Variablen `for i in 0..count(items)` -> während
  solving modifizierbar?
- Pfad-Indizes sind Solver-Variablen -> out of bounds?
- Negative Indizes sind bereits definiert `items[-1]` \<-> Rückwärts zählen?

#### Prozedurale DSL-Erweiterung

```
hook {
    clusterIndex = 0
    driveCluster = null

    for i in 0..count(items) - 1 {
        item = items[i]

        if previous(item) = null || item.withPrevious = false {
            driveCluster = new Cluster
            append(clusters, driveCluster)
            clusterIndex = clusterIndex + 1
        }

        item.cluster = driveCluster
        append(driveCluster.items, item)

        if count(driveCluster.items) > max_cardinality(driveCluster.items) {
            fail "Cluster cardinality exceeded"
        }
    }
}
```

#### Problemspezifischer Ausdruck

Generalisierte Partitionierung:

```
behavior {
    partition items // the sequence to iterate over
    into clusters // the sequence to generate
    linked by (item.cluster, cluster.items) // bidirectional references
    merge when withPrevious // the condition when to merge
}
```
