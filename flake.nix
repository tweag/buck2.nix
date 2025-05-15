{
  description = "Buck2 + nix flake rules";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;
      defaultSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = fn: lib.genAttrs defaultSystems (system: fn nixpkgs.legacyPackages.${system});
    in
    {
      apps = forAllSystems (pkgs: {
        generate-docs = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellApplication {
              name = "generate-docs";

              runtimeInputs = [
                pkgs.buck2
                pkgs.python3
              ];

              text = ''
                python3 docs/generate-docs.py
              '';
            }
          );
        };
      });
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          name = "buck2-shell";
          packages = [
            pkgs.buck2
            pkgs.git
            pkgs.python3
          ];
        };
      });
      templates.default = {
        path = ./examples;
        description = "buck2 + nix example project";
        welcomeText = ''
          # buck2 + nix
          ## quickstart

          Run `nix develop --command buck2 build ...` to build.

          ## docs
          See https://github.com/tweag/buck2.nix/blob/main/docs for documentation.
        '';
      };
    };
}
