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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuzzel-pass = {
      url = "github:d-hain/fuzzel-pass";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jai-temp.url = "github:samestep/nixpkgs/jai-beta-0.2.014";

    server-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    ghostty,
    fuzzel-pass,
    jai-temp,
    server-nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    jaiPkgs = import jai-temp {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = {
        inherit hyprland ghostty fuzzel-pass;
        jai-temp = jaiPkgs;
      };

      modules = [
        ./hosts/default/configuration.nix
      ];
    };

    nixosConfigurations.server = server-nixpkgs.lib.nixosSystem {
      system = system;

      modules = [
        ./hosts/server/configuration.nix
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
