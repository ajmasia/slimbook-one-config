{ pkgs, ... }:

let
  name = "workspaces";
  type = "internal/bspwm";

  colors = pkgs.callPackage ../utils/colors.nix { };
in
''
  [module/${name}]
  type = ${type}

  # core 
  pin-workspaces = true
  enable-click = true
  enable-scroll = true


  # labels
  label-monitor = %name%

  label-focused = 
  label-focused-foreground = ${colors.base.green}
  label-focused-padding = 1

  label-occupied = 
  label-occupied-foreground = ${colors.base.yellow}
  label-occupied-padding = 1

  label-urgent = 
  label-urgent-foreground = ${colors.base.red}
  label-urgent-padding = 1

  label-empty = 
  label-empty-foreground = ${colors.base.white}
  label-empty-padding = 1

  # format
  format = <label-state>
  format-font = 4
''
