# CCNUthesis 开发 TODO

本清单只记录 LaTeX 模板、文档、测试和发布流程相关工作。

## 当前重点

- [ ] 完善本科、硕士、博士三类完整示例文档。
- [ ] 补充不同字体、参考文献样式和盲审模式的编译测试。
- [ ] 检查 TeX Live 新版本下的宏包兼容性。
- [ ] 持续改进用户手册中的配置示例和故障排查说明。

## 工程维护

- [x] 统一 `source/`、`test/`、`docs/` 和 `scripts/` 的职责边界。
- [x] 建立可并行执行的 `scripts/test.sh` 编译测试流程。
- [x] 建立非交互式版本校验和发布打包流程。
- [ ] 为关键模板选项增加最小可复现 TeX fixture。
- [ ] 检查发布压缩包中的路径、资源和辅助文件清理结果。
- [ ] 在 CI 中固定必要的 TeX Live 宏包清单。

## 发布前检查

1. 运行 `make test-parallel`，确认所有 fixture 编译通过。
2. 运行 `make docs`，确认用户手册可生成。
3. 使用 `make release-check VERSION=x.y.z` 校验版本参数。
4. 更新 `CHANGELOG.md`，并检查发布包不包含个人资料或构建产物。
