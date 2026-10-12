# College Flutter App - Development Guide

This guide covers everything needed to set up, launch, and develop the Flutter app on Linux (Ubuntu/Debian) with Android Emulator and Brave Browser integration.

---

## 1. System Requirements & Environment Setup

Ensure the following tools are installed and present in your user environment:

### Essential Linux Dependencies

```bash
sudo apt update && sudo apt install -y curl git unzip xz-utils zip libglu1-mesa clang ninja-build libgtk-3-dev
```

### Flatpak Brave Wrapper Setup (One-time)

Because Brave is installed via Flatpak, create a launcher wrapper so Flutter can launch it directly:

```bash
sudo tee /usr/local/bin/brave-browser > /dev/null << 'EOF'
#!/bin/bash
exec flatpak run com.brave.Browser "$@"
EOF
sudo chmod +x /usr/local/bin/brave-browser
```

### Environment Variables (`~/.bashrc`)

Verify that your `~/.bashrc` includes the Flutter, Android SDK, and Brave paths:

```bash
# Flutter
export PATH="$PATH:$HOME/Documents/Development/flutter/bin"

# Android SDK & Tools
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# Web target override to use Brave Browser
export CHROME_EXECUTABLE="/usr/local/bin/brave-browser"
```

Apply changes:

```bash
source ~/.bashrc
```

Verify your setup:

```bash
flutter doctor -v
```

---

## 2. Launching the Android Emulator

Before starting the app on Android, check available emulators and launch one:

### List available AVDs

```bash
emulator -list-avds
```

### Start the Pixel 7 emulator

Run in the background so it does not lock your active shell:

```bash
emulator -avd Pixel_7_API_35 > /dev/null 2>&1 &
```

*(Alternatively, run without `> /dev/null 2>&1 &` in a separate terminal window to view boot logs).*

### Confirm the device is ready

```bash
flutter devices
```

You should see `emulator-5554` or `sdk gphone64 x86 64` listed as connected.

---

## 3. Running the App

Always navigate to the root directory where `pubspec.yaml` is located:

```bash
cd ~/Documents/GitHub/College-Flutter-Expo-app/flutter
```

### Fetch dependencies

```bash
flutter pub get
```

### Option A: Run on Android Emulator

```bash
flutter run -d emulator-5554
```

### Option B: Run on Web (Brave Browser)

There are two ways to view and test the app in your browser:

#### 1. Automatic Launch in Brave
Launches Brave automatically with Flutter DevTools and debugging hooks connected:

```bash
flutter run -d chrome
```
*(Because `CHROME_EXECUTABLE` points to `/usr/local/bin/brave-browser`, Flutter opens your Flatpak Brave instance).*

#### 2. Headless Web Server (Manual Browser Navigation)
Starts a local development HTTP server without auto-opening a browser window. Useful if you want to test across multiple open tabs or manually open `http://localhost:8080`:

```bash
flutter run -d web-server --web-port 8080 --web-hostname localhost
```
Once initialized, open Brave and navigate to:
```text
http://localhost:8080
```

---

## 4. Development & Live Controls (Hot Reload / Restart)

While `flutter run` is active in the terminal (for both Android and Web targets), use these interactive terminal keybindings:

| Key | Action | Description |
| :--- | :--- | :--- |
| **`r`** | **Hot Reload** | Updates UI changes instantly (~1s) while keeping current app state. |
| **`R`** | **Hot Restart** | Re-runs the `main()` method and resets state to fresh launch. |
| **`h`** | **Help** | Displays all interactive terminal commands. |
| **`w`** | **Widget Inspector** | Toggles the Flutter widget hierarchy tree outline. |
| **`c`** | **Clear Console** | Clears terminal log output. |
| **`q`** | **Quit** | Shuts down the dev server and terminates the running application. |

> **Note for Web:** On web targets, pressing `r` updates the running browser tab in real time. You can also manually refresh the tab with `Ctrl + Shift + R` if you need a hard reload.

---

## 5. Troubleshooting & Common Fixes

### File Locked / Cannot Type in `lib/main.dart`

* **IdeaVim Mode (Android Studio):** Press `i` to enter Insert Mode, or disable the Vim plugin with `Ctrl + Alt + V`.
* **Root Ownership:** If files were created with `sudo`, fix permissions:
  ```bash
  sudo chown -R $USER:$USER ~/Documents/GitHub/College-Flutter-Expo-app/
  chmod -R u+w ~/Documents/GitHub/College-Flutter-Expo-app/
  ```

### KVM Acceleration Issues

Verify your user can access `/dev/kvm`:

```bash
kvm-ok
```

If permission is denied, add your user to the `kvm` group:

```bash
sudo usermod -aG kvm $USER
newgrp kvm
```

### Web Target Fails to Launch Brave

Check that your wrapper script and environment variable are intact:

```bash
echo $CHROME_EXECUTABLE
/usr/local/bin/brave-browser --version
```