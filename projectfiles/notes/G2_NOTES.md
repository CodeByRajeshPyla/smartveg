# G2 — Init, Add, Commit (complete notes)

Course: 02_GIT_GITHUB.md · Project folder: `D:\vegbill`

---

## 0. Vocabulary first

**Repo (repository)** = a folder that Git is tracking.
An ordinary folder + a hidden `.git` folder inside it. Nothing else changes.

```
Plain folder            Repository
vegbill/                vegbill/
  lib/                    .git/       <- the only difference
  pubspec.yaml            lib/
  android/                pubspec.yaml
```

Consequences worth being able to state:
- Delete `.git` -> history gone, current files untouched.
- Copy the folder -> the full history travels with it.
- **Local** config lives at `.git\config`, which is why local config only works
  inside a repo.

---

## 1. `git init` — create the repo

```
git init
```

Output seen: `Initialized empty Git repository in D:/vegbill/.git/`

- Creates the hidden `.git` folder. **That is all it does.**
- Files are not touched, moved, or copied. **Nothing is saved yet.**
- The word **empty** in the output = **zero commits**. `init` builds the container,
  it does not put anything in it.

Verify:
```
ls -Force
```
`-Force` = PowerShell's "show hidden files too". In the Mode column `.git` shows
`d--h--`: `d` = directory, `h` = hidden. Every other folder shows `d-----`.

`git init` also creates `.git\config` (the local config file), but with **no `[user]`
section** — so nothing overrides global, and commits are signed `CodeByRajeshPyla`.

> Run `git init` in the **right folder**. Running it one level too high creates a repo
> that wraps the project instead of being the project. Prompt must read `PS D:\vegbill>`.

---

## 2. `git status` — the situation right now

```
git status
```

The most-run command in Git. **Read-only — it can never break anything.** Run it
constantly: before adding, before committing, whenever unsure.

It answers: what branch am I on, what has changed, what is staged, what is untracked.

**Untracked** = a file Git can see but has never snapshotted and is not watching.
Every file in the project is untracked right after `git init`.

---

## 3. `.gitignore` — files Git must never snapshot

**A plain text file, one rule per line, listing what Git must pretend does not exist.**
No magic. Anything matching a line: never appears in `git status`, never staged by
`git add .`, never enters a commit.

Flutter created this file for you (`flutter create` did it). Most languages ship a
standard one. You will rarely edit it — but you will add a line one day.

### Syntax
| Pattern | Means |
|---|---|
| `# Miscellaneous` | comment — for humans, ignored by Git |
| `.idea/` | trailing slash = a **folder**, and everything inside |
| `*.log` | `*` = anything. Matches `error.log`, `build.log`, any `.log` file |
| `/build/` | leading slash = only at the **top** of the project, not nested deeper |
| `#.vscode/` | commented out, so it is **NOT** ignored |

That last one is deliberate: Flutter left `.vscode/` trackable because you may *want*
editor settings shared with teammates. Your choice to uncomment.

### Why ignore anything — four reasons, all present in this project's file
1. **Regenerated output** — `/build/`, `.dart_tool/`. Flutter rebuilds them from source
   on every compile. Committing them = hundreds of MB, zero information, stale
   immediately.
2. **Editor settings** — `.idea/`, `*.iml`. Belong to Android Studio on *your* machine.
   A teammate on VS Code does not want them.
3. **OS junk** — `.DS_Store`, a file macOS drops into every folder.
4. **Secrets** — the big one in real projects. API keys, passwords. **In Stage 5, the
   Firebase config file goes here** — otherwise the keys get published to GitHub for
   the world to read. Common and expensive mistake.

### Rule of thumb
> **Your source code goes in Git. Anything a tool can regenerate, or anything secret,
> does not.**

### Proof seen in this lesson
`.dart_tool/`, `.idea/` and `*.iml` are all listed in the file — and `.dart_tool`,
`.idea` and `vegbill.iml` never appeared in a single `git status` or commit, though
they sit in the folder.

### The trap worth knowing now
`.gitignore` only affects files Git is **not already tracking**. Commit a file first,
add it to `.gitignore` afterwards, and Git keeps tracking it — the rule is simply
ignored. To stop it: `git rm --cached <file>`. The day this bites, you will have no
idea why the file will not go away.

---

## 4. The two-step save (the core concept of G2)

Git saves in **two** steps, not one.

| Step | Command | What it does |
|---|---|---|
| Stage | `git add` | Mark files to go into the *next* snapshot. **Nothing saved yet.** |
| Save | `git commit` | Write everything staged as one permanent snapshot + message |

