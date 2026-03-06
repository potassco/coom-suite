"""
Module implementing a coom specific navigation shell.
"""

from cmd import Cmd

from clingo.control import Control

from .coom_navigator import CoomNavigator
from .shell import NavigatorShell


class CoomShell(NavigatorShell):
    """
    Coom specific navigation shell.
    """

    prompt = "(coom) "

    def __init__(self, control: Control | None = None, grounded: bool | None = None):
        Cmd.__init__(self)
        self.nav = CoomNavigator(control, grounded)
        print("interactive coom shell - type 'help' or '?' for commands")
