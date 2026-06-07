{
  description = "DocE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fuzzel-pass = {
      url = "github:d-hain/fuzzel-pass";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix-notes = {
      url = "git+https://codeberg.org/ArkHost/HelixNotes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    servarr-nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    servarr-agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "servarr-nixpkgs";
    };
    servarr-nix-wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "servarr-nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    agenix,
    nix-wrapper-modules,
    hyprland,
    fuzzel-pass,
    helix-notes,
    servarr-nixpkgs,
    servarr-agenix,
    servarr-nix-wrapper-modules,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            agenix
            nix-wrapper-modules
            hyprland
            fuzzel-pass
            helix-notes
            ;
        };

        modules = [
          ./hosts/pc/configuration.nix
          agenix.nixosModules.default
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit
            agenix
            nix-wrapper-modules
            hyprland
            fuzzel-pass
            helix-notes
            ;
        };

        modules = [
          ./hosts/laptop/configuration.nix
          agenix.nixosModules.default
        ];
      };

      servarr = servarr-nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          nix-wrapper-modules = servarr-nix-wrapper-modules;
        };

        modules = [
          ./hosts/servarr/configuration.nix
          servarr-agenix.nixosModules.default
        ];
      };
    };

    packages.${system} = {
      default = self.packages.${system}.neovim;
      neovim = nix-wrapper-modules.lib.evalPackage [
        ./modules/nvim.nix
        {inherit pkgs;}
      ];
    };

    devShells.${system} = {
      default = self.devShells.${system}.pc;
      pc = pkgs.mkShell {
        packages = [
          agenix.packages.${system}.default
        ];
      };
      servarr = pkgs.mkShell {
        packages = [
          servarr-agenix.packages.${system}.default
        ];
      };
    };

    formatter.${system} = pkgs.alejandra;
  };
}
