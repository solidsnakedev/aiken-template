{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # cargo2nix.url = "github:cargo2nix/cargo2nix/unstable";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    aiken = {
      url = "github:aiken-lang/aiken";
      inputs = {
        cargo2nix.url = "github:cargo2nix/cargo2nix/unstable";
      };
    };
      # inputs.nixpkgs.follows = "nixpkgs";
    # };
    # aiken.url = "github:solidsnakedev/aiken";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, aiken }:
    flake-utils.lib.eachDefaultSystem (system:
    let pkgs = import nixpkgs { inherit system; overlays = [overlay]; };
        # aikenPkgs = aiken.packages.${system};
        # aiken-lib = pkgs.callPackage aiken {};
        overlay = final : prev: {
          aiken = inputs.aiken.packages.${system};
        };
    in
      {
        # packages = rec {
        #   hello = pkgs.hello;
        #   default = aikenPkgs.aiken;
        # };
        packages = pkgs.aiken;
        # packages = aiken-lib.buildPackage ./.;
        # apps = rec {
          # hello = flake-utils.lib.mkApp { drv = self.packages.${system}.hello; };
          # default = hello;
        # };
        devShell = pkgs.aiken;
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ hello aiken];
        };
      }
    );

}

