{ pkgs, flake, ... }:
let
  inherit (flake.lib) shellTempl pyDefaultVer;
in pkgs.mkShell (shellTempl {
  inherit pkgs;
  pyVer = pyDefaultVer;
})
