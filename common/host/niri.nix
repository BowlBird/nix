{ pkgs, inputs, ... }: {
  imports = [ inputs.niri.nixosModules.niri ];
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  niri-flake.cache.enable = false; 

  programs.niri = {
    enable = true;
    package = pkgs.niri;

    config = ''
      binds {
        Ctrl+Alt+Delete { quit skip-confirmation=true; }
      }
    '';
  };
}