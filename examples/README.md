# About

This directory contains an example project using buck2.nix. See https://github.com/tweag/buck2.nix.

## Usage

1. Enter the devshell

    ```console
    $ nix develop
    ```

2. Run Buck2 commands

    * build the project

    ```console
    $ buck2 build ...
    ```

    * see which targets are available

    ```console
    $ buck2 targets ...
    ```

    * run a target

    ``` console
    $ buck2 run src/cxx:hello
    ```

    * list sub-targets

    ```console
    $ buck2 audit subtargets ...
    ```

    * only build a sub-target and show the output

    ``` console
    $ buck2 build --show-output src/rust:hello[doc]
    ```

See https://buck2.build/ for more detailed documentation.
