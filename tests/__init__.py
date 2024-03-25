"""
Basic functions to run tests.
"""

from typing import List

from antlr4 import InputStream

from coomsolver.utils import run_antlr4_visitor


def parse_coom(coom_input: str) -> List[str]:
    """
    Helper function for testing the COOM to ASP parser.
    """
    input_stream = InputStream(coom_input)
    return run_antlr4_visitor(input_stream)

    #     output_list = fake_out.getvalue().split("\n")
    #     print(output_list)
    #     output_list = output_list[:-1] if output_list[-1] == "" else output_list
    #     return output_list
