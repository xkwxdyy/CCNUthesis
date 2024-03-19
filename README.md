# CCNUthesis

## 欢迎使用CCNUthesis（华中师范大学论文模版）

本模版支持华中师范大学数学与统计学学院本硕博毕业论文撰写，基于 [fduthesis](https://github.com/stone-zeng/fduthesis) 编写而成，借助现代 LaTeX 技术，希望达到用户接口简明、内容格式规范和模板样式可定制的统一。

本模板目前支持 XeTeX ，仅支持 UTF-8 编码。

请注意本模板为开发者独立开发，与学校官方部门并不存在合作关系，作者不对使用本模板产生的格式审查问题负责，请用户谨慎使用。

遇到本文档没有覆盖的问题属于正常情况，因为不同学院可能会对教务处的模板进行细节的修改，欢迎提交反馈意见。

## 模版的核心组成

- 核心文档类
  - `CCNUthesis.cls`
- 参考文献格式文件
  - `gb7714-CCNU.bbx`
  - `gb7714-CCNUay.bbx`
  - `gb7714-CCNU.cbx`
- 参考文献数据库
  - `CCNUthesis-main.bib`
- 配置文件
  - `ccnu-setup.tex`
- 使用示例
  - `main.tex`

### 使用示例

```latex
\documentclass[type = bachelor]{CCNUthesis}
% \documentclass[type = master]{CCNUthesis}
% \documentclass[type = doctor]{CCNUthesis}


% 加载用户的个人信息和论文相关参数设置的配置文件
\input{ccnu-setup.tex}


% 需要的额外宏包可以在此处自行调用
%   关于模版已经载入的宏包请参看手册「宏包依赖情况」
\usepackage{mathtools}



% 需要的命令环境可以自行定义
\newcommand{\upe}{\mathrm{e}}   % 直立的e，用于表示常量，如自然常数      
\newcommand{\upi}{\mathrm{i}}   % 直立的i，用于表示常量，如虚数单位


\begin{document}


% \frontmatter 开启论文前置部分
% 前置部分包含目录、中英文摘要以及符号表等
\frontmatter

\input{./front/abstract.tex}


% 符号表
\input{./front/notation.tex}



% \mainmatter 进入论文主体部分
\mainmatter

% 正文
\input{./body/chapter1.tex}
\input{./body/chapter2.tex}
\input{./body/chapter3.tex}
\input{./body/chapter4.tex}



% 论文后文部分，参考文献、致谢、附录等
\backmatter

\printbibliography

\include{./back/appendix.tex}

\include{./back/acknowledgements.tex}

\end{document}
```


## 重要提醒

1. 本模板未经学校相关部门审核及授权，使用前请务必斟酌。
2. 本模板仍处于开发中，不保证接口的稳定性。在撰写论文的过程中，请慎重考虑是否要同步进行更新。
3. 任何由于使⽤本模板⽽引起的论⽂格式审查问题均与本模板作者⽆关。


## 感谢

- 特别感谢 [hushidong](https://github.com/hushidong) 对 `CCNUthesis.bbx` 和 `CCNUthesis.cbx` 提供的定制帮助！
- 感谢 [zepinglee](https://github.com/zepinglee), [syvshc](https://github.com/syvshc) 在 `CCNUthesis` 编写过程中提供的帮助
- 感谢 [stone-zeng](https://github.com/stone-zeng) 开发的 [fduthesis](https://github.com/stone-zeng/fduthesis)

## 贡献

如果您有任何改进意见或者功能需求，欢迎提交 [issue](https://gitee.com/xkwxdyy/CCNUthesis/issues) 或 [pull request](https://gitee.com/xkwxdyy/CCNUthesis/pulls)。

## 仓库地址

Github：https://github.com/xkwxdyy/CCNUthesis

Gitee：https://gitee.com/xkwxdyy/CCNUthesis

## 参考资料

- 华中师范大学2018级理科毕业论文（设计）排版模式
- 华中师范大学理科毕业论文（设计）LaTeX模版（邓国泰）
- [研究生学位论文规范](http://gs.ccnu.edu.cn/info/1049/1398.htm)