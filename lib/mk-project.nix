{ mkBook, mkDeployBook, mkShell }:

pkgs:

{ name
, src
, branch
, deploy
, shell ? {}
}:

let
  book = mkBook pkgs { inherit src name; };
  deployBook = mkDeployBook pkgs { inherit book branch deploy; };
in
{
  inherit book deployBook;

  devShell = mkShell pkgs (shell // { inherit name deployBook; });

  deployBookApp = {
    type = "app";
    program = pkgs.lib.getExe deployBook;
    meta.description = "Deploy the book to branch '${branch}'";
  };
}
