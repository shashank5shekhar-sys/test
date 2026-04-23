# 🎯 QuizMaster — Flutter Quiz App

A complete dark-mode Flutter quiz app for students, powered by **Supabase** (free tier) for authentication, database, and storage.

---

## 📁 Project Structure

```
quiz_app/
├── lib/
│   ├── main.dart
│   ├── supabase/
│   │   ├── supabase_init.dart       # Supabase connection
│   │   ├── auth_service.dart        # Login / Signup logic
│   │   ├── database_service.dart    # Quiz + user data
│   │   └── storage_service.dart     # Profile image upload
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── quiz_model.dart
│   │   └── question_model.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── home_screen.dart
│   │   ├── profile_screen.dart
│   │   ├── quiz_list_screen.dart
│   │   ├── quiz_screen.dart
│   │   └── result_screen.dart
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── quiz_tile.dart
│   │   └── loading_widget.dart
│   ├── utils/
│   │   ├── theme.dart               # Dark mode theme
│   │   └── constants.dart
│   └── routes/
│       └── app_routes.dart
├── pubspec.yaml
├── supabase_setup.sql               # ← Run this in Supabase
└── README.md
```

---

## 🆓 Supabase Setup (100% Free)

### Step 1 — Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com) and click **Start for Free**
2. Sign in with GitHub (free, no credit card needed)
3. Click **New Project**
4. Choose a name (e.g. `quizmaster`), set a strong database password, pick the region closest to you
5. Wait ~2 minutes for the project to be ready

### Step 2 — Get your credentials

1. In your Supabase dashboard, go to **Settings → API**
2. Copy the **Project URL** (looks like `https://xxxx.supabase.co`)
3. Copy the **anon / public** key (long string starting with `eyJ...`)

### Step 3 — Add credentials to the app

Open `lib/utils/constants.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

with your actual values.

### Step 4 — Run the database schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Click **+ New Query**
3. Open the file `supabase_setup.sql` from this project
4. Paste the entire contents into the editor
5. Click **Run** (green button)

This will create all tables, Row Level Security policies, the storage bucket, and seed 5 quizzes with 5 questions each.

### Step 5 — Enable Email Auth

1. Go to **Authentication → Providers**
2. Make sure **Email** is enabled (it is by default)
3. Optionally disable "Confirm email" for easier testing:
   - Go to **Authentication → Settings**
   - Toggle off **Enable email confirmations**

---

## 🚀 Running the App

### Prerequisites

- Flutter SDK `>=3.0.0` installed → [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
- Android Studio or VS Code with Flutter extension
- A physical Android device or emulator (API 21+)

### Commands

```bash
# Clone or open the project folder
cd quiz_app

# Install dependencies
flutter pub get

# Run on Android
flutter run

# Build release APK
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

---

## ✨ Features

| Feature | Details |
|---|---|
| **Auth** | Email/password signup & login via Supabase Auth |
| **Success Popups** | Animated dialog on login & signup success |
| **Profile** | Name, phone, profile photo (stored in Supabase Storage) |
| **Home Screen** | User avatar + name, welcome banner, quick action cards |
| **Quiz List** | 5 quizzes fetched live from Supabase database |
| **Pre-Quiz Form** | Name + phone required before starting |
| **Quiz Screen** | One question at a time, A/B/C/D options, instant feedback |
| **Result Screen** | Score, percentage, PASS (≥90%) or FAIL badge |
| **Results Saved** | Every attempt saved to `quiz_results` table |
| **Dark Mode** | Forced dark mode throughout the app |
| **Android Ready** | Works on all Android phones (API 21+) |

---

## 🗄️ Database Tables

| Table | Purpose |
|---|---|
| `profiles` | User name, phone, avatar URL |
| `quizzes` | Quiz title, description, category, emoji |
| `questions` | Questions with 4 options + correct answer index |
| `quiz_results` | Score, pass/fail, participant details per attempt |

---

## 🔐 Security

- Row Level Security (RLS) is enabled on all tables
- Users can only read/write their own profile and results
- Quizzes and questions are public read (anyone can take a quiz)
- Avatar storage is protected so users can only overwrite their own files

---

## 📦 Dependencies

```yaml
supabase_flutter: ^2.3.4    # Backend (auth, database, storage)
google_fonts: ^6.2.1         # Orbitron + Space Grotesk fonts
flutter_animate: ^4.5.0      # Smooth animations
image_picker: ^1.0.7         # Profile photo picker
flutter_spinkit: ^5.2.1      # Loading indicators
cached_network_image: ^3.3.1 # Efficient image loading
shared_preferences: ^2.2.3   # Local key-value storage
```

---

## 🎨 Design

- **Color palette**: Deep navy `#0A0E1A` base, electric blue `#4F8EF7` accent
- **Fonts**: Orbitron (headings) + Space Grotesk (body)
- **Animations**: flutter_animate for staggered reveals and micro-interactions
- **Components**: Custom cards, chips, progress bars, animated result screen

---

## 🛠️ Adding More Quizzes

Simply insert into Supabase via the SQL Editor:

```sql
insert into quizzes (title, description, category, total_questions, icon_emoji)
values ('My New Quiz', 'Description here', 'Category', 5, '🎯');

-- Then get the generated id and insert questions:
insert into questions (quiz_id, question_text, options, correct_index, order_num)
values (
  '<paste-quiz-id-here>',
  'Your question here?',
  '["Option A","Option B","Option C","Option D"]',
  0,   -- 0 = Option A is correct
  1
);
```

---

## 📱 Android Permissions

Add these to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## 💡 Tips

- The free Supabase tier gives you **500 MB** database, **1 GB** storage, and **50,000** monthly active users — more than enough for a student quiz app
- To view quiz results, go to Supabase → **Table Editor → quiz_results**
- To add an admin panel, use Supabase's built-in Table Editor or build a web dashboard
