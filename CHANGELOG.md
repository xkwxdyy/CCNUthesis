# 更新日志

配套的 b 站讲解视频：<https://www.bilibili.com/video/bv1vS4y1D7hF>

更多关于模版的内容和如何使用，请仔细阅读 [wiki](https://gitee.com/xkwxdyy/CCNUthesis/wikis)！


## [v1.1.21] - 2022-05-13

### Fixed

- 修复 `oneside` 失效问题



## [v1.1.20] - 2022-05-11

### Added

- 增加开明式标点的设置

### Changed

- 修改“参考文献”标题缩进
- 修改参考文献的作者格式

## [v1.1.19] - 2022-05-02

### Changed

- 修改图表编号为形如 `1-1` 的样式

## [v1.1.18] - 2022-04-29

### Added

- 重写西文的字体设置并修复一些字体设置问题


## [v1.1.17] - 2022-04-28

### Changed

- `关键词` 和 `keywords` 部分去掉 `parbox`
- 更新 `physicx`
- 重新调整孤行寡行的抑制参数

### Fixed

- 修复 `abstract`、关键词的目录页码问题
- 解决目录摘要关键词的超链接问题

## [v1.1.16] - 2022-04-26

### Fixed

- `bibstyle={ccnu}` 时增加 `CCNUpunctcn=false`

## [v1.1.15] - 2022-04-24

### Fixed

- 修复 `bibstyle={ccnu}` 下的参考文献的作者之间的空格问题


## [v1.1.14] - 2022-04-22

### Changed

- 增加参考文献格式控制键值

## [v1.1.13] - 2022-04-21

### Added

- 增加落款签名环境

### Changed

- 修改目录部分行距

### Fixed

- 修复 `chapter` 缩进对参考文献和致谢、附录的影响


## [v1.1.12] - 2022-04-20

### Changed

- 定理环境增加缩进
- 修改数学字体为 `XITSMath`

### Fixed

- 尝试解决连续章节的孤行问题

## [v1.1.11] - 2022-04-19

- 重新修改章节标题的缩进


## [v1.1.10] - 2022-04-18

### Changed

- 将章节之间的 `clearpage` 效果改为连续排版效果 

## [v1.1.9] - 2022-04-17

### Fixed

- 解决中文标点下的参考文献 `book` 类的译者会出现两个逗号 [#129](https://github.com/hushidong/biblatex-gb7714-2015/issues/129)


## [v1.1.8] - 2022-04-15

### Added

- 目录中添加 `title`

### Changed

- 重新修改 `enumerate` 的缩进参数
- 修改 `table` 和 `figure` 的计数方式，变成连续编号

## [v1.1.8] - 2022-04-13

### Changed

- 取消 `\nocite{}` 的作用

## [v1.1.7] - 2022-04-09

### Added

- 增加 `\lineskiplimit` 的设置
### Removed

- 去掉关键词代码的 `- \parindent`

### Fixed

- 增加 `CCNUpunctcn = false`

## [v1.1.6] - 2022-03-31

### Fixed

- 更新 `CCNUthesis.bbx`，修复 `book` 类 [M] 后有两个 `.` 的问题

## [v1.1.5] - 2022-03-30

### Added

- `geometry` 设置中添加 `twoside`
- 设置第一层级 `enumerate` 的一些参数
### Changed

- `secnumdepth` 改为 3


## [v1.1.4] - 2022-03-27

### Added

- 增加副标题接口
### Changed

- 用 `LaTeX3` 重写下划线命令
- 完善下划线命令

## [v1.1.3] - 2022-03-25

### Added

- 增加了封面下方时间的输入接口

## [v1.1.2] - 2022-03-18

### Changed

- 由于 `Linux` 没有 `Times New Roman` 字体，更改数学字体为 `times`
### Fixed

- 完善副标题的功能
### Remove

- 去掉封面个人信息的冒号


## [v1.1.1] - 2022-03-16

### Changed

- 修改 `times*` 的数学字体
- 将致谢和附录的标题代码封装
- 移动 `chapter3.tex` 的示例代码到 `chapter0.tex`

## [v1.1.0] - 2022-03-14

### Added

- 增加 `CCNUthesis.bbx` 和 `CCNUthesis.cbx` 对参考文献进行格式修改

### Changed

- 修改 `main.tex` 中关于 `parencite` 和 `\cite` 的使用注释


### Removed

- 去掉 `calc` 宏包

## [v1.1.0] - 2022-03-13

### Changed

- 由于华文新魏字体不是全平台的，所以用插图方式插入版权声明页
- 增加“参考文献”下方间距
- 重新修改`bib`文件示例


## [v1.0.7] - 2022-03-12

### Added

- 增加 `enumitem` 宏包并增加示例


## [v1.0.6] - 2022-03-10

### Changed

- 默认数学字体改为`times*`

### Fixed

- 解决`\cite`和`\parencite`的可选参数效果问题


## [v1.0.6] - 2022-03-09

### Fixed

- 解决`\cite`和`\parencite`的可选参数效果问题


## [v1.0.5] - 2022-03-03

### Removed

- 将`CCNUthesis.def`的代码移到`CCNUthesis.cls`里

## [v1.0.4] - 2022-02-28

### Added

- 增加`physicx`宏包


## [v1.0.4] - 2022-02-27

### Added

- 增加`wiki`
- 增加`exam-zh`项目的`choices`模块代码

### Changed

- 修改`section`和`subsection`的上方间距
- 去掉定理类环境的`head`部分的`.`（[#I4VFRJ](https://gitee.com/xkwxdyy/CCNUthesis/issues/I4VFRJ)）
- 修改`proof`环境“证明”的字体，并添加冒号（[#I4VFRP](https://gitee.com/xkwxdyy/CCNUthesis/issues/I4VFRP)）

### Removed

- 删去`xchoices`宏包

## [v1.0.3] - 2022-02-19

### Fixed
- 修复`msg`报错

### Changed
- 重新修改定理类环境



## [v1.0.2] - 2022-02-01

### Changed
- 修改`choices`宏包为`xchoices`宏包
- 增加`xchoices`环境示例

### Fixed
- 修改`table`和`figure`环境的标题样式（[#I4SKXE](https://gitee.com/xkwxdyy/CCNUthesis/issues/I4SKXE)）



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

