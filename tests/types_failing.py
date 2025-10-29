"""Test file with type errors."""

from lib import greet, add_numbers

def failing_function() -> None:
    # Type error: passing string to function expecting int
    result = add_numbers("not", "numbers")
    print(f"Result: {result}")

    # Type error: passing int to function expecting str
    print(greet(42))
