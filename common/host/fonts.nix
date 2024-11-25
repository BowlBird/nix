{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    corefonts
    vistafonts
    google-fonts
    font-awesome
  ];
}
