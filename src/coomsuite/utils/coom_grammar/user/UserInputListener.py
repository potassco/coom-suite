# Generated from /home/ruehling/projects/coom-suite/src/coomsuite/utils/coom_grammar/user/UserInput.g4 by ANTLR 4.13.2
from antlr4 import *
if "." in __name__:
    from .UserInputParser import UserInputParser
else:
    from UserInputParser import UserInputParser

# This class defines a complete listener for a parse tree produced by UserInputParser.
class UserInputListener(ParseTreeListener):

    # Enter a parse tree produced by UserInputParser#user_input.
    def enterUser_input(self, ctx:UserInputParser.User_inputContext):
        pass

    # Exit a parse tree produced by UserInputParser#user_input.
    def exitUser_input(self, ctx:UserInputParser.User_inputContext):
        pass


    # Enter a parse tree produced by UserInputParser#input_block.
    def enterInput_block(self, ctx:UserInputParser.Input_blockContext):
        pass

    # Exit a parse tree produced by UserInputParser#input_block.
    def exitInput_block(self, ctx:UserInputParser.Input_blockContext):
        pass


    # Enter a parse tree produced by UserInputParser#input_operation.
    def enterInput_operation(self, ctx:UserInputParser.Input_operationContext):
        pass

    # Exit a parse tree produced by UserInputParser#input_operation.
    def exitInput_operation(self, ctx:UserInputParser.Input_operationContext):
        pass


    # Enter a parse tree produced by UserInputParser#set_value.
    def enterSet_value(self, ctx:UserInputParser.Set_valueContext):
        pass

    # Exit a parse tree produced by UserInputParser#set_value.
    def exitSet_value(self, ctx:UserInputParser.Set_valueContext):
        pass


    # Enter a parse tree produced by UserInputParser#add_instance.
    def enterAdd_instance(self, ctx:UserInputParser.Add_instanceContext):
        pass

    # Exit a parse tree produced by UserInputParser#add_instance.
    def exitAdd_instance(self, ctx:UserInputParser.Add_instanceContext):
        pass


    # Enter a parse tree produced by UserInputParser#floating.
    def enterFloating(self, ctx:UserInputParser.FloatingContext):
        pass

    # Exit a parse tree produced by UserInputParser#floating.
    def exitFloating(self, ctx:UserInputParser.FloatingContext):
        pass


    # Enter a parse tree produced by UserInputParser#path.
    def enterPath(self, ctx:UserInputParser.PathContext):
        pass

    # Exit a parse tree produced by UserInputParser#path.
    def exitPath(self, ctx:UserInputParser.PathContext):
        pass


    # Enter a parse tree produced by UserInputParser#path_item.
    def enterPath_item(self, ctx:UserInputParser.Path_itemContext):
        pass

    # Exit a parse tree produced by UserInputParser#path_item.
    def exitPath_item(self, ctx:UserInputParser.Path_itemContext):
        pass


    # Enter a parse tree produced by UserInputParser#path_index.
    def enterPath_index(self, ctx:UserInputParser.Path_indexContext):
        pass

    # Exit a parse tree produced by UserInputParser#path_index.
    def exitPath_index(self, ctx:UserInputParser.Path_indexContext):
        pass


    # Enter a parse tree produced by UserInputParser#name.
    def enterName(self, ctx:UserInputParser.NameContext):
        pass

    # Exit a parse tree produced by UserInputParser#name.
    def exitName(self, ctx:UserInputParser.NameContext):
        pass


    # Enter a parse tree produced by UserInputParser#stmt_end.
    def enterStmt_end(self, ctx:UserInputParser.Stmt_endContext):
        pass

    # Exit a parse tree produced by UserInputParser#stmt_end.
    def exitStmt_end(self, ctx:UserInputParser.Stmt_endContext):
        pass


    # Enter a parse tree produced by UserInputParser#formula_atom.
    def enterFormula_atom(self, ctx:UserInputParser.Formula_atomContext):
        pass

    # Exit a parse tree produced by UserInputParser#formula_atom.
    def exitFormula_atom(self, ctx:UserInputParser.Formula_atomContext):
        pass



del UserInputParser
