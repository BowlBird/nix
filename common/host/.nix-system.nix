{ pkgs, ... }: {
  pkgs.writeScriptBin "system" ''
    echo "hi"
  '';
}
