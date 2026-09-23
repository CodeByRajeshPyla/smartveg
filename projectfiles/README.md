# README — START HERE

This folder holds the full plan for my final-year B.Tech ECE project:
**Smart Vegetable Weighing & Billing System** (SmartVeg).

If you are Claude Code, read these files in this order before doing anything:

1. **`01_PROJECT_CONTEXT.md`** — what the project is, hardware details, all design
   decisions, the screens, the database, and known limitations.
2. **`02_GIT_GITHUB.md`** — Git fundamentals and GitHub setup (learn first, before
   any Flutter code).
3. **`03_FLUTTER_COURSE.md`** — the Flutter app, taught screen by screen.
4. **`04_FIREBASE_COURSE.md`** — optional cloud layer (Auth + Firestore backup),
   attempted only after the core app works.

Two more files are reference, not reading order — open them when a lesson calls for them:

- **`screens/`** — the 13 approved wireframe PNGs, one per screen, plus
  `SCREENS_INDEX.md` mapping each PNG to the lesson that builds it. **Open the matching
  PNG before building any screen.** The index also lists three known errors in the
  wireframes where the written spec overrules the picture.
- **`DESIGN.md`** — the design system: colour tokens and their roles, the Inter /
  JetBrains Mono split, tap-target sizes, radii and spacing.

`smartveg_course.zip` is the original bundle these files were extracted from. Everything
in it is already unpacked here; keep the zip as a backup, don't work from it.

---

## HOW TO TEACH ME (read this every session, never skip)

I am a B.Tech ECE final-year student. I am building this alone and I must be able to
explain **every single line** in my viva. My teammates also need to understand the whole
project. So:

1. **One lesson at a time.** Never skip ahead. Never jump to a later module.
2. **Every lesson follows this shape:**
   - Explain the ONE concept, simply.
   - Say WHY this project needs it right now.
   - Ask me to PREDICT something before showing me code.
   - Give code in **small pieces** that I type myself. Never dump a whole file.
   - After it runs, ask me to EXPLAIN IT BACK in my own words.
3. **Do not advance until I say "I understand" or "next".**
4. If I am stuck, give a **hint**, not the answer.
5. When I hit an error, explain what the error **means** before fixing it.
6. If I paste code and cannot explain it, we slow down and go back.
7. **Commit after every milestone.** Remind me to `git add` and `git commit` after
   each lesson gate passes.

## WHAT I ALREADY KNOW
- **Dart basics** — variables, functions, classes, collections, null safety. Skip
  language fundamentals; teach Flutter.
- **ESP32 + Arduino IDE** — fully working. Load cell + HX711 calibrated (factor
  101.16, ±3g accuracy), stability detection, tare, 16x2 LCD, BLE broadcasting as
  "ESP32-Scale" (verified with nRF Connect). The hardware is DONE.
- **Git** — brand new, never used it. Start from scratch.
- **Flutter** — brand new. I know Dart but have never built a Flutter app.
- **Firebase** — brand new.

## ABOUT THIS ACCOUNT
This Claude account is shared between two people. This project belongs to
**Rajesh Pyla** (B.Tech ECE student). Messages about this project are his. Do not
confuse with the other user's work.

## HOW TO START A SESSION
I will say something like: *"Start lesson G1"* or *"Continue from F2.3"*.
You read the relevant file, teach that one lesson, and stop at its gate.
After the gate passes, remind me to commit.
