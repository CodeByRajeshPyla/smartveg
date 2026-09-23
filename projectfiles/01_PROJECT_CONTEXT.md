# 01 — PROJECT CONTEXT

## WHAT THIS PROJECT IS

**SmartVeg** — an IoT smart scale + billing app for small vegetable shops.

A load cell senses the weight of vegetables → the HX711 chip amplifies the signal →
the ESP32 reads it and sends it over Bluetooth → a Flutter phone app receives it,
calculates the price, makes the bill, and saves everything to a local SQLite database.
The whole system works offline.

### The one-sentence summary (memorize for the viva)
> A load cell senses weight, the HX711 amplifies it, the ESP32 sends it over Bluetooth
> to a Flutter app that prices, bills, and stores everything offline in SQLite.

---

## HARDWARE — COMPLETE AND VERIFIED ✅

All hardware is finished. The app connects to it. Key facts:

- **Board:** ESP32 DevKit (ESP32-D0WD-V3), programmed in Arduino IDE.
- **Sensor chain:** 5 kg load cell → HX711 (DT = GPIO 26, SCK = GPIO 25) → ESP32.
- **Calibration factor:** 101.16 — reads real kg, accurate to ±3 grams.
- **Features working:** weight reading, averaging (`get_units`), stability detection
  (last 5 readings within 5 g = stable), tare (zeroing).
- **On-scale LCD:** 16×2 I2C LCD (SDA = GPIO 21, SCL = GPIO 22, address 0x27) —
  shows live weight and OK/settling status directly on the scale.
- **Bluetooth (BLE):** ESP32 advertises as **"ESP32-Scale"** (peripheral).
  - Service UUID: `12345678-1234-1234-1234-1234567890ab`
  - Characteristic UUID: `abcd1234-5678-90ab-cdef-1234567890ab`
  - Properties: NOTIFY, READ, **WRITE** (for tare commands from the app)
  - **Data format:** plain text `"grams,stableflag"` e.g. `"1486.0,1"`
  - Verified: nRF Connect receives the live weight.

---

## ARCHITECTURE DECISIONS (already made — follow these)

- **BLE, not Wi-Fi** — no internet dependency; works in any shop or street stall.
- **SQLite (sqflite), not Firebase as primary DB** — offline-first, free, data on phone.
- **Firebase used ONLY for optional cloud backup** (Stage 5), not core storage.
- **Package for BLE:** `flutter_blue_plus`.
- **Two-way BLE:** the app reads weight AND writes tare commands back to the ESP32.
- **Pass 1 coding style:** globals allowed, simple code, understandable over clever.
  Correctness rules that are NON-NEGOTIABLE:
  (1) weight must be stable before billing,
  (2) checkout must be one atomic SQLite transaction,
  (3) money math must be exact (no floating-point rounding bugs on prices).
- **Bill formatting** is kept in a separate function (`generateReceiptText(billId)`)
  so PDF export and future thermal printing both call the same logic.
- **Thermal printing** is future scope — the Print button exists in UI but is stubbed.

---

## THE BASKET AND TARE WORKFLOW (critical — read carefully)

**Field observation:** vendors don't remove each item from the basket after weighing.
They place a basket on the scale, tare it to zero, then add vegetables one at a time
into the basket. Each item is weighed, tapped on the tile grid, and auto-tared before
the next item goes in.

### The single tare rule
> **Every time the active bill changes — new bill, switch to a held one, or payment
> completed — the app sends a tare command to the ESP32 over BLE.**

Why this is always correct: switching the active bill is always the moment a different
physical basket goes onto the scale (a fresh one, or the customer's own being placed
back). The basket is genuinely empty at that moment because the seller bags items
before switching.

### The billing loop (the most repeated action, 200+ times/day)
1. Basket on scale, tared to 0.
2. Seller places one vegetable in basket → weight appears at the top of the screen.
3. Weight stabilizes → tiles light up (become tappable).
4. Seller taps the matching tile → price = weight × rate, item added to bill.
5. **App immediately sends auto-tare** → scale reads 0 again, item stays in basket.
6. Next vegetable placed → weight shows only that item's weight → tap tile → repeat.
7. When done → tap "Pay/Bill" → Cart → Mark paid → next customer.

