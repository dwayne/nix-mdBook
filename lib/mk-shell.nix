#
# Creates a shell that is tailor-made for writing your book with mdBook.
#
{ callPackage, lib, mdbook, mkShell, ... }:

{ name # The name of the shell

# The languages supported by highlight.js
, languages ? [ ":common" "elm" "haskell" "nix "]

# Determines whether or not the custom theme/highlight.js
# is automatically generated when you enter the shell
, autogenerateHighlightJs ? true

# The name to use for the deploy application
, deployAppName ? "deploy"

# Additional packages to add to the shell
, extraPackages ? []

# Additional Bash commands you want to run when
# you first enter the shell
, extraShellHook ? ""
}:

let
  highlightJs = callPackage ./mk-highlight-js.nix {} { inherit languages; };
in
mkShell {
  inherit name;

  packages = [
    mdbook
  ] ++ extraPackages;

  shellHook = ''
    export PROJECT_ROOT="$(git rev-parse --show-toplevel)"
    export PS1="($name)\n$PS1"

    init () {
      local title="$1"

      if [ -z "$title" ]; then
        echo "Please enter a title for your book." >&2
        return 1
      fi

      mdbook init --ignore none --title "$title"
    }
    alias i='init'

    generateHighlightJs () {
      install -Dm644 "${highlightJs}/highlight.js" "$PROJECT_ROOT/theme/highlight.js"
    }

    build () {
      mdbook build "$@"
    }
    alias b='build'

    serve () {
      mdbook serve "''${@:---open}"
    }
    alias s='serve'

    deploy () {
      nix run .#${deployAppName} -- "$@"
    }
    alias d='deploy'

    clean () {
      rm -rf "$PROJECT_ROOT/book"
    }

    ${lib.optionalString autogenerateHighlightJs ''
      if [ ! -f "$PROJECT_ROOT/theme/highlight.js" ]; then
        generateHighlightJs
      fi
    ''}

    echo "Write your book"
    echo ""
    echo "Type 'init' or 'i' to get started"
    echo "Type 'build' or 'b' to build your book"
    echo "Type 'serve' or 's' to serve your book"
    echo "Type 'deploy' or 'd' to deploy your book"
    echo "Type 'clean' to remove build artifacts"
    echo ""

    ${extraShellHook}
  '';
}
