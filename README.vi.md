# macclean

**Tiếng Việt** · [English](README.md)

Tool TUI chạy trong terminal để **kiểm tra và dọn dung lượng** trên máy Mac dùng để lập trình: Xcode, iOS Simulator, Gradle/Android, Flutter, rác của AI agent, cache ứng dụng.

Tab thứ hai, **Khởi động & hiệu năng**, giải thích vì sao máy lag (swap, tải CPU, CPU bị hạ xung vì nóng, app nặng) và cho bạn **tắt / bật lại** những thứ tự chạy nền: Homebrew services, mục mở khi đăng nhập, LaunchAgents / LaunchDaemons.

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

## Cài đặt nhanh

Yêu cầu: macOS và `python3` (có sẵn khi đã cài Xcode hoặc Command Line Tools). Không cần cài thêm thư viện nào.

```bash
gh repo clone Penz7/macclean ~/macclean && ~/macclean/install.sh
```

Lệnh này cài vào `~/.local/bin/macclean`. Nếu thư mục đó chưa nằm trong `PATH`, script sẽ in ra lệnh để thêm.

<details>
<summary>Các cách cài khác</summary>

```bash
# Dùng symlink: mỗi lần git pull là có bản mới luôn
~/macclean/install.sh --link

# Cài vào thư mục khác
PREFIX=/usr/local/bin ~/macclean/install.sh

# Không clone, chỉ tải đúng 1 file (cần gh đã đăng nhập)
mkdir -p ~/.local/bin && gh api repos/Penz7/macclean/contents/macclean \
  -H "Accept: application/vnd.github.raw" > ~/.local/bin/macclean && chmod +x ~/.local/bin/macclean

# Gỡ cài đặt
~/macclean/install.sh --uninstall
```
</details>

## Sử dụng

```bash
macclean                  # mở giao diện TUI
macclean --dry-run        # chạy thử, không xoá thật
macclean --list           # in báo cáo ra terminal rồi thoát
macclean --quick          # dọn nhanh các mục gợi ý, không mở TUI (có hỏi y/N)
macclean --quick --yes    # dọn nhanh, không hỏi lại (dùng cho script / cron)
macclean --tab startup    # mở TUI ở tab Khởi động & hiệu năng
macclean --startup        # in báo cáo khởi động & hiệu năng (kèm lệnh mở lại) rồi thoát
```

### ⚡ Dọn nhanh

Không cần tick từng mục: mở `macclean`, đợi quét xong, nhấn **`f`** rồi **`y`**. Toàn bộ mục được gợi ý `*` sẽ bị xoá.
Muốn xem trước những gì sẽ bị xoá thì chạy `macclean --quick --dry-run`.

### Phím tắt

| Phím | Tác dụng |
|---|---|
| **`f`** | **dọn nhanh**: chọn mọi mục gợi ý `*` rồi hỏi xác nhận xoá |
| `↑` `↓` / `j` `k` | di chuyển (`PgUp` `PgDn`, `g` `G` để nhảy) |
| `Space` | chọn / bỏ chọn; trên tiêu đề nhóm thì chọn cả nhóm |
| `a` | chọn / bỏ chọn cả nhóm đang đứng |
| `Enter` / `←` `→` | mở / đóng nhóm (`c` để mở / đóng tất cả) |
| `s` | chọn các mục được gợi ý (`*`) |
| `u` | bỏ chọn tất cả |
| `d` | xoá các mục đã chọn (có hỏi xác nhận); ở tab 2 là **tắt** |
| `e` | tab 2: **bật lại** các mục đã tắt đang được chọn |
| `i` | xem chi tiết mục đang đứng: đường dẫn, trạng thái, lệnh tắt và **lệnh mở lại** |
| `Tab` / `1` `2` | chuyển giữa tab Dung lượng và tab Khởi động & hiệu năng |
| `r` | quét lại |
| `q` | thoát |

## Tool quét những gì

| Nhóm | Mục | Được gợi ý `*` khi |
|---|---|---|
| Xcode | `iOS DeviceSupport`, `DerivedData` | luôn gợi ý, Xcode tự tạo lại khi cần |
| Xcode Archives | từng `.xcarchive`, kèm tên app, version và build | cũ hơn 60 ngày và không phải bản mới nhất của app đó |
| Simulator | từng thiết bị | không khả dụng, hoặc không mở hơn 90 ngày |
| Simulator runtime | từng runtime iOS / watchOS… | không còn simulator nào, hoặc không dùng hơn 90 ngày |
| Android | `~/.gradle/caches`, `daemon`, từng bản wrapper, AVD emulator | `daemon` và các wrapper cũ (giữ bản mới nhất) |
| Flutter / Dart | `~/.pub-cache`, các bản Flutter trong `~/fvm/versions` | không gợi ý, bạn tự quyết định |
| AI agents | lịch sử phiên của Claude Code, Codex, Gemini CLI / Antigravity; bản Codex cũ sau khi tự cập nhật; video quay trình duyệt; `workspaceStorage` của các editor AI (Cursor, Windsurf, Antigravity, VS Code…); file tạm cũ trong `$TMPDIR` và `/tmp` | lịch sử cũ hơn 30 ngày, file tạm cũ hơn 3 ngày, bản cập nhật cũ (giữ bản đang dùng) |
| AI model & runtime | HuggingFace, Whisper, ModelScope, Ollama, LM Studio, cache `uv`, runtime Codex | không gợi ý, vì tải lại rất lâu |
| Cache ứng dụng | `~/Library/Caches/*` (≥ 50 MB), cache npm | Homebrew, CocoaPods, Yarn, pip, npm…, và bộ cài cập nhật còn sót (`*.ShipIt`) |
| Thùng rác | `~/.Trash` | luôn gợi ý |

