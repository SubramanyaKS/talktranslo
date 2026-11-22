# 📢 TalkTranslo - Multi-Language Translator & Voice Conversation App

**TalkTranslo** is a modern, production-grade Flutter translation application designed for seamless multilingual communication. It features real-time text translation with a **4-tier resilient engine** (including **True On-Device Offline Translation** via Google ML Kit), **Pronunciation / Romanization Guides**, **Instant Debounced Auto-Translate**, **Auto-Detect Language ("Auto Detect ✨")**, tabletop **Face-to-Face (180° Inverted)** conversation mode, an offline **Travel & Survival Phrasebook**, **Editable Camera OCR** via Google ML Kit, **Fullscreen Traveler Mode**, **Clipboard Quick-Translate**, **Slow Pronunciation Mode (🐢 0.6x)**, tactile haptic feedback, **System / Light / Dark Material 3 theming**, and persistent SQLite database history.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6+-00B4AB?logo=dart)
![Material 3](https://img.shields.io/badge/Material--3-Enabled-7C3AED)
![License](https://img.shields.io/badge/License-MIT-green)
![Tests](https://img.shields.io/badge/Tests-33%20Passing-success)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

</div>

---

## 🚀 Key Features

### **📝 Modern Text Translation**
- **22+ Supported Languages:** Indian languages (Kannada, Hindi, Tamil, Telugu, Malayalam, Bengali, Gujarati, Assamese, Konkani, Sanskrit) and global languages (English [US & IN], Spanish, French, German, Japanese, Korean, Chinese [Simplified & Traditional], Russian, Arabic, Hebrew, Thai).
- **Auto-Detect Source Language ("Auto Detect ✨"):** Automatically identifies the input language, displays a `✨ Detected: <Language>` badge, routes input TTS to the detected locale, and unlocks one-tap language swapping.
- **Pronunciation / Romanization Guide:** Displays phonetic romanization (e.g., `ಹಲೋ, ಹೇಗಿದ್ದೀಯಾ?` → *`Halō, hēgiddīyā?`*) underneath non-Latin translations across Text Translate, Fullscreen Traveler Mode, and Camera OCR.
- **Instant Debounced Auto-Translate (`Instant ⚡`):** Optional toggle that translates automatically ~650ms after you stop typing.
- **4-Tier Resilient Engine + True Offline Mode:** Automatic failover across Google GTX (`&dt=rm`), `translator`, Chrome Dict, and **On-Device ML Kit Offline Translation** (`google_mlkit_translation`).
- **Clipboard Quick-Translate Banner:** Detects copied text from other apps on launch and app resume (`WidgetsBindingObserver`) with a one-tap translate pill.
- **Slow Pronunciation Mode (🐢 0.6x):** Dedicated turtle speed button on translation cards for language learners and travelers to hear difficult words enunciated slowly.
- **Interactive Language Picker & Animated Swap:** Search modal bottom sheet with national flags and smooth 180° language swap animation.
- **Fullscreen Traveler Mode:** Giant bold, dynamically scaling text (with optional romanization) designed for showing taxi drivers, store clerks, or passersby across counters.
- **Bottom Action Toolbar:** Quick buttons for **Voice Dictation (Mic)**, **Copy**, **Clear (✕)**, **Paste from Clipboard**, **Speak (TTS)**, **Slow Speak (🐢)**, **Fullscreen**, and **Share**.

### **📶 True On-Device Offline Translation (User-Controlled)**
- **On-Demand Language Pack Manager (`OfflineLanguagesScreen`):** Download or remove ~30 MB Google ML Kit on-device packs for 17 supported languages without bloating the base APK.
- **3 User-Controlled Preferences:**
  - **Auto Offline Fallback** (default ON): Automatically translates custom sentences, voice, and OCR text locally when internet is unavailable.
  - **Prefer Offline Mode** (default OFF): Runs translations on-device first whenever packs are downloaded to save mobile data.
  - **Download Over Wi-Fi Only** (default ON): Prevents cellular data usage during language pack downloads.
- **Clear Offline Indicator:** Displays a `Translated Offline (On-Device)` badge whenever a translation ran locally, plus transparent labeling of online-only languages (Assamese, Konkani, Malayalam, Sanskrit).

### **🎙️ Dual Split-Screen Voice Conversation Mode**
- **Two-Way Spoken Conversation:** Dedicated cards for Speaker 1 and Speaker 2 for natural face-to-face dialogue.
- **🔄 Tabletop Face-to-Face 180° Invert Mode:** One-tap toggle splits the screen evenly and flips Speaker 1's card 180° (`RotatedBox(quarterTurns: 2)`) so both participants can look at the phone placed flat on a table between them.
- **In-Card Microphones:** In Face-to-Face mode, dedicated pulsing `AvatarGlow` microphones and live waveforms are placed directly inside each speaker's card facing them.
- **Central Divider Toolbar:** Midpoint control bar with a 1-tap mode toggle pill, instant language swap button (`swapLanguages`), and conversation reset button.
- **Dual Microphone Action Dock:** Shown in handheld mode with two thumb-friendly microphone buttons and an active waveform visualizer.
- **Live Animated Audio Waveform:** Real-time dancing soundwave visualizer responding to mic amplitude and speech cadence.
- **Automatic Translation & Audio Playback:** Auto-translates upon silence detection or manual tap and speaks the translation aloud.

### **📖 Travel & Survival Phrasebook**
- **34 Curated Essential Phrases:** Spanning 5 core categories: 🚨 **Emergency & Medical**, 🚕 **Transit & Directions**, 🍽️ **Dining & Food**, 🏨 **Hotel & Stay**, and 👋 **Basics & Greetings**.
- **Zero-Latency Offline Bundles:** Pre-bundled with offline translations in key global languages (Spanish, French, Hindi, Kannada, German, Japanese, etc.) for zero-connectivity scenarios.
- **Dynamic On-the-Fly Translation:** Translates the entire phrasebook into any of the 60+ supported languages with automatic in-memory caching.
- **Search & Category Filtering:** Instant search bar plus horizontal category filter chips with emoji badges.
- **Actionable Phrase Cards:** One-tap **Speak (TTS)**, **Fullscreen Traveler View**, **Copy**, **Save to Starred**, and **Send to Translate Screen**.
- **Two-Way Navigation Access:** Accessible via the **Travel Phrasebook 📖** quick chip on the Translate screen and as a dedicated tab in the History hub.

### **📸 Camera & Gallery Image OCR Translation**
- **Optical Character Recognition (OCR):** Powered by on-device Google ML Kit.
- **Integrated Image Cropper:** Built-in cropping, rotating, and aspect ratio tool (`image_cropper`) allowing users to isolate specific text areas, signs, or document sections before recognition.
- **Editable Extracted Text:** Edit OCR typos directly in the extracted text field before translating.
- **Multi-Script Support:** Latin, Devanagari (Hindi, Kannada, etc.), Chinese (Simplified & Traditional), Japanese, and Korean.
- **Rich Output Actions:** Displays Romanization alongside translated text with one-tap **Speak (TTS)**, **Copy**, **Fullscreen**, and **Share**.
- **Live History Sync:** Scanned text translations automatically persist to SQLite and immediately appear in the History tab.

### **⭐ Translation History & Starred Hub**
- **3-Way Hub Toggle:** Segmented button switching between `[ All History | Saved Starred | Phrasebook 📖 ]`.
- **Real-Time SQLite Persistence:** Translations from text, voice conversation, and image OCR modes automatically persist (`sqflite`) and sync live via `DatabaseService.onChanges`.
- **Swipe-to-Delete with Confirmation & Undo:** Sliding any history card displays an alert confirmation dialog before deletion, with an instant undo action snackbar.
- **Export to Plain Text:** Quick export buttons in History and Home AppBars to share or backup translation history via the system share sheet (`share_plus`).

### **⚙️ Settings & Persistent Preferences**
- **3-Way Material 3 Theme Selector:** Choose between **System**, **Light**, and **Dark** themes with automatic contrast adjustments.
- **Offline Language Pack Manager:** Manage on-device ML Kit models and offline preferences directly from Settings.
- **Persistent Preferences:** Automatically saves and restores last chosen language pairs, Instant Auto-Translate, offline preferences, voice speed, pitch, voice style, and theme mode using `shared_preferences`.
- **Customizable Speech Engine:** Adjust speech rate (0.5x–2.0x), voice pitch, and voice models (Natural, Male, Female, Robot) with a live test preview.
- **Overflow-Free About & FAQ:** Expandable FAQ accordion covering Text, Conversation, Camera OCR, and History.

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| **Frontend Framework** | Flutter 3.6+ / Dart 3.6+ |
| **Design System** | Material 3 (`useMaterial3: true`, dynamic seed color palettes) |
| **State Management** | Provider 6.1.2 |
| **Translation Engine** | 4-Tier Multi-Fallback (Google GTX + Romanization, `translator`, Chrome Dict, ML Kit Offline) |
| **Offline Translation** | Google ML Kit On-Device Translation (`google_mlkit_translation` 0.13.1) |
| **OCR Engine** | Google ML Kit Text Recognition (`google_mlkit_text_recognition` 0.15.1) |
| **Speech Recognition (STT)** | `speech_to_text` 7.0.0 (with `SpeechListenOptions`) |
| **Text-to-Speech (TTS)** | `flutter_tts` 4.2.2 (with slow 0.52x and normal rates) |
| **Local Persistence** | `shared_preferences` 2.3.2 & `sqflite` 2.4.1 |
| **Native Sharing & Export** | `share_plus` 10.1.2 |
| **Image Handling & Cropping** | `image_picker` 1.2.1 & `image_cropper` 13.0.0 |
| **Tactile Feedback** | `HapticFeedback` (`lightImpact`, `selectionClick`, `mediumImpact`) |
| **Networking** | `http` 1.3.0 |

---

## 📂 Project Architecture

For complete architectural layer diagrams and pipeline workflows, see **[ARCHITECTURE.md](ARCHITECTURE.md)**.

```
lib/
├── main.dart                          # App entry point & multi-provider configuration
├── data/                              # Static & Curated Data
│   └── phrasebook_data.dart           # 34 survival phrases, categories & offline translations
├── models/                            # Data Models
│   └── history_item.dart              # SQLite translation history & favorite item model
├── screens/                           # User Interface Screens
│   ├── home_screen.dart              # M3 NavigationBar shell with IndexedStack
│   ├── translate_screen.dart         # Text translation, clipboard banner, offline fallback
│   ├── speech_screen.dart            # Tabletop 180° Face-to-Face & handheld voice mode
│   ├── imagetext_screen.dart         # ML Kit camera/gallery OCR & cropping
│   ├── history_screen.dart           # 3-way hub: History, Saved phrases & Phrasebook
│   ├── phrasebook_screen.dart        # Standalone & embedded Travel Phrasebook view
│   ├── fullscreen_text_screen.dart   # High-contrast fullscreen flashcard display
│   ├── setting_screen.dart           # 3-way theme selector, offline & speech settings
│   ├── offline_languages_screen.dart # On-device ML Kit language pack manager & toggles
│   ├── speechsetting_screen.dart     # Pitch, rate, voice model, and language config
│   ├── abouthelp_screen.dart         # Expandable FAQs and support
│   └── welcome_screen.dart           # Onboarding splash screen
├── provider/                          # State Management
│   ├── translator_provider.dart      # Translation, speech orchestration & audio streams
│   ├── history_provider.dart         # SQLite history & starred phrasebook state
│   ├── image_text_provider.dart      # OCR scanning and recognition pipeline
│   └── theme_provider.dart           # Theme mode management & persistence
├── services/                          # Core Business Logic
│   ├── translator_service.dart       # 4-tier resilient engine (Romanization, Auto-Detect, Offline)
│   ├── offline_translation_service.dart # ML Kit on-device model manager & offline translator
│   ├── database_service.dart         # SQLite CRUD & live change stream (`onChanges`)
│   ├── text_recognition_service.dart # ML Kit on-device text recognizer
│   └── speech_service.dart           # STT, TTS (with slow 0.52x mode) & voice styles
├── component/                         # Reusable UI Widgets
│   ├── audio_waveform.dart           # Live decibel-reactive audio waveform visualizer
│   ├── custom_dropdown.dart          # Search modal bottom sheet with flags
│   ├── text_card.dart                # M3 card with selectable text, toolbar & slow audio
│   ├── ripple_iconbutton.dart        # Ripple feedback button
│   ├── elevation_button.dart         # Custom elevated button
│   └── dialog.dart                   # Language modal dialogs
└── utils/                             # Utilities & Constants
    ├── constant.dart                 # App constants & metadata
    ├── language.dart                 # Language codes, flag emojis, and scripts
    └── theme.dart                    # Material 3 light and dark theme data
```

---

## 🧪 Automated Testing Suite

TalkTranslo maintains a 100% passing test suite across unit, widget, and live service tests:

| Test File | Scope |
|---|---|
| `test/audio_waveform_test.dart` | Verifies resting state and active multi-bar waveform animations. |
| `test/history_model_test.dart` | Tests `TranslationHistoryItem` SQLite serialization and `copyWith`. |
| `test/preferences_persistence_test.dart` | Verifies settings serialization and persistence across simulated restarts. |
| `test/speech_utils_test.dart` | Validates BCP-47 locale resolution (`getTtsLocale`) and voice normalizations. |
| `test/speech_screen_test.dart` | Verifies 180° Face-to-Face rotation, in-card microphones, and central divider toolbar. |
| `test/offline_translation_test.dart` | Verifies ML Kit language mapping, online-only partitioning, and `OfflineLanguagesScreen` UI. |
| `test/phrasebook_test.dart` | Tests survival phrase data, category filtering, search, and History tab switching. |
| `test/translation_service_test.dart` | Live integration tests for translation, Romanization, Auto-Detect, swap, and OCR state. |
| `test/widget_test.dart` | Smoke tests verifying onboarding navigation and HomeScreen shell rendering. |

To run the complete test suite:
```bash
flutter test
```

---

## 🗺️ Roadmap & Milestones

For architectural roadmaps and future plans, see [FUTURE_ROADMAP.md](FUTURE_ROADMAP.md).

- [x] **Phase 1:** Immediate Stabilization (Camera OCR auto-trigger, TTS locale alignment, dark mode text contrast).
- [x] **Phase 2:** Material 3 UI/UX Transformation (M3 NavigationBar, flag modal sheets, animated language swap, audio visualizer).
- [x] **Phase 3:** Persistence & SQLite History (Database storage, Starred phrases, `share_plus` text/CSV export, swipe-to-delete confirmation).
- [x] **Phase 4:** Image Cropper & OCR Isolation Tool (`image_cropper` with rotation and aspect ratio presets).
- [x] **Tier 1 Standout Features:**
  - [x] Auto-Detect Source Language ("Auto Detect ✨").
  - [x] Fullscreen Traveler / Flashcard Display Mode (`FullscreenTextScreen`).
  - [x] History & Starred Phrasebook Export (Plain Text & CSV).
  - [x] Tactile Haptic Feedback across all core interactions.
- [x] **Tier 2 Standout Features:**
  - [x] Tabletop Face-to-Face 180° Inverted Conversation Mode with in-card mics and central toolbar.
  - [x] Curated Offline Travel & Survival Phrasebook (34 phrases, 5 categories, offline bundles).
  - [x] Clipboard Quick-Translate Banner.
  - [x] Slow Pronunciation Mode (🐢 0.6x).
  - [x] Graceful Offline Status Banner & Phrasebook Fallback.
- [x] **Tier 3 Standout Features & Offline Engine:**
  - [x] True On-Device Offline Translation (`google_mlkit_translation`) with user-controlled `OfflineLanguagesScreen` (Auto Fallback, Prefer Offline, Wi-Fi Only).
  - [x] Pronunciation / Romanization Guide (`&dt=rm`) across Translate, Fullscreen, and Camera OCR.
  - [x] Instant Debounced Auto-Translate (`Instant ⚡`) toggle.
  - [x] Editable OCR Extracted Text + Fullscreen & Share actions.
  - [x] Material 3 3-Way Theme Selector (`System | Light | Dark`).
  - [x] Full Korean support across Text, Speech, and OCR + real-time SQLite History sync.
- [x] **Release Readiness (Production Hardening):** Production package rename (`com.talktranslo.app`), app label formatting (`TalkTranslo`), custom ProGuard / R8 code & resource shrinking rules (`proguard-rules.pro`), and verified release APK compilation (`app-release.apk`).

---

## 🚀 Building for Release

To compile an optimized, minified, and resource-shrunk Android release APK:
```bash
flutter build apk --release
```
The resulting production APK is output to `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📝 License

This project is open-source under the [MIT License](LICENSE).
