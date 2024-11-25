{ inputs, config, pkgs, ... }:  let
  matugen_config = (pkgs.formats.toml {}).generate "matugen_config" {
    type = "scheme-rainbow";
    config = {
    wallpaper = {
        command = "swww";
        arguments = ["img" "--transition-type" "center"];
        set = true;
      };
    };
    templates = {
        hyprland = {
            input_path = "${config.xdg.configHome}/matugen/hyprland-colors";
            output_path = "${config.xdg.configHome}/hypr/colors.conf";
        };

        kitty = {
            input_path = "${config.xdg.configHome}/matugen/kitty";
            output_path = "${config.xdg.configHome}/kitty/theme.conf";
        };
    };
  };
in {
    home.packages = [
        inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    systemd.user.tmpfiles.rules = [
        "L+ %h/.config/matugen/config.toml - - - - ${matugen_config}"
        "L+ %h/.config/matugen/hyprland-colors - - - - ${pkgs.writeTextFile {
                name = "hyprland-colors";
                text = builtins.readFile ./matugen-templates/hyprland;
            }
        }"
        "L+ %h/.config/matugen/kitty - - - - ${pkgs.writeTextFile {
                name = "kitty";
                text = builtins.readFile ./matugen-templates/kitty;
            }
        }"
    ];
    xdg.enable = true;
}
