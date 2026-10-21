# Generated from /home/ruehling/projects/coom-suite/src/coomsuite/utils/coom_grammar/user/UserInput.g4 by ANTLR 4.13.2
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
        4,1,23,101,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,
        6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,1,0,1,0,5,0,27,8,0,
        10,0,12,0,30,9,0,1,0,1,0,1,1,1,1,1,1,1,1,5,1,38,8,1,10,1,12,1,41,
        9,1,1,1,1,1,1,2,1,2,3,2,47,8,2,1,3,1,3,1,3,1,3,1,3,1,4,1,4,1,4,1,
        5,3,5,58,8,5,1,5,1,5,1,6,1,6,1,6,5,6,65,8,6,10,6,12,6,68,9,6,1,7,
        1,7,1,7,1,7,1,7,3,7,75,8,7,1,7,1,7,3,7,79,8,7,1,8,1,8,1,8,1,8,3,
        8,85,8,8,3,8,87,8,8,1,9,1,9,1,10,1,10,3,10,93,8,10,1,11,1,11,1,11,
        1,11,3,11,99,8,11,1,11,0,0,12,0,2,4,6,8,10,12,14,16,18,20,22,0,1,
        2,0,8,8,18,19,102,0,28,1,0,0,0,2,33,1,0,0,0,4,46,1,0,0,0,6,48,1,
        0,0,0,8,53,1,0,0,0,10,57,1,0,0,0,12,61,1,0,0,0,14,69,1,0,0,0,16,
        86,1,0,0,0,18,88,1,0,0,0,20,92,1,0,0,0,22,98,1,0,0,0,24,27,3,2,1,
        0,25,27,3,4,2,0,26,24,1,0,0,0,26,25,1,0,0,0,27,30,1,0,0,0,28,26,
        1,0,0,0,28,29,1,0,0,0,29,31,1,0,0,0,30,28,1,0,0,0,31,32,5,0,0,1,
        32,1,1,0,0,0,33,34,5,1,0,0,34,35,3,12,6,0,35,39,5,2,0,0,36,38,3,
        4,2,0,37,36,1,0,0,0,38,41,1,0,0,0,39,37,1,0,0,0,39,40,1,0,0,0,40,
        42,1,0,0,0,41,39,1,0,0,0,42,43,5,3,0,0,43,3,1,0,0,0,44,47,3,6,3,
        0,45,47,3,8,4,0,46,44,1,0,0,0,46,45,1,0,0,0,47,5,1,0,0,0,48,49,5,
        4,0,0,49,50,3,12,6,0,50,51,5,5,0,0,51,52,3,22,11,0,52,7,1,0,0,0,
        53,54,5,6,0,0,54,55,3,12,6,0,55,9,1,0,0,0,56,58,5,7,0,0,57,56,1,
        0,0,0,57,58,1,0,0,0,58,59,1,0,0,0,59,60,7,0,0,0,60,11,1,0,0,0,61,
        66,3,14,7,0,62,63,5,9,0,0,63,65,3,14,7,0,64,62,1,0,0,0,65,68,1,0,
        0,0,66,64,1,0,0,0,66,67,1,0,0,0,67,13,1,0,0,0,68,66,1,0,0,0,69,78,
        3,18,9,0,70,71,5,10,0,0,71,74,3,16,8,0,72,73,5,11,0,0,73,75,3,16,
        8,0,74,72,1,0,0,0,74,75,1,0,0,0,75,76,1,0,0,0,76,77,5,12,0,0,77,
        79,1,0,0,0,78,70,1,0,0,0,78,79,1,0,0,0,79,15,1,0,0,0,80,87,5,18,
        0,0,81,84,5,13,0,0,82,83,5,7,0,0,83,85,5,18,0,0,84,82,1,0,0,0,84,
        85,1,0,0,0,85,87,1,0,0,0,86,80,1,0,0,0,86,81,1,0,0,0,87,17,1,0,0,
        0,88,89,5,17,0,0,89,19,1,0,0,0,90,93,5,14,0,0,91,93,6,10,-1,0,92,
        90,1,0,0,0,92,91,1,0,0,0,93,21,1,0,0,0,94,99,5,15,0,0,95,99,5,16,
        0,0,96,99,3,10,5,0,97,99,3,12,6,0,98,94,1,0,0,0,98,95,1,0,0,0,98,
        96,1,0,0,0,98,97,1,0,0,0,99,23,1,0,0,0,12,26,28,39,46,57,66,74,78,
        84,86,92,98
    ]

class UserInputParser ( Parser ):

    grammarFileName = "UserInput.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    sharedContextCache = PredictionContextCache()

    literalNames = [ "<INVALID>", "'blockinput'", "'{'", "'}'", "'set'", 
                     "'='", "'add'", "'-'", "'\\u221E'", "'.'", "'['", "'..'", 
                     "']'", "'last'", "';'", "'true'", "'false'" ]

    symbolicNames = [ "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "<INVALID>", "<INVALID>", "<INVALID>", 
                      "<INVALID>", "NAME", "INTEGER", "FLOATING", "NEWLINE", 
                      "WHITESPACE", "COMMENT", "MULTILINE_COMMENT" ]

    RULE_user_input = 0
    RULE_input_block = 1
    RULE_input_operation = 2
    RULE_set_value = 3
    RULE_add_instance = 4
    RULE_floating = 5
    RULE_path = 6
    RULE_path_item = 7
    RULE_path_index = 8
    RULE_name = 9
    RULE_stmt_end = 10
    RULE_formula_atom = 11

    ruleNames =  [ "user_input", "input_block", "input_operation", "set_value", 
                   "add_instance", "floating", "path", "path_item", "path_index", 
                   "name", "stmt_end", "formula_atom" ]

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
    NAME=17
    INTEGER=18
    FLOATING=19
    NEWLINE=20
    WHITESPACE=21
    COMMENT=22
    MULTILINE_COMMENT=23

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
            self.state = 28
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while (((_la) & ~0x3f) == 0 and ((1 << _la) & 82) != 0):
                self.state = 26
                self._errHandler.sync(self)
                token = self._input.LA(1)
                if token in [1]:
                    self.state = 24
                    self.input_block()
                    pass
                elif token in [4, 6]:
                    self.state = 25
                    self.input_operation()
                    pass
                else:
                    raise NoViableAltException(self)

                self.state = 30
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 31
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
            self.state = 33
            self.match(UserInputParser.T__0)
            self.state = 34
            self.path()
            self.state = 35
            self.match(UserInputParser.T__1)
            self.state = 39
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==4 or _la==6:
                self.state = 36
                self.input_operation()
                self.state = 41
                self._errHandler.sync(self)
                _la = self._input.LA(1)

            self.state = 42
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
            self.state = 46
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [4]:
                self.enterOuterAlt(localctx, 1)
                self.state = 44
                self.set_value()
                pass
            elif token in [6]:
                self.enterOuterAlt(localctx, 2)
                self.state = 45
                self.add_instance()
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
            self.state = 48
            localctx.op = self.match(UserInputParser.T__3)
            self.state = 49
            self.path()
            self.state = 50
            self.match(UserInputParser.T__4)
            self.state = 51
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
            self.state = 53
            localctx.op = self.match(UserInputParser.T__5)
            self.state = 54
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
        self.enterRule(localctx, 10, self.RULE_floating)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 57
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==7:
                self.state = 56
                self.match(UserInputParser.T__6)


            self.state = 59
            _la = self._input.LA(1)
            if not((((_la) & ~0x3f) == 0 and ((1 << _la) & 786688) != 0)):
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
        self.enterRule(localctx, 12, self.RULE_path)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 61
            self.path_item()
            self.state = 66
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la==9:
                self.state = 62
                self.match(UserInputParser.T__8)
                self.state = 63
                self.path_item()
                self.state = 68
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
        self.enterRule(localctx, 14, self.RULE_path_item)
        self._la = 0 # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 69
            self.name()
            self.state = 78
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la==10:
                self.state = 70
                self.match(UserInputParser.T__9)
                self.state = 71
                self.path_index()
                self.state = 74
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la==11:
                    self.state = 72
                    self.match(UserInputParser.T__10)
                    self.state = 73
                    self.path_index()


                self.state = 76
                self.match(UserInputParser.T__11)


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
        self.enterRule(localctx, 16, self.RULE_path_index)
        self._la = 0 # Token type
        try:
            self.state = 86
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [18]:
                self.enterOuterAlt(localctx, 1)
                self.state = 80
                self.match(UserInputParser.INTEGER)
                pass
            elif token in [13]:
                self.enterOuterAlt(localctx, 2)
                self.state = 81
                self.match(UserInputParser.T__12)
                self.state = 84
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la==7:
                    self.state = 82
                    self.match(UserInputParser.T__6)
                    self.state = 83
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
        self.enterRule(localctx, 18, self.RULE_name)
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 88
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
        self.enterRule(localctx, 20, self.RULE_stmt_end)
        try:
            self.state = 92
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [14]:
                self.enterOuterAlt(localctx, 1)
                self.state = 90
                self.match(UserInputParser.T__13)
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
        self.enterRule(localctx, 22, self.RULE_formula_atom)
        try:
            self.state = 98
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [15]:
                self.enterOuterAlt(localctx, 1)
                self.state = 94
                localctx.atom_true = self.match(UserInputParser.T__14)
                pass
            elif token in [16]:
                self.enterOuterAlt(localctx, 2)
                self.state = 95
                localctx.atom_false = self.match(UserInputParser.T__15)
                pass
            elif token in [7, 8, 18, 19]:
                self.enterOuterAlt(localctx, 3)
                self.state = 96
                localctx.atom_num = self.floating()
                pass
            elif token in [17]:
                self.enterOuterAlt(localctx, 4)
                self.state = 97
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
