{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-dart.url = "github:Cir0X/nix-dart";
  };

  outputs = { self, nixpkgs, ...}@inputs: inputs.flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system; 
      overlays = [ inputs.nix-dart.overlay ];
    };
  in {
    packages = rec {
      tofi-rbw-unwrapped = (pkgs.callPackage ./nix/tofi-rbw-unwrapped.nix {
        buildDartPackage = pkgs.buildDartPackage.override ({
          dart = pkgs.dart;
        });
      });
      
      tofi-rbw = (pkgs.callPackage ./nix/tofi-rbw.nix {
        inherit tofi-rbw-unwrapped;
      });
    };

    devShell = pkgs.mkShell {
      packages = with pkgs; [
        dart
      ];
    };
  }) // {
    overlays.default = final: prev: let 
      pkgs = import nixpkgs { 
        inherit (prev) system;
        overlays = [ inputs.nix-dart.overlay ];
      };
    in rec {
      tofi-rbw-unwrapped = (final.callPackage ./nix/tofi-rbw-unwrapped.nix {
        buildDartPackage = pkgs.buildDartPackage.override ({
          dart = final.dart;
        });
      });

      tofi-rbw = (final.callPackage ./nix/tofi-rbw.nix {
        inherit tofi-rbw-unwrapped;
      });
    };
  };
}
