{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-utils-src = { url = "github:dwayne/nix-utils"; flake = false; };
    flake-nix-mdBook = {
      url = "../.";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-deploy.inputs.nix-utils-src.follows = "nix-utils-src";
    };
  };

  outputs = { self, nixpkgs, nix-utils-src, flake-nix-mdBook }:
    let
      lib = nixpkgs.lib;
      nixUtils = import nix-utils-src lib;
    in
    nixUtils.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ flake-nix-mdBook.overlays.default ];
        };
      in
      pkgs.nixMdBookPackages.defaultFlakeOutput {
        name = "example-book";
        root = ./.;
      }
    );
}
