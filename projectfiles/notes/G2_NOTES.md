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

A plain text file listing paths Git should skip. Flutter created one already.

It lists generated output: `build/`, `.dart_tool/`, etc.

Why ignore them: Flutter **regenerates** them from your source on every compile.
Snapshotting them would add hundreds of MB carrying zero information. Ignored files do
not appear in `git status` and are never committed.

Rule of thumb: **source goes in Git; anything a tool can rebuild does not.**

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

## 6. GATE

`git log` shows **one** commit, with your message and your name as Author.

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
