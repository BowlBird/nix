{ pkgs, ... }: {
    environment.systemPackages = [ pkgs.xorg.xprop ];
}
