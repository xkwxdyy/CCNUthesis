# 更新日志

配套的 b 站讲解视频：<www.bilibili.com/video/BV1FT41137eq>

更多关于模板的内容和如何使用，请仔细阅读模板中的 `CCNUthesis.pdf` 用户手册和 [wiki](https://gitee.com/xkwxdyy/CCNUthesis/wikis)！

QQ 1群：435903068（若满了请加2群）
QQ 2群：685329998


## [v1.4.4] - 2024-05-02

### Fixed

- 修改本科目录第二页只有一行时的页眉问题


## [v1.4.3] - 2024-04-28

### Fixed

- 修复 `choices` 环境的换行缩进问题


## [v1.4.3] - 2024-04-27
除了更新 `CCNUthesis.cls`，还需要将 `copyright` 目录下的 PDF 全部替换为新版（省事一点，全部替换就行）


### Changed
主要针对数院格式修改
- 去掉关键词最后的分号
- 版权页的 `1、` 改为 `2.`


## [v1.4.2] - 2024-04-27

除了更新 `CCNUthesis.cls` 还需要修改 `ccnu-setup.tex` 里
- `caption-labelstyle = dot`
- `caption-labelseperator = space`
注意是改成这两个值。

### Changed
本科模板（主要参考 2024 年教务处模板）

- 修改目录为三级
- 摘要部分关键词增加分号
- 英文标题居中加粗
- 调整正文一到三级标题缩进
- 调整参考文献的 item 缩进
- 调整参考文献标题的缩进
- 调整 `choices` 环境的缩进
- 数院：调整图标的标题与内容的距离（参考邓的设置）





## [v1.4.1] - 2024-04-05

### Added

- 增加 `style/theorem-bodyfont` 键值控制定理环境的正文字体




## [v1.4.0] - 2024-04-03


### Added
- 增加硕博盲审的版权页和键值 `blind-version = blind-schoolname`（来自 qq 群用户1542656672，物理学院）
- 增加硕博的第二种类型的版权页和键值 `copyright-version`（来自 qq 群用户1584103174，貌似是 2023 年新的版本）




## [v1.3.1] - 2024-03-27

### Removed

- 去掉英文月份中五月份 `May.` 的 `.`（[#I9C4W0](https://gitee.com/xkwxdyy/CCNUthesis/issues/I9C4W0)）




## [v1.3.0] - 2024-03-19

### Added
- 增加对模板非官方性的说明

### Fixed

- 处理博士模版的页码问题和间距

### Changed

- 本科默认参考文献样式改为作者-年
- 本科数院封面去掉 `（设计）`
- 博士打印选项 `print-doctor-twoside` 改为 `print-doctor`
- 博士 `chapter` 改为 `第...章`样式
- 修改硕博的 `section` 和 `subsection` 的缩进



## [v1.2.21] - 2024-03-07

### Added

- 增加封面二的标题控制接口：`cover_ii_only_title_content`

### Fixed

- 修复 `fullwidth-stop=false` 造成硕博的第二个封面的标题换行问题


## [v1.2.20] - 2024-02-22

### Added

- 增加了 `bib-keyval` 键值，用于接入 `biblatex` 的键值

### Changed

- 修改 `README.md` 的内容



## [v1.2.19] - 2024-01-18

### Changed

- 修改 `chapter0.tex` 的代码，删除 `physics` 和 `physicx` 部分的代码
- 恢复博士模板的公式括号


## [v1.2.18] - 2023-05-27

### Changed

- `version` 的 `print-master-oneside|print-master-twoside|print-doctor-twoside` 选项下封面的 logo 和页眉 logo 变成黑色(#16)



## [v1.2.17] - 2023-05-10

### Added

- 增加本科生的盲审 `blind-version` 处理和 `\blind` 命令
- 增加 `enumerate` 环境带圈数字的样式

### Changed

- 修改本科封面 “本科毕业论文（设计）” 的字号
- word 版本的 “Keywords” 之间添加空格



## [v1.2.16] - 2023-04-26

### Added

- logo 和声明页改成绝对路径

### Changed

- 硕博公式编号无括号

### Fixed

- 修复博士模板盲审时多一页空白页的问题


## [v1.2.15] - 2023-04-20

### Fixed

- 修复编译参考文献的 `undefined control sequence` 问题


## [v1.2.14] - 2023-04-13

### Fixed

- 修复书签的“zihao”问题（#8）


## [v1.2.14] - 2023-04-07


### Added

- 增加盲审的信息去除接口


### Changed

- 去掉 "Abstract:" 后面的空格



## [v1.2.14] - 2023-04-03

### Changed

- 调节硕博 `head-scope` 不同值时，扉页的内容垂直间距


## [v1.2.13] - 2023-03-16

### Changed

- 修改本科生的行间距为1.5倍并调整一些细节



## [v1.2.13] - 2023-03-11

### Added

- 示例文件和文档中增加“gb7714-2015ay”选项注释


## [v1.2.12] - 2023-02-19

### Fixed

- 修复`fullwidth-stop = false`失效的问题


## [v1.2.11] - 2023-01-10

### Fixed

- 修复脚本的问题


## [v1.2.11] - 2023-01-07

### Changed

- 完善 VScode 按照说明的一些细节


## [v1.2.11] - 2022-08-09

### Added

- 增加 `title-line-type` 键值

### Changed

- 修改硕博的扉页的中文标题样式

## [v1.2.10] - 2022-08-09

### Changed

- 重新调整模板封面位置

### Fixed

- 修复本科的标题行距问题

## [v1.2.9] - 2022-07-31

### Added

- 增加 `lguide-ch1.pdf` 文件（https://github.com/AlphaZTX/LaTeX-tutorials-opensource）

### Changed

- 修改行距代码


### Fixed

- 修复本科模板 `chapter-breakstyle = newpage` 对摘要的影响问题
- 修复 `\chapter` 的 `patchcmd` 失效问题

## [v1.2.8] - 2022-06-27
### Changed

- 个人信息配置变成分文件


### Fixed

- 修复附录的编号 bug
- 修复页眉的范围控制 `scope = main` 的失效问题

## [v1.2.7] - 2022-06-22

### Changed

- 个人信息配置变成分文件


### Fixed

- 修复附录的编号 bug
- 修复页眉的范围控制 `scope = main` 的失效问题

## [v1.2.7] - 2022-06-22

### Changed
- 修改博士模板的字号和行距代码


## [v1.2.6] - 2022-06-21

### Added

- 增加页眉 logo 和页眉线的统一控制接口
- 完成本硕博的页眉范围控制

### Changed

- 将两个 `.str_gset:N` 的键值接口改为 `.code:n` 类型，增加对旧版本 expl3 的兼容（[#I5D7OT](https://gitee.com/xkwxdyy/CCNUthesis/issues/I5D7OT)）

### Removed

- 去掉了本科的单双面打印类型接口

### Fixed

- 修复本科目录的间距问题
- 修复符号表的空白页问题（#4）


## [v1.2.6] - 2022-06-19

### Added

- 增加关键词和摘要之间是否空一行的控制
- 增加硕博页眉的在扉页显示与否的控制

### Fixed

- 修复摘要和致谢的硕博目录字号问题

## [v1.2.5] - 2022-06-07


### Added

- 增加图表的 `postion`


## [v1.2.4] - 2022-06-04

### Added

- 提供用户自定义定理类环境接口
- 增加本科模板的“chapter 是否新起一页”的键值控制
- 增加用户手册

### Changed

- 更改反例环境为“counterexample”

### Removed

- 去掉 `needspace` 宏包


## [v1.2.3] - 2022-06-03

### Changed

- 设置模板的默认值


## [v1.2.3] - 2022-06-01

### Added

- 增加页眉线的种类控制
- 增加“攻读学位期间发表的学术论文”

### Changed

- 扉页的个人信息的位置改为相对位置
- 增加硕博页眉 logo 和 line 的控制
- 更改版权页至 copyright 目录



## [v1.2.2] - 2022-05-24

### Changed

- 改变硕博 `word` 版本标题字体为黑体
- 改变硕博 `word` 版本个人信息字体为黑体


## [v1.2.2] - 2022-05-24

### Added

- 基本完成硕博的整体框架

## [v1.2.2] - 2022-05-24

### Added

- 增加本科生的封面的 `word` 和 `math` 风格切换控制


## [v1.2.1] - 2022-05-22

### Added

- 增加 author-year 的参考文献样式


## [v1.2.1] - 2022-05-17

### Added

- 增加 `caption-labelseperator` 控制图表 `label` 和内容的分隔符



## [v1.1.22] - 2022-05-14

### Added

- 增加图表的标题计数样式

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
- 修改了`\frontmatter`和`\mainmatter`的计数器，达到模板要求的效果

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

