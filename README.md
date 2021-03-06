# CCNUthesis

## 欢迎使用CCNUthesis（华中师范大学论文模版）

本模版支持华中师范大学数学与统计学学院本硕博毕业论文撰写，基于 [fduthesis](https://github.com/stone-zeng/fduthesis) 编写而成，借助现代 LaTeX 技术，希望达到用户接口简明、内容格式规范和模板样式可定制的统一。

本模板目前支持 XeTeX ，仅支持 UTF-8 编码。

本模版支持在 Windows、Mac、Linux 系统上运行。

在使用 `CCNUthesis` 之前，请阅读 「[lshort-zh-cn](https://ctan.math.illinois.edu/info/lshort/chinese/lshort-zh-cn.pdf)」 学习 LaTeX 基本知识，并仔细阅读模版中的用户手册 `CCNUthesis.pdf` 和 [wiki](https://gitee.com/xkwxdyy/CCNUthesis/wikis/%E7%94%A8%E6%88%B7%E5%BF%85%E8%AF%BB)

## 模版的核心组成

- 核心文档类
  - `CCNUthesis.cls`
- 参考文献格式文件
  - `gb7714-CCNU.bbx`
  - `gb7714-CCNUay.bbx`
  - `gb7714-CCNU.cbx`
- 参考文献数据库
  - `CCNUthesis-main.bib`
- 使用示例
  - `main.tex`

### 使用示例

```latex
% !TeX encoding = UTF-8
% !TeX program = xelatex
% !TeX spellcheck = en_US

%********************************************
% CCNUthesis: 华中师范大学论文模板
% 2022/05/29 v1.2.2
%
% 重要提示：
%   1. 请确保使用 UTF-8 编码保存
%   2. 请使用 XeLaTeX 或 latexmk 编译
%   3. 请仔细阅读用户文档
%   4. 不需要的注释可以尽情删除
%********************************************


\documentclass[type = bachelor]{CCNUthesis}
% \documentclass[type = master, version = print-master-twoside]{CCNUthesis}
% \documentclass[type = doctor]{CCNUthesis}


% type
% 学术类型
%   可选选项：bachelor|master|doctor
%     默认：bachelor

% version
% 文档版本
%   可选选项：electronic|print-bachelor-oneside|print-bachelor-twoside
%           print-master-oneside|print-master-twoside|
%           print-doctor-twoside
%     默认：electronic
%     electronic：电子版，无空白页
%     print-bachelor-oneside：打印版，本科，单面打印
%       数学与统计学学院「本科」终稿要求「单面」打印
%     print-bachelor-twoside：打印版，本科，双面打印
%       答辩打印可以双面打印（因为只是给答辩老师看，并不上交）
%     print-master-oneside：打印版，硕士，无空白页，单面打印
%     print-master-twoside：打印版，硕士，有空白页，双面打印
%     print-doctor-twoside：打印版，博士，有空白页，双面打印


\ccnusetup{
  % 个人信息
  %   注意：\ccnusetup 中不能出现空行
  info = {
    % cover-type = word,
    cover-type = math,
      % 封面的类型
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：word|math
      %     word：教务处的 word 封面格式
      %     math：数学与统计学学院的封面格式
      %     默认：math
      %
    title = {
      华中师范大学学位论文 \LaTeX{} 模版
    },
      % 中文-标题
      %   适用学位类型：【本｜硕｜博】
      %   会自动换行，如果换行点不满意，可以用 \\ 手动换行
      %   能概括整个学位论文的中心内容，简明、扼要
      %   论文题目一般不超过25个字，必要时可加副标题（在题目下一行以“——”打头）
      %
    title* = {
      CCNU thesis \LaTeX{} template 
    }, 
      % 英文-标题
      %   适用学位类型：【本｜硕｜博】
      %
    author = {你的姓名},
      % 中文-作者姓名
      %   适用学位类型：【本｜硕｜博】
      %
    author* = {Xing Ming},
      % 拼音-作者姓名
      %   适用学位类型：【硕｜博】
      %
    supervisor = {教师姓名 \quad 职称},
      % 中文-指导老师姓名+职称
      %   适用学位类型：【本｜硕｜博】
      %   职称：讲师｜副教授｜教授｜副研究员｜研究员
      %
    supervisor*-name = {Jiao shi},
      % 拼音-指导老师姓名
      %   适用学位类型：【硕｜博】
      %
    supervisor*-academic-title = {Professor},
      % 英文-指导老师职称
      %   适用学位类型：【硕｜博】
      %
    level = {2018级},
      % 年级
      %   适用学位类型：【本】
      %
    student-id = {学号},
      % 学号
      %   适用学位类型：【本】
      %
    department = {数学与统计学学院},
      % 中文-学院名称
      %   适用学位类型：【本｜硕｜博】
      %
    department* = {School of Mathematics and Statistics},
      % 英文-学院名称
      %   适用学位类型：【硕｜博】
      %
    major = {应用统计},
      % 中文-专业
      %   适用学位类型：【本｜硕｜博】
      %   选项参考：
      %     本：数学与应用数学（试验）｜数学与应用数学（师范）｜统计学
      %     硕：应用统计
      %   【硕博】「学术型学位学科专业」填写《授予博士、硕士学位和培养研究生的学科、专业目录》中的二级学科或我校自主设置专业；「专业型学位学科专业」填写「专业学位领域」，无领域学科不填
      %
    major* = {Mathematics},
      % 英文-专业
      %   适用学位类型：【硕｜博】
      %   选项参考：
      %     硕：Mathematics|Applied Statistics
      %
    research-area = {教育大数据},
      % 中文-研究方向
      %   适用学位类型：【硕｜博】
      %   选项参考：
      %     硕：教育大数据
      %
    research-area* = {Education big data},
      % 英文-研究方向
      %   适用学位类型：【硕｜博】
      %   选项参考：
      %     硕：Mathematics|Applied Statistics
      %
    degree-type = {应用统计硕士},
      % 中文-申请学位学生类别
      %   适用学位类型：【硕｜博】
      %   选项参考：
      %     硕：教育硕士｜应用统计硕士｜全日制硕士｜同等学力人员｜
      %        高校教师在职攻读硕士学位人员｜专业学位人员
      %     博：博士
      %
    degree-type* = {M.S.},
      % 英文-申请学位学生类别，缩写
      %   适用学位类型：【硕｜博】
      %   选项参考：
      %     硕：M.S.
      %
    keywords = {
      关键词1,
      关键词2,
      关键词3
    },
      % 中文-论文关键词
      %   适用学位类型：【本｜硕｜博】
      %   关键词之间用西文逗号 “,” 隔开
      %
    keywords* = {
      keyword1,
      keyword2,
      keyword3
    },
      % 英文-论文关键词
      %   适用学位类型：【本｜硕｜博】
      %   关键词之间用西文逗号 “,” 隔开
      %
    % year  = {2022},
      % 年份
      %   适用学位类型：【本｜硕｜博】
      %   如果不手动调整，则默认是「编译时」的年份
      %
    % month = {5},
      % 月份
      %   适用学位类型：【本｜硕｜博】
      %   如果不手动调整，则默认是「编译时」的月份
  },
  style = {
    font = times,
      % 西文字体
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：newtx|times|stixtwo|xits|tg|none
      %     目前的字体配置为: (TG = TeX Gyre, 默认值为 times)
      %     *******************************************************************
      %     选项名   : serif,            sans,     mono,         math
      %     *******************************************************************
      %     stixtwo : STIX Two Text,    TG Heros, TG Cursor,    STIX Two Math
      %     xits    : XITS,             TG Heros, TG Cursor,    XITS Math
      %     times   : Times New Roman,  Arial,    Courier New,  newtxmath
      %     newtx   : TG Termes,        TG Heros, TG Cursor,    newtxmath
      %     tg      : TG Termes,        TG Heros, TG Cursor,    TG Termes Math
      %     *******************************************************************
    footnote-style = xits,
      % 脚注编号样式
      %   可选选项：plain|libertinus|libertinus*|libertinus-sans|
      %           pifont|pifont*|pifont-sans|pifont-sans*|
      %           xits|xits-sans|xits-sans*
      %   默认与西文字体保持一致
      %   注意：对于本科生，《附件4：关于毕业论文注释与参考文献著录格式修订的通知》中指出“文科术科的论文注释「使用」脚注”及“理工科的论文注释「不使用」脚注”
    cjk-font = fandol,
      % 中文字体
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：adobe|fandol|founder|mac|sinotype|sourcehan|windows|none
      %   默认：fandol
      %   注意：
      %     1. 中文字体设置高度依赖于系统。各系统建议方案：
      %          windows：cjk-font = windows
      %          mac：    cjk-font = mac
      %          linux：  cjk-font = fandol（默认值）
      %     2. 除 fandol 和 sourcehan 外，其余字体均为商用字体，请注意版权问题
      %     3. 但 fandol 字体缺字比较严重，而 sourcehan 没有配备楷体和仿宋体
      %
    chapter-breakstyle = continuous,
      % chapter 是否要新起一页开始
      %   适用学位类型：【本】
      %   可选选项：continuous|newpage
      %   默认：continuous
      %     continuous：chapter 不新起一页开始
      %     newpage：chapter 新起一页开始
      %
    caption-labelstyle = hyphen,
      % 图表标题 label 计数样式
      %   适用学位类型：【本｜硕｜博】
      %     【硕｜博】应选择 dot （根据研究生学位论文规范）
      %   可选选项：arabic|hyphen|dot
      %     arabic：样式为图1，图2，表1，表2...，并且跨 chapter 连续编号，即 上一个 chapter 的图编号若为4，下一个 chapter 的第一个图编号为 5
      %     hyphen：样式为图1-1，图2-1，表1-1...
      %       x-y 的 x 为 chapter 值，y 为图表的计数器值，新的 chapter 中 y 会清零重新计数
      %     dot：样式为图1.1，图2.1，表1.1...
      %       x.y 的 x 为 chapter 值，y 为图表的计数器值，新的 chapter 中 y 会清零重新计数
      %     默认：hyphen
      %
    caption-labelseperator = colon,
      % 图表标题 label 和 标题内容 之内的分隔符
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：colon|space
      %     colon 表示 「:␣」，即一个西文冒号加一个空格
      %     space 表示 「␣␣」，即两个空格
      %     默认：colon
      %
    show-headlogo = false,
      % 是否显示页眉 logo
      %   适用学位类型：【硕｜博】
      %   可选选项：true|false
      %     默认：false
      %   logo 内容：华中师范大学校徽 + 硕士/博士学位论文中英文字样
      %
    headline = none,
      % 页眉的线的类型
      %   适用学位类型：【硕｜博】
      %   可选选项：single|double|thin-thick|thick-thin|none
      %     single：一条线
      %     double：两条线，一样粗细
      %     thin-thick：两条线，上细下粗
      %     thick-thin：两条线，上粗下细
      %     none：没有页眉的线
      %     默认：none
      %
    fullwidth-stop = catcode,
      % 标点的自动替换
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：catcode|mapping|false
      %     catcode：显式的 “。” 会被替换为 “．”（e.g. 不包括用宏定义保存的 “。”）
      %     mapping：所有的 “。” 会被替换为 “．”（使用 LuaLaTeX 编译则无效）
      %     false：不进行替换
      %     默认：catcode
      %   作用：是否把全角实心句点 “．” 作为默认的句号形状，即正文中输入“。” 最终编译效果为“. ”
      %   说明：一般科技类文章需要替换，防止“. ”与“。”混淆
      %
    bib-style = ccnu-bachelor-numerical,
      % bib-style 表示参考文献的格式
      %   适用学位类型：【本｜硕｜博】
      %   可选选项：
      %     ccnu-bachelor-numerical|ccnu-bachelor-author-year
      %     ccnu-master|ccnu-doctor|gb7714-2015
      %       ccnu-bachelor-numerical：【本】学校标准，顺序编码制
      %       ccnu-bachelor-author-year：【本】学校标准，作者-年制
      %       ccnu-master：【硕】国标，顺序编码制
      %       ccnu-doctor：【博】国标，顺序编码制
      %       gb7714-2015：国标，顺序编码制
      %     默认：ccnu-bachelor-numerical
      %
    bib-resource = {CCNUthesis-main.bib},
      % 参考文献数据源
      %   适用学位类型：【本｜硕｜博】
      %   注意：需要加 bib 后缀
      %   默认：CCNUthesis-main.bib
      %
    hyperlink = none,
      % 超链接样式
      %   可选选项：color|none
      %   默认：none
      %
    hyperlink-color = default,
      % 超链接颜色
      %   可选选项：default|classic|material|graylevel|prl
      %   默认：default
      %
  }
}



% 需要的宏包可以在此处自行调用
\usepackage{mathtools}
\usepackage{zhlipsum}



% 需要的命令环境可以自行定义
\newcommand{\upe}{\mathrm{e}}        % 直立的e，用于表示常量，如自然常数      
\newcommand{\upi}{\mathrm{i}}        % 直立的i，用于表示常量，如虚数单位



\begin{document}


% \frontmatter 开启论文前置部分
% 前置部分包含目录、中英文摘要以及符号表等
\frontmatter


% 摘要
%   适用学位类型：【本｜硕｜博】
\input{./front/abstract.tex}


% 符号表
%   适用学位类型：【本｜硕｜博】
%   不需要的话将 \input{./front/notation.tex} 注释掉或删除
\input{./front/notation.tex}



% \mainmatter 进入论文主体部分
\mainmatter


% 主体采用多文件编译的方式
% 即把每一章放进一个单独的 tex 文件里，并在这里用 \input 导入
% 例如 \input{./body/chapter1.tex}
% 表示插入 main 所在目录中的 body 目录下的 chapter1.tex 文件

% 正文
% 适用学位类型：【本｜硕｜博】
\input{./body/chapter1.tex}
\input{./body/chapter2.tex}
\input{./body/chapter3.tex}
\input{./body/chapter4.tex}



% 论文后文部分，参考文献、致谢、附录等
\backmatter


% 参考文献
%********************************************
% 行内引用：\parencite{} or \parencite[]{}，下面两个情况要用行内引用
%    - 去掉这个引用句子结构不完整，比如“定理证明可参看[1]”
%    - 英文文献的引用
% 上标引用：\cite{} or \cite[]{}，下面情况要用上标引用
%    - 去掉这个引用，句子结构完整，比如“作者提到，‘CCNUthesis 真是一个好模版。’^[1]”
%      其中“^[1]” 表示上标引用
%********************************************

% 输出参考文献
%   适用学位类型：【本｜硕｜博】
%   无须用户进行任何操作
%   用户要想正确输出参考文献：
%     1. 在 bib 文件中输入正确的参考文献条目信息
%     2. 在正文中正确地使用 \parencite 或 \cite 引用
%     3. 使用 xelatex-biber-xelatex*2 编译链或 latexmk 方式编译 main.tex 文件
\printbibliography


% 附录
% 【硕博】附录在致谢前
\include{./back/appendix.tex}

% 攻读学位期间取得的研究成果（博）
% \include{./back/publications.tex}


% 致谢
\include{./back/acknowledgements.tex}


% 附录
% 【本科】附录在致谢后
% \include{./back/appendix.tex}


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