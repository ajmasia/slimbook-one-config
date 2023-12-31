{ pkgs, ... }:

let
  # scripts
  bspc_restart = pkgs.callPackage ../../windowManager/bspwm/scripts/bspc_restart.nix { };
  bspc_terminal-scrachpad = pkgs.callPackage ../../windowManager/bspwm/scripts/bspc_terminal-scrachpad.nix { };

  pb_toggle = pkgs.callPackage ../../programs/polybar/scripts/pb_toggle.nix { };

  # default apps
  terminal = (import ../../constants.nix).terminal;
  browser = (import ../../constants.nix).browser;
in
{
  # restart tools
  "super + Escape" = "pkill -USR1 -x sxhkd && sxhkd &"; # reload sxhkd
  "super + alt + {q,r}" = "{bspc quit, ${bspc_restart}/bin/bspc_restart}"; # quit or restart bspwm

  # windows management
  "super + {_,shift +}w" = "bspc node -{c,k}"; # close or kill window
  "super + m" = "bspc desktop -l next"; # alternate between monocle and tiled layout
  "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}"; # alternate between tiled, pseudo_tiled, floating and fullscreen
  "super + shift + {1-9,0}" = "bspc node -d {I,II,III,IV,V,VI,VII,VIII,IX,X} -f"; # send window to desktop
  "super + shift + bracket{left,right}" = "bspc node -d {prev,next} -f"; # send window to previous or next desktop

  # desktops management
  "super + {1-9,0}" = "bspc desktop -f {I,II,III,IV,V,VI,VII,VIII,IX,X}"; # switch to desktop
  "super + {Left,Right}" = "bspc desktop -f {prev,next}"; # switch to previous or next desktop
  "super + shift + p" = "${pb_toggle}/bin/pb_toggle"; # show/hide polybar

  # apps shortcuts
  "super + @space" = "rofi -show drun -show-icons &"; # launch rofi
  "super + Return" = "alacritty"; # open terminal
  "super + shift + b" = "${browser}"; # open browser
  "super + shift + f" = "flameshot gui"; # open flameshot gui

  # crachpads
  # terminal
  "super + shift + t" = "${bspc_terminal-scrachpad}/bin/bspc_terminal-scrachpad";
}
