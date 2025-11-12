#!/bin/bash
set -e

echo "🚀 Setting up workspace with dotfiles..."

# Symlink dotfiles to home directory (since we have install.sh, we need to do this manually)
echo "📁 Symlinking dotfiles..."
for file in ~/dotfiles/.zshrc ~/dotfiles/.gitconfig; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if [ -L ~/"$filename" ] || [ -f ~/"$filename" ]; then
            rm ~/"$filename"
        fi
        ln -sf "$file" ~/"$filename"
        echo "✅ Symlinked $filename"
    fi
done

# Install oh-my-zsh
echo "🎨 Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "✅ oh-my-zsh installed"
else
    echo "✅ oh-my-zsh already installed"
fi

# Install autojump plugin (since it's in your plugins list)
echo "🦘 Installing autojump..."
if ! command -v autojump &> /dev/null; then
    # Install via apt if available (common in Ubuntu/Debian workspaces)
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y autojump
    # Install via brew if available
    elif command -v brew &> /dev/null; then
        brew install autojump
    fi
    echo "✅ autojump installed"
else
    echo "✅ autojump already installed"
fi

# Install Graphite CLI
echo "📊 Installing Graphite..."
if ! command -v gt &> /dev/null; then
    npm install -g @withgraphite/graphite-cli@stable
    echo "✅ Graphite installed"
else
    echo "✅ Graphite already installed"
fi

# Set up zsh history preservation
echo "📚 Setting up history preservation..."
mkdir -p ~/.config/workspace-history

# Create history backup/restore functions
cat >> ~/.zshrc << 'EOF'

# Workspace history preservation
WORKSPACE_HISTORY_DIR="$HOME/.config/workspace-history"
WORKSPACE_NAME=$(hostname | cut -d'-' -f2-)  # Extract workspace name from hostname

# Function to backup history
backup_history() {
    if [ -n "$WORKSPACE_NAME" ] && [ -f "$HOME/.zsh_history" ]; then
        mkdir -p "$WORKSPACE_HISTORY_DIR"
        cp "$HOME/.zsh_history" "$WORKSPACE_HISTORY_DIR/zsh_history_${WORKSPACE_NAME}_$(date +%Y%m%d_%H%M%S).bak"
        echo "History backed up for workspace: $WORKSPACE_NAME"
    fi
}

# Function to restore most recent history
restore_history() {
    if [ -n "$WORKSPACE_NAME" ]; then
        local latest_backup=$(ls -t "$WORKSPACE_HISTORY_DIR"/zsh_history_${WORKSPACE_NAME}_*.bak 2>/dev/null | head -n1)
        if [ -n "$latest_backup" ]; then
            cat "$latest_backup" >> "$HOME/.zsh_history"
            # Remove duplicates and sort by timestamp
            sort "$HOME/.zsh_history" | uniq > "$HOME/.zsh_history.tmp" && mv "$HOME/.zsh_history.tmp" "$HOME/.zsh_history"
            echo "History restored from: $(basename $latest_backup)"
        fi
    fi
}

# Auto-backup history on exit
trap backup_history EXIT

# Try to restore history on startup (only if current history is small/empty)
if [ -f "$HOME/.zsh_history" ]; then
    history_lines=$(wc -l < "$HOME/.zsh_history" 2>/dev/null || echo 0)
    if [ "$history_lines" -lt 10 ]; then
        restore_history
    fi
fi
EOF

echo "🎉 Workspace setup complete!"
echo ""
echo "Next steps:"
echo "1. Create a public GitHub repository for your dotfiles"
echo "2. Add your .zshrc and this install.sh to that repo"
echo "3. Make install.sh executable: chmod +x install.sh"
echo "4. Update your workspace config to use the dotfiles repo"
echo "5. Use 'workspaces create <name>' and your setup will be automatic!"