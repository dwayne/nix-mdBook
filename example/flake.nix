{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mdBook.url = "../.";
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

        mdBookLib = mdBook.lib.init pkgs (deploy.packages.${system}.default);

        project = mdBookLib.mkProject {
          # The name of your book
          name = "example-book";

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
          name = "example-book";
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
