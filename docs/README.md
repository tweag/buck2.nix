# flake.legacyPackage

A `flake.legacyPackage()` rule builds a nix package of a given flake.

```
flake.legacyPackage(
    name: str,
    default_target_platform: None | str = ...,
    target_compatible_with: list[str] = ...,
    compatible_with: list[str] = ...,
    exec_compatible_with: list[str] = ...,
    visibility: list[str] = ...,
    within_view: list[str] = ...,
    metadata: OpaqueMetadata = ...,
    tests: list[str] = ...,
    modifiers: OpaqueMetadata = ...,
    binaries: list[str] = ...,
    binary: None | str = ...,
    output: str = ...,
    package: None | str = ...,
    path: str,
)
```

## Examples

```starlark
flake.legacyPackage(
    name = "curl",
    path = ":nixpkgs",
    output = "bin",
    binary = "curl",
)
```

This creates a target called `curl` from the nix flake in `./nix`, building `path:nix#legacyPackages.<system>.curl.bin`.

## Parameters

### `name`

name of the target


### `default_target_platform`

specifies the default target platform, used when no platforms are specified on the command line


### `target_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `exec_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with an execution platform


### `visibility`

a list of visibility patterns restricting what targets can depend on this one


### `within_view`

a list of visibility patterns restricting what this target can depend on


### `metadata`

a key-value map of metadata associated with this target


### `tests`

a list of targets that provide tests for this one


### `modifiers`

an array of modifiers associated with this target


### `binaries`

add auxiliary binaries for this package

These can be accessed as sub-targets with the given name in dependent rules.


### `binary`

specify the default binary of this package

This provides `RunInfo` for a binary in the `bin` directory of the package.


### `output`

specify the output to build instead of the default

(optional, default: `"out"`)


### `package`

name of the flake output

(optional, default: same as `name`)


### `path`

the path to the flake


# flake.package

A `flake.package()` rule builds a nix package of a given flake.

```
flake.package(
    name: str,
    default_target_platform: None | str = ...,
    target_compatible_with: list[str] = ...,
    compatible_with: list[str] = ...,
    exec_compatible_with: list[str] = ...,
    visibility: list[str] = ...,
    within_view: list[str] = ...,
    metadata: OpaqueMetadata = ...,
    tests: list[str] = ...,
    modifiers: OpaqueMetadata = ...,
    binaries: list[str] = ...,
    binary: None | str = ...,
    output: str = ...,
    package: None | str = ...,
    path: str,
)
```

## Examples

```starlark
flake.package(
    name = "curl",
    path = "nix",
    output = "bin",
    binary = "curl",
)
```

This creates a target called `curl` from the nix flake in `./nix`, building `path:nix#packages.<system>.curl.bin`.

## Parameters

### `name`

name of the target


### `default_target_platform`

specifies the default target platform, used when no platforms are specified on the command line


### `target_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `exec_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with an execution platform


### `visibility`

a list of visibility patterns restricting what targets can depend on this one


### `within_view`

a list of visibility patterns restricting what this target can depend on


### `metadata`

a key-value map of metadata associated with this target


### `tests`

a list of targets that provide tests for this one


### `modifiers`

an array of modifiers associated with this target


### `binaries`

add auxiliary binaries for this package

These can be accessed as sub-targets with the given name in dependent rules.


### `binary`

specify the default binary of this package

This provides `RunInfo` for a binary in the `bin` directory of the package.


### `output`

specify the output to build instead of the default

(optional, default: `"out"`)


### `package`

name of the flake output

(optional, default: same as `name`)


### `path`

the path to the flake


# Toolchain Rules

Use these in the `toolchains` cell of your project to define toolchain targets.

# nix_cxx_toolchain

Creates a cxx toolchain that is required by all C/C++ rules.

```
nix_cxx_toolchain(
    name: str,
    default_target_platform: None | str = ...,
    target_compatible_with: list[str] = ...,
    compatible_with: list[str] = ...,
    exec_compatible_with: list[str] = ...,
    visibility: list[str] = ...,
    within_view: list[str] = ...,
    metadata: OpaqueMetadata = ...,
    tests: list[str] = ...,
    modifiers: OpaqueMetadata = ...,
    c_flags: list[str] = ...,
    cpp_dep_tracking_mode: str = ...,
    cxx_flags: list[str] = ...,
    link_flags: list[str] = ...,
    link_ordering: None | str = ...,
    link_style: str = ...,
    nix_cc: str,
)
```

## Examples

```starlark
# use the `cxx` flake package output from `./nix` to provide the compiler tools
flake.package(
    name = "nix_cc",
    binaries = [
        "ar",
        "cc",
        "c++",
        "nm",
        "objcopy",
        "ranlib",
        "strip",
    ],
    package = "cxx",
    path = "nix",
)

# provide the `cxx` toolchain using the `:nix_cc` target
nix_cxx_toolchain(
    name = "cxx",
    nix_cc = ":nix_cc",
    visibility = ["PUBLIC"],
)
```

