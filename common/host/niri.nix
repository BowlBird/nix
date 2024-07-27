{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
  programs.niri.package = pkgs.niri-unstable;
  inputs.niri.cache.enable = false;
}