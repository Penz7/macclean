# macclean

**English** · [Tiếng Việt](README.vi.md)

A terminal TUI to **inspect and free up disk space** on a developer Mac: Xcode, iOS Simulator, Gradle/Android, Flutter, AI agent leftovers and app caches.

A second tab, **Startup & performance** (*Khởi động & hiệu năng*), explains why the Mac is slow (swap, CPU load, thermal throttling, heavy apps) and lets you **disable and re-enable** things that run in the background: Homebrew services, login items, LaunchAgents and LaunchDaemons.

```
 macclean — dọn dẹp dung lượng Mac
 Ổ đĩa: 110.3G trống (76% đã dùng) │ Swap: 8.9/10.0G │ Pin: 73%, 884 chu kỳ │ SIP: bật
────────────────────────────────────────────────────────────────────────────────────
▾ Xcode · Archives                                          20 mục · 7.2G · đã chọn 2
  [x] * 18/06/2026 14:02 · production 1.0.1 (1)              290.8M  120 ngày trước
  [x] * 16/06/2026 15:35 · production 1.0.0 (10)             333.0M  122 ngày trước
  [ ]   15/10/2026 16:15 · production 1.0.10 (10)            334.4M  hôm nay
▾ Simulator · runtime                                                   2 mục · 19.6G
  [ ]   iOS 26.5 (23F77)                                       9.9G  11 sim · hôm nay
  [ ] * iOS 18.4 (22E238)                                      7.8G  0 sim · 210 ngày trước
▸ Android · Gradle & emulator                                           4 mục · 31.4G
────────────────────────────────────────────────────────────────────────────────────
 Đã chọn 2 mục · 624.0M  f dọn nhanh  Space chọn  a cả nhóm  s gợi ý  d xoá  q thoát
```

> The interface text is in Vietnamese. The keys and command-line flags are listed in English below.

## Quick install

Requirements: macOS and `python3`, which comes with Xcode or the Command Line Tools. No extra packages are needed.

```bash
gh repo clone Penz7/macclean ~/macclean && ~/macclean/install.sh
```

This installs the tool to `~/.local/bin/macclean`. If that folder is not on your `PATH`, the script prints the line to add it.

<details>
<summary>Other install options</summary>

```bash
# Symlink instead of copy: every git pull updates the tool
~/macclean/install.sh --link

# Install to a different folder
PREFIX=/usr/local/bin ~/macclean/install.sh

# Download just the script, no clone (needs gh to be logged in)
mkdir -p ~/.local/bin && gh api repos/Penz7/macclean/contents/macclean \
  -H "Accept: application/vnd.github.raw" > ~/.local/bin/macclean && chmod +x ~/.local/bin/macclean

# Uninstall
~/macclean/install.sh --uninstall
```
</details>

## Usage

```bash
macclean                  # open the TUI
macclean --dry-run        # trial run, nothing is deleted
macclean --list           # print a report to the terminal and exit
macclean --quick          # clean all suggested items without the TUI (asks y/N)
macclean --quick --yes    # clean without asking (for scripts / cron)
macclean --tab startup    # open the TUI on the Startup & performance tab
macclean --startup        # print the startup & performance report (with re-enable commands) and exit
```

### ⚡ Quick clean

You don't have to tick items one by one: open `macclean`, wait for the scan to finish, then press **`f`** and **`y`**. Every item marked `*` (suggested) gets deleted.
To see what would be deleted first, run `macclean --quick --dry-run`.

### Keys

| Key | Action |
|---|---|
| **`f`** | **quick clean**: select every suggested `*` item, then confirm deletion |
| `↑` `↓` / `j` `k` | move (`PgUp` `PgDn`, `g` `G` to jump) |
| `Space` | select / deselect; on a group header, the whole group |
| `a` | select / deselect the whole group under the cursor |
| `Enter` / `←` `→` | expand / collapse a group (`c` for all groups) |
| `s` | select the suggested items (`*`) |
| `u` | deselect everything |
| `d` | delete the selected items (asks for confirmation); on tab 2 it **disables** them |
| `e` | tab 2: **re-enable** the selected disabled items |
| `i` | show details for the item under the cursor: path, status, the disable command and the **re-enable command** |
| `Tab` / `1` `2` | switch between the Disk tab and the Startup & performance tab |
| `r` | rescan |
| `q` | quit |

## What it scans

