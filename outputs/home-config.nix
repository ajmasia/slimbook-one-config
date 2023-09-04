{ system, inputs, ... }:

let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
with inputs; {
  ajmasia = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.${system};

    extraSpecialArgs = {
      inherit inputs;
    };

    modules = [
      ../home/ajmasia-dev/home.nix
    ];
  };
}
