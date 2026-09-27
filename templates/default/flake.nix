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

        name = "my-book";
        branch = "gh-pages";
        paths = [
          ./src
          ./book.toml
        ];

        project = mdBook.lib.mkProject pkgs {
          inherit name branch;
          src = pkgs.lib.fileset.toSource {
            root = ./.;
            fileset = pkgs.lib.fileset.unions paths;
          };
          deploy = deploy.packages.${system}.default;
        };
      in
      {
        devShells.default = project.default.devShell;
        packages.default = project.default.package;
        apps.deploy = project.default.app;
      }
    );
}
