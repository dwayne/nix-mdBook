{
  description = "Reusable Nix tooling for writing books with mdBook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-deploy = {
      url = "github:dwayne/deploy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-deploy }:
    let
      lib = nixpkgs.lib;
    in
    {
      overlays.default = lib.composeManyExtensions [
        flake-deploy.overlays.default
        (final: _: {
          nixMdBookPackages = final.callPackage ./lib {};
        })
      ];

      templates = {
        default = self.templates.minimal;

        minimal = {
          description = "The bare minimum required for your mdBook";
          path = ./templates/minimal;
        };
      };
    };
}
