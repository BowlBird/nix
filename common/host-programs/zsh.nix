{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.zsh ];

  users.defaultUserShell = pkgs.zsh;

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
}
