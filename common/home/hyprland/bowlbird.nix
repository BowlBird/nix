{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      inputs.hyprland-easymotion.packages.${pkgs.system}.hyprland-easymotion
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      dwindle = {
        preserve_split = true;
      };
      misc = {
        disable_hyprland_logo = true;
	disable_splash_rendering = true;
      };
      input = {
      	accel_profile = "flat";
        touchpad = {
          natural_scroll = true;
        };
      };
      gestures = {
	workspace_swipe = true;
      };
      general = {
        resize_on_border = true;
      };
    };
    extraConfig = let
      bindModes = {
	    reset = [
	      "bind = , SUPER_L, submap, command"
	    ];
	    command = [
	      "bind = CONTROL_L ALT_L, Delete, exit"
	      "bind = , escape, submap, reset"
	      "bind = , T, exec, kitty"
	      "bind = , B, exec, xdg-open https://about:newtab"
	      "bind = , W, killactive"
	      "bindm = , mouse:272, movewindow"
	      "bind = , mouse:272, bringactivetotop"
	      "bindm = ALT_L, mouse:272, resizeactive"
	      "bind = , R, togglefloating"
	      "bind = , F, fullscreen, 0"
	      "bind = , SPACE, easymotion, action:hyprctl dispatch focuswindow address:{}"
	    ];
      };
      inlineConfig = let
        textSize = 48;
        padding = textSize;
        rounding = 0;
      in ''
      plugin:easymotion {
        textsize = ${builtins.toString textSize}
        textpadding = ${builtins.toString padding}
        textfont = Sans Mono SmallCaps Bold
        rounding = ${builtins.toString rounding}
        bgcolor=rgba(000000ff)
        bordersize = 1
        bordercolor=rgba(ffffffff)
      }
      '';
      createSubmaps = with pkgs.lib; modes: concatMapStrings (
        (bind: "${bind}\n")
        (flatten (
	  (mapAttrsToList (name: value: (["submap = ${name}"] ++ value)) modes))
	));
      in
	with pkgs.lib; (concatMapStrings (bind: "${bind}\n") (flatten ((mapAttrsToList (name: value: (["submap = ${name}"] ++ value)) bindModes)) ++ [ inlineConfig ]));
  };
}
