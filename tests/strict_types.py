"""Test file with proper type annotations for strict mode."""


def multiply(a: int, b: int) -> int:
    """Multiply two numbers together."""
    return a * b


def format_message(prefix: str, value: int) -> str:
    """Format a message with prefix and value."""
    return f"{prefix}: {value}"


if __name__ == "__main__":
    result = multiply(4, 5)
    print(format_message("Result", result))
