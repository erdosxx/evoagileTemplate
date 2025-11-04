{ pkgs, flake, system, ... }:
let inherit (flake.lib) shellTempl;
in pkgs.mkShell (shellTempl {
  inherit pkgs system;
  pyVer = "312";
})
