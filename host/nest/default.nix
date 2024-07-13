{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHost ./. {
  imports = sysUtils.buildImports {
    host = [
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

  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";
}
