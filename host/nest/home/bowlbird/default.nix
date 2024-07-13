{ inputs, sysUtils, lib, config, pkgs, ... }: sysUtils.buildHome (builtins.dirname ./.) {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };
}
