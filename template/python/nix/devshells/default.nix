{ pkgs, flake, system, ... }:
let inherit (flake.lib) shellTempl pyDefaultVer;
in pkgs.mkShell (shellTempl {
  inherit pkgs system;
  pyVer = pyDefaultVer;
})
