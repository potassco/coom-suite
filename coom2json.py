from json import dump

if __name__ == "__main__":
    with open("coom-output.txt", "r", encoding="utf-8") as f:
        coom_output = [l.strip() for l in f.readlines()]

    d = {}
    for c in coom_output:
        split = c.split("=")
        if len(split) == 2:
            var, val = split
            val = val.strip()
        else:
            var = split[0]
            val = None
        var = var.strip()

        node = d
        for p in var.split("."):
            if p not in node:
                node[p] = {}
            node = node[p]

    with open("output.json", "w", encoding="utf-8") as f:
        dump(d, f)
