"""
Test cases for multishot application class.
"""

from contextlib import redirect_stdout
from os.path import join
from typing import Any, cast
from unittest import TestCase
from unittest.mock import ANY, Mock, call, create_autospec, patch

from clingo import Control, SolveResult
from clingo.symbol import Function, Number, String, Symbol, parse_term

from coomsuite.bounds.multi_application import COOMMultiSolverApp, _get_fact_name_and_args
from coomsuite.bounds.multi_jump import COOMMultiSolverAppJump


def empty_groups(target: int, start: int) -> dict[int, set[str]]:
    """
    Stub for _preprocess_up_to yielding an empty group for every bound of the range.
    """
    return {bound: set() for bound in range(start, target + 1)}


def groups_with_fact(target: int, start: int) -> dict[int, set[str]]:
    """
    Stub for _preprocess_up_to yielding a (non-incremental) fact at the target bound of the range.
    """
    return empty_groups(target, start) | {target: {'set("root.bags","root.bags[1]").'}}


class TestMultiApplication(TestCase):
    """
    Test cases for multishot application class.
    """

    def assert_control_calls(self, control: Control, expected_calls: list[Any]) -> None:
        """
        Check that the calls to the mock control object match the expected calls.
        """
        self.assertEqual(
            len(cast(Mock, control).mock_calls),
            len(expected_calls),
            "number of calls to mock control does not match expected number of calls",
        )
        for i, (real, expected) in enumerate(zip(cast(Mock, control).mock_calls, expected_calls, strict=True)):
            self.assertEqual(real, expected, f"the {i}th call to mock control does not match the expected call")

    def test_multi_application_helper_function(self) -> None:
        """
        Test helper function used in multishot application class.
        """
        for fact, result in [
            (
                'set("root.totalVolume","root.totalVolume[0]").',
                ("set", (parse_term('"root.totalVolume"'), parse_term('"root.totalVolume[0]"'))),
            ),
            (
                'index("root.color[0]",0).',
                ("index", (parse_term('"root.color[0]"'), parse_term("0"))),
            ),
            ('allow(7,(1,0),"S").', ("allow", (parse_term("7"), parse_term("(1,0)"), parse_term('"S"')))),
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
            ('allow(7,(1,0),"S").', ("new_allow", (parse_term("7"), parse_term("(1,0)"), parse_term('"S"')))),
            ('number("5",5).', ("new_number", (parse_term('"5"'), parse_term("5")))),
            (
                'default("root.bags[1].color[0]","Red").',
                ("new_default", (parse_term('"root.bags[1].color[0]"'), parse_term('"Red"'))),
            ),
            # program parts that get the bound added to arguments
            (
                'type("root.bags[1]","Bags").',
                ("new_type", (parse_term('"root.bags[1]"'), parse_term('"Bags"'), parse_term("1"))),
            ),
            (
                'constraint(("root.color",1),"lowerbound").',
                ("new_constraint", (parse_term('("root.color",1)'), parse_term('"lowerbound"'), parse_term("1"))),
            ),
            (
                'column(("Size","root.bags[0].size[0]"),0,0,"root.bags[0].size[0]").',
                (
                    "new_column",
                    (
                        parse_term('("Size","root.bags[0].size[0]")'),
                        parse_term("0"),
                        parse_term("0"),
                        parse_term('"root.bags[0].size[0]"'),
                        parse_term("1"),
                    ),
                ),
            ),
        ]:
            self.assertEqual(app._get_prog_part(fact, 1), part, f"failed with fact={fact}, part={part}")

    def test_get_incremental_prog_part(self) -> None:
        """
        Test function for getting the program part of an incremental fact.
        """
        app = COOMMultiSolverApp([])

        name = parse_term('"name"')
        bound = 3
        bound_term = Number(3)
        boolean = (parse_term('(0,"name")'), String("boolean"))
        table = (parse_term('(1,"root")'), String("table"))

        # test unary, constraint and function
        for exp_type, args, part in [
            ("unary", (name,), ("incremental_unary", (name, bound_term))),
            ("constraint", boolean, ("incremental_boolean_constraint", boolean + (bound_term,))),
            # table constraints check the rows of the gap (bound-1, bound]
            ("constraint", table, ("incremental_table_constraint", table + (Number(2), bound_term))),
        ]:
            self.assertEqual(
                app._get_incremental_prog_part(exp_type, args, bound),
                part,
                f"failed with exp_type={exp_type}, args={args}, part={part}",
            )

        # functions compute the full aggregate the first time, afterwards they extend the last grounded bound
        for function_bound, part in [
            (0, ("incremental_function_full", (name, Number(0)))),
            (1, ("incremental_function_extend", (name, Number(0), Number(1)))),
            (2, ("incremental_function_extend", (name, Number(1), Number(2)))),
        ]:
            self.assertEqual(
                app._get_incremental_prog_part("function", (name,), function_bound),
                part,
                f"failed with function_bound={function_bound}, part={part}",
            )
        self.assertEqual(app._function_last_bound, {"name": 2})

        # test three cases for binary expression
        lhs_name = parse_term('"lhs"')
        op_name = parse_term('"op"')
        rhs_name = parse_term('"rhs"')
        binary_args = (name, lhs_name, op_name, rhs_name)
        part_args = binary_args + (bound_term,)
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
                app._get_incremental_prog_part("binary", binary_args, bound),
                (part_name, part_args),
                f"failed with inc_expressions={inc_expressions}, part_name={part_name}",
            )

        # test invalid incremental fact
        self.assertRaises(ValueError, app._get_incremental_prog_part, "number", [], 0)

    def test_update_bound(self) -> None:
        """
        Test the update bounds function of multi application class.
        """
        app = COOMMultiSolverApp([], algorithm="linear", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 5)]:
            fail_msg = f"failed with prev={prev}, current={current}"
            self.assertEqual(app._prev_bound, prev, fail_msg)
            self.assertEqual(app.current_max_bound, current, fail_msg)
            app._update_bound()

        app = COOMMultiSolverApp([], algorithm="exponential", initial_bound=3)

        for prev, current in [(None, 3), (3, 4), (4, 8)]:
            fail_msg = f"failed with prev={prev}, current={current}"
            self.assertEqual(app._prev_bound, prev, fail_msg)
            self.assertEqual(app.current_max_bound, current, fail_msg)
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
            "modules",
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
        inc_parts: set[tuple[str, tuple[Symbol, ...]]] = set()
        inc_parts = {
            (
                "function",
                (String("count(root.bags.pockets)"), String("count"), String("root.bags.pockets")),
            ),
        }
        inc_expressions = {"5<count(root.bags.pockets)"}

        # initialize attributes
        app._incremental_parts = inc_parts.copy()
        app._incremental_expressions = inc_expressions.copy()

        # incremental facts for updating incremental data
        incremental_facts = {
            'inc_set("root.bags.size.volume").',
            'inc_set("root.bags.pockets").',
            (
                'incremental("function","sum(root.bags.size.volume)",'
                '("sum(root.bags.size.volume)","sum","root.bags.size.volume")).'
            ),
            (
                'incremental("binary","5<count(root.bags.pockets)",'
                '("5<count(root.bags.pockets)","5","<","count(root.bags.pockets)")).'
            ),
            'incremental("constraint","5<count(root.bags.pockets)",((4,"5<count(root.bags.pockets)"),"boolean")).',
        }

        app._update_incremental_data(incremental_facts)

        # add everything to the expected results
        inc_parts.add(
            (
                "constraint",
                (parse_term('(4,"5<count(root.bags.pockets)")'), String("boolean")),
            )
        )
        inc_parts.add(
            (
                "binary",
                (String("5<count(root.bags.pockets)"), String("5"), String("<"), String("count(root.bags.pockets)")),
            )
        )
        inc_parts.add(
            (
                "function",
                (String("sum(root.bags.size.volume)"), String("sum"), String("root.bags.size.volume")),
            )
        )
        inc_expressions.add("sum(root.bags.size.volume)")

        # test value of _incremental_set dictionary
        self.assertEqual(app._incremental_parts, inc_parts)
        # test value of _incremental_expressions set
        self.assertEqual(app._incremental_expressions, inc_expressions)

    def _get_mock_control(self, solve_is_sat: list[bool]) -> Control:
        """
        Create a mock control object with a list of return values of solve.

        Args:
            solve_is_sat (list[bool]): list of returns values for solve calls (True/False for SAT/UNSAT)
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
        def assign(name: str, bound: int, value: bool) -> Any:  # noqa: ANN401
            return call.assign_external(Function(name, [Number(bound)], True), value)

        def release(name: str, bound: int) -> Any:  # noqa: ANN401
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
            app.current_max_bound = max_init
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
            self.assertEqual(app.current_max_bound, max_return, fail_msg)

            # check what calls were made to the control object
            self.assertEqual(cast(Mock, control).mock_calls, calls, fail_msg)

    def test_init_fix_externals(self) -> None:
        """
        Test initialization of the attributes for fixing externals.
        """
        # fixing externals is opt in
        app = COOMMultiSolverApp([])
        self.assertFalse(app._fix_externals)

        app = COOMMultiSolverApp([], fix_externals=True)
        self.assertTrue(app._fix_externals)
        # initially no bound is fixed
        self.assertEqual(app._fixed_active_bound, -1)

    def test_fix_active(self) -> None:
        """
        Test fixing the active externals.
        """

        def ground_fix(lower: int, upper: int) -> Any:  # noqa: ANN401
            return call.ground([("fix_active", [Number(lower), Number(upper)])])

        # without the option nothing is fixed
        app = COOMMultiSolverApp([])
        control = self._get_mock_control([])
        app._fix_active(control, 6)
        self.assertEqual(cast(Mock, control).mock_calls, [])
        self.assertEqual(app._fixed_active_bound, -1)

        # with the option all bounds up to the given bound are fixed
        app = COOMMultiSolverApp([], fix_externals=True)
        control = self._get_mock_control([])
        app._fix_active(control, 6)
        self.assertEqual(cast(Mock, control).mock_calls, [ground_fix(0, 6)])
        self.assertEqual(app._fixed_active_bound, 6)

        # bounds that are already fixed are not fixed again
        app._fix_active(control, 6)
        self.assertEqual(cast(Mock, control).mock_calls, [ground_fix(0, 6)])
        self.assertEqual(app._fixed_active_bound, 6)

        # a higher bound only fixes the bounds that are not fixed yet
        app._fix_active(control, 8)
        self.assertEqual(cast(Mock, control).mock_calls, [ground_fix(0, 6), ground_fix(7, 8)])
        self.assertEqual(app._fixed_active_bound, 8)

    def test_release_active(self) -> None:
        """
        Test releasing the active externals.
        """

        def release(bound: int) -> Any:  # noqa: ANN401
            return call.release_external(Function("active", [Number(bound)], True))

        # without the option nothing is released
        app = COOMMultiSolverApp([])
        control = self._get_mock_control([])
        app._release_active(control, 6, 8)
        self.assertEqual(cast(Mock, control).mock_calls, [])

        # with the option all bounds in the range are released
        app = COOMMultiSolverApp([], fix_externals=True)
        control = self._get_mock_control([])
        app._release_active(control, 6, 8)
        self.assertEqual(cast(Mock, control).mock_calls, [release(6), release(7), release(8)])

    def test_find_minimal_bound_fix_externals(self) -> None:
        """
        Test computing the minimal bound with fixing of externals.
        """

        def assign(name: str, bound: int, value: bool) -> Any:  # noqa: ANN401
            return call.assign_external(Function(name, [Number(bound)], True), value)

        def release(name: str, bound: int) -> Any:  # noqa: ANN401
            return call.release_external(Function(name, [Number(bound)], True))

        # externals are only fixed before another solve call (changing the program after the last one resets its result)
        # solving with bound 6 (unsatisfiable) and then with bound 7 (satisfiable)
        unsat_sat = [
            # solve with bound 6
            assign("active", 7, False),
            assign("active", 8, False),
            release("max_bound", 8),
            assign("max_bound", 6, True),
            call.solve(),
            # unsatisfiable: all bounds up to 6 stay active (bounds up to 4 are already fixed)
            call.ground([("fix_active", [Number(5), Number(6)])]),
            # solve with bound 7
            assign("active", 7, True),
            release("max_bound", 6),
            assign("max_bound", 7, True),
            call.solve(),
            # satisfiable: bound 8 is not released as there is no further solve call
        ]
        # solving with bound 6 (satisfiable) and then with bound 5 (unsatisfiable)
        sat_unsat = [
            # solve with bound 6
            assign("active", 7, False),
            assign("active", 8, False),
            release("max_bound", 8),
            assign("max_bound", 6, True),
            call.solve(),
            # satisfiable: bounds 7 and 8 are never active again
            release("active", 7),
            release("active", 8),
            # solve with bound 5
            assign("active", 6, False),
            release("max_bound", 6),
            assign("max_bound", 5, True),
            call.solve(),
            # unsatisfiable: bound 5 is not fixed as there is no further solve call
        ]

        for sat_values, expected_calls, max_return in [
            ([False, True], unsat_sat, 7),
            ([True, False], sat_unsat, 6),
        ]:
            app = COOMMultiSolverApp([], fix_externals=True)
            app._prev_bound = 4
            app.current_max_bound = 8
            # the active externals up to the unsatisfiable bound 4 were fixed before converging
            app._fixed_active_bound = 4
            control = self._get_mock_control(sat_values)

            with redirect_stdout(None):
                app._find_minimal_bound(control)

            fail_msg = f"failed with sat_values={sat_values}"
            self.assertEqual(app.current_max_bound, max_return, fail_msg)
            self.assertEqual(cast(Mock, control).mock_calls, expected_calls, fail_msg)

    def test_preprocess_bound(self) -> None:
        """
        Test preprocessing for a single bound (grounding stepwise preprocesses every bound).
        """
        non_incremental = {'domain("Color","Green").', 'domain("Color","Red").'}
        incremental = {'inc_set("root.bags.pockets").'}

        with patch("coomsuite.bounds.multi_application.preprocess", autospec=True) as mock_preprocess:
            mock_preprocess.side_effect = [list(non_incremental | incremental)]
            app = COOMMultiSolverApp([])
            # facts that were already processed for smaller bounds
            app._processed_facts = {'domain("Color","Green").'}
            with patch.object(app, "_update_incremental_data", autospec=True) as mock_update:
                new_facts = app._preprocess_bound(2)

        # the bounds of the objects are only computed when grounding in jumps
        self.assertEqual(mock_preprocess.call_args, call([], max_bound=2, discrete=True, multishot=True))
        self.assertEqual(mock_update.call_args, call(incremental))
        # only the facts that were not processed before are returned
        self.assertEqual(new_facts, {'domain("Color","Red").'})
        self.assertEqual(app._processed_facts, non_incremental)

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
            patch.object(app, "_get_prog_part", autospec=True) as mock_get_part,
        ):
            # mock value of _incremental_parts
            app._incremental_parts = {("unary", ())}
            # mocked return value of _remove_new_incremental_expressions
            mock_remove.side_effect = [[]]

            # mocked return value of _get_prog_part
            non_inc_parts = [
                ("new_set", (String('"root.color"'), String('"root.color[0]"'))),
                ("new_set", (String('"root.bags"'), String('"root.bags[1]"'))),
            ]
            mock_get_part.side_effect = non_inc_parts.copy()

            # mocked return value of _get_prog_part_of_incremental_set
            inc_parts = [("incremental_unary", (Number(1),))]

            # initial value of _new_processed_facts
            new_facts = [
                'set("root.bags","root.bags[1]").',
                'set("root.color","root.color[0]").',
            ]
            app._new_processed_facts = set(new_facts)

            # compute all program parts for bound 1
            parts = app._compute_prog_parts(1)

            # check if the correct parts are returned
            self.assertEqual(
                parts, non_inc_parts + inc_parts, f"parts is {parts}, expected {non_inc_parts + inc_parts}"
            )
            # check calls to _get_prog_part
            self.assertCountEqual(mock_get_part.call_args_list, [call(x, 1) for x in new_facts])

    def test_main_control_calls(self) -> None:
        """
        Test calls to the control object in multi application main function.
        """
        app = COOMMultiSolverApp([], initial_bound=2)

        control = self._get_mock_control([False, True])

        with (
            redirect_stdout(None),
            patch.object(app, "_preprocess_bound", autospec=True, return_value=set()),
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
                call.release_external(Function("max_bound", [Number(2)], True)),
                call.assign_external(Function("max_bound", [Number(3)], True), True),
                call.solve(),
            ]

            self.assert_control_calls(control, expected_calls)

    def test_main_control_calls_fix_externals(self) -> None:
        """
        Test calls to the control object in the main function with fixing of externals.
        """
        app = COOMMultiSolverApp([], initial_bound=2, fix_externals=True)

        control = self._get_mock_control([False, True])

        with (
            redirect_stdout(None),
            patch.object(app, "_preprocess_bound", autospec=True, return_value=set()),
            patch.object(app, "_compute_prog_parts", autospec=True),
            patch.object(app, "_find_minimal_bound", autospec=True),
        ):
            app.main(control, [])

            expected_calls = [
                call.load(ANY),
                call.load(ANY),
                call.add("base", [], ANY),
                call.ground([("base", [])]),
                # ground each bound in 0..2 and set the active external
                call.ground(ANY),
                call.assign_external(Function("active", [Number(0)], True), True),
                call.ground(ANY),
                call.assign_external(Function("active", [Number(1)], True), True),
                call.ground(ANY),
                call.assign_external(Function("active", [Number(2)], True), True),
                call.assign_external(Function("max_bound", [Number(2)], True), True),
                call.solve(),
                # unsatisfiable: all bounds up to 2 stay active
                call.ground([("fix_active", [Number(0), Number(2)])]),
                # grounding and assigning active for next bound
                call.ground(ANY),
                call.assign_external(Function("active", [Number(3)], True), True),
                call.release_external(Function("max_bound", [Number(2)], True)),
                call.assign_external(Function("max_bound", [Number(3)], True), True),
                call.solve(),
            ]

            self.assert_control_calls(control, expected_calls)


class TestMultiJumpApplication(TestMultiApplication, TestCase):
    """
    Test cases for multishot jump application class.
    """

    def test_jump_bound_of_fact(self) -> None:
        """
        Test determining the bound a fact becomes available at.
        """
        app = COOMMultiSolverAppJump([])
        app._object_bounds = {"root": 0, "root.bags[0]": 1, "root.bags[1]": 2, "root.bags[1].pockets[2]": 3}

        # a fact without any object path, and a fact referring to a single object
        self.assertEqual(app._bound_of_fact('domain("Color","Red").'), 0)
        self.assertEqual(app._bound_of_fact('type("root.bags[1]","Bag").'), 2)
        # a fact referring to several objects takes the maximum
        self.assertEqual(app._bound_of_fact('parent("root.bags[1].pockets[2]","root.bags[1]").'), 3)
        # a set path is covered by the object it starts at
        self.assertEqual(app._bound_of_fact('constraint(("root.bags[1].pockets",0),"lowerbound").'), 2)
        # an unknown object path raises an error (every object has a bound)
        self.assertRaises(KeyError, app._bound_of_fact, 'type("root.frame[9]","Frame").')

    def test_jump_preprocess_up_to(self) -> None:
        """
        Test preprocessing for a jump range and grouping of the new facts by bound.
        """
        # new facts added by preprocessing (mocked below)
        obj_bound = {'obj_bound("root",0).', 'obj_bound("root.bags[0]",1).', 'obj_bound("root.bags[1]",2).'}
        non_incremental = {
            'domain("Color","Green").',  # already processed, hence not part of any group
            'domain("Color","Red").',  # no object path, hence bound 0 (clamped to the start of the range)
            'type("root.bags[0]","Bag").',
            'type("root.bags[1]","Bag").',
            'constraint(("root.bags[1].pockets",0),"lowerbound").',
        }
        incremental = {'inc_set("root.bags.pockets").'}

        # mock preprocess function
        with patch("coomsuite.bounds.multi_jump.preprocess", autospec=True) as mock_preprocess:
            mock_preprocess.side_effect = [list(non_incremental | incremental | obj_bound)]

            app = COOMMultiSolverAppJump([])
            # facts that were already processed for smaller bounds
            app._processed_facts = {'domain("Color","Green").'}

            # mock update incremental data function
            with patch.object(app, "_update_incremental_data", autospec=True) as mock_update:
                groups = app._preprocess_up_to(2, 1)

        # preprocessing is done once, for the target bound
        self.assertEqual(
            mock_preprocess.call_args, call([], max_bound=2, discrete=True, multishot=True, object_bounds=True)
        )
        self.assertEqual(mock_update.call_args, call(incremental))
        # object bounds are collected separately and are not part of any group
        self.assertEqual(app._object_bounds, {"root": 0, "root.bags[0]": 1, "root.bags[1]": 2})
        # the new facts are grouped by bound (facts of bound 0 are clamped to the start of the range)
        self.assertEqual(
            groups,
            {
                1: {'domain("Color","Red").', 'type("root.bags[0]","Bag").'},
                2: {'type("root.bags[1]","Bag").', 'constraint(("root.bags[1].pockets",0),"lowerbound").'},
            },
        )
        # all new facts are marked as processed
        self.assertEqual(app._processed_facts, non_incremental)

    def test_jump_init(self) -> None:
        """
        Test initialization of the jump multishot application class.
        """
        # invalid function mode raises a ValueError
        self.assertRaises(ValueError, COOMMultiSolverAppJump, [], function_mode="invalid")

        # valid function mode is stored
        for mode in ("extend", "full"):
            app = COOMMultiSolverAppJump([], function_mode=mode)
            self.assertEqual(app._function_mode, mode)

    def test_jump_get_function_prog_part(self) -> None:
        """
        Test selecting the incremental function program part for the jump strategy.
        """
        args = (String("f"), String("count"), String("p"))

        # full mode always uses the self-contained full part, regardless of grounded bounds
        app = COOMMultiSolverAppJump([], function_mode="full")
        for bound in [3, 5]:
            self.assertEqual(
                app._get_function_prog_part(args, bound),
                ("incremental_function_full", args + (Number(bound),)),
            )

        # extend mode uses the full part the first time, afterwards it extends from the last grounded bound
        app = COOMMultiSolverAppJump([], function_mode="extend")
        self.assertEqual(
            app._get_function_prog_part(args, 3),
            ("incremental_function_full", args + (Number(3),)),
        )
        self.assertEqual(
            app._get_function_prog_part(args, 5),
            ("incremental_function_extend", args + (Number(3), Number(5))),
        )
        self.assertEqual(
            app._get_function_prog_part(args, 8),
            ("incremental_function_extend", args + (Number(5), Number(8))),
        )
        self.assertEqual(app._function_last_bound, {"f": 8})

    def test_jump_get_incremental_parts_at(self) -> None:
        """
        Test getting the incremental program parts at a bound for the jump strategy.
        """
        app = COOMMultiSolverAppJump([], function_mode="full")
        function = ("function", (String("f"), String("count"), String("p")))
        unary = ("unary", (String("u"),))
        boolean = ("constraint", (parse_term('(0,"f>=6")'), String("boolean")))
        table = ("constraint", (parse_term('(1,"root")'), String("table")))
        app._incremental_parts = {function, unary, boolean, table}

        # the parts are returned without grounding, only table constraints cover the whole jump range
        parts = app._get_incremental_parts_at(2, 3)
        self.assertCountEqual(
            parts,
            [
                ("incremental_function_full", function[1] + (Number(3),)),
                ("incremental_unary", unary[1] + (Number(3),)),
                ("incremental_boolean_constraint", boolean[1] + (Number(3),)),
                ("incremental_table_constraint", table[1] + (Number(1), Number(3))),
            ],
        )

    def test_jump_table_rows_between_targets(self) -> None:
        """
        Test that the table rows of all bounds of a jump are checked, not only those of the target bound.

        Only Green bags (w=1) are allowed and their sum has to be at least 6, so the minimal bound is 6.
        The jump targets are 0,1,2,4,8 (exponential) and 0,3,6 (linear with step 3), so rows are added at bounds
        strictly between two targets. If these rows are unchecked Red bags (w=2) lead to a too small bound.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_table.lp")]
        for algorithm, step in [("exponential", 1), ("linear", 3)]:
            for fix_externals in [False, True]:
                # the stepwise application (as reference) and the jump application with both function modes
                apps = [COOMMultiSolverApp(files, algorithm=algorithm, step=step, fix_externals=fix_externals)] + [
                    COOMMultiSolverAppJump(
                        files, algorithm=algorithm, step=step, function_mode=function_mode, fix_externals=fix_externals
                    )
                    for function_mode in ["extend", "full"]
                ]
                for app in apps:
                    with redirect_stdout(None):
                        app.main(Control(), [])

                    fail_msg = (
                        f"failed with {type(app).__name__}, algorithm={algorithm}, step={step}, "
                        f"fix_externals={fix_externals}"
                    )
                    self.assertEqual(app.current_max_bound, 6, fail_msg)

    def test_jump_number_at_later_bound(self) -> None:
        """
        Test that numbers added at a later bound get a value.

        Every bag has weight 3 (a local constraint) and their sum has to be at least 9, so the minimal bound is 3.
        The number 1 of the local constraints (count(bags[i])=1) is only added at bound 1.
        Without its value the local constraints are never enforced, leading to a too small bound.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_local_number.lp")]
        for algorithm in ["linear", "exponential"]:
            # the stepwise application and the jump application with both function modes
            apps = [COOMMultiSolverApp(files, algorithm=algorithm)] + [
                COOMMultiSolverAppJump(files, algorithm=algorithm, function_mode=function_mode)
                for function_mode in ["extend", "full"]
            ]
            for app in apps:
                with redirect_stdout(None):
                    app.main(Control(), [])

                fail_msg = f"failed with {type(app).__name__}, algorithm={algorithm}"
                self.assertEqual(app.current_max_bound, 3, fail_msg)

    def test_jump_default_at_later_bound(self) -> None:
        """
        Test that defaults of objects added at a later bound are applied.

        Every bag is Green (w=1) by default and their sum has to be at least 6, so the minimal bound is 6.
        The defaults of the bags are only added at later bounds, without them Red bags (w=2) lead to a too small bound.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_default.lp")]
        for algorithm in ["linear", "exponential"]:
            # the stepwise application and the jump application with both function modes
            apps = [COOMMultiSolverApp(files, algorithm=algorithm)] + [
                COOMMultiSolverAppJump(files, algorithm=algorithm, function_mode=function_mode)
                for function_mode in ["extend", "full"]
            ]
            for app in apps:
                with redirect_stdout(None):
                    app.main(Control(), [])

                fail_msg = f"failed with {type(app).__name__}, algorithm={algorithm}"
                self.assertEqual(app.current_max_bound, 6, fail_msg)

    def test_jump_user_input(self) -> None:
        """
        Test user input for objects of an unbounded feature.

        The user includes bags[1] and sets the weight of bags[3] (which does not exist for small bounds).
        The sum of the weights has to be at least 12, so the minimal bound is 1 (bags[0] and bags[1]).
        The user input (and bags[1]) belong to bound 0 independent of the bounds of the objects,
        with an initial bound of 2 they are part of the first jump.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_user_input.lp")]
        for algorithm in ["linear", "exponential"]:
            for initial_bound in [0, 2]:
                # the stepwise application and the jump application with both function modes
                apps = [COOMMultiSolverApp(files, algorithm=algorithm, initial_bound=initial_bound)] + [
                    COOMMultiSolverAppJump(
                        files, algorithm=algorithm, initial_bound=initial_bound, function_mode=function_mode
                    )
                    for function_mode in ["extend", "full"]
                ]
                for app in apps:
                    with redirect_stdout(None):
                        app.main(Control(), [])

                    fail_msg = f"failed with {type(app).__name__}, algorithm={algorithm}, initial_bound={initial_bound}"
                    self.assertEqual(app.current_max_bound, 1, fail_msg)

    def test_jump_user_value_at_later_bound(self) -> None:
        """
        Test that user values of objects added at a later bound are applied.

        The user sets the weight of bags[2] (only exists from bound 3 on) to 5,
        the sum of the weights has to be at least 26, so the minimal bound is 4 (10+10+5+10).
        Without the user value 3 bags with weight 10 lead to a too small bound.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_user_value.lp")]
        for algorithm in ["linear", "exponential"]:
            # the stepwise application and the jump application with both function modes
            apps = [COOMMultiSolverApp(files, algorithm=algorithm)] + [
                COOMMultiSolverAppJump(files, algorithm=algorithm, function_mode=function_mode)
                for function_mode in ["extend", "full"]
            ]
            for app in apps:
                with redirect_stdout(None):
                    app.main(Control(), [])

                fail_msg = f"failed with {type(app).__name__}, algorithm={algorithm}"
                self.assertEqual(app.current_max_bound, 4, fail_msg)

    def test_jump_user_include_order(self) -> None:
        """
        Test the order of objects for a user include of an object of an unbounded feature.

        The user includes bags[2] (instantiated at bound 0) and at least two boxes are required (minimal bound 2).
        When bags[1] is added at bound 2 it has to be included as well (as is bags[0]),
        i.e. there is only a single model at bound 2. The minimal bound is not affected,
        so the models of the final state (bound 2, the linear search does not need to converge) are checked.
        """
        files: list[str] = [join("examples", "tests", "multishot", "unbounded_user_include_order.lp")]
        # the stepwise application and the jump application with both function modes
        apps = [COOMMultiSolverApp(files)] + [
            COOMMultiSolverAppJump(files, function_mode=function_mode) for function_mode in ["extend", "full"]
        ]
        for app in apps:
            control = Control(["--models=0"])
            with redirect_stdout(None):
                app.main(control, [])

            models: list[list[str]] = []
            control.solve(on_model=lambda m: models.append(sorted(str(s) for s in m.symbols(shown=True))))

            fail_msg = f"failed with {type(app).__name__}"
            self.assertEqual(app.current_max_bound, 2, fail_msg)
            self.assertEqual(len(models), 1, fail_msg)
            for bag in range(3):
                self.assertIn(f'include("root.bags[{bag}]")', models[0], fail_msg)

    def test_jump_find_minimal_bound(self) -> None:
        """
        Test the convergence function of the jump multishot application class.
        """
        app = COOMMultiSolverAppJump([], function_mode="full")

        def assign(name: str, bound: int, value: bool) -> Any:  # noqa: ANN401
            return call.assign_external(Function(name, [Number(bound)], True), value)

        down_6 = [
            assign("active", 7, False),
            assign("active", 8, False),
            call.solve(),
        ]
        up_7 = [
            assign("active", 7, True),
            call.solve(),
        ]
        down_5 = [
            assign("active", 6, False),
            call.solve(),
        ]

        for prev_init, max_init, sat_values, calls, max_return in [
            (0, 1, [], [], 1),
            (4, 8, [False, True], down_6 + up_7, 7),
            (4, 8, [False, False], down_6 + up_7, 8),
            (4, 8, [True, True], down_6 + down_5, 5),
            (4, 8, [True, False], down_6 + down_5, 6),
        ]:
            app._prev_bound = prev_init
            app.current_max_bound = max_init
            control = self._get_mock_control(sat_values)

            with redirect_stdout(None):
                app._find_minimal_bound(control)

            fail_msg = (
                f"failed with prev_init={prev_init}, max_init={max_init}, "
                f"sat_values={sat_values}, max_return={max_return}"
            )
            self.assertEqual(app.current_max_bound, max_return, fail_msg)
            self.assertEqual(cast(Mock, control).mock_calls, calls, fail_msg)

    def test_jump_fix_max_bound(self) -> None:
        """
        Test fixing the max bound external during converge of the jump multishot application class.
        """

        def assign(name: str, bound: int, value: bool) -> Any:  # noqa: ANN401
            return call.assign_external(Function(name, [Number(bound)], True), value)

        def release(name: str, bound: int) -> Any:  # noqa: ANN401
            return call.release_external(Function(name, [Number(bound)], True))

        # solving with bound 6 (satisfiable) and then with bound 5 (unsatisfiable)
        sat_unsat = [
            # solve with bound 6 (max_bound stays at 8 for the jump strategy)
            assign("active", 7, False),
            assign("active", 8, False),
            # the max bound is fixed once, before the first solve of converge
            call.ground([("fix_max_bound", [Number(8)])]),
            call.solve(),
            # satisfiable: bounds 7 and 8 are never active again
            release("active", 7),
            release("active", 8),
            # solve with bound 5 (the max bound is not fixed again)
            assign("active", 6, False),
            call.solve(),
        ]

        for prev_init, max_init, sat_values, expected_calls, max_return in [
            # the minimal bound is already found: no solve call follows, so the max bound is not fixed
            (0, 1, [], [], 1),
            (4, 8, [True, False], sat_unsat, 6),
        ]:
            app = COOMMultiSolverAppJump([], function_mode="full", fix_externals=True)
            app._prev_bound = prev_init
            app.current_max_bound = max_init
            # the active externals up to the unsatisfiable bound were fixed before converging
            app._fixed_active_bound = prev_init
            control = self._get_mock_control(sat_values)

            with redirect_stdout(None):
                app._find_minimal_bound(control)

            fail_msg = f"failed with prev_init={prev_init}, max_init={max_init}, sat_values={sat_values}"
            self.assertEqual(app.current_max_bound, max_return, fail_msg)
            self.assertEqual(cast(Mock, control).mock_calls, expected_calls, fail_msg)

    def test_jump_main_control_calls(self) -> None:
        """
        Test calls to the control object in the jump multishot main function.
        """
        app = COOMMultiSolverAppJump([], initial_bound=2, function_mode="full")

        control = self._get_mock_control([False, True])

        def assign(name: str, bound: int, value: bool) -> Any:  # noqa: ANN401
            return call.assign_external(Function(name, [Number(bound)], True), value)

        def release(name: str, bound: int) -> Any:  # noqa: ANN401
            return call.release_external(Function(name, [Number(bound)], True))

        with (
            redirect_stdout(None),
            patch.object(app, "_preprocess_up_to", autospec=True, side_effect=groups_with_fact),
            patch.object(app, "_get_prog_part", autospec=True, return_value=("new_set", ())),
            patch.object(app, "_get_incremental_parts_at", autospec=True, return_value=[]),
            patch.object(app, "_find_minimal_bound", autospec=True),
        ):
            app.main(control, [])

            expected_calls = [
                call.load(ANY),
                call.load(ANY),
                # base program is grounded first (with the bound-0 facts)
                call.add("base", [], ANY),
                call.ground([("base", [])]),
                # the collected non-incremental parts are grounded in one batch per jump
                call.ground(ANY),
                # externals are assigned only after all grounding of the jump is done
                assign("active", 0, True),
                assign("active", 1, True),
                assign("active", 2, True),
                assign("max_bound", 2, True),
                call.solve(),
                # second jump (target bound 3)
                call.ground(ANY),
                assign("active", 3, True),
                release("max_bound", 2),
                assign("max_bound", 3, True),
                call.solve(),
            ]

            self.assert_control_calls(control, expected_calls)

    def test_jump_main_initial_bound_zero(self) -> None:
        """
        Test the jump main function when the initial bound is zero (single satisfiable jump).
        """
        app = COOMMultiSolverAppJump([], initial_bound=0, function_mode="full")

        control = self._get_mock_control([True])

        with (
            redirect_stdout(None),
            patch.object(app, "_preprocess_up_to", autospec=True, side_effect=empty_groups),
            patch.object(app, "_get_incremental_parts_at", autospec=True, return_value=[]),
            patch.object(app, "_find_minimal_bound", autospec=True) as mock_find,
        ):
            app.main(control, [])

            expected_calls = [
                call.load(ANY),
                call.load(ANY),
                call.add("base", [], ANY),
                call.ground([("base", [])]),
                call.ground(ANY),
                # no incremental grounding for the target (target == 0) and no previous max bound
                call.assign_external(Function("active", [Number(0)], True), True),
                call.assign_external(Function("max_bound", [Number(0)], True), True),
                call.solve(),
            ]
            self.assertEqual(cast(Mock, control).mock_calls, expected_calls)
            mock_find.assert_called_once()
