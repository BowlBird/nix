{ inputs, sysUtils, lib, config, pkgs, ... }: with.sysUtils; buildHome (dirname ./.) {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };
}
