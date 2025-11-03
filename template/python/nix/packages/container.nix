{ pkgs, flake, }:
let
  inherit (flake.lib) mkPkg projectInToml pyDefaultVer;
  python = pkgs."python${pyDefaultVer}";

  pythonApp = mkPkg {
    inherit pkgs;
    pyVer = pyDefaultVer;
  };

  rootImage = pkgs.buildEnv {
    name = "my-docker-root";
    paths = [ python pythonApp ];
    pathsToLink = [ "/bin" ]; # python will be linked in /bin
  };
  pname = projectInToml.name;
in pkgs.dockerTools.buildLayeredImage {
  name = pname;
  tag = "latest";

  contents = [ rootImage ];

  config = {
    WorkingDir = "/bin";
    Cmd = [ "python" "${pname}-script" ];
  };
}
