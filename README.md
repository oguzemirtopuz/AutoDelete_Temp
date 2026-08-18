<div align="center">

[![Windows 10/11](https://img.shields.io/badge/Platform-Windows_10_%2F_11-0078D6?style=for-the-badge&logo=windows&logoColor=white)](#)
[![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](#)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero_(Native_Only)-brightgreen?style=for-the-badge)](#)
[![Resource Footprint](https://img.shields.io/badge/Idle_Memory-0_MB_(One--Shot)-FF6F00?style=for-the-badge)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

<h1>⚡ AutoDelete_Temp</h1>
<h3>Zero-overhead Windows startup cleaner. Purges junk instantly, evades locked files, and notifies you when done.</h3>

<p><em>Permanent file deletion · User & System Temp targeting · Non-blocking error handling · Native Windows Toast reporting · Zero background CPU/RAM</em></p>

</div>

---

## 🎯 What Problem Does This Solve?

Windows accumulates gigabytes of temporary data across `%TEMP%` and `C:\Windows\Temp` every single week — installation leftovers, browser cache fragments, telemetry buffers, and crashed application remnants.

Most users manually press `Win + R` ➔ type `%temp%` ➔ `Ctrl + A` ➔ `Shift + Delete`, only to be interrupted by:
- Frustrating *"File In Use / Access Denied"* popups that halt the entire deletion queue.
- Uncleaned `C:\Windows\Temp` folders due to missing administrator elevation.
- Lingering junk in the Recycle Bin consuming disk space.
- The sheer friction of remembering to do it manually.

**AutoDelete_Temp** fully automates this workflow directly at Windows startup:
1. **Silent Trigger:** Launches invisibly at logon via Windows Task Scheduler with elevated privileges.
2. **Dual-Folder Purge:** Cleans both User `%TEMP%` and `C:\Windows\Temp` simultaneously.
3. **Lock-Safe Evasion:** Skips locked or actively used files silently without stopping or throwing errors.
4. **Permanent Removal:** Bypasses the Recycle Bin (Shift+Delete equivalent) to immediately reclaim disk space.
5. **Native Toast Notification:** Displays a clean Windows balloon notification reporting the exact file count and freed storage space once the process finishes.
6. **Zero Idle Overhead:** Shuts down completely after 1-2 seconds of execution (0 MB RAM, 0% CPU footprint during gaming or daily use).

---

## 👥 Who This Is For

- **Gamers & Power Users** who want maximum disk hygiene without running heavy background optimizer suites.
- **Developers & Engineers** whose build caches, Docker artifacts, and temp folders bloat the primary drive.
- **Minimalists** who want a set-and-forget native Windows solution with zero third-party software dependencies.

---

## ⚡ Key Highlights

| Feature | AutoDelete_Temp | Manual Cleaning (`Win+R`) | Third-Party "Cleaners" (CCleaner, etc.) |
|---|---|---|---|
| **Automation** | 100% Automated on logon | Manual every time | Requires background service |
| **Locked File Handling** | Silently skips & continues | Blocked by modal popups | Often hangs or prompts user |
| **Elevated Temp Cleaning** | Purges `C:\Windows\Temp` | Fails without admin | May require paid/premium tier |
| **Resource Usage** | **0 MB RAM / 0% CPU (Terminates)** | N/A | 50-200 MB constant background RAM |
| **Privacy & Telemetry** | **Zero external calls / Offline** | Offline | Constant telemetry & adware |
| **Visual Feedback** | Clean native Windows Toast | Manual folder check | Intrusive upgrade prompts |

---

## 🛠️ Architecture & Components

```
AutoDelete_Temp/
├── clean_temp.ps1      # Core engine — dual-path scanner, permanent purger & toast dispatcher
├── launcher.vbs        # Silent runner — launches PowerShell invisibly without console flicker
├── setup_task.ps1      # Task Scheduler architect — registers logon trigger with highest privileges
├── kurulum.bat         # 1-Click Installer (Admin elevation wrapper)
├── kaldir.bat          # 1-Click Uninstaller (Clean task removal)
└── LICENSE             # MIT License
```

### How the Engine Works:
1. **Dual Directory Resolution:** Dynamically resolves `$env:TEMP` (`%USERPROFILE%\AppData\Local\Temp`) and `$env:SystemDrive\Windows\Temp`.
2. **Atomic Traversal & Deletion:** Uses direct first-level directory traversal and recursive force-deletion (`Remove-Item -Force -Recurse -ErrorAction Stop`).
3. **Exception Shielding:** Each item is wrapped in an individual `try/catch` block. If Windows or another active process holds a handle on a file, it is cleanly skipped without halting execution.
4. **Byte Counter & Formatting:** Aggregates total freed bytes across non-container files and formats them to human-readable units (`KB`, `MB`, `GB`).
5. **Base64 UTF-8 Toast Dispatcher:** Emits a native `System.Windows.Forms.NotifyIcon` balloon tip containing exact statistics, formatted with UTF-8 byte decoding to prevent character encoding corruptions.
6. **Graceful Teardown:** Disposes notification resources and exits the process immediately.

---

## 🚀 Installation & Usage

### 1. Installation (1-Click)

1. Clone or download this repository:
   ```bash
   git clone https://github.com/oguzemirtopuz/AutoDelete_Temp.git
   cd AutoDelete_Temp
   ```
2. Double-click **`kurulum.bat`** (or Right-Click ➔ **Run as Administrator**).
3. The script automatically configures a high-privilege Windows Task Scheduler entry (`AutoDeleteTempCleaning`).

> **That's it!** Every time your PC boots up or you log in, temporary files are purged in the background, followed by a completion toast notification.

---

### 2. Manual Trigger / Testing

Want to clean temporary files immediately without restarting? Run:
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File clean_temp.ps1
```

---

### 3. Uninstallation (1-Click)

To remove the scheduled startup task completely:
1. Double-click **`kaldir.bat`** (Run as Administrator).
2. The task is instantly unregistered from Windows Task Scheduler.

---

## 🎮 Performance & Gaming Verification

A critical design requirement of AutoDelete_Temp is **zero performance interference**:

- **No Daemons / No Polling:** Does not run as a continuous loop, background agent, or Windows service.
- **Instant Lifecycle:** Executes for ~1.5 seconds during initial login and terminates immediately.
- **Zero FPS Drop:** While gaming, streaming, or working, the script uses **0.00% CPU**, **0 MB RAM**, and **0 Disk I/O**.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

---

<div align="center">
  <sub>Built with precision by <a href="https://github.com/oguzemirtopuz">Oğuz Emir Topuz</a></sub>
  <br/>
  <sub>⭐ If AutoDelete_Temp keeps your Windows clean, give it a star!</sub>
</div>
