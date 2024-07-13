{ inputs, sysUtils, lib, config, pkgs, ... }: sysUtils.buildHome (dirname ./.) {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };
}
