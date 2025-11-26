"""
The main entry point for the application.
"""

import sys
from tempfile import TemporaryDirectory

from . import convert_instance, solve
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

    if args.command == "convert":
        asp_instance = convert_instance(args.input, "model", args.output)
        if args.output is None:
            print(asp_instance)

        if args.user_input:
            output_user_lp_file = convert_instance(args.user_input, "user", args.output)

            if args.output is None:
                print("")
                print(output_user_lp_file)

    elif args.command == "solve":
        log.info("Converting and solving COOM file %s", args.input)

        with TemporaryDirectory() as temp_dir:
            # Parse COOM to ASP serialized facts
            serialized_facts = [convert_instance(args.input, "model", temp_dir)] + (
                [convert_instance(args.user_input, "user", temp_dir)] if args.user_input else []
            )

            if args.show_facts:
                print("\n".join(preprocess(serialized_facts, discrete=True)))  # nocoverage
            elif args.bounds:
                bound_solver = BoundSolver(serialized_facts, args.solver, solver_args, args.output)
                bound = bound_solver.get_bounds(
                    algorithm=args.bounds, initial_bound=args.initial_bound, use_multishot=args.multishot
                )

                print(f"\n The minimal upper bound is {bound}")
            else:
                solve(serialized_facts, args.solver, 99, solver_args, args.output)


if __name__ == "__main__":
    main()
