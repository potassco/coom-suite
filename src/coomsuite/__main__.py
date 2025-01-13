"""
The main entry point for the application.
"""

import sys
from tempfile import NamedTemporaryFile, TemporaryDirectory

from clingo.application import clingo_main

from . import convert_instance
from .application import COOMSolverApp
from .preprocess import check_user_input, preprocess
from .utils.logging import configure_logging, get_logger
from .utils.parser import get_parser


def main():
    """
    Run the main function.
    """
    parser = get_parser()
    args, unknown_args = parser.parse_known_args()
    configure_logging(sys.stderr, args.log, sys.stderr.isatty())

    log = get_logger("main")

    # log.info("info")
    # log.warning("warning")
    # log.debug("debug")
    # log.error("error")

    if args.command == "convert":
        asp_instance = convert_instance(args.input, "model", args.output)

        if args.user_input:
            output_user_lp_file = convert_instance(args.user_input, "user", args.output)

        if args.output is None:
            print(asp_instance)
            if args.user_input:
                print("")
                print(output_user_lp_file)

    elif args.command == "solve":
        log.info("Converting and solving COOM file %s", args.input)
        with TemporaryDirectory() as temp_dir:
            # Parse COOM to ASP serialized facts
            serialized_facts = [convert_instance(args.input, "model", temp_dir)] + (
                [convert_instance(args.user_input, "user", temp_dir)] if args.user_input else []
            )

            # Preprocess serialized ASP facts
            processed_facts = preprocess(
                serialized_facts,
                discrete=args.solver == "clingo",
            )

            if args.show_facts:
                print("\n".join(processed_facts))  # nocoverage
            else:
                check_user_input(processed_facts)

                with NamedTemporaryFile(mode="w", delete=False) as tmp:
                    tmp_name = tmp.name
                    tmp.write("".join(processed_facts))

                # Solve the ASP instance
                clingo_main(
                    COOMSolverApp(
                        options={
                            "solver": args.solver,
                            "output_format": args.output,
                        }
                    ),
                    [tmp_name] + unknown_args,
                )


if __name__ == "__main__":
    main()
