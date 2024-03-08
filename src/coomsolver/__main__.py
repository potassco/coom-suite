"""
The main entry point for the application.
"""

import sys

from . import convert_instance
from .utils.logging import configure_logging, get_logger
from .utils.parser import get_parser

# from clingo.application import clingo_main


def main():
    """
    Run the main function.
    """
    parser = get_parser()
    args = parser.parse_args()
    configure_logging(sys.stderr, args.log, sys.stderr.isatty())

    get_logger("main")

    if args.command == "convert":
        convert_instance(args.input, args.output)
    elif args.command == "solve":
        print("Solving")
    # log.info('info')
    # log.warning('warning')
    # log.debug('debug')
    # log.error('error')


if __name__ == "__main__":
    main()
