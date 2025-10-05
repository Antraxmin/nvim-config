#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

NVIM_CONFIG_DIR="$HOME/.config/nvim"
GIT_REPO="https://github.com/Antraxmin/nvim-config.git"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  LazyVim Auto Installation Script${NC}"
echo -e "${BLUE}========================================${NC}\n"

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
  echo -e "${RED}Error: This script is for Linux only${NC}"
  exit 1
fi

if [ -f /etc/os-release ]; then
  . /etc/os-release
  DISTRO=$ID
else
  echo -e "${RED}Cannot detect Linux distribution${NC}"
  exit 1
fi

echo -e "${GREEN}✓${NC} Detected: $PRETTY_NAME\n"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

check_nvim_version() {
  if command_exists nvim; then
    version=$(nvim --version | head -n1 | grep -oP '(?<=v)\d+\.\d+' || echo "0.0")
    major=$(echo $version | cut -d. -f1)
    minor=$(echo $version | cut -d. -f2)

    if [ "$major" -gt 0 ] || ([ "$major" -eq 0 ] && [ "$minor" -ge 9 ]); then
      return 0
    fi
  fi
  return 1
}

echo -e "${YELLOW}Installing dependencies...${NC}"

case $DISTRO in
ubuntu | debian)
  sudo apt update
  sudo apt install -y git curl wget unzip tar gzip

  if ! check_nvim_version; then
    echo -e "${YELLOW}Installing Neovim latest version...${NC}"
    sudo apt remove neovim -y 2>/dev/null || true

    if sudo add-apt-repository ppa:neovim-ppa/unstable -y 2>/dev/null; then
      sudo apt update
      sudo apt install neovim -y
    else
      echo -e "${YELLOW}Using AppImage method...${NC}"
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
      chmod u+x nvim.appimage
      sudo mv nvim.appimage /usr/local/bin/nvim
    fi
  fi
  ;;

centos | rhel | fedora)
  sudo yum install -y git curl wget unzip tar gzip

  if ! check_nvim_version; then
    echo -e "${YELLOW}Installing Neovim latest version...${NC}"
    sudo yum remove neovim -y 2>/dev/null || true
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
  fi
  ;;

arch | manjaro)
  sudo pacman -Sy --noconfirm git curl wget unzip tar gzip

  if ! check_nvim_version; then
    sudo pacman -S --noconfirm neovim
  fi
  ;;

*)
  echo -e "${RED}Unsupported distribution: $DISTRO${NC}"
  echo -e "${YELLOW}Please install Neovim 0.9+ manually${NC}"
  exit 1
  ;;
esac

echo -e "${GREEN}✓${NC} Dependencies installed\n"

if ! check_nvim_version; then
  echo -e "${RED}Error: Neovim 0.9+ is required${NC}"
  echo -e "${YELLOW}Current version:${NC}"
  nvim --version | head -n1
  exit 1
fi

echo -e "${GREEN}✓${NC} Neovim version check passed"
nvim --version | head -n1
echo ""

if [ -d "$NVIM_CONFIG_DIR" ]; then
  BACKUP_DIR="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
  echo -e "${YELLOW}Backing up existing config to: $BACKUP_DIR${NC}"
  mv "$NVIM_CONFIG_DIR" "$BACKUP_DIR"
fi

echo -e "${YELLOW}Cloning LazyVim configuration...${NC}"
git clone "$GIT_REPO" "$NVIM_CONFIG_DIR"
echo -e "${GREEN}✓${NC} Configuration cloned\n"

if ! command_exists node; then
  echo -e "${YELLOW}Installing Node.js...${NC}"
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs || sudo yum install -y nodejs || sudo pacman -S --noconfirm nodejs
  echo -e "${GREEN}✓${NC} Node.js installed\n"
fi

if ! command_exists python3; then
  echo -e "${YELLOW}Installing Python3...${NC}"
  sudo apt install -y python3 python3-pip || sudo yum install -y python3 python3-pip || sudo pacman -S --noconfirm python python-pip
  echo -e "${GREEN}✓${NC} Python3 installed\n"
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Installation Complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Run: ${GREEN}nvim${NC}"
echo -e "2. Wait 1-2 minutes for plugins to install"
echo -e "3. LSP servers will auto-install via Mason\n"

echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  ${GREEN}Space + e${NC}     - File explorer"
echo -e "  ${GREEN}Space + Space${NC} - Find files"
echo -e "  ${GREEN}Space + c + m${NC} - Mason (LSP manager)"
echo -e "  ${GREEN}:Lazy${NC}         - Plugin manager\n"

read -p "Start Neovim now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  nvim
fi
