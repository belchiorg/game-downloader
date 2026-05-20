#!/bin/bash
set -e

mkdir -p "$(dirname "$DEST_PATH")"

case "$SOURCE_TYPE" in
  http)
    curl -L --progress-bar -o "$DEST_PATH" "$SOURCE_URL"
    ;;
  gdrive)
    rclone copy "$SOURCE_URL" "$(dirname "$DEST_PATH")" \
      --config /etc/rclone/rclone.conf \
      --progress
    mv "$(dirname "$DEST_PATH")/$(basename "$SOURCE_URL")" "$DEST_PATH" 2>/dev/null || true
    ;;
  archive)
    ia download --glob="$(basename "$DEST_PATH")" \
      --destdir="$(dirname "$DEST_PATH")" \
      "$SOURCE_URL"
    ;;
  *)
    echo "Unknown source type: $SOURCE_TYPE"
    exit 1
    ;;
esac

if [ -n "$CHECKSUM" ]; then
  echo "$CHECKSUM  $DEST_PATH" | sha256sum -c -
fi

case "$DEST_PATH" in
  *.7z|*.rar|*.zip)
    7z x -o"$(dirname "$DEST_PATH")" "$DEST_PATH"
    rm "$DEST_PATH"
    echo "Done: extracted and removed $DEST_PATH"
    ;;
  *)
    echo "Done: $DEST_PATH"
    ;;
esac