# CCNUthesis

## 欢迎使用CCNUthesis（华中师范大学论文模版）
本模版目前支持华中师范大学理科本科毕业论文撰写，基于[fduthesis](https://github.com/stone-zeng/fduthesis)编写而成，借助现代 LaTeX 技术，希望达到用户接口简明、内容格式规范和模板样式可定制的统一。


## 编写背景

本人为华中师范大学2021级数学与统计学学院本科毕业生，当时所使用模版为邓国泰老师编写的LaTeX模版，但这个模版在使用过程中有许多不足，比如

### 从整体看

- 模版基于CTeX套装与GBK编码编写，早已不再推荐使用，具体原因可参看[《[LaTeX 发行版] 2018年，为什么不推荐使用 CTeX 套装了》](https://zhuanlan.zhihu.com/p/45174503) ；
- 由于编码原因，若用主流通用的UTF8编码的编辑器如`Visual Studio Code`等打开直接乱码，只能用文本编辑器打开，但对于绝大部分用户来说，语法高亮能帮助提高排版效率，所以编码问题是需要被解决的，也就是**需要用UTF8编码改写模版**
- 编码问题甚至导致了我这届大家查重报告全是乱码
- Mac系统的用户体验很不好，甚至目前旧模版仍然不支持Mac系统
- `def`目录文件比较杂，哪些是用户不建议改动的，哪些是可以用来自定义命令的，没有很好的说明
- `doc`目录中前言、正文和附录也放在一起，结构混乱

### 从细节看

- 基本的LaTeX编译器都有环境补全功能以及个人认为全称比简写更容易记（如有需要简写，每个人的方式又不同），所以不应该提前简化
- 个人认为一大堆的简化命令没必要，重要的是告诉用户如何定义命令来简化，让他们能够自己根据需要来简化，而不是来记一堆已经定义好的所谓的简化命令
- 排版选择题选项的命令局限性大，只能排版四个选项，对于问卷这些多个选项则及其麻烦。好在笔者编写了[choices宏包](https://gitee.com/xkwxdyy/choices-l3) ，提供了更方便更统一的命令
- 仍然有格式和内容揉在一起的现象
  - abstract处的关键词的`\quad`分割
  - 开头显式的`\def`命令来定义信息等

**所以需要有人来编写一份新的更友好的模版！**

目前`CCNUthesis`已基本完成了旧模版的样式复刻工作，并极大分离了内容和样式，让用户能更方便高效地进行论文的撰写，且支持多平台运行。

## 感谢
- 感谢[zepinglee](https://github.com/zepinglee), [syvshc](https://github.com/syvshc)在`CCNUthesis`编写过程中提供的帮助！
- 感谢[stone-zeng](https://github.com/stone-zeng)编写的[fduthesis](https://github.com/stone-zeng/fduthesis)！`CCNUthesis`是基于`fduthesis`编写而成的

## 贡献

如果您有任何改进意见或者功能需求，欢迎提交 [issue](https://gitee.com/xkwxdyy/CCNUthesis/issues) 或 [pull request](https://gitee.com/xkwxdyy/CCNUthesis/pulls)。

## 仓库地址

Github：https://github.com/xkwxdyy/CCNUthesis

Gitee：https://gitee.com/xkwxdyy/CCNUthesis

## 参考资料

- 华中师范大学2018级理科毕业论文（设计）排版模式
- 华中师范大学理科毕业论文（设计）LaTeX模版（邓国泰）



