# Waybar CAVA Waveform Extension

A responsive CAVA waveform extension for HyDE/Waybar. The waveform is rendered dynamically in the center of the bar when audio is playing, and automatically collapses to save space when silent.

## Setup Instructions

### 1. Host it on your GitHub
To share this extension with your friend or others easily via git:
1. Open your terminal in this directory:
   ```bash
   cd ~/waybar-cava
   ```
2. Initialize git and commit the files:
   ```bash
   git init
   git add .
   git commit -m "Initial release of waybar-cava extension"
   ```
3. Create a **new public repository** on GitHub named `waybar-cava`.
4. Link it to your GitHub repository and push it (replace `YOUR_USERNAME` with your real username):
   ```bash
   git branch -M main
   git remote add origin https://github.com/EchoBolt-07/waybar-cava.git
   git push -u origin main
   ```

---

### 2. How your Friend Can Use It (Cloning & Installing)
All your friend needs to do on their machine is open a terminal and run:

```bash
# Clone the repository
git clone https://github.com/EchoBolt-07/waybar-cava.git

# Navigate into the folder
cd waybar-cava

# Run the installer
chmod +x install.sh
./install.sh
```

### 3. How to Uninstall
If they ever want to undo the changes, they can simply run:
```bash
chmod +x uninstall.sh
./uninstall.sh
```
This will remove CAVA from all layouts, delete the script files, and clean up the CSS stylesheet automatically.
