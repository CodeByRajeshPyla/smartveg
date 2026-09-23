# G1 — Git Identity (complete notes)

Course: 02_GIT_GITHUB.md · Status: gate pending

---

## 1. What Git is (G0 recap, needed for the viva)

> Git is a program that takes snapshots of a folder and remembers every one of
> them, forever, along with who took it, when, and why.

- One snapshot = one **commit**.
- Every commit stores: **who** (name + email), **when** (timestamp),
  **why** (your message), **what changed** (exact lines vs the previous commit).
- All of it lives in one hidden folder, `.git`, inside the project.
  Delete `.git` -> history is gone, current files remain.
  Copy the project folder -> the full history travels with it.
- Replaces the `project - copy (2) FINAL USE THIS ONE` habit with one folder
  plus a readable list of snapshots.

**Git is not GitHub.** Git = the program on the laptop, works fully offline.
GitHub = a website that stores a copy online. Git first (G1-G3), GitHub after (G4).

### Why this project needs it
1. **Viva evidence** — `git log` shows dates and steps, proving you built SmartVeg yourself.
2. **The atomic checkout transaction** — the most important code in the project.
   You will break it while getting it right. Git is the undo button.
3. **Teammates** — sharing code without emailing zip files.

---

## 2. What G1 is about

Every commit is signed with an author name and email.
G1 = putting *your* stamp on that signature, before the first commit exists.

Order matters: identity is set **before** `git init`, because global settings live
in your user folder, not in any repo — Git accepts them with no repo present.
Git stamps the author at the moment of the commit, so the name must already be right.

---

## 3. Global vs local (the core concept of this lesson)

The only real difference is **which file the setting is written into**, and therefore
how far it reaches.

| | Flag | File written | Applies to |
|---|---|---|---|
| Global | `--global` | `C:\Users\rajeshpyla\.gitconfig` | every repo on this computer |
| Local | *(no flag)* | `<project>\.git\config` | that one project only |

Consequence worth reasoning out: the local file sits **inside `.git`**, so
**local settings only work inside a repo**. In a plain folder, `git config user.name "X"`
errors out — there is nowhere to write.

### Precedence
Git reads global first, then local, and **local wins**. Global is a default that a
project can override. The global value is not deleted or changed — just outranked there.

```
global: user.email = rajeshpyla78@gmail.com      <- default, everywhere
local (inside vegbill): user.email = work@x.com  <- wins, here only
```

### Which to use
- **Global** — anything true of you as a person: name, email, editor. Set once.
- **Local** — anything true of one project only. Classic case: personal email globally,
  employer's required email locally inside the work repo.

Global is correct for this project: your machine, you are the only one committing.

### The bug this causes in real life
Commits silently signed with the wrong email, because a stale local setting was
overriding global and nobody looked. The command that shows *which file* each setting
came from:

```
git config --list --show-origin
```

---

## 4. The commands (G1 itself)

```
git config --global user.name "CodeByRajeshPyla"
git config --global user.email "rajeshpyla78@gmail.com"
git config --global --list
```

### Reading the command, piece by piece
- `git` — the program
- `config` — the sub-command that reads and writes settings
- `--global` — write it for all projects on this computer
- `user.name` — section `user`, key `name`. The settings file is grouped into
  sections; the dot separates section from key.
- `"CodeByRajeshPyla"` — the value. Quotes are required when the value contains a
  space (otherwise Git reads two separate arguments). Quote always, as a habit.

### Notes on behaviour
- `config` **overwrites**, it does not append. The previous
  `rajeshpyla66@gmail.com` disappears.
- `--list` also prints unrelated lines (`core.autocrlf`, `init.defaultbranch`, ...)
  that came with the Git install. Ignore them; only the two `user.` lines matter here.

### user.name vs GitHub username
`user.name` is only the **display name printed on commits**. The GitHub username is a
separate thing (the one in your profile URL). They may be identical — that is a common
choice. Use the **same email** (`rajeshpyla78@gmail.com`) when signing up for GitHub in
G4, otherwise GitHub will not link these commits to your profile.

---

## 5. GATE

`git config --global --list` output contains:

```
user.name=CodeByRajeshPyla
user.email=rajeshpyla78@gmail.com
```

and `git --version` prints a version number (already confirmed: 2.53.0.windows.2).

---

## 6. Viva answers to have ready

**Q: What is Git?**
A program that stores snapshots of a project, each signed with an author, a timestamp
and a message, so any previous state can be restored exactly.

**Q: Difference between Git and GitHub?**
Git is the local version-control program and works offline. GitHub is a hosting website
that stores a copy of the repository online for backup and collaboration.

**Q: Why configure user.name and user.email?**
Every commit records its author. Without them Git refuses to commit, and the history
carries no proof of who wrote the code.

**Q: Global vs local config?**
Global lives in the user folder and applies to every repository on the machine; local
lives in the repository's own `.git/config` and applies only there. Local overrides
global.

**Q: Where does Git keep the history?**
In the hidden `.git` folder inside the project.

---

## NEXT — G2
`git init` (turn the folder into a repo), then `git add` (stage) and `git commit`
(save) for the first real snapshot.
