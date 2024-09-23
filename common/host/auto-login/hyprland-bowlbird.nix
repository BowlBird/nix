{ pkgs, ... }:

let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  permissions = "touch /tmp/hyprland.log; chmod +770 /tmp/hyprland.log;";
  session = "${pkgs.hyprland}/bin/Hyprland";
  username = "bowlbird";
in {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session} > /tmp/hyprland.log";
        user = "${username}";
      };
      default_session = {
        command = "${tuigreet} -g 'Welcome' -r --asterisks -t --time-format '%A, %B %-d, %Y %-I:%M:%S %p' -c '${session}  > /tmp/hyprland.log'";
        user = "${username}";
      };
    };
  };
}
