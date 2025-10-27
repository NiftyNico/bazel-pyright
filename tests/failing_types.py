"""Test file with type errors."""


def add_numbers(a: int, b: int) -> int:
    """Add two numbers together."""
    return a + b


def greet(name: str) -> str:
    """Greet a person by name."""
    return f"Hello, {name}!"


if __name__ == "__main__":
    # Type error: passing string to function expecting int
    result = add_numbers("not", "numbers")
    print(f"Result: {result}")

    # Type error: passing int to function expecting str
    print(greet(42))
