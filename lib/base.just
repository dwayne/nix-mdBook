[default]
[private]
list:
    @just --list --unsorted

# Create your new book with the given title
init title:
  mdbook init --ignore none --title "{{title}}"

# Generate highlight.js
gen-highlight-js:
  install -Dm644 "$PROJECT_HIGHLIGHT_JS" "theme/highlight.js"

# Build your book from its markdown files
[positional-arguments]
build *args:
  mdbook build "$@"

# Serve your book at http://localhost:3000, and rebuild it on changes
[positional-arguments]
serve *args:
  mdbook serve "${@:---open}"

# Deploy your book
[positional-arguments]
deploy *args:
  nix run .#deploy -- "$@"

clean:
  rm -rf book result

alias i := init
alias g := gen-highlight-js
alias b := build
alias s := serve
alias d := deploy
