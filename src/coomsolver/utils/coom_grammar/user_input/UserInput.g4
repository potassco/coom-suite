/*
 Grammar to define user input (customer product requirements)
 */

grammar UserInput;
import Base, Formula;

user_input: (input_block | input_operation)* EOF;

input_block: 'blockinput' path '{' input_operation* '}';

input_operation: set_value | add_instance;

set_value: op = 'set' path '=' formula_atom;
add_instance: op = 'add' INTEGER? path;