_Note_: The `nixpkgs` cc infrastructure depends on environment variables to be set during execution. You might
        need to wrap the C/C++ compiler tools capturing the environment. Take a look at the example project.

## Parameters

### `name`

name of the target


### `default_target_platform`

specifies the default target platform, used when no platforms are specified on the command line


### `target_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `exec_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with an execution platform


### `visibility`

a list of visibility patterns restricting what targets can depend on this one


### `within_view`

a list of visibility patterns restricting what this target can depend on


### `metadata`

a key-value map of metadata associated with this target


### `tests`

a list of targets that provide tests for this one


### `modifiers`

an array of modifiers associated with this target


# nix_python_bootstrap_toolchain

Creates a python_bootstrap toolchain.

```
nix_python_bootstrap_toolchain(
    name: str,
    default_target_platform: None | str = ...,
    target_compatible_with: list[str] = ...,
    compatible_with: list[str] = ...,
    exec_compatible_with: list[str] = ...,
    visibility: list[str] = ...,
    within_view: list[str] = ...,
    metadata: OpaqueMetadata = ...,
    tests: list[str] = ...,
    modifiers: OpaqueMetadata = ...,
    python: str,
)
```

## Examples

```starlark
# use the `python3` flake package output from `./nix` to provide the Python interpreter
flake.package(
    name = "python",
    binary = "python3",
    package = "python3",
    path = "nix",
)

# provide the `python_bootstrap` toolchain using the `:python` target
nix_python_bootstrap_toolchain(
    name = "python_bootstrap",
    python = ":python",
    visibility = ["PUBLIC"],
)
```

## Parameters

### `name`

name of the target


### `default_target_platform`

specifies the default target platform, used when no platforms are specified on the command line


### `target_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `exec_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with an execution platform


### `visibility`

a list of visibility patterns restricting what targets can depend on this one


### `within_view`

a list of visibility patterns restricting what this target can depend on


### `metadata`

a key-value map of metadata associated with this target


### `tests`

a list of targets that provide tests for this one


### `modifiers`

an array of modifiers associated with this target


# nix_rust_toolchain

Creates a rust toolchain that is required by all Rust rules.

```
nix_rust_toolchain(
    name: str,
    default_target_platform: None | str = ...,
    target_compatible_with: list[str] = ...,
    compatible_with: list[str] = ...,
    exec_compatible_with: list[str] = ...,
    visibility: list[str] = ...,
    within_view: list[str] = ...,
    metadata: OpaqueMetadata = ...,
    tests: list[str] = ...,
    modifiers: OpaqueMetadata = ...,
    allow_lints: list[str] = ...,
    clippy: str,
    clippy_toml: None | str = ...,
    default_edition: None | str = ...,
    deny_lints: list[str] = ...,
    doctests: bool = ...,
    nightly_features: bool = ...,
    report_unused_deps: bool = ...,
    rustc: str,
    rustc_binary_flags: list[str] = ...,
    rustc_flags: list[str] = ...,
    rustc_target_triple: str = ...,
    rustc_test_flags: list[str] = ...,
    rustdoc: str,
    rustdoc_flags: list[str] = ...,
    warn_lints: list[str] = ...,
)
```

## Examples

```starlark
# use the `rustc` flake package output from `./nix` to provide the Rust compiler and rustdoc
flake.package(
    name = "rustc",
    binaries = ["rustdoc"],
    binary = "rustc",
    path = "nix",
)

# use the `clippy` flake package output from `./nix` to provide the clippy tool
flake.package(
    name = "clippy",
    binary = "clippy-driver",
    path = "nix",
)

# provide the `rust` toolchain using the `:rustc` and `:clippy` targets
nix_rust_toolchain(
    name = "rust",
    clippy = ":clippy",
    default_edition = "2021",
    rustc = ":rustc",
    rustdoc = ":rustc[rustdoc]", # use the rustdoc binary from the `rustc` target
    visibility = ["PUBLIC"],
)
```

## Parameters

### `name`

name of the target


### `default_target_platform`

specifies the default target platform, used when no platforms are specified on the command line


### `target_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with a configuration


### `exec_compatible_with`

a list of constraints that are required to be satisfied for this target to be compatible with an execution platform


### `visibility`

a list of visibility patterns restricting what targets can depend on this one


### `within_view`

a list of visibility patterns restricting what this target can depend on


### `metadata`

a key-value map of metadata associated with this target


### `tests`

a list of targets that provide tests for this one


### `modifiers`

an array of modifiers associated with this target


### `rustc`

the Rust compiler


### `rustdoc`

the Rust documentation tool



