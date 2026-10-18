{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-deploy.url = "github:dwayne/deploy";
    flake-mdBook.url = "github:dwayne/nix-mdBook";
  };

  outputs = { self, nixpkgs, flake-deploy, flake-mdBook }:
    let
      lib = nixpkgs.lib;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      eachSupportedSystem = f:
        lib.foldAttrs
          lib.mergeAttrs
          {}
          (map
            (s: lib.mapAttrs (_: v: { ${s} = v; }) (f s))
            supportedSystems
          );
    in
    eachSupportedSystem(system:
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
