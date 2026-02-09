"""
The main entry point for the application.
"""

import sys
from os.path import basename, join, splitext

from . import convert_coom, run_ui, solve, write_facts
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
    elif args.command == "ui":
        log.info("Running UI with COOM file %s", args.input)
        run_ui(serialized_facts)

    elif args.command == "solve":
        log.info("Solving COOM file %s", args.input)

        if args.show_facts:
            log.info("Printing preprocessed facts")
            print("\n".join(preprocess(serialized_facts, discrete=True)))  # nocoverage
        elif unbounded:
            bound_solver = BoundSolver(serialized_facts, args.solver, solver_args, args.output)
            bound = bound_solver.get_bounds(
                algorithm=args.bounds, initial_bound=args.initial_bound, use_multishot=args.multishot
            )

            print(f"\n The minimal upper bound is {bound}")
        else:
            solve(serialized_facts, args.solver, 0, solver_args, args.output)


if __name__ == "__main__":
    main()
