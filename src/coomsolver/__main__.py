"""
The main entry point for the application.
"""

import sys
from tempfile import NamedTemporaryFile

from clingo.application import clingo_main

from . import convert_instance
from .application import COOMApp
from .utils.logging import configure_logging  # , get_logger
from .utils.parser import get_parser


def main():
    """
    Run the main function.
    """
    parser = get_parser()
    args = parser.parse_args()
    configure_logging(sys.stderr, args.log, sys.stderr.isatty())

    # log = get_logger("main")

    # log.info("info")
    # log.warning("warning")
    # log.debug("debug")
    # log.error("error")

    print(args.input)

    if args.command == "convert":
        convert_instance(args.input, args.output)
    elif args.command == "solve":
        with NamedTemporaryFile(suffix=".lp") as temp:
            convert_instance(args.input, temp.name)
            clingo_main(COOMApp(), [temp.name] + ["--out-ifs=\\n", "--out-atomf=%s."])


if __name__ == "__main__":
    main()
