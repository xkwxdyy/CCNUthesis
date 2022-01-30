# 更新日志

## [v1.0.1] - 2022-01-30
### Fixed
- 解决`\mathcal`和`\mathscr`效果相同的问题 （[#I4SKB1](https://gitee.com/xkwxdyy/CCNUthesis/issues/I4SKB1)）

## [v1.0.0] - 2022-01-28
### Added
- 增加bib文件参考文献部分注释
- 添加`choices`宏包及其示例
- 罗列已添加的宏包在正文注释，防止部分宏包冲突
- 完善README.md

### Changed
- 修改`proof`环境证毕符号
- 调整了声明页的页边距与其它部分距离
- 重定义了`\emph`命令
- 修改“关键字”为“关键词”
- 移动`main.tex`文件中不需要用户修改的style到`CCNUthesis.cls`中

### Fixed
- 重新优化关键词处的代码

## [v0.0.5] - 2022-01-27
### Added
- 参考文献注释信息
- 增加了`latexmkrc`文件

### Changed
- 将最后一页的原创声明移动到第二页并修改完成
- 去掉`main.tex`中的字体设置
- tocdepth设置移动到ctex的key_set中
- 重新调整目录chapter和正文chapter的格式
- 将目录页的pagestyle设置合并到`\tableofcontents`中
- 更改原来的摘要页为华师样式
- 修改了`\frontmatter`和`\mainmatter`的计数器，达到模版要求的效果

### Removed
- 去掉目录页码

## [v0.0.4] - 2022-01-25
### Added
- 完善示例文件结构
- 增加参考文献bib文件
- 增加`\ccnu_set_to_width:Nn`函数（等效于`\settowidth`）
- 增加`\xeCJKsetup{AutoFakeBold}`（被注释掉）

### Removed
- 去掉封面设置中的`\xeCJKsetup{AutoFakeBold}`（因为已经统一设置过）

## [v0.0.3] - 2022-01-24

### Added
- 增加封面信息下划线
- 封面增加“题目”二字

### Changed
- 修改页面尺寸
- 用tikz重新弄了“本科毕业论文（设计）”
- 更改文类为`ctexbook`

## [v0.0.2] - 2022-01-23

### Added
- 增加图片路径

### Changed
- 修改学校logo
- 修改目录深度
- 封面信息调整


## [v0.0.1] - 2022-01-21

### Added

- 初步“搬运”`fduthesis`代码（仓库[地址](https://github.com/stone-zeng/fduthesis)）并替换`fdu`为`ccnu`
- 增加`main.tex`为测试效果的文件
- 增加更新日志

## 仓库地址

Github：https://github.com/xkwxdyy/foo

Gitee：https://gitee.com/xkwxdyy/foo

