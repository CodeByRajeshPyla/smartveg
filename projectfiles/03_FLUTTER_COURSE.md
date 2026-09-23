# 03 — FLUTTER COURSE (screen by screen)

**The rule:** every Flutter concept is introduced by the screen that forces you to learn
it. Nothing abstract. Each lesson ends with a working piece of the real app.

**Lesson shape:** Concept → Why this screen needs it → Predict → Build (I type it) →
Run → Explain back → Gate → **Commit.**

I know Dart. Flutter is new. Skip language basics; teach Flutter.

---

## CONCEPT-TO-SCREEN MAP

| Screen | Concepts it forces you to learn |
|---|---|
| (setup) | Project creation, running on real phone |
| 01 Splash | Widgets, Scaffold, Column, StatefulWidget, setState, Timer |
| 04 Weigh & Select | Packages, permissions, async/await, **Streams**, BLE connect, derived values, bottom nav |
| 04b Settling | Conditional styling, disabled states |
| 05 Piece Qty | BottomSheet, stepper pattern |
| 06 Cart | ListView, **remove from list + setState**, discount logic, inline expansion |
| 07 Paid | Navigation pop, **two-way BLE write** (tare command), PDF generation |
| 02 Home | Dashboard layout, query aggregation, pulling data from SQLite |
| 03 Quick Prices | Forms, bulk editing, **SQLite batch update** |
| 08 Stock | Progress indicators, conditional chips, **FutureBuilder** |
| 09 Add Product | TextFormField, validation, image picker, **SQLite insert** |
| 10-11 Restock/DayClose | Gated navigation, **atomic transaction** |
| Multi-bill | Global state (list of bills), bill switcher, tare-on-switch |

**Why this order?** We build the core billing loop first (the thing the vendor uses
200 times/day), then the dashboard and admin screens. SQLite enters when the billing
loop needs to persist data. Multi-bill comes after single-bill works.

---

## STAGE 0 — SETUP

### S0.1 — Flutter doctor
Run `flutter doctor` in the terminal. Fix anything red.
GATE: mostly green (missing Chrome/emulator is fine — we use the real phone).

### S0.2 — Real phone connected
Enable USB debugging on your Android phone. Plug it in.
Run `flutter devices` — your phone must appear.
*We test on the REAL phone because the emulator cannot do Bluetooth.*
GATE: phone appears in the device list.

### S0.3 — Create the project and run
```
flutter create smartveg
cd smartveg
flutter run
```
You should see the default counter app on your phone.
GATE: default app runs on your phone.
**COMMIT: `git init && git add . && git commit -m "Initial commit: Flutter project"`**

---

## STAGE 1 — SCREEN 01 (SPLASH): Flutter fundamentals

### F1.1 — Widgets and the tree
CONCEPT: everything on screen is a widget. Widgets nest into a tree. A screen is just a
big tree of small widgets.
WHY: the splash screen is a Column holding an icon, two Texts, and a progress box.
BUILD: replace the default `main.dart` with a bare screen showing the app name as one
Text widget wrapped in a MaterialApp.
EXPLAIN BACK: what is a widget? what is the widget tree?

### F1.2 — Scaffold and Column
CONCEPT: Scaffold gives you a standard screen skeleton (AppBar + body). Column stacks
children vertically. Center positions them.
BUILD: Scaffold with no AppBar, a centered Column holding:
- A green Container with "kg" text (the logo)
- Text "SmartVeg"
- Text "IoT weighing & billing"
GATE: the splash layout is visible on your phone.
**COMMIT: "Add splash screen layout"**

### F1.3 — Stateless vs Stateful
CONCEPT: StatelessWidget never changes after drawing. StatefulWidget CAN change
(a countdown, a live weight, a loading bar).
PREDICT: your splash shows a warm-up progress bar — stateless or stateful? Why?
BUILD: convert the splash to a StatefulWidget.
EXPLAIN BACK: when do you need Stateful?

### F1.4 — setState and Timer
CONCEPT: `setState(() { ... })` tells Flutter "data changed, redraw." Without it, the
variable changes but the screen stays frozen. `Timer.periodic` runs code repeatedly.
WHY: the splash shows a scanning progress bar that fills up.
BUILD: a Timer that ticks each second, fills the progress bar, and shows the BLE
scanning state. When scanning "completes" (simulated for now), navigate to the next
screen.
**BREAK IT:** remove setState → the timer runs but the bar doesn't move. Now you
understand setState.
EXPLAIN BACK: what does setState actually do? what breaks without it?
GATE: splash shows a filling progress bar, then navigates forward.
**COMMIT: "Add BLE scanning animation to splash"**

---

## STAGE 2 — SCREEN 04 (WEIGH & SELECT): BLE and live data

This is the most important screen. Take your time here.

