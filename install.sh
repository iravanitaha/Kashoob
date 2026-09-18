#!/usr/bin/env bash

# Colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check for uninstall flag
if [[ "$1" == "--uninstall" ]]; then
    echo -e "${RED}Uninstalling Kashoob App...${NC}"
    rm -f ~/.local/bin/kashoob-app
    rm -f ~/.local/share/applications/com.kashoob.app.desktop
    rm -f ~/.local/share/icons/com.kashoob.app.png
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
    echo -e "${GREEN}Uninstallation complete!${NC}"
    exit 0
fi

echo -e "${BLUE}Installing Kashoob App for the current user...${NC}"

# Check and install dependencies for major Linux distributions
echo -e "${BLUE}Checking system dependencies...${NC}"
if command -v apt-get &> /dev/null; then
    echo "Detected Debian/Ubuntu-based system. Installing dependencies via apt..."
    sudo apt-get update
    sudo apt-get install -y python3-gi gir1.2-gtk-4.0 gir1.2-adw-1 gir1.2-webkit-6.0 curl
elif command -v dnf &> /dev/null; then
    echo "Detected Fedora/RHEL-based system. Installing dependencies via dnf..."
    sudo dnf install -y python3-gobject gtk4 libadwaita webkitgtk6.0 curl
elif command -v pacman &> /dev/null; then
    echo "Detected Arch-based system. Installing dependencies via pacman..."
    sudo pacman -S --needed --noconfirm python-gobject gtk4 libadwaita webkit2gtk-6.0 curl
elif command -v zypper &> /dev/null; then
    echo "Detected openSUSE-based system. Installing dependencies via zypper..."
    sudo zypper install -y python3-gobject gtk4 libadwaita typelib-1_0-WebKit-6_0 curl
else
    echo -e "${RED}Warning: Could not detect your package manager (apt, dnf, pacman, zypper). Please ensure Python3 PyGObject, GTK4, Libadwaita, and WebKit6 are installed manually.${NC}"
fi

# Create necessary directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons

# Install the Python application
echo -e "${BLUE}Copying application files...${NC}"
cp kashoob-app.py ~/.local/bin/kashoob-app
chmod +x ~/.local/bin/kashoob-app

# Download the Kashoob icon
echo -e "${BLUE}Downloading Kashoob icon...${NC}"
curl -s https://kashoob.com/static/images/icon-192.png -o ~/.local/share/icons/com.kashoob.app.png

# Install the Desktop Entry
cp com.kashoob.app.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/com.kashoob.app.desktop

# Update Desktop database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

echo -e "${GREEN}Installation complete! You can now launch 'Kashoob' from your application menu.${NC}"
