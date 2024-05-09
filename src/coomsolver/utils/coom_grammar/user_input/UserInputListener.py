# Generated from UserInput.g4 by ANTLR 4.9.3
from antlr4 import *

if __name__ is not None and "." in __name__:
    from .UserInputParser import UserInputParser
else:
    from UserInputParser import UserInputParser


# This class defines a complete listener for a parse tree produced by UserInputParser.
class UserInputListener(ParseTreeListener):

    # Enter a parse tree produced by UserInputParser#user_input.
    def enterUser_input(self, ctx: UserInputParser.User_inputContext):
        pass

    # Exit a parse tree produced by UserInputParser#user_input.
    def exitUser_input(self, ctx: UserInputParser.User_inputContext):
        pass

    # Enter a parse tree produced by UserInputParser#input_block.
    def enterInput_block(self, ctx: UserInputParser.Input_blockContext):
        pass

    # Exit a parse tree produced by UserInputParser#input_block.
    def exitInput_block(self, ctx: UserInputParser.Input_blockContext):
        pass

    # Enter a parse tree produced by UserInputParser#input_operation.
    def enterInput_operation(self, ctx: UserInputParser.Input_operationContext):
        pass

    # Exit a parse tree produced by UserInputParser#input_operation.
    def exitInput_operation(self, ctx: UserInputParser.Input_operationContext):
        pass

    # Enter a parse tree produced by UserInputParser#set_value.
    def enterSet_value(self, ctx: UserInputParser.Set_valueContext):
        pass

    # Exit a parse tree produced by UserInputParser#set_value.
    def exitSet_value(self, ctx: UserInputParser.Set_valueContext):
        pass

    # Enter a parse tree produced by UserInputParser#add_instance.
    def enterAdd_instance(self, ctx: UserInputParser.Add_instanceContext):
        pass

    # Exit a parse tree produced by UserInputParser#add_instance.
    def exitAdd_instance(self, ctx: UserInputParser.Add_instanceContext):
        pass

    # Enter a parse tree produced by UserInputParser#constant.
    def enterConstant(self, ctx: UserInputParser.ConstantContext):
        pass

    # Exit a parse tree produced by UserInputParser#constant.
    def exitConstant(self, ctx: UserInputParser.ConstantContext):
        pass

    # Enter a parse tree produced by UserInputParser#floating.
    def enterFloating(self, ctx: UserInputParser.FloatingContext):
        pass

    # Exit a parse tree produced by UserInputParser#floating.
    def exitFloating(self, ctx: UserInputParser.FloatingContext):
        pass

    # Enter a parse tree produced by UserInputParser#path.
    def enterPath(self, ctx: UserInputParser.PathContext):
        pass

    # Exit a parse tree produced by UserInputParser#path.
    def exitPath(self, ctx: UserInputParser.PathContext):
        pass

    # Enter a parse tree produced by UserInputParser#path_item.
    def enterPath_item(self, ctx: UserInputParser.Path_itemContext):
        pass

    # Exit a parse tree produced by UserInputParser#path_item.
    def exitPath_item(self, ctx: UserInputParser.Path_itemContext):
        pass

    # Enter a parse tree produced by UserInputParser#path_index.
    def enterPath_index(self, ctx: UserInputParser.Path_indexContext):
        pass

    # Exit a parse tree produced by UserInputParser#path_index.
    def exitPath_index(self, ctx: UserInputParser.Path_indexContext):
        pass

    # Enter a parse tree produced by UserInputParser#name.
    def enterName(self, ctx: UserInputParser.NameContext):
        pass

    # Exit a parse tree produced by UserInputParser#name.
    def exitName(self, ctx: UserInputParser.NameContext):
        pass

    # Enter a parse tree produced by UserInputParser#stmt_end.
    def enterStmt_end(self, ctx: UserInputParser.Stmt_endContext):
        pass

    # Exit a parse tree produced by UserInputParser#stmt_end.
    def exitStmt_end(self, ctx: UserInputParser.Stmt_endContext):
        pass

    # Enter a parse tree produced by UserInputParser#compare.
    def enterCompare(self, ctx: UserInputParser.CompareContext):
        pass

    # Exit a parse tree produced by UserInputParser#compare.
    def exitCompare(self, ctx: UserInputParser.CompareContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula.
    def enterFormula(self, ctx: UserInputParser.FormulaContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula.
    def exitFormula(self, ctx: UserInputParser.FormulaContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_add.
    def enterFormula_add(self, ctx: UserInputParser.Formula_addContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_add.
    def exitFormula_add(self, ctx: UserInputParser.Formula_addContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_sub.
    def enterFormula_sub(self, ctx: UserInputParser.Formula_subContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_sub.
    def exitFormula_sub(self, ctx: UserInputParser.Formula_subContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_mul.
    def enterFormula_mul(self, ctx: UserInputParser.Formula_mulContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_mul.
    def exitFormula_mul(self, ctx: UserInputParser.Formula_mulContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_div.
    def enterFormula_div(self, ctx: UserInputParser.Formula_divContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_div.
    def exitFormula_div(self, ctx: UserInputParser.Formula_divContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_pow.
    def enterFormula_pow(self, ctx: UserInputParser.Formula_powContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_pow.
    def exitFormula_pow(self, ctx: UserInputParser.Formula_powContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_sign.
    def enterFormula_sign(self, ctx: UserInputParser.Formula_signContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_sign.
    def exitFormula_sign(self, ctx: UserInputParser.Formula_signContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_func.
    def enterFormula_func(self, ctx: UserInputParser.Formula_funcContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_func.
    def exitFormula_func(self, ctx: UserInputParser.Formula_funcContext):
        pass

    # Enter a parse tree produced by UserInputParser#formula_atom.
    def enterFormula_atom(self, ctx: UserInputParser.Formula_atomContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_atom.
    def exitFormula_atom(self, ctx: UserInputParser.Formula_atomContext):
        pass


del UserInputParser
