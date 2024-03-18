"""
Utilities.
"""

from importlib.resources import as_file, files


def get_encoding() -> str:
    """Returns the kids bike encoding

    Returns:
        str: The path to the kids bike encoding
    """
    with as_file(files("coomsolver") / "encodings" / "encoding-clingo-kids.lp") as file:
        return str(file)
