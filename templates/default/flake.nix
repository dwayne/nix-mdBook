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
          name = "my-book";
          branch = "gh-pages";
          root = ./.;
          paths = [
            ./src
            ./book.toml
          ];
          deploy = deploy.packages.${system}.default;
        };
      in
      {
        devShells.default = project.devShell;
        packages.default = project.book;
        apps.deploy = project.deployBookApp;
      }
    );
}
