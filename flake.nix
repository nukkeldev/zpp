{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zls = {
      url = ./nix/zls;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    systems = builtins.attrNames inputs.zig.packages;
  in
    flake-utils.lib.eachSystem systems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            inputs.zls.packages.${system}.default
            inputs.zig.packages.${system}."0.15.1"
          ];
        };

        formatter = pkgs.alejandra;
      }
    );
}
