{ inputs, sysUtils, lib, config, pkgs, ... }: {
  imports = sysUtils.buildImports {
    host = [
      "nix-settings"
      "boot-systemd-splash"
      "audio-pipewire"
      "network-manager"
      "console"
      "libinput"
      "printing"
    ];
    host-programs = [
      "zsh"
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

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
