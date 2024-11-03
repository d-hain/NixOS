{
  description = "DocE PC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    hyprland.url = "github:hyprwm/Hyprland?submodules=1";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.doce-pc = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {inherit inputs;};

      modules = [
        ./hosts/default/configuration.nix
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
