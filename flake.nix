{
  description = "Reusable Nix tooling for writing books with mdBook";

  outputs = _:
    {
      lib = let
        mkBook = import ./lib/mk-book.nix;
        mkDeployBook = import ./lib/mk-deploy-book.nix;
        mkShell = import ./lib/mk-shell.nix;
        mkProject = import ./lib/mk-project.nix {
          inherit mkBook mkDeployBook mkShell;
        };
      in { inherit mkBook mkDeployBook mkShell mkProject; };

      templates = {
        default = {
          description = "A default structure for your mdBook";
          path = ./templates/default;
        };
      };
    };
}
