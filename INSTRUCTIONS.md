<details>
 <summary>Git Workflow Guide for Teams</summary>
<br>

  This Git workflow is designed for teams collaborating on a shared project using feature branches. It minimizes merge conflicts, keeps your branch aligned with the latest changes in `main`, and preserves a clean commit history.

---
  <details>
    <summary>Before You Begin Working</summary>
    
## Step 1: Always Start from the Latest `main`

Update your local `main` branch before starting any new work:

```bash
git checkout main
git pull origin main
```

This ensures your base is fully up-to-date with all recent merges and changes made by your teammates.

---

## Step 2: Create a Feature Branch from Updated `main`

Create a new branch for each task or feature you're working on:

```bash
git checkout -b feature/your-task-name
```
Choose a clear and descriptive name, such as `feature/backend-ride-history`.

---
</details>

<details><summary>While Working</summary>
  
## Step 3: Work on Your Feature and Commit Regularly

Make your changes, and commit them in small logical chunks:

```bash
git add .
git commit -m "Brief but clear description of your change"

#### Stage new, modified and deleted files
git add .

# Stage new and modified, ignore deleted files
git add --ignore-removal .

# Stage modified and deleted files, ignore new files
git add -u
```
Frequent, well-labeled commits make it easier to understand your work and review changes.

---

## Step 4: Rebase Regularly to Stay in Sync with `main`

While working on your feature branch, regularly update your code with changes from the main branch:

```bash
git fetch origin
git rebase origin/main
```

This reapplies your changes on top of the latest commits in `main`, reducing the chances of conflicts when merging.

---

## Step 5: Push Your Feature Branch Often

Push your branch to GitHub to share your progress with the team:

```
git push origin feature/your-task-name
```

This allows others to review your code or collaborate with you on the same branch. Do not rebase anymore after you use push. 

---
</details>

<details><summary>After Working</summary>
## Step 6: Open a Pull Request and Merge to `main`

Once you're done and your branch is up to date:

1. Push your latest changes
2. Open a pull request (PR) on GitHub
3. Request review from your teammates
4. Merge using "Squash and merge" or "Rebase and merge" to keep the commit history clean

---

## Step 7: After Merge, Clean Up Local Branches

Delete your local feature branch once the PR is merged:

```bash
git checkout main
git pull origin main
git branch -d feature/your-task-name
```

This keeps your workspace tidy.

---
</details>

## Workflow Comparison: Rebase vs Merge

### Updating Local `main`

```bash
git checkout main
git pull origin main
```

This updates your local `main` to match the remote. Use this **before creating a new branch**.

### Rebasing Feature Branch on Latest `main` (Preferred)

```bash
git fetch origin
git rebase origin/main
```

This replays your feature branch commits on top of the latest `main`. It avoids merge commits and keeps history clean. Reduces the chance of complex merge conflicts later on.

<br>

However, be careful because rebase rewrites commit history, any collaborators who pulled your branch before the rebase will now have inconsistent histories. 
Their Git will get confused, and they may have to reset or clean up local branches manually. 
This may be an issue when you rebase and then force-push or you have alrady pushed your branch to GitHub AND others are using that pushed branch.

![image](https://github.com/user-attachments/assets/b71c1221-9a68-4025-af2a-2aefd4618242)

If no one else is using the branch you pushed yet,  you can continue to use the following commands without worry
```
git fetch origin
git rebase origin/main
git push --force-with-lease
```
But if others are collaborating on the same branch, use `git pull origin main` instead to avoid rewriting shared history.





### Merging `main` into Feature Branch (Alternative)

```bash
git pull origin main
```

This merges `main` into your branch and creates a merge commit. Use only if rebase is not preferred.

---
</details>

<details>
  <summary>Guides and Videos</summary>
  
  - GitHub **Actions**
    - [YouTube Certification Tutorial](https://www.youtube.com/watch?v=Tz7FsunBbfQ)
      
  - **Pull Requests** : How to Make Them Good & How to Review Other PRs
    - [GitHub Docs: Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/reviewing-changes-in-pull-requests/about-pull-request-reviews) Pay attention to how to  have conversations in a pull request, comment on a pull request (incl. line comments)
  
  - Using **Project & Issues**
    - [GitHub Docs: Project Best Practices](https://docs.github.com/en/issues/planning-and-tracking-with-projects/learning-about-projects/best-practices-for-projects)
</details>

[Git commandline cheatsheet](https://training.github.com/downloads/github-git-cheat-sheet/)
