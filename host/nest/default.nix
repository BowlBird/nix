{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHost ./. {
  imports = buildImports {
    host = [
      "auto-timezone"
      "nix-settings"
      "boot-systemd-splash"
      "audio-pipewire"
      "network-manager"
      "ssh"
      "console"
      "libinput"
      "printing"
    ];
    host-programs = [
      "gnupg"
      "zsh"
      "neovim"
    ];
  };
}
