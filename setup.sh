#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$REPO_DIR/ansible"

echo "==> Habitat setup"

# --- 1. Prerequisites -------------------------------------------------------
apt_updated=false
apt_update_once() {
  if [ "$apt_updated" = false ]; then
    sudo apt update
    apt_updated=true
  fi
}

ensure_pkg() {
  local pkg="$1" bin="$2"
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "--> Installing $pkg"
    apt_update_once
    sudo apt install -y "$pkg"
  fi
}

ensure_pkg git git
ensure_pkg whiptail whiptail

if ! command -v ansible-playbook >/dev/null 2>&1; then
  echo "--> Installing Ansible"
  apt_update_once
  sudo apt install -y software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible
fi

# --- 2. Interactive selection ----------------------------------------------
cancelled() { echo "Cancelled."; exit 1; }

MACHINE=$(whiptail --title "Habitat" --menu "Select machine type:" 12 60 2 \
  "laptops" "Ubuntu laptop / desktop" \
  "raspberrypis" "Raspberry Pi (ARM)" \
  3>&1 1>&2 2>&3) || cancelled

IDES=$(whiptail --title "IDEs" --checklist "Select IDEs to install:" 11 60 2 \
  "vscode" "Visual Studio Code" ON \
  "zed" "Zed editor" OFF \
  3>&1 1>&2 2>&3) || cancelled

LANGS=$(whiptail --title "Languages" --checklist "Select language toolchains:" 13 60 4 \
  "python" "Python (uv, ruff, ty)" ON \
  "rust" "Rust (rustup)" OFF \
  "javascript" "Node.js (fnm)" OFF \
  "cpp" "C/C++ (clang, cmake, gdb)" OFF \
  3>&1 1>&2 2>&3) || cancelled

TOOLS=$(whiptail --title "Tools" --checklist "Select tools:" 14 60 5 \
  "docker" "Docker" OFF \
  "k8s" "Kubernetes tooling" OFF \
  "azure" "Azure CLI" OFF \
  "llm" "llm CLI" OFF \
  "pixi" "pixi" OFF \
  3>&1 1>&2 2>&3) || cancelled

EXTRAS=$(whiptail --title "Extras" --checklist "Optional extras:" 11 60 2 \
  "ssh" "Install and enable OpenSSH server" OFF \
  "dotfiles" "Apply dotfiles via chezmoi" ON \
  3>&1 1>&2 2>&3) || cancelled

# --- 3. Render selections ---------------------------------------------------
# whiptail emits selected tags as quoted, space-separated values.
to_yaml_list() {
  local cleaned
  cleaned=$(echo "$1" | tr -d '"' | xargs || true)
  if [ -z "$cleaned" ]; then
    echo "[]"
  else
    echo "[$(echo "$cleaned" | sed 's/ /, /g')]"
  fi
}

extras=" $(echo "$EXTRAS" | tr -d '"') "
case "$extras" in *" ssh "*) SSH=true;; *) SSH=false;; esac
case "$extras" in *" dotfiles "*) DOTFILES=true;; *) DOTFILES=false;; esac

LAPTOP_HOST=""
RPI_HOST=""
if [ "$MACHINE" = "laptops" ]; then
  LAPTOP_HOST="localhost"
else
  RPI_HOST="localhost"
fi

cat > "$ANSIBLE_DIR/inventory" <<EOF
localhost ansible_connection=local

[laptops]
$LAPTOP_HOST

[raspberrypis]
$RPI_HOST
EOF

mkdir -p "$ANSIBLE_DIR/host_vars"
cat > "$ANSIBLE_DIR/host_vars/localhost.yml" <<EOF
---
ides: $(to_yaml_list "$IDES")
language_support: $(to_yaml_list "$LANGS")
tools: $(to_yaml_list "$TOOLS")

install_ssh_server: $SSH
install_dotfiles: $DOTFILES
EOF

echo "--> Wrote ansible/inventory and ansible/host_vars/localhost.yml"

# --- 4. Run the playbook ----------------------------------------------------
echo "==> Running Ansible playbook"
cd "$ANSIBLE_DIR"
ansible-playbook site.yaml -K
