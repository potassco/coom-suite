"""
The main entry point for the application.
"""

import sys
from tempfile import TemporaryDirectory

from clingo.application import clingo_main

from . import convert_instance
from .application import COOMApp
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
            clingo_options = (
                [convert_instance(args.input, "model", temp_dir)]
                + ([convert_instance(args.user_input, "user", temp_dir)] if args.user_input else [])
                + unknown_args
            )

            if args.show_facts:
                clingo_options.append("--outf=3")

            options = {
                "solver": args.solver,
                "output_format": args.output,
                "show_facts": args.show_facts,
                "preprocess": True,
            }

            clingo_main(
                COOMApp(options=options),
                clingo_options,
            )


if __name__ == "__main__":
    main()
