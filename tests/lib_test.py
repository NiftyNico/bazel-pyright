from tests.lib import greet

from unittest import TestCase, main

class MainTest(TestCase):
    def test_main(self) -> None:
        assert greet("Felix") == "Hello Felix!"

if __name__ == "__main__":
    main()
