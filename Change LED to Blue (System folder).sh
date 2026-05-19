#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -E "$0" "$@"
fi

OPT="/opt/system"
SYS="$OPT/System"
BIN="/usr/local/bin"

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

#Change the LED script in the Option menu to allow switching back to Blue
sudo cp /usr/local/bin/Change\ LED\ to\ Blue.sh /opt/system/System/.
sudo rm /opt/system/System/Change\ LED\ to\ Red.sh
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
EOF

echo "Creating 'Change LED to Blue.sh' ..."
sleep 0.2
	cat > "$BIN/Change LED to Blue.sh" << 'EOF'
#!/bin/bash

#Ensure we can write to the LED gpio77
sudo chmod 777 /sys/class/gpio/export
echo 77 > /sys/class/gpio/export
sudo chmod 777 /sys/class/gpio/gpio77/direction
sudo echo out > /sys/class/gpio/gpio77/direction
sudo chmod 777 /sys/class/gpio/gpio77/value

#Set the LED color to Blue.
echo 0 > /sys/class/gpio/gpio77/value

#Change the battery life warning script to accomodate for this change
sudo cp -f -v /usr/local/bin/batt_life_warning.py.green /usr/local/bin/batt_life_warning.py
sudo systemctl daemon-reload
sudo systemctl restart batt_led

#Ensure that the LED is set back to Blue on boot
sudo cp -f -v /usr/local/bin/fix_power_led.green /usr/local/bin/fix_power_led

#Change the LED script in the Option menu to allow switching back to Blue
sudo cp /usr/local/bin/Change\ LED\ to\ Red.sh /opt/system/System/.
sudo rm /opt/system/System/Change\ LED\ to\ Blue.sh
printf "\033c" >> /dev/tty1
sudo systemctl restart emulationstation
EOF

echo "Copying 'Change LED to Red.sh'..."
sleep 0.2
cp "$BIN/Change LED to Red.sh" "${SYS}/."

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

echo "Removing old files ..."
sleep 0.2
rm -f "$OPT/Change LED to Red.sh" >/dev/null 2>&1

echo "Setting file permissions..."
sleep 0.2
chmod +x "$BIN/Change LED to Red.sh"
chmod +x "$BIN/Change LED to Blue.sh"
chmod +x "$SYS/Change LED to Red.sh"

echo "Starting service..."
chmod +x /usr/local/bin/fix_power_led.red /usr/local/bin/fix_power_led.green
cp "$BIN/fix_power_led.red" "$BIN/fix_power_led"
chmod +x "$BIN/fix_power_led"
systemctl enable fix-power-led
systemctl daemon-reload

echo "Success!"
sleep 2

rm -f "$0"