"""
Module defining a coom specific navigator class.
"""

from importlib.resources import as_file, files

from clingo.control import Control
from clingo.solving import Model
from clingo.symbol import Symbol

from .navigator import Navigator


class CoomNavigator(Navigator):
    """
    Coom specific navigator class.
    """

    def _on_model(self, model: Model) -> set[Symbol]:
        """
        Only use shown atoms.
        """
        result = set()
        for s in model.symbols(shown=True):
            if not self._is_auxiliary(s):
                result.add(s)
        return result

    def _get_all_atoms(self) -> set[Symbol]:
        """
        Only get shown atoms.
        """
        if self._atoms is None:
            self._ground()

            self._atoms = set()
            for atom in self._control.symbolic_atoms:
                if not atom.is_external:
                    self._atoms.add(atom.symbol)

            ctl = Control()
            with as_file(files("coomsuite") / "encodings" / "show-clingo.lp") as file:
                ctl.load(str(file))
            for a in self._atoms:
                ctl.add(f"{a}.")
            self._atoms = set()
            ctl.ground()
            with ctl.solve(yield_=True) as handle:
                for atom in handle.model().symbols(shown=True):
                    self._atoms.add(atom)

        return self._atoms
