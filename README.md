# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

Add it as an input:

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  flake-utils.url = "github:numtide/flake-utils";
  mdBook.url = "github:dwayne/nix-mdBook";
  deploy = {
    url = "github:dwayne/deploy";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };
};
```

Create a project:

```nix
project = mdBook.lib.mkProject pkgs {
  name = "my-book";
  branch = "gh-pages";
  root = ./.;
  paths = [
    ./src
    ./theme
    ./book.toml
  ];
  deploy = deploy.packages.${system}.default;
};
```

Use the development shell, book package, and deployment application as outputs of your flake:

```nix
{
  devShells.default = project.devShell;
  packages.default = project.book;
  apps.deploy = project.deployBookApp;
  checks = { inherit (project) book deployBook; };
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
