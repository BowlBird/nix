{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    fira-code
    corefonts
    vistafonts
    google-fonts
    font-awesome
  ];

  fonts.fontconfig = {
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [
        "Noto Sans Mono"
        "emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "emoji"
      ];
      serif = [
        "Noto Serif"
        "emoji"
      ];
    };
  };
}
