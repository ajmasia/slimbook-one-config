{pkgs, ...}: let
  notify = "${pkgs.libnotify}/bin/notify-send";
  pkill = "${pkgs.procps}/bin/pkill";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  bspc = "${pkgs.bspwm}/bin/bspc";
in
  pkgs.writeShellScriptBin "bspc_restart" ''
    ${pkill} polybar
    ${pkill} sxhkd
    # ${pkill} insync
    ${pkill} -f cloud-drive*
    ${systemctl} --user restart picom.service
    ${bspc} wm -r
    ${notify} 'BSPWM' \
      'Restart process finished' \
  ''
