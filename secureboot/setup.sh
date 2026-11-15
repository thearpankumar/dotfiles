#!/bin/bash
# Omarchy Secure Boot with your own keys (sbctl) + Limine config sealing,
# a Windows entry in the boot menu, and a themed boot menu whose wallpaper
# follows the Omarchy wallpaper.
#
# Run as your normal user (it calls sudo itself), in this order:
#   ./setup.sh prepare   # Secure Boot OFF: keys, signing, sealing, theme, Windows entry
#   (BIOS: clear Secure Boot keys / Reset to Setup Mode, keep Secure Boot OFF)
#   ./setup.sh enroll    # firmware in Setup Mode: enroll keys (+Microsoft +OEM), restore dbx
#   (BIOS: enable Secure Boot, OS Type = Windows UEFI mode)
#   ./setup.sh status    # check everything
#
# See README.md next to this script for the full explanation and recovery.
set -euo pipefail

HERE=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ESP=/boot
CONF=$ESP/limine.conf
LIMINE_EFI=$ESP/EFI/limine/limine_x64.efi
DEF=/etc/default/limine
BACKUP=/var/lib/secureboot-backup
EFIVARS=/sys/firmware/efi/efivars
GV=8be4df61-93ca-11d2-aa0d-00e098032b8c
MS_GUID=77fa9abd-0359-4d32-bd60-28f4e78f784b
WINDOWS_ENTRY=${WINDOWS_ENTRY:-Windows Boot Manager}   # firmware boot entry name
MENU_TIMEOUT=${MENU_TIMEOUT:-5}

