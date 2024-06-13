# Generated from UserInput.g4 by ANTLR 4.9.3
from antlr4 import *

if __name__ is not None and "." in __name__:
    from .UserInputParser import UserInputParser
else:
    from UserInputParser import UserInputParser

# This class defines a complete generic visitor for a parse tree produced by UserInputParser.


class UserInputVisitor(ParseTreeVisitor):

    # Visit a parse tree produced by UserInputParser#user_input.
    def visitUser_input(self, ctx: UserInputParser.User_inputContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#input_block.
    def visitInput_block(self, ctx: UserInputParser.Input_blockContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#input_operation.
    def visitInput_operation(self, ctx: UserInputParser.Input_operationContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#set_value.
    def visitSet_value(self, ctx: UserInputParser.Set_valueContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#add_instance.
    def visitAdd_instance(self, ctx: UserInputParser.Add_instanceContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#constant.
    def visitConstant(self, ctx: UserInputParser.ConstantContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#floating.
    def visitFloating(self, ctx: UserInputParser.FloatingContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#path.
    def visitPath(self, ctx: UserInputParser.PathContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#path_item.
    def visitPath_item(self, ctx: UserInputParser.Path_itemContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#path_index.
    def visitPath_index(self, ctx: UserInputParser.Path_indexContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#name.
    def visitName(self, ctx: UserInputParser.NameContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#stmt_end.
    def visitStmt_end(self, ctx: UserInputParser.Stmt_endContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#compare.
    def visitCompare(self, ctx: UserInputParser.CompareContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula.
    def visitFormula(self, ctx: UserInputParser.FormulaContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_add.
    def visitFormula_add(self, ctx: UserInputParser.Formula_addContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_sub.
    def visitFormula_sub(self, ctx: UserInputParser.Formula_subContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_mul.
    def visitFormula_mul(self, ctx: UserInputParser.Formula_mulContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_div.
    def visitFormula_div(self, ctx: UserInputParser.Formula_divContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_pow.
    def visitFormula_pow(self, ctx: UserInputParser.Formula_powContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_sign.
    def visitFormula_sign(self, ctx: UserInputParser.Formula_signContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_func.
    def visitFormula_func(self, ctx: UserInputParser.Formula_funcContext):
        return self.visitChildren(ctx)

    # Visit a parse tree produced by UserInputParser#formula_atom.
    def visitFormula_atom(self, ctx: UserInputParser.Formula_atomContext):
        return self.visitChildren(ctx)


del UserInputParser
