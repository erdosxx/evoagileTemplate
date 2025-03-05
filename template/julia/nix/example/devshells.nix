{ inputs, cell }:
let
  inherit (inputs) std;
  inherit (std.lib.dev) mkShell;
  inherit (cell) configs;
  # nixgl = inputs.nixgl;
  l = pkgs.lib // builtins;
  pkgs = inputs.nixpkgs;
  # pkgs = import inputs.nixpkgs {
  #   system = "x86_64-linux";
  #   overlays = [ nixgl.overlay ];
  # };
  inherit (l) getExe;
  sed = getExe pkgs.gnused;
in l.mapAttrs (_: mkShell) {
  default = { ... }: {
    name = "example devshell";

    imports = [ std.std.devshellProfiles.default ];

    packages = with pkgs;
      [
        # git
        (julia_111-bin.withPackages.override { precompile = true; } [
          "Plots"
          "GraphRecipes"
          "Graphs"
          # "GLMakie"
          "CairoMakie"
          "Documenter"
        ])
      ];

    nixago = with configs; [ just ];

    commands = [
      {
        name = "vi";
        category = "ops";
        help = "vi alias to neovim";
        command = ''nvim "$@"'';
      }
      {
        name = "jltest";
        category = "Julia";
        help = "Run all tests";
        command = ''
          julia -e 'using Pkg; Pkg.test()' --project=.
        '';
      }
      {
        name = "gendoc";
        category = "Julia";
        help = "Generate document by Documemter";
        command = ''
          julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(; path=pwd())); Pkg.instantiate();'
          julia --project=docs docs/make.jl deploy
        '';
      }
      {
        name = "jlrepl";
        category = "Julia";
        help = "Julia REPL";
        command = ''
          julia --project=.
        '';
      }
      {
        name = "getinput";
        category = "Gen Code";
        help = "Get first input parameter";
        command = ''
          echo $1
        '';
      }
      {
        name = "gentp";
        category = "Init";
        help = "Generate PkgTemplate in tmp: gentp <GitUserName>";
        command = ''
          julia nix/example/pkgTemplate/genprj.jl $1 $(pgr).jl tmp
        '';
      }
      {
        name = "gpr";
        category = "Init";
        help = "get project root dir without jl extension";
        command = ''
          PWD=$(pwd)
          baseName=$(basename $(echo $PWD))
          name_only="''${baseName%.*}"
          echo $name_only
        '';
      }
      {
        name = "repSed";
        category = "Init";
        help = "repSed <file> <pattern> <str>: Replace {{PATTERN}} to <str>";
        command = ''
          ${sed} "s/{{$2}}/$3/g" $1 > "$1.bak" 
          mv "$1.bak" $1
        '';
      }
      {
        name = "setupTmp";
        category = "Init";
        help = "Setup nix template with project root";
        command = ''
          prj_root=$(gpr)

          repSed src/ProjectName.jl PRJ_ROOT $prj_root
          mv src/ProjectName.jl src/"$prj_root".jl

          repSed test/runtests.jl PRJ_ROOT $prj_root
          repSed test/sample/tests.jl PRJ_ROOT $prj_root
        '';
      }
    ];

    env = [
      {
        name = "LD_LIBRARY_PATH";
        prefix =
          "${pkgs.libGL}/lib:${pkgs.xorg.libX11}/lib:${pkgs.xorg.libXcursor}/lib:${pkgs.xorg.libXi}/lib:${pkgs.xorg.libXinerama}/lib:${pkgs.xorg.libXrandr}/lib";
      }
      {
        name = "JULIA_GL_BACKEND";
        value = "glx";
      }
      # {
      #   name = "JULIA_CUDA_USE_BINARYBUILDER";
      #   value = "false";
      # }
      # {
      #   name = "NIXGL_COMMAND";
      #   value = "nixGL";
      # }
    ];
  };
}