### F2.1 — Packages and permissions
CONCEPT: `pubspec.yaml` adds libraries. Android needs explicit BLE permissions.
BUILD: add `flutter_blue_plus` to pubspec.yaml. Add these to AndroidManifest.xml:
`BLUETOOTH_SCAN`, `BLUETOOTH_CONNECT`, `ACCESS_FINE_LOCATION`.
Run `flutter pub get`.
EXPLAIN BACK: why does Android need location permission for BLE scanning?

### F2.2 — async / await / Future
CONCEPT: a Future is a value that arrives later. `await` pauses your function (not the
whole app) until it arrives.
PREDICT: why can't you write `device = scan()` and use `device` on the next line
without await?
BUILD: write the async scan-and-connect function that finds "ESP32-Scale" and connects.
GATE: the app connects to your ESP32 (Serial Monitor shows ">>> Phone connected").
**COMMIT: "BLE scan and connect to ESP32-Scale"**

### F2.3 — Streams (THE HEART OF THIS APP)
CONCEPT: a Future is ONE value. A Stream is MANY values arriving continuously. You
`listen()` and react to each value with setState.
WHY: your ESP32 sends `"grams,stableflag"` several times per second. That is a Stream.
BUILD: subscribe to the BLE characteristic's lastValueStream. Parse the string:
```dart
characteristic.lastValueStream.listen((bytes) {
  final text = String.fromCharCodes(bytes);   // "1486.0,1"
  final parts = text.split(',');
  setState(() {
    weightGrams = double.parse(parts[0]);
    isStable = parts[1] == '1';
  });
});
```
SEE: **press the load cell → your own app shows the weight change live.** 🎉
EXPLAIN BACK: Future vs Stream — in your own words.
GATE: live weight updating on your app from the real scale.
**COMMIT: "Live weight display from BLE stream"**

### F2.4 — The weight bar UI
BUILD: the green weight bar at the top of Screen 04. Large monospaced digits showing
the weight, a STABLE/settling badge (conditional color), and a Zero/Tare button.
GATE: weight bar looks like the wireframe, updates live.
**COMMIT: "Weight bar with stable/settling badge"**

### F2.5 — The tile grid (GridView)
CONCEPT: GridView.builder lays items out in a grid, rendering only what's visible.
WHY: the vegetable tiles.
BUILD: a hardcoded list of products (name, price, unit_type, category), rendered as a
3-column grid with colored tiles. Piece/bunch items get dashed borders.
GATE: tile grid is visible and scrollable.
**COMMIT: "Vegetable tile grid"**

### F2.6 — Category chips (filter)
BUILD: the chip bar (Top/Regular/Piece-Bunch/Slow/All). Tapping a chip filters the
grid. "Top (80%)" shows only products with category='top'.
GATE: chips filter the grid correctly.
**COMMIT: "Category filter chips"**

### F2.7 — Stability gate (tiles disabled when settling)
CONCEPT: conditional widget properties — color, opacity, and `onTap` driven by state.
WHY: **this is Screen 04b.** Tiles must be visibly disabled and untappable while the
weight is settling. When stable, they light up.
BUILD: when `isStable == false`, tiles render greyed out with no onTap handler. When
`isStable == true`, tiles render with their normal colors and onTap adds to bill.
GATE: put weight on scale → tiles grey → weight settles → tiles light up.
**COMMIT: "Stability gate: tiles disabled while settling"**

### F2.8 — Tap tile to add to bill + auto-tare
CONCEPT: maintaining a list in state. Sending a BLE write command.
WHY: tapping a tile captures the current weight, calculates the price, adds it to the
bill's item list, and sends a tare command to the ESP32 so the scale zeroes.
BUILD:
1. A global `List<BillItem>` for the current bill.
2. On tile tap: create a BillItem (product, weight, price=weight×rate), add to list.
3. Send tare command: write to the BLE characteristic.
4. setState to update the current-items summary bar.
PREDICT: what should the app do if someone taps a tile when weight is below 10g?
(Answer: ignore the tap — the safety rule.)
GATE: tap a tile → item appears in the current items bar → scale zeroes.
**COMMIT: "Add to bill with auto-tare"**

### F2.9 — Piece/bunch items (bottom sheet)
CONCEPT: `showModalBottomSheet` — a panel that slides up from the bottom.
WHY: piece items (lemon, coconut) skip the scale and use a quantity stepper instead.
BUILD: when a piece/bunch tile is tapped, open a bottom sheet with a stepper
(−, number, +), quick-pick chips (6/12/25), price calculation, and "Add to bill."
GATE: tapping Lemon tile opens the bottom sheet, adding 6 lemons adds to the bill.
**COMMIT: "Piece quantity bottom sheet"**

