# My NixOS Configuration

Here lies my NixOS configuration.

## File Structure

```shell
.
├── flake.lock
├── flake.nix
└── hosts
    ├── default # My Home PC
    │   ├── configuration.nix
    │   └── hardware-configuration.nix
    └── server # My Home Server
        ├── configuration.nix
        └── hardware-configuration.nix
```

## How to rebuild the system

After cloning this repo to your home directory just run this command:
```shell
sudo nixos-rebuild switch --flake /home/USER/NixOS#default
```

and `#server` instead of `#default` for the server.
