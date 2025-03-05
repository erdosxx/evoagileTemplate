{
  description = "Julia development environment";

  inputs = rec {
    std = {
      # url = "github:divnix/std";
      url = "github:divnix/std/5b19a01095518d1acbd1975b1903b83ace4fe0dd";
      inputs = {
        inherit devshell;
        inherit nixago;
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixpkgs = {
      # url = "github:NixOS/nixpkgs/nixos-unstable-small";
      url = "github:NixOS/nixpkgs/2ffed2bc3d27861b821f9bec127cf51a4dbfabb4";
    };

    devshell = {
      # url = "github:numtide/devshell";
      url = "github:numtide/devshell/f7795ede5b02664b57035b3b757876703e2c3eac";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixago = {
      # url = "github:nix-community/nixago";
      url =
        "github:nix-community/nixago/5133633e9fe6b144c8e00e3b212cdbd5a173b63d";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixgl = {
    #   # url = "github:nix-community/nixGL";
    #   url =
    #     "github:nix-community/nixGL/310f8e49a149e4c9ea52f1adf70cdc768ec53f8a";
    # };
  };

  outputs = { self, std, ... }@inputs:
    let
      # Get the directory name of the flake
    in std.growOn {
      inherit inputs;
      cellsFrom = ./nix;
      cellBlocks = with std.blockTypes; [
        # (runnables "apps")
        # (devshells "devshells" { extraArgs = { inherit flakeDir; }; })
        (devshells "devshells")
        (nixago "configs")
      ];
    } {
      # packages = std.harvest inputs.self [[ "example" "apps" ]];
      devShells = std.harvest inputs.self [ "example" "devshells" ];
    };
}
