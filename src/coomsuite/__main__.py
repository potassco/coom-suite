"""
The main entry point for the application.
"""

import sys
from os.path import basename, join, splitext
from tempfile import TemporaryDirectory

from . import convert_coom, solve, write_facts
from .bounds.solver import BoundSolver
from .preprocess import preprocess
from .utils.logging import configure_logging, get_logger
from .utils.parser import get_parser


def main() -> None:
    """
    Run the main function.
    """
    parser = get_parser()
    args, solver_args = parser.parse_known_args()
    configure_logging(sys.stderr, args.log, sys.stderr.isatty())

    log = get_logger("main")

    # log.info("info")
    # log.warning("warning")
    # log.debug("debug")
    # log.error("error")

    log.info("Converting COOM file %s", args.input)
    serialized_facts, unbounded = convert_coom(args.input, coom_user=args.user_input if args.user_input else None)

    if args.command == "convert":
        # asp_instance = convert_instance(args.input, "model", args.output)
        if args.output is None:
            print(serialized_facts)
        else:
            write_facts(serialized_facts, join(args.output, splitext(basename(args.input))[0] + "-coom.lp"))

    elif args.command == "solve":
        log.info("Solving COOM file %s", args.input)

        with TemporaryDirectory() as temp_dir:
            # # Parse COOM to ASP serialized facts
            # serialized_facts = [convert_instance(args.input, "model", temp_dir)] + (
            #     [convert_instance(args.user_input, "user", temp_dir)] if args.user_input else []
            # )
            temp_file = join(temp_dir, "serialized-facts.lp")
            log.info("Saving serialized facts to %s", temp_file)
            write_facts(serialized_facts, temp_file)

            if args.show_facts:
                print("\n".join(preprocess([temp_file], discrete=True)))  # nocoverage
            elif unbounded:
                bound_solver = BoundSolver([temp_file], args.solver, solver_args, args.output)
                bound = bound_solver.get_bounds(
                    algorithm=args.bounds, initial_bound=args.initial_bound, use_multishot=args.multishot
                )

                print(f"\n The minimal upper bound is {bound}")
            else:
                solve([temp_file], args.solver, 0, solver_args, args.output)


if __name__ == "__main__":
    main()
