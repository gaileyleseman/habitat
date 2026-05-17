# Habitat

Provisions an Ubuntu laptop (or Raspberry Pi) from a fresh install using Ansible.

## Quick start

```bash
sudo apt update && sudo apt install -y git
git clone --recurse-submodules https://github.com/gaileyleseman/habitat.git
cd habitat
./setup.sh
```

`setup.sh` installs the prerequisites, detects the machine type (asking you to
confirm), then asks whether to use the default component profile or pick
components interactively. It installs the Ansible collections and runs the
playbook. It does not apply dotfiles.

## What gets installed

`setup.sh` asks whether to use the default profile for the machine type. Accept
it and the committed `group_vars` profile is used as-is. Decline and a `whiptail`
picker opens, listing every available component (each names a role under
`ansible/roles/`); your selection is written to the gitignored
`ansible/host_vars/localhost.yaml`.

The picker is **pre-ticked** from the current selection: a previous
`host_vars/localhost.yaml` if one exists, otherwise the committed machine-type
profile. Edit those profiles to change the defaults a fresh machine starts from:

```yaml
# ansible/group_vars/laptops.yaml
components:
  - vscode      # IDE
  - python      # language toolchain
  - docker      # tool
  - claude      # AI CLI
```

## Re-running the playbook

After `setup.sh` has run once (it generates `ansible/inventory`), re-apply
changes — e.g. after editing a component profile — without re-running setup:

```bash
cd ansible
ansible-playbook site.yaml -K
```

Flags: `--check` (dry run), `--tags base|dev` (run part), `--syntax-check`.

## Dotfiles

Dotfiles live in the [`gaileyleseman/dotfiles`](https://github.com/gaileyleseman/dotfiles)
chezmoi repo and are managed separately — the playbook does not install `chezmoi`
or apply dotfiles. Install `chezmoi` and apply them after provisioning:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply gaileyleseman
chsh -s $(which zsh)
```
