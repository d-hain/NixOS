# My NixOS Configuration

Here lies my NixOS configuration.

## File Structure

```shell
.
├── flake.lock
├── flake.nix
├── hosts
│   ├── pc
│   ├── laptop
│   └── servarr
├── modules
└── secrets
```

## How to rebuild the system

After cloning this repo to your home directory just run this command:
```shell
sudo nixos-rebuild switch --flake /home/USER/NixOS#SYSTEM
```
Replace `USER` and `SYSTEM` with something that makes sense.
Options for `SYSTEM`: `pc` `laptop` `servarr`

## How to add a secret

Add an entry to `secrets/secrets.nix` with its keys.
Write whatever it is in the env file using `agenix -e SECRET_NAME.age`. (to get `agenix` use `nix develop`)
