{ pkgs, ... }: {
  home.packages = [ pkgs.kitty ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    enable_audio_bell = false;
  };
}
