grammar Formula;
import Base;

formula: formula_add ;
formula_add: formula_sub (operator='+' formula_sub)* ;
formula_sub: formula_mul (operator='-' formula_mul)* ;
formula_mul: formula_div (operator='*' formula_div)* ;
formula_div: formula_pow (operator='/' formula_pow)* ;
formula_pow: formula_sign (operator='^' formula_sign)* ;
formula_sign: ('-' neg=formula_sign) | ('+' formula_sign) | ('(' formula ')') | formula_func | formula_atom ;
formula_func: fun=FUNCTION '(' formula (',' formula)* ')' ;
formula_atom: atom_true='true' | atom_false='false' | atom_num=floating | atom_path=path ;
