{ ... }: {
  programs.niri.settings.binds = {
    "Ctrl+Alt+Delete".action.quit.skip-confirmation = true;
  };
}