{ inputs, sysUtils, lib, config, pkgs, ... }:
{
  imports = sysUtils.buildImports {
    host = [ "nix-settings" ];
  } ++ [./hardware-configuration.nix];

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;

    plymouth = {
      enable = true;
      theme = "bowlbird-logo";
      themePackages =  [
        inputs.plymouth-theme-bowlbird-logo.packages.x86_64-linux.default
      ];
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "rd.udev.log_priority=3"
   ];

    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
	editor = false;
	configurationLimit = 100;
      };
    };
  };
  networking.hostName = "nest";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
   font = "Lat2-Terminus16";
   keyMap = "us";
  };
  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.bowlbird = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	home-manager
 	zsh
  ];

  programs.zsh = {
	enable = true;
 	enableCompletion = true;

	setOptions = [
		"AUTO_CD"
		"HIST_IGNORE_DUPS"
	];

	autosuggestions = {
		enable = true;
	};

	syntaxHighlighting = {
		enable = true;
	};
	ohMyZsh = {
		enable = true;
		theme = "terminalparty";
		plugins = [
			"git"
		];
	};
};

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
