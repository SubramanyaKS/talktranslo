# 📢 TalkTranslo - Multi-Language Translator & Voice Conversation App

**TalkTranslo** is a modern, Flutter-based translation application designed for seamless multilingual communication. It features real-time text translation with a 3-tier resilient fallback engine, two-way split-screen voice conversation mode, optical character recognition (OCR) via Google ML Kit, multilingual text-to-speech, full Material 3 dynamic theming, and persistent user preferences.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6+-00B4AB?logo=dart)
![Material 3](https://img.shields.io/badge/Material--3-Enabled-7C3AED)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

</div>

---

## 🚀 Key Features

### **📝 Modern Text Translation**
- **20+ Supported Languages:** Indian languages (Kannada, Hindi, Tamil, Telugu, Malayalam, Bengali, etc.) and global languages (English, Spanish, French, German, Japanese, Chinese, etc.).
- **3-Tier Resilient Engine:** Automatic failover across primary and fallback Google translation APIs with locale normalization.
- **Interactive Language Picker:** Search modal bottom sheet displaying national flags with instant search filtering.
- **Animated Language Swap:** Smooth 180° rotation that swaps active source/target languages and input/output text simultaneously.
- **Bottom Action Toolbar:** Quick buttons for **Copy**, **Clear (✕)**, **Paste from Clipboard**, **Speak (TTS)**, and **Share**.
- **Live Character Counter:** Displays character length in real-time.

### **🎙️ Dual Split-Screen Voice Conversation Mode**
- **Two-Way Spoken Conversation:** Dedicated top/bottom cards for Speaker 1 and Speaker 2 for natural face-to-face dialogue.
- **Dual Microphone Action Dock:** Two thumb-friendly microphone buttons labeled with language flags.
- **Live Animated Audio Waveform:** Real-time dancing soundwave visualizer responding to mic amplitude and speech cadence in the dock and active speaker card.
- **Real-Time Live Transcripts:** Transcribes speech as you talk with animated voice glows.
- **Automatic Translation & Audio Playback:** Auto-translates upon silence detection or manual tap and speaks the translation aloud.
- **Pronunciation Replay:** Audio volume buttons on both speaker cards to replay translations anytime.

### **📸 Camera & Gallery Image OCR Translation**
- **Optical Character Recognition (OCR):** Powered by on-device Google ML Kit.
- **Integrated Image Cropper:** Built-in cropping, rotating, and aspect ratio tool (`image_cropper`) allowing users to isolate specific text areas, signs, or document sections before recognition.
- **Multi-Script Support:** Latin, Devanagari (Hindi, Kannada, etc.), Chinese (Simplified & Traditional), Japanese, and Korean.
- **Instant Recognition:** Image capture via Camera or Gallery automatically triggers text detection and translation.
- **Optimized Performance:** Pre-configured image compression (`maxWidth: 1200`, `imageQuality: 40`) for rapid OCR processing.
- **Persistent State:** Scanned images and extracted text persist across tab switches without resetting.

### **⭐ Translation History & Starred Phrasebook**
- **Automatic SQLite Persistence:** Translations from text and voice conversation modes automatically save to local database storage (`sqflite`).
- **Starred Phrases (Phrasebook):** Bookmark frequently used phrases with one tap for quick offline access.
- **Instant Search & Filter Chips:** Fast text search across source and translated phrases, with segmented tabs for "All" and "Starred".
- **Swipe-to-Delete with Undo:** Clean dismissible swipe actions to remove individual items with an instant undo action snackbar.
- **Card Actions:** Pronounce translations with TTS, copy text to clipboard, and share formatted translations natively via `share_plus`.

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
| **Text-to-Speech (TTS)** | `flutter_tts` 4.2.2 |
| **Local Persistence** | `shared_preferences` 2.3.2 & `sqflite` 2.4.1 |
| **Native Sharing** | `share_plus` 10.1.2 |
| **Image Handling & Cropping** | `image_picker` 1.2.1 & `image_cropper` 13.0.0 |
| **Networking** | `http` 1.3.0 |

---

## 📱 Supported Languages & Scripts

### Translation Languages (20+)
🇸🇦 Arabic (`ar`) • 🇮🇳 Assamese (`as`) • 🇧🇩 Bengali (`bn`) • 🇨🇳 Chinese Simplified (`zh-cn`) • 🇹🇼 Chinese Traditional (`zh-tw`) • 🇺🇸 English (`en`) • 🇫🇷 French (`fr`) • 🇩🇪 German (`de`) • 🇮🇳 Gujarati (`gu`) • 🇮🇱 Hebrew (`iw`) • 🇮🇳 Hindi (`hi`) • 🇯🇵 Japanese (`ja`) • 🇮🇳 Kannada (`kn`) • 🇮🇳 Konkani (`gom`) • 🇰🇷 Korean (`ko`) • 🇮🇳 Malayalam (`ml`) • 🇷🇺 Russian (`ru`) • 🇮🇳 Sanskrit (`sa`) • 🇪🇸 Spanish (`es`) • 🇮🇳 Tamil (`ta`) • 🇮🇳 Telugu (`te`) • 🇹🇭 Thai (`th`)

### Text Recognition Scripts (Google ML Kit)
- **Latin:** English, French, Spanish, German, Russian, Arabic, Hebrew, Thai
- **Devanagari:** Hindi, Kannada, Tamil, Telugu, Sanskrit, Assamese, Bengali, Gujarati, Konkani, Malayalam
- **Chinese:** Simplified & Traditional
- **Japanese:** Hiragana, Katakana, Kanji
- **Korean:** Hangul

---

## 📋 System Requirements & Permissions

### System Requirements
- **Flutter SDK:** 3.6.0 or higher
- **Dart SDK:** 3.6.0 or higher
- **Android:** API level 24+ (Android 7.0 to Android 15)
- **iOS:** iOS 12.0 or higher

### Permissions Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />

<!-- Required for Android 11+ Package Visibility -->
<queries>
    <intent>
        <action android:name="android.speech.RecognitionService" />
    </intent>
    <intent>
        <action android:name="android.intent.action.TTS_SERVICE" />
    </intent>
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT"/>
        <data android:mimeType="text/plain"/>
    </intent>
</queries>
```

#### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to capture text for OCR translation.</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app requires microphone access to record your voice for translation.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This app requires speech recognition to transcribe your voice for translation.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires photo library access to select images for translation.</string>
```

---

## 📌 Installation & Setup

### **1️⃣ Clone the Repository**
```bash
git clone https://github.com/SubramanyaKS/talktranslo.git
cd talktranslo
```

### **2️⃣ Install Dependencies**
```bash
flutter pub get
```

### **3️⃣ Run the Test Suite**
Verify that all unit tests and live translation integration tests pass:
```bash
flutter test
```

### **4️⃣ Run the App**
```bash
# Run on connected device or emulator
flutter run
```

---

## 📂 Project Architecture

For the complete technical breakdown, layer diagrams, and data flow pipelines, see **[ARCHITECTURE.md](ARCHITECTURE.md)**.

```
lib/
├── main.dart                          # App entry point & multi-provider configuration
├── models/                            # Data Models
│   └── history_item.dart              # Translation history & favorite item model
├── screens/                           # User Interface Screens
│   ├── home_screen.dart              # M3 NavigationBar shell with IndexedStack
│   ├── translate_screen.dart         # Text translation with animated swap & toolbars
│   ├── speech_screen.dart            # Split-screen dual voice conversation mode
│   ├── imagetext_screen.dart         # ML Kit camera/gallery OCR & translation
│   ├── history_screen.dart           # Searchable history & starred phrasebook
│   ├── setting_screen.dart           # Appearance, speech settings, and app info
│   ├── speechsetting_screen.dart     # Pitch, rate, voice model, and language config
│   ├── abouthelp_screen.dart         # Expandable FAQs and support
│   └── welcome_screen.dart           # Onboarding splash screen
├── provider/                          # State Management
│   ├── translator_provider.dart      # Translation, speech, and preferences state
│   ├── history_provider.dart         # SQLite history & starred phrasebook state
│   ├── image_text_provider.dart      # OCR scanning and recognition pipeline
│   └── theme_provider.dart           # Theme mode management & persistence
├── services/                          # Core Business Logic
│   ├── translator_service.dart       # 3-tier resilient translation engine
│   ├── database_service.dart         # SQLite CRUD & database helper
│   ├── text_recognition_service.dart # ML Kit on-device text recognizer
│   └── speech_service.dart           # Speech-to-Text & Text-to-Speech service
├── component/                         # Reusable UI Widgets
│   ├── custom_dropdown.dart          # Search modal bottom sheet with flags
│   ├── text_card.dart                # M3 card with selectable text & bottom toolbar
│   ├── ripple_iconbutton.dart        # Ripple feedback button
│   ├── elevation_button.dart         # Custom elevated button
│   └── dialog.dart                   # Language modal dialogs
└── utils/                             # Utilities & Constants
    ├── constant.dart                 # App constants & metadata
    ├── language.dart                 # Language codes, flag emojis, and scripts
    └── theme.dart                    # Material 3 light and dark theme data
```

---

## 🗺️ Future Roadmap & Planned Upgrades

For the complete architectural roadmap, milestones, and upcoming feature checklist, see [FUTURE_ROADMAP.md](FUTURE_ROADMAP.md).

- [x] **Phase 1:** Immediate Stabilization & Bug Squashing (Fixed camera OCR trigger, TTS language mismatch, dark theme text contrast, deprecated APIs).
- [x] **Phase 2:** Material 3 UI/UX Transformation (M3 NavigationBar, flag search modal sheets, animated language swap, bottom toolbars, split-screen conversation mode).
- [x] **Phase 3:** Persistence, History & Phrasebook (`shared_preferences` settings persistence, SQLite history database, Starred Phrasebook, `share_plus` native export).
- [x] **Phase 4 (In Progress):** Image Cropper & Isolation Tool (`image_cropper`) & Real-Time Audio Waveform Visualizer.
- [ ] **Phase 4 (Next):** On-device offline translation via `google_mlkit_translation` and Gemini AI contextual translation.

---

## 📝 License

This project is open-source under the [MIT License](LICENSE).

---

## 📧 Contact & Support

- **Author:** [Subramanya KS](https://github.com/SubramanyaKS)
- **Issues:** [GitHub Issues](https://github.com/SubramanyaKS/talktranslo/issues)

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repository if you found it helpful!

</div>
