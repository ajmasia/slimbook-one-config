{ pkgs, unstable, ... }:

let
  myNerdFonts = (unstable.nerdfonts.override {
    fonts = [
      "FiraCode"
      "Hack"
      "NerdFontsSymbolsOnly"
      "CascadiaCode"
      "JetBrainsMono"
      "Noto"
      "SourceCodePro"
      "Ubuntu"
    ];
  });

  yarnWithNode18 = pkgs.yarn.overrideAttrs (oldAttrs: rec {
    buildInputs = with pkgs; [
      nodejs-18_x
    ];
  });
in
with pkgs; [
  # Core tools
  ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep
  tldr # Simplified and community-driven man pages
  exa # A modern replacement for ls written in Rust
  lfs # Get infomation on yoour mounted disks
  libnotify # A library that sends desktop notifications to a notification daemon
  tree # A recursive directory listing program that produces a depth indented listing of files

  # System fonts
  myNerdFonts # My custom Nerd Fonts

  # Code builders, compilers and interpreters
  gcc # GNU compiler collection tools
  cmake # Cross-platform, open-source build system generatorpa
  gnumake # Tool to control the generation of non-source files from sources
  cargo # Rust builder & module manager
  nodejs-18_x # Node.js interpreter
  yarnWithNode18 # Node.js override with yarn

  # Productivity tools 
  unstable.obsidian # A second brain, for you, forever

  # Security tools
  unstable._1password-gui # Password manager and secure wallet
  unstable._1password # CLI Password manager and secure wallet

  # Browsers
  firefox # Firefox web browser

  # UI
  feh # A fast and light imlib2-based image viewero
]
