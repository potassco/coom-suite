import sys
import os
from clingo.control import Control
from clingo.script import enable_python

enable_python()

current_path = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
encoding_path = str(os.path.join(current_path, "encodings", "llm-explain.lp"))


# Check if the encoding file exists
if not os.path.exists(encoding_path):
    raise FileNotFoundError(f"Encoding file not found: {encoding_path}")

ctl = Control()
ctl.load(encoding_path)


# Load additional files from command-line arguments
for f in sys.argv[1:]:
    if f is None:
        continue
    if not isinstance(f, (str, os.PathLike)):
        continue
    if not os.path.exists(f):
        continue

    ctl.load(f)

ctl.ground([("base", [])])


def print_model(m):
    for s in m.symbols(atoms=True):
        print(f"{s}.")


ctl.solve(on_model=print_model)
