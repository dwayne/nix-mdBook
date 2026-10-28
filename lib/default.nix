{ lib
, newScope

, deploy
}:

lib.makeScope newScope (self: {
  inherit deploy;

  defaultFlakeOutput = self.callPackage ./default-flake-output.nix {};
  mkProject = self.callPackage ./mk-project.nix {};
  buildBook = self.callPackage ./build-book.nix {};
  mkServe = self.callPackage ./mk-serve.nix {};
  mkDeployBook = self.callPackage ./mk-deploy-book.nix {};
  devShell = self.callPackage ./dev-shell.nix {};
  highlightJs = self.callPackage ./highlight-js.nix {};
  languages = self.DEFAULT_LANGUAGES;

  DEFAULT_PATHS = [
    "src"
    "theme"
    "book.toml"
  ];

  OPTIONAL_PATHS = [
    "theme"
  ];

  DEFAULT_LANGUAGES = [ ":common" "elm" "haskell" "nix" ];
})
