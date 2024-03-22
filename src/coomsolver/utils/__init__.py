"""
Utilities.
"""

from importlib.resources import as_file, files

SOLVERS = ["clingo"]  # , "fclingo"]
COOM_PROFILES = ["kids", "city", "travel"]


def get_encoding(file_name) -> str:
    """Gets the path to a given ASP encoding in the encodings folder

    Input:
        file_name (str): The name of the ASP encoding with the extension

    Returns:
        str: The string for the path to the ASP encoding
    """
    with as_file(files("coomsolver") / "encodings" / file_name) as file:
        return str(file)
