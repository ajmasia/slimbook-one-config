{ inputs, pkgs, unstable-pkgs, ... }:

let
  username = (import ./constants.nix).userName;
  homeDirectory = (import ./constants.nix).homeDirectory;
in
with pkgs; {
  home = {
    inherit username homeDirectory;

    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };

    packages = (import ./packages { pkgs = pkgs; unstable = unstable-pkgs; });

    #  User assets and personal config
    file = (import ./file) { };

    stateVersion = "23.05";
  };

  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;

  nixpkgs = {
    overlays = [
      # (import ./overlays/bin.nix)
      # (f: p: { amd-controller = inputs.amd-controller.packages.x86_64-linux.default; })
    ];
  };

  imports = builtins.concatMap import [
    ./services
    ./programs
    ./windowManager
    ./ui
    ./xdg
  ];
}
