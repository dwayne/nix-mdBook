# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

### Create your book

Get started quickly by using the default template:

```bash
nix flake new --template github:dwayne/nix-mdBook#default my-book
cd my-book
```

Initialize a Git repository:

```bash
git init
git add .
git commit -m "Initial commit"
```

Enter the development environment and serve your book:

```bash
nix develop
# Write your book
#
# Type 'init' or 'i' to get started
# Type 'build' or 'b' to build your book
# Type 'serve' or 's' to serve your book
# Type 'deploy' or 'd' to deploy your book
# Type 'clean' to remove build artifacts
#
# (my-book-env)
serve
```

Finally, start to write your book and watch your changes live in the browser.

### Deploy your book

Deploy your book using GitHub pages as follows:

1. Create a new repository on GitHub.

It currently assumes the remote is called `origin` and the default branch is called `master`.

2. Run `deploy`.

The first time it runs it builds your book, copies the generated files to a new orphan branch called `gh-pages` and pushes it to GitHub.

On subsequent runs it only commits the changes you made to the `gh-pages` branch and pushes those up to GitHub.

3. Tell GitHub Pages to serve your book from the `gh-pages` branch.

Read [Configuring a publishing source for your GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

## FAQ

### How to configure `highlight.js`

#### Don't autogenerate it

```nix
project = mdBook.lib.mkProject pkgs {
  # ...

  shell = {
    autogenerateHighlightJs = false;
  };
}
```

#### Change the languages it supports

Maybe you want to write about context-free grammars:

```nix
project = mdBook.lib.mkProject pkgs {
  # ...

  shell = {
    languages = [ "abnf" "bnf" "ebnf" ];
  };
}
```

## Examples

- [How I Built freeCodeCamp's Calculator with Elm](https://github.com/dwayne/elm-calculator-tutorial)
