# 02 — GIT & GITHUB COURSE

Learn Git by using it on your real project from day one. Every lesson ends in a gate.

---

## WHY GIT MATTERS FOR YOU (not just theory)

Without Git: you have one copy of your code. If you break something, you manually undo
changes and hope you remember what you changed. If your laptop dies, everything is gone.

With Git: every meaningful save creates a snapshot you can always return to. GitHub stores
a cloud copy. You can experiment fearlessly because rolling back is one command.

For your viva: "We used Git for version control and GitHub for cloud backup. The full
commit history shows how the app was built incrementally."

---

## LESSON G1 — Install Git and configure identity

CONCEPT: Git needs to know who you are so every commit has an author.

BUILD:
1. Download Git from https://git-scm.com and install (accept all defaults).
2. Open a terminal (VS Code terminal is fine) and run:
   ```
   git config --global user.name "Rajesh Pyla"
   git config --global user.email "your-email@example.com"
   ```
3. Verify: `git config --global --list` shows your name and email.

GATE: `git --version` prints a version number, and your name/email are configured.

---

## LESSON G2 — Initialize a repo and make your first commit

CONCEPT: `git init` turns a folder into a Git repository. `git add` stages files
(marks them as ready to save). `git commit` saves a snapshot with a message.

WHY: your Flutter project folder needs to be a Git repo before any code is written.

BUILD:
1. Open your `smartveg` Flutter project folder in VS Code.
2. In the terminal:
   ```
   git init
   ```
   This creates a hidden `.git` folder — your project is now tracked.
3. Flutter already created a `.gitignore` file (tells Git which files to skip —
   build artifacts, platform binaries, etc.). Verify it exists.
4. Stage everything:
   ```
   git add .
   ```
5. Commit:
   ```
   git commit -m "Initial commit: Flutter project created"
   ```

EXPLAIN BACK: what does `git init` do? what is the difference between `add` and `commit`?

GATE: `git log` shows one commit with your message.

---

## LESSON G3 — The daily workflow: status, add, commit

CONCEPT: the three commands you will use every single day.

- `git status` — shows what changed since the last commit.
- `git add .` — stages all changes (or `git add filename` for specific files).
- `git commit -m "description"` — saves the snapshot.

WHY: after every lesson gate, you will commit. This creates a history of your progress
that is also valuable for your project report.

BUILD:
1. Make a small change — edit `lib/main.dart`, change the app title to "SmartVeg".
2. Run `git status` — it shows `main.dart` as modified.
3. `git add .`
4. `git commit -m "Change app title to SmartVeg"`
5. Run `git log` — now shows two commits.

PREDICT: if you run `git status` right after a commit, what does it say? (Answer:
"nothing to commit, working tree clean" — because everything is saved.)

GATE: you have at least 2 commits and can explain what status/add/commit each do.

---

## LESSON G4 — Create a GitHub repository and push

CONCEPT: GitHub is a website that stores a copy of your Git repo in the cloud.
`git push` uploads your local commits to GitHub. This is your backup.

BUILD:
1. Go to https://github.com and create a free account (if you don't have one).
2. Click "New repository", name it `smartveg`, set it to Private (your code, your
   choice — you can make it public later for your portfolio if you want).
3. GitHub shows setup commands. Since your repo already exists locally, use:
   ```
   git remote add origin https://github.com/YOUR-USERNAME/smartveg.git
   git branch -M main
   git push -u origin main
   ```
4. Refresh the GitHub page — your code is now visible online.

EXPLAIN BACK: what is `origin`? what does `push` do? why is this better than just
having the code on your laptop?

GATE: your code is visible on GitHub. `git remote -v` shows the GitHub URL.

---

## LESSON G5 — Good commit messages (a habit, not a rule)

CONCEPT: a good commit message says WHAT you did, not HOW. Future-you (and your viva
panel looking at your commit history) should understand each line.

GOOD messages:
- "Add splash screen with BLE scanning"
- "Implement stability gate on tile grid"
- "Fix discount cap calculation"
- "Add SQLite database with 4 tables"

BAD messages:
- "update" (what did you update?)
- "stuff" (what stuff?)
- "fix" (fix what?)
- "asdfgh" (why?)

BUILD: look at your existing commits. Would a stranger understand them?

GATE: you can explain why "Add weight display to billing screen" is better than "update".

---

## LESSON G6 — Branching (optional but useful)

CONCEPT: a branch is a parallel copy of your code where you can experiment without
affecting the main version. If the experiment works, you merge it back. If it fails,
you delete the branch — main is untouched.

WHY: when you start a new feature (like the discount system), you can work on a
branch. If you break something, main still has the last working version.

BUILD:
1. Create a branch: `git checkout -b feature/discount-system`
2. Make some changes, commit them.
3. Switch back to main: `git checkout main` — your changes disappear (they're
   on the branch, not here).
4. Switch back: `git checkout feature/discount-system` — changes are back.
5. When the feature works, merge: `git checkout main` then `git merge feature/discount-system`
6. Push: `git push`

PREDICT: what happens to your main branch while you're working on the feature branch?
(Answer: nothing — it stays exactly as it was.)

GATE: you have created, switched, and merged a branch.

---

## AFTER G6 — Git becomes a habit, not a course

From this point, every lesson in the Flutter course ends with:
> "Commit: `git add . && git commit -m 'description'` then `git push`"

Git is no longer a separate thing to learn — it's just part of how you work.

---

## THE COMMANDS YOU ACTUALLY NEED (reference card)

| Command | What it does | When |
|---|---|---|
| `git init` | Create a repo | Once at the start |
| `git status` | See what changed | Anytime |
| `git add .` | Stage all changes | Before every commit |
| `git commit -m "msg"` | Save a snapshot | After every meaningful piece of work |
| `git push` | Upload to GitHub | After each session or milestone |
| `git log --oneline` | See commit history | To check your progress |
| `git checkout -b name` | Create a branch | Before starting a new feature |
| `git checkout main` | Switch to main | To go back to the stable version |
| `git merge name` | Merge a branch | When the feature works |
| `git diff` | See exact line changes | Before committing, to review |

Everything else is rare. These 10 cover 99% of solo work.
