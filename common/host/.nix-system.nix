{ pkgs, ... }: {
  system = pkgs.writeScriptBin "system" ''
    echo "hi"
  '';

  environment.systemPackages = [system];
}
