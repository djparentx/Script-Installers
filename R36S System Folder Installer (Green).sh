#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$0" "$@"
fi

printf "\e[?25l" > /dev/tty1
printf "\033[H\033[2J" >  /dev/tty1

OPT="/opt/system"
SYS="$OPT/System"
TOOLS="$OPT/Tools"
BIN="/usr/local/bin"
BAK="/roms/backup/old scripts"

echo "========================================================="
echo "              R36S System Folder Installer"
echo "                      by djparent"
echo "========================================================="
echo "Starting..."
sleep 0.5

echo "Creating folders..."
mkdir -p "$SYS"
mkdir -p "$BAK"
sleep 0.2

echo "Moving system files..."
# --- backup old scripts ---
old_scripts=(
    "ZRam Manager.sh"
    "Wifi.sh"
    "Wifi Toggle.sh"
	"Wifi-Toggle.sh"
    "Remove ._ Files.sh"
    "PS1 - Generate m3u files.sh"
    "PS1 - Delete m3u files.sh"
    "Network Info.sh"
    "Enable Remote Services.sh"
    "Disable Remote Services.sh"
)

for f in "${old_scripts[@]}"; do
    [[ -f "${OPT}/${f}" ]] && mv "${OPT}/${f}" "${BAK}/"
done

# --- move System scripts ---
system_scripts=(
    "R36 Control.sh"
	"Change Password.sh"
	"Change Time.sh"
	"Restore Default Drastic Settings.sh"
	"Restore Default KODI Controls.sh"
	"System Info.sh"
	"Update.sh"
	"USB Drive Mount.sh"
	"USB Drive Unmount.sh"
	"Set Launchimage to ascii or pic.sh"
	"Set Launchimage to vid.sh"
)

for f in "${system_scripts[@]}"; do
    [[ -f "${OPT}/${f}" ]] && mv "${OPT}/${f}" "${SYS}/"
done

sleep 0.2

if [[ ! -f "$SYS/Change LED to Red.sh" && ! -f "$SYS/Change LED to Green.sh" ]]; then
	if grep -qi "^ID=debian" /etc/os-release; then
		echo "Creating 'batt_life_warning.py.red' ..."
		sleep 0.2
		cat > "$BIN/batt_life_warning.py.red" << 'EOF'
#!/usr/bin/env python3

import os
import sys
import time

batt_life = "/sys/class/power_supply/battery/capacity"
pwr_led = "/sys/class/gpio/gpio77/value"

while(True):
        if int(open(batt_life, "r").read()) <= 10:
                if int(open(pwr_led, "r").read()) == 1:
                        f = open(pwr_led, "w")
                        f.write("0")
                        f.close()
                        time.sleep(1)
                else:
                        f = open(pwr_led, "w")
                        f.write("1")
                        f.close()
                        time.sleep(1)

        elif int(open(batt_life, "r").read()) <= 20:
                if int(open(pwr_led, "r").read()) == 1:
                        f = open(pwr_led, "w")
                        f.write("0")
                        f.close()
                        time.sleep(30)
                else:
                        time.sleep(30)
        else:
                if int(open(pwr_led, "r").read()) == 0:
                        f = open(pwr_led, "w")
                        f.write("1")
                        f.close()
                        time.sleep(30)
                else:
                        time.sleep(30)
EOF

		echo "Creating 'batt_life_warning.py.green' ..."
		sleep 0.2
		cat > "$BIN/batt_life_warning.py.green" << 'EOF'
#!/usr/bin/env python3

import os
import sys
import time

batt_life = "/sys/class/power_supply/battery/capacity"
pwr_led = "/sys/class/gpio/gpio77/value"

while(True):
        if int(open(batt_life, "r").read()) <= 10:
                if int(open(pwr_led, "r").read()) == 1:
                        f = open(pwr_led, "w")
                        f.write("0")
                        f.close()
                        time.sleep(1)
                else:
                        f = open(pwr_led, "w")
                        f.write("1")
                        f.close()
                        time.sleep(1)

        elif int(open(batt_life, "r").read()) <= 20:
                if int(open(pwr_led, "r").read()) == 1:
                        f = open(pwr_led, "w")
                        f.write("0")
                        f.close()
                        time.sleep(30)
                else:
                        time.sleep(30)
        else:
                if int(open(pwr_led, "r").read()) == 1:
                        f = open(pwr_led, "w")
                        f.write("0")
                        f.close()
                        time.sleep(30)
                else:
                        time.sleep(30)
EOF

		echo "Creating 'fix-power-led.service'..."
		sleep 0.2
		cat > "/etc/systemd/system/fix-power-led.service" << 'EOF'
[Unit]
Description=Initialize Power LED GPIO
Before=batt_led.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fix_power_led
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

		echo "Creating 'fix_power_led.red' ..."
		sleep 0.2
		cat > "$BIN/fix_power_led.red" << 'EOF'
#!/bin/bash
echo 77 > /sys/class/gpio/export 2>/dev/null || true
echo out > /sys/class/gpio/gpio77/direction
echo 1 > /sys/class/gpio/gpio77/value
EOF

		echo "Creating 'fix_power_led.green' ..."
		sleep 0.2
		cat > "$BIN/fix_power_led.green" << 'EOF'
