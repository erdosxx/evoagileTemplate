{
  description = "Python project template using poetry2nix";

  outputs = { self }: {
    templates.python = {
      path = ./template;
      description = "Python project template with poetry2nix";
    };
  };
}
