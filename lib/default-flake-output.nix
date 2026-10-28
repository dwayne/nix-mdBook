{ mkProject }:

args:

let
  project = mkProject args;
in
{
  # nix develop
  devShells.default = project.devShell;

  # nix build -L
  packages = {
    inherit (project) book;
    default = project.book;
  };

  # nix run
  # nix run .#serve
  #
  # nix run .#deploy
  apps =
    let
      serve = project.serveBookApp;
    in
    {
      inherit serve;
      default = serve;
      deploy = project.deployBookApp;
    };

  # nix flake check -L
  checks = { inherit (project) book serveBook deployBook; };
}
