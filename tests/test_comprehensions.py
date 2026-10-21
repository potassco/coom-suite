"""Parsing and single-shot evaluation of function comprehensions."""

from pathlib import Path
from tempfile import TemporaryDirectory
from unittest import TestCase

from clingo import Symbol

from coomsuite.preprocess import preprocess

from . import parse_coom, run_test
from .clintests import TEST_UNSAT, StableModels


class TestFunctionComprehensions(TestCase):
    """Exercise comprehensions from COOM input through both solvers."""

    def test_parser(self) -> None:
        """Preserve function, binding, and decomposed filter facts."""
        self.assertEqual(
            parse_coom("behavior Bag { require sum(x.weight for x in bags if x.weight > 2) = 3 }"),
            [
                "behavior(0).",
                'context(0,"Bag").',
                'require(0,"sum(x.weightforxinbagsifx.weight>2)=3").',
                'binary("sum(x.weightforxinbagsifx.weight>2)=3","sum(x.weightforxinbagsifx.weight>2)","=","3").',
                'function("Bag","sum(x.weightforxinbagsifx.weight>2)","sum","x.weight").',
                'function_binding("sum(x.weightforxinbagsifx.weight>2)","x","bags").',
                'function_condition("sum(x.weightforxinbagsifx.weight>2)","x.weight>2").',
                'path("x.weight",0,"x").',
                'path("x.weight",1,"weight").',
                'binary("x.weight>2","x.weight",">","2").',
                'path("x.weight",0,"x").',
                'path("x.weight",1,"weight").',
                'number("2",2).',
                'path("bags",0,"bags").',
                'number("3",3).',
            ],
        )

    def test_parser_without_filter(self) -> None:
        """Treat an uppercase loop variable as a path rather than a constant."""
        facts = parse_coom("behavior { require count(X for X in bags) = 2 }")
        self.assertIn('function_binding("count(XforXinbags)","X","bags").', facts)
        self.assertIn('path("X",0,"X").', facts)
        self.assertFalse(any(f.startswith("function_condition(") for f in facts))
        self.assertNotIn('constant("X").', facts)

    def test_nonaggregate_comprehension(self) -> None:
        """Reject comprehensions on scalar functions explicitly."""
        with self.assertRaisesRegex(ValueError, "only supported for aggregate"):
            parse_coom("behavior { require sqrt(x for x in bags) = 2 }")

    def test_nested_aggregates_rejected(self) -> None:
        """Reject aggregate nesting, including through scalar calls or in filters."""
        for expression in (
            "sum(sum(y.weight for y in bags) for x in bags)",
            "sum(sum(x.weight) for x in bags)",
            "sum(x.weight for x in bags if count(bags) > 1)",
            "sum(sqrt(count(bags)))",
            "sum((1 + max(bags.weight)))",
        ):
            with self.subTest(expression=expression):
                with self.assertRaisesRegex(ValueError, "Nested aggregate function calls are not supported"):
                    parse_coom(f"behavior {{ require {expression} = 2 }}")
        for outer in ("sum", "count", "min", "max"):
            for inner in ("sum", "count", "min", "max"):
                with self.subTest(outer=outer, inner=inner):
                    with self.assertRaisesRegex(ValueError, "Nested aggregate function calls are not supported"):
                        parse_coom(f"behavior {{ require {outer}({inner}(bags.weight)) = 2 }}")

    def test_nested_scalar_functions_allowed(self) -> None:
        """Allow scalar nesting, including scalar calls around and inside aggregates."""
        cases = (
            ("sqrt(sqrt(weight))", 'unary("sqrt(sqrt(weight))","sqrt","sqrt(weight)").'),
            ("sqrt(sum(bags.weight))", 'unary("sqrt(sum(bags.weight))","sqrt","sum(bags.weight)").'),
            (
                "sum(sqrt(x.weight) for x in bags)",
                'unary("sqrt(x.weight)","sqrt","x.weight").',
            ),
            (
                "sum(x.weight for x in bags if sqrt(x.weight) > 1)",
                'unary("sqrt(x.weight)","sqrt","x.weight").',
            ),
            (
                "sqrt(sum(x.weight for x in bags))",
                'function_binding("sum(x.weightforxinbags)","x","bags").',
            ),
        )
        for expression, expected in cases:
            with self.subTest(expression=expression):
                facts = parse_coom(f"behavior {{ require {expression} = 2 }}")
                self.assertIn(expected, facts)

    def test_sibling_functions_allowed(self) -> None:
        """Separate function calls in one expression are not nested."""
        facts = parse_coom("behavior { require sum(x.weight for x in bags) + count(bags) = 2 }")
        self.assertIn('function("product","sum(x.weightforxinbags)","sum","x.weight").', facts)
        self.assertIn('function("product","count(bags)","count","bags").', facts)

    def _preprocess(self, expression: str, multishot: bool = False) -> list[str]:
        source = f"""
            product {{ 2 Bag bags }}
            structure Bag {{ num 1-3 weight }}
            behavior {{ require {expression} }}
        """
        user_input = """
            coom_user_value("root.bags[0].weight[0]",1).
            coom_user_value("root.bags[1].weight[0]",3).
        """
        return self._preprocess_source(source, user_input, multishot)

    def _preprocess_source(self, source: str, user_input: str = "", multishot: bool = False) -> list[str]:
        serialized = "\n".join("coom_" + fact for fact in parse_coom(source)) + user_input
        with TemporaryDirectory() as directory:
            path = Path(directory) / "model.lp"
            path.write_text(serialized, encoding="utf-8")
            return preprocess([str(path)], discrete=True, multishot=multishot)

    def test_aggregates(self) -> None:
        """Evaluate filtered projections with both solvers."""
        expected = StableModels(
            {
                'include("root.bags[0]")',
                'include("root.bags[1]")',
                'value("root.bags[0].weight[0]",1)',
                'value("root.bags[1].weight[0]",3)',
            }
        )
        expressions = [
            "count(x for x in bags) = 2",
            "sum(x.weight for x in bags) = 4",
            "min(x.weight for x in bags) = 1",
            "max(x.weight for x in bags) = 3",
            "count(x for x in bags if x.weight > 1) = 1",
            "sum(x.weight for x in bags if x.weight > 1) = 3",
            "min(x.weight for x in bags if x.weight > 1) = 3",
            "max(x.weight for x in bags if x.weight < 3) = 1",
            "sum(x.weight + 2 for x in bags if !(x.weight < 3)) = 5",
            "sum(2 for x in bags) = 4",
            "sum(x.weight for x in bags if x.weight > 3) = 0",
            "count(x for x in bags if x.weight > 3) = 0",
            "sum(X.weight for X in bags) = 4",
            "sum(x.weight for x in root.bags if x.weight > 1 && x.weight < 4) = 3",
            "sum(x.weight for x in bags) + count(bags) = 6",
            "sum(x.weight for x in bags) + sum(x.weight for x in bags if x.weight > 1) = 7",
        ]
        for expression in expressions:
            facts = self._preprocess(expression)
            for solver in ("clingo", "flingo"):
                with self.subTest(expression=expression, solver=solver):
                    run_test(expected, program="\n".join(facts), solver=solver, ctl_args=["0"])

    def test_scalar_nesting_preprocessed(self) -> None:
        """Instantiate scalar calls in projections, filters, and around aggregates."""
        for expression in (
            "sum(sqrt(x.weight) for x in bags) = 2",
            "sum(x.weight for x in bags if sqrt(x.weight) > 1) = 3",
            "sqrt(sum(x.weight for x in bags)) = 2",
        ):
            with self.subTest(expression=expression):
                facts = self._preprocess(expression)
                self.assertTrue(any(f.startswith("constraint(") and '"boolean"' in f for f in facts))
                self.assertTrue(any(f.startswith("unary(") and ',"sqrt",' in f for f in facts))
                self.assertTrue(any(f.startswith("aggregate_member(") for f in facts))

    def test_wrong_results_rejected(self) -> None:
        """Ensure aggregate requirements are enforced rather than dropped."""
        for expression in (
            "sum(x.weight for x in bags) = 5",
            "count(x for x in bags if x.weight > 1) = 2",
            "sum(2 for x in bags) = 2",
            "sum(x.weight for x in bags if x.weight > 3) = 1",
        ):
            facts = self._preprocess(expression)
            for solver in ("clingo", "flingo"):
                with self.subTest(expression=expression, solver=solver):
                    run_test(TEST_UNSAT, program="\n".join(facts), solver=solver, ctl_args=["0"])

    def test_filters_select_values_at_solve_time(self) -> None:
        """Check filters against values chosen by the solver."""
        facts = self._preprocess_source(
            """
            product { 2 Bag bags }
            structure Bag { num 1-3 weight }
            behavior { require count(x for x in bags if x.weight > 1) = 2 }
            """
        )
        models: list[set[Symbol | str]] = [
            {
                'include("root.bags[0]")',
                'include("root.bags[1]")',
                f'value("root.bags[0].weight[0]",{left})',
                f'value("root.bags[1].weight[0]",{right})',
            }
            for left in (2, 3)
            for right in (2, 3)
        ]
        expected = StableModels(*models)
        for solver in ("clingo", "flingo"):
            with self.subTest(solver=solver):
                run_test(expected, program="\n".join(facts), solver=solver, ctl_args=["0"])

    def test_optional_members(self) -> None:
        """Do not count members that exist only in the potential instance tree."""
        facts = self._preprocess_source(
            """
            product { 0..2 Bag bags }
            structure Bag { num 1-1 weight }
            behavior { require count(x for x in bags) = 0 }
            """
        )
        for solver in ("clingo", "flingo"):
            with self.subTest(solver=solver):
                run_test(StableModels(set()), program="\n".join(facts), solver=solver, ctl_args=["0"])

    def test_local_context_and_outer_paths(self) -> None:
        """Resolve unbound paths in the surrounding structure context."""
        facts = self._preprocess_source(
            """
            product { Box box }
            structure Box {
                2 Bag bags
                num 1-1 limit
            }
            structure Bag { num 1-1 weight }
            behavior Box { require sum(x.weight for x in bags if x.weight >= limit) = 2 }
            """
        )
        expected = StableModels(
            {
                'include("root.box[0]")',
                'include("root.box[0].bags[0]")',
                'include("root.box[0].bags[1]")',
                'value("root.box[0].limit[0]",1)',
                'value("root.box[0].bags[0].weight[0]",1)',
                'value("root.box[0].bags[1].weight[0]",1)',
            }
        )
        for solver in ("clingo", "flingo"):
            with self.subTest(solver=solver):
                run_test(expected, program="\n".join(facts), solver=solver, ctl_args=["0"])

    def test_multishot_rejected(self) -> None:
        """Do not silently evaluate comprehensions without incremental support."""
        with self.assertRaisesRegex(ValueError, "not supported by multi-shot"):
            self._preprocess("sum(x.weight for x in bags) = 4", multishot=True)
