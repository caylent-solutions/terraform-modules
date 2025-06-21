# GitHub Actions Security Scripts

This folder contains a script to maintain secure GitHub Actions by dynamically discovering all actions from your workflow files and pinning third-party actions to specific commit SHAs instead of mutable tags.

## 🔒 Security Problem Solved

**Problem**: Third-party GitHub Actions using tags like `@v2` or `@main` can be updated maliciously by attackers who compromise the action maintainer's account.

**Solution**: Automatically discover all actions from your workflows and pin third-party actions to immutable commit SHAs that cannot be changed.

## 📁 Files in This Folder

### `action-security.py` ⭐ **Main Tool**
**Purpose**: Dynamically discover all GitHub Actions from workflow files and manage security
**Features**:
- Automatically scans all `.github/workflows/*.yml` files
- Discovers all `uses:` statements
- Categorizes into official GitHub actions vs third-party actions
- Gets current SHAs for third-party actions (or confirms existing SHAs)
- Generates allowlist under GitHub's 255-character limit
- Provides copy/paste content for GitHub settings

**Usage**: 
```bash
# Using make task (recommended)
make github-actions-security

# Or run directly
./action-security.py
# or
python action-security.py
```

### `github-allowlist-minimal.txt`
**Purpose**: Generated allowlist file (updated automatically by action-security.py)
**Usage**: Copy/paste content into GitHub Settings → Actions → General → Actions permissions

### `README.md`
**Purpose**: This documentation file

## 🔄 Action Security Update Process

**⚠️ IMPORTANT: Run this script whenever you add, update, or remove GitHub Actions in your workflows!**

### When to Run
```bash
# Run after any workflow changes (recommended method):
make github-actions-security

# Or run directly:
./action-security.py

# This should be run:
# - After adding new actions to workflows
# - After updating action versions 
# - After removing actions from workflows
# - Quarterly as a security audit (every 3 months)
```

### Process
1. **Run the Security Script**: 
   ```bash
   make github-actions-security
   ```

2. **If Actions Changed**:
   - **Copy New Allowlist**: Copy the script output to GitHub Settings
     - Go to Settings → Actions → General → Actions permissions
     - Select "Allow select actions and reusable workflows"
     - Paste the new allowlist content
     - Save settings

3. **If New Third-Party Actions Added**:
   - Ensure new third-party actions in your workflows use SHAs (not version tags)
   - Test the workflows work with the actions
   - Commit changes: `git commit -am "Security: Update GitHub Actions allowlist"`

**Note**: The script automatically discovers all actions, so you don't need to manually track what actions you're using.

## 🎯 Current Action Security Status

### Automatically Discovered Actions
The `action-security.py` script finds these actions in your workflows:

**✅ Safe (Official GitHub Actions - No SHA Required)**:
- `actions/checkout@v4`
- `actions/github-script@v7` 
- `github/codeql-action/init@v3`
- `github/codeql-action/analyze@v3`

**🔒 SHA-Pinned (Third-Party Actions)**:
- `tibdex/github-app-token@3beb63f4bd073e61482598c45c71c1019b59b73a  # v2`
- `slackapi/slack-github-action@6c661ce58804a1a20f6dc5fbee7f0381b469e001  # v1.25.0`
- `trstringer/manual-approval@9f5e5d6bc511762e17f849775a3c56bdea6b4493  # v1`

### Dynamic Discovery Benefits
- **No manual tracking**: Script automatically finds all actions in your workflows
- **Complete coverage**: Scans all `.github/workflows/*.yml` files
- **Accurate detection**: Distinguishes between official GitHub actions and third-party actions
- **Current status**: Shows if actions are already SHA-pinned or need updating

## ⚠️ Security Best Practices

1. **Always pin third-party actions** to SHAs, never use mutable tags
2. **Update SHAs quarterly** to get security patches
3. **Review action repositories** before updating SHAs:
   - Check for recent suspicious commits
   - Verify maintainer is still legitimate
   - Look for security advisories
4. **Test workflows** after SHA updates
5. **Monitor security advisories** for actions you use

## 🚨 Emergency Security Response

If you discover a compromised action:

1. **Immediate**: Remove the action from the allowlist in GitHub settings
2. **Block workflows**: This will prevent any workflows using that action from running
3. **Investigate**: Check if the compromised action was used in any recent workflow runs
4. **Replace**: Find a secure alternative action or build internal replacement
5. **Update**: Remove the compromised action from all workflows

### Maintenance Schedule

- **After workflow changes**: Run `make github-actions-security` immediately
- **Quarterly audit**: Review all actions and update SHAs (March, June, September, December)
- **Monthly**: Review security advisories for actions used
- **As needed**: Remove/replace actions that become unmaintained

## 🔍 How to Verify Action Security

Before adding a new action or updating SHAs:

1. **Repository Health**:
   - Recent commits and activity
   - Number of stars/forks
   - Issue response time

2. **Maintainer Verification**:
   - Legitimate GitHub account
   - History of security practices
   - Organization backing (if applicable)

3. **Code Review**:
   - Review the action's source code
   - Check for suspicious dependencies
   - Verify permissions requested

4. **Alternatives**:
   - Consider official GitHub actions first
   - Look for actions by reputable organizations
   - Evaluate building internal alternatives for critical functions
