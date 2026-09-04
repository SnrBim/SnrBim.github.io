# Automatic BIMTools Update

---

## 1. What has changed for users

* **Before:** The plugin displayed a dialog and downloaded an MSI installer. Users had to complete the installation steps manually, close Revit and any open projects, and confirm loading each new version when Revit started.
* **Now:** Updates are downloaded silently in the background. To start working with the new version, simply close and reopen Revit, with no installation windows or manual steps.
* **Hot-reload:** An already downloaded update can be applied on the fly while working, without restarting Revit or reopening heavy models.
> **Note:** Automatic updating is available starting with version **v25.33** (May 7, 2026). If you updated the plugin after this date, the loader is already installed and the feature is active.

---

## 2. How to use it (Info -> Extra menu)

### Automatic mode

* At Revit startup and every 2 hours afterwards, the plugin checks the server for updates.
* A new version is downloaded silently in the background.
* At the next Revit startup, the latest release is loaded, old versions are removed, and a notification with a brief change summary and a GitHub link is shown.

### Manual check (`Check for updates now`)

Immediately starts a server check and reports the status:

* No updates are available.
* The update was downloaded and will be applied after restarting Revit.
* Automatic updates are disabled.

### Applying without restarting (`Apply downloaded update now`)

Starts the **Hot-reload** procedure. This is useful when a heavy model is open and restarting Revit is inconvenient. The new version is loaded immediately in the current session.

### Manual DLL loading (`Load DLL manually...`)

Lets you select a `.dll` file from disk, for example a test build from a developer, and activate it immediately in the current session through Hot-reload.

> **Please note:** Loading through the interface is **temporary**. After restarting Revit, the official installed version will be loaded again.

### Managing automatic updates (`Auto-update enabled`)

This checkbox controls background checking and downloading. When it is cleared, automatic background updating is disabled, but the manual check remains available.

![Info window](infoWindow.png)

---

## 3. Technical details (Under the hood)

### Thin Loader architecture and the security prompt for unsigned plugins

Revit asks the user to confirm the launch of an unsigned plugin when its binary file has changed. To avoid purchasing an expensive certificate and distributing self-signed certificates through the company IT department, the architecture is split into two parts:

1. The `.addin` manifest (`%APPDATA%\Autodesk\Revit\Addins\20YY\`) registers `BimToolsLoader.dll`, which normally does not change when plugin commands are updated.
2. The user approves the Loader in Revit once.
3. At startup, the Loader scans the working directory (`%APPDATA%\Sener\BimTools\bin\`), selects the newest version subfolder, and starts the main DLL.
4. The plugin registration remains unchanged from Revit's perspective, so update-related plugin confirmation windows do not appear.

<details markdown="block">
<summary>How to open the AppData folder in Windows</summary>

`%appdata%` is a system variable that points to the current user's hidden application settings folder: `C:\Users\<user>\AppData\Roaming`.

The fastest way:

1. Press **Win + R**.
2. Paste `%appdata%\Autodesk\Revit\Addins`.
3. Press **Enter**.

You can also paste this path into the address bar of Windows File Explorer and press **Enter**.

</details>

### Hot-reload mechanics

Directly replacing a `.dll` while Revit is running is impossible because the operating system locks the file. Hot-reload solves this by loading the new version alongside the old one and unsubscribing the old version from Revit events:

* **.NET limitation:** The old `.dll` cannot be completely unloaded from Revit's main application domain and remains in memory until the program closes.
* **Interface:** The old ribbon tab is hidden and a new one is created.
* **Side effects:** Hotkeys and buttons added to the Quick Access Toolbar (QAT) remain linked to the first loaded version. Memory usage also increases slightly.

*Because of these limitations, Hot-reload is an optional manual action. The standard way to apply updates is to restart Revit.*

### Keeping a custom DLL and version naming rules

If you need to keep a test DLL active across Revit restarts:

* Place the DLL manually in `%APPDATA%\Sener\BimTools\bin\X.Y.1\` (official versions use `X.Y` without a third component).
* **Important:** Do not create a folder for the next major version `X.Y+1` manually. The loader will consider it newer and this will block the official `X.Y+1` release from being downloaded. Using a third component (`X.Y.1`) keeps automatic updating working correctly.

## Changelog

2026-09-04 v26.12 - added a notification when an updated version starts.
