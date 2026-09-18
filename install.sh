#!/usr/bin/env bash

echo "Installing Kashoob App for the current user..."

# Create necessary directories
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/applications
mkdir -p ~/.local/share/icons

# Install the Python application
cp kashoob-app.py ~/.local/bin/kashoob-app
chmod +x ~/.local/bin/kashoob-app

# Download the Kashoob icon (named matching the app-id for Wayland/GNOME icon mapping)
echo "Downloading Kashoob icon..."
curl -s https://kashoob.com/static/images/icon-192.png -o ~/.local/share/icons/com.kashoob.app.png

# Install the Desktop Entry
cp com.kashoob.app.desktop ~/.local/share/applications/
chmod +x ~/.local/share/applications/com.kashoob.app.desktop

# Update Desktop database
update-desktop-database ~/.local/share/applications/ 2>/dev/null || true

echo "Installation complete! You can now launch 'Kashoob' from your application menu."
