# Generated from UserInput.g4 by ANTLR 4.13.2
# encoding: utf-8
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
	from typing import TextIO
else:
	from typing.io import TextIO

def serializedATN():
    return [
        4,1,24,108,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,1,0,1,0,
        5,0,29,8,0,10,0,12,0,32,9,0,1,0,1,0,1,1,1,1,1,1,1,1,5,1,40,8,1,10,
        1,12,1,43,9,1,1,1,1,1,1,2,1,2,1,2,3,2,50,8,2,1,3,1,3,1,3,1,3,1,3,
        1,4,1,4,1,4,1,5,1,5,1,5,1,5,1,6,3,6,65,8,6,1,6,1,6,1,7,1,7,1,7,5,
        7,72,8,7,10,7,12,7,75,9,7,1,8,1,8,1,8,1,8,1,8,3,8,82,8,8,1,8,1,8,
        3,8,86,8,8,1,9,1,9,1,9,1,9,3,9,92,8,9,3,9,94,8,9,1,10,1,10,1,11,
        1,11,3,11,100,8,11,1,12,1,12,1,12,1,12,3,12,106,8,12,1,12,0,0,13,
        0,2,4,6,8,10,12,14,16,18,20,22,24,0,1,2,0,9,9,19,20,109,0,30,1,0,
        0,0,2,35,1,0,0,0,4,49,1,0,0,0,6,51,1,0,0,0,8,56,1,0,0,0,10,59,1,
        0,0,0,12,64,1,0,0,0,14,68,1,0,0,0,16,76,1,0,0,0,18,93,1,0,0,0,20,
        95,1,0,0,0,22,99,1,0,0,0,24,105,1,0,0,0,26,29,3,2,1,0,27,29,3,4,
        2,0,28,26,1,0,0,0,28,27,1,0,0,0,29,32,1,0,0,0,30,28,1,0,0,0,30,31,
        1,0,0,0,31,33,1,0,0,0,32,30,1,0,0,0,33,34,5,0,0,1,34,1,1,0,0,0,35,
        36,5,1,0,0,36,37,3,14,7,0,37,41,5,2,0,0,38,40,3,4,2,0,39,38,1,0,
        0,0,40,43,1,0,0,0,41,39,1,0,0,0,41,42,1,0,0,0,42,44,1,0,0,0,43,41,
        1,0,0,0,44,45,5,3,0,0,45,3,1,0,0,0,46,50,3,6,3,0,47,50,3,8,4,0,48,
        50,3,10,5,0,49,46,1,0,0,0,49,47,1,0,0,0,49,48,1,0,0,0,50,5,1,0,0,
        0,51,52,5,4,0,0,52,53,3,14,7,0,53,54,5,5,0,0,54,55,3,24,12,0,55,
        7,1,0,0,0,56,57,5,6,0,0,57,58,3,14,7,0,58,9,1,0,0,0,59,60,5,7,0,
        0,60,61,3,14,7,0,61,62,3,14,7,0,62,11,1,0,0,0,63,65,5,8,0,0,64,63,
        1,0,0,0,64,65,1,0,0,0,65,66,1,0,0,0,66,67,7,0,0,0,67,13,1,0,0,0,
        68,73,3,16,8,0,69,70,5,10,0,0,70,72,3,16,8,0,71,69,1,0,0,0,72,75,
        1,0,0,0,73,71,1,0,0,0,73,74,1,0,0,0,74,15,1,0,0,0,75,73,1,0,0,0,
        76,85,3,20,10,0,77,78,5,11,0,0,78,81,3,18,9,0,79,80,5,12,0,0,80,
        82,3,18,9,0,81,79,1,0,0,0,81,82,1,0,0,0,82,83,1,0,0,0,83,84,5,13,
        0,0,84,86,1,0,0,0,85,77,1,0,0,0,85,86,1,0,0,0,86,17,1,0,0,0,87,94,
        5,19,0,0,88,91,5,14,0,0,89,90,5,8,0,0,90,92,5,19,0,0,91,89,1,0,0,
        0,91,92,1,0,0,0,92,94,1,0,0,0,93,87,1,0,0,0,93,88,1,0,0,0,94,19,
        1,0,0,0,95,96,5,18,0,0,96,21,1,0,0,0,97,100,5,15,0,0,98,100,6,11,
        -1,0,99,97,1,0,0,0,99,98,1,0,0,0,100,23,1,0,0,0,101,106,5,16,0,0,
        102,106,5,17,0,0,103,106,3,12,6,0,104,106,3,14,7,0,105,101,1,0,0,
        0,105,102,1,0,0,0,105,103,1,0,0,0,105,104,1,0,0,0,106,25,1,0,0,0,
        12,28,30,41,49,64,73,81,85,91,93,99,105
    ]

