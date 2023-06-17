{ system, inputs, customModules, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem; 
in
{
  viserion = nixosSystem {
    inherit system;

    specialArgs = {
      inherit inputs;
    };
    
    modules = [
      ../system/hardware-configuration.nix
      ../system/configuration.nix
      customModules
    ];
  };
}
