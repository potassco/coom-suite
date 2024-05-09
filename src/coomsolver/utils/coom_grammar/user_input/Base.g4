grammar Base;

@parser::header {}

@parser::members {
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
}

constant: floating | name | 'true' | 'false';
floating:
	'-'? (FLOATING | INTEGER | '\u221e'); // == infinity symbol
//integer: '-'? INTEGER ;

// define path expressions
path: path_item ('.' path_item)*;
path_item: name ('[' path_index ('..' path_index)? ']')?;
path_index: INTEGER | ('last' ('-' INTEGER)?);

name: NAME | FUNCTION | KEYWORD;
stmt_end: ';' | {self.wasNewline()};

compare:
	'<'
	| '<='
	| '≤'
	| '>'
	| '>='
	| '≥'
	| '='
	| '=='
	| '!='
	| '≠'
	| '⊇'
	| 'contains';

// define lexical tokens
FUNCTION:
	'count'
	| 'min'
	| 'max'
	| 'sum'
	| 'delta'
	| 'pow'
	| 'sqrt'
	| 'ceil'
	| 'floor'
	| 'round'
	| 'mod'
	| 'log'
	| 'ln'
	| TRIGONOMETRIC;
TRIGONOMETRIC:
	'sin'
	| 'asin'
	| 'sinh'
	| 'cos'
	| 'acos'
	| 'cosh'
	| 'tan'
	| 'atan'
	| 'tanh';
BEHAVIOR: 'behavior';
CONDITION: 'condition';
IMPLY: 'imply';
REQUIRE: 'require';
DEFAULT: 'default';
KEYWORD:
	'last'
	| 'true'
	| 'false'
	| CONDITION
	| 'valid'
	| 'from'
	| 'to'
	| 'product'
	| 'structure'
	| 'enumeration'
	| BEHAVIOR
	| DEFAULT
	| IMPLY
	| REQUIRE
	| 'combinations'
	| 'allow'
	| 'forbid'
	| 'readwrite'
	| 'readonly'
	| 'hide'
	| 'attribute'
	| 'reference'
	| 'static';

NAME: (ALPHA ALPHANUMERIC*) | QUOTED_SINGLE | QUOTED_DOUBLE;

fragment ALPHANUMERIC: ALPHA | DIGIT;
fragment ALPHA:
	[_a-zA-Z$\u00A2-\u00A5\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02FF\u0370-\u037D\u037F-\u1FFF\u200C-\u200D\u2070-\u218F\u2C00-\u2FEF\u3001-\uD7FF\uF900-\uFDCF\uFDF0-\uFFFD]
		;
fragment DIGIT: [0-9];

fragment QUOTED_SINGLE: '\'' (ESC | ~['\\\u0000-\u001F])* '\'';
fragment QUOTED_DOUBLE: '"' (ESC | ~["\\\u0000-\u001F])* '"';

fragment ESC: '\\' (["\\/bfnrt] | UNICODE);
fragment UNICODE: 'u' HEX HEX HEX HEX;
fragment HEX: [0-9a-fA-F];

INTEGER: DIGIT+;
FLOATING: DIGIT+ ('.' DIGIT+)?;
TIMES: INTEGER 'x';

HASHES: '#'+;

// skip whitespaces, but get the newlines in a spearate channel

NEWLINE: [\r\n]+ -> channel(HIDDEN);
WHITESPACE: [ \t]+ -> skip;

// allow java-like comments, direct them into the comment channel

COMMENT: '//' ~[\n\r]* ( [\n\r] | EOF) -> channel(HIDDEN);
MULTILINE_COMMENT:
	'/*' (MULTILINE_COMMENT | .)*? ('*/' | EOF) -> channel(HIDDEN);
