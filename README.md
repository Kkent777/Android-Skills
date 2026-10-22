# Android Skills

面向各类原生 Android 应用的开发与维护技能包，可用于工具、笔记、内容、零售、日程、媒体及设备相关应用。技能按技术问题划分，业务规则从目标产品和工程读取。

## 从哪里开始

新建应用、跨层功能或综合排错，先读 [android-app-development](skills/android-app-development/SKILL.md)。它帮助确定需求、技术栈、状态寿命、数据来源、平台边界与验证路径。

已有明确问题时直接进入专项：

| Skill | 适用任务 | 关键判断 |
| --- | --- | --- |
| [android-app-development](skills/android-app-development/SKILL.md) | 新建或维护应用、跨层功能、综合排错 | 选型、架构、平台能力与分层验证 |
| [compose-local-ui](skills/compose-local-ui/SKILL.md) | Compose 页面、表单、列表、选择器与异步事件 | 状态归属、生命周期、保存后更新 |
| [csv-json-local-data](skills/csv-json-local-data/SKILL.md) | CSV 导入导出、JSON 映射和旧式存储修复 | 数据契约、坏记录、恢复与作用域 |
| [local-session-navigation](skills/local-session-navigation/SKILL.md) | 本地或远端认证、账号切换、深链与返回栈 | 真实身份、授权边界、过期请求 |
| [android-launch-package-debugging](skills/android-launch-package-debugging/SKILL.md) | Activity 启动失败、变体与安装包错配 | 源码、产物、安装与设备证据 |
| [android-room-data-flow](skills/android-room-data-flow/SKILL.md) | Room 表结构、迁移、导入、缓存与持久状态 | 保数据、查询观察、离线同步 |
| [retrofit-contextual-api](skills/retrofit-contextual-api/SKILL.md) | REST API、分页、取消、错误与结果保存 | 请求契约、幂等性、缓存与可选生成服务 |
| [android-testing-strategy](skills/android-testing-strategy/SKILL.md) | 单元、Room、UI、截图与设备测试的选择和配置 | 先盘点，按风险验证，替身与真实平台分清 |
| [android-performance-diagnostics](skills/android-performance-diagnostics/SKILL.md) | 启动慢、掉帧、ANR、内存与包体问题 | 生产近似基线、证据定位、版本分流与复测 |

## 使用原则

- 新工程按需求选型，既有 Compose、View/XML、Fragment、Java 或混合工程沿原约定维护。
- 无账号应用无需增加登录，无持久数据需求无需增加 Room，离线功能无需增加 Retrofit。
- 已有 MVVM、MVI、依赖注入或序列化方案优先复用，技能不强制更换框架。
- 任务涉及相机、定位、蓝牙、媒体、后台、通知或支付时，按通用入口识别平台限制，再核对项目版本和服务方官方资料。
- 每个入口可独立使用；references 里的例子是按需读取的检查场景，不是固定表名、类名、接口或业务模型。
- 编译、打包、设备行为与远端服务成功分别报告，格式检查不能证明实际应用可用。

这些技能提供跨应用的开发决策和故障处理方法，不宣称内置所有 Android SDK 的完整实现模板。专项按需求使用，不要求每次加载全部九项。

## 例子

> 使用 android-app-development 检查这个购物清单应用，先确认已有架构，再实现离线编辑和同步；按实际功能选择专项。

> 使用 compose-local-ui 排查笔记保存后列表不更新的问题，保留现有 ViewModel 和数据层。

> 使用 android-launch-package-debugging 核对当前 flavor 的安装身份和启动组件。

> 使用 android-testing-strategy，为这次离线保存与同步改动选择最小有效回归，复用现有测试框架。

> 使用 android-performance-diagnostics，分析列表掉帧的已有 trace，先给证据再做可复测的小修改。

## 检查与资料

在资料包目录运行：

```sh
ruby scripts/validate_skills.rb
ruby scripts/test_validate_skills.rb
```

[校验器](scripts/validate_skills.rb) 检查 metadata、正文、围栏与本地行内链接；回归脚本验证校验器的正常和失败路径。它们不运行 Android、网络或硬件测试。实际结果见 [EVALUATION.md](EVALUATION.md)。

[能力与使用边界](PROJECT_SUMMARY.md) 说明如何把这些方法用于不同类型应用。GitHub 分发只包含通用技能、参考、脚本和说明；本地历史归档与任务计划不参与分发，也不是技能的运行依赖。

本轮参考 Android 官方 android/skills 补充测试与性能流程；固定提交、文件对照、采用点和舍弃点见 [SOURCES.md](SOURCES.md)。只读研究外部内容，未执行其安装或脚本。

仓库名为 Android-Skills。按所用工具的技能加载方式选择单个 SKILL.md 或专项，不会因克隆仓库而自动安装到全局 skills 目录。