| Group | Items | Suggested `*` when |
|---|---|---|
| Xcode | `iOS DeviceSupport`, `DerivedData` | always, Xcode rebuilds them when needed |
| Xcode Archives | each `.xcarchive`, with app name, version and build | older than 60 days and not the latest archive of that app |
| Simulator | each device | unavailable, or not opened for 90+ days |
| Simulator runtime | each iOS / watchOS… runtime | no simulators left, or not used for 90+ days |
| Android | `~/.gradle/caches`, `daemon`, each wrapper version, AVD emulators | `daemon` and old wrappers (the newest is kept) |
| Flutter / Dart | `~/.pub-cache`, Flutter versions in `~/fvm/versions` | never, you decide |
| AI agents | Claude Code, Codex, Gemini CLI / Antigravity session history; old Codex releases; browser recordings; `workspaceStorage` of AI editors (Cursor, Windsurf, Antigravity, VS Code…); stale files in `$TMPDIR` and `/tmp` | history older than 30 days, temp files older than 3 days, old self-update releases (the current one is kept) |
| AI models & runtimes | HuggingFace, Whisper, ModelScope, Ollama, LM Studio, `uv` cache, Codex runtime | never, they take a long time to download again |
| App caches | `~/Library/Caches/*` (≥ 50 MB), npm cache | Homebrew, CocoaPods, Yarn, pip, npm…, and app updater leftovers (`*.ShipIt`) |
| Trash | `~/.Trash` | always |

The top bar also shows the machine's state: free disk space, swap, CPU load, thermal throttling, battery health and SIP status. Anything worth worrying about is shown in red.

## Startup & performance (tab 2)

If the Mac is slow but the disk still has free space, deleting files won't help: the usual causes are too little RAM (swap is full), an overloaded CPU or heat. Press `Tab` (or run `macclean --tab startup`) to see:

| Group | Shows | Suggested to disable `*` when |
|---|---|---|
| Performance | swap, CPU load vs. thread count, `CPU_Speed_Limit` (thermal throttling), days since the last restart; the apps using the most RAM / CPU (grouped per app) with a tip | view only, macclean never quits apps |
| Homebrew services | `brew services` (MySQL, PostgreSQL, MongoDB, Redis…) | running and a database / dev service |
| Login items | Login Items; Docker's *Start Docker Desktop when you sign in* | the app was uninstalled; Docker starting at login |
| LaunchAgents | `~/Library/LaunchAgents`, `/Library/LaunchAgents` (`com.apple.*` is skipped) | broken (its program or script is gone), or only an auto-updater |
| LaunchDaemons | `/Library/LaunchDaemons` | same as above |

Never suggested: browser updaters (security patches), VPNs, license checkers, company security / MDM agents, Docker's helper services.

**Disabling and re-enabling:**

- Select items with `Space` (or `s` / `f` for the `*` items) and press `d` to disable them. To turn one back on, select a disabled item and press `e`.
- Press `i` on an item to see the exact command macclean will run and the **command to re-enable it by hand**. `macclean --startup` prints these too.
- How each kind is disabled (all of it is reversible):
  - Homebrew: `brew services stop <name>`, re-enabled with `brew services start <name>`.
  - LaunchAgent / Daemon: `launchctl bootout` + `launchctl disable`, re-enabled with `launchctl enable` + `launchctl bootstrap`. The plist is **not deleted**.
  - A **broken** plist is moved to `~/.local/state/macclean/launchd-backup/`; re-enabling moves it back.
  - Login item: removed from the list; re-enabling adds the same app back.
  - Docker: sets `AutoStart` in `settings-store.json`, the same as *Docker → Settings → General → Start Docker Desktop when you sign in*.
- Everything macclean disables is recorded in `~/.local/state/macclean/disabled.json` (when it was disabled and how to re-enable it), so items that no longer show up in the system lists still appear as disabled and can be turned back on.
- Items in `/Library/LaunchDaemons` need admin rights: macclean leaves the TUI briefly to ask for your `sudo` password, then comes back.

## Safety

- It always asks before deleting, and only an exact `y` confirms.
- It only deletes paths **inside your home folder, `$TMPDIR` or `/tmp`**, and in the temp folders only files owned by you.
- Simulators and runtimes are removed with `xcrun simctl delete` / `xcrun simctl runtime delete`, never by deleting files directly.
- Gradle daemons are stopped before Gradle caches are deleted.
- Deletion is **permanent**; nothing goes to the Trash. If in doubt, run with `--dry-run` first.
- On the Startup & performance tab macclean only **disables**, it never deletes; `--dry-run` applies to disabling / re-enabling too.

> **Note:** Deleting an archive also deletes its dSYMs, so crash logs from that build can no longer be symbolicated. This doesn't matter if you have already uploaded the dSYMs to Crashlytics or Sentry.
