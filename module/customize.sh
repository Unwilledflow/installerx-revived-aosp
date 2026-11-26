SKIPUNZIP=0

[ "$BOOTMODE" = true ] || abort '! Install from Magisk on a booted Android system.'
[ ! -d /data/adb/modules/packageinstaller ] || abort '! Remove the legacy packageinstaller module and reboot first.'

pkg=com.android.packageinstaller
apk=/system/priv-app/PackageInstaller/PackageInstaller.apk
[ -f "$apk" ] || abort '! The expected AOSP system APK path is absent.'
[ "$(/system/bin/pm path --user 0 "$pkg")" = "package:$apk" ] || abort '! This module requires the AOSP package at the expected path, without a /data update or splits.'

active=/data/adb/modules/com.android.packageinstaller/module.prop
if [ -f "$active" ]; then
  feed=$(sed -n 's/^updateJson=//p' "$MODPATH/module.prop")
  [ -n "$feed" ] && grep -Fqx "updateJson=$feed" "$active" || abort '! Remove the other AOSP module and reboot before switching sources.'
fi

[ -s "$MODPATH$apk" ] || abort '! The module APK is missing or empty.'
set_perm_recursive "$MODPATH/system" 0 0 0755 0644 || abort '! Could not set APK permissions.'
# Android may reuse parse entries if the APK has an older timestamp than its cache.
touch "$MODPATH$apk" || abort '! Could not refresh APK timestamp.'
ui_print '- InstallerX Revived staged. Reboot to activate.'
