"""Module docstring: should look like Comment when docstring highlighting works."""

name = "normal string: should look like String"


def add(a: int, b: int) -> int:
    """Function docstring: should look like Comment."""
    note = "regular in-function string: should look like String"
    block = """
    Triple-quoted assigned string (not docstring).
    Depending on your rules this may remain String.
    """
    return a + b


class Example:
    """Class docstring: should look like Comment."""

    def method(self) -> str:
        """Method docstring: should look like Comment."""
        return "value"
