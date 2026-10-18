{ just
, lib
, mdbook
, mkShell

, mkHighlightJs
}:

{ # The languages supported by highlight.js
  languages ? [ ":common" "elm" "haskell" "nix" ]

  # Determines whether or not the custom theme/highlight.js
  # is automatically generated when you enter the shell
, autogenerateHighlightJs ? true
}:

let
  highlightJs = mkHighlightJs { inherit languages; };
in
mkShell {
  name = "mdBook";

  packages = [
    just
    mdbook
  ];

  shellHook = ''
    export PROJECT_ROOT="$PWD"
    export PROJECT_HIGHLIGHT_JS="${highlightJs}/highlight.js"
    export PROJECT_JUSTFILE="${./base.just}"

    if [ ! -f "$PROJECT_ROOT/justfile" ]; then
      install -Dm644 "${./user.just}" "$PROJECT_ROOT/justfile"
    fi

    ${lib.optionalString autogenerateHighlightJs ''
      if [ ! -f "$PROJECT_ROOT/theme/highlight.js" ]; then
        just gen-highlight-js
      fi
    ''}
  '';
}
