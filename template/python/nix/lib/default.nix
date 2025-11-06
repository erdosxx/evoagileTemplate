{ flake, inputs, ... }:
let
  inherit (inputs) uv2nix pyproject-nix pyproject-build-systems;
  inherit (inputs) nixpkgs;
  config = import ./config.nix { inherit flake inputs; };

  workspace = uv2nix.lib.workspace.loadWorkspace {
    workspaceRoot = ../../.; # Root of your flake/project
  };

  overlay = workspace.mkPyprojectOverlay {
    sourcePreference = "wheel"; # Or "sdist"
  };

  editableOverlay =
    workspace.mkEditablePyprojectOverlay { root = "$REPO_ROOT"; };
in rec {
  inherit (config) pyDefaultVer myCustomOverrides mkPyPkgNotUV basePkgs;

  mkPythonSet = { python, pkgs, }:
    let
      basePythonSet =
        pkgs.callPackage pyproject-nix.build.packages { inherit python; };
    in basePythonSet.overrideScope (nixpkgs.lib.composeManyExtensions [
      pyproject-build-systems.overlays.default # For build tools
      overlay # Your locked dependencies
      editableOverlay # For editable installs
      myCustomOverrides # Your fixes
    ]);

  projectInToml =
    (builtins.fromTOML (builtins.readFile ../../pyproject.toml)).project;

  mkPyTomlEnv = { python, pkgs, }:
    let pythonSet = mkPythonSet { inherit python pkgs; };
    in pythonSet.mkVirtualEnv (projectInToml.name + "-env")
    workspace.deps.default; # Uses deps from pyproject.toml [project.dependencies]

  shellTempl = { pyVer, pkgs, system, }:
    let
      python = pkgs."python${pyVer}";
      pyPkgs = pkgs."python${pyVer}Packages";
      bPkgs = basePkgs { inherit pkgs system; };
      pythonSet = mkPythonSet { inherit python pkgs; };
      pyTomlEnv = mkPyTomlEnv { inherit python pkgs; };
      pyPkgsNotUV = mkPyPkgNotUV { inherit pyPkgs; };
      shellname = "pkg${pyVer}";
    in {
      packages = bPkgs ++ pyPkgsNotUV ++ [ pyTomlEnv ];
      shellHook = config.shellHook { inherit pkgs pythonSet shellname; };
    };

  mkPkg = { pyVer, pkgs, }:
    let
      python = pkgs."python${pyVer}";
      pyPkgs = pkgs."python${pyVer}Packages";
      pyTomlEnv = mkPyTomlEnv { inherit python pkgs; };
      pyPkgsNotUV = mkPyPkgNotUV { inherit pyPkgs; };
    in pkgs.stdenv.mkDerivation rec {
      pname = projectInToml.name;
      inherit (projectInToml) version;
      src = ../../src/${pname}/.; # Source of your main script

      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildInputs = pyPkgsNotUV ++ [ pyTomlEnv ];
      installPhase = ''
        mkdir -p $out/bin
        cp main.py $out/bin/${pname}-script
        chmod +x $out/bin/${pname}-script
        makeWrapper ${pyTomlEnv}/bin/python $out/bin/${pname} \
          --add-flags $out/bin/${pname}-script
      '';
    };
}
