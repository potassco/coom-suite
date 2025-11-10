"""
Generate house benchmark instances.
"""

import argparse
import os
import random
from typing import List, Optional

TEMPLATE = "instance.coom"

parser = argparse.ArgumentParser(
    prog="GenerateHous",
    description="Generate house benchmark instances",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument("--maxrooms", type=int, default=10, help="Upper bound of the domain for numRooms")
parser.add_argument("--maxthings", type=int, default=10, help="Upper bound of the domain for numThings")
parser.add_argument("--persons", type=int, default=3, help="Number of persons")
parser.add_argument("--rooms", type=int, help="Number of rooms")
parser.add_argument("--instances", type=int, default=10, help="Number of instances to generate")
parser.add_argument(
    "--randomize",
    type=int,
    help="Randomize number of short and long things, value of this option is the number of instances for one total value of things",
)
parser.add_argument("--name", type=str, default="house", help="Instance name")
parser.add_argument("--out", type=str, default="out", help="Output directory")


def get_instance(max_rooms: int, max_things: int, num_persons: int):
    with open(TEMPLATE, "r", encoding="utf-8") as f:
        instance = f.read()

    replacements = {
        "MAXROOMS": str(max_rooms),
        "MAXTHINGS": str(max_things),
        "NUMPERSONS": str(num_persons),
    }

    for key, value in replacements.items():
        instance = instance.replace(key, value)

    return instance


def get_user_input(rooms: Optional[int], persons: int, short_things: int, long_things: int) -> List[str]:
    user_input = []

    if rooms:
        user_input.append(f"set numRooms[0] = {rooms}")

    for i in range(persons):
        user_input.append(f"set person[{i}].numShortThings[0] = {short_things}")
        user_input.append(f"set person[{i}].numLongThings[0] = {long_things}")

    return user_input


def get_pairs(total: int, num_pairs: int):
    pairs = []
    for _ in range(num_pairs):
        x = random.randint(0, total)
        pairs.append((x, total - x))

    return pairs


if __name__ == "__main__":
    args = parser.parse_args()

    os.makedirs(args.out, exist_ok=True)

    instance = get_instance(args.maxrooms, args.maxthings, args.persons)

    outinstance = os.path.join(
        args.out,
        (
            f"{args.name}_{args.maxrooms}_{args.maxthings}_{args.persons}"
            + (f"_{args.rooms}" if args.rooms else "")
            + ".coom"
        ),
    )
    with open(outinstance, "w", encoding="utf-8") as f:
        f.write(instance)

    step = (args.maxthings - 1) // (args.instances - 1)
    num_things = [1 + i * step for i in range(args.instances)]

    for i, things in enumerate(num_things):
        if args.randomize:
            pairs = get_pairs(things, args.randomize)
        else:
            pairs = [(things, things)]

        for j, (short_things, long_things) in enumerate(pairs):
            user_input = get_user_input(args.rooms, args.persons, short_things, long_things)

            outuser = os.path.join(
                args.out,
                (
                    f"user-input-{args.name}_{args.maxrooms}_{args.maxthings}_{args.persons}"
                    + (f"_{args.rooms}" if args.rooms else "")
                    + f"_{things}"
                    + (f"_{j}" if args.randomize else "")
                    + ".coom"
                ),
            )
            with open(outuser, "w", encoding="utf-8") as f:
                f.write("\n".join(user_input))
                f.write("\n")
