{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      # pkgs-s = forAllSystems (system: import nixpkgs { inherit system; });
      pkgs-s = system: import nixpkgs { inherit system; };
    in {
      packages = forAllSystems (system: let pkgs = pkgs-s system; in rec {
        default = pkgs.hello;
      });
      devShells = forAllSystems (system: let pkgs = pkgs-s system; in rec {
        default = pkgs.mkShell {
          buildInputs = [ pkgs.python311 ];
        };
      });
    };
}
