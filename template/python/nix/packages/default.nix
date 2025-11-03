{ pkgs, flake, }:
let
  inherit (flake.lib) mkPkg pyDefaultVer;
in mkPkg {
  inherit pkgs;
  pyVer = pyDefaultVer;
}
