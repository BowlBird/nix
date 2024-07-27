{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.home-manager ];
  news.display = "silent";
}
