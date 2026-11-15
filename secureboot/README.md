# Secure Boot for Omarchy (Limine) + Windows dual boot + themed boot menu

Secure Boot with **your own keys** on Omarchy, keeping Windows (on a second SSD)
bootable, with a boot menu that always shows, offers Omarchy or Windows, and uses
the current Omarchy wallpaper as its background (it follows wallpaper/theme changes).

Set up and tested on an ASUS ROG Strix G713 (AMI firmware, Ryzen + RTX 3050),
Omarchy 4.5, Limine 12.9, limine-mkinitcpio-hook 1.40, sbctl 0.18, kernel 7.2.

It uses only the tools Omarchy already ships plus `sbctl` — the method from the
Arch Wiki ([Limine](https://wiki.archlinux.org/title/Limine),
[Secure Boot](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot))
and the [limine-entry-tool README](https://gitlab.com/Zesko/limine-entry-tool/-/blob/master/README.md).

## Quick start (one go)

```bash
git clone -b omarchy-secureboot https://github.com/thearpankumar/dotfiles.git ~/dotfiles-secureboot
cd ~/dotfiles-secureboot/secureboot

./setup.sh prepare        # Secure Boot must be OFF. Keys, signing, sealing, theme, Windows entry.
systemctl reboot          # check the themed menu shows and both Omarchy and Windows boot

systemctl reboot --firmware-setup
#   BIOS (F7 Advanced) > Security > Secure Boot > Key Management >
#   "Clear Secure Boot keys" / "Reset to Setup Mode".  Keep Secure Boot DISABLED.  F10.

./setup.sh enroll         # firmware in Setup Mode: enroll keys (+Microsoft +OEM), restore dbx

systemctl reboot --firmware-setup
#   BIOS > Security > Secure Boot: Secure Boot Control = Enabled,
#   OS Type = "Windows UEFI mode".  F10.

./setup.sh status         # Secure Boot: enabled (user), everything OK
```

Then boot Windows from the menu and check `msinfo32` → *Secure Boot State: On*.

Run it as your normal user; it calls `sudo` where needed. Every step is
idempotent, so re-running `prepare` is safe (it never overwrites the first
backups). Options: `MENU_TIMEOUT=10 ./setup.sh prepare`,
`WINDOWS_ENTRY="Windows Boot Manager"` (firmware entry name, see `efibootmgr`).

## Before you start

- **BitLocker:** if Windows uses BitLocker / Device Encryption, have the recovery
  key ready (aka.ms/myrecoverykey). Changing Secure Boot keys can trigger one
  recovery prompt. The Windows entry used here (see below) avoids repeat prompts.
- **TPM-unlocked LUKS:** this setup assumes the disk is unlocked with a password.
  If you sealed LUKS to the TPM, re-enroll it after Secure Boot is on.
- **Keep Microsoft + OEM keys.** `enroll` uses `sbctl enroll-keys -m -f`. Without
  them Windows won't boot, and GPU/firmware option ROMs signed by Microsoft can
  fail — the Arch Wiki warns this can brick some laptops (ASUS TUF, ThinkPads).
- The Omarchy installer ISO does not boot with Secure Boot on; turn it off to reinstall.

## What it does

### `prepare` (Secure Boot off)

1. Installs `sbctl` and `efitools`.
2. Backs up the firmware's original `PK`, `KEK`, `db`, `dbx` and the original
   `limine.conf` + `/etc/default/limine` to `/var/lib/secureboot-backup/`.
3. `sbctl create-keys` → your PK/KEK/db keys in `/var/lib/sbctl/keys/`.
4. In `/etc/default/limine` (limine-entry-tool):
   - `ENABLE_ENROLL_LIMINE_CONFIG=yes` — the BLAKE2B checksum of `limine.conf`
     is embedded in `limine_x64.efi`, which is then signed. Nobody can change
     the boot menu or kernel command line without your key, and Limine's editor
     is disabled.
   - `ENABLE_VERIFICATION=yes` — every file Limine loads carries a `#b2sum` hash.
   - `FIND_BOOTLOADERS=no` — stops the auto-added "EFI fallback" entry for the
     unsigned rescue loader (it fails under Secure Boot).
   - Makes sure the enrollment hooks exist:
     `/etc/boot/hooks/pre.d/10-limine-reset-enroll`,
     `/etc/boot/hooks/post.d/90-limine-enroll-config`.
5. Installs the dynamic boot wallpaper (below) and renders the first image.
6. Edits `/boot/limine.conf`:
   - `timeout: 5`, `quiet: no` (Omarchy's default `timeout: 1` + `quiet: yes`
     hides the menu),
   - a theme block (Tokyo Night colours, wallpaper with its hash, translucent
     text panel),
   - a **Windows 11** entry, if the firmware has a "Windows Boot Manager" entry.
7. `limine-mkinitcpio` rebuilds the UKI. Because `sbctl` is now set up:
   - sbctl's mkinitcpio post hook signs the UKI,
   - limine-entry-tool leaves the kernel cmdline **out** of the UKI (signed
     UKIs with an embedded cmdline can't boot Btrfs snapshots), so Limine passes
     it — protected by the sealed `limine.conf`,
   - the post hook enrolls the new config checksum and signs Limine.
8. Verifies: UKI hash = hash in `limine.conf`, config checksum enrolled,
   wallpaper hash, `sbctl verify`.

### `enroll` (firmware in Setup Mode)

1. `sbctl enroll-keys -m -f`: your keys + Microsoft's KEK/db certificates
   (Windows Production PCA 2011, Windows UEFI CA 2023, UEFI CA 2011/2023,
   Option ROM CA 2023) + the firmware's built-in OEM db certificate.
2. **Restores dbx.** Clearing keys in the BIOS also wipes the revocation list
   (`dbx`). The backup is signed with your new KEK and written back
   (`sign-efi-sig-list` + `efi-updatevar`). On the G713: 445 revocations restored.

### Windows entry

```
/Windows 11
    comment: Restart into Windows Boot Manager (firmware entry)
    protocol: efi_boot_entry
    entry: Windows Boot Manager
```

`efi_boot_entry` makes Limine set `BootNext` and reboot into the firmware's own
Windows Boot Manager entry, instead of chainloading `bootmgfw.efi`. Windows then
boots exactly as if picked from the firmware, so BitLocker's TPM measurements
don't change between the two paths. It also keeps working when Windows Update
replaces its boot files, and needs no access to the other SSD (fast boot is fine).
The cost is one quick extra reboot when choosing Windows.

### Theme block in `limine.conf`

```
# >>> boot theme (Tokyo Night + current Omarchy wallpaper, kept in sync by limine-wallpaper.path)
wallpaper: boot():/limine-wallpaper.jpg#<b2sum>
wallpaper_style: stretched
backdrop: 1a1b26
term_background: 401a1b26      # TT=40: translucent panel over the wallpaper
term_margin: 96
term_margin_gradient: 12
interface_branding_color: 7aa2f7
# <<< boot theme
```

Omarchy's own Tokyo Night `term_palette`/`term_foreground` lines stay as they are.

### Dynamic boot wallpaper

```
Omarchy wallpaper/theme change
  └─ ~/.config/systemd/user/omarchy-boot-wallpaper.path        (user)
      └─ ~/.local/bin/omarchy-boot-wallpaper-render
           1920x1080 JPEG, dimmed 55% toward the theme's background colour
           (video wallpapers: a still frame) → /var/lib/omarchy-boot-wallpaper/boot.jpg
  └─ /etc/systemd/system/limine-wallpaper.path                 (root)
      └─ /usr/local/bin/limine-wallpaper-apply
           copy to /boot/limine-wallpaper.jpg, rewrite the hash on the
           `wallpaper:` line, limine-enroll-config (seal + sign), verify
```

The image is decoded only by the unprivileged user service. The root side
never parses it: it copies without following symlinks and only accepts a plain
JPEG under 8 MB. If an update is interrupted, Limine just skips a wallpaper
whose hash doesn't match — the machine still boots.
Change the size with `BOOT_WALLPAPER_SIZE=2560x1440` in the user service.

## Files

| Path in repo | Installed to |
|---|---|
| `setup.sh` | run from the repo |
| `local/bin/omarchy-boot-wallpaper-render` | `~/.local/bin/` |
| `systemd/user/omarchy-boot-wallpaper.{path,service}` | `~/.config/systemd/user/` |
| `bin/limine-wallpaper-apply` | `/usr/local/bin/` |
| `systemd/system/limine-wallpaper.{path,service}` | `/etc/systemd/system/` |

Changed on the system: `/etc/default/limine`, `/boot/limine.conf`,
`/boot/limine-wallpaper.jpg`, `/boot/EFI/limine/limine_x64.efi` (sealed +
signed), `/boot/EFI/Linux/*.efi` (signed), firmware PK/KEK/db/dbx.

## Living with it

- **Updates need nothing.** Kernel, mkinitcpio and Limine updates re-sign and
  re-seal through sbctl's hooks and limine-entry-tool's boot hooks. Snapper
  snapshots taken from now on carry signed kernel images.
- **Editing `/boot/limine.conf` by hand:** run `sudo limine-enroll-config`
  afterwards, otherwise Limine refuses the config — **even with Secure Boot
  off**. Don't hand-edit the `wallpaper:` line (the wallpaper sync owns it).
- Snapshots created **before** the setup have unsigned kernel images: they only
  boot with Secure Boot off.
- `omarchy-refresh-limine` resets `limine.conf` to Omarchy's default: re-run
  `./setup.sh prepare` afterwards to bring back the theme and Windows entry.
- `sbctl verify` lists `EFI/BOOT/BOOTX64.EFI` and old snapshot images as
  unsigned. That's expected: `BOOTX64.EFI` is the deliberately unsigned rescue loader.
- Optional: set a BIOS administrator password, otherwise anyone at the keyboard
  can switch Secure Boot off.

## Recovery

| Problem | Fix |
|---|---|
| Omarchy won't boot after enabling Secure Boot | BIOS → disable Secure Boot; you boot as before. Run `./setup.sh status` to see what's unsigned. |
| Limine panics: config checksum mismatch | Boot the rescue loader: F8 boot menu → `EFI/BOOT/BOOTX64.EFI` (Secure Boot off), then `sudo limine-enroll-config`. |
| Windows says "Selected boot image did not authenticate" | Keys were enrolled without Microsoft's. Clear keys again and re-run `./setup.sh enroll`. |
| Factory keys come back after reboot (MSI) | Disable "Factory Key Provisioning" before clearing keys. |
| Go back to factory Secure Boot | BIOS → Key Management → "Restore Factory Keys" / "Install default Secure Boot keys". Originals are also in `/var/lib/secureboot-backup/`. |

## Sources

- Arch Wiki: [Limine](https://wiki.archlinux.org/title/Limine), [Secure Boot](https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot) (sbctl, OpROMs, dual booting with Windows)
- [Limine CONFIG.md](https://github.com/limine-bootloader/limine/blob/trunk/CONFIG.md) (`efi_boot_entry`, `wallpaper`, `term_background`, hashes, `enroll-config`)
- [limine-entry-tool README](https://gitlab.com/Zesko/limine-entry-tool/-/blob/master/README.md) (`ENABLE_ENROLL_LIMINE_CONFIG`, boot hooks, sbctl integration)
- Omarchy manual: [Dual Boot Install](https://learn.omacom.io/2/the-omarchy-manual/120/dual-boot-install)
- Community: [omacom/omarchy discussion #5306](https://github.com/omacom/omarchy/discussions/5306), [omasecboot](https://github.com/peregrinus879/omasecboot) (BootNext idea for Windows)
