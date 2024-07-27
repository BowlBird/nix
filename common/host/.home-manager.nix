{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.home-manager ];
  programs.home-manager.news.enable = false;
}
