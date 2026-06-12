import os
import re
import argparse

def update_file(filepath):
    if not os.path.exists(filepath):
        return
    with open(filepath, 'r') as f:
        content = f.read()

    if "custom/cava" in content:
        return

    basename = os.path.basename(filepath)

    if basename == "macos.jsonc":
        if '"modules-center"' not in content:
            updated = content.replace(
                '"modules-right":',
                '"modules-center": ["custom/cava"],\n  "modules-right":'
            )
            with open(filepath, 'w') as f:
                f.write(updated)
        return

    group_patterns = [
        r'("group/pill#center"\s*:\s*\{[^}]*?"modules"\s*:\s*\[)',
        r'("group/pill-in#center"\s*:\s*\{[^}]*?"modules"\s*:\s*\[)',
        r'("group/pill#center3"\s*:\s*\{[^}]*?"modules"\s*:\s*\[)',
        r'("group/pill#1"\s*:\s*\{[^}]*?"modules"\s*:\s*\[)'
    ]
    
    updated = content
    for pattern in group_patterns:
        match = re.search(pattern, updated, re.DOTALL)
        if match:
            matched_str = match.group(1)
            if "\n" in matched_str:
                replacement = matched_str + '\n            "custom/cava",'
            else:
                replacement = matched_str + '"custom/cava", '
            updated = updated.replace(matched_str, replacement)
            break
            
    if updated != content:
        with open(filepath, 'w') as f:
            f.write(updated)

def remove_from_file(filepath):
    if not os.path.exists(filepath):
        return
    with open(filepath, 'r') as f:
        content = f.read()

    if "custom/cava" not in content:
        return

    # Remove the module from arrays
    # Match "custom/cava", or , "custom/cava" or "custom/cava"
    updated = content
    updated = re.sub(r'\s*,\s*"custom/cava"', '', updated)
    updated = re.sub(r'"custom/cava"\s*,\s*', '', updated)
    updated = re.sub(r'"custom/cava"', '', updated)

    # Clean up empty lines or empty modules array in macos.jsonc center modules
    if os.path.basename(filepath) == "macos.jsonc":
        updated = re.sub(r'"modules-center"\s*:\s*\[\s*\]\s*,\s*', '', updated)
        updated = re.sub(r'\s*,\s*"modules-center"\s*:\s*\[\s*\]', '', updated)

    if updated != content:
        with open(filepath, 'w') as f:
            f.write(updated)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--single', help='Update a single config file')
    parser.add_argument('--dir', help='Update all config files in a directory')
    parser.add_argument('--remove-single', help='Remove custom/cava from a single file')
    parser.add_argument('--remove-dir', help='Remove custom/cava from all files in a directory')
    args = parser.parse_args()

    if args.single:
        update_file(args.single)
    elif args.dir:
        for root, dirs, files in os.walk(args.dir):
            for file in files:
                if file.endswith(".jsonc"):
                    update_file(os.path.join(root, file))
    elif args.remove_single:
        remove_from_file(args.remove_single)
    elif args.remove_dir:
        for root, dirs, files in os.walk(args.remove_dir):
            for file in files:
                if file.endswith(".jsonc"):
                    remove_from_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
