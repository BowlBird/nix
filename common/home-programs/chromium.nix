{ pkgs, ... }: {
  home.packages = [ pkgs.chromium ];
  programs.chromium = {
    enable = true;
  };
}
