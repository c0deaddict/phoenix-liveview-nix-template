{ pkgs }: rec {
  demo = pkgs.callPackage ./demo.nix {};
}