### Safety rules
- "Add to bill" (tapping a tile) requires weight stable AND > 10 g (prevents
  empty-basket billing).
- Tiles are **visibly disabled/greyed** while settling — the vendor can see they
  can't tap yet.

---

## MULTI-BILL SWITCHER (field-research-driven)

**Field observation:** vendors interleave orders for multiple customers rather than
completing one at a time. Customer A is being served, Customer B arrives — the vendor
holds A's bill and starts B's, switching freely.

### How it works
- A horizontal strip of "open bill" cards sits below the weight bar: Bill 1, Bill 2, +
- Tapping a card makes that bill active.
- Tapping "+" creates a new bill alongside the others.
- "Hold" explicitly holds the current bill (seller bags items, sets basket aside).
- **Each bill switch triggers a tare** (the single tare rule above).
- Each bill has its own independent Cart → Payment → Paid flow.
- Bills stay open indefinitely until paid.

---

## VEGETABLE CATEGORIES (tile organization)

Products are organized into three vendor-chosen tiers:

- **Top** — the 6-8 items that sell every day (tomato, onion, potato...).
  Shown first by default. Covers ~80% of transactions.
- **Regular** — items that sell most days but aren't daily staples.
- **Slow** — seasonal or occasional items.

Category chips at the top of the tile grid: `Top (80%) | Regular | Piece/Bunch | Slow | All`

Within each category, items are auto-sorted by sales frequency (most-sold first).
The vendor assigns the tier when creating a product (Add Product screen).
Piece/bunch items have dashed tile borders to signal "no weighing."

---

## THE APP — 11 SCREENS (13 states)

### Bottom navigation: Home | Bill | Stock | Prices

| # | Screen | Purpose |
|---|---|---|
| 01 | Splash / Connect | BLE scan, connect to ESP32-Scale |
| 02 | Home dashboard | Today/week sales, discounts, low stock, most-sold top 3, NEW BILL |
| 03 | Quick Prices | Update all mandi rates in < 60 sec, ± Rs 5 steppers |
| 04 | Weigh & Select (STABLE) | **THE CORE SCREEN** — live weight bar at top, bill switcher, category chips, tile grid, current items (collapsible), bottom dock with Hold + Pay |
| 04b | Weigh & Select (SETTLING) | Same as 04, but weight bar amber, all tiles greyed/disabled, "Wait for STABLE" warning |
| 05 | Piece Quantity (bottom sheet) | For lemons/coconut/bunches — stepper with quick chips (6/12/25), no weighing |
| 06a | Cart (normal) | Line items with × delete, FREE tags, discount chips (-Rs 5/-Rs 10/Set total/Clear), round-off, Cash/UPI, "To collect", Mark paid |
| 06b | Cart (Set Total expanded) | Same as 06a but discount block expanded inline: input "Customer will pay Rs __", quick-pick chips, derived discount shown, cap warning |
| 07 | Paid | Confirmation, NEXT CUSTOMER button, Share bill (PDF/WhatsApp), Print (stubbed) |
| 08 | Stock | Levels with progress bars, Low/Out chips, weekly wastage card, + New |
| 09 | Add/Edit Product | Name, Sold by (kg/piece/bunch), **Display in (Top/Regular/Slow)**, price, opening stock, low-stock alert, optional photo |
| 10 | Restock (blocked) | Day-close gate — LOCKED until yesterday is closed, greyed inputs |
| 11 | Day Close | Book remaining → weigh fresh → spoiled = book − fresh (derived, never typed) |

### Key feature details

**Discounts:** flat chips (-Rs 5, -Rs 10) or "Set total" (vendor types the agreed price,
discount is derived). Per-bill cap (Rs 50 or 20%, whichever is less). Discount stored in
its own column — never touches item prices.

**Free items:** long-press a cart line → mark as FREE. Price goes to 0 but stock STILL
deducts. Keeps inventory honest for the coriander/dhaniya the vendor throws in for
regulars.

