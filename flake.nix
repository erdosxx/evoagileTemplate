{
  description = "development project templates";

  outputs = { self }: {
    template.python = {
      path = ./template/python;
      description = "Python project template with poetry2nix";
    };
    template.bash = {
      path = ./template/bash;
      description = "Bash project template with bats testing framework.";
    };
    template.julia = {
      path = ./template/julia;
      description = "Julia project template with testing, documenter and CI.";
    };
  };
}
