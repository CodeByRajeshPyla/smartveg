# G0 — What Git Is

Read before G1. Not a command lesson — the idea the rest of the course sits on.

---

## 1. The problem it exists to solve

Three weeks from now the Weigh & Select screen works. You start the multi-bill
switcher and the app stops building. You cannot remember which of the 40 things you
changed broke it.

What students do instead of using Git:

```
vegbill/
vegbill - copy/
vegbill - copy (2)/
vegbill FINAL/
vegbill FINAL working/
vegbill FINAL working USE THIS ONE/
```

It fails because after a week nobody — including you — knows what is inside each
folder, or which one actually works.

---

## 2. What Git is

> **Git is a program that takes snapshots of a folder and remembers every one of
> them, forever, along with who took it, when, and why.**

That is the whole idea. Everything else is detail.

One snapshot = one **commit**. Each commit stores:

| Part | What it is |
|---|---|
| **who** | your name and email (set in G1) |
| **when** | exact timestamp |
| **why** | a message you write, e.g. `"Add BLE connection to ESP32-Scale"` |
| **what changed** | the exact lines that differ from the previous snapshot |

You can return to any commit at any time — **exactly**, byte for byte, not roughly.

So six folders become one folder plus a readable list:

```
Add cart discount chips
Add tile grid with category chips
Connect to ESP32-Scale over BLE
Create products table in SQLite
Initial commit: Flutter project created
```

That list **is** the project's history. When the app breaks, find the last snapshot
where it worked and go there.

---

## 3. Where Git keeps it

In one hidden folder, **`.git`**, inside the project folder. That is the entire
database.

- Delete `.git` -> history gone, current files untouched.
- Copy the project to a pen drive -> `.git` comes along, full history included.

---

## 4. Why THIS project needs it

1. **The viva.** `git log` prints the history with dates — evidence you built SmartVeg
   over weeks, in steps, yourself. A folder of finished code proves nothing about who
   wrote it.
2. **The atomic checkout transaction.** `01_PROJECT_CONTEXT.md` calls it the most
   important code in the project. You will break it while getting it right. Git is the
   undo button.
3. **Teammates.** Git + GitHub (G4) is how code is shared without emailing zip files.

---

## 5. Git is NOT GitHub

| | What it is |
|---|---|
| **Git** | the program on your laptop that takes snapshots. Works fully offline. |
| **GitHub** | a website that stores a copy of your snapshots online, so they survive the laptop dying and teammates can read them. |

Git can be used forever without GitHub. Order in this course: Git first (G1-G3),
GitHub after (G4).

---

## 6. The two predictions (answers)

**Q: `.git` holds every snapshot, but the project folder only shows current files.
Where does the OLD version of a file live after you change it and commit again?**
Inside `.git`. The project folder only ever shows the current state; every previous
version sits in the `.git` database. That is why `.git` grows while the folder stays
uncluttered.

**Q: Flutter regenerates `build/` on every compile. Should Git snapshot it?**
No. It is generated output — rebuilt from your source every time. Committing it adds
hundreds of MB carrying zero information. Flutter already created a `.gitignore`
listing exactly these files. (See G2, section 3.)

---

## 7. Viva answers

**Q: What is Git?**
A program that stores snapshots of a project, each signed with an author, timestamp and
message, so any previous state can be restored exactly.

**Q: Git vs GitHub?**
Git is the local version-control program and works offline. GitHub is a hosting website
storing a copy of the repository online for backup and collaboration.

**Q: Where is the history kept?**
In the hidden `.git` folder inside the project.

---

## NEXT — G1
Setting your name and email: the **who** stamp that goes on every snapshot.
