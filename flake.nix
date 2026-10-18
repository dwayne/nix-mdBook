{
  description = "Reusable Nix tooling for writing books with mdBook";

  outputs = { self }:
    {
      lib.init = pkgs: deploy: pkgs.callPackage ./lib { inherit deploy; };

      templates = {
        default = self.templates.basic;

        basic = {
          description = "A basic structure for your mdBook";
          path = ./templates/basic;
        };
      };
    };
}
