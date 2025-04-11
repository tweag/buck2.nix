# buck2.nix

Integrate [Nix](https://nixos.org/) with [Buck2](https://buck2.build/) to configure toolchains and dependencies for a project.

# Motivation

Buck2 is a polyglot build system that is designed to be fast and efficient for large codebases. Buck2 relies on remote execution for build isolation to enforce hermetic builds, therefore does not isolate local build actions so strictly.

Nix is a powerful package manager and build system for Linux and other Unix-like operating systems which strives for reproducibility. The [`nixpkgs`](https://search.nixos.org/packages)
repository is a very comprehensive, large collection of software packaged using nix.

By integrating Nix with Buck2 and leveraging the `nixpkgs` package collection, a project can define its required build tools and toolchains (e.g. C++, Python, Rust) declaratively and reproducibly but still benefit from fast, reliable builds.

# Quickstart

To create a project using **buck2.nix**, run:

```console
$ nix flake new --template github:tweag/buck2.nix quickstart
```

To build the project, run:

```console
$ cd quickstart
$ nix develop
$ buck2 build ...
```

_Note:_ if you use [direnv](https://github.com/direnv/direnv), just run `direnv allow` in the project directory.

# Usage

1. add it to you `.buckconfig` setting the commit hash to the current main branch:

```ini
[external_cells]
nix = git

[external_cell_nix]
git_origin = https://github.com/tweag/buck2.nix.git
commit_hash = ...
```

2. add a nix flake to your project

e.g. in `tools/nix/flake.nix`:

``` nix
outputs = { ... }: {
  packages.${system}.python = python3;
}
```

3. use it in your project

in `tools/BUCK`:

```bazel
load("@nix//flake.bzl", "flake")

flake.package(
    name = "python"
    binary = "python",
    path = "nix",
)
```

See the [documentation](docs#flakepackage) and examples in [`examples/`](examples/).


# Links

* https://github.com/thoughtpolice/buck2-nix -- alternative prelude using nix

# Sponsors

buck2.nix was funded by [Mercury Technologies](https://mercury.com/) and is maintained by [Tweag](https://tweag.io/)

# License

[Apache 2.0](LICENSE)