Dòng trên cùng còn cho biết tình trạng máy: dung lượng trống, swap, tải CPU, CPU có bị hạ xung không, tình trạng pin và trạng thái SIP. Mục nào đáng lo sẽ được tô đỏ.

## Khởi động & hiệu năng (tab 2)

Máy lag mà ổ đĩa vẫn còn trống thì dọn file không giúp được: thủ phạm thường là thiếu RAM (swap đầy), CPU quá tải hoặc máy nóng. Nhấn `Tab` (hoặc chạy `macclean --tab startup`) để xem:

| Nhóm | Hiển thị | Được gợi ý tắt `*` khi |
|---|---|---|
| Hiệu năng | swap, tải CPU so với số luồng, `CPU_Speed_Limit` (hạ xung vì nóng), số ngày chưa khởi động lại; các app tốn RAM / CPU nhất (gộp theo app) kèm lời khuyên | chỉ để xem, macclean không tự tắt app |
| Homebrew services | `brew services` (MySQL, PostgreSQL, MongoDB, Redis…) | đang chạy và là database / dịch vụ dev |
| Mở khi đăng nhập | Login Items; tuỳ chọn *Start Docker Desktop when you sign in* | app đã bị gỡ; Docker tự mở khi đăng nhập |
| LaunchAgents | `~/Library/LaunchAgents`, `/Library/LaunchAgents` (bỏ qua `com.apple.*`) | hỏng (chương trình / script không còn), hoặc chỉ là trình tự cập nhật |
| LaunchDaemons | `/Library/LaunchDaemons` | như trên |

Không gợi ý tắt: updater của trình duyệt (để nhận bản vá bảo mật), VPN, kiểm tra bản quyền, phần mềm bảo mật / MDM của công ty, dịch vụ phụ của Docker.

**Tắt và mở lại:**

- Chọn mục bằng `Space` (hoặc `s` / `f` cho các mục `*`), nhấn `d` để tắt. Muốn bật lại thì chọn mục "đã tắt" rồi nhấn `e`.
- Nhấn `i` trên một mục để xem đúng lệnh mà macclean sẽ chạy và **lệnh để mở lại bằng tay**. `macclean --startup` cũng in các lệnh này.
- Cách tắt từng loại (đều đảo ngược được):
  - Homebrew: `brew services stop <tên>`, mở lại bằng `brew services start <tên>`.
  - LaunchAgent / Daemon: `launchctl bootout` + `launchctl disable`, mở lại bằng `launchctl enable` + `launchctl bootstrap`. Plist **không bị xoá**.
  - Plist **hỏng** thì được cất vào `~/.local/state/macclean/launchd-backup/`, bật lại sẽ chuyển về chỗ cũ.
  - Login Item: gỡ khỏi danh sách, bật lại sẽ thêm lại đúng app đó.
  - Docker: đặt `AutoStart` trong `settings-store.json`, tương đương *Docker → Settings → General → Start Docker Desktop when you sign in*.
- Mọi mục macclean đã tắt được ghi vào `~/.local/state/macclean/disabled.json` (thời điểm tắt và cách mở lại), nên kể cả mục đã biến khỏi danh sách hệ thống vẫn hiện "đã tắt" để bật lại được.
- Mục trong `/Library/LaunchDaemons` cần quyền admin: macclean tạm thoát giao diện để hỏi mật khẩu `sudo`, rồi quay lại.

## An toàn

- Luôn hỏi xác nhận trước khi xoá, và phải nhấn đúng `y` mới xoá.
- Chỉ xoá đường dẫn **nằm trong thư mục home, `$TMPDIR` hoặc `/tmp`**; trong các thư mục tạm thì chỉ xoá file thuộc về bạn.
- Simulator và runtime được xoá bằng `xcrun simctl delete` / `xcrun simctl runtime delete`, không xoá file trực tiếp.
- Tự tắt Gradle daemon trước khi xoá cache Gradle.
- Xoá là **xoá hẳn**, không qua Thùng rác. Nếu không chắc, hãy chạy `--dry-run` trước.
- Ở tab Khởi động & hiệu năng, macclean chỉ **tắt** chứ không xoá; `--dry-run` cũng áp dụng cho việc tắt / bật.

> **Lưu ý:** Xoá Archive thì mất luôn dSYM của bản build đó, nên không thể symbolicate crash log của bản ấy nữa. Nếu bạn đã upload dSYM lên Crashlytics hoặc Sentry thì không sao.
