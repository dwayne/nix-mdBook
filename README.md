# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

Add it as an input:

```nix
inputs.mdBook.url = "github:dwayne/nix-mdBook";
```

Create a project:

```nix
project = mdBook.lib.mkProject pkgs {
  inherit system;

  name = "my-book";
  branch = "gh-pages";
  root = ./.;
  paths = [
    ./src
    ./theme
    ./book.toml
  ];
};
```

Use the development shell, book package, and deployment application as outputs of your flake:

```nix
{
  devShells.default = project.devShell;
  packages.default = project.book;
  apps.deploy = project.deployBookApp;
}
```

## Templates

Show all available templates.

```bash
nix flake show github:dwayne/nix-mdBook
```

### Default

```bash
nix flake new --template github:dwayne/nix-mdBook#default my-book

# or, inside an existing directory

nix flake init --template github:dwayne/nix-mdBook#default
```
