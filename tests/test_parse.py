"""
Test cases for the parser from COOM to ASP.
"""

from unittest import TestCase

from . import parse_coom


class TestCOOMUserParser(TestCase):
    """
    Test cases for COOM User input to ASP parser.
    """

    def test_set(self) -> None:
        """
        Test parsing the 'set' keyword
        used for setting values.
        """
        self.assertEqual(parse_coom("set color[0] = Red", grammar="user"), ['user_value("root.color[0]","Red").'])
        self.assertEqual(
            parse_coom("set frontWheel[0].size[0] = 23", grammar="user"),
            ['user_value("root.frontWheel[0].size[0]",23).'],
        )

    def test_add(self) -> None:
        """
        Test parsing the 'add' keyword
        used for adding instances of objects.
        """
        self.assertEqual(parse_coom("add basket[0]", grammar="user"), ['user_include("root.basket[0]").'])
        self.assertEqual(
            parse_coom("add wheels[0] add wheels[1]", grammar="user"),
            ['user_include("root.wheels[0]").', 'user_include("root.wheels[1]").'],
        )

    def test_blockinput(self) -> None:
        """
        Test parsing a user input block.
        """
        self.assertEqual(
            parse_coom("blockinput basket[0] {set color[0] = Yellow}", grammar="user"),
            ['user_value("root.basket[0].color[0]","Yellow").'],
        )


