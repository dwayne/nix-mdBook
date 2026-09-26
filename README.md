# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

Add it as an input:

```nix
inputs.mdBook.url = "github:dwayne/nix-mdBook";
```

The flake has no inputs of its own.

```nix
let
  mkShell = mdBook.lib.mkShell pkgs;
in
{
  devShells.default = mkShell {
    name = "my-book";
  };
}
```

## What's in `lib`?

### [`mkShell`](./lib/mk-shell.nix)

A [`callPackage`](https://nix.dev/tutorials/callpackage.html) compatible function that returns another function for creating a shell that is tailor-made for writing your book with [`mdBook`](https://rust-lang.github.io/mdBook/).

Arguments:

- `name` - The name of the shell.
- `extraPackages` (optional) - Additional packages to add to the shell.
- `extraShellHook` (optional) - Additional Bash commands you want to run when you first enter the shell.
