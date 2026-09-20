# 🤖 Tanishk's AI Bot — Multiplatform App

Smart AI Voice Calling & WhatsApp Business Assistant for Android, iOS, and Web (Chrome).

---

## 📥 Direct Click-to-Run Links

| Platform | Direct Action Link | Details |
| :--- | :--- | :--- |
| 📱 **Android Phone** | 👉 **[Click Here to Download Android APK](https://github.com/TanishkSudani/tanishk_ai_bot/raw/main/releases/tanishk_ai_bot_v1.0.apk)** | Direct download & install on Android *(21.3 MB)* |
| 🌐 **Web (Chrome / Browser)** | 👉 **[Click Here to Open & Run in Browser](https://tanishksudani.github.io/tanishk_ai_bot/)** | Instant full-featured web app in any browser |
| 🍏 **iPhone / iOS** | 👉 **[Click Here to Run in your iPhone](https://tanishksudani.github.io/tanishk_ai_bot/)** | Opens in Safari → Tap Share → Add to Home Screen |
| 📦 **iOS Native IPA** | 👉 **[Click Here to Download iOS .IPA Package](https://github.com/TanishkSudani/tanishk_ai_bot/actions)** | Cloud-built native IPA package from GitHub Actions |

---

### 📱 1. Android (APK)
Download the ready-to-install Android Release APK directly on your phone:
- 🚀 **[Click Here to Download Android APK (v1.0.0)](https://github.com/TanishkSudani/tanishk_ai_bot/raw/main/releases/tanishk_ai_bot_v1.0.apk)** *(Size: 21.3 MB)*
- Once downloaded on your Android phone, tap the file and click **Install**.

---

### 🌐 2. Web (Chrome / Edge / Firefox)
Use the app directly in your desktop or mobile browser without any installation:
- 🚀 **[Click Here to Open & Run in Browser](https://tanishksudani.github.io/tanishk_ai_bot/)**

---

### 🍏 3. iPhone / iOS Guide (Complete Step-by-Step)

To run on your iPhone or iPad:
- 🚀 **[Click Here to Run in your iPhone](https://tanishksudani.github.io/tanishk_ai_bot/)**

#### 🔹 Method A: Instant Home Screen App (PWA — Recommended for All iPhone Users)
*No Mac or Apple Developer Account needed. Works on 100% of iPhones:*
1. Open 👉 **[https://tanishksudani.github.io/tanishk_ai_bot/](https://tanishksudani.github.io/tanishk_ai_bot/)** in **Safari** on your iPhone.
2. Tap the **Share** button at the bottom of the screen (square box with an arrow pointing up).
3. Scroll down in the menu and tap **"Add to Home Screen"** (`+`).
4. Tap **"Add"** in the top right corner.
5. **Done!** The **Tanishk AI Bot** app icon will appear directly on your iPhone home screen. When tapped, it opens in full-screen mode like an App Store app with smooth animations, no browser bars, and full functionality!

#### 🔹 Method B: Cloud-Built iOS Package (.IPA from GitHub Actions)
*Built automatically using GitHub's macOS cloud servers:*
1. Go to the [Actions Tab](https://github.com/TanishkSudani/tanishk_ai_bot/actions) in this repository.
2. Click on the latest workflow run: **Flutter Multiplatform Build**.
3. Under the **Artifacts** section at the bottom, download **`ios-ipa-build`**.
4. Extract the ZIP to get `tanishk_ai_bot_ios.ipa`.
5. Sideload onto any iPhone using tools like **AltStore**, **Sideloadly**, or **Apple Configurator**.

#### 🔹 Method C: Running Locally on Mac / Xcode (For Developers)
*If you have a Mac laptop/desktop:*
```bash
git clone https://github.com/TanishkSudani/tanishk_ai_bot.git
cd tanishk_ai_bot
flutter pub get
open ios/Runner.xcworkspace
```
Select your connected iPhone or iOS Simulator in Xcode and press **▶ Run** (or run `flutter run -d ios`).

---

### 🌐 3. Web (Chrome / Browser)
Use the app directly in your desktop or mobile browser without any installation:
- Run locally with `flutter run -d chrome --web-port=1000` or host on GitHub Pages/Firebase.

---

## ✨ Features

- 📞 **Interactive Live AI Voice Calling**: Real-time microphone audio capture, natural conversational responses, and Text-to-Speech (TTS) voice synthesis.
- 🤖 **Google Gemini & Cloud AI**: Direct Gemini 1.5/2.0 Flash reasoning engine with built-in instant multilingual business fallback.
- 🔴 **Live Call Monitoring**: Dynamic frequency audio waveform visualizer synced to speech, live transcripts, mute mic, and call hold controls.
- 💚 **Instant WhatsApp Summaries**: 1-Tap automated dispatch of formatted call summaries & action items to the business owner.
- 🌐 **True Multilingual Intelligence**: Auto-detects caller language (Gujarati ગુજરાતી, Hindi हिन्दी, English).
- 🚀 **Deployment Hub**: Twilio voice webhook connector and live incoming call simulator.
- ⚙️ **AI Settings**: Persistent credentials for Gemini API, Twilio, Anthropic Claude, and Deepgram.

---

## 🛠️ Professional Project Structure

```text
tanishk_ai_bot/
├── lib/
│   ├── config/                ← Design tokens, colors & system constants
│   │   ├── app_colors.dart    ← High-contrast dark theme & neon gradients
│   │   └── app_constants.dart ← Endpoints, sample data & exports
│   ├── models/                ← Data models with full JSON serialization
│   │   ├── call_model.dart    ← Historical call record model
│   │   ├── call_session_state.dart ← Live call status & caller profiles
│   │   ├── transcript_model.dart   ← Timestamped live speech transcript
│   │   └── ai_settings_model.dart  ← App settings & cloud API credentials
│   ├── services/              ← Core business logic & AI voice services
│   │   ├── ai_service.dart    ← Multilingual Gemini AI & prompt engine
│   │   ├── tts_service.dart   ← Text-to-Speech audio engine
│   │   ├── speech_service.dart← Microphone speech recognition (STT)
│   │   ├── call_session_service.dart ← Live call orchestrator & state machine
│   │   ├── storage_service.dart    ← SharedPreferences call history & settings
│   │   └── whatsapp_service.dart   ← WhatsApp digest deep linking & clipboard
│   ├── widgets/               ← Reusable UI components
│   │   ├── live_waveform.dart ← Dynamic reactive audio visualizer
│   │   ├── live_call_card.dart← Active call monitor widget
│   │   ├── call_list_tile.dart← Polished call list entry with badges
│   │   └── stat_card.dart     ← Dashboard analytics card
│   ├── screens/               ← Primary application screens
│   │   ├── splash_screen.dart ← Animated branding launch
│   │   ├── home_screen.dart   ← Bottom navigation shell
│   │   ├── dashboard_screen.dart ← Live business metrics & active call card
│   │   ├── live_screen.dart   ← Comprehensive interactive Live AI Call screen
│   │   ├── calls_screen.dart  ← Call history with dynamic storage binding
│   │   ├── chat_screen.dart   ← Call details & transcript review
│   │   ├── deploy_screen.dart ← Twilio webhook config & live simulator
│   │   └── settings_screen.dart ← AI API credentials & bot identity
│   └── main.dart              ← Application entry point & service bootstrap
├── assets/                    ← Branding assets and icons
├── android/                   ← Production Android runner
├── ios/                       ← Production iOS runner
├── web/                       ← Production Web runner (Chrome)
├── releases/                  ← Compiled release binaries (APK)
├── pubspec.yaml               ← Dependencies & metadata
└── README.md                  ← Comprehensive project documentation
```

---

## 💻 Developer Setup & Running

```bash
# Clone the repository
git clone https://github.com/TanishkSudani/tanishk_ai_bot.git
cd tanishk_ai_bot

# Install Flutter dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build Android APK
flutter build apk --release
```
