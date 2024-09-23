{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHome ./. {
  imports = sysUtils.buildImports {
    home = [
      "hyprland/bowlbird"
      "xdg/bowlbird"
    ];
    home-programs = [
      "git/bowlbird"
      "kitty"
      "chromium"
    ];
  };
}
