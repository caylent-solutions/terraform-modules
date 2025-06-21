#!/usr/bin/env python
"""
GitHub Actions Security Manager
Dynamically discovers actions from workflow files and generates secure allowlists
"""

import os
import re
import subprocess
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple


class ActionSecurityManager:
    def __init__(self):
        self.script_dir = Path(__file__).parent
        self.repo_root = self.script_dir.parent
        self.workflows_dir = self.repo_root / ".github" / "workflows"
        self.allowlist_file = self.script_dir / "github-allowlist-minimal.txt"
        
    def discover_actions(self) -> List[str]:
        """Discover all actions from workflow files"""
        print("🔍 Discovering actions from workflow files...")
        
        if not self.workflows_dir.exists():
            print(f"❌ Workflows directory not found: {self.workflows_dir}")
            return []
            
        actions = set()
        
        # Find all .yml files in workflows directory
        for workflow_file in self.workflows_dir.glob("*.yml"):
            try:
                with open(workflow_file, 'r') as f:
                    content = f.read()
                    
                # Find all uses: statements (exclude local workflow references)
                uses_pattern = r'^\s*uses:\s*([^\s#]+)'
                matches = re.findall(uses_pattern, content, re.MULTILINE)
                
                for match in matches:
                    # Skip local workflow references (start with ./)
                    if not match.startswith('./'):
                        actions.add(match.strip())
                    
            except Exception as e:
                print(f"⚠️  Error reading {workflow_file}: {e}")
        
        actions_list = sorted(list(actions))
        
        print("📋 Found actions:")
        for action in actions_list:
            print(f"   - {action}")
            
        return actions_list
    
    def categorize_actions(self, actions: List[str]) -> Tuple[Set[str], Dict[str, str]]:
        """Categorize actions into official GitHub and third-party"""
        print("\n📊 Categorizing actions...")
        
        official_actions = set()
        third_party_actions = {}
        
        for action in actions:
            if action.startswith(('actions/', 'github/')):
                # Official GitHub actions
                repo = action.split('@')[0]
                official_actions.add(repo)
                print(f"   ✅ Official: {action}")
            elif '@' in action and '/' in action:
                # Third-party actions with version
                repo, version = action.split('@', 1)
                third_party_actions[repo] = version
                print(f"   ⚠️  Third-party: {action}")
            else:
                print(f"   ❓ Unknown format: {action}")
                
        return official_actions, third_party_actions
    
    def get_sha(self, repo: str, version: str) -> str:
        """Get SHA for a GitHub action"""
        print(f"📍 Getting SHA for {repo}@{version}...")
        
        # Check if already a SHA
        if re.match(r'^[a-f0-9]{40}$', version):
            print(f"   ✅ Already using SHA: {version}")
            return version
            
        try:
            # Try to get SHA for tag
            cmd = ['git', 'ls-remote', f'https://github.com/{repo}.git', f'refs/tags/{version}']
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0 and result.stdout.strip():
                sha = result.stdout.strip().split('\t')[0]
                print(f"   ✅ SHA: {sha}")
                return sha
            
            # Try main branch if tag not found
            print(f"   ⚠️  Tag {version} not found, trying main branch...")
            cmd = ['git', 'ls-remote', f'https://github.com/{repo}.git', 'refs/heads/main']
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
            
            if result.returncode == 0 and result.stdout.strip():
                sha = result.stdout.strip().split('\t')[0]
                print(f"   ✅ SHA from main: {sha}")
                return sha
                
        except subprocess.TimeoutExpired:
            print(f"   ❌ Timeout getting SHA for {repo}")
        except Exception as e:
            print(f"   ❌ Error getting SHA for {repo}: {e}")
            
        raise Exception(f"Could not get SHA for {repo}@{version}")
    
    def generate_allowlist(self, official_actions: Set[str], third_party_shas: Dict[str, str]) -> str:
        """Generate the allowlist content"""
        print("\n📝 Generating GitHub Actions Allowlist...")
        
        # Try compact format first (comma-separated for GitHub Enterprise compatibility)
        items = [
            "actions/*",
            "github/*"
        ]
        
        # Add third-party actions with SHAs
        for repo, sha in sorted(third_party_shas.items()):
            items.append(f"{repo}@{sha}")
        
        # Generate compact format (comma-separated, single line)
        content = ','.join(items)
        
        # Check character count
        char_count = len(content)
        print(f"   📊 Character count: {char_count}/255 (compact format)")
        
        if char_count > 255:
            print(f"   ❌ ERROR: Allowlist too long! ({char_count} > 255 characters)")
            print("   💡 Consider reducing the number of third-party actions")
            sys.exit(1)
        else:
            print("   ✅ Allowlist fits GitHub's limit")
            
        return content
    
    def save_allowlist(self, content: str):
        """Save allowlist to file"""
        with open(self.allowlist_file, 'w') as f:
            f.write(content)
        print(f"   📁 Saved to: {self.allowlist_file}")
    
    def display_results(self, content: str, official_actions: Set[str], 
                       third_party_actions: Dict[str, str], third_party_shas: Dict[str, str]):
        """Display final results"""
        print("\n🎯 COPY THIS TO GITHUB SETTINGS:")
        print("=" * 63)
        print("Path: Settings → Actions → General → Actions permissions → 'Allow select actions'")
        print()
        print(content.strip())
        print()
        
        print("📋 Action Security Summary:")
        print("=" * 27)
        print(f"✅ Official GitHub Actions ({len(official_actions)} found):")
        for repo in sorted(official_actions):
            print(f"   - {repo}/*")
        
        print(f"\n⚠️  Third-Party Actions ({len(third_party_actions)} found, SHA-pinned):")
        for repo in sorted(third_party_shas.keys()):
            sha = third_party_shas[repo]
            version = third_party_actions[repo]
            print(f"   - {repo}@{sha}  # {version}")
    
    def run(self):
        """Main execution"""
        print("🔒 GitHub Actions Security Manager")
        print("=" * 35)
        
        # Discover all actions
        actions = self.discover_actions()
        if not actions:
            print("❌ No actions found")
            return
        
        # Categorize actions
        official_actions, third_party_actions = self.categorize_actions(actions)
        
        # Get SHAs for third-party actions
        print(f"\n🔍 Processing {len(third_party_actions)} third-party actions for SHA pinning...")
        third_party_shas = {}
        
        for repo, version in third_party_actions.items():
            try:
                sha = self.get_sha(repo, version)
                third_party_shas[repo] = sha
            except Exception as e:
                print(f"❌ Failed to get SHA for {repo}@{version}: {e}")
                sys.exit(1)
        
        # Generate allowlist
        content = self.generate_allowlist(official_actions, third_party_shas)
        
        # Save allowlist
        self.save_allowlist(content)
        
        # Display results
        self.display_results(content, official_actions, third_party_actions, third_party_shas)
        
        print("\n📅 NEXT QUARTERLY UPDATE:")
        print("=" * 24)
        print("Run 'make github-actions-security' again in 3 months")
        print("The script will automatically discover any new actions you've added")
        print()
        print("🚨 SECURITY REMINDER:")
        print("If you add new third-party actions to workflows:")
        print("1. Run 'make github-actions-security' to update the allowlist")
        print("2. Update GitHub settings with the new allowlist")
        print("3. Ensure new actions are pinned to SHAs in your workflows")


if __name__ == "__main__":
    manager = ActionSecurityManager()
    manager.run()