#!/bin/bash
echo 77 > /sys/class/gpio/export 2>/dev/null || true
echo out > /sys/class/gpio/gpio77/direction
echo 0 > /sys/class/gpio/gpio77/value
EOF
	
		echo "Starting service..."
		chmod +x /usr/local/bin/fix_power_led.red /usr/local/bin/fix_power_led.green
		cp "$BIN/fix_power_led.red" "$BIN/fix_power_led"
		chmod +x "$BIN/fix_power_led"
		systemctl enable fix-power-led
		systemctl daemon-reload
	fi

	echo "Creating 'Change LED to Red.sh' ..."
	sleep 0.2
	cat > "$BIN/Change LED to Red.sh" << 'EOF'
#!/bin/bash

#Ensure we can write to the LED gpio77
sudo chmod 777 /sys/class/gpio/export
echo 77 > /sys/class/gpio/export
sudo chmod 777 /sys/class/gpio/gpio77/direction
sudo echo out > /sys/class/gpio/gpio77/direction
sudo chmod 777 /sys/class/gpio/gpio77/value

#Set the LED color to red.
echo 1 > /sys/class/gpio/gpio77/value

#Change the battery life warning script to accomodate for this change
sudo cp -f -v /usr/local/bin/batt_life_warning.py.red /usr/local/bin/batt_life_warning.py
sudo systemctl daemon-reload
sudo systemctl restart batt_led

#Ensure that the LED is set back to RED on boot
sudo cp -f -v /usr/local/bin/fix_power_led.red /usr/local/bin/fix_power_led

#Change the LED script in the Option menu to allow switching back to Green
sudo cp /usr/local/bin/Change\ LED\ to\ Green.sh /opt/system/System/.
sudo rm /opt/system/System/Change\ LED\ to\ Red.sh
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
EOF

	echo "Creating 'Change LED to Green.sh' ..."
	sleep 0.2
	cat > "$BIN/Change LED to Green.sh" << 'EOF'
#!/bin/bash

#Ensure we can write to the LED gpio77
sudo chmod 777 /sys/class/gpio/export
echo 77 > /sys/class/gpio/export
sudo chmod 777 /sys/class/gpio/gpio77/direction
sudo echo out > /sys/class/gpio/gpio77/direction
sudo chmod 777 /sys/class/gpio/gpio77/value

#Set the LED color to Green.
echo 0 > /sys/class/gpio/gpio77/value

#Change the battery life warning script to accomodate for this change
sudo cp -f -v /usr/local/bin/batt_life_warning.py.green /usr/local/bin/batt_life_warning.py
sudo systemctl daemon-reload
sudo systemctl restart batt_led

#Ensure that the LED is set back to Green on boot
sudo cp -f -v /usr/local/bin/fix_power_led.green /usr/local/bin/fix_power_led

#Change the LED script in the Option menu to allow switching back to Green
sudo cp /usr/local/bin/Change\ LED\ to\ Red.sh /opt/system/System/.
sudo rm /opt/system/System/Change\ LED\ to\ Green.sh
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
EOF

	echo "Copying 'Change LED to Red.sh'..."
	sleep 0.2
	cp "$BIN/Change LED to Red.sh" "${SYS}/."

	echo "Removing old files ..."
	rm -f "$BIN/Change LED to Blue.sh" >/dev/null 2>&1
	rm -f "$OPT/Change LED to Red.sh" >/dev/null 2>&1
	sleep 0.2
fi

echo ""
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
curl -L "$URL" -o "${SYS}/CPU Manager.sh" && echo "Success. Installed to $SYS" || echo "Failed."

if grep -qi "^ID=debian" /etc/os-release; then
	echo "Downloading SYSTEMS Manager..."
	URL=$(curl -s https://api.github.com/repos/djparentx/SYSTEMS-Manager-for-dArkOS-RE/releases/latest \
		| python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
	curl -L "$URL" -o "${SYS}/SYSTEMS Manager.sh" && echo "Success. Installed to $SYS" || echo "Failed."
fi

echo "Downloading Button Mapper for Scripts..."
URL=$(curl -s https://api.github.com/repos/djparentx/R36S-Button-Mapper-for-Scripts/releases/latest \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['assets'][0]['browser_download_url'])")
curl -L "$URL" -o "${SYS}/Button Mapper for Scripts.sh" && echo "Success. Installed to $SYS" || echo "Failed."

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
curl -L "$URL" -o "${SYS}/RetroArch One-Click Backup.sh" && echo "Success. Installed to $SYS" || echo "Failed."

echo "-----------------------------------------------"
echo "Setting file permissions..."
chmod -R +x "$OPT"
chmod +x "$BIN/Change LED to Red.sh"
chmod +x "$BIN/Change LED to Green.sh"
chmod +x "$SYS/Change LED to Red.sh"
sleep 0.2

echo ""
echo "Finished! Wait for EmulationStation to restart..."
sleep 2

rm -f "$0"
touch /tmp/es-restart
pkill -f "/usr/bin/emulationstation/emulationstation$"