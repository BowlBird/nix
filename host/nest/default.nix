{ inputs, sysUtils, lib, config, pkgs, ... }: sysUtils.buildHost {
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
  } ++ [./hardware-configuration.nix];

  hostName = "nest";
  timeZone = "America/Chicago";
  locale = "en_US.UTF-8";

  users.bowlbird = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}
