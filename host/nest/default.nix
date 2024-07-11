{ inputs, sysUtils, lib, config, pkgs, ... }: {
  imports = sysUtils.buildImports {
    host = [
      "nix-settings"
      "boot-systemd-splash"
    ];
  } ++ [./hardware-configuration.nix];


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
