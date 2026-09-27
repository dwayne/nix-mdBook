{ mkBook, mkDeployBook, mkShell }:

pkgs:

{ name
, branch
, root
, paths
, deploy
, shell ? {}
}:

let
  book = mkBook pkgs {
    inherit name;
    src = pkgs.lib.fileset.toSource {
      inherit root;
      fileset = pkgs.lib.fileset.unions paths;
    };
  };
  deployBook = mkDeployBook pkgs { inherit book branch deploy; };
in
{
  inherit book deployBook;

  devShell = mkShell pkgs (shell // { inherit name; });

  deployBookApp = {
    type = "app";
    program = pkgs.lib.getExe deployBook;
    meta.description = "Deploy the book to branch '${branch}'";
  };
}
