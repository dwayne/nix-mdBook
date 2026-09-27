{
  description = "Reusable Nix tooling for writing books with mdBook";

  outputs = _:
    {
      lib = {
        mkBook = import ./lib/mk-book.nix;
        mkDeployBook = import ./lib/mk-deploy-book.nix;
        mkShell = import ./lib/mk-shell.nix;
      };

      templates = {
        default = {
          description = "A default structure for your mdBook";
          path = ./templates/default;
        };
      };
    };
}
