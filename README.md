# CCNUthesis

## 欢迎使用CCNUthesis（华中师范大学论文模版）

本模版目前支持华中师范大学数学与统计学学院本科毕业论文撰写，基于 [fduthesis](https://github.com/stone-zeng/fduthesis) 编写而成，借助现代 LaTeX 技术，希望达到用户接口简明、内容格式规范和模板样式可定制的统一。

本模板目前支持 XeTeX ，仅支持 UTF-8 编码。

本模版支持在 Windows、Mac、Linux 系统上运行。

由于有些[问题](https://gitee.com/xkwxdyy/CCNUthesis/issues/I4VPO2)，请不要在 `overleaf` 上编译，请根据 [wiki](https://gitee.com/xkwxdyy/CCNUthesis/wikis/%E7%94%A8%E6%88%B7%E5%BF%85%E8%AF%BB) 中的指导进行 `TeX Live` 的正确安装，并进行本地编译。

在使用 `CCNUthesis` 之前，请阅读 「[lshort-zh-cn](https://ctan.math.illinois.edu/info/lshort/chinese/lshort-zh-cn.pdf)」 学习 LaTeX 基本知识，并仔细阅读 [wiki](https://gitee.com/xkwxdyy/CCNUthesis/wikis/%E7%94%A8%E6%88%B7%E5%BF%85%E8%AF%BB)

## 模版的核心组成

- 核心文档类
  - `CCNUthesis.cls`
- 参考文献数据库
  - `CCNUthesis-main.bib`
- 使用示例
  - `main.tex`

### 使用示例

```latex
% !TeX program  = XeLaTeX
% !TeX encoding = UTF-8

\documentclass{CCNUthesis}

\ccnusetup{
  % 个人信息
  info = {
    % 主标题
    title = {
      中文主标题
    },
    % subtitle = {
      % 这是一个副标题
    % },
    % 论文的英文标题
    title* = {
      Thesis Title
    }, 
    % 学院
    department = {数学与统计学学院},
    % 专业
    major = {数学与应用数学（试验）},
    % 年级
    level = {2018级},
    % 姓名
    author = {你的姓名},
    % 学号
    student-id = {学号},
    % 指导教师
    supervisor = {xxx \quad 教授},
    % 论文中文关键词
    keywords = {
      关键词1,
      关键词2,
      关键词3
    },
    % 论文英文关键词
    keywords* = {
      keyword1,
      keyword2,
      keyword3
    },
    % 年份
    % year    = {2022},
    % 月份
    % month = {4}
  },
  style = {
    % 中文字体
    cjk-font = fandol,
    % 参考文献数据库
    bib-resource = {CCNUthesis-main.bib}
  }
}

\begin{document}


\frontmatter

% 目录
\tableofcontents

\begin{abstract}
  中文摘要
\end{abstract}

\begin{abstract*}
  English abstract
\end{abstract*}

\mainmatter

<论文主体>

\backmatter

<参考文献>
<致谢>
<附录>（可选）

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