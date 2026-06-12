#!/bin/bash
set -e

# Define directories
WAYBAR_CONF_DIR="$HOME/.config/waybar"
WAYBAR_SHARE_DIR="$HOME/.local/share/waybar/layouts"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing Waybar CAVA Waveform ==="

# 1. Install CAVA if not present
if ! command -v cava &> /dev/null; then
    echo "CAVA is not installed. Installing..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --needed --noconfirm cava
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y cava
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y cava
    else
        echo "Could not find a supported package manager. Please install 'cava' manually."
    fi
fi

# 2. Copy the CAVA script
echo "Copying scripts..."
mkdir -p "$WAYBAR_CONF_DIR/scripts"
cp "$REPO_DIR/scripts/waybar-cava.sh" "$WAYBAR_CONF_DIR/scripts/waybar-cava.sh"
chmod +x "$WAYBAR_CONF_DIR/scripts/waybar-cava.sh"

# 3. Copy the CAVA waybar module configuration
echo "Copying module configs..."
mkdir -p "$WAYBAR_CONF_DIR/modules"
cp "$REPO_DIR/modules/cava.jsonc" "$WAYBAR_CONF_DIR/modules/cava.jsonc"

# 4. Safely append CSS styling to user-style.css
USER_STYLE="$WAYBAR_CONF_DIR/user-style.css"
if [ ! -f "$USER_STYLE" ]; then
    touch "$USER_STYLE"
fi

if ! grep -q "#custom-cava" "$USER_STYLE"; then
    echo "Adding CAVA styles to $USER_STYLE..."
    cat "$REPO_DIR/styles/cava.css" >> "$USER_STYLE"
fi

# 5. Inject custom/cava into active configuration
ACTIVE_CONFIG="$WAYBAR_CONF_DIR/config.jsonc"
if [ -f "$ACTIVE_CONFIG" ] && ! grep -q "custom/cava" "$ACTIVE_CONFIG"; then
    echo "Injecting CAVA into active config.jsonc..."
    python3 "$REPO_DIR/scripts/update_layouts.py" --single "$ACTIVE_CONFIG" || true
fi

# 6. Inject custom/cava into all shared layouts so it works when switching styles
if [ -d "$WAYBAR_SHARE_DIR" ]; then
    echo "Injecting CAVA into all shared layouts in $WAYBAR_SHARE_DIR..."
    python3 "$REPO_DIR/scripts/update_layouts.py" --dir "$WAYBAR_SHARE_DIR" || true
fi

# 7. Reload Waybar
echo "Reloading Waybar..."
pkill -USR2 waybar || true

echo "=== CAVA Waveform Installed Successfully! ==="
EOF
