# 04 — FIREBASE COURSE (optional cloud layer)

**WHEN TO START THIS:** only after the core app is fully working (all stages in
03_FLUTTER_COURSE.md complete). Firebase is a bonus layer, not a dependency. If you run
out of time, the app works perfectly without it — and that's an honest, defensible
answer in the viva.

**WHAT THIS ADDS:** two features that complement the offline-first design without
replacing it.

1. **Firebase Auth (Google Sign-In)** — the vendor logs in once, and their data is
   tied to an identity. If they switch phones, their account follows.
2. **Firestore cloud backup** — when internet is available, bills silently sync to
   Firestore as a backup. If the phone is lost, the sales history isn't gone.

**WHAT THIS DOES NOT DO:** Firestore does NOT replace SQLite as the primary database.
All billing, stock, and spoilage logic continues to read from and write to SQLite.
Firestore is a passive, read-only cloud mirror for safety.

**The viva answer this creates:**
> "SQLite handles all billing offline with zero latency. Firebase provides optional
> cloud backup when internet is available. The app works identically without it,
> but the vendor gets the safety of a cloud copy. This layered approach gives both
> reliability and data safety."

**Why this matters for your kirana billing machine later:** the exact same pattern
(local-first + cloud sync) is what your main product will need. Learning it here on
a small project means you're not learning it under product-launch pressure later.

---

## LESSON FB1 — Create a Firebase project

CONCEPT: Firebase is a Google platform with many services. You only use two:
Authentication and Firestore. Everything starts with creating a project in the
Firebase Console.

BUILD:
1. Go to https://console.firebase.google.com
2. Click "Add project", name it "smartveg" (or similar).
3. Skip Google Analytics (not needed for this).
4. Project is created — you see the Firebase dashboard.

EXPLAIN BACK: what is Firebase? why is it not replacing your SQLite?
GATE: Firebase project exists in the console.
**COMMIT: "Create Firebase project (console only, no code yet)"**

---

## LESSON FB2 — Connect Firebase to your Flutter app

CONCEPT: Firebase needs a config file in your Android project so the app can talk to
Firebase services.

BUILD:
1. In Firebase Console: Add an Android app. Use your package name
   (find it in `android/app/build.gradle` → `applicationId`).
2. Download `google-services.json`.
3. Place it in `android/app/` folder.
4. Add Firebase dependencies to your Gradle files (the console shows exact lines).
5. Add `firebase_core` to pubspec.yaml. Run `flutter pub get`.
6. In `main.dart`, initialize Firebase before `runApp`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(MyApp());
   }
   ```
7. Run the app — no errors means Firebase is connected.

GATE: app runs without errors with Firebase initialized.
**COMMIT: "Connect Firebase to Flutter app"**

---

## LESSON FB3 — Firebase Auth (Google Sign-In)

CONCEPT: Firebase Auth handles login flows. Google Sign-In lets the vendor tap one
button to log in with their Google account — no passwords to remember.

BUILD:
1. In Firebase Console → Authentication → Sign-in method → enable Google.
2. Add `firebase_auth` and `google_sign_in` to pubspec.yaml.
3. Create a simple login screen with a "Sign in with Google" button:
   ```dart
   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
   final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
   final credential = GoogleAuthProvider.credential(
     accessToken: googleAuth.accessToken,
     idToken: googleAuth.idToken,
   );
   await FirebaseAuth.instance.signInWithCredential(credential);
   ```
4. After sign-in, navigate to the Home screen.
5. Show the vendor's name on the Home screen.
6. Add a "Sign out" option in Settings (or a menu).

PREDICT: why use Google Sign-In instead of email/password? (Answer: a small vendor
may not have an email address they check regularly, but they almost certainly have a
Google account on their Android phone — it's the account that runs the Play Store.)

GATE: tapping "Sign in with Google" logs the vendor in, their name shows on Home.
**COMMIT: "Firebase Auth with Google Sign-In"**

---

## LESSON FB4 — Firestore setup and the sync model

CONCEPT: Firestore is a cloud database organized as Collections → Documents. Each
document is like a JSON object. You'll mirror your SQLite bills to Firestore.

**The sync model (understand this before coding):**
- SQLite is the **source of truth**. Every billing action reads from and writes to
  SQLite first.
- After a successful SQLite checkout, the app **also** writes a copy of the bill to
  Firestore — but only if internet is available. If it's not, the bill is fine in
  SQLite; the Firestore copy catches up later.
- The app NEVER reads from Firestore during billing. Firestore is a **write-only
  backup mirror** from the app's perspective.

**Firestore structure:**
```
users/
  {userId}/
    bills/
      {billId}/
        subtotal: 96.87
        discount: 6.87
        total: 90.00
        payment_mode: "upi"
        paid_at: "2026-09-20T14:30:00"
        items: [
          { name: "Tomato", qty: 1.486, unit: "kg", price: 45, amount: 66.87 },
          { name: "Lemon", qty: 6, unit: "pc", price: 5, amount: 30.00 }
        ]
