#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$@"
fi

printf "\e[?25l" > /dev/tty1
printf "\033[H\033[2J" >  /dev/tty1

OPT="/opt/system"
TOOLS="$OPT/Tools"

echo "========================================================="
echo "           R36S Tools Folder Script Installer"
echo "                      by djparent"
echo "========================================================="
echo "Starting..."
sleep 0.5

echo "Downloading and installing scripts by djparentx"
echo "-----------------------------------------------"

echo "Downloading Wi-Fi Manager..."
read -r wifiver URL < <(curl -s https://api.github.com/repos/djparentx/Wi-Fi-Manager/releases/latest \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['tag_name'].lstrip('v'), d['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "$OPT/Wi-Fi Manager ${wifiver}.sh" && echo "Success. Installed to $OPT" || echo "Failed."

echo "Downloading BT Manager..."
read -r btver URL < <(curl -s https://api.github.com/repos/djparentx/BT-Manager/releases/latest \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['tag_name'].lstrip('v'), d['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "$OPT/BT Manager ${btver}.sh" && echo "Success. Installed to $OPT" || echo "Failed."

echo "Downloading CPU Manager..."
URL=$(curl -s https://api.github.com/repos/djparentx/CPU-Manager/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/CPU Manager.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

if grep -qi "^ID=debian" /etc/os-release; then
	echo "Downloading SYSTEMS Manager..."
	URL=$(curl -s https://api.github.com/repos/djparentx/SYSTEMS-Manager-for-dArkOS/releases/latest \
		| python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
	curl -L "$URL" -o "${TOOLS}/SYSTEMS Manager.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."
fi

echo "Downloading Button Mapper for Scripts..."
URL=$(curl -s https://api.github.com/repos/djparentx/R36S-Button-Mapper-for-Scripts/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/Button Mapper for Scripts.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

echo "Downloading Battery Calibration Tool..."
read -r bctver URL < <(curl -s https://api.github.com/repos/djparentx/R36S-Battery-Calibration-Tool/releases/latest \
    | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['tag_name'].lstrip('v'), d['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/R36S Battery Calibration Tool v${bctver}.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

echo "Downloading Dave's Retro Shaders..."
URL=$(curl -s https://api.github.com/repos/djparentx/Dave-s-Retro-Shaders/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/Dave's Retro Shaders.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

echo "Downloading Dave's Modern Shaders..."
URL=$(curl -s https://api.github.com/repos/djparentx/Dave-s-Modern-Shaders/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/Dave's Modern Shaders.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

echo "Downloading RetroArch One-Click Backup..."
URL=$(curl -s https://api.github.com/repos/djparentx/RetroArch-One-Click-Settings/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${TOOLS}/RetroArch One-Click Backup.sh" && echo "Success. Installed to $TOOLS" || echo "Failed."

echo "-----------------------------------------------"
echo "Setting file permissions..."
chmod -R +x "$OPT"
sleep 0.2

echo ""
echo "Finished!"
sleep 1

rm -f "$0"
