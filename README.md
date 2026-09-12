# Tanishk's AI Bot — Android App

## Android Studio Ma Run Kevi Rite Karvu

### Step 1 — Zip Extract Karo
- `tanishk_ai_bot.zip` download karo
- Koi folder ma extract karo (e.g. `C:\Users\Tanishk\Projects\`)

### Step 2 — Android Studio Open Karo
- Android Studio open karo
- **"Open"** click karo (New Project nahi!)
- `tanishk_ai_bot` folder select karo → **OK**

### Step 3 — Gradle Sync
- Android Studio auto sync karso
- Niche **"Build"** tab ma progress dikhaso
- Internet connection rakho — dependencies download thaso (~5 min)

### Step 4 — Phone Connect Karo
- USB thi phone connect karo
- Phone Settings → Developer Options → USB Debugging → ON
- Android Studio ma upar device dropdown ma taro phone dikhaso

### Step 5 — Run Karo
- Green **▶ Run** button dabavo
- App phone ma install thaso!

---

## APK Banava Mate (Share karvano)
- **Build** → **Build Bundle(s) / APK(s)** → **Build APK(s)**
- Wait karo — niche notification aavso "APK generated"
- **"Locate"** click karo → `app-debug.apk` malso
- Aa file koi pn Android phone ma install thai shake

---

## Server Connect Karvano (Real calls mate)
Settings screen ma nakho:
- Twilio SID + Token → twilio.com thi
- Claude API Key → console.anthropic.com thi  
- Deepgram Key → console.deepgram.com thi
- Taro WhatsApp number

---

## Files Structure
```
tanishk_ai_bot/
├── android/app/src/main/
│   ├── kotlin/com/tanishk/aibot/
│   │   ├── SplashActivity.kt    ← Splash screen
│   │   ├── MainActivity.kt      ← Dashboard + Calls + Live
│   │   ├── ChatActivity.kt      ← WhatsApp style chat
│   │   ├── SettingsActivity.kt  ← Settings + API keys
│   │   ├── CallAdapter.kt       ← Call list
│   │   └── ChatAdapter.kt       ← Chat bubbles
│   ├── res/layout/              ← UI layouts
│   ├── res/values/              ← Colors, strings, themes
│   └── AndroidManifest.xml
└── build.gradle
```
