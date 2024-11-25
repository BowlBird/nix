{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHome ./. {
  imports = sysUtils.buildImports {
    home = [
      "hyprland/bowlbird"
      "xdg/bowlbird"
      "theme/default"
    ];
    home-programs = [
      "git/bowlbird"
      "kitty"
      "chromium"
      "matugen"
    ];
  };
}
