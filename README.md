# 📢 TalkTranslo - Multi-Language Translator & Voice Conversation App

**TalkTranslo** is a modern, production-grade Flutter translation application designed for seamless multilingual communication. It features real-time text translation with a 3-tier resilient fallback engine, **Auto-Detect Language ("Auto Detect ✨")**, tabletop **Face-to-Face (180° Inverted)** conversation mode, an offline **Travel & Survival Phrasebook**, optical character recognition (OCR) via Google ML Kit, **Fullscreen Traveler Mode**, **Clipboard Quick-Translate**, **Slow Pronunciation Mode (🐢 0.6x)**, multilingual text-to-speech, tactile haptic feedback, full Material 3 dynamic theming, and persistent SQLite database history.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6+-00B4AB?logo=dart)
![Material 3](https://img.shields.io/badge/Material--3-Enabled-7C3AED)
![License](https://img.shields.io/badge/License-MIT-green)
![Tests](https://img.shields.io/badge/Tests-26%20Passing-success)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

</div>

---

## 🚀 Key Features

### **📝 Modern Text Translation**
- **20+ Supported Languages:** Indian languages (Kannada, Hindi, Tamil, Telugu, Malayalam, Bengali, Gujarati, Marathi, etc.) and global languages (English [US & IN], Spanish, French, German, Japanese, Chinese, Russian, Arabic, etc.).
- **Auto-Detect Source Language ("Auto Detect ✨"):** Automatically recognizes the input language across all translation endpoints without manual configuration.
- **3-Tier Resilient Engine:** Automatic failover across primary and fallback Google translation APIs (GTX single and Chrome Dict endpoints) with locale normalization.
- **Clipboard Quick-Translate Banner:** Automatically detects copied text from other apps (WhatsApp, Chrome, Mail) and provides a one-tap translate pill.
- **Offline Survival Fallback:** If internet is unavailable, typed text automatically matches against the offline survival dictionary for instant zero-latency translation.
- **Slow Pronunciation Mode (🐢 0.6x):** Dedicated turtle speed button on translation cards for language learners and travelers to hear difficult words enunciated slowly.
- **Interactive Language Picker:** Search modal bottom sheet displaying national flags with instant search filtering.
- **Animated Language Swap:** Smooth 180° rotation that swaps active source/target languages and input/output text simultaneously (with auto-detect swap protection).
- **Fullscreen Traveler Mode:** Giant bold, dynamically scaling text screen designed for showing taxi drivers, store clerks, or passersby across counters.
- **Bottom Action Toolbar:** Quick buttons for **Voice Dictation (Mic)**, **Copy**, **Clear (✕)**, **Paste from Clipboard**, **Speak (TTS)**, **Slow Speak (🐢)**, **Fullscreen**, and **Share**.
- **Tactile Haptic Feedback:** Light and selection clicks on mic taps, language swaps, copy, clear, and favorite toggles.

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
- **Multi-Script Support:** Latin, Devanagari (Hindi, Kannada, etc.), Chinese (Simplified & Traditional), Japanese, and Korean.
- **Instant Recognition:** Image capture via Camera or Gallery automatically triggers text detection and translation.
- **Auto-Saved to History:** Scanned text translations automatically persist into the SQLite database history.
- **Persistent State:** Scanned images and extracted text persist across tab switches without resetting.

### **⭐ Translation History & Starred Hub**
- **3-Way Hub Toggle:** Segmented button switching between `[ All History | Saved Starred | Phrasebook 📖 ]`.
- **Automatic SQLite Persistence:** Translations from text, voice conversation, and image OCR modes automatically persist to local SQLite database storage (`sqflite`).
- **Swipe-to-Delete with Confirmation & Undo:** Sliding any history card displays an alert confirmation dialog before deletion, with an instant undo action snackbar.
- **Export to Plain Text & CSV:** Quick export buttons in History and Home AppBars to share or backup translation history via the system share sheet (`share_plus`).

### **⚙️ Settings & Persistent Preferences**
- **Persistent Preferences:** Automatically saves and restores last chosen language pairs, voice speed, pitch, voice style, and theme mode using `shared_preferences`.
- **Material 3 Dynamic Theming:** Full support for Light and Dark modes with automatic contrast adjustments.
- **Customizable Speech Engine:** Adjust speech rate (0.5x–2.0x), voice pitch, and voice models (Male, Female, Robot) with a live test preview.
- **Overflow-Free About & FAQ:** Expandable FAQ accordion and support links.

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| **Frontend Framework** | Flutter 3.6+ / Dart 3.6+ |
| **Design System** | Material 3 (`useMaterial3: true`, dynamic seed color palettes) |
| **State Management** | Provider 6.1.2 |
| **Translation Engine** | 3-Tier Multi-Fallback (`translator` + Google GTX & Chrome Dict APIs) |
| **OCR Engine** | Google ML Kit Text Recognition (`google_mlkit_text_recognition`) |
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
│   ├── setting_screen.dart           # Appearance, speech settings, and app info
│   ├── speechsetting_screen.dart     # Pitch, rate, voice model, and language config
│   ├── abouthelp_screen.dart         # Expandable FAQs and support
│   └── welcome_screen.dart           # Onboarding splash screen
├── provider/                          # State Management
│   ├── translator_provider.dart      # Translation, speech orchestration & audio streams
│   ├── history_provider.dart         # SQLite history & starred phrasebook state
│   ├── image_text_provider.dart      # OCR scanning and recognition pipeline
│   └── theme_provider.dart           # Theme mode management & persistence
├── services/                          # Core Business Logic
│   ├── translator_service.dart       # 3-tier resilient translation engine (with Auto-Detect)
│   ├── database_service.dart         # SQLite CRUD & database helper
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
| `test/phrasebook_test.dart` | Tests survival phrase data, category filtering, search, and History tab switching. |
| `test/translation_service_test.dart` | Live integration tests translating across English, Kannada, Hindi, and Spanish. |
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
