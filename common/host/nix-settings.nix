{ ... }: {
  nix.settings.experimental-features = [
   "nix-command"
   "flakes"
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
