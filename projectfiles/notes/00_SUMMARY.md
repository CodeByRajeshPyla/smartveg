# SmartVeg — Learning Progress

Owner: Rajesh Pyla · Repo: https://github.com/CodeByRajeshPyla/smartveg (private)

---

## Where things stand

| Stage | Status |
|---|---|
| **Hardware** (ESP32 + HX711 + load cell + LCD + BLE) | DONE before this course |
| **Git & GitHub** — G0, G1, G2, G3, G4, G5 | **DONE** |
| G6 — branching | skipped, optional — do it before the multi-bill switcher |
| **Flutter** — S0.1 flutter doctor | **DONE** |
| S0.2 — real phone connected | **IN PROGRESS** |
| S0.3 onward — the app | not started |

Notes files: `G0_NOTES.md` ... `G5_NOTES.md` in this folder.

---

## THE GIT COURSE IN ONE PAGE

### What Git is
> A program that takes snapshots of a folder and remembers every one forever, with who
> took it, when, and why.

- One snapshot = one **commit**, storing who / when / why / what changed.
- All of it lives in the hidden **`.git`** folder inside the project.
- **Git != GitHub.** Git is the local program (works offline); GitHub is a website
  holding a second copy.

### The three places a file can be
```
YOUR FOLDER --git add--> STAGING ("cart") --git commit--> HISTORY (.git) --git push--> GITHUB
```
- `add` = put in the cart. Nothing saved yet.
- `commit` = Mark paid. Saved permanently, locally.
- `push` = send commits to GitHub. **Commits, not files** — uncommitted work never goes.

### The four file states
**Untracked** (never saved) · **Modified** (saved before, changed since) ·
**Staged** (in the cart) · **Clean** (matches the last commit).
Git only ever reports what differs — that is why `git status` stays short.

### Identity
Set once in G1, stamped automatically on every commit, **baked in permanently**.
- **Global** (`--global`, `C:\Users\<you>\.gitconfig`) = every repo on the machine.
- **Local** (no flag, `<project>\.git\config`) = that project only, and **it wins**.
- Global = your default; local = the exception. The email must match the GitHub account
  or commits will not link to your profile.

### The daily loop — the habit that remains
```
edit -> git status -> git add . -> git status -> git commit -m "..." -> git push
```
> **status often, commit small.** Each commit is a restore point.

### Commit messages
Verb first, present tense, name the thing, under ~50 chars.
`Add splash screen with BLE scanning`, not `update`.
The messages are what make the history **searchable**.

### `.gitignore`
A plain list of what Git must pretend does not exist.
> **Your source code goes in Git. Anything a tool can regenerate, or anything secret,
> does not.**
In Stage 5 the Firebase config file goes here — or the keys get published.

### Reading the labels
```
b549e67 (HEAD -> main, origin/main) Add G4 notes
```
`HEAD` = you are here · `main` = local branch · `origin/main` = GitHub's branch.
**All three on one commit = in sync.** Local ahead = unpushed work.

### Branch
A **name pointing at one commit**, which slides forward as you commit.
Purpose: a place to try things that cannot hurt the version that works.
One branch (`main`) is correct for now.

### Undo
`git restore <file>` — throw the change away, back to the last commit.
`git restore --staged <file>` — take out of the cart, keep the edit.

---

## THE COMMANDS THAT MATTER

```
git config --global user.name "..."     # G1, once
git config --global user.email "..."    # G1, once
git init                                # once per project
git status                              # constantly. read-only, safe
git add .                               # stage everything not ignored
git commit -m "Add thing to place"      # save a snapshot
git log --oneline                       # the history
git remote add origin <url>             # once per project
git branch -M main                      # once per project
git push -u origin main                 # first push only
git push                                # every push after that
```

---

## PROBLEMS HIT (and what they taught)

| Symptom | Cause | Lesson |
|---|---|---|
| `LF will be replaced by CRLF` | Windows uses CR+LF, Linux/Mac LF; Git stores LF internally | **a warning, not an error** — ignore |
| `git log` seemed to hang | it opened a pager | press **`q`** to quit |
| `remote: Repository not found` | private repo + **stale saved GitHub credential** from a previous account, so Git never prompted | **no login prompt on a failing network command = suspect a stale credential, not a wrong URL.** Found with `cmdkey /list`, removed with `cmdkey /delete:...` |
| `flutter doctor` red X on Visual Studio | only needed for Windows desktop builds | doctor checks **every** platform; only your target's rows matter |

---

## VIVA — THE GIT QUESTIONS

**What is Git?** A program storing snapshots of a project, each signed with an author,
timestamp and message, so any previous state can be restored exactly.

**Git vs GitHub?** Git is the local version-control program, works offline. GitHub is a
hosting website keeping a copy online for backup and collaboration.

**add vs commit?** `add` stages — marks what goes into the next snapshot, saving
nothing. `commit` writes everything staged into history permanently. Two steps so each
commit covers one logical change.

**What is `origin`?** The local nickname for the remote repository's URL.

**What does `push` do?** Uploads commits that exist locally but not on the remote.

**How do you undo an uncommitted change?** `git restore <file>`.

**Why commit often?** Every commit is a restore point and a readable step; rare commits
mean the only undo jumps far back.

**Where is the history stored?** In the hidden `.git` folder inside the project.

---

## NEXT
S0.2 — enable USB debugging, connect the phone, `flutter devices`.
A **real phone is required**: an emulator has no Bluetooth radio, and the entire
project depends on receiving `"grams,stableflag"` from the ESP32 over BLE.
