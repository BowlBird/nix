{ pkgs, inputs, ... }: {
  environment.systemPackages = [ pkgs.home-manager ];
  inputs.home-manager.news.display = "silent";
}
