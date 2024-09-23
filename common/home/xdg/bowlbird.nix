{ ... }: {
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      browser = "floorp.desktop";
    in
    {
      "x-scheme-handler/http" = [browser];
      "x-scheme-handler/https" = [browser];
    };
  };
}
