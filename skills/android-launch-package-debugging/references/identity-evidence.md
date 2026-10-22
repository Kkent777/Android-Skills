# 安装身份与启动证据场景

以下包名为通用示例，不是目标项目配置或实际设备验证结果。

## debug 后缀与源码类名

安装身份可能是 com.example.catalog.debug，而 Activity 类是 com.example.catalog.MainActivity。二者不同可以合法，不应直接把所有 package 字符串替换成相同值。

核对顺序为源码 package/类 -> 当前 variant -> 合并 Manifest -> 当前 APK -> 目标设备已安装包 -> 实际启动组件。以真实产物为准，不从 build 目录任取旧 APK。

## 多模块或多 flavor

目标应用模块可能不叫 app，开发/测试/生产可能有不同 launcher、applicationIdSuffix、环境配置和安装包。发现目标任务后再构建，测试环境的成功不能证明生产变体正确。

activity-alias 也可能承担 launcher 入口；区分可启动 alias 与实际 Activity 类，核对 exported、intent-filter 和组件是否启用。

## IDE 仍使用旧运行目标

若 APK 和设备安装身份一致，而 IDE 调旧包名，修复具体运行配置或同步 Gradle model。不要新增同名旧 Activity 掩盖错误，也不默认删除整个 .idea。

## “启动成功”但随后崩溃

am start -W 返回成功只说明启动请求被接受。验证前台 Activity、进程和对应崩溃日志；不清空全设备日志，不把运行期异常继续归为包名错误。

## 数据似乎丢失

applicationId 改变产生新安装身份，原应用私有数据不会自动出现。先确认包和变体，不直接认定数据库损坏。卸载会清除数据，不能作为常规起手动作。

## 交付证据

分别报告编译、打包、安装与运行结果。设备不可用则止于构建产物，保存错误文本和未验证路径。
