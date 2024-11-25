{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHost ./. {
  imports = buildImports {
    host = [
      "auto-timezone"
      "nix-settings"
      "caps2esc"
      "auto-login/hyprland-bowlbird"
      "boot-systemd-splash"
      "fonts"
      "audio-pipewire"
      "network-manager"
      "ssh"
      "console"
      "libinput"
      "printing"
      "hyprland"
      "git"
    ];
    host-programs = [
      "gnupg"
      "zsh"
      "neovim"
      "zed"
      "floorp"
      "btop"
      "thunar"
      "pamixer"
      "swww"
      "imagemagick"
      "jq"
      "vesktop"
      "nwg-look"
      "wev"
    ];
  };
}
