{
  description = "Buck2 + nix project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    buck2-nix = {
      url = "github:tweag/buck2.nix";
      flake = false;
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      buck2-nix,
    }:
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
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          name = "buck2-shell";
          packages = [
            pkgs.buck2
            pkgs.git
            pkgs.nix
          ];
          shellHook = ''
            mkdir -p .buckconfig.d
            cat > .buckconfig.d/buck2-nix.config <<'EOF'
            [external_cell_nix]
              git_origin = https://github.com/tweag/buck2.nix.git
              commit_hash = ${buck2-nix.rev}
            EOF
          '';
        };
      });
    };
}
