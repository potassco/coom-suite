"""
Contains a dictionary with all clintest tests for preprocessing
and the corresponding files or programs they should be run with.

The key of the dictionary corresponds to the name of the test.

All tests run with clingo.
"""

from typing import Any

from . import SingleModelEquals

TESTS_PREPROCESS: dict[str, dict[str, Any]] = {
    "empty_product": {
        "test": SingleModelEquals({'part("product")', 'type("root","product")'}),
        "program": 'coom_structure("product").',
    }
    # "require_with_number": {
    #     "test": Assert(All(), ContainsTheory(('value("root.wheel[0].size[0]",27)'))),
    #     "files": ["require_with_number.lp"],
    # },
    # "require_with_number_ge": {
    #     "test": Assert(All(), ContainsTheory(('value("root.wheel[0].size[0]",28)'))),
    #     "ftest": Assert(All(), ContainsTheory('value("root.wheel[0].size[0]",28)', check_theory=True)),
    #     "files": ["require_with_number_ge.lp"],
    # },
    # "require_with_constant": {
    #     "test": Assert(All(), Contains(('value("root.wheel[0]","W28")'))),
    #     "files": ["require_with_constant.lp"],
    # },
    # "require_two_wheels": {
    #     "test": AndTest(
    #         Assert(
    #             Exact(1),
    #             SupersetOf({('value("root.frontWheel[0].size[0]",27)'), ('value("root.rearWheel[0].size[0]",27)')}),
    #         ),
    #         Assert(
    #             Exact(1),
    #             SupersetOf({('value("root.frontWheel[0].size[0]",28)'), ('value("root.rearWheel[0].size[0]",28)')}),
    #         ),
    #     ),
    #     "ftest": AndTest(
    #         Assert(
    #             Exact(1),
    #             SupersetOfTheory(
    #                 {('value("root.frontWheel[0].size[0]",27)'), ('value("root.rearWheel[0].size[0]",27)')},
    #                 check_theory=True,
    #             ),
    #         ),
    #         Assert(
    #             Exact(1),
    #             SupersetOfTheory(
    #                 {('value("root.frontWheel[0].size[0]",28)'), ('value("root.rearWheel[0].size[0]",28)')},
    #                 check_theory=True,
    #             ),
    #         ),
    #     ),
    #     "files": ["require_two_wheels.lp"],
    # },
    # "condition": {
    #     "test": Assert(
    #         All(), Implies(Contains('value("root.wheelSupport[0]","True")'), Contains('value("root.wheel[0]","Small")'))
    #     ),
    #     "files": ["condition.lp"],
    # },
    # "combination": {
    #     "test": AndTest(
    #         Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","False")', 'value("root.wheel[0]","W20")'})),
    #         Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","False")', 'value("root.wheel[0]","W18")'})),
    #         Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","True")', 'value("root.wheel[0]","W16")'})),
    #         Assert(Any(), SupersetOf({'value("root.wheelSupport[0]","True")', 'value("root.wheel[0]","W14")'})),
    #         NumModels(4),
    #     ),
    #     "files": ["combination.lp"],
    # },
    # "enumeration": {
    #     "test": AndTest(
    #         Assert(Exact(1), Contains('value("root.color[0]","Red")')),
    #         Assert(Exact(1), Contains('value("root.color[0]","Green")')),
    #         Assert(Exact(1), Contains('value("root.color[0]","Blue")')),
    #         NumModels(3),
    #     ),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","color","Color",1,1).
    #         coom_enumeration("Color").
    #         coom_option("Color", "Red").
    #         coom_option("Color", "Green").
    #         coom_option("Color", "Blue").""",
    # },
    # "bool_enumeration": {
    #     "test": AndTest(
    #         Assert(Exact(1), Contains('value("root.boolean[0]","True")')),
    #         Assert(Exact(1), Contains('value("root.boolean[0]","False")')),
    #         NumModels(2),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","boolean","Bool",1,1).""",
    # },
    # "attribute": {
    #     "test": Assert(
    #         Exact(1), SupersetOfTheory({'value("root.wheel[0].size[0]",14)', 'value("root.wheel[0]","W14")'})
    #     ),
    #     "ftest": Assert(
    #         Exact(1),
    #         SupersetOfTheory({'value("root.wheel[0].size[0]",14)', 'value("root.wheel[0]","W14")'}, check_theory=True),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","wheel","Wheel",1,1).
    #     coom_enumeration("Wheel").
    #     coom_attribute("Wheel","size","num").
    #     coom_option("Wheel", "W14").
    #     coom_attribute_value("Wheel","W14","size",14).""",
    # },
    # "structure": {
    #     "test": AndTest(
    #         Assert(Exact(1), Contains('include("root.wheel[0]")')),
    #         NumModels(1),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","wheel","Wheel",1,1).
    #     coom_structure("Wheel").""",
    # },
    # "structure_optional": {
    #     "test": AndTest(
    #         Assert(Exact(1), Contains('include("root.basket[0]")')),
    #         NumModels(2),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","basket","Basket",0,1).
    #     coom_structure("Basket").""",
    # },
    # "structure_nested": {
    #     "test": AndTest(
    #         Assert(
    #             Exact(1),
    #             SupersetOf({'include("root.carrier[0]")', 'include("root.carrier[0].bag[0]")'}),
    #         ),
    #         NumModels(1),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","carrier","Carrier",1,1).
    #     coom_structure("Carrier").
    #     coom_feature("Carrier","bag","Bag",1,1).
    #     coom_structure("Bag").""",
    # },
    # "structure_nested_optional": {
    #     "test": AndTest(
    #         Assert(Exact(3), Contains('include("root.carrier[0]")')),
    #         Assert(Exact(2), Contains('include("root.carrier[0].bag[0]")')),
    #         Assert(
    #             Exact(1),
    #             SupersetOf(
    #                 {
    #                     'include("root.carrier[0]")',
    #                     'include("root.carrier[0].bag[0]")',
    #                     'include("root.carrier[0].bag[1]")',
    #                 }
    #             ),
    #         ),
    #         NumModels(4),
    #     ),
    #     "program": """
    #     coom_structure("product").
    #     coom_feature("product","carrier","Carrier",0,1).
    #     coom_structure("Carrier").
    #     coom_feature("Carrier","bag","Bag",0,2).
    #     coom_structure("Bag").""",
    # },
    # "require_with_partonomy": {
    #     "test": Assert(All(), Contains('value("root.basket[0].color[0]","Red")')),
    #     "files": ["require_with_partonomy.lp"],
    # },
    # "require_multiple_instances": {
    #     "test": Assert(
    #         All(), SupersetOf({'value("root.wheel[0].size[0]","W28")', 'value("root.wheel[1].size[0]","W28")'})
    #     ),
    #     "files": ["require_multiple_instances.lp"],
    # },
    # "require_with_partonomy2": {
    #     "test": Assert(
    #         All(), SupersetOf({'value("root.bag[0].color[0]","Red")', 'value("root.bag[1].color[0]","Red")'})
    #     ),
    #     "files": ["require_with_partonomy2.lp"],
    # },
    # "require_with_partonomy_multiple_instances": {
    #     "test": Assert(
    #         All(),
    #         SupersetOf(
    #             {
    #                 'value("root.compartment[0].bag[0].color[0]","Red")',
    #                 'value("root.compartment[0].bag[1].color[0]","Red")',
    #                 'value("root.compartment[1].bag[0].color[0]","Red")',
    #                 'value("root.compartment[1].bag[1].color[0]","Red")',
    #             }
    #         ),
    #     ),
    #     "files": ["require_with_partonomy_multiple_instances.lp"],
    # },
    # "combination_with_structure": {
    #     "test": AndTest(
    #         NumModels(8),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.wheelSupport[0]","True")'),
    #                 And(
    #                     Or(
    #                         Contains('value("root.wheel[0].size[0]","W14")'),
    #                         Contains('value("root.wheel[0].size[0]","W16")'),
    #                     ),
    #                     Or(
    #                         Contains('value("root.wheel[1].size[0]","W14")'),
    #                         Contains('value("root.wheel[1].size[0]","W16")'),
    #                     ),
    #                 ),
    #             ),
    #         ),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.wheelSupport[0]","False")'),
    #                 And(
    #                     Or(
    #                         Contains('value("root.wheel[0].size[0]","W18")'),
    #                         Contains('value("root.wheel[0].size[0]","W20")'),
    #                     ),
    #                     Or(
    #                         Contains('value("root.wheel[1].size[0]","W18")'),
    #                         Contains('value("root.wheel[1].size[0]","W20")'),
    #                     ),
    #                 ),
    #             ),
    #         ),
    #     ),
    #     "files": ["combination_with_structure.lp"],
    # },
    # "combination_at_part_with_wildcard": {
    #     "test": AndTest(
    #         NumModels(5),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.wheel[0].size[0]","W30")'),
    #                 SupersetOf(
    #                     {
    #                         'value("root.wheel[0].material[0]","Aluminum")',
    #                         'value("root.wheel[1].material[0]","Aluminum")',
    #                     }
    #                 ),
    #             ),
    #         ),
    #     ),
    #     "files": ["combination_at_part_with_wildcard.lp"],
    # },
    # "combination_at_part_multiple_instances": {
    #     "test": AndTest(
    #         NumModels(4),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.bike[0].material[0]","Carbon")'),
    #                 SupersetOf(
    #                     {
    #                         'value("root.bike[0].wheel[0]","W28")',
    #                         'value("root.bike[0].wheel[1]","W28")',
    #                     }
    #                 ),
    #             ),
    #         ),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.bike[0].material[0]","Aluminum")'),
    #                 SupersetOf(
    #                     {
    #                         'value("root.bike[0].wheel[0]","W30")',
    #                         'value("root.bike[0].wheel[1]","W30")',
    #                     }
    #                 ),
    #             ),
    #         ),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.bike[1].material[0]","Carbon")'),
    #                 SupersetOf(
    #                     {
    #                         'value("root.bike[1].wheel[0]","W28")',
    #                         'value("root.bike[1].wheel[1]","W28")',
    #                     }
    #                 ),
    #             ),
    #         ),
    #         Assert(
    #             All(),
    #             Implies(
    #                 Contains('value("root.bike[1].material[0]","Aluminum")'),
    #                 SupersetOf(
    #                     {
    #                         'value("root.bike[1].wheel[0]","W30")',
    #                         'value("root.bike[1].wheel[1]","W30")',
    #                     }
    #                 ),
    #             ),
    #         ),
    #     ),
    #     "files": ["combination_at_part_multiple_instances.lp"],
    # },
    # "simple_numeric_feature": {
    #     "test": AndTest(
    #         Assert(Exact(1), Contains('value("root.size[0]",1)')),
    #         Assert(Exact(1), Contains('value("root.size[0]",2)')),
    #         Assert(Exact(1), Contains('value("root.size[0]",3)')),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), ContainsTheory('value("root.size[0]",1)', check_theory=True)),
    #         Assert(Exact(1), ContainsTheory('value("root.size[0]",2)', check_theory=True)),
    #         Assert(Exact(1), ContainsTheory('value("root.size[0]",3)', check_theory=True)),
    #     ),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","size","num",1,1).
    #         coom_range("product","size",1,3).""",
    # },
    # "simple_arithmetic_plus": {
    #     "test": AndTest(
    #         Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",3)'})),
    #         Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",4)'})),
    #         Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.b[0]",3)'})),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",3)'}, check_theory=True)),
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",4)'}, check_theory=True)),
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.b[0]",3)'}, check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_plus.lp"],
    # },
    # "simple_arithmetic_minus": {
    #     "test": AndTest(
    #         NumModels(1),
    #         Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",4)'})),
    #     ),
    #     "ftest": AndTest(
    #         NumModels(1),
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",4)'}, check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_minus.lp"],
    # },
    # "simple_arithmetic_multiplication": {
    #     "test": AndTest(
    #         NumModels(1),
    #         Assert(Exact(1), Equals({'value("root.a[0]",3)', 'value("root.b[0]",4)'})),
    #     ),
    #     "files": ["simple_arithmetic_multiplication.lp"],
    # },
    # "simple_arithmetic_plus_default_right": {
    #     "test": AndTest(
    #         Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), ContainsTheory('value("root.a[0]",2)', check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_plus_default_right.lp"],
    # },
    # "simple_arithmetic_plus_default_left": {
    #     "test": AndTest(
    #         Assert(Exact(1), Equals({'value("root.b[0]",2)'})),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), ContainsTheory('value("root.b[0]",2)', check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_plus_default_left.lp"],
    # },
    # "simple_arithmetic_minus_default_right": {
    #     "test": AndTest(
    #         Assert(Exact(1), Equals({'value("root.a[0]",2)'})),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), ContainsTheory('value("root.a[0]",2)', check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_minus_default_right.lp"],
    # },
    # "simple_arithmetic_minus_default_left": {
    #     "test": AndTest(
    #         Assert(Exact(1), Equals({'value("root.b[0]",2)'})),
    #     ),
    #     "ftest": AndTest(
    #         Assert(Exact(1), ContainsTheory('value("root.b[0]",2)', check_theory=True)),
    #     ),
    #     "files": ["simple_arithmetic_minus_default_left.lp"],
    # },
    # "parentheses": {
    #     "test": AndTest(
    #         NumModels(2),
    #         Assert(Exact(1), Equals({'value("root.a[0]",1)', 'value("root.b[0]",1)'})),
    #         Assert(Exact(1), Equals({'value("root.a[0]",2)', 'value("root.b[0]",2)'})),
    #     ),
    #     "ftest": AndTest(
    #         NumModels(2),
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",1)', 'value("root.b[0]",1)'}, check_theory=True)),
    #         Assert(Exact(1), SupersetOfTheory({'value("root.a[0]",2)', 'value("root.b[0]",2)'}, check_theory=True)),
    #     ),
    #     "files": ["parentheses.lp"],
    # },
    # "set_discrete": {
    #     "test": AndTest(NumModels(1), Assert(All(), Contains('value("root.color[0]","Yellow")'))),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","color","Color",1,1).
    #         coom_enumeration("Color").
    #         coom_option("Color","Red").
    #         coom_option("Color","Yellow").
    #         coom_user_value("root.color[0]","Yellow").""",
    # },
    # "set_num": {
    #     "test": AndTest(NumModels(1), Assert(All(), Contains('value("root.size[0]",5)'))),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","size","num",1,1).
    #         coom_range("product","size",1,10).
    #         coom_user_value("root.size[0]",5).""",
    # },
    # "add": {
    #     "test": AndTest(
    #         NumModels(2),
    #         Assert(All(), Contains('include("root.bag[0]")')),
    #         Assert(Exact(1), Contains('include("root.bag[1]")')),
    #     ),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","bag","Bag",0,2).
    #         coom_structure("Bag").
    #         coom_user_include("root.bag[0]").""",
    # },
    # "add2": {
    #     "test": AndTest(
    #         NumModels(1),
    #         Assert(All(), Contains('include("root.bag[0]")')),
    #         Assert(All(), Contains('include("root.bag[1]")')),
    #     ),
    #     "program": """
    #         coom_structure("product").
    #         coom_feature("product","bag","Bag",0,2).
    #         coom_structure("Bag").
    #         coom_user_include("root.bag[0]").
    #         coom_user_include("root.bag[1]").""",
    # },
}
