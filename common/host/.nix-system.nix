{ pkgs, ... }: {

  environment.systemPackages = [
    (pkgs.writeScriptBin "system" ''
      echo "hi"
    '')
  ];
}
