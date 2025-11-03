{ pkgs, flake, ... }:
let inherit (flake.lib) shellTempl;
in pkgs.mkShell (shellTempl {
  inherit pkgs;
  pyVer = "313";
})
