#!/usr/bin/env bash
# Cài đặt macclean vào ~/.local/bin (hoặc thư mục trong $PREFIX).
#   ./install.sh            sao chép script
#   ./install.sh --link     tạo symlink (git pull là cập nhật luôn)
#   ./install.sh --uninstall
set -euo pipefail

BIN_DIR="${PREFIX:-$HOME/.local/bin}"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/macclean"
DEST="$BIN_DIR/macclean"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "macclean chỉ chạy trên macOS." >&2
  exit 1
fi

case "${1:-}" in
  --uninstall)
    rm -f "$DEST"
    echo "Đã gỡ $DEST"
    exit 0
    ;;
  --link)
    mkdir -p "$BIN_DIR"
    ln -sf "$SRC" "$DEST"
    echo "Đã tạo symlink $DEST -> $SRC"
    ;;
  "")
    mkdir -p "$BIN_DIR"
    install -m 755 "$SRC" "$DEST"
    echo "Đã cài $DEST"
    ;;
  *)
    echo "Cách dùng: $0 [--link | --uninstall]" >&2
    exit 1
    ;;
esac

if ! command -v python3 >/dev/null 2>&1; then
  echo "Cảnh báo: chưa có python3. Chạy: xcode-select --install" >&2
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) echo "Xong! Gõ: macclean" ;;
  *)
    echo
    echo "$BIN_DIR chưa nằm trong PATH. Thêm vào ~/.zshrc:"
    echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
    ;;
esac
