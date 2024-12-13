{ pkgs, ... }: {
  home.packages = [ pkgs.kitty ];
  programs.kitty.enable = true;
  programs.kitty.font.name = "Noto Sans Mono";
  programs.kitty.settings = {
    enable_audio_bell = false;
    confirm_os_window_close = 0;
    window_padding_width = 5;
  };
  programs.kitty.extraConfig = ''
  include ./theme.conf
  '';
}
