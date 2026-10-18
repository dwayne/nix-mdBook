{ lib

, buildBook
, mkDeployBook
, mkDevShell
}:

{ name  # The name of the book
, root  # A path to the directory containing the book.toml
, paths # A list of paths to all the files needed to build the book

  # The options you want to pass on to mkDevShell (see ./mk-dev-shell.nix)
, devShellOptions ? {}

  # The branch to which you want to deploy
, branch ? "gh-pages"
}:

let
  book = buildBook {
    inherit name;
    src = lib.fileset.toSource {
      inherit root;
      fileset = lib.fileset.unions paths;
    };
  };

  deployBook = mkDeployBook { inherit book branch; };
in
{
  inherit book deployBook;

  devShell = mkDevShell devShellOptions;

  app = {
    type = "app";
    program = lib.getExe deployBook;
    meta.description = "Deploy the book to branch '${branch}'";
  };
}
