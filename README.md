# QuizMaster

A Flutter quiz app with 10 subject categories, Firebase authentication, per-category high scores, and a dark navy theme derived from the background texture.

---

## Features

- **10 quiz categories** — Computer Science, Physics, Chemistry, Biology, History, Geography, Civics, Philosophy, Psychology, Indian Law
- **Timed questions** — 10-second countdown per question with a colour-coded progress bar (green → amber → red)
- **Scoring** — +10 for correct, −5 for wrong (floor at 0); animated circular gauge on results screen
- **Answer review** — every question's correct answer and explanation shown after the quiz
- **High scores** — per-category best scores saved to Firestore; viewable in a report screen with letter grades (A+→D) and animated progress bars
- **Authentication** — Google Sign-In, email/password login and signup, or guest mode (plays without saving scores)
- **Consistent dark theme** — all screens share the blurred navy background; dialogs, snack bars, and cards follow the same palette

---

## Screens

| Screen | Description |
|---|---|
| Welcome | Sign in with Google / Email, or continue as Guest |
| Auth | Login / Sign-up form with animated mode toggle |
| Home | Category grid with greeting and High Scores shortcut |
| Quiz | Timed question + answer options with immediate feedback |
| End | Score gauge, stats, performance label, full answer review |
| High Scores | Per-category best score, grade badge, animated progress bars |

---

## Tech Stack

| Layer | Package |
|---|---|
| UI framework | Flutter 3.24+ / Dart 3.2+ |
| Animations | `flutter_animate ^4.5.0` |
| Typography | `google_fonts ^6.2.1` (Poppins) |
| Auth | `firebase_auth ^5.3.1`, `google_sign_in ^6.2.1` |
| Database | `cloud_firestore ^5.0.0` |
| Local storage | `get_storage ^2.1.1` (session score) |
| Timer | `timer_count_down ^2.2.2` |
| Progress indicators | `percent_indicator ^4.2.3` |

---

## Project Structure

```
lib/
├── main.dart                   # Firebase + GetStorage init
├── app.dart                    # MaterialApp, dark theme derived from bg.png
├── widgets/
│   └── app_background.dart     # Shared blurred bg used by all screens
├── models/
│   ├── question.dart
│   └── quiz_category.dart
├── data/
│   ├── categories.dart         # All 10 QuizCategory definitions
│   └── quiz_data/              # 10 question list files (one per category)
├── services/
│   ├── auth_service.dart       # Google + email sign-in/sign-up/sign-out
│   ├── score_service.dart      # Session total score (GetStorage)
│   └── high_score_service.dart # Per-category Firestore high scores
└── screens/
    ├── welcome/                # Welcome screen
    ├── auth/                   # Login / sign-up
    ├── home/                   # Category grid
    ├── quiz/                   # Quiz screen + option button + timer bar
    ├── end/                    # Results screen + result card
    └── highscore/              # High score report
```

---

## Firebase Setup

### 1. Create a Firebase project

Add Android and iOS apps, download `google-services.json` / `GoogleService-Info.plist`, and place them in the standard locations (`android/app/` and `ios/Runner/`).

### 2. Enable sign-in providers

Firebase Console → Authentication → Sign-in method → enable:
- **Email/Password**
- **Google**

### 3. Create Firestore database

Firebase Console → Firestore Database → Create database (Production mode).

Set security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /highscores/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

### 4. Run FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart`.

---

## Getting Started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.24+ and a connected device or emulator.

---

## Theme

The dark colour palette is sampled directly from `assets/bg.png`:

| Role | Hex | Usage |
|---|---|---|
| Deep navy | `#0A1428` | Scaffold background |
| Card surface | `#151F38` | Cards, dialogs, snack bars |
| Accent indigo | `#6C63FF` | Primary, buttons, active states |
| Overlay | `#0A1428` at 78% | Blur overlay in `AppBackground` |

All screens render `bg.png` with a 6px Gaussian blur and the dark overlay, creating a unified frosted-glass aesthetic.
