# Datadog Workspace Dotfiles Setup

This repository contains your personal dotfiles and automation for recreating Datadog workspaces with all your preferred tools and settings.

## What This Provides

✅ **Automatic .zshrc setup** - Your exact shell configuration  
✅ **Oh My Zsh installation** - With agnoster theme and your plugins  
✅ **Graphite CLI installation** - Your go-to Git workflow tool  
✅ **Autojump installation** - Directory jumping utility  
✅ **History preservation** - Maintains shell history across workspace recreations  
✅ **Consistent workspace settings** - Automated configuration via config.yaml  

## One-Time Setup

### 1. Create Your Dotfiles Repository

1. Create a **public** GitHub repository (e.g., `https://github.com/YOUR-USERNAME/dotfiles`)
2. Upload these files to your repository:
   - `.zshrc` (your shell configuration)
   - `install.sh` (automation script)
   - `README.md` (this file)

3. Make the install script executable:
   ```bash
   chmod +x install.sh
   ```

### 2. Set Up Workspace Configuration

Create the config file to make all workspace creations use your dotfiles automatically:

```bash
mkdir -p ~/.config/datadog/workspaces
```

Copy the provided `config.yaml` to `~/.config/datadog/workspaces/config.yaml` and update:
- Replace `YOUR-USERNAME` with your actual GitHub username
- Adjust region, instance-type, and extensions as needed

### 3. Test Your Setup

Before your next workspace recreation, test with a temporary workspace:

```bash
workspaces create test-dotfiles --dotfiles https://github.com/YOUR-USERNAME/dotfiles
```

## Using Your Setup

### Creating a New Workspace (Every 6 Months)

Now workspace creation is simple - just run:

```bash
workspaces create lin-yang-2024-q4  # or whatever name you prefer
```

Your dotfiles will be automatically:
- Downloaded and applied
- Oh My Zsh will be installed
- Graphite will be installed  
- Autojump will be installed
- History preservation will be set up

### Accessing Your Workspace

```bash
ssh workspace-lin-yang-2024-q4
```

### History Preservation

The setup includes automatic history backup/restore:
- History is backed up when you exit the workspace
- History is restored when you start a new workspace session
- Stored in `~/.config/workspace-history/`

## Customization

### Adding More Tools

Edit `install.sh` to add more tools:

```bash
# Example: Install additional CLI tools
if ! command -v my-tool &> /dev/null; then
    npm install -g my-tool
    echo "✅ my-tool installed"
fi
```

### Modifying Shell Configuration

Edit `.zshrc` and push to your repository. New workspaces will automatically get the updates.

### VSCode Extensions

Add extensions to your `config.yaml`:

```yaml
vscode-extensions:
- "ms-azuretools.vscode-docker"
- "github.copilot"
- "your-extension-here"
```

## Files in This Setup

- **`.zshrc`** - Your shell configuration with themes, plugins, aliases, and custom functions
- **`install.sh`** - Automation script that installs oh-my-zsh, Graphite, autojump, and sets up history preservation
- **`config.yaml`** - Workspace defaults configuration for consistent workspace creation
- **`README.md`** - This documentation

## Troubleshooting

If something doesn't work:

1. Check that your dotfiles repository is public
2. Verify `install.sh` is executable: `chmod +x install.sh`
3. Test the setup with a temporary workspace first
4. Check the workspace creation logs for errors
5. Ask in [#workspaces](https://dd.enterprise.slack.com/archives/C02PW2547B9) Slack channel

## Benefits

🎯 **One-command workspace creation** - No manual setup required  
⚡ **Consistent environment** - Same tools and settings every time  
🔄 **History continuity** - Keep your shell history across recreations  
🛠️ **Easy customization** - Modify files and push to update all future workspaces