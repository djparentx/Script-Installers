# Script Installers
You only need run one of the scripts, choose the install destination by script. They are self-deleting when finished.

Both installers now work for ArkOS and dArkOS. The System Folder Installer is idempotent so both installers can also now be run as batch update tools.

## Script Installer (Tools)
- Installs Wi-Fi Manager and BT Manager to /opt/system
- Installs all my other scripts to /opt/system/Tools
   - CPU Manager
   - Button Mapper for Scripts
   - RetroArch One-Click Backup
   - SYSTEMS Manager (dArkOS only)
   - R36S Battery Calibration Tool
   - Dave's Retro Shaders
   - Dave's Modern Shaders

---

## System Folder Installer
- Run Blue version if blue LED, Green version if green LED
- Creates a new folder at /opt/system/System
- Installs Wi-Fi Manager and BT Manager to /opt/system
- Installs the following scripts to /opt/system/System:
   - CPU Manager
   - Button Mapper for Scripts
   - RetroArch One-Click Backup
   - SYSTEMS Manager
- Installs the following scripts to /opt/system/Tools:
   - R36S Battery Calibration Tool
   - Dave's Retro Shaders
   - Dave's Modern Shaders
- Moves the following scripts to /opt/system/System:
   - Change LED to Red
   - R36 Control
   - Change Password
   - Change Time
   - Restore Default Drastic Settings
   - Restore Default KODI Controls
   - System Info
   - Update
   - USB Drive Mount
   - USB Drive Unmount
   - Set Launchimage to ascii or pic
   - Set Launchimage to vid
- Moves the following scripts to /roms/backup/old scripts:
   - ZRam Manager
   - Wifi
   - Wifi Toggle
   - Wifi-Toggle
   - Remove ._ Files
   - PS1 - Generate m3u files
   - PS1 - Delete m3u files
   - Network Info
   - Enable Remote Services
   - Disable Remote Services
