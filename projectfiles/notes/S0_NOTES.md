# S0 — Setup (Flutter Stage 0)

Course: 03_FLUTTER_COURSE.md · **STATUS: ALL GATES PASSED**
Device: `I2208 (mobile) • 10BCAA14NN000CW • android-arm64 • Android 14 (API 34)`

Goal of this stage: prove the machine can build the app and put it on the phone.
No code written.

---

## S0.1 — `flutter doctor`

```
flutter doctor        # check the toolchain
flutter doctor -v     # same, with full detail
flutter devices       # list what you can run on
```

- It checks **every platform Flutter can target**, so it will always complain about
  something. **Only your target's rows matter.**
- `[X] Visual Studio` = needed for **Windows desktop** builds only -> irrelevant to an
  Android app. Ignore it.
- Must be green for this project: **Flutter**, **Android toolchain**,
  **Connected device**.
- Result here: Flutter 3.38.7 (stable), Android SDK 36.1.0.

> Habit: run `flutter doctor` first whenever anything behaves strangely. It is also the
> first thing anyone will ask you to paste when you ask for help.

---

## S0.2 — Real phone

### Why a real phone is non-negotiable
An emulator is software pretending to be a phone — **there is no Bluetooth radio behind
it.** This entire project is the app receiving `"grams,stableflag"` (e.g. `"1486.0,1"`)
from the ESP32 over BLE. On an emulator that can never happen.

Physical device, over USB, for the whole project.

### Enabling it
1. Settings -> About phone -> **Build number**, tap **7 times** -> "You are now a
   developer". (Xiaomi: About phone -> MIUI version. Samsung: Software information.)
2. Developer options -> **USB debugging** ON.
   (Xiaomi/Redmi: Settings -> Additional settings -> Developer options, and also enable
   **Install via USB** — Xiaomi blocks installs without it.)
3. Plug in -> phone shows **"Allow USB debugging?"** with the computer's fingerprint ->
   tick **Always allow from this computer** -> **Allow**.
4. Use a **data cable**, not charge-only. A charge-only cable **fails silently**: the
   phone charges and no device ever appears.

### Gate
```
flutter devices
```
The phone appears with its model name:
```
I2208 (mobile) • 10BCAA14NN000CW • android-arm64 • Android 14 (API 34)
```
- **`android-arm64`** = the phone's CPU architecture. Flutter compiles Dart to **native
  ARM machine code** for it — not a web page, not an interpreter. A real Android app.
- The long string is the device serial.

---

## S0.3 — Run the app

The course says `flutter create smartveg`, but **the project already exists** —
`D:\vegbill` with `lib/main.dart`. So S0.3 is only:

```
flutter run
```

Result: Flutter's **default counter app** on the phone — a `+` button and a number that
increases when tapped.

**Why this matters before writing any SmartVeg code:** it proves the entire chain works
— code -> compile -> install -> run on real hardware. If something is broken in the
toolchain, find out now, not while debugging BLE.

That counter app is Stage 1's concepts in miniature: Scaffold, Column, StatefulWidget,
setState. Stage 1 rebuilds that logic as the Splash screen.

---

## HOT RELOAD — the thing to remember from this stage

While `flutter run` is active, the terminal watches for file changes:

| Key | Name | Effect |
|---|---|---|
| **`r`** | **hot reload** | code changes appear on the phone in under a second, **keeping current state** (the counter keeps its number) |
| **`R`** | **hot restart** | rebuilds the app from scratch; **state is lost** (counter resets to 0) |
| **`q`** | quit | stops the run |

**The development loop for every screen in this project:**
```
edit -> save -> press r -> look at the phone
```
No reinstalling, no waiting. This is Flutter's single biggest practical advantage.

Use **`R`** when hot reload is not enough — changed `main()`, added a package, or
changed something that only runs at startup.

---

## GATES — ALL PASSED
- S0.1: `flutter doctor` mostly green (Visual Studio X is fine).
- S0.2: phone appears in `flutter devices`.
- S0.3: default counter app runs on the phone.

---

## Viva answers

**Q: Why test on a real phone instead of an emulator?**
The emulator has no Bluetooth hardware, and the project depends on receiving weight data
from the ESP32 over BLE.

**Q: What is hot reload?**
Flutter injects changed code into the running app in under a second while preserving its
current state, so the UI can be developed without reinstalling the app.

**Q: Hot reload vs hot restart?**
Hot reload keeps the app's state; hot restart rebuilds from scratch and resets it.
Restart is needed for changes to `main()`, new packages, or startup-time code.

**Q: What does `flutter doctor` do?**
Inspects the whole toolchain — SDK, Android tools, connected devices — and reports what
is missing or broken for every platform Flutter can target.

---

## NEXT — STAGE 1, Screen 01 (Splash)
F1.1 widgets and the tree · F1.2 Scaffold and Column · F1.3 stateless vs stateful ·
F1.4 setState and Timer.
