{
  description = "Packaging and development environments for various pieces of KDAB software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }: let
    supportedSystems = let
      inherit (flake-utils.lib) system;
    in [
      system.aarch64-linux
      system.x86_64-linux
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        # use overlays so packages can get each other from callPackage
        overlays = [
          (_: super: {
            KDAB = {
              envs = super.callPackage ./packages/envs {};
              software = super.callPackage ./packages/software {};
            };
          })
        ];
      };
    in {
      packages = {
        inherit (pkgs.KDAB) envs software;
        default = self.packages.${system}.software.charm;

        kdgpu-docs-debug = pkgs.KDAB.software.kdgpu.override {
          kdutils = pkgs.KDAB.software.kdutils.override {debug = true;};
          debug = true;
          docs = true;
        };
      };

      formatter = pkgs.alejandra;
    });
}
