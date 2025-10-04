#!/usr/bin/env bash
set -euo pipefail

echo "==============================================================="
echo "Vítejte na Ansible workshopu LinuxDays 2025"
echo "Probíhá příprava prostředí..."
echo "==============================================================="

# Config
VENV_DIR="/opt/python-venv-ansible"
ANSIBLE_VERSION="11.1.0"

# Basic OS check (non-fatal)
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "${ID:-}" in
    ubuntu|debian) ;;
    *) echo "Upozornění: Tento skript je navržen pro Debian/Ubuntu. Pokračuji..." ;;
  esac
fi

echo "[1/5] Instalace systémových balíčků (python3, python3-venv)..."
sudo apt-get update -y
sudo apt-get install -y python3 python3-venv python3-pip

echo "[2/5] Vytvářím virtualenv: $VENV_DIR"
if [ ! -d "$VENV_DIR" ]; then
  sudo mkdir -p "$VENV_DIR"
  sudo chown "$(id -u)":"$(id -g)" "$VENV_DIR"
  python3 -m venv "$VENV_DIR"
else
  echo "Virtualenv již existuje, přeskočeno."
fi

echo "[3/5] Aktivace virtualenv"
# shellcheck disable=SC1090
source "$VENV_DIR/bin/activate"

echo "[4/5] Aktualizace pip a instalace Ansible $ANSIBLE_VERSION"
python -m pip install --upgrade pip
if ! python -m pip install "ansible==${ANSIBLE_VERSION}"; then
  echo "Varování: Instalace ansible==${ANSIBLE_VERSION} selhala. Zkouším nejnovější dostupnou verzi..."
  python -m pip install ansible
fi

echo "[5/5] Kontrola verzí"
echo -n "Python: "; python --version
echo -n "Pip:    "; pip --version
echo -n "Ansible:"; ansible --version | head -n1 || echo " Ansible není dostupný."

cat <<EOF

===============================================================
Instalace dokončena.
Aktivujte prostředí kdykoli pomocí:
  source $VENV_DIR/bin/activate

Příjemný workshop!
===============================================================
EOF
