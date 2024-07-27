{ inputs, sysUtils, lib, config, pkgs, ... }: with sysUtils; buildHome ./. {
  imports = sysUtils.buildImports {
    home = [
      "niri/bowlbird"
    ];
    home-programs = [
      "git/bowlbird"
    ];
  };
}
