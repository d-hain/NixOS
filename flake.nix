{
  description = "DocE PC";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/51b85c5d18065941b05be44852034017279e28ec";
    # wezterm.url = "github:wez/wezterm?dir=nix";
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
