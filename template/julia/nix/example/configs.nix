{ inputs, cell }:
let
  pkgs = inputs.nixpkgs;
  inherit (inputs.std.lib) cfg;
  inherit (inputs.std.lib.dev) mkNixago;
  # l = nixpkgs.lib // builtins;

in {
  just = (mkNixago cfg.just) {
    data.tasks = import ./justfile.nix { inherit inputs cell; };
  };
}
