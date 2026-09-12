# 🤖 Tanishk's AI Bot — Multiplatform App

Smart AI Voice Calling & WhatsApp Business Assistant for Android, iOS, and Web (Chrome).

---

## 📥 Direct Downloads & Links

### 📱 1. Android (APK)
Download the ready-to-install Android Release APK directly on your phone:
- 🚀 **[Click Here to Download APK (v1.0.0)](https://github.com/TanishkSudani/tanishk_ai_bot/raw/main/releases/tanishk_ai_bot_v1.0.apk)** *(Size: 21.3 MB)*
- Once downloaded on your Android phone, tap the file and click **Install**.

### 🌐 2. Web (Chrome / Browser)
Use the app directly in your desktop or mobile browser without any installation:
- Run locally with `flutter run -d chrome --web-port=1000` or host on GitHub Pages/Firebase.

### 🍏 3. iPhone / iOS (Web App / PWA)
- Open the Web app link in **Safari on your iPhone**.
- Tap the **Share** button at the bottom and select **"Add to Home Screen"**.
- The app icon will appear on your iPhone screen and run in full-screen like a native iOS app!

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
