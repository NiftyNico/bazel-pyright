"""Pyright type checking rules wrapper for Bazel."""


load(
    "@rules_python//python:defs.bzl",
    py_binary_base = "py_binary",
    py_library_base = "py_library",
    py_test_base = "py_test",
)

load("@rules_pyright//:defs.bzl", "pyright_test")


def _py_typed(py_target, name, srcs=[], deps=[], data=[], tags=[], pyrightconfig=None, **kwargs):
    pyright_test(
        name=name + "_pyright_test",
        srcs=srcs,
        deps=deps,
        data=data,
        pyrightconfig=pyrightconfig,
        tags=tags,
    )

    py_target(
        name=name,
        srcs=srcs,
        deps=deps,
        data=data,
        **kwargs
    )

def py_binary(**kwargs):
    _py_typed(
        py_target = py_binary_base,
        **kwargs
    )

def py_library(**kwargs):
    _py_typed(
        py_target = py_library_base,
        **kwargs
    )

def py_test(**kwargs):
    _py_typed(
        py_target = py_test_base,
        **kwargs
    )
