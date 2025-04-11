{
  description = "Buck2 toolchain flake";

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
      packages = forAllSystems (pkgs: {
        inherit (pkgs)
          bash
          clippy
          curl
          hello
          python3
          rustc
          ;

        cxx = pkgs.stdenv.mkDerivation {
          name = "buck2-cxx";
          dontUnpack = true;
          dontCheck = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildPhase = ''
            function capture_env() {
                # variables to export, all variables with names beginning with one of these are exported
                local -ar vars=(
                    NIX_CC_WRAPPER_TARGET_HOST_
                    NIX_CFLAGS_COMPILE
                    NIX_DONT_SET_RPATH
                    NIX_ENFORCE_NO_NATIVE
                    NIX_HARDENING_ENABLE
                    NIX_IGNORE_LD_THROUGH_GCC
                    NIX_LDFLAGS
                    NIX_NO_SELF_RPATH
                )
                for prefix in "''${vars[@]}"; do
                    for v in $( eval 'echo "''${!'"$prefix"'@}"' ); do
                        echo "--set"
                        echo "$v"
                        echo "''${!v}"
                    done
                done
            }

            mkdir -p "$out/bin"

            for tool in ar nm objcopy ranlib strip; do
                ln -st "$out/bin" "$NIX_CC/bin/$tool"
            done

            mapfile -t < <(capture_env)

            makeWrapper "$NIX_CC/bin/$CC" "$out/bin/cc" "''${MAPFILE[@]}"
            makeWrapper "$NIX_CC/bin/$CXX" "$out/bin/c++" "''${MAPFILE[@]}"
          '';
        };
      });
    };
}
