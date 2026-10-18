{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-deploy.url = "github:dwayne/deploy";
    flake-mdBook.url = "../.";
  };

  outputs = { self, nixpkgs, flake-utils, flake-deploy, flake-mdBook }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        deploy = flake-deploy.lib.mkDeploy pkgs;
        mdBook = flake-mdBook.lib.mkMdBook pkgs deploy;

        project = mdBook.mkProject {
          # The name of your book
          name = "my-book";

          # Where's the root of your project?
          root = ./.;

          # Which files are needed to build your book?
          paths = [
            ./src
            ./theme
            ./book.toml
          ];
        };
      in
      {
        # nix develop
        devShells.default = pkgs.mkShell {
          name = "my-book";
          inputsFrom = [ project.devShell ];
        };

        # nix build -L
        packages.default = project.book;

        # nix run .#deploy
        apps.deploy = project.app;

        # nix flake check -L
        checks = { inherit (project) book deployBook; };
      }
    );
}
