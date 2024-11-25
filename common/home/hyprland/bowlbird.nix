{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    plugins = [
      inputs.hyprland-easymotion.packages.${pkgs.system}.hyprland-easymotion
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
      inputs.hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    ];
    settings = {
      general = {
        border_size = 0;
        gaps_in = 10;
        gaps_out = 20;

        resize_on_border = true;
        extend_border_grab_area = 20;
      };
      decoration = {
        rounding = 5;
        shadow = {
            sharp = true;
            range = 0;
            offset = "10, 10";
        };
      };
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
    };

    extraConfig = let
      bindModes = {
	    reset = [
	      "bind = , super_l, submap, command"
		  "bindl = , XF86AudioMute, exec, pamixer --set-volume 0"
	      "bindrl = , XF86AudioLowerVolume, exec, pamixer -d 5"
	      "bindrl = , XF86AudioRaiseVolume, exec, pamixer -i 5"
	    ];
	    command = [
		  "bindl = , XF86AudioMute, exec, pamixer --set-volume 0"
	      "bindrl = , XF86AudioLowerVolume, exec, pamixer -d 5"
	      "bindrl = , XF86AudioRaiseVolume, exec, pamixer -i 5"
	      "bind = control_l alt_l, delete, exit"
	      "bind = , escape, submap, reset"
	      "bind = , t, exec, kitty"
		  "bind = , e, exec, thunar"
	      "bind = , b, exec, xdg-open https://about:newtab"
	      "bind = , w, killactive"
		  "bind = , s, togglesplit"
	      "bindm = , mouse:272, movewindow"
	      "bind = , mouse:272, bringactivetotop"
	      "bindm = alt_l, mouse:272, resizeactive"
	      "bind = , r, togglefloating"
	      "bind = , f, fullscreen, 0"
	      "bind = , space, easymotion, action:hyprctl --batch 'dispatch focuswindow address:{};dispatch bringactivetotop'"
		  "bind = shift, space , overview:open"
	    ] ++ (pkgs.lib.flatten (map
		    (x: [
				"bind = , ${builtins.toString (builtins.elemAt x 0)}, split:workspace, ${builtins.toString (builtins.elemAt x 1)}"
				"bind = control_l shift, ${builtins.toString (builtins.elemAt x 0)}, split:movetoworkspace, ${builtins.toString (builtins.elemAt x 1)}"
				"bind = shift, ${builtins.toString (builtins.elemAt x 0)}, split:movetoworkspacesilent, ${builtins.toString (builtins.elemAt x 1)}"
			])
			[[1 1] [2 2] [3 3] [4 4] [5 5] [6 6] [7 7] [8 8] [9 9] [0 10]]
		));
      };
      inlineConfig = let
        textSize = 48;
        padding = textSize;
        rounding = 0;
      in ''
      exec-once=swww-daemon
      exec-once=hyprctl dismissnotify
      source = ~/.config/hypr/colors.conf

      decoration:shadow:color = $shadow
      plugin:easymotion {
        textsize = ${builtins.toString textSize}
        textpadding = ${builtins.toString padding}
        rounding = 5
        textfont=Sans Small-Caps
        bgcolor=$primary_container
        bordersize = 0
        bordercolor=rgba(ffffffff)
      }

      plugin:hyprbars {
        bar_height = 30
        bar_color = $primary_container
        bar_part_of_window = true
        bar_precedence_over_border = true
        bar_text_size = 11
        bar_buttons_alignment = left
        bar_text_font = Noto Sans
        hyprbars-button = $primary_color, 12, , hyprctl dispatch killactive
        hyprbars-button = $secondary_color, 12, , hyprctl dispatch fullscreen 0
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
