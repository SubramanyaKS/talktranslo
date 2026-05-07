# 📢 TalkTranslo - Multi-Language Translator & Speech App

**TalkTranslo** is a comprehensive Flutter-based translator application that supports real-time text translation, voice translation, image text recognition and translation, and multi-language text-to-speech capabilities. Perfect for breaking language barriers with a user-friendly interface.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.6+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.6+-00B4AB?logo=dart)
![License](https://img.shields.io/badge/License-Open%20Source-green)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-brightgreen)

</div>

---

## 🚀 Features

### **📝 Text Translation**
- Translate text between 20+ languages
- Support for Indian languages (Kannada, Tamil, Telugu, Hindi, etc.)
- Supports European languages (English, French, German, Spanish, Russian, etc.)
- Real-time translation with error handling
- Timeout protection (15-second limit)

### **🎤 Voice Translation**
- Convert speech to text in multiple languages
- Automatic translation of recognized text
- Text-to-speech playback in target language
- Adjustable speech rate and pitch
- Multiple voice options (Male, Female, Robot)

### **📸 Image Text Recognition & Translation**
- Optical Character Recognition (OCR) using Google ML Kit
- Support for multiple text scripts:
  - Latin (English, French, Spanish, etc.)
  - Devanagari (Hindi, Kannada, Tamil, Telugu, etc.)
  - Chinese (Simplified & Traditional)
  - Japanese
  - Korean
- Automatic text detection and translation
- Image capture from camera or gallery

### **⚙️ Settings & Customization**
- Language preference selection
- Voice and speech settings
- Adjustable pitch and speed
- Theme customization

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| **Frontend** | Flutter 3.6+ |
| **Language** | Dart |
| **State Management** | Provider 6.1.2 |
| **Translation API** | google_mlkit_text_recognition 0.15.1 |
| **OCR Engine** | Google ML Kit Text Recognition |
| **Speech Recognition** | speech_to_text 7.0.0 |
| **Text-to-Speech** | flutter_tts 4.2.2 |
| **Image Handling** | image_picker 1.2.1 |
| **Networking** | http 1.3.0, translator 1.0.3 |
| **UI Components** | Material Design |

---

## 📱 Supported Languages

### Translation Languages (20+)
Arabic, Assamese, Bengali, Chinese (Simplified & Traditional), English, French, German, Gujarati, Hebrew, Hindi, Japanese, Kannada, Konkani, Malayalam, Russian, Sanskrit, Spanish, Tamil, Telugu, Thai

### Text Recognition Scripts
- **Latin** - English, French, Spanish, German, Russian, Arabic, Hebrew, Thai
- **Devanagari** - Hindi, Kannada, Tamil, Telugu, Sanskrit, Assamese, Bengali, Gujarati, Konkani, Malayalam
- **Chinese** - Simplified & Traditional
- **Japanese** - Hiragana, Katakana, Kanji
- **Korean** - Hangul

---

## 📋 Requirements

### System Requirements
- Flutter SDK: 3.6.0 or higher
- Dart SDK: 3.6.0 or higher
- Android: API level 24 or higher
- iOS: 11.0 or higher

### Permissions Required
#### Android
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### iOS
```xml
NSCameraUsageDescription
NSMicrophoneUsageDescription
NSPhotoLibraryUsageDescription
NSPhotoLibraryAddUsageDescription
```

---

## 📌 Installation & Setup

### **1️⃣ Prerequisites**
Ensure you have Flutter installed. If not, download from [flutter.dev](https://flutter.dev/docs/get-started/install)

### **2️⃣ Clone the Repository**
```bash
git clone https://github.com/SubramanyaKS/talktranslo.git
cd talktranslo
```

### **3️⃣ Install Dependencies**
```bash
flutter pub get
```

### **4️⃣ Configure Permissions**

#### Android (`android/app/build.gradle`)
```gradle
android {
    compileSdkVersion 34
    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }
}
```

#### iOS (`ios/Podfile`)
```ruby
platform :ios, '11.0'
```

### **5️⃣ Run the App**

**On Android:**
```bash
flutter run
```

**On iOS:**
```bash
flutter run
```

**With specific device:**
```bash
flutter run -d <device_id>
```

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── screens/                           # UI Screens
│   ├── home_screen.dart              # Home/Main screen
│   ├── translate_screen.dart         # Text translation screen
│   ├── speech_screen.dart            # Voice translation screen
│   ├── imagetext_screen.dart         # Image text recognition & translation
│   ├── setting_screen.dart           # Settings screen
│   ├── abouthelp_screen.dart         # About & Help section
│   └── welcome_screen.dart           # Onboarding/Welcome screen
├── provider/                          # State Management
│   ├── translator_provider.dart      # Text/Speech translation state
│   ├── image_text_provider.dart      # Image recognition state
│   └── theme_provider.dart           # Theme state management
├── services/                          # Business Logic
│   ├── translator_service.dart       # Translation API integration
│   ├── text_recognition_service.dart # OCR/ML Kit integration
│   └── speech_service.dart           # Speech recognition & TTS
├── component/                         # Reusable UI Components
│   ├── custom_dropdown.dart          # Custom dropdown widget
│   ├── text_card.dart                # Text card component
│   ├── ripple_iconbutton.dart        # Ripple effect button
│   ├── elevation_button.dart         # Elevated button
│   ├── texticon_button.dart          # Text + Icon button
│   └── dialog.dart                   # Custom dialogs
└── utils/                             # Utilities
    └── language.dart                 # Language mappings & constants
```

---

## 🔧 How to Use

### **Text Translation**
1. Open the app and navigate to "Translate" tab
2. Enter text to translate
3. Select target language
4. View translated result
5. Tap volume icon to hear translation

### **Voice Translation**
1. Go to "Speech" tab
2. Select source and target languages
3. Tap mic icon to start listening
4. Speak in the selected language
5. View and hear the translated text

### **Image Text Translation**
1. Navigate to "Image Text" tab
2. Select source language (text in image) and target language
3. Tap camera icon to capture or photo icon to select from gallery
4. App automatically recognizes and translates text
5. View recognized and translated text

---

## ⚠️ Recent Bug Fixes (v1.0)

- ✅ Fixed translation crash on network timeout
- ✅ Added 15-second timeout for translation requests
- ✅ Improved error handling in text recognition
- ✅ Added permission error handling for camera access
- ✅ Disabled translate button when no text is recognized
- ✅ Enhanced debugging with detailed error messages

---

## 🚀 Future Enhancements

- 🎨 Dark Mode Support
- 💾 Offline Translation Cache
- 🔤 Support for more languages and scripts
- 🎯 Improved OCR accuracy
- 🌙 Night Mode Theme
- 📊 Translation History
- 🔤 Advanced Text Formatting
- 📤 Share & Export Features

---

## 🐛 Known Issues & Limitations

- Hebrew and Thai text recognition may have limited accuracy
- Translation requires active internet connection
- OCR accuracy depends on image quality and lighting
- Large image processing may take longer

---

## 📝 License

This project is **open-source** and free to use under the MIT License. Feel free to contribute!

---

## 🤝 Contributing

We welcome contributions! Follow these steps:

1. **Fork the repository**
   ```bash
   git clone https://github.com/SubramanyaKS/talktranslo.git
   cd talktranslo
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make your changes and commit**
   ```bash
   git commit -m "Add amazing feature"
   ```

4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```

5. **Open a Pull Request** with detailed description

---

## 🐞 Bug Reports & Feature Requests

Found a bug or have a feature request? Open an [issue](https://github.com/SubramanyaKS/talktranslo/issues) with:
- Description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Device/OS information

---

## 📧 Contact & Support

- **Email:** connectwithsubbu@gmail.com
- **Twitter:** [@developersubbu](https://x.com/)
- **Issues:** [GitHub Issues](https://github.com/SubramanyaKS/talktranslo/issues)

---

## 🙏 Acknowledgments

- **Google ML Kit** - For powerful OCR capabilities
- **Flutter Team** - For the amazing framework
- **Open Source Community** - For all the wonderful packages

---

<div align="center">

**Made with ❤️ by [Subramanya KS](https://github.com/SubramanyaKS)**

⭐ Star this repo if you found it helpful!

</div>