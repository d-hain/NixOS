# My NixOS Configuration

Here lies my NixOS configuration.

## File Structure

```shell
.
├── flake.lock
├── flake.nix
└── hosts
    └── default # My Home PC
        ├── configuration.nix
        └── hardware-configuration.nix
```

## How to rebuild the system

After `stow`ing the dotfiles run this command:
```shell
sudo nixos-rebuild switch --flake $(realpath /home/USER/nixos)#default
```
