"""
Generate cargo bike benchmark instances.
"""

import argparse
import os

parser = argparse.ArgumentParser(
    prog="GenerateCargoBike",
    description="Generate cargo bike benchmark instances",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument("--range", type=int, default=200, help="Upper bound for domain of volume features")
parser.add_argument("--instances", type=int, default=10, help="Number of instances")
parser.add_argument("--min", type=int, default=50, help="Minimum value for requested volume, in percent of range")
parser.add_argument("--max", type=int, default=100, help="Maximum value for requested volume, in percent of range")
parser.add_argument(
    "--template", type=str, default="simple", help="Template to use for the instance (simple or complex)"
)
parser.add_argument("--name", type=str, default="cargo-bike", help="Instance name")
parser.add_argument("--out", type=str, default="out", help="Output directory")


def get_instance(template: str, max_volume: int):
    with open(template, "r", encoding="utf-8") as f:
        instance = f.read()

    return instance.replace("MAX", str(max_volume))


def get_user_input(max_volume: int, request: int) -> str:
    return f"set requestedVolume[0] = {int(max_volume * request / 100)}"


if __name__ == "__main__":
    args = parser.parse_args()

    os.makedirs(args.out, exist_ok=True)

    match args.template:
        case "simple":
            template = "instance.coom"
            name = args.name
        case "complex":
            template = "instance-complex.coom"
            name = args.name + "-complex"
        case _:
            raise ValueError("unknown template")

    # get instance with updated range for volume attributes
    instance = get_instance(template, args.range)

    # write instance to file
    outinstance = os.path.join(args.out, f"{name}_{args.range}.coom")
    with open(outinstance, "w", encoding="utf-8") as f:
        f.write(instance)

    # compute the requested volumes as percent of the range
    request_range = args.max - args.min
    request_step = request_range / (args.instances - 1)
    requests = [args.min + i * request_step for i in range(args.instances)]

    # get the user input for each request and write to file
    for i, request in enumerate(requests):
        user_input = get_user_input(args.range, request)

        outuser = os.path.join(args.out, f"user-input-{name}_{args.range}_{i}.coom")
        with open(outuser, "w", encoding="utf-8") as f:
            f.write(f"{user_input}\n")
