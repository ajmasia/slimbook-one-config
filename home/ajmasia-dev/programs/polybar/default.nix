{ config, pkgs, ... }:

let
  userConfigPath = (import ../../constants.nix).configHome;

  custom-polybar-package = pkgs.polybar.override {
    alsaSupport = true;
    githubSupport = true;
    mpdSupport = true;
    pulseSupport = true;
  };

  # Main config
  global = pkgs.callPackage ./global.nix { };

  # bars
  dell-monitor = pkgs.callPackage ./bars/dell-monitor.nix { pkgs = pkgs; };
  # dell-external = pkgs.callPackage ./bars/dell-external.nix { pkgs = pkgs; };

  # tools
  # colors = builtins.readFile ./utils/colors.ini;
  spacers = pkgs.callPackage ./utils/spacers.nix { pkgs = pkgs; };

  # modules
  modules = pkgs.callPackage ./modules { };

  # scripts
  # pb_get-temp-path = pkgs.callPackage ./scripts/pb_get-temp-path.nix { };
in
with pkgs; {
  home = {
    packages = [ custom-polybar-package ];
  };

  xdg = {
    configFile."polybar/config.ini".source = writeText "polybar.conf" ''
      ${global}
      ${modules}
      ${spacers}
      ${dell-monitor}
    '';
  };
}
