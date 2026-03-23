# Working with Multiple Repositories in VS Code

There are several ways to work with multiple Git repositories in VS Code. Here's a guide tailored for working with both `shoebox` and `shoebox-utilities`.

## Method 1: Multi-Root Workspace (Recommended)

A multi-root workspace lets you open multiple project folders in a single VS Code window.

### Setup:

1. **Open VS Code** with your main shoebox project
2. **Add the utilities folder**:
   - File → Add Folder to Workspace...
   - Navigate to `/home/mbudd/Documents/shoebox-utilities`
   - Click "Add"

3. **Save the workspace**:
   - File → Save Workspace As...
   - Save as `shoebox-dev.code-workspace` (in any location)

### Result:

Your workspace will look like this:
```
📁 SHOEBOX (multiple folders)
  📂 shoebox
  📂 shoebox-utilities
```

Each folder has its own:
- Git status
- File search scope
- Settings

### Workspace File

VS Code creates a `.code-workspace` file:

```json
{
  "folders": [
    {
      "path": "/home/mbudd/Documents/electron/shoebox"
    },
    {
      "path": "/home/mbudd/Documents/shoebox-utilities"
    }
  ],
  "settings": {
    // Shared settings for this workspace
  }
}
```

You can double-click this file to open the workspace anytime.

### Benefits:
- ✅ Single window for related projects
- ✅ Independent Git operations per folder
- ✅ Shared settings/extensions across projects
- ✅ Search across all folders or specific folder
- ✅ Easy switching between projects

### Tips:

**Search in specific folder:**
- Click the folder dropdown in Search panel
- Or use `Ctrl+Shift+F` and specify folder

**Git operations:**
- Source Control panel shows all repos
- Each repo has its own section
- Commit/push/pull independently

**Terminal:**
- Opens in workspace root by default
- Use `cd` to navigate between projects

## Method 2: Multiple Windows

Open each repository in separate VS Code windows:

1. File → Open Folder → `/home/mbudd/Documents/electron/shoebox`
2. File → New Window
3. File → Open Folder → `/home/mbudd/Documents/shoebox-utilities`

### Benefits:
- ✅ Complete isolation
- ✅ Different settings per project
- ✅ Alt+Tab between projects

### Drawbacks:
- ❌ More memory usage
- ❌ Can't search across projects
- ❌ More window management

## Method 3: Use Integrated Terminal

Keep shoebox open, access utilities via terminal:

```bash
# In VS Code terminal
cd ~/Documents/shoebox-utilities
git status
```

Open files from utilities in current window:
```bash
code mklinks/linux/mklinks
```

## Recommended Workflow for Shoebox Development

### Daily Work Setup:

1. **Open the multi-root workspace**:
   ```bash
   code ~/shoebox-dev.code-workspace
   ```

2. **Use Source Control panel** for Git:
   - See both repos at once
   - Stage/commit/push separately
   - Visual diff for both projects

3. **Search across projects** when needed:
   - Ctrl+Shift+F opens search
   - Select which folders to include

### Creating the Workspace File:

Run this to create your workspace file:

```bash
cat > ~/shoebox-dev.code-workspace << 'EOF'
{
  "folders": [
    {
      "name": "Shoebox App",
      "path": "/home/mbudd/Documents/electron/shoebox"
    },
    {
      "name": "Shoebox Utilities",
      "path": "/home/mbudd/Documents/shoebox-utilities"
    }
  ],
  "settings": {
    "files.exclude": {
      "**/node_modules": true,
      "**/dist": true,
      "**/.git": false
    },
    "search.exclude": {
      "**/node_modules": true,
      "**/dist": true
    }
  }
}
EOF
```

Then open it:
```bash
code ~/shoebox-dev.code-workspace
```

## Useful VS Code Extensions for Multi-Repo

- **GitLens** - Enhanced Git integration, great for multiple repos
- **Project Manager** - Quick switch between workspaces/projects
- **Open in External App** - Open files in external editors

## Quick Reference

| Action | Shortcut | Notes |
|--------|----------|-------|
| Add folder to workspace | File → Add Folder | While workspace is open |
| Save workspace | File → Save Workspace As | Create .code-workspace file |
| Open workspace | `code file.code-workspace` | From terminal |
| Search specific folder | Click folder in search dropdown | In Search panel |
| Open file from terminal | `code path/to/file` | Opens in current window |
| Source Control panel | Ctrl+Shift+G | Shows all repos |

## Next Steps

1. Create your workspace file (see above)
2. Open it: `code ~/shoebox-dev.code-workspace`
3. You'll see both projects in the sidebar
4. Try committing to each repo independently

The multi-root workspace is perfect for related projects like shoebox and shoebox-utilities!
