{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      mousetrap = (with pkgs; stdenv.mkDerivation {
          pname = "mousetrap";
          version = "1.0.0";
          src = fetchgit {
            url = "https://github.com/gholken/Mousetrap";
            rev = "9299933ea0cbaf39b36c6bfd3498474541884211";
            sha256 = "";
          };
          nativeBuildInputs = [
            cmake
            pkg-config
            xorg.libX11
            xorg.libXfixes
            libnotify
          ];
          buildPhase = "make -j $NIX_BUILD_CORES";
          installPhase = ''
            mkdir -p $out/bin
            mv $TMP/mousetrap $out/bin
          '';
        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = mousetrap;
      devShell = pkgs.mkShell {
        buildInputs = [
          mousetrap
          pkgs.libnotify
        ];
      };
    }
  );
}
