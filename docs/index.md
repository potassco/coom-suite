---
hide:
- navigation
- toc
---

# COOM Suite

The [COOM language][coom] is a domain-specific language
for modelling product configuration problems. While currently geared towards
ASP, the *COOM Suite* is intended to serve as a general workbench for
experimentation with industrial-scale product configuration problems. It
includes a (customizable) [ANTLR v4][antlr] parser to convert
COOM specifications into facts, and currently contains two [ASP encodings][encodings] for
solving: one for [clingo] and one for
hybrid solver [fclingo].

In addition, a range of examples and a benchmark collection with four scalable
benchmark sets is provided.


=== "Workflow"
    The workflow of the *COOM Suite* is as follows:

    1. First, a COOM model gets parsed and translated into
       a fact format which closely resembles the COOM language
    2. Next, these facts get refined by means of an ASP encoding
       into another, COOM-independent fact format
    3. This serves as input to another encoding solving the configuration problem
    4. The stable models can be parsed back into a COOM solution

    ![Workflow](assets/images/workflow.png){width="1200"}

=== "COOM model"
    As an example consider the following simple COOM model:

    ```cpp
    product { //(1)!
        Bool    wheelSupport
        Wheel	frontWheel
        Wheel	rearWheel
    }

    enumeration Wheel { //(2)!
        attribute num size //(3)!

        W14	= (	 14	) //(4)!
        W16	= (	 16	)
        W18	= (	 18	)
        W20	= (	 20	)
    }


    behavior { //(5)!
        combinations  (wheelSupport	 rearWheel)
        allow         (True          (W14, W16)) //(6)!
        allow         (False         (W18, W20))
    }

    behavior {
        require frontWheel.size = rearWheel.size //(7)!
    }

    ```

    1. Product to be configured
    2. Enumerations provide a discrete number of options
    3. Additional attribute values can be defined for each option
    4. The option W14 has size 14
    5. The behavior keyword defines constraints
    6. A wheelSupport can be used only with rear wheels W14 and W16
    7. The size of the front and rear wheel have to be equal

=== "Serialization"

=== "ASP facts"

!!! info
    The *COOM suite* is part of the [Potassco] suite (which is the home of *clingo* and other ASP tools)

[coom]: https://www.coom-lang.org/
[antlr]: https://www.antlr.org
[encodings]: reference/encodings/index.md
[clingo]: https://potassco.org/clingo
[fclingo]: https://github.com/potassco/fclingo
[Potassco]: https://potassco.org
