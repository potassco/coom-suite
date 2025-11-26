"""
Test cases for main application functionality.
"""

from io import StringIO
from unittest import TestCase

from clingo.symbol import parse_term

from coomsuite.utils import asp2coom, coom2asp, logging
from coomsuite.utils.logging import configure_logging, get_logger
from coomsuite.utils.parser import get_parser


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

    def test_asp2coom(self) -> None:
        """
        Test the COOM output formatting.
        """
        self.assertEqual(asp2coom(parse_term('include("root.carrier[0]")')), "carrier[0]")
        self.assertEqual(asp2coom(parse_term('value("root.color[0]", "Blue")')), 'color[0] = "Blue"')
        self.assertEqual(asp2coom(parse_term('value("root.wheel[0].size[0]", 27)')), "wheel[0].size[0] = 27")
        self.assertRaises(ValueError, asp2coom, parse_term('instance("")'))

    def test_coom2asp(self) -> None:
        """
        Test the COOM to ASP conversion
        """
        self.assertEqual(coom2asp("carrier[0]"), 'include("root.carrier[0]")')
        self.assertEqual(coom2asp('color[0] = "Blue"'), 'value("root.color[0]","Blue")')
        self.assertEqual(coom2asp("wheel[0].size[0] = 27"), 'value("root.wheel[0].size[0]",27)')