### F2.10 — Current items bar + bottom dock
BUILD: the collapsible "Current Items · 3 · Tap to view" bar and the bottom dock
showing BILL TOTAL, Hold button, and Pay/Bill button.
GATE: items bar shows count and total, expands on tap to show the full list with ×
remove buttons.
**COMMIT: "Current items bar and bottom dock"**

### F2.11 — Bottom navigation
CONCEPT: BottomNavigationBar switches which screen body is shown, holding an index.
BUILD: 4 tabs — Home, Bill, Stock, Prices — with placeholder bodies for the non-Bill
tabs. Bill tab shows the Weigh & Select screen.
GATE: tabs switch correctly, Bill tab shows the working billing screen.
**COMMIT: "Bottom navigation with 4 tabs"**

---

## STAGE 3 — SCREENS 06-07 (CART & PAID): completing the billing loop

### F3.1 — Navigation push/pop
CONCEPT: `Navigator.push` opens a new screen on top. `Navigator.pop` goes back.
BUILD: tapping "Pay/Bill →" pushes the Cart screen. A back arrow pops it.

### F3.2 — Cart screen (ListView of items)
BUILD: Screen 06a — list of bill items with name, weight/qty, price, and × delete icon.
Subtotal calculated. Discount chips (-Rs 5, -Rs 10, Set total, Clear).
GATE: cart shows all items correctly.

### F3.3 — Remove item from bill
BUILD: tapping × removes that item from the list, recalculates the total.
Rule: only allowed before payment.
GATE: removing an item updates the total instantly.

### F3.4 — Free items (long-press)
BUILD: long-pressing a cart line marks it as FREE. Price becomes 0, but the item stays
in the list (stock will still deduct on checkout).
GATE: long-press → item shows FREE tag → total drops.

### F3.5 — Set Total inline expansion
BUILD: Screen 06b — tapping "Set total" expands the discount block inline to show:
input field ("Customer will pay Rs __"), quick-pick chips (Rs 95/90/85), derived
discount with percentage, cap check. "Apply" confirms, "Cancel" collapses.
Round-off locks to ₹0 when Set Total is active — the wireframe shows +₹0.13 here, which
is a drawing error; see the round-off warning in `01_PROJECT_CONTEXT.md`.
GATE: entering Rs 90 on a Rs 96.87 subtotal shows "Discount = -Rs 6.87 (7%)".
**COMMIT: "Cart with discounts, free items, and Set Total"**

### F3.6 — Mark paid and the Paid screen
BUILD: tapping "Mark paid" saves the bill (to a global list for now — SQLite comes
later), sends a tare command (for the next customer), and pushes Screen 07 (Paid).
Paid screen shows the amount, bill number, and NEXT CUSTOMER button. Share bill
and Print (stubbed) buttons. Tapping NEXT CUSTOMER pops back to the billing screen
with a fresh bill.
GATE: full billing loop works — weigh → select → cart → pay → next customer.
**COMMIT: "Paid screen and complete billing loop"**

---

## STAGE 4 — SQLITE (making data survive restarts)

### F4.1 — sqflite setup
CONCEPT: `sqflite` is Flutter's local database package. `path` helps find the database
file location.
BUILD: add `sqflite` and `path` to pubspec.yaml. Create a `database_helper.dart` file
with an `initDb()` function that creates the 4 tables from the schema in
`01_PROJECT_CONTEXT.md`.
GATE: app starts without errors, database file is created.
**COMMIT: "SQLite database with 4 tables"**

### F4.2 — Seed products
BUILD: on first run, insert a starter set of products (Tomato, Potato, Onion, Lemon,
Palak, Beans, etc.) with prices, unit_types, and categories.
GATE: products load from the database into the tile grid.
**COMMIT: "Seed products from SQLite"**

### F4.3 — The atomic checkout transaction
CONCEPT: a database transaction groups multiple operations into one all-or-nothing unit.
WHY: "Mark paid" must save the bill, save each item, AND reduce stock. If any step
fails, ALL must undo — otherwise stock deducts for an unsaved bill.
BUILD:
```dart
await db.transaction((txn) async {
  int billId = await txn.insert('bills', { ... });
  for (var item in cart) {
    await txn.insert('bill_items', { ... });
    await txn.rawUpdate(
      'UPDATE products SET stock_qty = stock_qty - ? WHERE id = ?',
      [item.quantity, item.productId]);
  }
});
```
PREDICT: what happens if the phone crashes between inserting bill_items and updating
stock? (Answer: with a transaction, both are undone. Without, stock is wrong.)
GATE: pay a bill → restart the app → the bill is saved, stock is reduced.
**COMMIT: "Atomic checkout transaction"**

