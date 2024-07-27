{ pkgs, inputs, ... }: {
  imports = [ inputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri;
  programs.niri.enable = true;
  inputs.niri-flake.cache.enable = false;
}