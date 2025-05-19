load("@prelude//rust:rust_toolchain.bzl", "PanicRuntime", "RustToolchainInfo")

_DEFAULT_TRIPLE = select({
    "config//os:linux": select({
        "config//cpu:arm64": "aarch64-unknown-linux-gnu",
        "config//cpu:x86_64": "x86_64-unknown-linux-gnu",
    }),
    "config//os:macos": select({
        "config//cpu:arm64": "aarch64-apple-darwin",
        "config//cpu:x86_64": "x86_64-apple-darwin",
    }),
    "config//os:windows": select({
        "config//cpu:arm64": select({
            # Rustup's default ABI for the host on Windows is MSVC, not GNU.
            # When you do `rustup install stable` that's the one you get. It
            # makes you opt in to GNU by `rustup install stable-gnu`.
            "DEFAULT": "aarch64-pc-windows-msvc",
            "config//abi:gnu": "aarch64-pc-windows-gnu",
            "config//abi:msvc": "aarch64-pc-windows-msvc",
        }),
        "config//cpu:x86_64": select({
            "DEFAULT": "x86_64-pc-windows-msvc",
            "config//abi:gnu": "x86_64-pc-windows-gnu",
            "config//abi:msvc": "x86_64-pc-windows-msvc",
        }),
    }),
})

def _nix_rust_toolchain_impl(ctx: AnalysisContext) -> list[Provider]:
    return [
        DefaultInfo(),
        RustToolchainInfo(
            allow_lints = ctx.attrs.allow_lints,
            clippy_driver = ctx.attrs.clippy[RunInfo],
            clippy_toml = ctx.attrs.clippy_toml[DefaultInfo].default_outputs[0] if ctx.attrs.clippy_toml else None,
            compiler = ctx.attrs.rustc[RunInfo],
            default_edition = ctx.attrs.default_edition,
            panic_runtime = PanicRuntime("unwind"),
            deny_lints = ctx.attrs.deny_lints,
            doctests = ctx.attrs.doctests,
            nightly_features = ctx.attrs.nightly_features,
            report_unused_deps = ctx.attrs.report_unused_deps,
            rustc_binary_flags = ctx.attrs.rustc_binary_flags,
            rustc_flags = ctx.attrs.rustc_flags,
            rustc_target_triple = ctx.attrs.rustc_target_triple,
            rustc_test_flags = ctx.attrs.rustc_test_flags,
            rustdoc = ctx.attrs.rustdoc[RunInfo],
            rustdoc_flags = ctx.attrs.rustdoc_flags,
            warn_lints = ctx.attrs.warn_lints,
        ),
    ]

nix_rust_toolchain = rule(
    impl = _nix_rust_toolchain_impl,
    attrs = {
        "allow_lints": attrs.list(attrs.string(), default = []),
        "clippy": attrs.exec_dep(providers = [RunInfo]),
        "clippy_toml": attrs.option(attrs.dep(providers = [DefaultInfo]), default = None),
        "default_edition": attrs.option(attrs.string(), default = None),
        "deny_lints": attrs.list(attrs.string(), default = []),
        "doctests": attrs.bool(default = False),
        "nightly_features": attrs.bool(default = False),
        "report_unused_deps": attrs.bool(default = False),
        "rustc": attrs.exec_dep(providers = [RunInfo], doc = "the Rust compiler"),
        "rustc_binary_flags": attrs.list(attrs.string(), default = []),
        "rustc_flags": attrs.list(attrs.string(), default = []),
        "rustc_target_triple": attrs.string(default = _DEFAULT_TRIPLE),
        "rustc_test_flags": attrs.list(attrs.string(), default = []),
        "rustdoc": attrs.exec_dep(providers = [RunInfo], doc = "the Rust documentation tool"),
        "rustdoc_flags": attrs.list(attrs.string(), default = []),
        "warn_lints": attrs.list(attrs.string(), default = []),
    },
    doc = """
    Creates a rust toolchain that is required by all Rust rules.

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
    """,
    is_toolchain_rule = True,
)
