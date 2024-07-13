{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHome ./. {
  imports = sysUtils.buildImports {
    home = [];
    home-programs = [
      "git/bowlbird"
    ];
  };
}
