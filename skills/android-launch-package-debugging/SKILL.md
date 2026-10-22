---
name: android-launch-package-debugging
description: "排查 Android 包名迁移、构建变体或运行配置引起的 Activity class does not exist、启动包错误及 launcher 不匹配，沿源码、合并 Manifest、APK 和设备安装身份定位最小修复。"
---

# Android 包名与启动排错

## 拆开报错中的身份

`Activity class {installed.id/source.package.MainActivity} does not exist` 中，斜杠前是安装包 ID，后面是组件类名。两者前缀不同不代表非法；要与当前变体、实际 APK 和目标设备一致。

## 按证据定位

1. 记录完整报错、目标设备、当前 module/variant 和失败发生在构建、安装还是启动阶段。先保留原始错误，不先清缓存。
2. 找到 Activity 的声明及 `package`，检查 Gradle `namespace`、`applicationId`、flavor 和 suffix。安装身份可能是 `app.id.debug`，但类仍在 `source.package`。
3. 搜索 main/变体 Manifest 与隐藏运行配置，核对 Activity、activity-alias、exported 和 MAIN/LAUNCHER。相对类名以当前变体的合并 Manifest 解析结果为准。
4. 检查本次构建的 merged Manifest、APK 身份和 launcher；再核对设备安装包和实际启动命令。使用该 module/variant 对应的产物，不从 build 下任取一个同名 APK；生成目录或旧 APK 存在不能证明当前输入正确。

查设备前确认选中的 serial。按当前环境可用工具检查，例如：

```sh
adb devices -l
adb -s <serial> shell pm path <application-id>
adb -s <serial> shell cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.LAUNCHER <application-id>
```

以上 `<...>` 是从项目和设备证据取值的占位。设备不可用时，验证止于产物，不能声称启动成功。

需要实际启动验证时，使用刚解析出的组件执行 `adb -s <serial> shell am start -W -n <resolved-component>`。命令被接受不等于应用持续可用；再确认前台 Activity 和对应进程的崩溃日志。只记录与本次启动相关的输出，不清空全设备日志。

## 选择最小修复

| 证据 | 修复位置 |
| --- | --- |
| 类声明与 Manifest 的目标不一致 | 相关源码 package/import 或输入 Manifest；不编辑合并产物 |
| `.debug`/flavor 身份与运行命令不一致 | 当前变体和运行配置；不强行让所有标识相同 |
| APK 正确但设备仍装旧产物 | 确认部署目标并重新部署；先检查安装错误 |
| APK 与设备一致，IDE 命令仍用旧 ID | 刷新 Gradle model 或修复该运行配置 |
| 启动解析成功但进程随后崩溃 | 转查对应崩溃堆栈；不要继续当作包名不存在处理 |

包名迁移按证据覆盖源码和测试的 package/import、Gradle、输入 Manifest 与相关运行配置。目录名、项目名、主题名不必为了“看起来一致”而全改；不添加旧包名 Activity 掩盖错误目标。

## 构建和数据边界

- Kotlin 编译、完整 APK 构建、安装和设备启动是四种不同证据。只报告实际完成的层级。
- `applicationId` 改变会形成新安装身份；旧包的 preferences 不会自动出现。先检查身份，不把“数据消失”直接判断为存储损坏。
- 仅当错误指向 SDK/资源兼容时才调整相关配置；minSdk 是安装下限，targetSdk 是目标行为，不能互相代替。
- 常规同步、重新构建和部署无效后再考虑缓存。卸载会清除对应本地数据，删除 `.idea` 会影响配置，均不作为默认修复。

交付保留“报错 -> 源码/变体 -> APK -> 设备”的证据链、修改位置和未验证环节。源码不可读时说明证据止点，不凭空恢复包名或改 SDK。

## 按需参考

需要区分 flavor、Activity 类名和安装身份时，读取 [安装身份与证据场景](references/identity-evidence.md)。示例包名与 SDK 值不能代替目标仓库配置。
