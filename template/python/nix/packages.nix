{
  pkgs,
  mkPyTomlEnv,
  projectInToml,
  mkPyPkgNotUV,
  pyDefaultVer,
}: let
  mkPkg = {pyVer}: let
    python = pkgs."python${pyVer}";
    pyPkgs = pkgs."python${pyVer}Packages";
    pyTomlEnv = mkPyTomlEnv {inherit python;};
    pyPkgsNotUV = mkPyPkgNotUV {inherit pyPkgs;};
  in rec {
    pname = projectInToml.name;
    inherit (projectInToml) version;
    src = ../src/${pname}/.; # Source of your main script

    nativeBuildInputs = [pkgs.makeWrapper];
    buildInputs = pyPkgsNotUV ++ [pyTomlEnv];
    installPhase = ''
      mkdir -p $out/bin
      cp main.py $out/bin/${pname}-script
      chmod +x $out/bin/${pname}-script
      makeWrapper ${pyTomlEnv}/bin/python $out/bin/${pname} \
        --add-flags $out/bin/${pname}-script
    '';
  };
in rec {
  # default = pkg313;
  default = pkgs.lib.getAttr "pkg${pyDefaultVer}" {
    inherit pkg312 pkg313 pkg314;
  };
  pkg312 = mkPkg {pyVer = "312";};
  pkg313 = mkPkg {pyVer = "313";};
  pkg314 = mkPkg {pyVer = "314";};
}
