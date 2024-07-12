{ inputs, sysUtils, lib, config, pkgs, ... }: sysUtils.buildHome {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };

  username = "bowlbird"
  # packages = with pkgs; [];
}
