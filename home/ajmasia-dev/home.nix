{
  inputs,
  pkgs,
  ...
}: let
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

      packages = import ./packages {pkgs = pkgs;};

      #  User assets and personal config
      file = (import ./file) {};

      stateVersion = "23.05";
    };

    programs.home-manager.enable = true;
    fonts.fontconfig.enable = true;

    accounts.email.accounts = {
      icloud = {
        primary = true;
        himalaya.enable = true;
        address = "antoniojosemasia@icloud.com";
        realName = "Antonio José Masiá";
        userName = "antoniojosemasia";
        passwordCommand = "op item get 'iCloud main' --fields label=himalaya";
        imap = {
          host = "imap.mail.me.com";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.mail.me.com";
          port = 587;
          tls.enable = true;
        };
      };
    };

    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg:
          builtins.elem (pkgs.lib.getName pkg) [
            "obsidian"
            "spotify"
            "synology-drive-client"
            # "insync-pkg"
            # "insync"
            "todoist-electron"
            "discord"
            "vscode"
            "google-chrome"
          ];
        permittedInsecurePackages = [];
      };
      overlays = [
        (import ./overlays/bin.nix)
        # (f: p: { amd-controller = inputs.amd-controller.packages.x86_64-linux.default; })
      ];
    };

    systemd.user.services = {
      polkit-gnome-authentication-agent-1 = {
        Unit = {
          After = ["graphical-session-pre.target"];
          Description = "polkit-gnome-authentication-agent-1";
          PartOf = ["graphical-session.target"];
        };

        Service = {
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
          Type = "simple";
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    };

    imports = builtins.concatMap import [
      ./services
      ./programs
      ./windowManager
      ./ui
      ./xdg
    ];
  }
