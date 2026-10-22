#!/bin/sh
# Hantar poster kuliah ke TV melalui Wi-Fi (ADB). Poster disimpan dalam /sdcard/Pictures/Poster.
# Guna:  ./poster.sh <IP-TV> poster1.jpg poster2.png ...   tambah poster
#        ./poster.sh <IP-TV> --senarai                       lihat poster dalam TV
#        ./poster.sh <IP-TV> --padam-semua                   buang semua poster
set -e
TV="$1"; shift || true
[ -n "$TV" ] && [ $# -gt 0 ] || { sed -n 2,6p "$0"; exit 1; }
ADB="${ADB:-$HOME/glass-tv-sdk/sdk/platform-tools/adb}"
DEV="$TV:5555"; DIR=/sdcard/Pictures/Poster
"$ADB" connect "$DEV" >/dev/null
case "$1" in
  --senarai) "$ADB" -s "$DEV" shell ls -1 "$DIR" 2>/dev/null || echo "(tiada poster)"; exit 0 ;;
  --padam-semua) "$ADB" -s "$DEV" shell rm -rf "$DIR" ;;
  *) "$ADB" -s "$DEV" shell mkdir -p "$DIR"
     for f in "$@"; do "$ADB" -s "$DEV" push "$f" "$DIR/"; done ;;
esac
# Minta Android index semula supaya app nampak perubahan (cara Android 11+, kemudian cara lama).
"$ADB" -s "$DEV" shell content call --method scan_volume --uri content://media --arg external_primary >/dev/null 2>&1 \
  || "$ADB" -s "$DEV" shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file://$DIR" >/dev/null 2>&1 || true
echo "Siap. Poster akan muncul dalam pusingan slide seterusnya (~1-2 minit)."
