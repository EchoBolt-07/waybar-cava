#!/bin/bash
# Temporary Cava config file
config_file="/tmp/waybar_cava_config"

# Create config file for Cava (autodetects audio driver)
cat <<EOF > "$config_file"
[general]
framerate = 60
bars = 12

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Kill any existing cava processes spawned by this script
pkill -f "cava -p $config_file" || true

# Define block characters for the waveform
dict=" ▂▃▄▅▆▇█"

# Run cava and read output
cava -p "$config_file" | while read -r line; do
    line="${line%;}"
    if [ -z "$line" ]; then
        continue
    fi
    IFS=';' read -ra bars <<< "$line"
    
    # Check if all bars are 0 (silent)
    is_silent=true
    for bar in "${bars[@]}"; do
        if [[ "$bar" =~ ^[1-7]$ ]]; then
            is_silent=false
            break
        fi
    done

    if [ "$is_silent" = true ]; then
        echo "{\"text\": \"\", \"class\": \"cava\"}"
    else
        output=""
        for bar in "${bars[@]}"; do
            if [[ "$bar" =~ ^[0-7]$ ]]; then
                output+="${dict:$bar:1}"
            else
                output+="${dict:0:1}"
            fi
        done
        echo "{\"text\": \"$output\", \"class\": \"cava\"}"
    fi
done
