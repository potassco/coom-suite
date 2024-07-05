"""
Generates random core benchmark instances
"""

import argparse
import os
from random import choices, sample
from typing import Any, List

parser = argparse.ArgumentParser(
    prog="GenerateRandomKids",
    description="Generates random core benchmark instances",
)
parser.add_argument("--features", "-f", type=int)
parser.add_argument("--options", "-o", type=int)
parser.add_argument("--constraint_size", "-c", type=int)
parser.add_argument("--name", type=str)
parser.add_argument("--out", type=str)


def make_row(num_cols: int, options: List[str]) -> str:
    return " ".join([f"F{i}" for i in choices(options, k=num_cols)])


def make_constraint(num_cols: int, num_rows: int, features: List[Any], options: List[Any]) -> str:
    cols = " ".join([f"feat{i}" for i in sample(features, num_cols)])
    combinations = f"combinations ({cols})"

    rows = "\n".join([f"allow ({make_row(num_cols, options)})" for i in range(num_rows)])
    constraint = "behavior{\n" + combinations + "\n" + rows + "\n}"
    return constraint


if __name__ == "__main__":
    args = parser.parse_args()

    # OUTDIR = os.path.join(INSTANCE_DIR, f"{args.features}_{args.options}")
    os.makedirs(args.out, exist_ok=True)

    FEATURES = "\n".join([f"Feat{i} feat{i}" for i in range(args.features)])
    OPTIONS = " ".join([f"F{i}" for i in range(args.options)])
    ENUMERATIONS = "\n".join([f"enumeration Feat{i}{{ {OPTIONS} }}" for i in range(args.features)])

    instance = []

    instance.append(f"product{{ {FEATURES} }}")
    instance.append("")

    instance.append(ENUMERATIONS)

    constraints = [
        make_constraint(
            args.constraint_size,
            args.options * 2,
            list(range(args.features)),
            list(range(args.options)),
        )
        for _ in range((args.features // args.constraint_size) + 1)
    ]

    outfile = os.path.join(
        args.out,
        f"{args.name}{args.features}_{args.options}_{args.constraint_size}.coom",
    )
    with open(outfile, "w", encoding="utf-8") as f:
        f.write("\n".join(instance))
        f.write("\n\n")
        f.write("\n".join(constraints))
