---
name: Field Utility & Kinetic Precision
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3e4947'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#6e7977'
  outline-variant: '#bdc9c6'
  surface-tint: '#006a63'
  primary: '#0f766e'
  on-primary: '#ffffff'
  primary-container: '#005c55'
  on-primary-container: '#a3faef'
  inverse-primary: '#80d5cb'
  secondary: '#2b6954'
  on-secondary: '#ffffff'
  secondary-container: '#adedd3'
  on-secondary-container: '#306d58'
  tertiary: '#7d4200'
  on-tertiary: '#ffffff'
  tertiary-container: '#a15600'
  on-tertiary-container: '#ffe6d5'
  accent-info: '#1565c0'
  on-accent-info: '#ffffff'
  accent-info-container: '#e8f1fc'
  on-accent-info-container: '#0d47a1'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#9cf2e8'
  primary-fixed-dim: '#80d5cb'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#00504a'
  secondary-fixed: '#b0f0d6'
  secondary-fixed-dim: '#95d3ba'
  on-secondary-fixed: '#002117'
  on-secondary-fixed-variant: '#0b513d'
  tertiary-fixed: '#ffdcc3'
  tertiary-fixed-dim: '#ffb77d'
  on-tertiary-fixed: '#2f1500'
  on-tertiary-fixed-variant: '#6e3900'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  headline-xl:
    fontFamily: Inter
    fontSize: 40px
    fontWeight: '800'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-xl-mobile:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '700'
    lineHeight: 28px
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '700'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '500'
    lineHeight: 26px
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 22px
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  data-display-xl:
    fontFamily: JetBrains Mono
    fontSize: 48px
    fontWeight: '800'
    lineHeight: 52px
    letterSpacing: -0.04em
  data-display-lg:
    fontFamily: JetBrains Mono
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  data-display-md:
    fontFamily: JetBrains Mono
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 13px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.06em
  label-numeric:
    fontFamily: JetBrains Mono
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 20px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  gutter-tablet: 1rem
  margin: 0.75rem
  margin-tablet: 1.25rem
  space-xs: 0.375rem
  space-sm: 0.625rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2.25rem
---

## Brand & Style

This design system is tailored specifically for high-tempo, physical retail in unforgiving ambient environments: outdoor markets, direct sunlight, variable glare, moisture, and vendors operating devices rapidly with wet, dusted, or calloused hands. 

The aesthetic is **Tactile Industrial Utilitarianism**. It rejects decorative subtlety, nested menus, low-contrast pastel gradients, and delicate lines in favor of immediate affordance, structural density, high optical legibility, and physical clarity. 

### Emotional Target & Voice
- **Absolute Reliability:** Transmits instant confidence that figures, weights, and offline sync logs are mathematically sound and physically locked.
- **Instrument Precision:** Operates like a digital trade tool—analogous to a professional field multimeter or commercial point-of-sale terminal.
- **Effortless Speed:** Reduces cognitive and motor friction; critical tasks require zero visual hunting, generous error margins on taps, and definitive confirmation of device states.

## Colors

The palette is tuned for **extreme optical clarity under outdoor sunlight** (diffusing ambient reflections) while resisting visual clutter. High-contrast tonal surfaces replace delicate low-contrast grays, ensuring accessibility under glare.

### Primary & Functional Roles
- **Primary (`#0F766E`)**: Deep calm teal. Used for key interactive actions, focused states, system headers, and active hardware states. This exact value is what the approved wireframes render — it is the single source of truth for the brand green, and the `primary` token in the frontmatter above matches it.
- **Secondary (`#064E3B`)**: Rich dark forest green. Used for critical confirmations, high-contrast badges, totalized figures, and primary tactile action surfaces.
- **Tertiary (`#D97706`)**: High-alert amber. Dedicated to scale calibration alerts, unstable weight states ("Settling..."), and Bluetooth sync holds.
- **Neutral (`#0F172A`)**: Carbon ink. Used for all primary numbers, scale readings, and heavy typography to maximize contrast against clean white/off-white surfaces.

