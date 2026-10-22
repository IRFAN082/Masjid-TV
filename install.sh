#!/bin/sh
# Pasang Paparan Masjid ke TV Android melalui Wi-Fi (ADB).
# Guna: ./install.sh 192.168.1.50   (IP TV: Tetapan > Rangkaian; hidupkan "USB/Network debugging" dalam Developer options)
set -e
TV="$1"; [ -n "$TV" ] || { echo "Guna: $0 <IP-TV>"; exit 1; }
ADB="${ADB:-$HOME/glass-tv-sdk/sdk/platform-tools/adb}"
DIR="$(cd "$(dirname "$0")" && pwd)"
"$ADB" connect "$TV:5555"
"$ADB" -s "$TV:5555" install -r "$DIR/dist/PaparanMasjid.apk"
# Benarkan app dibuka sendiri selepas TV hidup / bekalan elektrik pulih.
"$ADB" -s "$TV:5555" shell appops set my.masjid.tv SYSTEM_ALERT_WINDOW allow || true
# Benarkan app baca poster dalam folder "Poster".
"$ADB" -s "$TV:5555" shell pm grant my.masjid.tv android.permission.READ_MEDIA_IMAGES 2>/dev/null \
  || "$ADB" -s "$TV:5555" shell pm grant my.masjid.tv android.permission.READ_EXTERNAL_STORAGE || true
"$ADB" -s "$TV:5555" shell am start -n my.masjid.tv/.MainActivity
echo "Siap. Tekan MENU (atau OK 3 kali) pada remote untuk buka Tetapan."
