load("@prelude//python_bootstrap:python_bootstrap.bzl", "PythonBootstrapToolchainInfo")

def _nix_python_bootstrap_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        PythonBootstrapToolchainInfo(
            interpreter = ctx.attrs.python[RunInfo],
        ),
    ]

nix_python_bootstrap_toolchain = rule(
    impl = _nix_python_bootstrap_toolchain_impl,
    attrs = {
        "python": attrs.exec_dep(providers = [RunInfo]),
    },
    doc = """
    Creates a python_bootstrap toolchain.

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
    """,
    is_toolchain_rule = True,
)
