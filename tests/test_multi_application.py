"""
Test cases for multishot application class.
"""

# pylint: disable=protected-access

from contextlib import redirect_stdout
from typing import Any, Dict, List, Optional, Set, Tuple
from unittest import TestCase
from unittest.mock import ANY, call, create_autospec, patch

from clingo import Control, SolveResult
from clingo.symbol import Function, Number, String, Symbol, parse_term

from coomsuite.bounds.multi_application import COOMMultiSolverApp, _get_fact_name_and_args


class TestMultiApplication(TestCase):
    """
    Test cases for multishot application class.
    """

    def test_multi_application_helper_function(self) -> None:
        """
        Test helper function used in multishot application class.
        """
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
            self.assertEqual(_get_fact_name_and_args(fact), result, f"failed with fact={fact}, result={result}")

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
            ('number("5",5).', ("new_number", [parse_term('"5"'), parse_term("5")])),
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
            self.assertEqual(app._get_prog_part(fact, 1), part, f"failed with fact={fact}, part={part}")

        # invalid program part
        self.assertRaises(ValueError, app._get_prog_part, 'part("test").', 0)

    def test_get_incremental_prog_part(self) -> None:
        """
        Test function for getting the program part of an incremental fact.
        """
        app = COOMMultiSolverApp([])

        name = parse_term('"name"')
        bound = 3
        bound_term = Number(3)

        # test unary, constraint and function
        for exp_type, args, part in [
            ("unary", [name], ("incremental_unary", [name, bound_term])),
            ("constraint", [name], ("incremental_constraint", [name, bound_term])),
            # first the function prog parts has prefix new
            ("function", [name], ("new_incremental_function", [name, bound_term])),
            # then it has prefix update
            ("function", [name], ("update_incremental_function", [name, bound_term])),
        ]:
            self.assertEqual(
                app._get_incremental_prog_part(exp_type, args, bound),
                part,
                f"failed with exp_type={exp_type}, args={args}, part={part}",
            )

        # test three cases for binary expression
        lhs_name = parse_term('"lhs"')
        op_name = parse_term('"op"')
        rhs_name = parse_term('"rhs"')
        binary_args = [name, lhs_name, op_name, rhs_name]
        part_args = binary_args.copy()
        part_args.append(bound_term)
        for inc_expressions, part_name in [
            # 1: only the right sub-expression is incremental
            ({rhs_name.string}, "incremental_binary_r"),
            # 2: only the left sub-expression is incremental
            ({lhs_name.string}, "incremental_binary_l"),
            # 3: both sub-expressions are incremental
            ({rhs_name.string, lhs_name.string}, "incremental_binary"),
        ]:
            app._incremental_expressions = inc_expressions
            self.assertEqual(
                app._get_incremental_prog_part("binary", binary_args.copy(), bound),
                (part_name, part_args),
                f"failed with inc_expressions={inc_expressions}, part_name={part_name}",
            )

        # test invalid incremental fact
        self.assertRaises(ValueError, app._get_incremental_prog_part, "number", [], 0)

    def test_check_if_updates_incremental_set(self) -> None:
        """
        Test helper function that checks if a fact updates an incremental set.
        """
        app = COOMMultiSolverApp([])

        app._incremental_sets["name"] = set()

        for fact, result in [('set("other",2).', None), ('set("name",1).', "name"), ("p.", None)]:
            self.assertEqual(
                app._check_if_updates_incremental_set(fact), result, f"failed with fact={fact}, result={result}"
            )

    def test_update_bound(self) -> None:
        """
        Test the update bounds function of multi application class.
        """
        app = COOMMultiSolverApp([], algorithm="linear", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 5)]:
            fail_msg = f"failed with prev={prev}, current={current}"
            self.assertEqual(app._prev_bound, prev, fail_msg)
            self.assertEqual(app.max_bound, current, fail_msg)
            app._update_bound()

        app = COOMMultiSolverApp([], algorithm="exponential", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 8)]:
            fail_msg = f"failed with prev={prev}, current={current}"
            self.assertEqual(app._prev_bound, prev, fail_msg)
            self.assertEqual(app.max_bound, current, fail_msg)
            app._update_bound()

    def test_remove_new_incremental_expressions(self) -> None:
        """
        Test functionality of removing new incremental expressions from a list of facts.
        """
        app = COOMMultiSolverApp([])

        # initial value of _processed_facts
        processed = {'allow(7,(0,0),"small").'}

        # initial value of _new_processed_facts
        new = {
            'domain("Size","small").',
            'constraint(("root.color",1),"lowerbound").',
            'constraint((7,"root.bags[0]"),"table").',
            'constraint((2,"root.color[0]=Blue"),"boolean").',
            'function("count(root.bags[0].pockets)","count","root.bags[0].pockets").',
            'binary("root.color[0]=Blue","root.color[0]","=","Blue").',
            'unary("-7","-","7").',
        }
        # incremental expressions part of the initial value of _new_processed_facts
        incremental = {
            'constraint((4,"5<count(root.bags.pockets)"),"boolean").',
            'function("count(root.bags.pockets)","count","root.bags.pockets").',
            'binary("5<count(root.bags.pockets)","5","<","count(root.bags.pockets)").',
            'unary("(count(root.bags.pockets))","()","count(root.bags.pockets)").',
        }

        # initialize attributes accordingly
        app._new_processed_facts = new | incremental
        app._processed_facts = processed.copy()
        app._incremental_expressions = {
            "5<count(root.bags.pockets)",
            "count(root.bags.pockets)",
            "(count(root.bags.pockets))",
        }

        # remove the new incremental expressions
        removed = app._remove_new_incremental_expressions()

        # check that return value of function matches the incremental expressions
        # note that return value has type List[Tuple[str, List[Symbol]]]
        self.assertCountEqual(removed, [_get_fact_name_and_args(f) for f in incremental])
        # check that _processed_facts are the initial value (processed) + incremental
        self.assertEqual(app._processed_facts, processed | incremental)
        # check that _new_processed_facts contains only new but not incremental
        self.assertEqual(app._new_processed_facts, new)

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
        incremental_facts = {
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
        }

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

        # test value of _incremental_set dictionary
        self.assertEqual(app._incremental_sets, inc_sets_dict)
        # test value of _incremental_expressions set
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
        Helper function to create a mock control object with a list of return values of solve.

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

            fail_msg = (
                f"failed with prev_init={prev_init}, max_init={max_init}, "
                f"sat_values={sat_values}, max_return={max_return}"
            )

            # check that the correct minimal bound was computed
            self.assertEqual(app.max_bound, max_return, fail_msg)

            # check what calls were made to the control object
            self.assertEqual(control.mock_calls, calls, fail_msg)  # type: ignore[attr-defined]

    def test_preprocess_new_bound(self) -> None:
        """
        Test preprocessing and updates to data structures for a new bound.
        """
        # initial values for preocessed and new processed facts
        initial_processed = {'domain("Color","Green").'}
        initial_new_processed = {'domain("Color","Blue").'}

        # new facts added by preprocessing (mocked below)
        non_incremental = {'domain("Color","Red").'}
        incremental = {
            'inc_set("root.bags.pockets").',
            (
                'incremental("function","count(root.bags.pockets)","root.bags.pockets",'
                '("count(root.bags.pockets)","count","root.bags.pockets"))'
            ),
        }

        # define expected values after calling preprocess_new_bound
        # expected processed facts
        expected_processed = initial_processed | initial_new_processed
        # expected new processed facts
        expected_new_processed = non_incremental
        # expected arguments to update incremental data method
        expected_update_args = incremental

        # bound to process at
        bound = 2

        # mock preprocess function
        with patch("coomsuite.bounds.multi_application.preprocess", autospec=True) as mock_preprocess:
            # mock return value
            mock_preprocess.side_effect = [list(non_incremental | incremental)]

            # initialize multi solver
            app = COOMMultiSolverApp([])
            app._processed_facts = initial_processed.copy()
            app._new_processed_facts = initial_new_processed.copy()

            # mock update incremental data function
            with patch.object(app, "_update_incremental_data", autospec=True) as mock_update:
                # call multi solver preprocess function
                app._preprocess_new_bound(bound)

                # check arguments of call to preprocess
                self.assertEqual(mock_preprocess.call_args, call([], max_bound=bound, discrete=True, multishot=True))
                # check _processed_facts
                self.assertEqual(app._processed_facts, expected_processed)
                # check _new_processed_facts
                self.assertEqual(app._new_processed_facts, expected_new_processed)
                # check arguments of call to _update_incremental_data
                self.assertEqual(mock_update.call_args, call(expected_update_args))

    def test_compute_prog_parts_at_zero(self) -> None:
        """
        Test compute program parts function for bound zero.
        """
        app = COOMMultiSolverApp([])

        with (
            patch.object(app, "_remove_new_incremental_expressions", autospec=True) as mock_remove,
            patch.object(app, "_get_incremental_prog_part", autospec=True) as mock_get_inc_part,
        ):
            # mocked return value of _remove_new_incremental_expressions
            mock_remove.side_effect = [[("function", ['"count"']), ("unary", ['"()"'])]]
            # expected program parts
            expected_parts = [
                ("new_function", [String('"count"'), Number(0)]),
                ("new_unary", [String('"()"'), Number(0)]),
            ]
            # mock the program parts as return values of _get_incremental_prog_part
            mock_get_inc_part.side_effect = expected_parts.copy()
            # expected calls to _get_incremental_prog_part
            expected_get_inc_part_calls = [
                call("function", ['"count"'], 0),
                call("unary", ['"()"'], 0),
            ]

            # compute program parts for bound 0
            parts = app._compute_prog_parts(0)

            # check that correct parts are returned
            self.assertEqual(parts, expected_parts)
            # check call to _get_incremental_prog_part
            self.assertEqual(mock_get_inc_part.call_args_list, expected_get_inc_part_calls)

    def test_compute_prog_parts_at_non_zero(self) -> None:
        """
        Test compute program parts function for non-zero bound.
        """
        app = COOMMultiSolverApp([])

        with (
            patch.object(app, "_remove_new_incremental_expressions", autospec=True) as mock_remove,
            patch.object(app, "_check_if_updates_incremental_set", autospec=True) as mock_check_updates,
            patch.object(app, "_get_prog_part", autospec=True) as mock_get_part,
            patch.object(app, "_get_prog_part_of_incremental_set", autospec=True) as mock_get_part_inc_set,
        ):
            # mocked return value of _remove_new_incremental_expressions
            mock_remove.side_effect = [[]]

            # mocked return value of _check_if_updates_incremental_set
            def mock_check_updates_side_effect(fact: str) -> Optional[str]:
                match fact:
                    case 'set("root.bags","root.bags[1]").':
                        return '"root.bags"'
                    case _:
                        return None

            mock_check_updates.side_effect = mock_check_updates_side_effect

            # mocked return value of _get_prog_part
            non_inc_parts = [
                ("new_set", [String('"root.color"'), String('"root.color[0]"')]),
                ("new_set", [String('"root.bags"'), String('"root.bags[1]"')]),
            ]
            mock_get_part.side_effect = non_inc_parts.copy()

            # mocked return value of _get_prog_part_of_incremental_set
            inc_parts = [("update_incremental_function", [Number(1)]), ("incremental_unary", [Number(1)])]
            mock_get_part_inc_set.side_effect = [inc_parts.copy()]

            # initial value of _new_processed_facts
            new_facts = [
                'set("root.bags","root.bags[1]").',
                'set("root.color","root.color[0]").',
            ]
            app._new_processed_facts = set(new_facts)

            # compute all program parts for bound 1
            parts = app._compute_prog_parts(1)

            # check if the correct parts are returned
            self.assertEqual(parts, non_inc_parts + inc_parts)
            # check calls to _check_if_updates_incremental_set
            self.assertCountEqual(mock_check_updates.call_args_list, [call(x) for x in new_facts])
            # check calls to _get_prog_part
            self.assertCountEqual(mock_get_part.call_args_list, [call(x, 1) for x in new_facts])
            # check call to _get_part_of_incremental_set
            self.assertEqual(mock_get_part_inc_set.call_args_list, [call('"root.bags"', 1)])

    def test_main_control_calls(self) -> None:
        """
        Test calls to the control object in multi application main function.
        """
        app = COOMMultiSolverApp([], initial_bound=2)

        control = self._get_mock_control([False, True])

        with (
            redirect_stdout(None),
            patch.object(app, "_preprocess_new_bound", autospec=True),
            patch.object(app, "_compute_prog_parts", autospec=True),
            patch.object(app, "_find_minimal_bound", autospec=True),
        ):
            app.main(control, [])

            expected_calls = [
                call.load(ANY),
                call.load(ANY),
                # check that base program is grounded first
                call.add("base", [], ANY),
                call.ground([("base", [])]),
                # ground each bound in 0..2 and set the active external
                call.ground(ANY),
                call.assign_external(Function("active", [Number(0)], True), True),
                call.ground(ANY),
                call.assign_external(Function("active", [Number(1)], True), True),
                call.ground(ANY),
                call.assign_external(Function("active", [Number(2)], True), True),
                # check that max bound external is set correctly
                call.assign_external(Function("max_bound", [Number(2)], True), True),
                call.solve(),
                # grounding and assigning active for next bound
                call.ground(ANY),
                call.assign_external(Function("active", [Number(3)], True), True),
                # releasing previous max bound and assigning new max bound
                call.assign_external(Function("max_bound", [Number(3)], True), True),
                call.release_external(Function("max_bound", [Number(2)], True)),
                call.solve(),
            ]

            self.assertEqual(
                len(control.mock_calls),  # type: ignore[attr-defined]
                len(expected_calls),
                "number of calls to mock control does not match expected number of calls",
            )

            for i, (real, expected) in enumerate(zip(control.mock_calls, expected_calls)):  # type: ignore[attr-defined]
                self.assertEqual(real, expected, f"the {i}th call to mock control does not match the expected call")
