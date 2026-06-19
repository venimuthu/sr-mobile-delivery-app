# SR Department Store — Ice Cream & Frozen Delivery

A premium, Apple-style customer mobile app for **SR Department Store**, *No.1 Tolgate, Trichy*. Built with Flutter. Ships today on a clean dummy catalogue and is wired so the entire app moves to the real backend by flipping a single flag.

---

## What's inside

- **Home** — editorial hero, shop-by-category rail, featured rail, and the full catalogue grid.
- **Store** — every category at a glance.
- **Product detail** — large product visual, highlights, cold-chain delivery note, sticky add-to-cart.
- **Search** — instant search across the freezer.
- **Cart** — line items, free-delivery progress, itemised bill (delivery, packaging, GST).
- **Checkout** — address, UPI / Card / Cash-on-delivery, place order.
- **Order tracking** — live status timeline: Confirmed → Preparing → Out for delivery → Delivered.
- **Orders** — active order + history.
- **Account** — profile, saved address, support, sign out.
- **Auth** — mock OTP login (demo code `1234`) with a *Skip for now* path.

The visual language follows apple.com: a near-white canvas, ink-black type, one confident accent (system blue), tightly-tracked headlines, generous spacing, and restrained motion.

---

## Running it

> Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.16+). This repo contains the app source (`lib/`) and `pubspec.yaml`. The platform folders (`android/`, `ios/`, etc.) are generated on your machine.

```bash
# 1. Generate the native platform folders (keeps lib/ and pubspec.yaml intact)
flutter create .

# 2. Fetch dependencies
flutter pub get

# 3. Run on a device or simulator
flutter run
```

The **Inter** typeface (a free stand-in for SF Pro) is loaded at runtime via `google_fonts`, so the first launch needs a network connection. To ship fonts offline, bundle the Inter `.ttf` files and point `google_fonts` at them.

---

## Architecture

A small, layered structure that keeps the UI completely unaware of where data comes from.

```
lib/
├── core/            theme (colours, type, ThemeData), constants, formatters
├── models/          Product, Category, CartItem, Order, AppUser  (+ JSON)
├── data/
│   ├── dummy_data.dart            the in-memory catalogue (delete later)
│   ├── datasources/
│   │   ├── catalog_data_source.dart      abstract contract
│   │   ├── dummy_catalog_data_source.dart serves dummy_data (now)
│   │   └── api_catalog_data_source.dart   talks to the SR backend (stub)
│   └── repositories/              choose a source; expose clean methods
├── providers/       CatalogProvider, CartProvider, OrderProvider, AuthProvider
├── widgets/         shared UI (ProductCard, GradientImage, buttons…)
└── screens/         splash, auth, home, catalog, product, cart, checkout, orders, profile
```

State management is **Provider** (`ChangeNotifier`). Every model already has `fromJson` / `toJson`, so the real API can return the same shapes with zero model changes.

### Product visuals
Until the catalogue has photography, each product renders as its own branded two-colour gradient with an emoji — intentional and on-brand, never a broken image box. The moment a product carries an `imageUrl`, `GradientImage` shows the photo instead. No call-site changes.

---

## Going from dummy data to the real SR Department Store backend

Everything is staged for the switch:

1. **Flip the flag** in `lib/core/constants/app_constants.dart`:
   ```dart
   static const bool useDummyData = false;
   static const String apiBaseUrl = 'https://api.srdepartmentstore.in/v1';
   ```
2. **Implement the transport** in `lib/data/datasources/api_catalog_data_source.dart`. The parsing is already written (`Product.fromJson`, `Category.fromJson`); only the HTTP calls are stubbed, with the exact endpoints sketched in comments. Add the `http` (or `dio`) package and fill in the four methods.
3. **Wire real auth & orders** when ready — `AuthProvider` (OTP) and `OrderRepository` (place order + status stream) have clearly marked `TODO(backend)` seams. The status stream becomes a WebSocket against the live delivery feed; its public surface stays identical.

That's it — the providers, widgets, and screens never change.

---

## Notes

- Tunable commerce values (free-delivery threshold, delivery fee, packaging, GST, ETA) live in `AppConstants`.
- This is the customer app. The admin portal and backend services described in the wider architecture are separate deliverables.

---

*SR Department Store · No.1 Tolgate, Trichy*
