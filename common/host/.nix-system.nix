{ pkgs, ... }: {
  system = pkgs.writeScriptBin "system" ''
    echo "hi"
  '';
}
