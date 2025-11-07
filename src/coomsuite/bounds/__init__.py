"""
General helper functions for solving unbounded cardinalities.
"""

from itertools import count, dropwhile
from typing import Iterator, Optional


def _exponential_iter() -> Iterator[int]:
    n = 0
    while True:
        yield 2**n
        n += 1


def get_bound_iter(algorithm: str, start: int) -> Iterator[int]:
    """
    Get an iterator over the bounds for a selected algorithm.

    Note that the iterator starts after the start value.

    Args:
        algorithm (str): either "linear" or "exponential"
        start (int): value after which the iterator starts
    """
    iterator: Iterator[int]
    match algorithm:
        case "linear":
            iterator = count(start + 1)
        case "exponential":
            iterator = dropwhile(lambda x: x <= start, _exponential_iter())
        case _:
            raise ValueError(f"unknown algorithm for bound iter: {algorithm}")

    return iterator


def next_bound_converge(unsat_bound: int, sat_bound: int) -> Optional[int]:
    """
    Determine the next bound (between unsat_bound and sat_bound) for converging to the minimal bound

    Returns:
        Optional[int]: The next bound to check, or None if sat_bound is already the minimal bound
    """
    if unsat_bound + 1 == sat_bound:
        return None

    return (unsat_bound + sat_bound) // 2
