{ inputs, cell, ... }: {
  std = {
    description = "add std in Nix Shell";
    content = ''
      nix shell github:divnix/std
    '';
  };
  sl = {
    description = "get std list";
    content = ''
      std list
    '';
  };
  up = {
    description = "update flake";
    content = ''
      nix flake update
    '';
  };
  dev = {
    description = "devshell env";
    content = ''
      std //example/devshells/default:enter
    '';
  };
}
