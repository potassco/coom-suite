"""
Contains a custom backend for the UI.
"""

import base64

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
    if "=" in c:
        path, value = c.split("=")
        return f'value("root.{path.strip()}",{value.strip()})'
    else:
        path = c.strip()
        return f'include("root.{path}")'


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
        coom_solution = "\n".join([f"{asp2coom(s)}" for s in sorted_symbols])

        file_name = file_name.strip('"')
        with open(file_name, "w", encoding="UTF-8") as file:
            file.write(coom_solution)
        self._messages.append(
            (
                "Download successful",
                f"Information saved in file {file_name}.",
                "success",
            )
        )

    @overwrites(ExplanationBackend)
    def upload_file(self):
        """
        Upload file using the context. The context should have the name of the file under `filename` and the
        file content in base64 under `filecontent`.
        """
        coom_solution = next((c.value for c in self._context if c.key == "filecontent"), None)

        if not coom_solution:
            raise RuntimeError("No content found in context")

        decoded_coom_solution = base64.b64decode(coom_solution).decode("utf-8")
        asp_facts = [coom2asp(l) for l in decoded_coom_solution.splitlines() if l.strip()]
        self.clear_assumptions()

        for f in asp_facts:
            self.add_assumption(f)
