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
        output_model_lp_file = convert_instance(args.input, "model", args.output)
        log.info("ASP model file saved in %s", output_model_lp_file)
        if args.user_input:
            output_user_lp_file = convert_instance(args.user_input, "user_input", args.output)
            log.info("ASP user input file saved in %s", output_user_lp_file)
    elif args.command == "solve":
        log.info("Converting and solving COOM file %s", args.input)
        with TemporaryDirectory() as temp_dir:
            output_model_lp_file = convert_instance(args.input, "model", temp_dir)
            if args.user_input:
                output_user_lp_file = convert_instance(args.user_input, "user_input", temp_dir)
            clingo_main(
                COOMApp(solver=args.solver, output=args.output, show=args.show),
                [output_model_lp_file, output_user_lp_file] + unknown_args,
            )


if __name__ == "__main__":
    main()
