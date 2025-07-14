#!/bin/bash

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

cd "$parent_path"

antlr4 -v 4.9.3 -Dlanguage=Python3 model/Model.g4 -visitor

antlr4 -v 4.9.3 -Dlanguage=Python3 user/UserInput.g4 -visitor
