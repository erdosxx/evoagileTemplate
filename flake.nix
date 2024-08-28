{
  description = "development project templates";

  outputs = { }: {
    templates.python = {
      path = ./template/python;
      description = "Python project template with poetry2nix";
    };
  };
}
