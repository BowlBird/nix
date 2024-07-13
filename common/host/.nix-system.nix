{ pkgs, ... }: {
  environment.systemPackages = [(
    pkgs.writeScriptBin "system" ''
      rebuild() {
        level=$1
        flake=$2
        home=$HOME

        echo $level $flake $home

      }
      clean() {
        echo clean
      }
    ''
  )];
}
