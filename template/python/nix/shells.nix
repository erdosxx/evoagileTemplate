{ pkgs, mkPythonSet, mkPyTomlEnv, mkPyPkgNotUV, pyDefaultVer, }:
let
  shellTempl = { pyVer }:
    let
      basePkgs = with pkgs; [
        # pylyzer
        pyright
        just
        ruff
        uv
        qt6.qtbase
        qt6.qtsvg
        gemini-cli
      ];
      python = pkgs."python${pyVer}";
      pyPkgs = pkgs."python${pyVer}Packages";
      pythonSet = mkPythonSet { inherit python; };
      pyTomlEnv = mkPyTomlEnv { inherit python; };
      # following pkgs need to setup here rather than uv(add)
      # to work correctly.
      pyPkgsNotUV = mkPyPkgNotUV { inherit pyPkgs; };
    in {
      packages = basePkgs ++ pyPkgsNotUV ++ [ pyTomlEnv ];
      shellHook = let
        getExe = pkgs.lib.getExe;
        git = getExe pkgs.git;
        pass = getExe pkgs.pass;
        sed = getExe pkgs.gnused;
        basename = "${pkgs.coreutils}/bin/basename";
        echo = "${pkgs.coreutils}/bin/echo";
        tr = "${pkgs.coreutils}/bin/tr";
        cat = "${pkgs.coreutils}/bin/cat";
        chmod = "${pkgs.coreutils}/bin/chmod";
        mv = "${pkgs.coreutils}/bin/mv";
      in ''
        # unset PYTHONPATH
        export UV_NO_SYNC=1
        export UV_PYTHON=${pythonSet.python.interpreter}
        export UV_PYTHON_DOWNLOADS=never
        export REPO_ROOT=$(${git} rev-parse --show-toplevel)
        export GEMINI_API_KEY="$(${pass} gemini/key1)"
        # Conventionally python project name should be all lower case letters
        export PRJ_NAME=$(${basename} $(${echo} $REPO_ROOT) | ${tr} '[:upper:]' '[:lower:]')

        # Create a script in $PATH every time devshell is entered
        ${cat} > $PWD/nix/replace-in-place.sh <<'EOF'
#!/usr/bin/env bash
# Usage: ./replace-in-place.sh file pattern replacement
${sed} "s/$2/$3/g" $1 > "$1.bak"
${mv} "$1.bak" $1
EOF
        ${chmod} +x $PWD/nix/replace-in-place.sh

        # Setup project name
        ${cat} > $PWD/nix/setup_prj.sh <<'EOF'
#!/usr/bin/env bash
nix/replace-in-place.sh pyproject.toml prj_name $PRJ_NAME      
nix/replace-in-place.sh uv.lock prj_name $PRJ_NAME      
nix/replace-in-place.sh tests/test_arithmetic.py prj_name $PRJ_NAME      
nix/replace-in-place.sh tests/test_hello_world.py prj_name $PRJ_NAME      
${git} mv src/prj_name src/$PRJ_NAME
EOF
        ${chmod} +x $PWD/nix/setup_prj.sh
        ${echo} "-----------------------------------------------------------------------------"
        ${echo} "To setup project name, run: ./nix/setup_prj.sh in project root only one time."
        ${echo} "Then edit README.md file to correct github repo path for badges."
        ${echo} "-----------------------------------------------------------------------------"
      '';
    };
in rec {
  # default = "pkg${pyDefaultVer}"; does not work.
  # pkgs.lib.getAttr enables dynamic selection from attribute sets using a string.
  default =
    pkgs.lib.getAttr "pkg${pyDefaultVer}" { inherit pkg312 pkg313 pkg314; };
  pkg312 = shellTempl { pyVer = "312"; };
  pkg313 = shellTempl { pyVer = "313"; };
  pkg314 = shellTempl { pyVer = "314"; };
}
