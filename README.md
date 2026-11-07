# Android Skills

九份中文开发指南，覆盖原生 Android 应用的架构、界面、存储、网络、测试与性能诊断。使用时可直接阅读对应的 `SKILL.md`，或将该技能目录交给支持此格式的工具加载。

## 选择指南

| 工程问题 | 指南 |
| --- | --- |
| 新建应用、设计跨层功能或综合排错 | [应用开发与架构](skills/android-app-development/SKILL.md) |
| 表单状态、页面恢复与异步事件 | [Compose 界面](skills/compose-local-ui/SKILL.md) |
| 导入导出、字段映射与损坏记录恢复 | [CSV 与 JSON](skills/csv-json-local-data/SKILL.md) |
| 账号切换、深链和退出后的返回栈 | [会话与导航](skills/local-session-navigation/SKILL.md) |
| 构建变体、启动组件和安装包不一致 | [应用启动与包名排错](skills/android-launch-package-debugging/SKILL.md) |
| 数据库迁移、查询观察与离线存储 | [Room 数据流](skills/android-room-data-flow/SKILL.md) |
| API 请求、取消、分页和缓存 | [Retrofit 网络请求](skills/retrofit-contextual-api/SKILL.md) |
| 选择单元、数据库、界面或设备测试 | [测试策略](skills/android-testing-strategy/SKILL.md) |
| 定位启动慢、掉帧、ANR 与内存问题 | [性能诊断](skills/android-performance-diagnostics/SKILL.md) |

## 检查

在仓库根目录运行文档校验与校验器回归测试。

```sh
ruby scripts/validate_skills.rb
ruby scripts/test_validate_skills.rb
```

[应用示例与适用范围](PROJECT_SUMMARY.md) · [检查记录](EVALUATION.md) · [参考来源](SOURCES.md)
