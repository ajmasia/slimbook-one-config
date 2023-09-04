{ pkgs, ... }:

let
  MAIN_MONITOR = (import ../../../constants.nix).mainMonitor;
  PORTABLE_MONITOR = (import ../../../constants.nix).portableMonitor;

  xrandr = "${pkgs.xorg.xrandr}/bin/xrandr";
  grep = "${pkgs.gnugrep}/bin/grep";
  bspc = "${pkgs.bspwm}/bin/bspc";
  notify = "${pkgs.libnotify}/bin/notify-send";
in
pkgs.writeShellScriptBin "bspc_set-monitors" ''
  is_displayPort_1_monitor_connected=$(${xrandr} --query | ${grep} '${PORTABLE_MONITOR} connected')
  is_hdmi_monitor_connected=$(${xrandr} --query | ${grep} '${MAIN_MONITOR} connected')

  if [[ $is_displayPort_1_monitor_connected == "" ]]; then
    ${bspc} monitor ${MAIN_MONITOR} -d I II III IV V VI VII VIII IX X

    ${notify} "Dell Monitor Connected"
  elif [[ $is_hdmi_monitor_connected == "" ]]; then
    ${bspc} monitor ${PORTABLE_MONITOR} -d I II III IV V VI VII VIII IX X

    ${notify} "Portable Dell Monitor Connected"
  else
    ${bspc} monitor ${PORTABLE_MONITOR} -d I
    ${bspc} monitor ${MAIN_MONITOR} -d II III IV V VI VII VIII IX X 
    ${bspc} desktop I -l monocle

    ${notify} "Window Manager" "Dual Monitors Connected" -i "~/.local/share/notify-icons/nixos.png"
  fi 
''
