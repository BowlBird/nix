{ inputs, sysUtils, lib, config, pkgs, ... }: {
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

  networking.hostName = "nest";
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.bowlbird = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [];
  };

  system.stateVersion = "24.05";
}
