# G4 — GitHub: remote, branch rename, push

Course: 02_GIT_GITHUB.md · **STATUS: GATE PASSED**
Repo: https://github.com/CodeByRajeshPyla/smartveg (private)

---

## 1. What GitHub actually is

The repo lives in `D:\vegbill\.git`. One copy, one laptop. Drive dies -> project,
notes and history all gone.

> **GitHub is a computer somewhere else holding a second copy of your `.git`.**

Same repo, same commits, **same hashes** — just on a server reachable over the internet.

What it buys:
1. **Backup** — laptop dies, `git clone` onto a new machine, everything is back.
2. **Sharing** — teammates read the code without emailed zip files.
3. **Proof** — commits dated on a server and signed with your email. Viva evidence.

**GitHub adds no new Git concepts.** The daily loop (`status -> add -> commit`) is
unchanged. `push` is one extra step at the end.

---

## 2. Three new words

| Word | Meaning |
|---|---|
| **remote** | a nickname for "another copy of this repo, somewhere else" |
| **origin** | the conventional nickname for your main remote. Nothing magic — but every tutorial assumes it |
| **push** | upload commits that exist locally but not on the remote |

**`push` uploads commits, not files.** Anything uncommitted stays on the laptop and
never reaches GitHub. Commit first, then push.

---

## 3. `master` vs `main`

Git's old default branch name is `master`; GitHub's default is `main`, and the industry
moved years ago. Rename once to avoid endless small mismatches:

```
git branch -M main
```
`-M` = rename, force. Silent. **No commits change** — only the branch label.

---

## 4. The commands

```
git remote add origin https://github.com/CodeByRajeshPyla/smartveg.git
git remote -v          # show remotes
git branch -M main
git push -u origin main
```

- `remote add` prints **nothing** — silence = success. Purely local; GitHub is not
  contacted at all.
- `git remote -v` shows `origin` **twice**: once for `fetch` (download), once for
  `push` (upload). Git permits different URLs for each; identical is normal.
- `-u` = remember this pairing. **Afterwards plain `git push` works with no
  arguments.** Only needed on a branch's first push.

---

## 5. Creating the repo on GitHub — the one big trap

New repository -> name `smartveg` -> **Private** ->
**do NOT tick "Add a README", ".gitignore", or "license". Leave it completely empty.**

Why: you already have a repo with history. If GitHub creates files too, the two
histories collide and the first push fails with a confusing error. This is the most
common G4 mistake.

---

## 6. Authentication — the step that actually goes wrong

**A GitHub password will not work.** Password auth for Git was switched off in 2021.
Instead, Git Credential Manager opens a window on first push; choose **Browser**,
authorize, and Windows stores the credential permanently. Later pushes are silent.

### The failure hit in this lesson
```
remote: Repository not found.
fatal: repository 'https://github.com/CodeByRajeshPyla/smartveg.git/' not found
```

**`Repository not found` means one of two things and GitHub will not say which:**
1. the repo genuinely does not exist, **or**
2. it exists but is **private**, and whoever GitHub thinks you are cannot see it.

GitHub says "not found" rather than "not allowed" on purpose — otherwise anyone could
probe which private repos exist.

**The real cause here:** no login window ever appeared, which means Git was *not even
trying* to authenticate — it already had a credential. A stale GitHub login from the
machine's previous owner-account was saved in Windows Credential Manager:

```
Target: LegacyGeneric:target=git:https://github.com
```

Found with `cmdkey /list`. Deleted with:
```
cmdkey /delete:LegacyGeneric:target=git:https://github.com
```
Safe and reversible — it only removes a saved password for github.com. Nothing about
the repo, commits or files is touched.

The next push then printed `please complete authentication in your browser...` and
worked.

> **Diagnostic rule: if a Git network command fails with NO login prompt, suspect a
> stale saved credential, not a wrong URL.**

Also check the browser is signed in as the right GitHub account — authorizing the wrong
one produces the identical "Repository not found".

`git ls-remote origin` is a lightweight way to test the connection without pushing.

---

## 7. Reading a successful push

```
Enumerating objects: 88, done.
Compressing objects: 100% (71/71), done.
Writing objects: 100% (88/88), 3.45 MiB | 33.00 KiB/s, done.
Total 88 (delta 8), reused 0
remote: Resolving deltas: 100% (8/8), done.
To https://github.com/CodeByRajeshPyla/smartveg.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

- **object** = Git's internal unit: a file version, a folder listing, or a commit.
- **delta compression** = Git sends the *differences* between versions where it can,
  not whole files. That is why pushing a large history is usually fast.
- **`[new branch] main -> main`** — GitHub had no `main`, so it created one from yours.
- **`set up to track 'origin/main'`** — the `-u` flag. Local `main` is now paired with
  GitHub's `main`.
- Ignored files (`.dart_tool`, `.idea`, `build/`) are never in commits, so they never
  reach GitHub. `.gitignore` saved a large upload.

---

## 8. GATE — PASSED

```
$ git remote -v
origin  https://github.com/CodeByRajeshPyla/smartveg.git (fetch)
origin  https://github.com/CodeByRajeshPyla/smartveg.git (push)

$ git log --oneline --decorate
e66c8b2 (HEAD -> main, origin/main) Add G3 notes
12441fd Add G0, G1 and G2 notes
a9a33a9 Initial commit: Flutter project created
```

### Reading the decorations — important
Three labels on one commit:

| Label | Means |
|---|---|
| `HEAD` | you are here |
| `main` | your local branch |
| `origin/main` | **GitHub's** branch, as Git last saw it |

**All three on the same commit = local and GitHub are in sync.**
Commit again and `main` moves forward while `origin/main` stays behind — that is Git
showing you that you have unpushed work. This line is the at-a-glance answer to
"did I push?"

`git status -sb` shows the same thing compactly: `## main...origin/main`

---

## 9. The new daily loop

```
edit -> git status -> git add . -> git commit -m "..." -> git push
```
`git push` alone is enough from now on, thanks to `-u`.

---

## 10. Viva answers

**Q: What is `origin`?**
The nickname registered locally for the remote repository's URL — by convention, the
main remote, here the GitHub copy.

**Q: What does `push` do?**
Uploads commits that exist in the local repository but not yet on the remote.

**Q: Why is GitHub better than keeping code only on the laptop?**
It is an off-machine backup, it lets teammates access the code, and it provides a
dated, authored record of the work on an independent server.

**Q: Does GitHub store your files or your commits?**
Commits — the full history. Uncommitted changes and ignored files never reach it.

**Q: Why rename `master` to `main`?**
`main` is GitHub's default and the current industry convention; matching it avoids
branch-name mismatches.

---

## NEXT — G5
Good commit messages. Short habit lesson, no setup.
