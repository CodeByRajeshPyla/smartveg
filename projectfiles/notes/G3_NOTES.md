# G3 — The Daily Workflow

Course: 02_GIT_GITHUB.md · **STATUS: GATE PASSED**

---

## 1. The four states a file can be in

| State | Meaning | When you see it |
|---|---|---|
| **Untracked** | Git sees it but has never saved it | brand new file |
| **Modified** | Git saved it before, and it has changed since | you edited an existing file |
| **Staged** | marked to go into the next commit | after `git add` |
| **Clean** | identical to the last commit | after `git commit` |

In G2 every file was **untracked** — Git had never saved anything.
In G3 `G2_NOTES.md` was **modified** — it existed in commit `a9a33a9` and changed after.

**Git only ever reports what differs.** `G1_NOTES.md` was untouched, so it never
appeared in any status output. That is why `git status` stays short and useful even in
a big project.

Both kinds can appear in one commit:
```
new file:   projectfiles/notes/G0_NOTES.md     <- never seen before
modified:   projectfiles/notes/G2_NOTES.md     <- known, contents changed
```

---

## 2. `git status` is a mirror, not a fixed message

It has no fixed output. It describes the situation *at that moment*. Same command,
four different answers in one session:

| When | What it said | Why |
|---|---|---|
| after `git init` | `No commits yet` + **Untracked files** | Git had never saved anything |
| after `git add .` | **Changes to be committed** (50 files) | they were staged |
| after `git commit` | `nothing to commit, working tree clean` | folder matched the snapshot |
| after a file was edited | **Changes not staged** — `modified: ...` | folder now differs from the snapshot |

If it printed the same thing always, it would be useless.

---

## 3. Git prints the commands you probably want — read them

Before staging:
```
(use "git add <file>..." to update what will be committed)
(use "git restore <file>..." to discard changes in working directory)
```
After staging, the second hint changes:
```
(use "git restore --staged <file>..." to unstage)
```

| Command | Does |
|---|---|
| `git add <file>` | keep the change, put it in the cart |
| `git restore <file>` | **throw the change away** — file goes back to how it was in the last commit |
| `git restore --staged <file>` | take it **out of the cart**, change is kept in the folder |

`git restore` is the payoff of the whole system: broke something, do not know what you
did, do not care — restore it to the last known-good state instantly.

Note the difference: **unstage** removes from the cart. **Restore** throws the item away.

`no changes added to commit` = the staging area is empty.

---

## 4. THE DAILY LOOP — the whole of G3

```
  edit files -> git status -> git add . -> git status -> git commit -m "..."
                    ^                                            |
                    +--------------------------------------------+
```

Run after every lesson for the rest of the project.
`status` **before** adding (what changed?), `status` **after** adding (did I stage the
right things?), then commit.

> **Habit: status often, commit small.**

**Why commit small and often:** each commit is a restore point. One giant commit per
week means your only undo goes back a week. One commit per lesson means you can always
step back exactly one step.

---

## 5. Reading a non-first commit

```
[master 12441fd] Add G0, G1 and G2 notes
 2 files changed, 212 insertions(+), 11 deletions(-)
 create mode 100644 projectfiles/notes/G0_NOTES.md
```

Compared with the very first commit:

- **No `(root-commit)`.** This commit has a **parent**, `a9a33a9`. The chain has begun:
  ```
  a9a33a9  <-  12441fd
  (first)      (points back to the first)
  ```
  That is physically what a Git history is: each commit pointing at the one before it.
- **`11 deletions(-)`** — the first commit had none. Git does not store "the file
  changed"; it stores exactly which lines left and which arrived. That is what makes
  returning to any point precise.
- **`2 files changed`, not 50.** Only what actually differed. The other 48 are reused,
  not re-saved — which is why hundreds of commits do not cost hundreds of copies of
  disk space.
- **`create mode` appears once**, only for the genuinely new file.

---

## 6. `git log --oneline`

```
12441fd (HEAD -> master) Add G0, G1 and G2 notes
a9a33a9 Initial commit: Flutter project created
```

- Newest first. Read bottom-up and it is the story of the project.
- **`HEAD` moved.** It was on `a9a33a9`; committing moved it to `12441fd`.
  `HEAD` = "you are here", and it follows you along the chain as you commit.
- This list is what an examiner sees: dated, signed, step by step.

---

## 7. GATE — PASSED

```
12441fd (HEAD -> master) Add G0, G1 and G2 notes
a9a33a9 Initial commit: Flutter project created

nothing to commit, working tree clean
```

---

## 8. Viva answers

**Q: Difference between untracked and modified?**
Untracked means Git has never saved that file. Modified means Git has it in a previous
commit and the file has changed since.

**Q: What does `git status` tell you?**
The current state of the working folder relative to the last commit and the staging
area: what is untracked, modified, staged, and whether the tree is clean.

**Q: How do you undo a change you have not committed?**
`git restore <file>` returns it to the state in the last commit.
`git restore --staged <file>` only unstages it, keeping the edit.

**Q: Why commit often rather than once at the end?**
Every commit is a restore point and a readable step in the history. Rare commits mean
the only undo available jumps a long way back.

**Q: How does Git store a history?**
As a chain of commits, each one recording the exact lines changed and pointing back to
its parent.

---

## NEXT — G4
GitHub: creating the online repository and pushing this history to it.