### F4.4 — FutureBuilder (loading data)
CONCEPT: FutureBuilder handles loading/data/error states for async database queries.
BUILD: the tile grid now loads products via FutureBuilder instead of a hardcoded list.
Shows a loading spinner while the query runs.
GATE: tile grid loads from the database.
**COMMIT: "Load products with FutureBuilder"**

### F4.5 — Bill formatting function
BUILD: `generateReceiptText(billId)` — queries the bill and its items from SQLite,
formats them as a readable receipt (shop name, items, totals). Used by both PDF export
and future thermal printing.
GATE: calling the function returns a properly formatted receipt string.
**COMMIT: "Bill formatting function (generateReceiptText)"**

### F4.6 — PDF export and share
CONCEPT: `pdf` package generates PDFs. `share_plus` or `printing` opens the Android
share sheet.
BUILD: the "Share bill" button on the Paid screen generates a PDF using
`generateReceiptText`, then opens the share sheet (WhatsApp, email, etc.).
GATE: a real PDF bill is shared via WhatsApp.
**COMMIT: "PDF bill generation and WhatsApp share"**

---

## STAGE 5 — REMAINING SCREENS (applying what you already know)

No new Flutter concepts from here — just applying everything above to new screens.

### F5.1 — Home dashboard (Screen 02)
BUILD: Today's sales (SUM of paid bills today), week's sales, discount total,
low-stock products, most-sold top 3. All queried from SQLite.
**COMMIT: "Home dashboard with live stats"**

### F5.2 — Quick Prices (Screen 03)
BUILD: list of all products with ± steppers. Changed items highlighted. "Save all"
does a batch SQLite update.
**COMMIT: "Quick Prices screen"**

### F5.3 — Stock (Screen 08)
BUILD: product list with progress bars, Low/Out chips, weekly wastage card.
Tap a row → navigate to Restock.
**COMMIT: "Stock screen"**

### F5.4 — Add/Edit Product (Screen 09)
BUILD: TextFormField for name, unit_type chips, **category chips (Top/Regular/Slow)**,
price, stock, low alert, optional photo (image_picker package). Save → SQLite insert.
**COMMIT: "Add/Edit product screen"**

### F5.5 — Restock and Day Close (Screens 10-11)
BUILD: restock checks `last_closed_date` — if yesterday isn't closed, show the gate
(Screen 10). Day Close (Screen 11) reads from the scale via BLE, computes spoilage,
and uses a transaction to update stock.
**COMMIT: "Restock with day-close gate and spoilage tracking"**

---

## STAGE 6 — MULTI-BILL SWITCHER (the field-research feature)

### F6.1 — Multiple open bills
CONCEPT: instead of one global cart list, maintain a list of Bill objects, each with
its own items list. A `currentBillId` tracks which is active.
BUILD: the bill switcher strip (horizontal scroll of cards). Tapping a card sets
currentBillId. "+" creates a new bill. setState redraws to show the active bill's items.
PREDICT: if Bill 2 is active and you tap a tile, which bill gets the item?
**COMMIT: "Multi-bill switcher"**

### F6.2 — Hold and tare-on-switch
BUILD: "Hold" button bags the current bill's items (a visual confirmation) and resets.
Every bill switch triggers a BLE tare write.
GATE: two bills open, switch between them, each has correct independent items/totals,
tare fires on every switch.
**COMMIT: "Hold button and tare-on-bill-switch"**

### F6.3 — Open bills survive restart
BUILD: open bills (status='open') are queried from SQLite on app start and populated
into the bill switcher.
GATE: open a bill, add items, restart the app — the bill is still there.
**COMMIT: "Persist open bills across restarts"**

---

## FINAL GATE — THE COMPLETE APP
- Splash → connects to scale.
- Home shows live stats.
- NEW BILL → weigh & select → tiles disabled while settling, enabled when stable.
- Tap tile → item added, auto-tare fires, next item ready.
- Piece items → bottom sheet with stepper.
- Cart → discount (flat or Set Total), free items, remove items.
- Mark paid → atomic transaction → stock deducts → Paid screen.
- PDF shared via WhatsApp.
- Stock screen → restock blocked by day-close gate → spoilage derived.
- Multi-bill: two customers interleaved, switching works, tare fires.
- Everything saved in SQLite, survives restart.
- Full Git history on GitHub showing incremental progress.

---

## PROGRESS TRACKER
```
Stage 0  [ ][ ][ ]           Setup + first commit
Stage 1  [ ][ ][ ][ ]        Splash (Flutter fundamentals)
Stage 2  [ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]  Weigh & Select (BLE + core billing)
Stage 3  [ ][ ][ ][ ][ ][ ]  Cart & Paid (complete billing loop)
Stage 4  [ ][ ][ ][ ][ ][ ]  SQLite (data persists)
Stage 5  [ ][ ][ ][ ][ ]     Remaining screens
Stage 6  [ ][ ][ ]           Multi-bill switcher
```
