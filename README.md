# macclean

**English** · [Tiếng Việt](README.vi.md)

A terminal TUI to **inspect and free up disk space** on a developer Mac: Xcode, iOS Simulator, Gradle/Android, Flutter and app caches.

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
| `d` | delete the selected items (asks for confirmation) |
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
| App caches | `~/Library/Caches/*` (≥ 50 MB), npm cache | Homebrew, CocoaPods, Yarn, pip, npm… |
| Trash | `~/.Trash` | always |

The top bar also shows the machine's state: free disk space, swap, battery health and SIP status. Anything worth worrying about is shown in red.

## Safety

- It always asks before deleting, and only an exact `y` confirms.
- It only deletes paths **inside your home folder**.
- Simulators and runtimes are removed with `xcrun simctl delete` / `xcrun simctl runtime delete`, never by deleting files directly.
- Gradle daemons are stopped before Gradle caches are deleted.
- Deletion is **permanent**; nothing goes to the Trash. If in doubt, run with `--dry-run` first.

> **Note:** Deleting an archive also deletes its dSYMs, so crash logs from that build can no longer be symbolicated. This doesn't matter if you have already uploaded the dSYMs to Crashlytics or Sentry.
