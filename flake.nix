{
  description = "My awesom system config";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    amd-controller = {
      type = "github";
      owner = "ajmasia";
      repo = "amd-controller";
      ref = "rolling";
    };

    # amd-controller.url = "path:/home/ajmasia/repos/amd-controller";
    hyprland.url = "github:hyprwm/Hyprland";
    hpr-scratcher.url = "github:hyprland-community/hpr-scratcher?dir=nix";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    system = "x86_64-linux";

    customModules = {
      imports = [
        inputs.amd-controller.module
      ];
    };
  in {
    nixosConfigurations = (
      import ./outputs/nixos-config.nix {
        inherit system inputs customModules;
      }
    );

    homeConfigurations = (
      import ./outputs/home-config.nix {
        inherit system inputs;
      }
    );
  };
}
