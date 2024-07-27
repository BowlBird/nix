{ pkgs, inputs, ... }: {
  pkgs.overlays = [ inputs.niri.overlays.niri ];
  # programs.niri.package = pkgs.niri;
}