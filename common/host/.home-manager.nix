{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.home-manager ];
  programs.home-manager.news.display = "silent";
}
