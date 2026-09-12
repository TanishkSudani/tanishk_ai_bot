# 🤖 Tanishk's AI Bot — Multiplatform App

Smart AI Voice Calling & WhatsApp Business Assistant for Android, iOS, and Web (Chrome).

---

## 📥 Direct Downloads & Links

### 📱 1. Android (APK)
Download the ready-to-install Android Release APK directly on your phone:
- 🚀 **[Click Here to Download APK (v1.0.0)](https://github.com/TanishkSudani/tanishk_ai_bot/raw/main/releases/tanishk_ai_bot_v1.0.apk)** *(Size: 21.3 MB)*
- Once downloaded on your Android phone, tap the file and click **Install**.

### 🍏 2. iPhone / iOS Guide (Complete Step-by-Step)

Because Apple restricts direct `.apk` downloads, you have **3 simple ways** to run this app on any iPhone or iPad:

#### 🔹 Method A: Instant Home Screen App (PWA — Recommended for All Users)
*No Mac or Apple Developer Account needed. Works on 100% of iPhones:*
1. Open the hosted Web App URL in **Safari** on your iPhone.
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

- 📞 **AI Voice Calling**: Auto-answers business calls with Twilio & Deepgram Nova-2 speech-to-text.
- 🔴 **Live Call Monitoring**: Real-time waveform visualizer, live Deepgram transcripts, and hold/mute controls.
- 💚 **Instant WhatsApp Summaries**: Dispatches concise, structured call summaries to the business owner.
- 🌐 **Multilingual**: Auto-detects caller language (Gujarati, Hindi, English, Tamil).
- 🚀 **Deployment Hub**: Twilio voice webhook connector and live incoming call simulator.
- ⚙️ **AI Settings**: Persistent credentials for Twilio, Anthropic Claude 3.5, and Deepgram.

---

## 🛠️ Project Structure

```text
tanishk_ai_bot/
├── lib/                   ← Main Flutter codebase (screens, widgets, models)
├── assets/                ← Assets and branding
├── android/               ← Production Flutter Android runner
├── ios/                   ← Production Flutter iOS runner
├── web/                   ← Production Flutter Web runner (Chrome)
├── releases/              ← Compiled release binaries (APK)
├── pubspec.yaml           ← Dependencies & metadata
└── README.md              ← Project overview & documentation
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
