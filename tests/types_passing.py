"""Test file with correct type annotations."""

from lib import add_numbers, greet

def implicit_any(value):
    """This function has implicit Any parameter - would fail in strict mode."""
    return value


if __name__ == "__main__":
    result = add_numbers(5, 3)
    print(f"Result: {result}")
    print(greet("World"))
    print(implicit_any(42))
