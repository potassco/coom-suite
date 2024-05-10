"""
Test cases for main application functionality.
"""

from io import StringIO
from unittest import TestCase

from clingo.symbol import parse_term

from coomsolver.utils import format_sym_coom, logging
from coomsolver.utils.logging import configure_logging, get_logger
from coomsolver.utils.parser import get_parser


class TestMain(TestCase):
    """
    Test cases for main application functionality.
    """

    def test_logger(self) -> None:
        """
        Test the logger.
        """
        sio = StringIO()
        configure_logging(sio, logging.INFO, True)
        log = get_logger("main")
        log.info("test123")
        self.assertRegex(sio.getvalue(), "test123")

    def test_parser(self) -> None:
        """
        Test the parser.
        """
        parser = get_parser()
        ret = parser.parse_args(["--log", "info"])
        self.assertEqual(ret.log, logging.INFO)

    def test_coom_output(self) -> None:
        """
        Test the COOM output formatting.
        """
        self.assertEqual(format_sym_coom(parse_term('instance((), "")')), "")
        self.assertEqual(format_sym_coom(parse_term('instance((carrier, ((), 0)), "Carrier")')), "carrier[0]")
        self.assertEqual(format_sym_coom(parse_term('val((color, ((), 0)), "Blue")')), 'color[0] = "Blue"')
        self.assertEqual(format_sym_coom(parse_term("val((size, ((wheel, ((), 0)), 0)), 27)")), "wheel[0].size[0] = 27")
        self.assertRaises(ValueError, format_sym_coom, parse_term("structure(5)"))
