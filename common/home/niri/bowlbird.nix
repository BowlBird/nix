{ inputs, ... }: {
  imports = [ inputs.niri.homeModules.niri ];
  programs.niri.settings.binds = {
    "Ctrl+Alt+Delete".action.quit.skip-confirmation = true;
  };
}