**The shop analogy:** `add` = tapping tiles to put items in the cart.
`commit` = tapping **Mark paid**. The cart is not a bill until you pay.

**Why two steps and not one:** so you choose *what* goes into a snapshot. You may have
edited five files but only want three in this commit. Staging is that filter — it keeps
each commit about one thing, which is what makes the history readable later.

```
working folder  --git add-->  staging area  --git commit-->  .git history
```

---

## 5. The commands

```
git add .
```
- `add` = stage.
- `.` = "this folder and everything inside it".
- Files listed in `.gitignore` are skipped automatically.

```
git commit -m "Initial commit: Flutter project created"
```
- `commit` = save the staged files as one snapshot.
- `-m` = "message follows". Without `-m`, Git opens a text editor to demand one.
- The message is the **why**. It is not optional and it is read by future-you.

```
git log
```
Shows the history. Example shape:
```
commit 81a6b4f396d2170c12b9488f94412348c467a90e
Author: CodeByRajeshPyla <rajeshpyla78@gmail.com>
Date:   Tue Sep 22 16:47:20 2026 +0530

    Add note file
```
- The long hex string is the **commit hash** — a unique ID for that snapshot.
- The `Author:` line was **not typed at commit time**. Git read it from the global
  config. That is what G1 was for.
- The author is **baked in permanently**. Changing global config later does **not**
  fix old commits. That is why identity is lesson G1, not G5.

```
git log --oneline
```
Same history, one line per commit — hash + message. What you actually use day to day.

---

## 6. GATE — PASSED

```
commit a9a33a9603ed2ee7adbba05df0c7e405cc0c705e (HEAD -> master)
Author: CodeByRajeshPyla <rajeshpyla78@gmail.com>
Date:   Wed Sep 23 14:03:39 2026 +0530

    Initial commit: Flutter project created
```
First snapshot of SmartVeg: 50 files, 2639 insertions.

### Things this output teaches
- The `Author:` line was **never typed**. Git read it from the global config (G1).
- `a9a33a9603ed...` is the full **40-character hash**; `a9a33a9` is the short form.
  It is computed from the snapshot's contents, so it is unique and unforgeable.
- **`HEAD`** = "you are here" — Git's pointer to your current position in history.
- After committing, `git status` says **`nothing to commit, working tree clean`**:
  the folder and the last snapshot are identical. Nothing unsaved. This is the state
  to be in at the end of every lesson.

### Reading the commit's own output
```
[master (root-commit) a9a33a9] Initial commit: Flutter project created
 50 files changed, 2639 insertions(+)
```
- `master` — the branch (G6 topic).
- `(root-commit)` — the **first commit in the repo**; it has no parent. Seen exactly
  once in a project's life. Every later commit points back to the one before it,
  forming a chain.
- `a9a33a9` — short commit hash.
- `2639 insertions(+)` — 2639 lines added, none removed; everything was new.
- `create mode 100644` — new file, ordinary permissions.

### Two things observed on the way
- **Git tracks files, not folders.** Before staging, status collapsed `android/` to one
  line; after staging it listed all 23 files inside. Consequence: Git cannot store an
  empty folder — there is no file in it to track.
- **CRLF warnings on `git add` are not errors.** Windows ends lines with CR+LF, Linux
  and Mac with LF. Git stores LF internally so a file is identical everywhere, and
  converts back on checkout. The warning just announces that conversion. Ignore it.
- **`git log` opens a pager** when output is long. Press **`q`** to quit back to the
  prompt; space/arrows scroll.

---

## 7. Viva answers to have ready

**Q: What does `git init` do?**
Creates the hidden `.git` folder, turning an ordinary folder into a repository. It saves
nothing — the repo starts empty, with zero commits.

**Q: Difference between `add` and `commit`?**
`add` stages files, marking what will go into the next snapshot; nothing is saved.
`commit` writes everything staged into the history as one permanent snapshot with a
message. Two steps so you control exactly what each commit contains.

**Q: What is the staging area for?**
To choose which of your changes belong in this snapshot, so each commit covers one
logical change and the history stays readable.

**Q: What is `.gitignore`?**
A list of paths Git must never track — build output and generated files that tools
recreate from source, so committing them adds size without information.

**Q: Where does the Author name come from?**
From the config set in G1; Git stamps it automatically at commit time and it is stored
permanently in that commit.

---

## NEXT — G3
The daily workflow: `status` -> `add` -> `commit`, repeated after every lesson.