class TestCOOMModelParser(TestCase):
    """
    Test cases for COOM Model to ASP parser.
    """

    def test_product(self) -> None:
        """
        Test parsing the 'product' keyword.
        """
        self.assertEqual(parse_coom("product{}"), ['structure("product").'])

    def test_structure(self) -> None:
        """
        Test parsing the 'structure' keyword.
        """
        self.assertEqual(parse_coom("structure Test {}"), ['structure("Test").'])

    def test_feature(self) -> None:
        """
        Test parsing the 'feature' keyword.
        """
        self.assertEqual(
            parse_coom("product{Wheel wheel Frame frame}"),
            [
                'structure("product").',
                'feature("product","wheel","Wheel",1,1).',
                'feature("product","frame","Frame",1,1).',
            ],
        )
        self.assertEqual(
            parse_coom("structure Carrier {0..3 Bag bag}"),
            ['structure("Carrier").', 'feature("Carrier","bag","Bag",0,3).'],
        )
        self.assertEqual(
            parse_coom("structure Carrier {2..* Bag bag}"),
            ['structure("Carrier").', 'feature("Carrier","bag","Bag",2,#sup).'],
        )
        self.assertEqual(
            parse_coom("structure Carrier {5x Bag bag}"),
            ['structure("Carrier").', 'feature("Carrier","bag","Bag",5,5).'],
        )
        self.assertEqual(
            parse_coom("product{num	1-100 totalWeight}"),
            [
                'structure("product").',
                'feature("product","totalWeight","num",1,1).',
                'range("product","totalWeight",1,100).',
            ],
        )
        self.assertEqual(
            parse_coom("product{num	-100-10 totalWeight}"),
            [
                'structure("product").',
                'feature("product","totalWeight","num",1,1).',
                'range("product","totalWeight",-100,10).',
            ],
        )
        self.assertEqual(
            parse_coom("product{num 0-∞ totalWeight}"),
            [
                'structure("product").',
                'feature("product","totalWeight","num",1,1).',
                'range("product","totalWeight",0,#sup).',
            ],
        )
        self.assertEqual(
            parse_coom("product{num -∞-1000 totalWeight}"),
            [
                'structure("product").',
                'feature("product","totalWeight","num",1,1).',
                'range("product","totalWeight",#inf,1000).',
            ],
        )

        self.assertEqual(parse_coom("product{string id}"), ['structure("product").'])

    def test_enumeration(self) -> None:
        """
        Test parsing the 'enumeration' keyword.
        """
        self.assertEqual(
            parse_coom("enumeration Color {Red Green Yellow Blue}"),
            [
                'enumeration("Color").',
                'option("Color", "Red").',
                'option("Color", "Green").',
                'option("Color", "Yellow").',
                'option("Color", "Blue").',
            ],
        )
        self.assertEqual(
            parse_coom(
                """\
                enumeration Capacity {
                        attribute num/l volume
                        attribute num/gr weight
                        B10  = ( 10,  100)
                        B20  = ( 20,  250)
                    }"""
            ),
            [
                'enumeration("Capacity").',
                'attribute("Capacity","volume","num").',
                'attribute("Capacity","weight","num").',
                'option("Capacity", "B10").',
                'attribute_value("Capacity","B10","volume",10).',
                'attribute_value("Capacity","B10","weight",100).',
                'option("Capacity", "B20").',
                'attribute_value("Capacity","B20","volume",20).',
                'attribute_value("Capacity","B20","weight",250).',
            ],
        )

        self.assertEqual(
            parse_coom(
                """\
                enumeration Size {
                        attribute color
                        Small  = ( Red )
                        Big    = ( Blue )
                    }"""
            ),
            [
                'enumeration("Size").',
                'attribute("Size","color","str").',
                'option("Size", "Small").',
                'attribute_value("Size","Small","color","Red").',
                'option("Size", "Big").',
                'attribute_value("Size","Big","color","Blue").',
            ],
        )

    def test_behavior(self) -> None:
        """
        Test parsing the 'behavior' keyword.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior Bag {require a = b}"),
            [
                "behavior(0).",
                'context(0,"Bag").',
                'require(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {require color = Red}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"color=Red").',
                'binary("color=Red","color","=","Red").',
                'path("color",0,"color").',
                'constant("Red").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {default color = red}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'default(0,"color","red").',
                'path("color",0,"color").',
                'path("red",0,"red").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b require c = d}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                "behavior(1).",
                'context(1,"product").',
                'require(1,"c=d").',
                'binary("c=d","c","=","d").',
                'path("c",0,"c").',
                'path("d",0,"d").',
            ],
        )

        self.assertEqual(
            parse_coom(
                """behavior {
                            combinations  (wheelSupport	 rearWheel)
                            allow         (True          (W14, W16))
                            allow         (False         (W18, W20))}"""
            ),
            [
                "behavior(0).",
                'context(0,"product").',
                'combinations(0,0,"wheelSupport").',
                'combinations(0,1,"rearWheel").',
                'path("wheelSupport",0,"wheelSupport").',
                'path("rearWheel",0,"rearWheel").',
                'allow(0,(0,0),"True").',
                'allow(0,(1,0),"W14").',
                'allow(0,(1,0),"W16").',
                'allow(0,(0,1),"False").',
                'allow(0,(1,1),"W18").',
                'allow(0,(1,1),"W20").',
            ],
        )

        self.assertEqual(
            parse_coom(
                """behavior {
                            combinations  (color	 size)
                            allow         (Red       -*-)
                            allow         (Yellow    S)}"""
            ),
            [
                "behavior(0).",
                'context(0,"product").',
                'combinations(0,0,"color").',
                'combinations(0,1,"size").',
                'path("color",0,"color").',
                'path("size",0,"size").',
                'allow(0,(0,0),"Red").',
                'allow(0,(0,1),"Yellow").',
                'allow(0,(1,1),"S").',
            ],
        )

        self.assertEqual(
            parse_coom(
                """behavior Bike {
                            combinations  (wheelSupport	 rearWheel)
                            allow         (True          (W14, W16))
                            allow         (False         (W18, W20))}"""
            ),
            [
                "behavior(0).",
                'context(0,"Bike").',
                'combinations(0,0,"wheelSupport").',
                'combinations(0,1,"rearWheel").',
                'path("wheelSupport",0,"wheelSupport").',
                'path("rearWheel",0,"rearWheel").',
                'allow(0,(0,0),"True").',
                'allow(0,(1,0),"W14").',
                'allow(0,(1,0),"W16").',
                'allow(0,(0,1),"False").',
                'allow(0,(1,1),"W18").',
                'allow(0,(1,1),"W20").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {condition a = b require c > 5}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'condition(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'require(0,"c>5").',
                'binary("c>5","c",">","5").',
                'path("c",0,"c").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {condition a = b default c = d}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'condition(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'default(0,"c","d").',
                'path("c",0,"c").',
                'path("d",0,"d").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{imply a = b}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'imply(0,"a","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(parse_coom("behavior{readonly totalWeight}"), [])

    def test_condition(self) -> None:
        """
        Test parsing the 'condition' keyword.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b || a = c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b||a=c").',
                'binary("a=b||a=c","a=b","||","a=c").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'binary("a=c","a","=","c").',
                'path("a",0,"a").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b || a = c || a = d}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b||a=c||a=d").',
                'binary("a=b||a=c||a=d","a=b","||","a=c||a=d").',
                'binary("a=c||a=d","a=c","||","a=d").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'binary("a=c","a","=","c").',
                'path("a",0,"a").',
                'path("c",0,"c").',
                'binary("a=d","a","=","d").',
                'path("a",0,"a").',
                'path("d",0,"d").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b && a = c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b&&a=c").',
                'binary("a=b&&a=c","a=b","&&","a=c").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'binary("a=c","a","=","c").',
                'path("a",0,"a").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b && a = c && a = d}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b&&a=c&&a=d").',
                'binary("a=b&&a=c&&a=d","a=b","&&","a=c&&a=d").',
                'binary("a=c&&a=d","a=c","&&","a=d").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
                'binary("a=c","a","=","c").',
                'path("a",0,"a").',
                'path("c",0,"c").',
                'binary("a=d","a","=","d").',
                'path("a",0,"a").',
                'path("d",0,"d").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require ! a = b }"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"!a=b").',
                'unary("!a=b","!","a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require (a = b) }"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"(a=b)").',
                'unary("(a=b)","()","a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )

    def test_formula(self) -> None:
        """
        Test parsing behavior with arithmetic formulas.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b + c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b+c").',
                'binary("a=b+c","a","=","b+c").',
                'path("a",0,"a").',
                'binary("b+c","b","+","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b - c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b-c").',
                'binary("a=b-c","a","=","b-c").',
                'path("a",0,"a").',
                'binary("b-c","b","-","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b * c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b*c").',
                'binary("a=b*c","a","=","b*c").',
                'path("a",0,"a").',
                'binary("b*c","b","*","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )
        self.assertEqual(
            parse_coom("behavior{require a = b / c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b/c").',
                'binary("a=b/c","a","=","b/c").',
                'path("a",0,"a").',
                'binary("b/c","b","/","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b ^ c}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b^c").',
                'binary("a=b^c","a","=","b^c").',
                'path("a",0,"a").',
                'binary("b^c","b","^","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = - b}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=-b").',
                'binary("a=-b","a","=","-b").',
                'path("a",0,"a").',
                'unary("-b","-","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = + b}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=+b").',
                'binary("a=+b","a","=","+b").',
                'path("a",0,"a").',
                'unary("+b","+","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = (b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=(b)").',
                'binary("a=(b)","a","=","(b)").',
                'path("a",0,"a").',
                'unary("(b)","()","b").',
                'path("b",0,"b").',
            ],
        )

    def test_function(self) -> None:
        """
        Test parsing behavior with functions.
        """

        self.assertEqual(
            parse_coom("behavior{require a = sum(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=sum(b)").',
                'binary("a=sum(b)","a","=","sum(b)").',
                'path("a",0,"a").',
                'function("product","sum(b)","sum","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = sum(b,c)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=sum(b,c)").',
                'binary("a=sum(b,c)","a","=","sum(b,c)").',
                'path("a",0,"a").',
                'function("product","sum(b,c)","sum","b").',
                'function("product","sum(b,c)","sum","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = count(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=count(b)").',
                'binary("a=count(b)","a","=","count(b)").',
                'path("a",0,"a").',
                'function("product","count(b)","count","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = count(b,c)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=count(b,c)").',
                'binary("a=count(b,c)","a","=","count(b,c)").',
                'path("a",0,"a").',
                'function("product","count(b,c)","count","b").',
                'function("product","count(b,c)","count","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )
        self.assertEqual(
            parse_coom("behavior{require a = min(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=min(b)").',
                'binary("a=min(b)","a","=","min(b)").',
                'path("a",0,"a").',
                'function("product","min(b)","min","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = min(b,c)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=min(b,c)").',
                'binary("a=min(b,c)","a","=","min(b,c)").',
                'path("a",0,"a").',
                'function("product","min(b,c)","min","b").',
                'function("product","min(b,c)","min","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = max(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=max(b)").',
                'binary("a=max(b)","a","=","max(b)").',
                'path("a",0,"a").',
                'function("product","max(b)","max","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = max(b,c)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=max(b,c)").',
                'binary("a=max(b,c)","a","=","max(b,c)").',
                'path("a",0,"a").',
                'function("product","max(b,c)","max","b").',
                'function("product","max(b,c)","max","c").',
                'path("b",0,"b").',
                'path("c",0,"c").',
            ],
        )

        # self.assertEqual(
        #     parse_coom("behavior{require a = delta(b)}"),
        #     [
        #         "behavior(0).",
        #         'context(0,"product").',
        #         'require(0,"a=delta(b)").',
        #         'binary("a=delta(b)","a","=","delta(b)").',
        #         'path("a",0,"a").',
        #         'unary("product","delta(b)","delta","b").',
        #         'path("b",0,"b").',
        #     ],
        # )

        # self.assertEqual(
        #     parse_coom("behavior{require a = delta(b,c)}"),
        #     [
        #         "behavior(0).",
        #         'context(0,"product").',
        #         'require(0,"a=delta(b,c)").',
        #         'binary("a=delta(b,c)","a","=","delta(b,c)").',
        #         'path("a",0,"a").',
        #         'function("product","delta(b,c)","delta","b").',
        #         'function("product","delta(b,c)","delta","c").',
        #         'path("b",0,"b").',
        #         'path("c",0,"c").',
        #     ],
        # )

        # self.assertEqual(
        #     parse_coom("behavior{require a = pow(b)}"),
        #     [
        #         "behavior(0).",
        #         'context(0,"product").',
        #         'require(0,"a=pow(b)").',
        #         'binary("a=pow(b)","a","=","pow(b)").',
        #         'path("a",0,"a").',
        #         'function("product","pow(b)","pow","b").',
        #         'path("b",0,"b").',
        #     ],
        # )

        self.assertEqual(
            parse_coom("behavior{require a = sqrt(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=sqrt(b)").',
                'binary("a=sqrt(b)","a","=","sqrt(b)").',
                'path("a",0,"a").',
                'unary("sqrt(b)","sqrt","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = ceil(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=ceil(b)").',
                'binary("a=ceil(b)","a","=","ceil(b)").',
                'path("a",0,"a").',
                'unary("ceil(b)","ceil","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = floor(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=floor(b)").',
                'binary("a=floor(b)","a","=","floor(b)").',
                'path("a",0,"a").',
                'unary("floor(b)","floor","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = round(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=round(b)").',
                'binary("a=round(b)","a","=","round(b)").',
                'path("a",0,"a").',
                'unary("round(b)","round","b").',
                'path("b",0,"b").',
            ],
        )

        # self.assertEqual(
        #     parse_coom("behavior{require a = mod(b)}"),
        #     [
        #         "behavior(0).",
        #         'context(0,"product").',
        #         'require(0,"a=mod(b)").',
        #         'binary("a=mod(b)","a","=","mod(b)").',
        #         'path("a",0,"a").',
        #         'function("product","mod(b)","mod","b").',
        #         'path("b",0,"b").',
        #     ],
        # )

        self.assertEqual(
            parse_coom("behavior{require a = log(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=log(b)").',
                'binary("a=log(b)","a","=","log(b)").',
                'path("a",0,"a").',
                'unary("log(b)","log","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = ln(b)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=ln(b)").',
                'binary("a=ln(b)","a","=","ln(b)").',
                'path("a",0,"a").',
                'unary("ln(b)","ln","b").',
                'path("b",0,"b").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = sin(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=sin(5)").',
                'binary("x=sin(5)","x","=","sin(5)").',
                'path("x",0,"x").',
                'unary("sin(5)","sin","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = asin(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=asin(5)").',
                'binary("x=asin(5)","x","=","asin(5)").',
                'path("x",0,"x").',
                'unary("asin(5)","asin","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = cos(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=cos(5)").',
                'binary("x=cos(5)","x","=","cos(5)").',
                'path("x",0,"x").',
                'unary("cos(5)","cos","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = acos(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=acos(5)").',
                'binary("x=acos(5)","x","=","acos(5)").',
                'path("x",0,"x").',
                'unary("acos(5)","acos","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = cosh(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=cosh(5)").',
                'binary("x=cosh(5)","x","=","cosh(5)").',
                'path("x",0,"x").',
                'unary("cosh(5)","cosh","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = tan(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=tan(5)").',
                'binary("x=tan(5)","x","=","tan(5)").',
                'path("x",0,"x").',
                'unary("tan(5)","tan","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = atan(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=atan(5)").',
                'binary("x=atan(5)","x","=","atan(5)").',
                'path("x",0,"x").',
                'unary("atan(5)","atan","5").',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require x = tanh(5)}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"x=tanh(5)").',
                'binary("x=tanh(5)","x","=","tanh(5)").',
                'path("x",0,"x").',
                'unary("tanh(5)","tanh","5").',
                'number("5",5).',
            ],
        )

    def test_path(self) -> None:
        """
        Test parsing behavior with path expressions.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b.c.d.e.f}"),
            [
                "behavior(0).",
                'context(0,"product").',
                'require(0,"a=b.c.d.e.f").',
                'binary("a=b.c.d.e.f","a","=","b.c.d.e.f").',
                'path("a",0,"a").',
                'path("b.c.d.e.f",0,"b").',
                'path("b.c.d.e.f",1,"c").',
                'path("b.c.d.e.f",2,"d").',
                'path("b.c.d.e.f",3,"e").',
                'path("b.c.d.e.f",4,"f").',
            ],
        )

    def test_explanation(self) -> None:
        """
        Test parsing behavior with explanation.
        """
        self.assertEqual(
            parse_coom('behavior{explanation "This is a test constraint" require a = b}'),
            [
                "behavior(0).",
                'context(0,"product").',
                'explanation(0,"This is a test constraint").',
                'require(0,"a=b").',
                'binary("a=b","a","=","b").',
                'path("a",0,"a").',
                'path("b",0,"b").',
            ],
        )
