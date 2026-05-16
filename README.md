# Habitat

Provisions an Ubuntu laptop (or Raspberry Pi) from a fresh install using Ansible.
Dotfiles are managed separately by [chezmoi](https://chezmoi.io) and are not stored
in this repo.

## Quick start

From a fresh install:

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/gaileyleseman/habitat.git
cd habitat
./setup.sh
```

`setup.sh` installs the prerequisites (`git`, `ansible`, `whiptail`), then opens an
interactive `whiptail` picker to choose the machine type and which components to
install (IDEs, language toolchains, tools, SSH server, dotfiles). It writes the
selection to `ansible/inventory` and `ansible/host_vars/localhost.yml` (both
gitignored) and runs the playbook.

## Manual runs

The playbook must be run from inside `ansible/` so `ansible.cfg` and the inventory
resolve:

```bash
cd ansible
ansible-playbook site.yaml -K
```

Useful flags:

- `--check` — dry run; report changes without applying them.
- `--tags base|dev|dotfiles` — run only part of the playbook.
- `--syntax-check` — validate the playbook.

## Layout

- `ansible/site.yaml` — top-level playbook (`base` → `dev` → `dotfiles`).
- `ansible/tasks/` — `base.yaml`, `dev.yaml`, `dotfiles.yaml`, plus `apps/`,
  `languages/`, `tools/`.
- `ansible/group_vars/` — defaults per group (`all`, `laptops`, `raspberrypis`).
- `ansible/host_vars/localhost.yml` — per-machine selections (generated).
- `ansible/inventory.example` — inventory template.

## Dotfiles

The `dotfiles` component runs `chezmoi init --apply gaileyleseman`, pulling
dotfiles from the separate chezmoi repo. Shell environment and `PATH` entries for
the tools installed here (rustup, fnm, uv, etc.) live in that dotfiles repo.