class UserInputParser ( Parser ):

    grammarFileName = "UserInput.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'blockinput'", "'{'", "'}'", "'set'", 
                     "'='", "'add'", "'associate'", "'-'", "'\\u221E'", 
                     "'.'", "'['", "'..'", "']'", "'last'", "';'", "'true'", 
                     "'false'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "NAME", "INTEGER", "FLOATING", 
                      "NEWLINE", "WHITESPACE", "COMMENT", "MULTILINE_COMMENT" ]

    RULE_user_input = 0
    RULE_input_block = 1
    RULE_input_operation = 2
    RULE_set_value = 3
    RULE_add_instance = 4
    RULE_associate = 5
    RULE_floating = 6
    RULE_path = 7
    RULE_path_item = 8
    RULE_path_index = 9
    RULE_name = 10
    RULE_stmt_end = 11
    RULE_formula_atom = 12

    ruleNames =  [ "user_input", "input_block", "input_operation", "set_value", 
                   "add_instance", "associate", "floating", "path", "path_item", 
                   "path_index", "name", "stmt_end", "formula_atom" ]

    EOF = Token.EOF
    T__0=1
    T__1=2
    T__2=3
    T__3=4
    T__4=5
    T__5=6
    T__6=7
    T__7=8
    T__8=9
    T__9=10
    T__10=11
    T__11=12
    T__12=13
    T__13=14
    T__14=15
    T__15=16
    T__16=17
    NAME=18
    INTEGER=19
    FLOATING=20
    NEWLINE=21
    WHITESPACE=22
    COMMENT=23
    MULTILINE_COMMENT=24

    def __init__(self, input:TokenStream, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.2")
        self._interp = ParserATNSimulator(self, self.atn, self.decisionsToDFA, self.sharedContextCache)
        self._predicates = None



    def wasNewline(self):
        for index in reversed(range(self.getCurrentToken().tokenIndex)):
            # stop on default channel
            token = self.getTokenStream().get(index)
            if token.channel == 0:
                break

            # if the token is blank and contains newline, we found it
            if len(token.text) == 0:
                continue
            if token.text.startswith("\n") or token.text.startswith("\r"):
                return True

        return False



    class User_inputContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def EOF(self):
            return self.getToken(UserInputParser.EOF, 0)

        def input_block(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_blockContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_blockContext,i)


        def input_operation(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_operationContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_operationContext,i)


        def getRuleIndex(self):
            return UserInputParser.RULE_user_input

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterUser_input" ):
                listener.enterUser_input(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitUser_input" ):
                listener.exitUser_input(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitUser_input" ):
                return visitor.visitUser_input(self)
            else:
                return visitor.visitChildren(self)




    def user_input(self):

        localctx = UserInputParser.User_inputContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_user_input)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 30
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while (((_la) & ~0x3f) == 0 and ((1 << _la) & 210) != 0):
                self.state = 28
                self._errHandler.sync(self)
                token = self._input.LA(1)
                if token in [1]:
                    self.state = 26
                    self.input_block()
                    pass
                elif token in [4, 6, 7]:
                    self.state = 27
                    self.input_operation()
                    pass
                else:
                    raise NoViableAltException(self)

                self.state = 32
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 33
            self.match(UserInputParser.EOF)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Input_blockContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext,0)


        def input_operation(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_operationContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_operationContext,i)


        def getRuleIndex(self):
            return UserInputParser.RULE_input_block

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterInput_block" ):
                listener.enterInput_block(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitInput_block" ):
                listener.exitInput_block(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitInput_block" ):
                return visitor.visitInput_block(self)
            else:
                return visitor.visitChildren(self)




    def input_block(self):

        localctx = UserInputParser.Input_blockContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_input_block)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 35
            self.match(UserInputParser.T__0)
            self.state = 36
            self.path()
            self.state = 37
            self.match(UserInputParser.T__1)
            self.state = 41
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while (((_la) & ~0x3f) == 0 and ((1 << _la) & 208) != 0):
                self.state = 38
                self.input_operation()
                self.state = 43
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 44
            self.match(UserInputParser.T__2)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Input_operationContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def set_value(self):
            return self.getTypedRuleContext(UserInputParser.Set_valueContext,0)


        def add_instance(self):
            return self.getTypedRuleContext(UserInputParser.Add_instanceContext,0)


        def associate(self):
            return self.getTypedRuleContext(UserInputParser.AssociateContext,0)


        def getRuleIndex(self):
            return UserInputParser.RULE_input_operation

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterInput_operation" ):
                listener.enterInput_operation(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitInput_operation" ):
                listener.exitInput_operation(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitInput_operation" ):
                return visitor.visitInput_operation(self)
            else:
                return visitor.visitChildren(self)




    def input_operation(self):

        localctx = UserInputParser.Input_operationContext(self, self._ctx, self.state)
        self.enterRule(localctx, 4, self.RULE_input_operation)
        try:
            self.state = 49
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4]:
                self.enterOuterAlt(localctx, 1)
                self.state = 46
                self.set_value()
                pass
            elif token in [6]:
                self.enterOuterAlt(localctx, 2)
                self.state = 47
                self.add_instance()
                pass
            elif token in [7]:
                self.enterOuterAlt(localctx, 3)
                self.state = 48
                self.associate()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Set_valueContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.op = None # Token

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext,0)


        def formula_atom(self):
            return self.getTypedRuleContext(UserInputParser.Formula_atomContext,0)


        def getRuleIndex(self):
            return UserInputParser.RULE_set_value

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterSet_value" ):
                listener.enterSet_value(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitSet_value" ):
                listener.exitSet_value(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitSet_value" ):
                return visitor.visitSet_value(self)
            else:
                return visitor.visitChildren(self)




    def set_value(self):

        localctx = UserInputParser.Set_valueContext(self, self._ctx, self.state)
        self.enterRule(localctx, 6, self.RULE_set_value)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 51
            localctx.op = self.match(UserInputParser.T__3)
            self.state = 52
            self.path()
            self.state = 53
            self.match(UserInputParser.T__4)
            self.state = 54
            self.formula_atom()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Add_instanceContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.op = None # Token

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext,0)


        def getRuleIndex(self):
            return UserInputParser.RULE_add_instance

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterAdd_instance" ):
                listener.enterAdd_instance(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitAdd_instance" ):
                listener.exitAdd_instance(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitAdd_instance" ):
                return visitor.visitAdd_instance(self)
            else:
                return visitor.visitChildren(self)




    def add_instance(self):

        localctx = UserInputParser.Add_instanceContext(self, self._ctx, self.state)
        self.enterRule(localctx, 8, self.RULE_add_instance)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 56
            localctx.op = self.match(UserInputParser.T__5)
            self.state = 57
            self.path()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class AssociateContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.op = None # Token

        def path(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.PathContext)
            else:
                return self.getTypedRuleContext(UserInputParser.PathContext,i)


        def getRuleIndex(self):
            return UserInputParser.RULE_associate

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterAssociate" ):
                listener.enterAssociate(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitAssociate" ):
                listener.exitAssociate(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitAssociate" ):
                return visitor.visitAssociate(self)
            else:
                return visitor.visitChildren(self)




    def associate(self):

        localctx = UserInputParser.AssociateContext(self, self._ctx, self.state)
        self.enterRule(localctx, 10, self.RULE_associate)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 59
            localctx.op = self.match(UserInputParser.T__6)
            self.state = 60
            self.path()
            self.state = 61
            self.path()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class FloatingContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def FLOATING(self):
            return self.getToken(UserInputParser.FLOATING, 0)

        def INTEGER(self):
            return self.getToken(UserInputParser.INTEGER, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_floating

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterFloating" ):
                listener.enterFloating(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitFloating" ):
                listener.exitFloating(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitFloating" ):
                return visitor.visitFloating(self)
            else:
                return visitor.visitChildren(self)




    def floating(self):

        localctx = UserInputParser.FloatingContext(self, self._ctx, self.state)
        self.enterRule(localctx, 12, self.RULE_floating)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 64
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==8:
                self.state = 63
                self.match(UserInputParser.T__7)


            self.state = 66
            _la = self._input.LA(1)
            if not((((_la) & ~0x3f) == 0 and ((1 << _la) & 1573376) != 0)):
                self._errHandler.recoverInline(self)
            else:
                self._errHandler.reportMatch(self)
                self.consume()
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class PathContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def path_item(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Path_itemContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Path_itemContext,i)


        def getRuleIndex(self):
            return UserInputParser.RULE_path

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPath" ):
                listener.enterPath(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPath" ):
                listener.exitPath(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPath" ):
                return visitor.visitPath(self)
            else:
                return visitor.visitChildren(self)




    def path(self):

        localctx = UserInputParser.PathContext(self, self._ctx, self.state)
        self.enterRule(localctx, 14, self.RULE_path)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 68
            self.path_item()
            self.state = 73
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==10:
                self.state = 69
                self.match(UserInputParser.T__9)
                self.state = 70
                self.path_item()
                self.state = 75
                self._errHandler.sync(self)
                _la = self._input.LA(1)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Path_itemContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def name(self):
            return self.getTypedRuleContext(UserInputParser.NameContext,0)


        def path_index(self, i:int=None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Path_indexContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Path_indexContext,i)


        def getRuleIndex(self):
            return UserInputParser.RULE_path_item

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPath_item" ):
                listener.enterPath_item(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPath_item" ):
                listener.exitPath_item(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPath_item" ):
                return visitor.visitPath_item(self)
            else:
                return visitor.visitChildren(self)




    def path_item(self):

        localctx = UserInputParser.Path_itemContext(self, self._ctx, self.state)
        self.enterRule(localctx, 16, self.RULE_path_item)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 76
            self.name()
            self.state = 85
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==11:
                self.state = 77
                self.match(UserInputParser.T__10)
                self.state = 78
                self.path_index()
                self.state = 81
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la==12:
                    self.state = 79
                    self.match(UserInputParser.T__11)
                    self.state = 80
                    self.path_index()


                self.state = 83
                self.match(UserInputParser.T__12)


        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Path_indexContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def INTEGER(self):
            return self.getToken(UserInputParser.INTEGER, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_path_index

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterPath_index" ):
                listener.enterPath_index(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitPath_index" ):
                listener.exitPath_index(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitPath_index" ):
                return visitor.visitPath_index(self)
            else:
                return visitor.visitChildren(self)




    def path_index(self):

        localctx = UserInputParser.Path_indexContext(self, self._ctx, self.state)
        self.enterRule(localctx, 18, self.RULE_path_index)
        self._la = 0 # Token type
        try:
            self.state = 93
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [19]:
                self.enterOuterAlt(localctx, 1)
                self.state = 87
                self.match(UserInputParser.INTEGER)
                pass
            elif token in [14]:
                self.enterOuterAlt(localctx, 2)
                self.state = 88
                self.match(UserInputParser.T__13)
                self.state = 91
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la==8:
                    self.state = 89
                    self.match(UserInputParser.T__7)
                    self.state = 90
                    self.match(UserInputParser.INTEGER)


                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class NameContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NAME(self):
            return self.getToken(UserInputParser.NAME, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_name

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterName" ):
                listener.enterName(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitName" ):
                listener.exitName(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitName" ):
                return visitor.visitName(self)
            else:
                return visitor.visitChildren(self)




    def name(self):

        localctx = UserInputParser.NameContext(self, self._ctx, self.state)
        self.enterRule(localctx, 20, self.RULE_name)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 95
            self.match(UserInputParser.NAME)
        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Stmt_endContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser


        def getRuleIndex(self):
            return UserInputParser.RULE_stmt_end

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterStmt_end" ):
                listener.enterStmt_end(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitStmt_end" ):
                listener.exitStmt_end(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitStmt_end" ):
                return visitor.visitStmt_end(self)
            else:
                return visitor.visitChildren(self)




    def stmt_end(self):

        localctx = UserInputParser.Stmt_endContext(self, self._ctx, self.state)
        self.enterRule(localctx, 22, self.RULE_stmt_end)
        try:
            self.state = 99
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [15]:
                self.enterOuterAlt(localctx, 1)
                self.state = 97
                self.match(UserInputParser.T__14)
                pass
            elif token in [-1]:
                self.enterOuterAlt(localctx, 2)
                self.wasNewline()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx


    class Formula_atomContext(ParserRuleContext):
        __slots__ = 'parser'

        def __init__(self, parser, parent:ParserRuleContext=None, invokingState:int=-1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.atom_true = None # Token
            self.atom_false = None # Token
            self.atom_num = None # FloatingContext
            self.atom_path = None # PathContext

        def floating(self):
            return self.getTypedRuleContext(UserInputParser.FloatingContext,0)


        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext,0)


        def getRuleIndex(self):
            return UserInputParser.RULE_formula_atom

        def enterRule(self, listener:ParseTreeListener):
            if hasattr( listener, "enterFormula_atom" ):
                listener.enterFormula_atom(self)

        def exitRule(self, listener:ParseTreeListener):
            if hasattr( listener, "exitFormula_atom" ):
                listener.exitFormula_atom(self)

        def accept(self, visitor:ParseTreeVisitor):
            if hasattr( visitor, "visitFormula_atom" ):
                return visitor.visitFormula_atom(self)
            else:
                return visitor.visitChildren(self)




    def formula_atom(self):

        localctx = UserInputParser.Formula_atomContext(self, self._ctx, self.state)
        self.enterRule(localctx, 24, self.RULE_formula_atom)
        try:
            self.state = 105
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [16]:
                self.enterOuterAlt(localctx, 1)
                self.state = 101
                localctx.atom_true = self.match(UserInputParser.T__15)
                pass
            elif token in [17]:
                self.enterOuterAlt(localctx, 2)
                self.state = 102
                localctx.atom_false = self.match(UserInputParser.T__16)
                pass
            elif token in [8, 9, 19, 20]:
                self.enterOuterAlt(localctx, 3)
                self.state = 103
                localctx.atom_num = self.floating()
                pass
            elif token in [18]:
                self.enterOuterAlt(localctx, 4)
                self.state = 104
                localctx.atom_path = self.path()
                pass
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx
