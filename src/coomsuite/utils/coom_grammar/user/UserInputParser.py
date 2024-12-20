# Generated from UserInput.g4 by ANTLR 4.9.3
# encoding: utf-8
import sys
from io import StringIO

from antlr4 import *

if sys.version_info[1] > 5:
    from typing import TextIO
else:
    from typing.io import TextIO


def serializedATN():
    with StringIO() as buf:
        buf.write("\3\u608b\ua72a\u8133\ub9ed\u417c\u3be7\u7786\u5964\3\31")
        buf.write("g\4\2\t\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b")
        buf.write("\t\b\4\t\t\t\4\n\t\n\4\13\t\13\4\f\t\f\4\r\t\r\3\2\3\2")
        buf.write("\7\2\35\n\2\f\2\16\2 \13\2\3\2\3\2\3\3\3\3\3\3\3\3\7\3")
        buf.write("(\n\3\f\3\16\3+\13\3\3\3\3\3\3\4\3\4\5\4\61\n\4\3\5\3")
        buf.write("\5\3\5\3\5\3\5\3\6\3\6\3\6\3\7\5\7<\n\7\3\7\3\7\3\b\3")
        buf.write("\b\3\b\7\bC\n\b\f\b\16\bF\13\b\3\t\3\t\3\t\3\t\3\t\5\t")
        buf.write("M\n\t\3\t\3\t\5\tQ\n\t\3\n\3\n\3\n\3\n\5\nW\n\n\5\nY\n")
        buf.write("\n\3\13\3\13\3\f\3\f\5\f_\n\f\3\r\3\r\3\r\3\r\5\re\n\r")
        buf.write("\3\r\2\2\16\2\4\6\b\n\f\16\20\22\24\26\30\2\3\4\2\n\n")
        buf.write("\24\25\2h\2\36\3\2\2\2\4#\3\2\2\2\6\60\3\2\2\2\b\62\3")
        buf.write("\2\2\2\n\67\3\2\2\2\f;\3\2\2\2\16?\3\2\2\2\20G\3\2\2\2")
        buf.write("\22X\3\2\2\2\24Z\3\2\2\2\26^\3\2\2\2\30d\3\2\2\2\32\35")
        buf.write("\5\4\3\2\33\35\5\6\4\2\34\32\3\2\2\2\34\33\3\2\2\2\35")
        buf.write(" \3\2\2\2\36\34\3\2\2\2\36\37\3\2\2\2\37!\3\2\2\2 \36")
        buf.write('\3\2\2\2!"\7\2\2\3"\3\3\2\2\2#$\7\3\2\2$%\5\16\b\2%')
        buf.write(")\7\4\2\2&(\5\6\4\2'&\3\2\2\2(+\3\2\2\2)'\3\2\2\2)*")
        buf.write("\3\2\2\2*,\3\2\2\2+)\3\2\2\2,-\7\5\2\2-\5\3\2\2\2.\61")
        buf.write("\5\b\5\2/\61\5\n\6\2\60.\3\2\2\2\60/\3\2\2\2\61\7\3\2")
        buf.write("\2\2\62\63\7\6\2\2\63\64\5\16\b\2\64\65\7\7\2\2\65\66")
        buf.write("\5\30\r\2\66\t\3\2\2\2\678\7\b\2\289\5\16\b\29\13\3\2")
        buf.write("\2\2:<\7\t\2\2;:\3\2\2\2;<\3\2\2\2<=\3\2\2\2=>\t\2\2\2")
        buf.write(">\r\3\2\2\2?D\5\20\t\2@A\7\13\2\2AC\5\20\t\2B@\3\2\2\2")
        buf.write("CF\3\2\2\2DB\3\2\2\2DE\3\2\2\2E\17\3\2\2\2FD\3\2\2\2G")
        buf.write("P\5\24\13\2HI\7\f\2\2IL\5\22\n\2JK\7\r\2\2KM\5\22\n\2")
        buf.write("LJ\3\2\2\2LM\3\2\2\2MN\3\2\2\2NO\7\16\2\2OQ\3\2\2\2PH")
        buf.write("\3\2\2\2PQ\3\2\2\2Q\21\3\2\2\2RY\7\24\2\2SV\7\17\2\2T")
        buf.write("U\7\t\2\2UW\7\24\2\2VT\3\2\2\2VW\3\2\2\2WY\3\2\2\2XR\3")
        buf.write("\2\2\2XS\3\2\2\2Y\23\3\2\2\2Z[\7\23\2\2[\25\3\2\2\2\\")
        buf.write("_\7\20\2\2]_\b\f\1\2^\\\3\2\2\2^]\3\2\2\2_\27\3\2\2\2")
        buf.write("`e\7\21\2\2ae\7\22\2\2be\5\f\7\2ce\5\16\b\2d`\3\2\2\2")
        buf.write("da\3\2\2\2db\3\2\2\2dc\3\2\2\2e\31\3\2\2\2\16\34\36)\60")
        buf.write(";DLPVX^d")
        return buf.getvalue()


class UserInputParser(Parser):

    grammarFileName = "UserInput.g4"

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [DFA(ds, i) for i, ds in enumerate(atn.decisionToState)]

    sharedContextCache = PredictionContextCache()

    literalNames = [
        "<INVALID>",
        "'blockinput'",
        "'{'",
        "'}'",
        "'set'",
        "'='",
        "'add'",
        "'-'",
        "'\u221E'",
        "'.'",
        "'['",
        "'..'",
        "']'",
        "'last'",
        "';'",
        "'true'",
        "'false'",
    ]

    symbolicNames = [
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "<INVALID>",
        "NAME",
        "INTEGER",
        "FLOATING",
        "NEWLINE",
        "WHITESPACE",
        "COMMENT",
        "MULTILINE_COMMENT",
    ]

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

    ruleNames = [
        "user_input",
        "input_block",
        "input_operation",
        "set_value",
        "add_instance",
        "floating",
        "path",
        "path_item",
        "path_index",
        "name",
        "stmt_end",
        "formula_atom",
    ]

    EOF = Token.EOF
    T__0 = 1
    T__1 = 2
    T__2 = 3
    T__3 = 4
    T__4 = 5
    T__5 = 6
    T__6 = 7
    T__7 = 8
    T__8 = 9
    T__9 = 10
    T__10 = 11
    T__11 = 12
    T__12 = 13
    T__13 = 14
    T__14 = 15
    T__15 = 16
    NAME = 17
    INTEGER = 18
    FLOATING = 19
    NEWLINE = 20
    WHITESPACE = 21
    COMMENT = 22
    MULTILINE_COMMENT = 23

    def __init__(self, input: TokenStream, output: TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.9.3")
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def EOF(self):
            return self.getToken(UserInputParser.EOF, 0)

        def input_block(self, i: int = None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_blockContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_blockContext, i)

        def input_operation(self, i: int = None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_operationContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_operationContext, i)

        def getRuleIndex(self):
            return UserInputParser.RULE_user_input

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterUser_input"):
                listener.enterUser_input(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitUser_input"):
                listener.exitUser_input(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitUser_input"):
                return visitor.visitUser_input(self)
            else:
                return visitor.visitChildren(self)

    def user_input(self):

        localctx = UserInputParser.User_inputContext(self, self._ctx, self.state)
        self.enterRule(localctx, 0, self.RULE_user_input)
        self._la = 0  # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 28
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while ((_la) & ~0x3F) == 0 and (
                (1 << _la) & ((1 << UserInputParser.T__0) | (1 << UserInputParser.T__3) | (1 << UserInputParser.T__5))
            ) != 0:
                self.state = 26
                self._errHandler.sync(self)
                token = self._input.LA(1)
                if token in [UserInputParser.T__0]:
                    self.state = 24
                    self.input_block()
                elif token in [UserInputParser.T__3, UserInputParser.T__5]:
                    self.state = 25
                    self.input_operation()
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext, 0)

        def input_operation(self, i: int = None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Input_operationContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Input_operationContext, i)

        def getRuleIndex(self):
            return UserInputParser.RULE_input_block

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterInput_block"):
                listener.enterInput_block(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitInput_block"):
                listener.exitInput_block(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitInput_block"):
                return visitor.visitInput_block(self)
            else:
                return visitor.visitChildren(self)

    def input_block(self):

        localctx = UserInputParser.Input_blockContext(self, self._ctx, self.state)
        self.enterRule(localctx, 2, self.RULE_input_block)
        self._la = 0  # Token type
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
            while _la == UserInputParser.T__3 or _la == UserInputParser.T__5:
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def set_value(self):
            return self.getTypedRuleContext(UserInputParser.Set_valueContext, 0)

        def add_instance(self):
            return self.getTypedRuleContext(UserInputParser.Add_instanceContext, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_input_operation

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterInput_operation"):
                listener.enterInput_operation(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitInput_operation"):
                listener.exitInput_operation(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitInput_operation"):
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
            if token in [UserInputParser.T__3]:
                self.enterOuterAlt(localctx, 1)
                self.state = 44
                self.set_value()
            elif token in [UserInputParser.T__5]:
                self.enterOuterAlt(localctx, 2)
                self.state = 45
                self.add_instance()
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.op = None  # Token

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext, 0)

        def formula_atom(self):
            return self.getTypedRuleContext(UserInputParser.Formula_atomContext, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_set_value

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterSet_value"):
                listener.enterSet_value(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitSet_value"):
                listener.exitSet_value(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitSet_value"):
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.op = None  # Token

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_add_instance

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterAdd_instance"):
                listener.enterAdd_instance(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitAdd_instance"):
                listener.exitAdd_instance(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitAdd_instance"):
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def FLOATING(self):
            return self.getToken(UserInputParser.FLOATING, 0)

        def INTEGER(self):
            return self.getToken(UserInputParser.INTEGER, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_floating

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterFloating"):
                listener.enterFloating(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitFloating"):
                listener.exitFloating(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitFloating"):
                return visitor.visitFloating(self)
            else:
                return visitor.visitChildren(self)

    def floating(self):

        localctx = UserInputParser.FloatingContext(self, self._ctx, self.state)
        self.enterRule(localctx, 10, self.RULE_floating)
        self._la = 0  # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 57
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la == UserInputParser.T__6:
                self.state = 56
                self.match(UserInputParser.T__6)

            self.state = 59
            _la = self._input.LA(1)
            if not (
                (
                    ((_la) & ~0x3F) == 0
                    and (
                        (1 << _la)
                        & (
                            (1 << UserInputParser.T__7)
                            | (1 << UserInputParser.INTEGER)
                            | (1 << UserInputParser.FLOATING)
                        )
                    )
                    != 0
                )
            ):
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def path_item(self, i: int = None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Path_itemContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Path_itemContext, i)

        def getRuleIndex(self):
            return UserInputParser.RULE_path

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterPath"):
                listener.enterPath(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitPath"):
                listener.exitPath(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitPath"):
                return visitor.visitPath(self)
            else:
                return visitor.visitChildren(self)

    def path(self):

        localctx = UserInputParser.PathContext(self, self._ctx, self.state)
        self.enterRule(localctx, 12, self.RULE_path)
        self._la = 0  # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 61
            self.path_item()
            self.state = 66
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            while _la == UserInputParser.T__8:
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def name(self):
            return self.getTypedRuleContext(UserInputParser.NameContext, 0)

        def path_index(self, i: int = None):
            if i is None:
                return self.getTypedRuleContexts(UserInputParser.Path_indexContext)
            else:
                return self.getTypedRuleContext(UserInputParser.Path_indexContext, i)

        def getRuleIndex(self):
            return UserInputParser.RULE_path_item

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterPath_item"):
                listener.enterPath_item(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitPath_item"):
                listener.exitPath_item(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitPath_item"):
                return visitor.visitPath_item(self)
            else:
                return visitor.visitChildren(self)

    def path_item(self):

        localctx = UserInputParser.Path_itemContext(self, self._ctx, self.state)
        self.enterRule(localctx, 14, self.RULE_path_item)
        self._la = 0  # Token type
        try:
            self.enterOuterAlt(localctx, 1)
            self.state = 69
            self.name()
            self.state = 78
            self._errHandler.sync(self)
            _la = self._input.LA(1)
            if _la == UserInputParser.T__9:
                self.state = 70
                self.match(UserInputParser.T__9)
                self.state = 71
                self.path_index()
                self.state = 74
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la == UserInputParser.T__10:
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def INTEGER(self):
            return self.getToken(UserInputParser.INTEGER, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_path_index

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterPath_index"):
                listener.enterPath_index(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitPath_index"):
                listener.exitPath_index(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitPath_index"):
                return visitor.visitPath_index(self)
            else:
                return visitor.visitChildren(self)

    def path_index(self):

        localctx = UserInputParser.Path_indexContext(self, self._ctx, self.state)
        self.enterRule(localctx, 16, self.RULE_path_index)
        self._la = 0  # Token type
        try:
            self.state = 86
            self._errHandler.sync(self)
            token = self._input.LA(1)
            if token in [UserInputParser.INTEGER]:
                self.enterOuterAlt(localctx, 1)
                self.state = 80
                self.match(UserInputParser.INTEGER)
            elif token in [UserInputParser.T__12]:
                self.enterOuterAlt(localctx, 2)
                self.state = 81
                self.match(UserInputParser.T__12)
                self.state = 84
                self._errHandler.sync(self)
                _la = self._input.LA(1)
                if _la == UserInputParser.T__6:
                    self.state = 82
                    self.match(UserInputParser.T__6)
                    self.state = 83
                    self.match(UserInputParser.INTEGER)

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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def NAME(self):
            return self.getToken(UserInputParser.NAME, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_name

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterName"):
                listener.enterName(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitName"):
                listener.exitName(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitName"):
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser

        def getRuleIndex(self):
            return UserInputParser.RULE_stmt_end

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterStmt_end"):
                listener.enterStmt_end(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitStmt_end"):
                listener.exitStmt_end(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitStmt_end"):
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
            if token in [UserInputParser.T__13]:
                self.enterOuterAlt(localctx, 1)
                self.state = 90
                self.match(UserInputParser.T__13)
            elif token in [UserInputParser.EOF]:
                self.enterOuterAlt(localctx, 2)
                self.wasNewline()
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
        __slots__ = "parser"

        def __init__(self, parser, parent: ParserRuleContext = None, invokingState: int = -1):
            super().__init__(parent, invokingState)
            self.parser = parser
            self.atom_true = None  # Token
            self.atom_false = None  # Token
            self.atom_num = None  # FloatingContext
            self.atom_path = None  # PathContext

        def floating(self):
            return self.getTypedRuleContext(UserInputParser.FloatingContext, 0)

        def path(self):
            return self.getTypedRuleContext(UserInputParser.PathContext, 0)

        def getRuleIndex(self):
            return UserInputParser.RULE_formula_atom

        def enterRule(self, listener: ParseTreeListener):
            if hasattr(listener, "enterFormula_atom"):
                listener.enterFormula_atom(self)

        def exitRule(self, listener: ParseTreeListener):
            if hasattr(listener, "exitFormula_atom"):
                listener.exitFormula_atom(self)

        def accept(self, visitor: ParseTreeVisitor):
            if hasattr(visitor, "visitFormula_atom"):
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
            if token in [UserInputParser.T__14]:
                self.enterOuterAlt(localctx, 1)
                self.state = 94
                localctx.atom_true = self.match(UserInputParser.T__14)
            elif token in [UserInputParser.T__15]:
                self.enterOuterAlt(localctx, 2)
                self.state = 95
                localctx.atom_false = self.match(UserInputParser.T__15)
            elif token in [
                UserInputParser.T__6,
                UserInputParser.T__7,
                UserInputParser.INTEGER,
                UserInputParser.FLOATING,
            ]:
                self.enterOuterAlt(localctx, 3)
                self.state = 96
                localctx.atom_num = self.floating()
            elif token in [UserInputParser.NAME]:
                self.enterOuterAlt(localctx, 4)
                self.state = 97
                localctx.atom_path = self.path()
            else:
                raise NoViableAltException(self)

        except RecognitionException as re:
            localctx.exception = re
            self._errHandler.reportError(self, re)
            self._errHandler.recover(self, re)
        finally:
            self.exitRule()
        return localctx
