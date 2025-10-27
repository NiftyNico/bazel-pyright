"""Pyright type checking rules for Bazel."""

def _pyright_test_impl(ctx):
    """Implementation of pyright_test rule."""

    # Collect all Python source files
    srcs = [src for src in ctx.files.srcs if src.extension == "py"]

    if not srcs:
        fail("No Python source files found for pyright checking")

    # Create a script that invokes the runner with source files
    script = ctx.actions.declare_file(ctx.label.name + "_test.sh")

    ctx.actions.write(
        output = script,
        content = """#!/usr/bin/env bash
set -euo pipefail
exec {runner} {srcs}
""".format(
            runner = ctx.executable._runner.short_path,
            srcs = " ".join([src.short_path for src in srcs]),
        ),
        is_executable = True,
    )

    # Collect runfiles
    runfiles = ctx.runfiles(files = srcs + [ctx.executable._runner])
    runfiles = runfiles.merge(ctx.attr._runner[DefaultInfo].default_runfiles)

    return [DefaultInfo(
        executable = script,
        runfiles = runfiles,
    )]

pyright_test = rule(
    implementation = _pyright_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".py"],
            mandatory = True,
            doc = "Python source files to type check",
        ),
        "_runner": attr.label(
            default = "//pyright:runner",
            executable = True,
            cfg = "exec",
        ),
    },
    doc = "Runs pyright type checker on Python source files",
)

def py_typed(name, base_rule, srcs = [], deps = [], tags = [], main = None, **kwargs):
    """A Python target that automatically includes pyright type checking.

    Args:
        name: Name of the target
        base_rule: The underlying rule to use (e.g., native.py_library, native.py_binary,
                   or any custom wrapper)
        srcs: Python source files
        deps: Dependencies
        tags: Tags to apply to both the base target and the pyright test
        main: Main entry point file (will be added to srcs for pyright test)
        **kwargs: Additional arguments passed to the base rule
    """
    # Pass main to the base rule if provided
    base_rule_kwargs = dict(kwargs)
    if main:
        base_rule_kwargs["main"] = main

    base_rule(
        name = name,
        srcs = srcs,
        deps = deps,
        tags = tags,
        **base_rule_kwargs
    )

    # For pyright test, include main in srcs if provided and not already in srcs
    # (but don't pass main attribute to the test)
    pyright_srcs = srcs
    if main and main not in srcs:
        pyright_srcs = srcs + [main]

    # Create a pyright test for this target with the same tags
    pyright_test(
        name = name + "_pyright_test",
        srcs = pyright_srcs,
        tags = tags + ["pyright", "type-check"],
    )
