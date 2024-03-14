"""
Utilities.
"""

# import atexit
# from contextlib import ExitStack

from importlib_resources import as_file, files


def get_file_path(package: str, file_name: str) -> str:
    """Gets the path for a file

    Args:
        package (str): The package, for instance "coomsolver.encodings"
        file_name (str): The name of the file with the extension

    Returns:
        str: The string for the path to the file
    """
    # file_manager = ExitStack()
    # atexit.register(file_manager.close)
    # ref = files(package)
    # file = file_manager.enter_context(as_file(ref / file_name))
    # return str(file)
    with as_file(files(package) / file_name) as file:
        return str(file)
