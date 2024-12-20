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
    },
    "structure_mandatory": {
        "test": SingleModelEquals(
            {
                'part("product")',
                'part("Wheel")',
                'constraint(("root.wheel",1),"lowerbound")',
                'index("root.wheel[0]",0)',
                'parent("root.wheel[0]","root")',
                'set("root.wheel","root.wheel[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","wheel","Wheel",1,1).
            coom_structure("Wheel").""",
    },
    "structure_optional": {
        "test": SingleModelEquals(
            {
                'part("product")',
                'part("Wheel")',
                'constraint(("root.wheel",0),"lowerbound")',
                'index("root.wheel[0]",0)',
                'parent("root.wheel[0]","root")',
                'set("root.wheel","root.wheel[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","wheel","Wheel",0,1).
            coom_structure("Wheel").""",
    },
    "structure_nested": {
        "test": SingleModelEquals(
            {
                'part("product")',
                'part("Carrier")',
                'part("Bag")',
                'constraint(("root.carrier",1),"lowerbound")',
                'constraint(("root.carrier[0].bag",1),"lowerbound")',
                'index("root.carrier[0]",0)',
                'index("root.carrier[0].bag[0]",0)',
                'parent("root.carrier[0]","root")',
                'parent("root.carrier[0].bag[0]","root.carrier[0]")',
                'set("root.carrier","root.carrier[0]")',
                'set("root.carrier[0].bag","root.carrier[0].bag[0]")',
                'type("root","product")',
                'type("root.carrier[0]","Carrier")',
                'type("root.carrier[0].bag[0]","Bag")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","carrier","Carrier",1,1).
            coom_structure("Carrier").
            coom_feature("Carrier","bag","Bag",1,1).
            coom_structure("Bag").""",
    },
    "structure_nested_optional": {
        "test": SingleModelEquals(
            {
                'part("product")',
                'part("Carrier")',
                'part("Bag")',
                'constraint(("root.carrier",0),"lowerbound")',
                'constraint(("root.carrier[0].bag",0),"lowerbound")',
                'index("root.carrier[0]",0)',
                'index("root.carrier[0].bag[0]",0)',
                'index("root.carrier[0].bag[1]",1)',
                'parent("root.carrier[0]","root")',
                'parent("root.carrier[0].bag[0]","root.carrier[0]")',
                'parent("root.carrier[0].bag[1]","root.carrier[0]")',
                'set("root.carrier","root.carrier[0]")',
                'set("root.carrier[0].bag","root.carrier[0].bag[0]")',
                'set("root.carrier[0].bag","root.carrier[0].bag[1]")',
                'type("root","product")',
                'type("root.carrier[0]","Carrier")',
                'type("root.carrier[0].bag[0]","Bag")',
                'type("root.carrier[0].bag[1]","Bag")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","carrier","Carrier",0,1).
            coom_structure("Carrier").
            coom_feature("Carrier","bag","Bag",0,2).
            coom_structure("Bag").""",
    },
    "enumeration": {
        "test": SingleModelEquals(
            {
                'discrete("Color")',
                'part("product")',
                'constraint(("root.color",1),"lowerbound")',
                'domain("Color","Red")',
                'domain("Color","Green")',
                'domain("Color","Blue")',
                'index("root.color[0]",0)',
                'parent("root.color[0]","root")',
                'set("root.color","root.color[0]")',
                'type("root","product")',
                'type("root.color[0]","Color")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","color","Color",1,1).
            coom_enumeration("Color").
            coom_option("Color", "Red").
            coom_option("Color", "Green").
            coom_option("Color", "Blue").""",
    },
    "bool_enumeration": {
        "test": SingleModelEquals(
            {
                'discrete("Bool")',
                'part("product")',
                'constraint(("root.boolean",1),"lowerbound")',
                'domain("Bool","True")',
                'domain("Bool","False")',
                'index("root.boolean[0]",0)',
                'parent("root.boolean[0]","root")',
                'set("root.boolean","root.boolean[0]")',
                'type("root","product")',
                'type("root.boolean[0]","Bool")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","boolean","Bool",1,1).""",
    },
    "attribute": {
        "test": SingleModelEquals(
            {
                'discrete("Wheel")',
                'integer("Wheel.size")',
                'part("product")',
                'constraint(("root.wheel",1),"lowerbound")',
                'constraint(("root.wheel[0].size",1),"lowerbound")',
                'constraint(("Wheel","root.wheel[0]"),"table")',
                'domain("Wheel","W14")',
                'index("root.wheel[0]",0)',
                'index("root.wheel[0].size[0]",0)',
                'parent("root.wheel[0]","root")',
                'parent("root.wheel[0].size[0]","root.wheel[0]")',
                'set("root.wheel","root.wheel[0]")',
                'set("root.wheel[0].size","root.wheel[0].size[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'type("root.wheel[0].size[0]","Wheel.size")',
                'allow("Wheel",(0,0),"W14")',
                'allow("Wheel",(1,0),14)',
                'range("Wheel.size",14,14)',
                'column(("Wheel","root.wheel[0]"),0,1,"root.wheel[0].size[0]")',
                'column(("Wheel","root.wheel[0]"),0,0,"root.wheel[0]")',
            }
        ),
        "program": """
            coom_structure("product").
            coom_feature("product","wheel","Wheel",1,1).
            coom_enumeration("Wheel").
            coom_attribute("Wheel","size","num").
            coom_option("Wheel", "W14").
            coom_attribute_value("Wheel","W14","size",14).""",
    },
    "require_with_number": {
        "test": SingleModelEquals(
            {
                'discrete("Wheel")',
                'integer("Wheel.size")',
                'part("product")',
                'constraint(("root.wheel",1),"lowerbound")',
                'constraint(("root.wheel[0].size",1),"lowerbound")',
                'constraint(("Wheel","root.wheel[0]"),"table")',
                'constraint((0,"root.wheel[0].size[0]=27"),"boolean")',
                'domain("Wheel","W27")',
                'domain("Wheel","W28")',
                'index("root.wheel[0]",0)',
                'index("root.wheel[0].size[0]",0)',
                'number("27",27)',
                'parent("root.wheel[0]","root")',
                'parent("root.wheel[0].size[0]","root.wheel[0]")',
                'set("root.wheel","root.wheel[0]")',
                'set("root.wheel[0].size","root.wheel[0].size[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'type("root.wheel[0].size[0]","Wheel.size")',
                'allow("Wheel",(0,0),"W27")',
                'allow("Wheel",(0,1),"W28")',
                'allow("Wheel",(1,1),28)',
                'allow("Wheel",(1,0),27)',
                'range("Wheel.size",27,28)',
                'binary("root.wheel[0].size[0]=27","root.wheel[0].size[0]","=","27")',
                'column(("Wheel","root.wheel[0]"),0,1,"root.wheel[0].size[0]")',
                'column(("Wheel","root.wheel[0]"),0,0,"root.wheel[0]")',
            }
        ),
        "files": ["require_with_number.lp"],
    },
    "require_with_number_ge": {
        "test": SingleModelEquals(
            {
                'discrete("Wheel")',
                'integer("Wheel.size")',
                'part("product")',
                'constraint(("root.wheel",1),"lowerbound")',
                'constraint(("root.wheel[0].size",1),"lowerbound")',
                'constraint(("Wheel","root.wheel[0]"),"table")',
                'constraint((0,"root.wheel[0].size[0]>=28"),"boolean")',
                'domain("Wheel","W27")',
                'domain("Wheel","W28")',
                'index("root.wheel[0]",0)',
                'index("root.wheel[0].size[0]",0)',
                'number("28",28)',
                'parent("root.wheel[0]","root")',
                'parent("root.wheel[0].size[0]","root.wheel[0]")',
                'set("root.wheel","root.wheel[0]")',
                'set("root.wheel[0].size","root.wheel[0].size[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'type("root.wheel[0].size[0]","Wheel.size")',
                'allow("Wheel",(0,0),"W27")',
                'allow("Wheel",(0,1),"W28")',
                'allow("Wheel",(1,1),28)',
                'allow("Wheel",(1,0),27)',
                'range("Wheel.size",27,28)',
                'binary("root.wheel[0].size[0]>=28","root.wheel[0].size[0]",">=","28")',
                'column(("Wheel","root.wheel[0]"),0,1,"root.wheel[0].size[0]")',
                'column(("Wheel","root.wheel[0]"),0,0,"root.wheel[0]")',
            }
        ),
        "files": ["require_with_number_ge.lp"],
    },
    "require_with_constant": {
        "test": SingleModelEquals(
            {
                'constant("W28")',
                'discrete("Wheel")',
                'part("product")',
                'constraint(("root.wheel",1),"lowerbound")',
                'constraint((0,"root.wheel[0]=W28"),"boolean")',
                'domain("Wheel","W27")',
                'domain("Wheel","W28")',
                'index("root.wheel[0]",0)',
                'parent("root.wheel[0]","root")',
                'set("root.wheel","root.wheel[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'binary("root.wheel[0]=W28","root.wheel[0]","=","W28")',
            }
        ),
        "files": ["require_with_constant.lp"],
    },
    "require_two_wheels": {
        "test": SingleModelEquals(
            {
                'discrete("Wheel")',
                'integer("Wheel.size")',
                'part("product")',
                'constraint(("root.frontWheel",1),"lowerbound")',
                'constraint(("root.rearWheel",1),"lowerbound")',
                'constraint(("root.frontWheel[0].size",1),"lowerbound")',
                'constraint(("root.rearWheel[0].size",1),"lowerbound")',
                'constraint(("Wheel","root.frontWheel[0]"),"table")',
                'constraint(("Wheel","root.rearWheel[0]"),"table")',
                'constraint((0,"root.frontWheel[0].size[0]=root.rearWheel[0].size[0]"),"boolean")',
                'domain("Wheel","W27")',
                'domain("Wheel","W28")',
                'index("root.frontWheel[0]",0)',
                'index("root.rearWheel[0]",0)',
                'index("root.rearWheel[0].size[0]",0)',
                'index("root.frontWheel[0].size[0]",0)',
                'parent("root.frontWheel[0]","root")',
                'parent("root.rearWheel[0]","root")',
                'parent("root.rearWheel[0].size[0]","root.rearWheel[0]")',
                'parent("root.frontWheel[0].size[0]","root.frontWheel[0]")',
                'set("root.frontWheel","root.frontWheel[0]")',
                'set("root.rearWheel","root.rearWheel[0]")',
                'set("root.frontWheel[0].size","root.frontWheel[0].size[0]")',
                'set("root.rearWheel[0].size","root.rearWheel[0].size[0]")',
                'type("root","product")',
                'type("root.frontWheel[0]","Wheel")',
                'type("root.rearWheel[0]","Wheel")',
                'type("root.frontWheel[0].size[0]","Wheel.size")',
                'type("root.rearWheel[0].size[0]","Wheel.size")',
                'allow("Wheel",(0,0),"W27")',
                'allow("Wheel",(0,1),"W28")',
                'allow("Wheel",(1,1),28)',
                'allow("Wheel",(1,0),27)',
                'range("Wheel.size",27,28)',
                'binary("root.frontWheel[0].size[0]=root.rearWheel[0].size[0]","root.frontWheel[0].size[0]","=","root.rearWheel[0].size[0]")',
                'column(("Wheel","root.frontWheel[0]"),0,1,"root.frontWheel[0].size[0]")',
                'column(("Wheel","root.rearWheel[0]"),0,1,"root.rearWheel[0].size[0]")',
                'column(("Wheel","root.frontWheel[0]"),0,0,"root.frontWheel[0]")',
                'column(("Wheel","root.rearWheel[0]"),0,0,"root.rearWheel[0]")',
            }
        ),
        "files": ["require_two_wheels.lp"],
    },
    "conditional_require": {
        "test": SingleModelEquals(
            {
                'constant("True")',
                'constant("Small")',
                'discrete("Wheel")',
                'discrete("Bool")',
                'part("product")',
                'constraint(("root.wheel",1),"lowerbound")',
                'constraint(("root.wheelSupport",1),"lowerbound")',
                'constraint((0,"!root.wheelSupport[0]=True||root.wheel[0]=Small"),"boolean")',
                'domain("Wheel","Small")',
                'domain("Wheel","Large")',
                'domain("Bool","True")',
                'domain("Bool","False")',
                'index("root.wheel[0]",0)',
                'index("root.wheelSupport[0]",0)',
                'parent("root.wheel[0]","root")',
                'parent("root.wheelSupport[0]","root")',
                'set("root.wheel","root.wheel[0]")',
                'set("root.wheelSupport","root.wheelSupport[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'type("root.wheelSupport[0]","Bool")',
                'unary("!root.wheelSupport[0]=True","!","root.wheelSupport[0]=True")',
                'binary("root.wheel[0]=Small","root.wheel[0]","=","Small")',
                'binary("root.wheelSupport[0]=True","root.wheelSupport[0]","=","True")',
                'binary("!root.wheelSupport[0]=True||root.wheel[0]=Small","!root.wheelSupport[0]=True","||","root.wheel[0]=Small")',
            }
        ),
        "files": ["conditional_require.lp"],
    },
    "require_multiple_instances": {
        "test": SingleModelEquals(
            {
                'constant("W28")',
                'discrete("Size")',
                'part("product")',
                'part("Wheel")',
                'constraint(("root.wheel",2),"lowerbound")',
                'constraint(("root.wheel[0].size",1),"lowerbound")',
                'constraint(("root.wheel[1].size",1),"lowerbound")',
                'constraint((0,"root.wheel[0].size[0]=W28"),"boolean")',
                'constraint((0,"root.wheel[1].size[0]=W28"),"boolean")',
                'domain("Size","W27")',
                'domain("Size","W28")',
                'index("root.wheel[0]",0)',
                'index("root.wheel[1]",1)',
                'index("root.wheel[1].size[0]",0)',
                'index("root.wheel[0].size[0]",0)',
                'parent("root.wheel[0]","root")',
                'parent("root.wheel[1]","root")',
                'parent("root.wheel[1].size[0]","root.wheel[1]")',
                'parent("root.wheel[0].size[0]","root.wheel[0]")',
                'set("root.wheel","root.wheel[0]")',
                'set("root.wheel","root.wheel[1]")',
                'set("root.wheel[0].size","root.wheel[0].size[0]")',
                'set("root.wheel[1].size","root.wheel[1].size[0]")',
                'type("root","product")',
                'type("root.wheel[0]","Wheel")',
                'type("root.wheel[1]","Wheel")',
                'type("root.wheel[1].size[0]","Size")',
                'type("root.wheel[0].size[0]","Size")',
                'binary("root.wheel[1].size[0]=W28","root.wheel[1].size[0]","=","W28")',
                'binary("root.wheel[0].size[0]=W28","root.wheel[0].size[0]","=","W28")',
            }
        ),
        "files": ["require_multiple_instances.lp"],
    },
    "require_with_partonomy": {
        "test": SingleModelEquals(
            {
                'constant("Red")',
                'discrete("Color")',
                'part("product")',
                'part("Basket")',
                'constraint(("root.basket",1),"lowerbound")',
                'constraint(("root.basket[0].color",1),"lowerbound")',
                'constraint((0,"root.basket[0].color[0]=Red"),"boolean")',
                'domain("Color","Red")',
                'domain("Color","Yellow")',
                'index("root.basket[0]",0)',
                'index("root.basket[0].color[0]",0)',
                'parent("root.basket[0]","root")',
                'parent("root.basket[0].color[0]","root.basket[0]")',
                'set("root.basket","root.basket[0]")',
                'set("root.basket[0].color","root.basket[0].color[0]")',
                'type("root","product")',
                'type("root.basket[0]","Basket")',
                'type("root.basket[0].color[0]","Color")',
                'binary("root.basket[0].color[0]=Red","root.basket[0].color[0]","=","Red")',
            }
        ),
        "files": ["require_with_partonomy.lp"],
    },
    "require_with_partonomy2": {
        "test": SingleModelEquals(
            {
                'constant("Red")',
                'discrete("Color")',
                'part("product")',
                'part("Bag")',
                'constraint(("root.bag",2),"lowerbound")',
                'constraint(("root.bag[0].color",1),"lowerbound")',
                'constraint(("root.bag[1].color",1),"lowerbound")',
                'constraint((0,"root.bag[0].color[0]=Red"),"boolean")',
                'constraint((0,"root.bag[1].color[0]=Red"),"boolean")',
                'domain("Color","Red")',
                'domain("Color","Yellow")',
                'index("root.bag[0]",0)',
                'index("root.bag[1]",1)',
                'index("root.bag[1].color[0]",0)',
                'index("root.bag[0].color[0]",0)',
                'parent("root.bag[0]","root")',
                'parent("root.bag[1]","root")',
                'parent("root.bag[1].color[0]","root.bag[1]")',
                'parent("root.bag[0].color[0]","root.bag[0]")',
                'set("root.bag","root.bag[0]")',
                'set("root.bag","root.bag[1]")',
                'set("root.bag[0].color","root.bag[0].color[0]")',
                'set("root.bag[1].color","root.bag[1].color[0]")',
                'type("root","product")',
                'type("root.bag[0]","Bag")',
                'type("root.bag[1]","Bag")',
                'type("root.bag[1].color[0]","Color")',
                'type("root.bag[0].color[0]","Color")',
                'binary("root.bag[1].color[0]=Red","root.bag[1].color[0]","=","Red")',
                'binary("root.bag[0].color[0]=Red","root.bag[0].color[0]","=","Red")',
            }
        ),
        "files": ["require_with_partonomy2.lp"],
    },
    "require_with_partonomy_multiple_instances": {
        "test": SingleModelEquals(
            {
                'constant("Red")',
                'discrete("Color")',
                'part("product")',
                'part("Compartment")',
                'part("Bag")',
                'constraint(("root.compartment",2),"lowerbound")',
                'constraint(("root.compartment[0].bag",2),"lowerbound")',
                'constraint(("root.compartment[1].bag",2),"lowerbound")',
                'constraint(("root.compartment[1].bag[0].color",1),"lowerbound")',
                'constraint(("root.compartment[1].bag[1].color",1),"lowerbound")',
                'constraint(("root.compartment[0].bag[0].color",1),"lowerbound")',
                'constraint(("root.compartment[0].bag[1].color",1),"lowerbound")',
                'constraint((0,"root.compartment[0].bag[0].color[0]=Red"),"boolean")',
                'constraint((0,"root.compartment[0].bag[1].color[0]=Red"),"boolean")',
                'constraint((0,"root.compartment[1].bag[0].color[0]=Red"),"boolean")',
                'constraint((0,"root.compartment[1].bag[1].color[0]=Red"),"boolean")',
                'domain("Color","Red")',
                'domain("Color","Yellow")',
                'domain("Color","Green")',
                'index("root.compartment[0]",0)',
                'index("root.compartment[1]",1)',
                'index("root.compartment[1].bag[0]",0)',
                'index("root.compartment[1].bag[1]",1)',
                'index("root.compartment[0].bag[0]",0)',
                'index("root.compartment[0].bag[1]",1)',
                'index("root.compartment[0].bag[1].color[0]",0)',
                'index("root.compartment[0].bag[0].color[0]",0)',
                'index("root.compartment[1].bag[1].color[0]",0)',
                'index("root.compartment[1].bag[0].color[0]",0)',
                'parent("root.compartment[0]","root")',
                'parent("root.compartment[1]","root")',
                'parent("root.compartment[1].bag[0]","root.compartment[1]")',
                'parent("root.compartment[1].bag[1]","root.compartment[1]")',
                'parent("root.compartment[0].bag[0]","root.compartment[0]")',
                'parent("root.compartment[0].bag[1]","root.compartment[0]")',
                'parent("root.compartment[0].bag[1].color[0]","root.compartment[0].bag[1]")',
                'parent("root.compartment[0].bag[0].color[0]","root.compartment[0].bag[0]")',
                'parent("root.compartment[1].bag[1].color[0]","root.compartment[1].bag[1]")',
                'parent("root.compartment[1].bag[0].color[0]","root.compartment[1].bag[0]")',
                'set("root.compartment","root.compartment[0]")',
                'set("root.compartment","root.compartment[1]")',
                'set("root.compartment[0].bag","root.compartment[0].bag[0]")',
                'set("root.compartment[0].bag","root.compartment[0].bag[1]")',
                'set("root.compartment[1].bag","root.compartment[1].bag[0]")',
                'set("root.compartment[1].bag","root.compartment[1].bag[1]")',
                'set("root.compartment[1].bag[0].color","root.compartment[1].bag[0].color[0]")',
                'set("root.compartment[1].bag[1].color","root.compartment[1].bag[1].color[0]")',
                'set("root.compartment[0].bag[0].color","root.compartment[0].bag[0].color[0]")',
                'set("root.compartment[0].bag[1].color","root.compartment[0].bag[1].color[0]")',
                'type("root","product")',
                'type("root.compartment[0]","Compartment")',
                'type("root.compartment[1]","Compartment")',
                'type("root.compartment[1].bag[0]","Bag")',
                'type("root.compartment[1].bag[1]","Bag")',
                'type("root.compartment[0].bag[0]","Bag")',
                'type("root.compartment[0].bag[1]","Bag")',
                'type("root.compartment[0].bag[1].color[0]","Color")',
                'type("root.compartment[0].bag[0].color[0]","Color")',
                'type("root.compartment[1].bag[1].color[0]","Color")',
                'type("root.compartment[1].bag[0].color[0]","Color")',
                'binary("root.compartment[1].bag[1].color[0]=Red","root.compartment[1].bag[1].color[0]","=","Red")',
                'binary("root.compartment[1].bag[0].color[0]=Red","root.compartment[1].bag[0].color[0]","=","Red")',
                'binary("root.compartment[0].bag[1].color[0]=Red","root.compartment[0].bag[1].color[0]","=","Red")',
                'binary("root.compartment[0].bag[0].color[0]=Red","root.compartment[0].bag[0].color[0]","=","Red")',
            }
        ),
        "files": ["require_with_partonomy_multiple_instances.lp"],
    },
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