### Semantic & Status Accents
- **Selection Blue (`#1565C0`)**: The input-and-choice accent. Reserved strictly for states the *vendor* has selected or typed, as distinct from states the *system* reports. Used for: the active bill card border in the switcher, a selected payment mode (UPI/Cash), a focused or edited numeric field, changed-but-unsaved price rows, quantity `+` in the piece stepper, the day-close weighing panel, and secondary informational actions (Share bill, + New). Never use it for money totals, confirmations, or hardware state — those are green, forest green, and amber respectively. Keeping this role separate is what lets a vendor tell "I chose this" apart from "the scale says this" at a glance in bright sun.
- **Hardware Stable Emerald (`#10B981`)**: Confirmed weight lock, active ESP32 connection, and instant bill print status.
- **Alert Red (`#DC2626`)**: Tare mismatch, ESP32 disconnect, zeroing error, and voided transactions.
- **Surface Clean (`#FFFFFF`) & Canvas Ground (`#F8FAFC`)**: High-luminance bases that reject muddy mid-tones, making edge boundaries readable outdoors.
- **Structural Stroke (`#CBD5E1`)**: Crisp 1.5px to 2px division lines providing physical boundaries between dense operational touchpoints.

## Typography

The type system prioritizes immediate readability at arm's length (40–80 cm) while the Android terminal rests on a market stall or vehicle mount.

### Architectural Rules
- **Inter** handles linguistic content, headers, product names, and navigation labels with heavy, robust letterforms that resist pixelation and sunlight bleeds.
- **JetBrains Mono** governs all dynamic numerical updates: real-time live scale feeds (e.g., `1.845 kg`), unit rates (e.g., `₹40/kg`), and running total computations (`₹120.00`). Tabular spacing (`tabular-nums`) is mandatory across all arithmetic contexts to eliminate layout shifting during scale fluctuations.
- **Weight Strategy:** Minimum weight for functional UI copy is `500` (Medium) to prevent line disappearance under bright ambient illumination.
- **Currency Symbol:** always the rupee glyph **`₹`**, never the ASCII `Rs`. The wireframes are inconsistent on this point (screen 04 uses `₹`, screens 05/06/07/09 use `Rs`) — `₹` is correct and JetBrains Mono renders it at all weights. Write it with no space before the figure: `₹90.00`, not `₹ 90.00`.
- **Decimal Discipline:** money always carries exactly two decimals (`₹66.87`, `₹30.00`) and weight exactly three (`1.486 kg`, `0.000 kg`), so digits stay in fixed columns and the readout never jitters as the scale settles.

## Layout & Spacing

The layout is built upon a **rigid touch-first fluid grid** engineered to minimize scrolling and prioritize spatial ergonomics for single-handed thumb reach and index-finger speed.

### Device Breakpoints & Adaptations
- **Handheld Compact Mobile (< 400px):** Single-column ledger with persistent 3-row grid for vegetable catalogue; live scale viewport anchored permanently at the top; checkout sheet docked to the screen bottom.
- **Standard Mobile (400px – 599px):** **3-column** vegetable selection deck (as drawn in `screens/04_weigh_and_select.png` — the tile sizing and the 88×88px minimum tap target were laid out for three across; do not build two), top-anchored live weight panel, and 72px thumb-zone execution dock.
- **Rugged POS Tablet (≥ 600px):** Split-view operational mode: 60% left catalogue grid (3–4 columns), 40% right continuous live bill ledger with full-scale readout and direct thermal print commands.

### Hit Targets & Physical Margins
Every interactive surface adheres to a **strict minimum boundary of 48×48px**, scaling to **60–64px** for high-frequency field actions (Tare, Zero, Add to Bill, Cash Tender). Component padding ensures fingers touching off-center do not trigger adjacent commands.

## Elevation & Depth

This design system deliberately minimizes soft ambient blurs and high-diffusion drop shadows, as they wash out completely under direct midday sunlight and create visual haze on low-tier IPS mobile panels.

