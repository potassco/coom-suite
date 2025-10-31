"""
Test cases for multishot application class.
"""

# pylint: disable=protected-access

from contextlib import redirect_stdout
from typing import List, Any, Tuple, Dict, Set
from unittest import TestCase
from unittest.mock import call, create_autospec

from clingo import Control, SolveResult
from clingo.symbol import Function, Number, String, parse_term, Symbol

from coomsuite.bounds.multi_application import COOMMultiSolverApp, _filter_existing_facts, _get_fact_name_and_args


class TestMultiApplication(TestCase):
    """
    Test cases for multishot application class.
    """

    def test_multi_application_helper_functions(self) -> None:
        """
        Test helper functions used in multishot application class.
        """
        for existing, new, filtered in [(["p."], ["p.", "q.", "r."], ["q.", "r."])]:
            self.assertEqual(_filter_existing_facts(existing, new), filtered)

        for fact, result in [
            (
                'set("root.totalVolume","root.totalVolume[0]").',
                ("set", [parse_term('"root.totalVolume"'), parse_term('"root.totalVolume[0]"')]),
            ),
            (
                'index("root.color[0]",0).',
                ("index", [parse_term('"root.color[0]"'), parse_term("0")]),
            ),
            ('allow(7,(1,0),"S").', ("allow", [parse_term("7"), parse_term("(1,0)"), parse_term('"S"')])),
        ]:
            self.assertEqual(_get_fact_name_and_args(fact), result)

        # test behavior when fact is not given with trailing "."
        self.assertRaises(RuntimeError, _get_fact_name_and_args, "p(0)")

    def test_init_flingo(self) -> None:
        """
        Test initialization with flingo as solver.
        """
        self.assertRaises(ValueError, COOMMultiSolverApp, [], options={"solver": "flingo"})

    def test_get_prog_part(self) -> None:
        """
        Test function for getting the program part of a (non-incremental) fact.
        """
        app = COOMMultiSolverApp([])

        for fact, part in [
            ('allow(7,(1,0),"S").', ("new_allow", [parse_term("7"), parse_term("(1,0)"), parse_term('"S"')])),
            # program parts that get the bound added to arguments
            (
                'type("root.bags[1]","Bags").',
                ("new_type", [parse_term('"root.bags[1]"'), parse_term('"Bags"'), parse_term("1")]),
            ),
            (
                'constraint(("root.color",1),"lowerbound").',
                ("new_constraint", [parse_term('("root.color",1)'), parse_term('"lowerbound"'), parse_term("1")]),
            ),
            (
                'column(("Size","root.bags[0].size[0]"),0,0,"root.bags[0].size[0]").',
                (
                    "new_column",
                    [
                        parse_term('("Size","root.bags[0].size[0]")'),
                        parse_term("0"),
                        parse_term("0"),
                        parse_term('"root.bags[0].size[0]"'),
                        parse_term("1"),
                    ],
                ),
            ),
        ]:
            self.assertEqual(app._get_prog_part(fact, 1), part)

        # invalid program part
        self.assertRaises(ValueError, app._get_prog_part, 'number("5",5).', 0)

    def test_get_incremental_prog_part(self) -> None:
        """
        Test function for getting the program part of an incremental fact.
        """
        app = COOMMultiSolverApp([])

        name = parse_term('"name"')
        bound = 3
        bound_term = Number(3)

        for exp_type, args, part in [
            ("unary", [name], ("incremental_unary", [name, bound_term])),
            ("constraint", [name], ("incremental_constraint", [name, bound_term])),
            ("function", [name], ("new_incremental_function", [name, bound_term])),
            ("function", [name], ("update_incremental_function", [name, bound_term])),
        ]:
            self.assertEqual(app._get_incremental_prog_part(exp_type, args, bound), part)

        lhs_name = parse_term('"lhs"')
        op_name = parse_term('"op"')
        rhs_name = parse_term('"rhs"')
        binary_args = [name, lhs_name, op_name, rhs_name]
        part_args = binary_args.copy()
        part_args.append(bound_term)
        app._incremental_expressions = {rhs_name.string}
        self.assertEqual(
            app._get_incremental_prog_part("binary", binary_args.copy(), bound),
            ("incremental_binary_r", part_args),
        )
        app._incremental_expressions = {lhs_name.string}
        self.assertEqual(
            app._get_incremental_prog_part("binary", binary_args.copy(), bound),
            ("incremental_binary_l", part_args),
        )
        app._incremental_expressions = {rhs_name.string, lhs_name.string}
        self.assertEqual(
            app._get_incremental_prog_part("binary", binary_args.copy(), bound),
            ("incremental_binary", part_args),
        )

        self.assertRaises(ValueError, app._get_incremental_prog_part, "number", [], 0)

    def test_check_if_updates_incremental_set(self) -> None:
        """
        Test helper function that checks if a fact updates an incremental set.
        """
        app = COOMMultiSolverApp([])

        app._incremental_sets["name"] = set()

        for fact, result in [('set("other",2).', None), ('set("name",1).', "name"), ("p.", None)]:
            self.assertEqual(app._check_if_updates_incremental_set(fact), result)

    def test_update_bound(self) -> None:
        """
        Test the update bounds function of multi application class.
        """
        app = COOMMultiSolverApp([], algorithm="linear", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 5)]:
            self.assertEqual(app._prev_bound, prev)
            self.assertEqual(app.max_bound, current)
            app._update_bound()

        app = COOMMultiSolverApp([], algorithm="exponential", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 8)]:
            self.assertEqual(app._prev_bound, prev)
            self.assertEqual(app.max_bound, current)
            app._update_bound()

    def test_remove_new_incremental_expressions(self) -> None:
        """
        Test functionality of removing new incremental expressions from a list of facts.
        """
        app = COOMMultiSolverApp([])

        # initial value of processed facts
        processed = ['allow(7,(0,0),"small").']

        # initial value of new processed facts
        new = [
            'domain("Size","small").',
            'constraint(("root.color",1),"lowerbound").',
            'constraint((7,"root.bags[0]"),"table").',
            'constraint((2,"root.color[0]=Blue"),"boolean").',
            'function("count(root.bags[0].pockets)","count","root.bags[0].pockets").',
            'binary("root.color[0]=Blue","root.color[0]","=","Blue").',
            'unary("-7","-","7").',
        ]
        # incremental expressions part of the initial value of new processed facts
        incremental = [
            'constraint((4,"5<count(root.bags.pockets)"),"boolean").',
            'function("count(root.bags.pockets)","count","root.bags.pockets").',
            'binary("5<count(root.bags.pockets)","5","<","count(root.bags.pockets)").',
            'unary("(count(root.bags.pockets))","()","count(root.bags.pockets)").',
        ]

        # initialize attributes accordingly
        app._new_processed_facts = new + incremental
        app._processed_facts = processed.copy()
        app._incremental_expressions = {
            "5<count(root.bags.pockets)",
            "count(root.bags.pockets)",
            "(count(root.bags.pockets))",
        }

        removed = app._remove_new_incremental_expressions()

        # check that return value of function matches the incremental expressions
        # note that return value has type List[Tuple[str, List[Symbol]]]
        self.assertCountEqual(removed, [_get_fact_name_and_args(f) for f in incremental])
        # check that processed facts are the initial value (processed) + incremental
        self.assertCountEqual(app._processed_facts, processed + incremental)
        # check that new processed facts contains only new but not incremental
        self.assertCountEqual(app._new_processed_facts, new)

    def test_update_incremental_data(self) -> None:
        """
        Test updating of data structures tracking incremental sets and expressions.
        """
        app = COOMMultiSolverApp([])

        # initial incremental data
        inc_sets_dict: Dict[str, Set[Tuple[str, Tuple[Symbol, ...]]]] = {}
        inc_sets_dict["root.bags.pockets"] = {
            (
                "function",
                (String("count(root.bags.pockets)"), String("count"), String("root.bags.pockets")),
            ),
        }
        inc_expressions = {"5<count(root.bags.pockets)"}

        # initialize attributes
        app._incremental_sets = inc_sets_dict.copy()
        app._incremental_expressions = inc_expressions.copy()

        # incremental facts for updating incremental data
        incremental_facts = [
            'inc_set("root.bags.size.volume").',
            'inc_set("root.bags.pockets").',
            (
                'incremental("function","sum(root.bags.size.volume)","root.bags.size.volume",'
                '("sum(root.bags.size.volume)","sum","root.bags.size.volume")).'
            ),
            (
                'incremental("binary","5<count(root.bags.pockets)","root.bags.pockets",'
                '("5<count(root.bags.pockets)","5","<","count(root.bags.pockets)")).'
            ),
            (
                'incremental("constraint","5<count(root.bags.pockets)","root.bags.pockets",'
                '((4,"5<count(root.bags.pockets)"),"boolean")).'
            ),
        ]

        app._update_incremental_data(incremental_facts)

        # add everything to the expected results
        inc_sets_dict["root.bags.pockets"].add(
            (
                "constraint",
                (parse_term('(4,"5<count(root.bags.pockets)")'), String("boolean")),
            )
        )
        inc_sets_dict["root.bags.pockets"].add(
            (
                "binary",
                (String("5<count(root.bags.pockets)"), String("5"), String("<"), String("count(root.bags.pockets)")),
            )
        )
        inc_sets_dict["root.bags.size.volume"] = {
            (
                "function",
                (String("sum(root.bags.size.volume)"), String("sum"), String("root.bags.size.volume")),
            )
        }
        inc_expressions.add("sum(root.bags.size.volume)")

        self.assertEqual(app._incremental_sets, inc_sets_dict)
        self.assertEqual(app._incremental_expressions, inc_expressions)

    def test_get_prog_part_of_incremental_set(self) -> None:
        """
        Test function computing all program parts of an incremental set.
        """
        app = COOMMultiSolverApp([])

        # initialize data
        app._incremental_sets = {}
        app._incremental_sets["root.bags.pockets"] = set()
        expected_parts = []
        bound = 2

        # add elements to the incremental set and respective program parts to expected return
        for name, args, part_name in [
            (
                "function",
                [String("count(root.bags.pockets)"), String("count"), String("root.bags.pockets")],
                "new_incremental_function",
            ),
            (
                "constraint",
                [parse_term('(4,"5<count(root.bags.pockets)")'), String("boolean")],
                "incremental_constraint",
            ),
            (
                "unary",
                [String("(count(root.bags.pockets))"), String("()"), String("count(root.bags.pockets)")],
                "incremental_unary",
            ),
        ]:
            app._incremental_sets["root.bags.pockets"].add((name, tuple(args)))
            expected_parts.append((part_name, args + [Number(bound)]))

        parts = app._get_prog_part_of_incremental_set("root.bags.pockets", bound)

        self.assertCountEqual(parts, expected_parts)

    def _get_mock_control(self, solve_is_sat: List[bool]) -> Control:
        """
        Create a mock control object.

        Args:
            solve_is_sat (List[bool]): list of returns values for solve calls (True/False for SAT/UNSAT)
        """
        control = create_autospec(Control)

        returns = []
        for sat in solve_is_sat:
            ret = create_autospec(SolveResult)
            ret.satisfiable = sat
            returns.append(ret)

        control.solve.side_effect = returns

        return control  # type: ignore[no-any-return]

    def test_find_minimal_bound(self) -> None:
        """
        Test the function computing the minimal bound.
        """
        app = COOMMultiSolverApp([])

        # expected function calls to the control object
        # - helper functions to define sequence of calls
        def assign(name: str, bound: int, value: bool) -> Any:
            return call.assign_external(Function(name, [Number(bound)], True), value)

        def release(name: str, bound: int) -> Any:
            return call.release_external(Function(name, [Number(bound)], True))

        # - initial calls
        initial_calls = [
            assign("active", 7, False),
            assign("active", 8, False),
            release("max_bound", 8),
            assign("max_bound", 6, True),
            call.solve(),
        ]
        # - calls after the first solve is satisfiable
        calls_after_sat = [
            assign("active", 6, False),
            release("max_bound", 6),
            assign("max_bound", 5, True),
            call.solve(),
        ]
        # - calls after the first solve is unsatisfiable
        calls_after_unsat = [
            assign("active", 7, True),
            release("max_bound", 6),
            assign("max_bound", 7, True),
            call.solve(),
        ]

        # define values for testing
        # prev_init: initial value of app._prev_bound
        # max_init: initial value of app.max_bound
        # sat_values: list of return values of control.solve for defining mock control
        # calls: expected sequence of calls to the control object
        # max_return: the expected value of app.max_bound upon return
        for prev_init, max_init, sat_values, calls, max_return in [
            (
                0,
                1,
                [],
                [],
                1,
            ),
            (
                4,
                8,
                [False, True],
                initial_calls + calls_after_unsat,
                7,
            ),
            (
                4,
                8,
                [False, False],
                initial_calls + calls_after_unsat,
                8,
            ),
            (
                4,
                8,
                [True, True],
                initial_calls + calls_after_sat,
                5,
            ),
            (
                4,
                8,
                [True, False],
                initial_calls + calls_after_sat,
                6,
            ),
        ]:
            # initialize values
            app._prev_bound = prev_init
            app.max_bound = max_init
            # initialize mock control object
            control = self._get_mock_control(sat_values)

            # compute the minimal bound
            with redirect_stdout(None):
                app._find_minimal_bound(control)

            # check that the correct minimal bound was computed
            self.assertEqual(app.max_bound, max_return)

            # check what calls were made to the control object
            self.assertEqual(control.mock_calls, calls)  # type: ignore[attr-defined]
