# G5 — Commit Messages

Course: 02_GIT_GITHUB.md · **STATUS: GATE PASSED**
Shortest lesson in the course. No setup, one habit.

---

## 1. The point

A commit message answers **what changed and why** — not *how*.
The code already shows how; the diff is right there. What the diff cannot show is the
**intention**.

Real audience, in order:
1. **Future-you at 1am**, scrolling `git log --oneline` for the last commit where
   billing worked.
2. **The viva panel**, reading that same list.

---

## 2. Good vs bad

| Bad | Why it fails |
|---|---|
| `update` | updated *what*? |
| `stuff` | which stuff? |
| `fix` | fixed what? did it work? |
| `asdfgh` | everyone writes this at least once |

| Good |
|---|
| `Add splash screen with BLE scanning` |
| `Implement stability gate on tile grid` |
| `Fix discount cap calculation` |
| `Add SQLite database with 4 tables` |

**The difference:** every good message names a **thing** and an **action on it**.
Every bad one names neither.

**The test:** read the good list on its own — it reads like a project report.

---

## 3. The recipe

> **Start with a verb, present tense, and name the thing.**

`Add` · `Fix` · `Remove` · `Implement` · `Update` · `Refactor`

- **Present tense** (`Add`, not `Added`): a commit describes what it *does* to the
  codebase when applied. It is a convention, and consistency beats the logic.
- **Under ~50 characters.**
- **If the message needs an "and", the commit is probably doing two things** and should
  be two commits. `Add BLE scanning and fix discount cap` = two unrelated changes; you
  will one day want to undo one without losing the other.

---

## 4. Why this is a lesson and not a nicety

One `update` is survivable. Twenty of them and the whole history reads:

```
update
fix
update
stuff
fix again
```

That is not a history, it is a list of dates. You cannot find the commit where billing
last worked — so the undo button built across G0-G4 becomes **unusable**.

> **The messages are what make the history searchable.**

---

## 5. This project's own history

```
b549e67 Add G4 notes
e66c8b2 Add G3 notes
12441fd Add G0, G1 and G2 notes
a9a33a9 Initial commit: Flutter project created
```

Verb-first, names the thing, readable by a stranger. Keep doing exactly this.

Note `12441fd` contains an "and" — by the rule above that could have been two commits.
Minor here (all the same kind of change), but split it when the two things are
unrelated.

---

## 6. GATE — PASSED

**Q: Why is `Add weight display to billing screen` better than `update`?**

It tells you **what changed and where**, in one line, without opening anything.
`update` tells you nothing — you would have to open the commit and read the diff to
find out what it even touched.

---

## 7. Reading a second push to the same branch

```
Writing objects: 100% (5/5), 3.66 KiB
To https://github.com/CodeByRajeshPyla/smartveg.git
   e66c8b2..b549e67  main -> main
```

Three differences from the **first** push:
- **`e66c8b2..b549e67`** instead of `[new branch]` — GitHub already had `main`; this
  moved it forward from the old commit to the new one.
- **No login prompt** — Windows saved the credential after the one browser sign-in.
- **3.66 KiB, not 3.45 MiB** — only the new commit travelled; the 88 earlier objects
  were reused.

---

## NEXT
G6 (branching) is optional — skip until the multi-bill switcher, which is exactly the
"experiment that could break working code" case it is for.
Git is now a habit, not a course. On to `03_FLUTTER_COURSE.md`.
