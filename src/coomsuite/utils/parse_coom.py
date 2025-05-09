"""
The COOM parser.

Traverses the abstract syntax tree of the COOM input
in a visitor style fashion and outputs ASP facts.
"""

# flake8: noqa
# pylint: skip-file
# mypy: ignore-errors
from typing import List, Optional

from .coom_grammar.model.ModelParser import ModelParser
from .coom_grammar.model.ModelVisitor import ModelVisitor
from .coom_grammar.user.UserInputParser import UserInputParser
from .coom_grammar.user.UserInputVisitor import UserInputVisitor


class ASPUserInputVisitor(UserInputVisitor):
    """
    Custom visitor of the COOM Parser.
    Custom visitor of the COOM User Input Parser.
    Generates a list of ASP facts as strings.
    """

    def __init__(self) -> None:
        super().__init__()
        self.context: str = ""
        self.output_asp: List[str] = []

    def visitInput_block(self, ctx: UserInputParser.Input_blockContext):
        self.context = ctx.path().getText() + "."
        super().visitInput_block(ctx)
        self.context = ""

    def visitSet_value(self, ctx: UserInputParser.Set_valueContext):
        path = self.context + ctx.path().getText()
        value = ctx.formula_atom().getText()
        is_str = ctx.formula_atom().path() is not None
        if is_str:
            self.output_asp.append(f'user_value("root.{path}","{value}").')
        else:
            self.output_asp.append(f'user_value("root.{path}",{value}).')
        super().visitSet_value(ctx)

    def visitAdd_instance(self, ctx: UserInputParser.Add_instanceContext):
        path = self.context + ctx.path().getText()
        self.output_asp.append(f'user_include("root.{path}").')
        super().visitAdd_instance(ctx)


