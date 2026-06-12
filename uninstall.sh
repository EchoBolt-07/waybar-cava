#!/bin/bash
set -e

# Define directories
WAYBAR_CONF_DIR="$HOME/.config/waybar"
WAYBAR_SHARE_DIR="$HOME/.local/share/waybar/layouts"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Uninstalling Waybar CAVA Waveform ==="

# 1. Remove the scripts
echo "Removing scripts..."
rm -f "$WAYBAR_CONF_DIR/scripts/waybar-cava.sh"

# 2. Remove module config
echo "Removing modules..."
rm -f "$WAYBAR_CONF_DIR/modules/cava.jsonc"

# 3. Clean up user-style.css
USER_STYLE="$WAYBAR_CONF_DIR/user-style.css"
if [ -f "$USER_STYLE" ]; then
    echo "Removing CSS styles from $USER_STYLE..."
    # Create a backup
    cp "$USER_STYLE" "${USER_STYLE}.bak"
    # Remove #custom-cava and #custom-cava.empty blocks
    python3 -c "
import re
with open('$USER_STYLE', 'r') as f:
    content = f.read()

# Remove #custom-cava block and #custom-cava.empty block
cleaned = re.sub(r'#custom-cava\s*\{[^}]*\}', '', content)
cleaned = re.sub(r'#custom-cava\.empty\s*\{[^}]*\}', '', cleaned)
# Clean up extra newlines
cleaned = re.sub(r'\n{3,}', '\n\n', cleaned)

with open('$USER_STYLE', 'w') as f:
    f.write(cleaned)
"
fi

# 4. Remove from active configuration
ACTIVE_CONFIG="$WAYBAR_CONF_DIR/config.jsonc"
if [ -f "$ACTIVE_CONFIG" ]; then
    echo "Removing CAVA from active config.jsonc..."
    python3 "$REPO_DIR/scripts/update_layouts.py" --remove-single "$ACTIVE_CONFIG" || true
fi

# 5. Remove from shared layouts
if [ -d "$WAYBAR_SHARE_DIR" ]; then
    echo "Removing CAVA from all layouts in $WAYBAR_SHARE_DIR..."
    python3 "$REPO_DIR/scripts/update_layouts.py" --remove-dir "$WAYBAR_SHARE_DIR" || true
fi

# 6. Reload Waybar
echo "Reloading Waybar..."
pkill -USR2 waybar || true

echo "=== CAVA Waveform Uninstalled Successfully! ==="
EOF
