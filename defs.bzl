"""Pyright type checking rules for Bazel."""

def _pyright_test_impl(ctx):
    """Implementation of pyright_test rule."""

    # Collect all source files (including non-.py files)
    all_srcs = ctx.files.srcs

    # Filter only Python files for execution
    py_srcs = [src for src in all_srcs if src.extension == "py"]

    if not py_srcs:
        fail("No Python source files found for pyright checking")

    # Create a script that invokes node with pyright directly
    script = ctx.actions.declare_file(ctx.label.name + "_test.sh")

    pyright_index = ctx.file._pyright_index
    pyright_files = ctx.files._pyright_files

    # Build the pyright command with optional config
    config_arg = ""
    config_files = []
    if ctx.file.pyrightconfig:
        config_arg = "--project " + ctx.file.pyrightconfig.short_path
        config_files = [ctx.file.pyrightconfig]

    ctx.actions.write(
        output = script,
        content = """#!/usr/bin/env bash
set -euo pipefail
export PYTHONPATH="${{PWD}}"
exec node {pyright_index} {config_arg} {srcs}
""".format(
            pyright_index = pyright_index.short_path,
            config_arg = config_arg,
            srcs = " ".join([src.short_path for src in py_srcs]),
        ),
        is_executable = True,
    )

    return [DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(
            files = all_srcs + [pyright_index] + pyright_files + config_files,
        ).merge_all([
            dep[DefaultInfo].default_runfiles
            for dep in ctx.attr.deps
            if DefaultInfo in dep
        ]).merge_all([
            data[DefaultInfo].default_runfiles
            for data in ctx.attr.data
            if DefaultInfo in data
        ]),
    )]

pyright_test = rule(
    implementation = _pyright_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
            doc = "Source files to include (Python files will be type checked)",
        ),
        "deps": attr.label_list(
            default = [],
            doc = "Dependencies",
        ),
        "data": attr.label_list(
            default = [],
            doc = "Any other data to include",
        ),
        "pyrightconfig": attr.label(
            allow_single_file = [".json"],
            doc = "Optional pyrightconfig.json file for type checking configuration",
        ),
        "_pyright_index": attr.label(
            default = "@pyright//:index.js",
            allow_single_file = True,
        ),
        "_pyright_files": attr.label(
            default = "@pyright//:pyright_files",
        ),
    },
    doc = "Runs pyright type checker on Python source files",
)