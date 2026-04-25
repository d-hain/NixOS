# My NixOS Configuration

Here lies my NixOS configuration.

## Neovim

To access my neovim configuration on a system that has Nix installed, use this:
```bash
nix run git+https://git.doceys.computer/NixOS#neovim
```

## File Structure

```bash
.
├── dotfiles
├── flake.lock
├── flake.nix
├── hosts
│   ├── laptop
│   │   └── dotfiles
│   ├── pc
│   │   └── dotfiles
│   └── servarr
├── lib
├── modules
└── secrets
```

- `dotfiles`
  A directory for all shared non-nix dotfiles.
- `hosts`
  All subdirectories of `hosts` are all files specific to one host.
  - `dotfiles`
    Non-nix dotfiles that are specific to that host.
- `lib`
  Nix functions used throughout the config.
- `modules`
  Somewhat coherently organized files that many systems use.
- `secrets`
  Agenix secrets mostly used for my home server.

## Manual Steps for a new system

+ Copy my SSH Keys to `~/.ssh`
+ Add the SSH Keys to the GPG-Agent
  ```bash
  ssh-add ~/.ssh/<private-key-name>
  ```
+ Restore my GPG Keys
  ```bash
  # For each key:
  gpg --import public.gpg
  gpg --import private.gpg
  ```

(I hope that's all)

## How to rebuild the system

After cloning this repo to your home directory just run this command:
```bash
sudo nixos-rebuild switch --flake /home/<USER>/NixOS#<SYSTEM>
```
Replace `<USER>` and `<SYSTEM>` with something that makes sense.
Options for `<SYSTEM>`: `pc` `laptop` `servarr`

## How to add a secret

1. Add an entry to `secrets/secrets.nix` with its keys.
2. Write whatever it is in the env file using `agenix -e <SECRET_NAME>.age`. (to get `agenix` use `nix develop`)
3. To use that secret add it in the `hosts/<HOST>/secrets.nix` file.
4. Then in the configuration use `config.age.secrets.<SECRET_NAME>.path` to get the path of the file.
