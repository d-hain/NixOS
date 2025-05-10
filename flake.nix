{
  description = "DocE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    fuzzel-pass = {
      url = "github:d-hain/fuzzel-pass";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    server-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    server-nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    ghostty,
    fuzzel-pass,
    server-nixpkgs,
    server-nixpkgs-unstable,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        hyprland = hyprland;
        ghostty = ghostty;
        fuzzel-pass = fuzzel-pass;
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
