# InstallerX Revived 自签名 AOSP 模块

以 `com.android.packageinstaller` 运行的 InstallerX Revived 系统安装器。GitHub Actions 每 6 小时检查上游最新稳定版，用本仓库的固定签名构建 ZIP。首次在 Magisk 从本地安装，之后在 Magisk 模块页点「更新」，完成后重启。[InstallerX Revived 上游](https://github.com/wxxsfxyzm/InstallerX-Revived/releases/latest)

## 首次安装

1. 如果已有系统安装器替换模块，先导出 InstallerX 设置，卸载旧模块并重启，确认原厂安装器恢复。
2. 用 `adb shell pm path --user 0 com.android.packageinstaller` 检查 ROM，预期回显 `package:/system/priv-app/PackageInstaller/PackageInstaller.apk`。模块仅支持这个系统 APK 路径。厂商包名、不同路径、拆分 APK 或 `/data/app` 更新会导致刷入检查失败。
3. 下载发行页的 `InstallerX-Revived-AOSP-<版本>.zip`，在 Magisk 从本地安装并重启。[模块发行页](https://github.com/Unwilledflow/installerx-revived-aosp/releases)
4. 打开一个 APK 验证 InstallerX 是否接管。之后由 Magisk 下载更新 ZIP，重启后生效。

卸载模块会清理 Android 的包解析缓存，保留安装器应用数据。切换签名或 ROM 本身仍可能影响应用数据，迁移前请备份。

## 构建

[构建工作流](.github/workflows/build.yml)从上游稳定标签检出源码，验证包名、版本号和 APK 签名，再发布 Release 和 Magisk 的 `update.json`。首次跑通前需要仓库 Secret：`SIGNING_KEY_STORE_BASE64`、`SIGNING_STORE_PASSWORD`、`SIGNING_KEY_ALIAS`、`SIGNING_KEY_PASSWORD`。当前上游稳定版的 Miuix 依赖已发布在公开 Maven Central，不需要 GitHub PAT。[签名指纹](signer.sha256)用于校验后续构建沿用同一密钥。签名凭据从 Actions Secrets 读取。若上游日后需要私有 GitHub Packages 依赖，请在 workflow 中添加一个限定为 `read:packages` 的 Token Secret；不要把令牌直接写进配置。

模块结构基于 ByteJuno，2026-11-26 改为跟随稳定版、由本仓库签名和发布，增加刷入路径检查并移除了卸载时的应用数据清除。按 GPL-3.0 发布。[ByteJuno 原始版本](https://github.com/ByteJuno/InstallerX-Revived-AOSP-Module/tree/0f0c53dda33f1da7146471f7e157b3d35c885699) · [许可证](LICENSE)
