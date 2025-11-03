{ flake, inputs, ... }: {
  # define default python version to setup devshell and package
  pyDefaultVer = "313";

  # base packages for devshell
  basePkgs = { pkgs }:
    with pkgs; [
      # pylyzer
      pyright
      just
      ruff
      uv
      qt6.qtbase
      qt6.qtsvg
      gemini-cli
    ];

  # python packages that need to be installed in flake not uv.
  # following pkgs need to setup here rather than uv(add)
  # to work correctly.
  mkPyPkgNotUV = { pyPkgs }: (with pyPkgs; [ pyqt6 matplotlib ]);

  myCustomOverrides = final: prev:
    {
      # e.g., some-package = prev.some-package.overridePythonAttrs (...);
    };

  shellHook = { pkgs, pythonSet, }:
    let
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
      nix/replace-in-place.sh Justfile prj_name $PRJ_NAME
      nix/replace-in-place.sh tests/test_arithmetic.py prj_name $PRJ_NAME
      nix/replace-in-place.sh tests/test_hello_world.py prj_name $PRJ_NAME
      ${git} mv src/prj_name src/$PRJ_NAME
      EOF
      ${chmod} +x $PWD/nix/setup_prj.sh
      ${echo} "-----------------------------------------------------------------------------"
      ${echo} "To setup project name, run: ./nix/setup_prj.sh in project root only one time."
      ${echo} "Then edit README.md file to correct github repo path for badges."
      ${echo} "Then configure environment by editing ./nix/lib/config.nix"
      ${echo} "-----------------------------------------------------------------------------"
    '';
}
