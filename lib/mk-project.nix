{ lib
, mkShell

, buildBook
, devShell
, mkDeployBook
, mkServe
, DEFAULT_PATHS
, OPTIONAL_PATHS
}:

{ name
, root
, defaultPaths ? DEFAULT_PATHS
, extraPaths ? []
, devShellArgs ? {}
, serveArgs ? {}
, branch ? "gh-pages"
}:
let
  fs = lib.fileset;

  toAbsPath = s:
    let
      absPath = root + "/${s}";
    in
    if builtins.elem s OPTIONAL_PATHS then
      fs.maybeMissing absPath
    else
      absPath;

  book = buildBook {
    inherit name;
    src = fs.toSource {
      inherit root;
      fileset = fs.unions (builtins.map toAbsPath (defaultPaths ++ extraPaths));
    };
  };

  deployBook = mkDeployBook { inherit book branch; };
  serveBook = mkServe (serveArgs // { name = "serve-${name}"; root = book; });
in
{
  inherit book serveBook deployBook;

  devShell = mkShell (devShellArgs // {
    inherit name;
    inputsFrom = [ devShell ] ++ (devShellArgs.inputsFrom or []);
  });

  serveBookApp = {
    type = "app";
    program = lib.getExe serveBook;
    meta.description = "Serve the book";
  };

  deployBookApp = {
    type = "app";
    program = lib.getExe deployBook;
    meta.description = "Deploy the book to branch '${branch}'";
  };
}
