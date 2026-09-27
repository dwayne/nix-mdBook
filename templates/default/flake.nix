{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mdBook.url = "github:dwayne/nix-mdBook";
    deploy = {
      url = "github:dwayne/deploy";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, mdBook, deploy }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        project = mdBook.lib.mkProject pkgs {
          # The name of your book
          name = "my-book";

          # The branch to use for deployments
          branch = "gh-pages";

          # Where's the root of your project?
          root = ./.;

          # Which files are needed to build your book?
          paths = [
            ./src
            ./theme
            ./book.toml
          ];

          deploy = deploy.packages.${system}.default;
        };
      in
      {
        # nix develop
        devShells.default = project.devShell;

        # nix build
        packages.default = project.book;

        # nix run .#deploy
        apps.deploy = project.deployBookApp;
      }
    );
}
