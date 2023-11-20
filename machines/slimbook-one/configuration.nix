# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "viserion";

  # TODO: Add wg-quick vpn interface to networking settingi

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "es_ES.UTF-8";
    };
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.defaultSession = "none+bspwm";

  services.xserver.windowManager.bspwm.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound = {
    enable = true;

    mediaKeys = {
      enable = true;
    };
  };

  # hardware.pulseaudio.enable = false; # Use pipewire as the default audio backend
  # hardware.pulseaudio = {
  #   enable = true;
  #   package = pkgs.pulseaudioFull;
  # };

  security = {
    polkit = {
      enable = true;
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Bluetooth manager
    blueman = {
      enable = false;
    };

    # gvfs.enable = true; # needed for trahs support with nautilus

    pcscd = {
      enable = true;
    }; # Yubikey smart card mode (CCID) and OTP mode (udev)

    openvpn = {};

    mullvad-vpn = {
      enable = true;

      package = pkgs.mullvad-vpn;
    };

    udisks2 = {
      enable = true;
    };

    # Needed to some apps like blueman-manager or networkmanager to save their options
    gnome.gnome-keyring.enable = true;

    # Zeroconf protocol implementation for service discovery
    avahi = {
      enable = true;
    };

    dbus.packages = [pkgs.dconf];
  };

  virtualisation = {
    docker = {
      enable = true;
    };
  };

  hardware.logitech.wireless.enable = true;
  hardware.bluetooth = {
    enable = true;

    settings = {
      General = {
        ControllerMode = "dual";
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ajmasia = {
    isNormalUser = true;
    description = "ajmasia";
    extraGroups = ["wheel" "networkmanager" "audio" "input" "docker"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    etc = {
      openvpn = {
        source = "${pkgs.update-resolv-conf}/libexec/openvpn";
      };
    };

    systemPackages = with pkgs; [
      vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      wget
      logitech-udev-rules # Lunux device manager for the logitech unyfying receiver
      home-manager
      bluetuith # Bluetooth manager
    ];
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
    #
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
  };

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (pkgs.lib.getName pkg) [
          "1password"
          "1password-cli"
        ];
      permittedInsecurePackages = [];
    };
  };

  xdg = {
    # Enable D-Bus communication for sandboxed applications
    portal = {
      enable = true;
    };
  };

  amd-controller = {
    enable = true;

    runAsAdmin = {
      # required by polybar cpu-profile
      enable = true;
      user = "ajmasia";
    };

    processor = "5900HX";

    powerManagement = {
      enable = true;

      awakeMode = "medium";
      powertop.enable = false;
      powerUpCommandsDelay = 30;
      resumeCommandsDelay = 10;
    };
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = ["my-user-name"];
    };

    dconf.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
