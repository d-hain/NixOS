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

    servarr-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    ghostty,
    fuzzel-pass,
    servarr-nixpkgs,
    agenix,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit hyprland ghostty fuzzel-pass;
        };

        modules = [
          ./hosts/pc/configuration.nix
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit hyprland ghostty fuzzel-pass;
        };

        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };

      servarr = servarr-nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/servarr/configuration.nix
          agenix.nixosModules.default
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = [
        agenix.packages.${system}.default
      ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
