# rules-pyright
Bazel rules for running [Pyright](https://github.com/microsoft/pyright) type checking on Python code. This project provides seamless integration of the Pyright static type checker into Bazel build systems.

## Overview
`rules-pyright` enables you to enforce Python type safety as part of your Bazel build process.

## Features
- **Bazel Integration**: Bazel rule for type checking
- **Configuration Support**: Optional `pyrightconfig.json` for customizing type checking behavior
- **Test Framework Integration**: Works seamlessly with Bazel's test runner

## Installation

### Prerequisites

- [Bazelisk](https://bazel.build/install/bazelisk)

### Setup

Add to your `MODULE.bazel`:

```python
bazel_dep(name = "rules_pyright", version = "0.1.0")
git_override(
    module_name = "rules_pyright",
    remote = "https://github.com/NiftyNico/rules_pyright.git",
    commit = "COMMIT_SHA",
)

```

## Usage

See the test [macro](tests/defs.bzl) and [targets](tests/defs.bzl) for example usage.

Include the following in MODULE.bazel
```starlark
bazel_dep(name = "rules-pyright", version = "0.1.0")
git_override(
    module_name = "rules-pyright",
    remote = "https://github.com/NiftyNico/pyright-rules.git",
    commit = "bb2fb01e1d5c1fe41f5ef5645e490b844b5b062f",
)
```

## Rule Reference

### `pyright_test`

Runs Pyright type checking on Python source files ([source](defs.bzl))

## License

MIT License - Copyright 2025 Nico Higuera

## Contributing

Contributions are welcome! Please feel free to open issues or pull requests.

## References

- [Pyright Documentation](https://microsoft.github.io/pyright/)
- [Bazel Documentation](https://bazel.build/docs)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)