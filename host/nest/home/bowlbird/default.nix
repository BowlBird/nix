{ inputs, sysUtils, lib, config, pkgs, ... }: sysUtils.buildHome (dirName ./.) {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };

  username = "bowlbird";
}
