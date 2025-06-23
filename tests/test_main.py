"""
Test cases for main application functionality.
"""

from io import StringIO
from unittest import TestCase

from clingo.symbol import parse_term

from coomsuite.utils import format_sym_coom, logging, sort_refined_facts
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

    def test_coom_output(self) -> None:
        """
        Test the COOM output formatting.
        """
        self.assertEqual(format_sym_coom(parse_term('include("carrier[0]")')), "carrier[0]")
        self.assertEqual(format_sym_coom(parse_term('value("color[0]", "Blue")')), 'color[0] = "Blue"')
        self.assertEqual(format_sym_coom(parse_term('value("wheel[0].size[0]", 27)')), "wheel[0].size[0] = 27")
        self.assertRaises(ValueError, format_sym_coom, parse_term('instance("")'))

    def test_sort_refined_facts(self) -> None:
        """
        Test the sorting of refined facts.
        """
        facts = [
            'discrete("Color").',
            'domain("Wheel","W14").',
            'integer("Wheel.size").',
            'range("Wheel.size",14,20).',
            'type("root","product").',
            'index("root.rearWheel[0].size[0]",0).',
            'parent("root.color[0]","root").',
            'constraint(("root.color",1),"lowerbound").',
            'constraint(("Wheel","root.rearWheel[0]"),"table").',
            'constraint((0,"root.frontWheel[0].size[0]>16"),"boolean").',
            'binary("root.frontWheel[0].size[0]>16","root.frontWheel[0].size[0]",">","16").',
            'unary("!root.color[0]=Yellow","!","root.color[0]=Yellow").',
            'function("count(root.carrier.bag)","count","root.carrier.bag").',
            'column((1,"root"),0,0,"root.wheelSupport[0]").',
            'allow(1,(0,0),"True").',
            'set("root.color","root.color[0]").',
            'part("product").',
            'constant("Yellow").',
            'number("16",16).',
            'explanation(1,"A wheel support can only be used with rear wheels of type W14 or W16.").',
            'user_value("root.color[0]","Yellow").',
            'user_include("root.wheel[0]").',
        ]
        sorted_facts = sort_refined_facts(facts)
        sorted_facts_without_comments = [f for f in sorted_facts if not f.startswith("%") and f != ""]
        self.assertEqual(set(facts), set(sorted_facts_without_comments))
