{ pkgs, unstable-pkgs, ... }:

let
  unstable = unstable-pkgs;
in
{
  programs.fzf = {
    enable = true;

    package = unstable.fzf;
    enableBashIntegration = true;
  };
}
