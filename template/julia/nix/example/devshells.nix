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
  gh = getExe pkgs.github-cli;
  git = getExe pkgs.git;
  qto = getExe pkgs.quarto;
in l.mapAttrs (_: mkShell) {
  default = { ... }: {
    name = "Julia devshell";

    imports = [ std.std.devshellProfiles.default ];

    packages = with pkgs; [
      quarto
      librsvg # for quarto to convert to pdf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-extra
      stix-otf
      stix-two
      fira-math
      texliveFull
      (julia_111-bin.withPackages.override {
        precompile = true;
        extraLibs = [
          "${pkgs.libGL}/lib"
          "${pkgs.xorg.libX11}/lib"
          "${pkgs.xorg.libXcursor}/lib"
          "${pkgs.xorg.libXi}/lib"
          "${pkgs.xorg.libXinerama}/lib"
          "${pkgs.xorg.libXrandr}/lib"
        ];
        packageOverrides = {
          "REPLVim" = fetchFromGitHub {
            owner = "andreypopp";
            repo = "julia-repl-vim";
            rev = "49dc50348df20cc54628b4599d0ce89bd07213e5";
            sha256 = "sha256-M5Tx3iqCTqUxwuw7bbyJKI3sHHanZYvDrZ3r0p+LRl4=";
          };
        };
      } [
        "Plots"
        "GraphRecipes"
        "Graphs"
        "CairoMakie"
        "Documenter"
        "Coverage"
        "OhMyREPL"
        "Revise"
        "REPLVim"
        "SpecialFunctions"
        # "GLMakie"
        "DataFrames"
        "Statistics"
        # "GtkReactive"
        # "GtkObservables"
        "QuartoNotebookRunner"
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
        name = "jlt";
        category = "Julia";
        help = "Run all tests";
        command = ''
          julia -e 'using Pkg; Pkg.test()' --project=.
        '';
      }
      {
        name = "gdoc";
        category = "Julia";
        help = "Generate document by Documemter";
        command = ''
          julia --project=docs -e 'using Pkg; Pkg.develop(PackageSpec(; path=pwd())); Pkg.instantiate();'
          julia --project=docs docs/make.jl deploy
        '';
      }
      {
        name = "repl";
        category = "Julia";
        help = "Julia REPL";
        command = ''
          julia --project=.
        '';
      }
      {
        name = "stupp";
        category = "Init";
        help = "Setup project with PkgTemplate";
        command = ''
          setupTmp
          gentp tmp
          GEN_DIR="tmp/''${PRJ_ROOT}"
          cp ''${GEN_DIR}/LICENSE .
          cp ''${GEN_DIR}/.gitignore .
          cp ''${GEN_DIR}/.JuliaFormatter.toml .
          cp ''${GEN_DIR}/Manifest.toml .
          cp ''${GEN_DIR}/Project.toml .
          cp ''${GEN_DIR}/README.md .
          cp -r ''${GEN_DIR}/docs .
          cp -r ''${GEN_DIR}/.github .
          rm -rf tmp
          julia -e 'using Pkg; Pkg.add(["Plots", "GLMakie", "Distributions", "QuartoNotebookRunner"]);' \
          --project=.
          julia -e 'using Pkg; Pkg.add(["Plots", "GLMakie", "Distributions", "DocumenterCitations"]);' \
          --project=docs
          qto add pat-alt/quarto-julia
          qto add pat-alt/documenterjl
        '';
      }
      {
        name = "gentp";
        category = "Init";
        help = "gentp <tmp_dir> :Generate PkgTemplate in <tmp_dir>: ";
        command = ''
          julia nix/example/pkgTemplate/genprj.jl $GH_USER $PRJ_ROOT $1
        '';
      }
      {
        name = "gcov";
        category = "Julia";
        help = "Generate test coverage";
        command = ''
          julia --project=. nix/example/pkgTemplate/gencov.jl $PRJ_NAME
        '';
      }
      {
        name = "cln";
        category = "Julia";
        help = "Clean .cov coverage files";
        command = ''
          julia --project=. nix/example/pkgTemplate/covclean.jl
        '';
      }
      {
        name = "gpr";
        category = "Init";
        help = "get project root dir";
        command = ''
          PWD=$(pwd)
          baseName=$(basename $(echo $PWD))
          echo $baseName
        '';
      }
      {
        name = "gprn";
        category = "Init";
        help = "get project root dir without jl extension";
        command = ''
          baseName=$(gpr)
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
          repSed src/ProjectName.jl PRJ_NAME $PRJ_NAME
          mv src/ProjectName.jl src/''${PRJ_NAME}.jl

          repSed test/runtests.jl PRJ_NAME $PRJ_NAME
          repSed test/sample/tests.jl PRJ_NAME $PRJ_NAME
          repSed docs/src/graph.md PRJ_NAME $PRJ_NAME
          repSed tutorials/_quarto.yml PRJ_NAME $PRJ_NAME
          repSed tutorials/quartoEx.qmd PRJ_NAME $PRJ_NAME
        '';
      }
      {
        name = "gls";
        category = "github";
        help = "ghrls: check repostitory status";
        command = ''
          ${gh} repo ls $GH_USER --limit=1000
        '';
      }
      {
        name = "gcr";
        category = "github";
        help = "ghrcc <repo_name> <private|public> : create github repo";
        command = ''
          ${gh} repo create "''${GH_USER}/$1" --$2
        '';
      }
      {
        name = "ged";
        category = "github";
        help = "ghred <private|public>: change github visibility";
        command = ''
          ${gh} repo edit "''${GH_USER}/''${PRJ_ROOT}" --visibility $1 \
          --accept-visibility-change-consequences
        '';
      }
      {
        name = "gph";
        category = "github";
        help = "git push origin HEAD";
        command = ''
          ${git} push origin HEAD
        '';
      }
      {
        name = "qto";
        category = "quarto";
        help = "quarto wrapper to fix write permission.";
        command = ''
          target="''${XDG_RUNTIME_DIR}/julia/Project.toml"
          if [ -f "$target" ] && [ ! -w "$target" ]; then
            echo "File $target is not writable."
            echo "Changing permissions to 744."
            chmod 744 $target
          fi
          ${qto} $@
        '';
      }
      {
        name = "qts";
        category = "quarto";
        help = "quarto extensions status";
        command = ''
          ${qto} list extensions
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
      {
        name = "GH_USER";
        eval = ''
          $(${git} config --get remote.origin.url | ${sed} -n 's/.*github.com[:\/]\([^\/]*\)\/.*/\1/p')
        '';
      }
      {
        name = "PRJ_ROOT";
        eval = "$(gpr)";
      }
      {
        name = "PRJ_NAME";
        eval = "$(gprn)";
      }
      {
        name = "XDG_RUNTIME_DIR";
        eval = "/run/user/$(id -u)";
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
