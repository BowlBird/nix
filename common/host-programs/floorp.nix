{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.floorp
  ];
}
