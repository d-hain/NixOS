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
sudo nixos-rebuild switch --flake /home/<USER>/NixOS#<SYSTEM>
```
Replace `<USER>` and `<SYSTEM>` with something that makes sense.
Options for `<SYSTEM>`: `pc` `laptop` `servarr`

## How to add a secret

1. Add an entry to `secrets/secrets.nix` with its keys.
2. Write whatever it is in the env file using `agenix -e <SECRET_NAME>.age`. (to get `agenix` use `nix develop`)
3. To use that secret add it in the `hosts/<HOST>/secrets.nix` file.
4. Then in the configuration use `config.age.secrets.<SECRET_NAME>.path` to get the path of the file.
    - Or `builtin.readFile config.age.secrets.<SECRET_NAME>.path` to get its contents.
 
