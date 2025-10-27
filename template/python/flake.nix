{
  description = "template application using uv2nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    flake-utils.url = "github:numtide/flake-utils";

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs = {
        pyproject-nix.follows = "pyproject-nix";
        uv2nix.follows = "uv2nix";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, uv2nix, pyproject-nix
    , pyproject-build-systems, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # 1. Load Project Workspace (parses pyproject.toml, uv.lock)
        workspace = uv2nix.lib.workspace.loadWorkspace {
          workspaceRoot = ./.; # Root of your flake/project
        };

        # 2. Generate Nix Overlay from uv.lock (via workspace)
        overlay = workspace.mkPyprojectOverlay {
          sourcePreference = "wheel"; # Or "sdist"
        };

        editableOverlay =
          workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };

        # 3. Placeholder for Your Custom Package Overrides
        myCustomOverrides = final: prev:
          {
            # e.g., some-package = prev.some-package.overridePythonAttrs (...);
          };

        pkgs = import nixpkgs { inherit system; };

        mkPythonSet = { python }:
          let
            basePythonSet =
              pkgs.callPackage pyproject-nix.build.packages { inherit python; };
          in basePythonSet.overrideScope (nixpkgs.lib.composeManyExtensions [
            pyproject-build-systems.overlays.default # For build tools
            overlay # Your locked dependencies
            editableOverlay # For editable installs
            myCustomOverrides # Your fixes
          ]);

        # --- This is where your project's metadata is accessed ---
        projectInToml =
          (builtins.fromTOML (builtins.readFile ./pyproject.toml)).project;

        mkPyTomlEnv = { python }:
          let pythonSet = mkPythonSet { inherit python; };
          in pythonSet.mkVirtualEnv (projectInToml.name + "-env")
          workspace.deps.default; # Uses deps from pyproject.toml [project.dependencies]

        # python packages that need to be installed in flake not uv.
        mkPyPkgNotUV = { pyPkgs }: with pyPkgs; [ pyqt6 matplotlib ];

        # define default python version to setup devshell and package
        pyDefaultVer = "313";
      in {
        devShells = pkgs.lib.mapAttrs (_: pkgs.mkShell)
          ((import ./nix/shells.nix) {
            inherit pkgs mkPythonSet mkPyTomlEnv mkPyPkgNotUV pyDefaultVer;
          });

        packages = pkgs.lib.mapAttrs (_: pkgs.stdenv.mkDerivation)
          ((import ./nix/packages.nix) {
            inherit pkgs mkPyTomlEnv projectInToml mkPyPkgNotUV pyDefaultVer;
          });

        # App for `nix run`
        apps = let pname = projectInToml.name;
        in rec {
          default = {
            type = "app";
            program = "${self.packages.${system}.default}/bin/${pname}";
          };
          ${pname} = default;
        };
      });
}