**Remove item:** × icon per cart line, only before payment. Removing from the bill doesn't
remove from the basket — that's the seller's physical action.

**Round-off:** auto-calculated. Locked to ₹0 when "Set total" is used.

> ⚠️ **The wireframes are wrong here — trust this rule, not the PNG.** Both
> `screens/06a_cart.png` and `screens/06b_cart_set_total.png` show "Round-off +Rs 0.13"
> while Set Total is active at ₹90. That is a drawing error. The arithmetic proves it:
> subtotal ₹96.87 − discount ₹6.87 = ₹90.00 exactly, so there is nothing to round, and
> the same screens correctly print "To collect ₹90" (not ₹90.13). When Set Total is
> active, the vendor has already named the final figure — adding a round-off on top
> would silently change the price they just agreed with the customer.
>
> **Implement:** if `setTotalActive` then `roundOff = 0`, else
> `roundOff = round(subtotal − discount) − (subtotal − discount)`.
> Assert in code that `subtotal − discount + roundOff == total`, always.

**Spoilage tracking:** day-close gate blocks restock until the seller weighs the
still-fresh remainder. Spoilage = book stock − weighed fresh. The seller never types the
loss number — it's derived.

---

## DATABASE (SQLite — 4 tables)

```sql
CREATE TABLE products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  unit_type TEXT NOT NULL DEFAULT 'kg',    -- 'kg' | 'piece' | 'bunch'
  category TEXT NOT NULL DEFAULT 'regular', -- 'top' | 'regular' | 'slow'
  price_per_unit REAL NOT NULL,
  stock_qty REAL NOT NULL DEFAULT 0,
  low_alert_qty REAL NOT NULL DEFAULT 5,
  photo_path TEXT,
  last_closed_date TEXT
);

CREATE TABLE bills (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  status TEXT NOT NULL DEFAULT 'open',     -- 'open' | 'paid'
  subtotal REAL,
  discount REAL DEFAULT 0,
  round_off REAL DEFAULT 0,
  total REAL,
  payment_mode TEXT,                       -- 'cash' | 'upi'
  created_at TEXT,
  paid_at TEXT
);

CREATE TABLE bill_items (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  bill_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity REAL NOT NULL,
  unit_price REAL NOT NULL,                -- frozen at time of billing
  amount REAL NOT NULL,
  is_free INTEGER DEFAULT 0,
  FOREIGN KEY (bill_id) REFERENCES bills(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE stock_entries (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  product_id INTEGER NOT NULL,
  entry_type TEXT NOT NULL,                -- 'purchase' | 'spoilage' | 'correction'
  quantity REAL NOT NULL,
  value_lost REAL DEFAULT 0,
  created_at TEXT,
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### The atomic checkout (the most important transaction)
When "Mark paid" is tapped, three things happen inside ONE SQLite transaction:
1. Bill status → 'paid', totals written.
2. All bill_items inserted.
3. Stock reduced for each item.
If any step fails, ALL are undone. This prevents stock from deducting for a bill
that didn't save. Point to this in the viva as evidence of data-integrity thinking.

---

## REPORT / VIVA — THINGS TO BE READY FOR

**"Why no AI camera for vegetable recognition?"** — a tile grid is faster in practice
and immune to poor shop lighting. Recognition is listed as future scope.

**"Why SQLite, not Firebase?"** — offline-first by design. A shop can't depend on
internet during billing. Firebase is used only for optional cloud backup.

**"Why three discount methods?"** — because Indian vegetable buying involves real
haggling. Flat chips for small adjustments, "Set total" for the common "make it Rs 90"
scenario, and free items for regulars. Each is modeled on observed vendor behavior.

**"How do you track spoilage?"** — derived, not typed. The vendor weighs the fresh
remainder; the system computes the loss. This can't be skipped or understated.

**"What happens if the phone disconnects mid-billing?"** — the bill is in SQLite
locally. Reconnecting to BLE resumes weight streaming. No data is lost.
