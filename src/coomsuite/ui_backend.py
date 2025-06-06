"""
Contains a custom backend for the UI.
"""

from clingo import Control, Symbol
from clinguin.server.application.backends.explanation_backend import ExplanationBackend
from clinguin.utils.annotations import overwrites

# from .utils import format_sym_coom


def asp2coom(s: Symbol) -> str:
    """
    Converts ASP output symbols to COOM facts.
    """
    if s.name == "include":
        return s.arguments[0].string.removeprefix("root.")
    if s.name == "value":
        path = s.arguments[0].string.removeprefix("root.")
        value = s.arguments[1]
        return f"{path} = {value}"
    raise ValueError(f"Unrecognized predicate: {s.name}")


def coom2asp(c: str) -> str:
    """
    Converts COOM facts to ASP facts.
    """
    if c.contains("="):
        path, value = c.split("=")
        return f'value("{path.strip()}", {value.strip()})'
    else:
        path = c.strip()
        return f'include("{path}")'


class CoomBackend(ExplanationBackend):
    """
    Extends ExplanationBackend with functionality for the COOM UI.
    """

    @overwrites(ExplanationBackend)
    def download(self, show_prg=None, file_name="current_solution.coom"):
        """
        Downloads the current model in COOM format. It must be selected first via :func:`~select` .

        Arguments:
            show_prg (_type_, optional): Program to filter output using show statements. Defaults to None.
            file_name (str, optional): The name of the file for the download. Defaults to "current_solution.coom".
        """
        if self._model is None:
            raise RuntimeError("Cant download when there is no model")
        show_prg = show_prg or ""
        prg = "\n".join([f"{s}." for s in self._model])
        ctl = Control()
        ctl.add("base", [], prg)
        try:
            ctl.add("base", [], show_prg.replace('"', ""))
        except RuntimeError as exc:
            raise Exception("Show program can't be parsed. Make sure it is a valid clingo program.") from exc
        ctl.ground([("base", [])])
        with ctl.solve(yield_=True) as hnd:
            for m in hnd:
                output_symbols = [s for s in m.symbols(shown=True)]

        sorted_symbols = sorted(output_symbols)
        final_prg = "\n".join([f"{asp2coom(s)}" for s in sorted_symbols])

        file_name = file_name.strip('"')
        with open(file_name, "w", encoding="UTF-8") as file:
            file.write(final_prg)
        self._messages.append(
            (
                "Download successful",
                f"Information saved in file {file_name}.",
                "success",
            )
        )

    def upload(self, file: str):
        """
        Uploads a COOM solution to the backend.
        The solution will parsed to ASP and selected as current model.

        Arguments:
            file (str): The file to upload in COOM format.
        """
        self.clear_assumptions()

        lines = file.splitlines()
        for line in lines:
            self.add_assumption(coom2asp(line))
