# Import External Repository with Full History

Import an external Git repository into this monorepo while preserving all commit history and contributor attributions. The imported code will NOT be a submodule - files will be regular tracked files in this repo.

## Process

1. Ask me for the following information:
   - **Upstream Repository URL**: The Git URL to import from
   - **Target Path**: Where to place the code in this monorepo (e.g., `providers/aws/primitives/lambda`)
   - **Branch Name**: The branch to import from the upstream repo (e.g., `master`, `main`)

2. Execute the import:
   ```bash
   # Add upstream as temporary remote
   git remote add temp-upstream <UPSTREAM_URL>
   
   # Fetch the specified branch
   git fetch temp-upstream <BRANCH_NAME>
   
   # Read the tree into target path
   git read-tree --prefix=<TARGET_PATH>/ -u temp-upstream/<BRANCH_NAME>
   
   # Commit the files
   git commit -m "feat: Import <repo-name> with full history

Imported from <UPSTREAM_URL>
Branch: <BRANCH_NAME>
Preserves all commit history and contributor attributions"
   
   # Merge the history
   git merge -s ours --no-commit --allow-unrelated-histories temp-upstream/<BRANCH_NAME>
   
   # Complete the merge
   git commit -m "Merge <repo-name> history into monorepo

Merges full commit history from <UPSTREAM_URL>
All original contributors and their commits are preserved"
   
   # Clean up
   git remote remove temp-upstream
   ```

3. Verify the import:
   - Confirm files exist in target path
   - Confirm no `.git` folder exists in target path
   - Show sample of preserved commit history with `git log --all --oneline | grep -i <keyword> | head -20`
   - Show one commit with author details to verify attribution: `git show --format=fuller <commit-hash> | head -15`

## Expected Result

- All files from upstream repo are in the target path
- No `.git` subdirectory (not a submodule)
- Full commit history is merged into this repo
- All original authors and dates are preserved
- Ready for refactoring while maintaining contribution history
