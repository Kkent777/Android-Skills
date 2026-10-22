# GitHub 借鉴来源与改写记录

## 选定项目

本轮只选择一个主要参照：[Android 官方 android/skills](https://github.com/android/skills)。它采用可按任务加载的技能和参考资料，覆盖不同 Android 专项，适合作为本技能包的外部对照。

- 阅读日期：2026-10-19。
- 固定提交：`5bda39f154fb859a08d45e2392f3568e049f83fb`，该提交记录日期为 2026-10-14。
- 仓库说明：[固定版本 README](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/README.md)。
- 上游许可证：[Apache License 2.0](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/LICENSE.txt)。

固定链接用于追溯这轮阅读内容，不代表未来 Android/工具版本仍符合当时的实现前提。后续实际开发按项目版本重新核对当前官方资料。

## 具体采用与取舍

| 已读上游文件 | 借鉴的方法 | 本包落点 | 没有采用的默认规则 |
| --- | --- | --- | --- |
| [testing/testing-setup/SKILL.md](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/testing/testing-setup/SKILL.md) | 先盘点测试栈，再区分替身、数据库、UI、截图与设备证据 | [android-testing-strategy](skills/android-testing-strategy/SKILL.md) | 不因没有 DI 就安装 Hilt；不默认安装所有测试框架或固定截图尺寸 |
| [jetpack-compose/jetpack-compose-performance/SKILL.md](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/jetpack-compose/jetpack-compose-performance/SKILL.md) | 检查测量环境，按状态、布局、列表、绘制等成本查原因 | [android-performance-diagnostics](skills/android-performance-diagnostics/SKILL.md) | 不采用全项目强制扫描、统一稳定性标注/集合规则或微优化清单照搬 |
| [performance/r8-analyzer/SKILL.md](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/performance/r8-analyzer/SKILL.md) | 按工具版本选择分析路径，区分产物证据与静态判断 | [性能诊断的构建分流](skills/android-performance-diagnostics/SKILL.md) | 不照搬固定模块、任务、脚本路径；不自动升级 AGP，不伪造量化报告 |
| [profilers/android-profiler/SKILL.md](https://github.com/android/skills/blob/5bda39f154fb859a08d45e2392f3568e049f83fb/profilers/android-profiler/SKILL.md) | 区分录制与分析意图，先核对环境和已有证据 | [通用开发入口](skills/android-app-development/SKILL.md)及性能专项 | 不复制上游环境安装或默认触发范围，不在无必要时增加工具 |

## 改写方式与许可边界

本轮借鉴的是任务划分、盘点、条件分流和验证结构；技能正文结合本包已有约束重新编写，没有复制上游脚本、Kotlin 代码块或逐段翻译其正文。许可证链接用于标明上游许可，不把它擅自声明为本包全部内容的许可证，也不暗示官方认可本包。

未来如果实际复制或改编上游受保护文本、代码或资源，应保留所需许可证、署名及相关声明，并清楚标明修改；当前没有把整个上游仓库作为本包内容分发。

## 本轮验证能证明什么

仓库和文件存在、固定提交及许可已读取；文档结构与本包校验器回归在本地执行。没有在 Android 工程中验证上游全部建议，也没有执行上游脚本、安装插件、调用付费服务或替用户发布代码。

新增方法对应的场景检查与执行结果见 [EVALUATION.md](EVALUATION.md)。
