{ pkgs, inputs, niri, ... }: {
  imports = [niri.nixosModules.niri];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri;
}