### Structural Depth Architecture
- **Layer 0 (Canvas Base):** High-clarity `#F8FAFC` foundation.
- **Layer 1 (Tactile Card Surface):** Pure `#FFFFFF` surfaces bounded by crisp, high-contrast borders (`1.5px solid #CBD5E1`).
- **Layer 2 (Hardware State Cards & Modal Overlays):** Deep mechanical 2-stop offset shadow: `0px 3px 0px 0px #CBD5E1` (giving a physical, clickable button feel) combined with a high-contrast dark outline (`#0F172A`).
- **Layer 3 (Active Scale Readout):** Recessed industrial bezel effect achieved with an inset 2px border (`#0F766E`) and tonal background fill (`#F0FDFA`), providing immediate perceptual separation between standard software buttons and live physical hardware telemetry.

## Shapes

The design system employs a **balanced, tactile roundedness (Scale 2 - 0.5rem base radius)**. 

Sharp 90-degree corners are avoided to soften hand collisions on screen corners and maintain approachable consumer trust, while pill shapes (which reduce usable internal tap surface) are restricted strictly to micro status badges.

### Spatial Application
- **Base Components (Inputs, Product Tiles, Table Rows):** `0.5rem` (8px) corner radius.
- **Chunky Operational Elements (Tare/Zero, Add Item, Keypad Keys):** `1rem` (16px) corner radius, delivering an identifiable physical button appearance.
- **Permanent Top/Bottom Sheets & Hardware Display Bar:** `1.25rem` (20px) top or boundary radius with prominent 2px perimeter containment.

## Components

### 1. Live Scale Telemetry Monitor (Hero Component)
- **Visuals:** High-contrast recessed container with deep carbon background (`#0F172A`) or high-visibility daylight mode (`#F0FDFA` with `#0F766E` 2px border).
- **Readout:** Extra-large `data-display-xl` JetBrains Mono figures (e.g., `2.450 kg`).
- **Status Indicator Badges:**
  - *Settling / Calibrating:* High-alert amber badge (`#FEF3C7` background, `#92400E` border and text) with pulsing dot.
  - *Stable Lock:* Bright emerald badge (`#059669` background, `#FFFFFF` text) with a firm checkmark, indicating weight is locked and ready for billing.
- **Integrated Zero/Tare Actions:** Twin tactile square pushbuttons (min 56px height) integrated on the right edge of the monitor.

### 2. Product Selection Tiles
- **Structure:** Heavy rectangular cards with minimum tap target of 88×88px.
- **Content Placement:** Vegetable name in bold Inter (`headline-sm`), localized secondary name in muted body, unit price in JetBrains Mono (`label-numeric`), and an optional high-contrast visual glyph or photo container.
- **Touch Feedback:** Distinct physical button displacement (`transform: translateY(2px)`) with crisp border-color shift from neutral slate to secondary forest green.

### 3. Tactile Stepper & Quantity Adjusters
- **Structure:** Segmented 3-part block (Minus, Value, Plus).
- **Ergonomics:** `+` and `–` trigger regions are a minimum of 52px width with prominent `#0F172A` iconography, eliminating mis-taps. Central quantity text uses `data-display-md`.

### 4. Segmented Multi-Customer Bill Switcher
- **Structure:** Horizontal segmented tab bar docked below the header, allowing vendors to handle 3 active customer baskets concurrently while vegetables are weighed in succession.
- **States:** Active bill highlighted in primary teal with bold customer tag and running item count; inactive tabs styled with clear slate borders and muted totals.

### 5. Persistent Execution Dock (Bottom Sheet)
- **Structure:** Fixed bottom strip (minimum height 76px) anchoring the transaction.
- **Elements:** 
  - Left pane: Running total displayed in `data-display-lg` (`₹485.00`) with itemized count.
  - Right pane: Primary execution button ("PRINT & SAVE" / "COMPLETE CASH") rendered in solid dark forest green (`#064E3B`) with high-contrast white text, spanning at least 50% of screen width.

### 6. Inputs & Numeric Touchpad
- **Structure:** Full-width custom on-screen numeric keypad for rapid manual weight or rate entry.
- **Keys:** Elevated tactile blocks with 60px height, bold centered numerals, high contrast borders, and strong haptic/auditory feedback loops on tap.