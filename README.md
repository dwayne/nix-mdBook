# Nix for mdBook

Reusable Nix tooling for writing books with [`mdBook`](https://rust-lang.github.io/mdBook/).

## Usage

### Create your book

Get started quickly by using the default template:

```bash
nix flake new -t github:dwayne/nix-mdBook my-book
cd my-book

git init
git add .

nix develop

git add flake.lock justfile theme
git commit -m "Initial commit"
```

### Serve your book

```bash
just serve
```

Now you can start to write your book and watch your changes live in the browser.

### Deploy your book

Deploy your book using GitHub pages as follows:

1. Create a new repository on GitHub.

It currently assumes the remote is called `origin` and the default branch is called `master`.

2. `just deploy`.

The first time it runs it builds your book, copies the generated files to a new orphan branch called `gh-pages` and pushes it to GitHub.

On subsequent runs it only commits the changes you made to the `gh-pages` branch and pushes those up to GitHub.

3. Tell GitHub Pages to serve your book from the `gh-pages` branch.

Read [Configuring a publishing source for your GitHub Pages site](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site).

## FAQ

### How to configure `highlight.js`

#### Change the languages it supports

Maybe you want to write about context-free grammars:

```nix
project = mdBookLib.mkProject {
  # ...

  devShellOptions = {
    languages = [ "abnf" "bnf" "ebnf" ];
  };
}
```

#### Don't autogenerate it

```nix
project = mdBookLib.mkProject {
  # ...

  devShellOptions = {
    autogenerateHighlightJs = false;
  };
}
```

## Examples

- [How I Built freeCodeCamp's Calculator with Elm](https://github.com/dwayne/elm-calculator-tutorial)
