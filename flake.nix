{
  description = "Reusable Nix tooling for writing books with mdBook";

  outputs = _:
    {
      lib.mkShell = import ./lib/mk-shell.nix;

      templates = {
        default = {
          description = "A default structure for your mdBook";
          path = ./templates/default;
        };
      };
    };
}
