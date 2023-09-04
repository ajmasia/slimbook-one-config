{ pkgs, config, ... }:
let
  wallpaper = (import ../../constants.nix).wallpaper;
  # bspc_restart = pkgs.callPackage ../../window-manager/bspwm/scripts/bspc_restart.nix { };
  MAIN_MONITOR = (import ../../constants.nix).mainMonitor;
  PORTABLE_MONITOR = (import ../../constants.nix).portableMonitor;

  feh = "${pkgs.feh}/bin/feh";
  notify = "${pkgs.libnotify}/bin/notify-send";
in
{
  services.grobi = {
    enable = true;

    rules =
      [
        {
          name = "Home with two monitors connected";
          outputs_connected = [ MAIN_MONITOR PORTABLE_MONITOR ];
          configure_row = [ PORTABLE_MONITOR MAIN_MONITOR ];
          primary = MAIN_MONITOR;
          atomic = true;
          execute_after = [
            "${feh} --bg-fill ${wallpaper}"
          ];
        }
        {
          name = "Home with only main monitor connected";
          outputs_disconnected = [ PORTABLE_MONITOR ];
          outputs_connected = [ MAIN_MONITOR ];
          configure_single = MAIN_MONITOR;
          primary = MAIN_MONITOR;
          atomic = true;
          execute_after = [
            "${feh} --bg-fill ${wallpaper}"
          ];
        }
      ];
    executeAfter = [
      # TODO: Pending to mange startup process
      # "${bspc_restart}/bin/bspc_restart"
      # "${gb_check-startup}/bin/gb_check-startup"
      "${notify} 'Grobi' 'Monitors config has changed'"
    ];
  };
}
