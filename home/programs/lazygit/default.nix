{ pkgs, unstable-pkgs, ... }:

let
  unstable = unstable-pkgs;
in
{
  programs.lazygit = {
    enable = true;

    package = unstable.lazygit;
    settings = {
      disableStartupPopups = true;
    };
  };
}
