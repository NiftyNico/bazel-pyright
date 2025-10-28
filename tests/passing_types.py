"""Test file with correct type annotations."""


def add_numbers(a: int, b: int) -> int:
    """Add two numbers together."""
    return a + b


def greet(name: str) -> str:
    """Greet a person by name."""
    return f"Hello, {name}!"


def implicit_any(value):
    """This function has implicit Any parameter - would fail in strict mode."""
    return value


if __name__ == "__main__":
    result = add_numbers(5, 3)
    print(f"Result: {result}")
    print(greet("World"))
    print(implicit_any(42))