```

BUILD:
1. Add `cloud_firestore` to pubspec.yaml.
2. In Firebase Console → Firestore Database → Create database (start in test mode
   for development; lock down with security rules before any real use).
3. Understand the structure above.

EXPLAIN BACK: why is Firestore a mirror, not the primary database?
GATE: Firestore database exists in the console, you can explain the sync model.
**COMMIT: "Firestore database setup"**

---

## LESSON FB5 — Sync bills to Firestore after checkout

BUILD: in your checkout transaction (the one in F4.3), after the SQLite transaction
succeeds, add a Firestore write:
```dart
// After the SQLite transaction succeeds:
try {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('bills')
      .doc(billId.toString())
      .set({
        'subtotal': bill.subtotal,
        'discount': bill.discount,
        'total': bill.total,
        'payment_mode': bill.paymentMode,
        'paid_at': DateTime.now().toIso8601String(),
        'items': items.map((i) => {
          'name': i.name,
          'qty': i.quantity,
          'unit': i.unitType,
          'price': i.unitPrice,
          'amount': i.amount,
        }).toList(),
      });
  }
} catch (e) {
  // Firestore failed — that's OK, SQLite has the data.
  // Log the error, don't crash the app.
  print('Firestore sync failed: $e');
}
```

**Critical design rule:** the Firestore write is OUTSIDE the SQLite transaction and
wrapped in try/catch. If Firestore fails (no internet, server error), the bill is
still safely in SQLite. The app continues normally. Never let a cloud failure block
a local billing operation.

PREDICT: why is the Firestore write after the SQLite transaction, not inside it?
(Answer: if Firestore fails, you don't want to undo the SQLite save too — the bill
is valid locally regardless of whether the cloud copy succeeded.)

GATE: pay a bill → check Firestore Console → the bill document appears.
**COMMIT: "Sync bills to Firestore after checkout"**

---

## LESSON FB6 — Offline resilience and retry

CONCEPT: what happens when the app is offline during checkout?

BUILD: the Firestore write silently fails (the try/catch handles it). Add a simple
mechanism to retry:
1. Add a `synced_to_cloud` column (INTEGER DEFAULT 0) to the `bills` SQLite table.
2. On successful Firestore write, update `synced_to_cloud = 1`.
3. On app start (or periodically), query bills where `synced_to_cloud = 0` and
   retry the Firestore write.
4. Show a small indicator on the Home screen: "2 bills pending cloud sync" (or
   nothing if all are synced).

GATE: turn off Wi-Fi → pay a bill → SQLite has it, Firestore doesn't → turn Wi-Fi
on → the bill syncs automatically.
**COMMIT: "Offline sync retry for Firestore backup"**

---

## LESSON FB7 — Security rules (lock it down)

CONCEPT: Firestore security rules control who can read/write what. In test mode,
anyone can read/write everything — that's fine for development but not for a real app.

BUILD: in Firebase Console → Firestore → Rules, set:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```
This means: a logged-in user can only read/write their own data. Nobody else can
see their bills.

EXPLAIN BACK: what would happen without these rules?
GATE: rules are published. Trying to read another user's data fails.
**COMMIT: "Firestore security rules"**

---

## AFTER FB7 — Firebase is done

Your app now has:
- SQLite for all local billing (fast, offline, free).
- Firebase Auth for identity (Google Sign-In).
- Firestore for cloud backup (syncs when online, retries when offline).
- Security rules protecting each vendor's data.

This is the exact pattern professional offline-first apps use, and it's directly
transferable to your kirana billing machine.

---

## PROGRESS TRACKER
```
FB1 [ ]  Firebase project created
FB2 [ ]  Connected to Flutter app
FB3 [ ]  Google Sign-In working
FB4 [ ]  Firestore structure understood
FB5 [ ]  Bills sync to Firestore after checkout
FB6 [ ]  Offline retry mechanism
FB7 [ ]  Security rules locked down
```
