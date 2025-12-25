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
    servarr-agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "servarr-nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    hyprland,
    ghostty,
    fuzzel-pass,
    servarr-nixpkgs,
    servarr-agenix,
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
          servarr-agenix.nixosModules.default
        ];
      };
    };

    devShells.${system} = {
      default = self.devShells.${system}.servarr;
      servarr = pkgs.mkShell {
        packages = [
          servarr-agenix.packages.${system}.default
        ];
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
