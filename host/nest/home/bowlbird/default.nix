{ inputs, lib, config, pkgs, ... }: {
  
  imports = [];
  
  nixpkgs.config = {
	allowUnfree = true;
	allowUnfreePredicate = _: true;
  };

  home = {
    username = "bowlbird";
    homeDirectory = "/home/bowlbird";
    stateVersion = "24.11";
    packages = with pkgs; [];
  };

  programs.home-manager.enable = true;

  programs.git = {
  	enable = true;
  	userName = "bowlbird";
	  userEmail = "bowlbirdcontact@gmail.com";
 	  extraConfig = {
		  init.defaultBranch = "main";
	  };
  };
}
