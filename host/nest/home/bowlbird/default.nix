{ inputs, sysUtils, lib, config, pkgs, ... }: {
  imports = sysUtils.buildImports {
    home-programs = [
      "git-bowlbird"
    ];
  };

  home = {
    username = "bowlbird";
    homeDirectory = "/home/bowlbird";
    stateVersion = "24.05";
    packages = with pkgs; [];
  };
}
