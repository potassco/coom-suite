"""
Main function for navigator shell.
"""

import argparse

from navigation.shell import NavigatorShell


def main():
    parser = argparse.ArgumentParser(prog="navigation shell")
    parser.add_argument("program", nargs="?")
    parser.add_argument("--script")

    args = parser.parse_args()

    shell = NavigatorShell(args.program)

    if args.script:
        shell.run_script(args.script)

    shell.cmdloop()


if __name__ == "__main__":
    main()