say()  { printf '\n\033[1;34m== %s\033[0m\n' "$*"; }
ok()   { printf '\033[32mOK\033[0m   %s\n' "$*"; }
bad()  { printf '\033[31mFAIL\033[0m %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

efivar_byte() { [[ -r $EFIVARS/$1-$GV ]] && od -An -t u1 -j4 -N1 "$EFIVARS/$1-$GV" | tr -d ' '; }
sb_enabled()  { [[ $(efivar_byte SecureBoot) == 1 ]]; }
setup_mode()  { [[ $(efivar_byte SetupMode) == 1 ]]; }
sbctl_ready() { sudo sbctl setup --print-state --json 2>/dev/null | grep -q '"installed": true'; }

preflight() {
  [[ $EUID -ne 0 ]] || die "run as your normal user; the script uses sudo where needed"
  [[ -d /sys/firmware/efi ]] || die "not booted in UEFI mode"
  command -v limine-entry-tool >/dev/null || die "limine-entry-tool not found (this is for Omarchy's Limine setup)"
  sudo test -f "$CONF" || die "$CONF not found"
  sudo -v
}

set_opt() {  # set_opt KEY VALUE in /etc/default/limine
  if sudo grep -q "^$1=" "$DEF"; then
    sudo sed -i "s|^$1=.*|$1=$2|" "$DEF"
  else
    printf '\n%s=%s\n' "$1" "$2" | sudo tee -a "$DEF" >/dev/null
  fi
}

install_wallpaper_sync() {
  say "Install the dynamic boot wallpaper (user render + root apply)"
  install -d ~/.local/bin ~/.config/systemd/user
  install -m 0755 "$HERE/local/bin/omarchy-boot-wallpaper-render" ~/.local/bin/
  cp "$HERE"/systemd/user/omarchy-boot-wallpaper.{path,service} ~/.config/systemd/user/
  sudo install -m 0755 "$HERE/bin/limine-wallpaper-apply" /usr/local/bin/limine-wallpaper-apply
  sudo cp "$HERE"/systemd/system/limine-wallpaper.{path,service} /etc/systemd/system/
  sudo install -d -o "$USER" -g "$(id -gn)" -m 0755 /var/lib/omarchy-boot-wallpaper
  # First render now, so the theme block below has an image and a hash.
  ~/.local/bin/omarchy-boot-wallpaper-render
  [[ -f /var/lib/omarchy-boot-wallpaper/boot.jpg ]] || die "no wallpaper rendered (is an Omarchy wallpaper set?)"
  sudo install -m 0644 /var/lib/omarchy-boot-wallpaper/boot.jpg "$ESP/limine-wallpaper.jpg"
}

edit_limine_conf() {
  say "Theme the boot menu + add the Windows entry"
  local wp_hash windows=""
  wp_hash=$(sudo b2sum "$ESP/limine-wallpaper.jpg" | cut -d' ' -f1)
  if sudo efibootmgr | grep -qF "$WINDOWS_ENTRY"; then
    windows=$WINDOWS_ENTRY
    echo "Firmware entry '$WINDOWS_ENTRY' found: adding Windows to the menu"
  else
    echo "No firmware entry named '$WINDOWS_ENTRY': skipping the Windows entry"
  fi
  sudo python3 -I - "$CONF" "$wp_hash" "$MENU_TIMEOUT" "$windows" <<'PY'
import sys, re
path, wp_hash, timeout, windows = sys.argv[1:5]
text = open(path).read()

# Idempotent: drop what a previous run added.
text = re.sub(r'# >>> boot theme.*?# <<< boot theme\n', '', text, flags=re.S)
text = re.sub(r'\n?/Windows 11\n(?:[ \t]+.*\n?)*', '\n', text)

first = text.index('\n/') + 1          # first menu entry
header, body = text[:first], text[first:]

# Always show the menu (Omarchy ships timeout 1 + quiet, which hides it).
header = re.sub(r'(?m)^timeout:.*$', f'timeout: {timeout}', header)
header = re.sub(r'(?m)^quiet:.*$', 'quiet: no', header)
header = re.sub(r'(?m)^(term_background|backdrop|interface_branding_colou?r):.*\n', '', header)

theme = f"""# >>> boot theme (Tokyo Night + current Omarchy wallpaper, kept in sync by limine-wallpaper.path)
wallpaper: boot():/limine-wallpaper.jpg#{wp_hash}
wallpaper_style: stretched
backdrop: 1a1b26
term_background: 401a1b26
term_margin: 96
term_margin_gradient: 12
interface_branding_color: 7aa2f7
# <<< boot theme
"""
header = header.rstrip('\n') + '\n\n' + theme
out = header + body.rstrip('\n') + '\n'
if windows:
    out += f"""
/Windows 11
    comment: Restart into Windows Boot Manager (firmware entry)
    protocol: efi_boot_entry
    entry: {windows}
"""
open(path, 'w').write(out)
PY
}

verify() {
  say "Verify"
  local f h rc=0
  for f in $(sudo find "$ESP/EFI/Linux" -maxdepth 1 -name '*.efi' 2>/dev/null); do
    h=$(sudo b2sum "$f" | cut -d' ' -f1)
    if sudo grep -q "${f#"$ESP"/}#$h" "$CONF"; then ok "hash in limine.conf matches $f"; else bad "hash mismatch for $f"; rc=1; fi
  done
  h=$(sudo b2sum "$CONF" | cut -d' ' -f1)
  if sudo grep -qa "$h" "$LIMINE_EFI"; then ok "limine.conf checksum enrolled in $LIMINE_EFI"; else bad "limine.conf checksum NOT enrolled"; rc=1; fi
  h=$(sudo b2sum "$ESP/limine-wallpaper.jpg" 2>/dev/null | cut -d' ' -f1)
  if [[ -n $h ]] && sudo grep -q "limine-wallpaper.jpg#$h" "$CONF"; then ok "boot wallpaper hash"; else bad "boot wallpaper hash"; fi
  if sudo grep -q '^/Windows 11' "$CONF"; then ok "Windows entry present"; else echo "--   no Windows entry"; fi
  if sudo grep -q '^/EFI fallback' "$CONF"; then bad "'EFI fallback' entry present (fails under Secure Boot)"; rc=1; else ok "no unsigned 'EFI fallback' menu entry"; fi
  echo "--- sbctl verify (snapshot images and EFI/BOOT/BOOTX64.EFI being unsigned is expected)"
  sudo sbctl verify || true
  return $rc
}

cmd_prepare() {
  preflight
  sb_enabled && die "Secure Boot is already enabled. Disable it in the BIOS before 'prepare'."

  say "Install sbctl and efitools"
  sudo pacman -S --needed --noconfirm sbctl efitools

  say "Back up the current firmware keys and boot configs to $BACKUP"
  sudo install -d -m 0700 "$BACKUP"
  for v in PK KEK db dbx; do
    sudo test -s "$BACKUP/original_$v.esl" || sudo efi-readvar -v "$v" -o "$BACKUP/original_$v.esl" || true
  done
  sudo test -f "$BACKUP/limine.conf.orig"    || sudo cp "$CONF" "$BACKUP/limine.conf.orig"
  sudo test -f "$BACKUP/default-limine.orig" || sudo cp "$DEF" "$BACKUP/default-limine.orig"
  sudo ls -la "$BACKUP"

  say "Create your Secure Boot keys"
  if sbctl_ready; then echo "keys already exist"; else sudo sbctl create-keys; fi

  say "Turn on Limine config sealing + file verification (limine-entry-tool)"
  set_opt ENABLE_ENROLL_LIMINE_CONFIG yes
  set_opt ENABLE_VERIFICATION yes
  # Omarchy's FIND_BOOTLOADERS=yes adds an "EFI fallback" entry for the unsigned
  # rescue loader EFI/BOOT/BOOTX64.EFI, which fails under Secure Boot. Windows
  # gets its own entry below, so turn auto-detection off and drop that entry.
  set_opt FIND_BOOTLOADERS no
  sudo grep -q '^/EFI fallback' "$CONF" && sudo limine-remove-entry "EFI fallback" 0 || true
  # The enrollment hooks ship with limine-mkinitcpio-hook; make sure they exist.
  sudo install -d /etc/boot/hooks/pre.d /etc/boot/hooks/post.d
  sudo test -e /etc/boot/hooks/pre.d/10-limine-reset-enroll  || sudo ln -s /usr/bin/limine-reset-enroll  /etc/boot/hooks/pre.d/10-limine-reset-enroll
  sudo test -e /etc/boot/hooks/post.d/90-limine-enroll-config || sudo ln -s /usr/bin/limine-enroll-config /etc/boot/hooks/post.d/90-limine-enroll-config

  install_wallpaper_sync
  edit_limine_conf

  say "Rebuild the kernel image (signed by sbctl's mkinitcpio hook), regenerate entries, seal + sign Limine"
  sudo limine-mkinitcpio
  sudo limine-enroll-config

  say "Enable the boot wallpaper sync"
  sudo systemctl daemon-reload
  sudo systemctl enable --now limine-wallpaper.path
  systemctl --user daemon-reload
  systemctl --user enable --now omarchy-boot-wallpaper.path

  verify || die "verification failed: do NOT continue to the BIOS steps"
  sudo sbctl status || true
  cat <<'EOF'

Next:
  1. Reboot once and check the boot menu shows (themed, with Windows).
  2. systemctl reboot --firmware-setup
     BIOS > Security > Secure Boot > Key Management > "Clear Secure Boot keys"
     (or "Reset to Setup Mode"). Keep Secure Boot DISABLED. Save + exit.
  3. Boot Omarchy and run:  ./setup.sh enroll
EOF
}

cmd_enroll() {
  preflight
  setup_mode || die "firmware is not in Setup Mode. Clear the Secure Boot keys in the BIOS first."
  sbctl_ready || die "no sbctl keys; run './setup.sh prepare' first"

  say "Enroll your keys + Microsoft keys (-m) + the firmware's built-in OEM keys (-f)"
  if ls "$EFIVARS"/dbDefault-$GV >/dev/null 2>&1; then
    sudo sbctl enroll-keys -m -f
  else
    echo "Firmware exposes no built-in default keys; enrolling with Microsoft keys only"
    sudo sbctl enroll-keys -m
  fi

  say "Restore the dbx revocation list (clearing keys in the BIOS empties it)"
  local n
  n=$(sudo efi-readvar -v dbx 2>/dev/null | grep -c 'Hash:' || true)
  if (( n > 0 )); then
    echo "dbx already has $n entries"
  elif sudo test -s "$BACKUP/original_dbx.esl"; then
    local K=/var/lib/sbctl/keys/KEK
    sudo sign-efi-sig-list -g "$MS_GUID" -k "$K/KEK.key" -c "$K/KEK.pem" dbx \
      "$BACKUP/original_dbx.esl" "$BACKUP/restore_dbx.auth"
    sudo efi-updatevar -f "$BACKUP/restore_dbx.auth" dbx
    echo "dbx restored: $(sudo efi-readvar -v dbx | grep -c 'Hash:') entries"
  else
    echo "WARNING: no dbx backup found; dbx stays empty (Windows Update will refill it over time)"
  fi

  say "Enrolled certificates"
  for v in PK KEK db; do
    echo "[$v]"; sudo efi-readvar -v "$v" | grep -A1 'Subject:' | grep -v -e '--' -e 'Subject:' | sed 's/^ */  /'
  done
  cat <<'EOF'

Next:
  systemctl reboot --firmware-setup
  BIOS > Security > Secure Boot: Secure Boot Control = Enabled,
  OS Type = "Windows UEFI mode" (ASUS). Save + exit, boot Omarchy, then:
    ./setup.sh status
EOF
}

cmd_status() {
  preflight
  say "Firmware"
  bootctl status 2>/dev/null | grep -E 'Secure Boot|Current Boot Loader' -A1 | grep -E 'Secure Boot|Product' || true
  sudo sbctl status || true
  verify || true
  say "Boot wallpaper sync"
  systemctl is-active limine-wallpaper.path >/dev/null && ok "limine-wallpaper.path active" || bad "limine-wallpaper.path inactive"
  systemctl --user is-active omarchy-boot-wallpaper.path >/dev/null && ok "omarchy-boot-wallpaper.path active" || bad "omarchy-boot-wallpaper.path inactive"
}

case "${1:-}" in
  prepare) cmd_prepare ;;
  enroll)  cmd_enroll ;;
  status)  cmd_status ;;
  *) sed -n '2,15p' "$0"; exit 1 ;;
esac
