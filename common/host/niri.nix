{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri-unstable;
  inputs.niri.cache.enable = false;
}