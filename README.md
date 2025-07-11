# My NixOS Configuration

Here lies my NixOS configuration.

## File Structure

```shell
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── default
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   ├── laptop
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── server
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── qbittorrent.nix
└── modules
    ├── environment.nix
    ├── hardware-stuff.nix
    ├── hyprsunset.nix
    ├── nix.nix
    ├── programs.nix
    ├── services.nix
    ├── shell.nix
    └── user.nix
```

## How to rebuild the system

After cloning this repo to your home directory just run this command:
```shell
sudo nixos-rebuild switch --flake /home/USER/NixOS#SYSTEM
```
Replace `USER` and `SYSTEM` with something that makes sense.
Options for `SYSTEM`: `pc` `laptop` `server`
