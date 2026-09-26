{ mdbook, mkShell, ... }:

{ name
, extraPackages ? []
, extraShellHook ? ""
}:

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

    build () {
      mdbook build "$@"
    }
    alias b='build'

    serve () {
      mdbook serve "''${@:---open}"
    }
    alias s='serve'

    clean () {
      rm -rf "$PROJECT_ROOT/book"
    }

    echo "Write your book"
    echo ""
    echo "Type 'init' or 'i' to get started"
    echo "Type 'build' or 'b' to build your book"
    echo "Type 'serve' or 's' to serve your book"
    echo "Type 'clean' to remove build artifacts"
    echo ""

    ${extraShellHook}
  '';
}
