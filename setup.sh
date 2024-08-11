#!/bin/bash

# Path to the Ruby script and the symlink
SCRIPT_PATH="$(pwd)/bin/find_pairs_runner.rb"
SYMLINK_PATH="./bin/find-pairs"

# Check if the symlink already exists
if [ -L "$SYMLINK_PATH" ]; then
  echo "Symlink already exists: $SYMLINK_PATH -> $(readlink "$SYMLINK_PATH")"
  echo "Updating symlink..."
  # Remove the existing symlink
  rm "$SYMLINK_PATH"
fi

# Create the new symlink
ln -s "$SCRIPT_PATH" "$SYMLINK_PATH"

# Ensure the script is executable
chmod +x "$SCRIPT_PATH"

# Add the bin directory to the PATH if not already present
if ! echo "$PATH" | grep -q "$(pwd)/bin"; then
  echo "Adding bin directory to PATH..."
  echo "export PATH=\"\$PATH:$(pwd)/bin\"" >> ~/.bashrc
  echo "export PATH=\"\$PATH:$(pwd)/bin\"" >> ~/.zshrc
  # Reload the shell configuration
  if [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
  elif [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
  fi
fi

echo "Symlink created: $SYMLINK_PATH -> $SCRIPT_PATH"
