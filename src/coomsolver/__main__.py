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
        output_lp_file = convert_instance(args.input, args.output)
        log.info("ASP file saved in %s", output_lp_file)
    elif args.command == "solve":
        log.info("Converting and solving COOM file %s", args.input)
        with TemporaryDirectory() as temp_dir:
            output_lp_file = convert_instance(args.input, temp_dir)
            clingo_main(
                COOMApp(solver=args.solver, output=args.output, show=args.show),
                [output_lp_file] + unknown_args,
            )


if __name__ == "__main__":
    main()
