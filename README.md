# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

Add it as an input:

```nix
inputs.mdBook.url = "github:dwayne/nix-mdBook";
```

The flake has no inputs of its own.

### Templates

Show all available templates.

```bash
nix flake show github:dwayne/nix-mdBook
```

#### Default

```bash
nix flake new --template github:dwayne/nix-mdBook#default my-book

# or, inside an existing directory

nix flake init --template github:dwayne/nix-mdBook#default
```

### Shell

```nix
devShells.default = mdBook.lib.mkShell pkgs {
  name = "my-book";
}
```

#### [`mkShell`](./lib/mk-shell.nix)

A [`callPackage`](https://nix.dev/tutorials/callpackage.html) compatible function that returns another function for creating a shell that is tailor-made for writing your book with [`mdBook`](https://rust-lang.github.io/mdBook/).

Required arguments:

- `name` - The name of the shell.

Optional arguments:

- `languages` - The languages supported by [`highlight.js`](https://github.com/highlightjs/highlight.js/tree/10.1.1).
- `autogenerateHighlightJs` - Determines whether or not the custom `theme/highlight.js` is automatically generated when you enter the shell.
- `extraPackages` - Additional packages to add to the shell.
- `extraShellHook` - Additional Bash commands you want to run when you first enter the shell.
