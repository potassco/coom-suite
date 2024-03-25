"""
Test cases for the parser from COOM to ASP.
"""

from unittest import TestCase

from . import parse_coom


class TestMain(TestCase):
    """
    Test cases for COOM to ASP parser.
    """

    def test_product(self) -> None:
        """
        Test the 'product' keyword.
        """
        self.assertEqual(parse_coom("product{}"), ['structure(":root").'])

    def test_structure(self) -> None:
        """
        Test the 'structure' keyword.
        """
        self.assertEqual(parse_coom("structure Test {}"), ['\nstructure("Test").'])

    def test_feature(self) -> None:
        """
        Test the 'feature' keyword.
        """
        self.assertEqual(
            parse_coom("product{Wheel wheel Frame frame}"),
            ['structure(":root").', 'feature(":root",wheel,"Wheel",1,1).', 'feature(":root",frame,"Frame",1,1).'],
        )

        self.assertEqual(
            parse_coom("structure Carrier {0..3 Bag bags}"),
            ['\nstructure("Carrier").', 'feature("Carrier",bags,"Bag",0,3).'],
        )

        self.assertEqual(
            parse_coom("structure Carrier {2..* Bag bags}"),
            ['\nstructure("Carrier").', 'feature("Carrier",bags,"Bag",2,#sup).'],
        )

        self.assertEqual(
            parse_coom("structure Carrier {5x Bag bags}"),
            ['\nstructure("Carrier").', 'feature("Carrier",bags,"Bag",5,5).'],
        )

        self.assertEqual(
            parse_coom("product{num	1-100 totalWeight}"),
            ['structure(":root").', 'feature(":root",totalWeight,"num",1,1).', 'range(":root",totalWeight,1,100).'],
        )

    def test_enumeration(self) -> None:
        """
        Test the 'enumeration' keyword.
        """
        self.assertEqual(
            parse_coom("enumeration Color {Red Green Yellow Blue}"),
            [
                '\nenumeration("Color").',
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
                '\nenumeration("Capacity").',
                'attribute("Capacity",volume,"num").',
                'attribute("Capacity",weight,"num").',
                'option("Capacity", "B10").',
                'attr_value("Capacity","B10",volume,10).',
                'attr_value("Capacity","B10",weight,100).',
                'option("Capacity", "B20").',
                'attr_value("Capacity","B20",volume,20).',
                'attr_value("Capacity","B20",weight,250).',
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
                '\nenumeration("Size").',
                'attribute("Size",color,"str").',
                'option("Size", "Small").',
                'attr_value("Size","Small",color,"Red").',
                'option("Size", "Big").',
                'attr_value("Size","Big",color,"Blue").',
            ],
        )

    def test_behavior(self) -> None:
        """
        Test the 'behavior' keyword.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior Bag {require a = b}"),
            [
                '\nbehavior(("Bag",0)).',
                'require(("Bag",0),"a=b").',
                'binary("Bag","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {require color = Red}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"color=Red").',
                'binary(":root","color=Red","color","=","Red").',
                'path("color",0,color).',
                'constant("Red").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {default color = red}"),
            [
                '\nbehavior((":root",0)).',
                'default((":root",0),"color","red").',
                'path("color",0,color).',
                'path("red",0,red).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b require c = d}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                '\nbehavior((":root",1)).',
                'require((":root",1),"c=d").',
                'binary(":root","c=d","c","=","d").',
                'path("c",0,c).',
                'path("d",0,d).',
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
                '\nbehavior((":root",0)).',
                'combinations((":root",0),0,"wheelSupport").',
                'combinations((":root",0),1,"rearWheel").',
                'path("wheelSupport",0,wheelSupport).',
                'path("rearWheel",0,rearWheel).',
                'allow((":root",0),(0,0),"True").',
                'allow((":root",0),(1,0),"W14").',
                'allow((":root",0),(1,0),"W16").',
                'allow((":root",0),(0,1),"False").',
                'allow((":root",0),(1,1),"W18").',
                'allow((":root",0),(1,1),"W20").',
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
                '\nbehavior(("Bike",0)).',
                'combinations(("Bike",0),0,"wheelSupport").',
                'combinations(("Bike",0),1,"rearWheel").',
                'path("wheelSupport",0,wheelSupport).',
                'path("rearWheel",0,rearWheel).',
                'allow(("Bike",0),(0,0),"True").',
                'allow(("Bike",0),(1,0),"W14").',
                'allow(("Bike",0),(1,0),"W16").',
                'allow(("Bike",0),(0,1),"False").',
                'allow(("Bike",0),(1,1),"W18").',
                'allow(("Bike",0),(1,1),"W20").',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {condition a = b require c > 5}"),
            [
                '\nbehavior((":root",0)).',
                'condition((":root",0),"a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'require((":root",0),"c>5").',
                'binary(":root","c>5","c",">","5").',
                'path("c",0,c).',
                'number("5",5).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior {condition a = b default c = d}"),
            [
                '\nbehavior((":root",0)).',
                'condition((":root",0),"a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'default((":root",0),"c","d").',
                'path("c",0,c).',
                'path("d",0,d).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{imply a = b}"),
            ['\nbehavior((":root",0)).', 'imply((":root",0),a,"b").', 'path("a",0,a).', 'path("b",0,b).'],
        )

        self.assertEqual(parse_coom("behavior{readonly totalWeight}"), [])

    def test_condition(self) -> None:
        """
        Test the 'condition' keyword.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b || a = c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b||a=c").',
                'binary(":root","a=b||a=c","a=b","||","a=c").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'binary(":root","a=c","a","=","c").',
                'path("a",0,a).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b || a = c || a = d}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b||a=c||a=d").',
                'binary(":root","a=b||a=c||a=d","a=b","||","a=c||a=d").',
                'binary(":root","a=c||a=d","a=c","||","a=d").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'binary(":root","a=c","a","=","c").',
                'path("a",0,a).',
                'path("c",0,c).',
                'binary(":root","a=d","a","=","d").',
                'path("a",0,a).',
                'path("d",0,d).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b && a = c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b&&a=c").',
                'binary(":root","a=b&&a=c","a=b","&&","a=c").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'binary(":root","a=c","a","=","c").',
                'path("a",0,a).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b && a = c && a = d}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b&&a=c&&a=d").',
                'binary(":root","a=b&&a=c&&a=d","a=b","&&","a=c&&a=d").',
                'binary(":root","a=c&&a=d","a=c","&&","a=d").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
                'binary(":root","a=c","a","=","c").',
                'path("a",0,a).',
                'path("c",0,c).',
                'binary(":root","a=d","a","=","d").',
                'path("a",0,a).',
                'path("d",0,d).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require ! a = b }"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"!a=b").',
                'unary(":root","!a=b","!","a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require (a = b) }"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"(a=b)").',
                'unary(":root","(a=b)","()","a=b").',
                'binary(":root","a=b","a","=","b").',
                'path("a",0,a).',
                'path("b",0,b).',
            ],
        )

    def test_formula(self) -> None:
        """
        Test behavior with arithmetic formulas.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b + c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b+c").',
                'binary(":root","a=b+c","a","=","b+c").',
                'path("a",0,a).',
                'binary(":root","b+c","b","+","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b - c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b-c").',
                'binary(":root","a=b-c","a","=","b-c").',
                'path("a",0,a).',
                'binary(":root","b-c","b","-","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b * c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b*c").',
                'binary(":root","a=b*c","a","=","b*c").',
                'path("a",0,a).',
                'binary(":root","b*c","b","*","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )
        self.assertEqual(
            parse_coom("behavior{require a = b / c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b/c").',
                'binary(":root","a=b/c","a","=","b/c").',
                'path("a",0,a).',
                'binary(":root","b/c","b","/","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = b ^ c}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b^c").',
                'binary(":root","a=b^c","a","=","b^c").',
                'path("a",0,a).',
                'binary(":root","b^c","b","^","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = - b}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=-b").',
                'binary(":root","a=-b","a","=","-b").',
                'path("a",0,a).',
                'unary(":root","-b","-","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = + b}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=+b").',
                'binary(":root","a=+b","a","=","+b").',
                'path("a",0,a).',
                'unary(":root","+b","+","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = (b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=(b)").',
                'binary(":root","a=(b)","a","=","(b)").',
                'path("a",0,a).',
                'unary(":root","(b)","()","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = sum(b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=sum(b)").',
                'binary(":root","a=sum(b)","a","=","sum(b)").',
                'path("a",0,a).',
                'function(":root","sum(b)","sum","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = sum(b,c)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=sum(b,c)").',
                'binary(":root","a=sum(b,c)","a","=","sum(b,c)").',
                'path("a",0,a).',
                'function(":root","sum(b,c)","sum","b").',
                'function(":root","sum(b,c)","sum","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = count(b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=count(b)").',
                'binary(":root","a=count(b)","a","=","count(b)").',
                'path("a",0,a).',
                'function(":root","count(b)","count","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = count(b,c)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=count(b,c)").',
                'binary(":root","a=count(b,c)","a","=","count(b,c)").',
                'path("a",0,a).',
                'function(":root","count(b,c)","count","b").',
                'function(":root","count(b,c)","count","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )
        self.assertEqual(
            parse_coom("behavior{require a = min(b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=min(b)").',
                'binary(":root","a=min(b)","a","=","min(b)").',
                'path("a",0,a).',
                'function(":root","min(b)","min","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = min(b,c)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=min(b,c)").',
                'binary(":root","a=min(b,c)","a","=","min(b,c)").',
                'path("a",0,a).',
                'function(":root","min(b,c)","min","b").',
                'function(":root","min(b,c)","min","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = max(b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=max(b)").',
                'binary(":root","a=max(b)","a","=","max(b)").',
                'path("a",0,a).',
                'function(":root","max(b)","max","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = max(b,c)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=max(b,c)").',
                'binary(":root","a=max(b,c)","a","=","max(b,c)").',
                'path("a",0,a).',
                'function(":root","max(b,c)","max","b").',
                'function(":root","max(b,c)","max","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = delta(b)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=delta(b)").',
                'binary(":root","a=delta(b)","a","=","delta(b)").',
                'path("a",0,a).',
                'function(":root","delta(b)","delta","b").',
                'path("b",0,b).',
            ],
        )

        self.assertEqual(
            parse_coom("behavior{require a = delta(b,c)}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=delta(b,c)").',
                'binary(":root","a=delta(b,c)","a","=","delta(b,c)").',
                'path("a",0,a).',
                'function(":root","delta(b,c)","delta","b").',
                'function(":root","delta(b,c)","delta","c").',
                'path("b",0,b).',
                'path("c",0,c).',
            ],
        )

    def test_path(self) -> None:
        """
        Test behavior with path expressions.
        """
        self.assertEqual(
            parse_coom("behavior{require a = b.c.d.e.f}"),
            [
                '\nbehavior((":root",0)).',
                'require((":root",0),"a=b.c.d.e.f").',
                'binary(":root","a=b.c.d.e.f","a","=","b.c.d.e.f").',
                'path("a",0,a).',
                'path("b.c.d.e.f",0,b).',
                'path("b.c.d.e.f",1,c).',
                'path("b.c.d.e.f",2,d).',
                'path("b.c.d.e.f",3,e).',
                'path("b.c.d.e.f",4,f).',
            ],
        )
