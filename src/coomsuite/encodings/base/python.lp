% Python helper functions
#script (python)
from clingo import String

def contains(s1, s2):
    """
    Checks whether a string s2 is contained in another string s1.
    """
    if s2.string in s1.string:
        return String("True")
    return String("False")
#end.
