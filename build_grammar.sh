#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

grammar_path="$parent_path/src/coomsuite/utils/coom_grammar"

antlr4 -v 4.13.2 -Dlanguage=Python3 $grammar_path/model/Model.g4 -visitor

antlr4 -v 4.13.2 -Dlanguage=Python3 $grammar_path/user/UserInput.g4 -visitor
