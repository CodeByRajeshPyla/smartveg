# 05 — BEYOND SMARTVEG: the job-ready roadmap

Added 2026-10-31. Goal: an **independent, job-ready Flutter developer in the AI era** —
able to build an app from scratch, understand an unfamiliar codebase, debug complex
errors, catch wrong AI-generated code, and explain decisions in interviews.

SmartVeg (`03_FLUTTER_COURSE.md`) comes first and is finished properly. This file is
what follows. Every module uses the teaching rules in `README.md`.

---

## What SmartVeg already teaches (so it is not repeated)

| Skill | Where in SmartVeg |
|---|---|
| Git and GitHub | G0–G5 |
| Widgets, layout, the widget tree | F1.1–F1.2 |
| State, setState, lifecycle | F1.3–F1.4 |
| async / await / Future | F2.2 |
| Streams | F2.3 |
| Hardware over BLE (read + write) | F2.2–F2.4, F2.8 |
| Custom widgets with inputs | F2.4 |
| Lists, grids, filtering | F2.5–F2.6 |
| Conditional UI, disabled states | F2.7 |
| Navigation | F3.1 |
| Local database (SQLite), transactions | F4.1–F4.4 |
| Global state across screens | F6 |

---

## Every module follows the practice ladder

1. **Problem** — what it solves, why real apps need it
2. **My approach** — I say how I would do it before seeing code
3. **Hints**, then I **attempt** it
4. **Review** of my code -> corrections explained
5. **Questions** to test understanding
6. **Harder challenge**
7. Regularly: a **broken-code drill** (diagnose and repair) and a **no-AI task**

---

## The modules

### B1 — Dart, properly
Fill the gaps found in the assessment: classes and constructors, null safety in depth,
collections (`map`, `where`, `fold`), enums, `async` error handling (`try/catch`),
extension methods, records and pattern matching (Dart 3).
**Project:** a command-line bill calculator in pure Dart (no Flutter).

### B2 — State management beyond setState
Why `setState` stops scaling (SmartVeg's multi-bill is the first sign). `InheritedWidget`
-> **Provider** -> **Riverpod**. Lifting state up; one source of truth.
**Project:** move SmartVeg's bills into a Provider/Riverpod model.

### B3 — App architecture
Folder structure, separating UI / logic / data, the **repository pattern**, dependency
injection, why `print` is not logging.
**Project:** refactor SmartVeg into layers — the BLE code behind a `ScaleRepository`.

### B4 — REST APIs and JSON
HTTP, status codes, the `http`/`dio` packages, JSON parsing into model classes,
loading / error / empty states, timeouts and retries.
**Project:** an app that fetches data from a public API (e.g. market prices or weather)
with proper error handling.

### B5 — Firebase and authentication
Firebase Auth (email/phone sign-in), Firestore, security rules, offline sync.
Uses `04_FIREBASE_COURSE.md`.
**Project:** cloud backup of SmartVeg's daily sales.

### B6 — Testing
Unit tests (bill maths, paise rounding), widget tests, mocking the scale so tests run
without hardware, what to test and what not to.
**Project:** a test suite for SmartVeg's billing logic.

### B7 — Debugging and performance
Flutter DevTools, the widget inspector, reading stack traces fast, rebuild counts,
`const`, list performance, memory leaks (uncancelled streams and timers).
**Drills:** broken-code challenges.

### B8 — Reading an unfamiliar codebase
Clone an open-source Flutter app, find the entry point, trace one feature end to end,
draw its data flow, fix a small issue in it.

### B9 — Deployment
Release builds, app signing, app name and icon, versioning, Play Store internal testing,
crash reporting.
**Project:** SmartVeg as a signed release APK.

### B10 — Interview readiness
Explain SmartVeg's architecture and every decision (why BLE not Wi-Fi, why SQLite not
Firebase, why paise as int, why the stability gate). Review AI-generated code and find
its bugs. Mock technical interviews.

---

## Tracking

Course % (reported in chat) covers the 44 SmartVeg lessons. When SmartVeg is complete,
progress is tracked per module (B1–B10) in the same way.
