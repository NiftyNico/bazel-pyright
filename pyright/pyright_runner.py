"""Runner script for pyright type checking."""

import sys
from pyright import main as pyright_main


def main():
    """Run pyright on the provided source files."""
    if len(sys.argv) < 2:
        print("Usage: pyright_runner.py <source_files...>", file=sys.stderr)
        sys.exit(1)

    sys.exit(pyright_main(sys.argv[1:]))


if __name__ == "__main__":
    main()
