{ lib
, newScope

, deploy
}:

lib.makeScope newScope (self: {
  mkProject = lib.makeOverridable (self.callPackage ./mk-project.nix {});
  buildBook = lib.makeOverridable (self.callPackage ./build-book.nix {});
  mkDeployBook = lib.makeOverridable (self.callPackage ./mk-deploy-book.nix { inherit deploy; });
  mkHighlightJs = lib.makeOverridable (self.callPackage ./mk-highlight-js.nix {});
  mkDevShell = lib.makeOverridable (self.callPackage ./mk-dev-shell.nix {});
})
