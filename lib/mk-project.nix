{ mkBook, mkDeployBook, mkShell }:

pkgs:

{ name
, src
, branch
, deploy
}:

let
  book = mkBook pkgs { inherit src name; };
  deployBook = mkDeployBook pkgs { inherit book branch deploy; };
in
{
  inherit book deployBook;

  default = {
    devShell = mkShell pkgs { inherit name deployBook; };
    package = book;
    app = {
      type = "app";
      program = pkgs.lib.getExe deployBook;
      meta.description = "Deploy the book to branch '${branch}'";
    };
  };
}
