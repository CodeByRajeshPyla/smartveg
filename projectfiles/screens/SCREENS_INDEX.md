# SCREENS INDEX — visual reference for each screen

These are the final, approved UI designs. When building a screen in the Flutter course,
open the matching PNG to see exactly what to build. The design system (colors,
typography, spacing) is in `../DESIGN.md`.

**Read "Known wireframe errors" at the bottom of this file before building 06a/06b.**

| File | Screen | Build in course lesson |
|---|---|---|
| `01_splash.png` | Splash / BLE scanning | F1.1–F1.4 |
| `02_home.png` | Home dashboard | F5.1 |
| `03_quick_prices.png` | Quick Prices (± steppers) | F5.2 |
| `04_weigh_and_select.png` | **Core billing screen (STABLE state)** — weight bar, bill switcher, category chips, tile grid, current items, dock | F2.4–F2.11 |
| `04b_settling_state.png` | **Same screen, SETTLING state** — amber weight bar, all tiles greyed/disabled | F2.7 |
| `05_piece_quantity.png` | Piece quantity bottom sheet | F2.9 |
| `06a_cart.png` | Cart (normal/collapsed discount) | F3.2–F3.4 |
| `06b_cart_set_total.png` | Cart (Set Total expanded inline) | F3.5 |
| `07_paid.png` | Paid confirmation | F3.6 |
| `08_stock.png` | Stock inventory | F5.3 |
| `09_add_product.png` | Add/Edit product (with category selector) | F5.4 |
| `10_restock_blocked.png` | Restock blocked by day-close gate | F5.5 |
| `11_day_close.png` | Day close / spoilage | F5.5 |

## Key visual rules (from DESIGN.md)
- **Primary green:** #0F766E (headers, key actions)
- **Dark forest green:** #064E3B (Mark paid, primary tactile buttons)
- **Amber:** #D97706 (settling/unstable weight states)
- **Stable emerald:** #10B981 (weight locked, confirmed)
- **Selection blue:** #1565C0 (what the *vendor* chose or typed: active bill card,
  selected payment mode, focused/edited number, changed price rows, Share bill, + New)
- **Red:** #DC2626 (errors, out of stock, voids)
- **Numbers** use JetBrains Mono (tabular). **Text** uses Inter (min weight 500).
- **Currency** is always `₹`, never `Rs` — the PNGs are inconsistent, `₹` wins.
- **Tap targets:** min 48px, scaling to 60-64px for high-frequency actions (Tare,
  Add to Bill, Pay).
- Piece/bunch tiles have dashed borders. Weight items have solid.
- The tile grid is **3 columns** on a normal phone.

---

## Known wireframe errors (build the rule, not the picture)

These PNGs are approved as *layout*, but three details in them are wrong. Where a PNG
disagrees with the written spec, the written spec wins.

1. **Round-off in `06a_cart.png` and `06b_cart_set_total.png`.** Both show
   "Round-off +Rs 0.13" while Set Total is active. Round-off must be **₹0** whenever
   Set Total is active. The screens' own "To collect Rs 90" line proves it
   (96.87 − 6.87 = 90.00 exactly). Full reasoning in `../01_PROJECT_CONTEXT.md`.
2. **Currency symbol.** Screen 04 uses `₹`; screens 05, 06a, 06b, 07 and 09 use `Rs`.
   Use `₹` everywhere.
3. **Column count.** `DESIGN.md` previously said 2-column for standard mobile; the
   approved grid is 3 columns, as drawn. DESIGN.md has been corrected to match.

## Undocumented-but-real: the blue accent

A fourth colour (~#1565C0) appears on nearly every screen — splash progress bar, UPI
when selected, "+ New", "Share bill", the piece-sheet `+`, changed rows in Quick Prices,
the day-close weighing panel, and the active bill card border. It was missing from the
original DESIGN.md and has now been added there as `accent-info` with a defined role:
**vendor input and selection**, kept distinct from teal (brand), forest green (money
confirmed) and amber (hardware unstable).

## Data consistency (use these as your SQLite seed in F4.2)

The numbers across all 13 screens form one coherent dataset — 37 bills today makes the
next bill **#0038**; Home's low-stock list matches Stock exactly; week waste ₹214 matches
the wastage card; Quick Prices' new values (45/28/55) match the tile grid; screen 10's
"4.0 kg" matches screen 11's book remaining; and 2.514 kg × ₹45 = **₹113.13** ✓.
Seed the database with these values and every screen you build will agree with every
other one — which makes demoing the app in your viva much easier.