class ASPModelVisitor(ModelVisitor):
    """
    Custom visitor of the COOM Parser.
    Generates a list of ASP facts as strings.
    """

    def __init__(self) -> None:
        super().__init__()
        self.parent_enum: Optional[ModelParser.EnumerationContext] = None
        self.root_name: str = "product"
        self.structure_name: str = self.root_name
        self.context: str = self.root_name
        self.constraint_idx: int = 0
        self.row_idx: int = 0
        self.print_path: bool = True
        self.output_asp: List[str] = []

    def visitProduct(self, ctx: ModelParser.ProductContext):
        self.output_asp.append(f'structure("{self.root_name}").')
        super().visitProduct(ctx)

    def visitStructure(self, ctx: ModelParser.StructureContext):
        self.structure_name = ctx.name().getText()
        self.output_asp.append("")
        self.output_asp.append(f'structure("{self.structure_name}").')
        super().visitStructure(ctx)
        self.structure_name = self.root_name

    def visitEnumeration(self, ctx: ModelParser.EnumerationContext):
        self.parent_enum = ctx
        self.output_asp.append("")
        self.output_asp.append(f'enumeration("{ctx.name().getText()}").')
        super().visitEnumeration(ctx)
        self.parent_enum = None

    def visitBehavior(self, ctx: ModelParser.BehaviorContext):
        if ctx.name() is not None:
            self.context = ctx.name().getText()
        super().visitBehavior(ctx)
        self.context = self.root_name

    def visitFeature(self, ctx: ModelParser.FeatureContext):
        field: ModelParser.FieldContext = ctx.field()
        feature_name = field.fieldName.getText()

        if field.number_def() is not None:
            type_name = "num"
        elif field.string_def() is not None:
            return  # ignore string features
        elif field.type_ref is not None:
            type_name = field.type_ref.NAME()
        # else:
        #     type_name = feature_name

        cardinality: ModelParser.CardinalityContext = ctx.cardinality()
        c_min = 1
        c_max = 1
        if cardinality is not None:
            c_min = cardinality.min.text.replace("x", "")
            c_max = c_min
            if cardinality.max is not None:
                c_max = cardinality.max.text.replace("x", "").replace("*", "#sup")

        self.output_asp.append(f'feature("{self.structure_name}","{feature_name}","{type_name}",{c_min},{c_max}).')
        if type_name == "num":
            num: ModelParser.Number_defContext = field.number_def()
            if num.min is not None or num.max is not None:
                r_min = "#inf" if num.min.getText() == "-\u221e" else num.min.getText()  # negative infinity symbol
                r_max = "#sup" if num.max.getText() == "\u221e" else num.max.getText()  # infinity symbol
                self.output_asp.append(f'range("{self.structure_name}","{feature_name}",{r_min},{r_max}).')

    def visitAttribute(self, ctx: ModelParser.AttributeContext):
        # if self.parent_enum is None:
        #     raise ValueError("illegal option")
        parent_name = self.parent_enum.name().getText()
        field: ModelParser.FieldContext = ctx.field()
        if field.number_def() is not None:
            field_type = "num"
        else:
            field_type = "str"
        field_name = field.fieldName.getText()
        self.output_asp.append(f'attribute("{parent_name}","{field_name}","{field_type}").')
        super().visitAttribute(ctx)

    def visitOption(self, ctx: ModelParser.OptionContext):
        # if self.parent_enum is None:
        #     raise ValueError("illegal option")
        parent_name = self.parent_enum.name().getText()
        option_name = ctx.name().getText()
        self.output_asp.append(f'option("{parent_name}", "{option_name}").')

        constant: ModelParser.ConstantContext = ctx.constant()
        if constant != []:
            parent_attr: ModelParser.AttributeContext = self.parent_enum.attribute()
            for a, c in zip(parent_attr, constant):
                field: ModelParser.FieldContext = a.field()
                attr_name = field.fieldName.getText()
                if c.floating() is not None:
                    option_value = c.floating().getText()
                elif c.name() is not None:
                    option_value = f'"{c.name().getText()}"'
                self.output_asp.append(
                    f'attribute_value("{parent_name}","{option_name}","{attr_name}",{option_value}).'
                )

    def visitConditioned(self, ctx: ModelParser.ConditionedContext):
        if ctx.interaction() is None:
            self.output_asp.append("")
            self.output_asp.append(f"behavior({self.constraint_idx}).")
            self.output_asp.append(f'context({self.constraint_idx},"{self.context}").')
            super().visitConditioned(ctx)
            self.constraint_idx += 1

    def visitExplanation(self, ctx: ModelParser.ExplanationContext):
        self.output_asp.append(f"explanation({self.constraint_idx},{ctx.name().getText()}).")
        return super().visitExplanation(ctx)

    def visitAssign_default(self, ctx: ModelParser.Assign_defaultContext):
        path = ctx.path().getText()
        formula = ctx.formula().getText()
        self.output_asp.append(f'default({self.constraint_idx},"{path}","{formula}").')
        super().visitAssign_default(ctx)

    def visitAssign_imply(self, ctx: ModelParser.Assign_implyContext):
        path = ctx.path().getText()
        formula = ctx.formula().getText()
        self.output_asp.append(f'imply({self.constraint_idx},"{path}","{formula}").')
        super().visitAssign_imply(ctx)

    def visitCombinations(self, ctx: ModelParser.CombinationsContext):
        for i, f in enumerate(ctx.formula()):
            self.output_asp.append(f'combinations({self.constraint_idx},{i},"{f.getText()}").')
        super().visitCombinations(ctx)
        self.row_idx = 0

    def visitCombination_row(self, ctx: ModelParser.Combination_rowContext):
        row_type = ctx.rowType.text
        for col_idx, item in enumerate(ctx.combination_item()):
            values = item.getText()
            # Removing brackets around the values. Is this safe?
            if "," in values:
                values = values[1:-1]
            for v in values.split(","):
                if v == "-*-":  # Wildcard operator for combinations table
                    continue
                self.output_asp.append(f'{row_type}({self.constraint_idx},({col_idx},{self.row_idx}),"{v}").')
        self.print_path = False
        super().visitCombination_row(ctx)
        self.print_path = True
        self.row_idx += 1

    def visitPrecondition(self, ctx: ModelParser.PreconditionContext):
        condition = f'"{ctx.condition().getText()}"'
        self.output_asp.append(f"condition({self.constraint_idx},{condition}).")
        super().visitPrecondition(ctx)

    def visitRequire(self, ctx: ModelParser.RequireContext):
        condition = f'"{ctx.condition().getText()}"'
        self.output_asp.append(f"require({self.constraint_idx},{condition}).")
        super().visitRequire(ctx)

    def visitCondition_or(self, ctx: ModelParser.Condition_orContext):
        cond_and: ModelParser.condition_andContext = ctx.condition_and()
        for i in range(len(cond_and) - 1):
            left = cond_and[i].getText()
            right = "||".join([a.getText() for a in cond_and[i + 1 :]])
            complete = left + "||" + right
            self.output_asp.append(f'binary("{complete}","{left}","||","{right}").')
        super().visitCondition_or(ctx)

    def visitCondition_and(self, ctx: ModelParser.Condition_andContext):
        cond_not: ModelParser.condition_notContext = ctx.condition_not()
        for i in range(len(cond_not) - 1):
            left = cond_not[i].getText()
            right = "&&".join([a.getText() for a in cond_not[i + 1 :]])
            complete = left + "&&" + right
            self.output_asp.append(f'binary("{complete}","{left}","&&","{right}").')
        super().visitCondition_and(ctx)

    def visitCondition_not(self, ctx: ModelParser.Condition_notContext):
        complete = ctx.getText()
        if ctx.condition_not() is not None:
            negated = ctx.condition_not().getText()
            self.output_asp.append(f'unary("{complete}","!","{negated}").')
        elif ctx.condition() is not None:
            in_brackets = ctx.condition().getText()
            self.output_asp.append(f'unary("{complete}","()","{in_brackets}").')
        super().visitCondition_not(ctx)

    def visitCondition_compare(self, ctx: ModelParser.Condition_compareContext):
        formula: ModelParser.FormulaContext = ctx.formula()
        parts: ModelParser.Condition_partContext = ctx.condition_part()

        left = formula.getText()
        for i, p in enumerate(parts):
            # Binary atom for compare
            right = p.formula().getText()
            compare = p.compare().getText()
            complete = left + compare + right
            self.output_asp.append(f'binary("{complete}","{left}","{compare}","{right}").')
            left = right

            # # For multiple comparisons rewrite as propositional formulas connected by &&
            # right_prop = "&&".join(
            #     [f"{l.formula().getText()}{r.getText()}" for l, r in (zip(parts[i:], parts[i + 1 :]))]
            # )
            # if right_prop != "":
            #     complete_prop = complete + "&&" + right_prop
            #     self.output_asp.append(f'binary("{complete_prop}","{complete}","&&","{right_prop}").')
        super().visitCondition_compare(ctx)

    def visitFormula_add(self, ctx: ModelParser.Formula_addContext):
        form_sub: ModelParser.Formula_subContext = ctx.formula_sub()
        for i in range(len(form_sub) - 1):
            left = form_sub[i].getText()
            right = "+".join([a.getText() for a in form_sub[i + 1 :]])
            complete = left + "+" + right
            self.output_asp.append(f'binary("{complete}","{left}","+","{right}").')
        super().visitFormula_add(ctx)

    def visitFormula_sub(self, ctx: ModelParser.Formula_subContext):
        form_mul: ModelParser.Formula_mulContext = ctx.formula_mul()
        for i in range(len(form_mul) - 1):
            left = form_mul[i].getText()
            right = "-".join([a.getText() for a in form_mul[i + 1 :]])
            complete = left + "-" + right
            self.output_asp.append(f'binary("{complete}","{left}","-","{right}").')
        super().visitFormula_sub(ctx)

    def visitFormula_mul(self, ctx: ModelParser.Formula_mulContext):
        form_div: ModelParser.Formula_divContext = ctx.formula_div()
        for i in range(len(form_div) - 1):
            left = form_div[i].getText()
            right = "*".join([a.getText() for a in form_div[i + 1 :]])
            complete = left + "*" + right
            self.output_asp.append(f'binary("{complete}","{left}","*","{right}").')
        super().visitFormula_mul(ctx)

    def visitFormula_div(self, ctx: ModelParser.Formula_divContext):
        form_pow: ModelParser.Formula_powContext = ctx.formula_pow()
        for i in range(len(form_pow) - 1):
            left = form_pow[i].getText()
            right = "/".join([a.getText() for a in form_pow[i + 1 :]])
            complete = left + "/" + right
            self.output_asp.append(f'binary("{complete}","{left}","/","{right}").')
        super().visitFormula_div(ctx)

    def visitFormula_pow(self, ctx: ModelParser.Formula_powContext):
        form_sign: ModelParser.Formula_signContext = ctx.formula_sign()
        for i in range(len(form_sign) - 1):
            left = form_sign[i].getText()
            right = "^".join([a.getText() for a in form_sign[i + 1 :]])
            complete = left + "^" + right
            self.output_asp.append(f'binary("{complete}","{left}","^","{right}").')
        super().visitFormula_pow(ctx)

    def visitFormula_sign(self, ctx: ModelParser.Formula_signContext):
        complete = ctx.getText()
        if ctx.formula_sign() is not None:
            if ctx.neg is not None:
                negated = ctx.formula_sign().getText()
                self.output_asp.append(f'unary("{complete}","-","{negated}").')
            else:
                # Is this really necessary?
                positive = ctx.formula_sign().getText()
                self.output_asp.append(f'unary("{complete}","+","{positive}").')
        elif ctx.formula() is not None:
            in_brackets = ctx.formula().getText()
            self.output_asp.append(f'unary("{complete}","()","{in_brackets}").')
        elif ctx.formula_func() is not None:
            func = ctx.formula_func().FUNCTION()
            for f in ctx.formula_func().formula():
                if str(func) in ["sum", "count", "min", "max", "avg"]:
                    self.output_asp.append(f'function("{self.context}","{complete}","{func}","{f.getText()}").')
                else:
                    self.output_asp.append(f'unary("{complete}","{func}","{f.getText()}").')
        super().visitFormula_sign(ctx)

    def visitPath(self, ctx: ModelParser.PathContext):
        # Only do this for actual paths? Not formulas
        if self.print_path:
            full_path = f"{ctx.getText()}"

            if full_path[0].isupper():
                self.output_asp.append(f'constant("{full_path}").')
            else:
                for i, p in enumerate(ctx.path_item()):
                    self.output_asp.append(f'path("{full_path}",{i},"{p.getText()}").')

    def visitFloating(self, ctx: ModelParser.FloatingContext):
        # if ctx.FLOATING() is not None:
        #     pass
        if ctx.INTEGER() is not None:
            self.output_asp.append(f'number("{ctx.INTEGER()}",{ctx.INTEGER()}).')
