{
  description = "DocE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    };

    server-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    server-nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ghostty,
    server-nixpkgs,
    server-nixpkgs-unstable,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        ghostty = ghostty;
        nixpkgs-unstable = nixpkgs-unstable;
      };

      modules = [
        ./hosts/default/configuration.nix
      ];
    };

    nixosConfigurations.server = server-nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        nixpkgs-unstable = server-nixpkgs-unstable;
      };

      modules = [
        ./hosts/server/configuration.nix
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
