{ pkgs, inputs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with inputs.nix-vscode-extensions.extensions.x86_64-linux.vscode-marketplace; [
      pkief.material-icon-theme
        kydronepilot.material-deep-ocean-theme
        rust-lang.rust-analyzer
        jnoortheen.nix-ide
    ];
    userSettings = {
      "workbench.colorTheme" = "Material Deep Ocean";
      "window.menuBarVisibility" = "hidden";
      "workbench.iconTheme" = "material-icon-theme";
      "nix.enableLanguageServer" = true;
    };
  };
}
