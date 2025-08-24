{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    version = "0.15.0";
    hashes = {
      x86_64-linux = "sha256-GtLRQuS8Jw8ltVT5mpZxmfAewQu5eXmk8d0Gh5ROtMk=";
      aarch64-linux = "TODO";
      x86_64-darwin = "TODO";
      aarch64-darwin = "TODO";
    };
    systems = builtins.attrNames hashes;
  in
    flake-utils.lib.eachSystem systems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "zls";
        version = version;

        src = pkgs.fetchzip {
          url = "https://github.com/zigtools/zls/releases/download/${version}/zls-${system}.tar.xz";
          sha256 = hashes.${system};
          stripRoot = false;
        };

        installPhase = ''
          mkdir -p $out/bin
          cp -r * $out/bin
        '';
      };
    });
}
