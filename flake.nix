{
  description = "Phoenix Live View demo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      overlay = final: prev: import ./nix/pkgs/default.nix { pkgs = final; };

      packages = forAllSystems (system:
        import ./nix/pkgs/default.nix rec {
          pkgs = import nixpkgs { inherit system; };
        });

      defaultPackage = forAllSystems (system: self.packages.${system}.demo);

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = [ pkgs.bashInteractive ];
            buildInputs = with pkgs; [
              inotify-tools
              node2nix
            ];
          };
        });
    };
}
