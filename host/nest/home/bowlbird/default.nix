{ inputs, sysUtils, lib, config, pkgs, ... }: with.sysUtils; buildHome (dirName ./.) {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git-bowlbird"
    ];
  };
}
