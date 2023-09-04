let
  configHome = (import ../constants.nix).configHome;
in
[
  {
    xdg = {
      inherit configHome;

      enable = true;

      desktopEntries = import ./desktop.nix;
      mimeApps = import ./mine.nix;

      configFile = {
        "ranger" = {
          recursive = true;
          source = ./config/ranger;
        };
      };
    };
  }
]
