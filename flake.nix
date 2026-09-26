{
  description = "Reusable Nix tooling for writing books with mdBook";

  outputs = _:
    {
      lib.mkShell = import ./lib/mk-shell.nix;
    };
}
