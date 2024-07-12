{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.home-manager ];
  programs.home-manager.enable = true;
}
