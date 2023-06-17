{ system, inputs, ... }:

let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  unstable-pkgs = import inputs.nixpkgs-unstable {
    inherit system;

    config = {
      allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
        "obsidian"
        "1password"
        "1password-cli"
      ];
      permittedInsecurePackages = [ ];
    };
  };
in
with inputs; {
  ajmasia = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};

    extraSpecialArgs = {
      inherit inputs unstable-pkgs;
    };

    modules = [
      ../home/home.nix
    ];
  };
}
