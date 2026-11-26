SKIPUNZIP=0

[ "$BOOTMODE" = true ] || abort '! Install from Magisk on a booted Android system.'
[ ! -d /data/adb/modules/packageinstaller ] || abort '! Remove the legacy packageinstaller module and reboot first.'

apk=/system/priv-app/PackageInstaller/PackageInstaller.apk
[ -s "$MODPATH$apk" ] || abort '! The module APK is missing or empty.'

active=/data/adb/modules/com.android.packageinstaller/module.prop
if [ -f "$active" ]; then
  feed=$(sed -n 's/^updateJson=//p' "$MODPATH/module.prop")
  [ -n "$feed" ] && grep -Fqx "updateJson=$feed" "$active" || abort '! Remove the other AOSP module and reboot before switching sources.'
fi

# NoMount resolves the module's system tree at boot; do not inspect the unmounted stock path here.
set_perm_recursive "$MODPATH/system" 0 0 0755 0644 || abort '! Could not set APK permissions.'
ui_print '- InstallerX Revived staged. Reboot to activate.'
