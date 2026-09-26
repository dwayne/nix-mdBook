{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mdBook.url = "github:dwayne/nix-mdBook";
  };

  outputs = { self, nixpkgs, flake-utils, mdBook }:
    flake-utils.lib.eachDefaultSystem(system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = mdBook.lib.mkShell pkgs {
          name = "my-book";
        };
      }
    );
}
