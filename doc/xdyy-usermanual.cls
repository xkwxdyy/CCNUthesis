\NeedsTeXFormat{LaTeX2e}[2018/04/01]
\ProvidesClass{xdyy-usermanual}
              [2022/02/01 v0.0.1 Class for Writing usermanual document.]
\LoadClass{l3doc}
% \xdyymanualsetup{
%   info = {
%     author            = {夏康玮},
%     title             = {用户手册},
%     email             = {kangweixia_xdyy@163.com},
%     date              = {2022-01-31},
%     version           = {0.0.1},
%     github-repository = {https://github.com/xkwxdyy/},
%     gitee-repository  = {https://gitee.com/xkwxdyy/},
%   }
% }
% \meta{xxx}: <xxx>
% \marg{xxx}: {xxx}
% \oarg{xxx}: [xxx]
% \cmd{}: 不带\的命令
% \cs{}: l3类型命令，如
%        \cs{\meta{name}:\meta{signature}} 
%        produces 
%        \⟨name⟩:⟨signature⟩
% \tn{}: 带\的2e命令
% \pkg{}: 
% \env{}:
% \cls{}:
% \file{}:
% function环境，syntax环境，如：
%      \begin{function}[added = 2022-01-31, updated = 2022-01-31]{\function_one:, \function_two:}
%        \begin{syntax}
%        |\foo_bar:| \Arg{meta} \meta{test_1}
%        \end{syntax}
%        \meta{description}
%      \end{function}
\RequirePackage{
  ctex,
  xcolor,
  % listings,
  minted,
  sourcecodepro,
  mwe,
  % graphicx,
  hyperref
}

\setminted{formatcom=\xeCJKVerbAddon}

% 设置latexcode和bashcode的背景颜色
\definecolor{codebg}{rgb}{0.95,0.95,0.95}
%%%% 重新设计个人信息接口 %%%%
\ExplSyntaxOn
\tl_new:N \l__xdyymanual_info_author_tl                % 作者名
\tl_new:N \l__xdyymanual_info_title_tl                 % 标题
\tl_new:N \l__xdyymanual_info_email_tl                 % 邮箱
\tl_new:N \l__xdyymanual_info_date_tl                  % 日期
\tl_new:N \l__xdyymanual_info_version_tl               % 版本
\tl_new:N \l__xdyymanual_info_github_repository_tl     % github仓库地址
\tl_new:N \l__xdyymanual_info_gitee_repository_tl      % gitee仓库地址
\cs_set_eq:NN \__xdyymanual_url:n \url                 % 复制\url命令
\cs_generate_variant:Nn \__xdyymanual_url:n {V}
\cs_set_eq:NN \__xdyymanual_path:n \path                % 复制\path命令
\cs_generate_variant:Nn \__xdyymanual_path:n {V}

\keys_define:nn { xdyymanual }
  {
    info  .meta:nn = { xdyymanual / info  } {#1}
  }

\keys_define:nn { xdyymanual / info }
  {
    author .tl_set:N = \l__xdyymanual_info_author_tl,
    author .initial:n = 夏康玮,
    title .tl_set:N = \l__xdyymanual_info_title_tl,
    title .initial:n = {用户手册},
    email .tl_set:N = \l__xdyymanual_info_email_tl,
    email .initial:n = {kangweixia_xdyy@163.com},
    date .tl_set:N = \l__xdyymanual_info_date_tl,
    date .initial:n = {\today},
    version .tl_set:N = \l__xdyymanual_info_version_tl,
    version .initial:n = {0.0.1},
    github-repository .tl_set:N = \l__xdyymanual_info_github_repository_tl,
    github-repository .initial:n = {https://github.com/xkwxdyy} ,
    gitee-repository .tl_set:N = \l__xdyymanual_info_gitee_repository_tl,
    gitee-repository .initial:n = {https://gitee.com/xkwxdyy} ,
  }
\title
  {
    \bfseries \tl_use:N \l__xdyymanual_info_title_tl
  }

\author
  {
    \tl_use:N \l__xdyymanual_info_author_tl \\
    \__xdyymanual_path:V \l__xdyymanual_info_email_tl
  }

\date
  {
    \tl_use:N \l__xdyymanual_info_date_tl 
    \quad 
    v \tl_use:N \l__xdyymanual_info_version_tl
    \thanks{ \__xdyymanual_url:V \l__xdyymanual_info_github_repository_tl }
    \thanks{ \__xdyymanual_url:V \l__xdyymanual_info_gitee_repository_tl }
  }
\NewDocumentCommand { \xdyymanualsetup } { m }
  { \keys_set:nn { xdyymanual } { #1 } }
\ExplSyntaxOff
%%%% 自定义命令 %%%%
\ExplSyntaxOn
% 重定义强调\emph命令
\RenewDocumentCommand { \emph } { +m } 
  {
    \group_begin:
      \slshape \bfseries  #1
    \group_end:
  }

% 初始值命令
\NewDocumentCommand { \init } { +v } 
  {
    \hspace{\fill}
    初始值~=~
    \textcolor{blue}{ \bfseries #1 }
  }

% xx = xx命令，一般\kvopt{\meta{key}}{\meta{val}}
\DeclareDocumentCommand { \kvopt } { m m }
  {
    \texttt{#1 \breakablethinspace = \breakablethinspace #2}
  }
\def\breakablethinspace{\hskip 0.16667em\relax}

% remark环境
\NewDocumentEnvironment { remark }{ +b }{
  \group_begin:
    \par \large
    \color{violet}
    注：
      #1
  \group_end:
}
\ExplSyntaxOff


%%%% LaTeX示例环境（代码+效果） %%%%
% https://sikouhjw.github.io/2020/04/29/2020-04-29-Make-an-example-environment-with-minted/
\newlength\savefboxrule
\newlength\savefboxsep
\edef\example@name{\jobname-example.aux}
% 水平模式：hexample环境
\newenvironment{hexample}%
{%
\renewcommand{\minted@FVB@VerbatimOut}[1]{%
  \@bsphack
  \begingroup
    \FV@DefineWhiteSpace
    \def\FV@Space{\space}%
    \FV@DefineTabOut
    \let\FV@ProcessLine\minted@write@detok
    \immediate\openout\FV@OutFile ##1\relax
    \let\FV@FontScanPrep\relax
    \let\@noligs\relax
    \FV@Scan}
\minted@FVB@VerbatimOut{\example@name}}%
{\minted@FVE@VerbatimOut%
  \trivlist\item\relax
  \setlength{\savefboxrule}{\fboxrule}%
  \setlength{\savefboxsep}{\fboxsep}%
  \setlength{\fboxsep}{0.015\textwidth}%
  \setlength{\fboxrule}{0.4pt}%
  \fcolorbox[gray]{0}{0.95}{%
    \begin{minipage}[c]{0.45\textwidth}%
      \setlength{\fboxrule}{\savefboxrule}%
      \setlength{\fboxsep}{\savefboxsep}%
      \small\inputminted[breakanywhere,breaklines=true,numbers=left]{latex}{\example@name}%
    \end{minipage}%
  }%
  \hfill%
  \fbox{%
    \begin{minipage}[c]{0.45\textwidth}%
      \setlength{\fboxrule}{\savefboxrule}%
      \setlength{\fboxsep}{\savefboxsep}%
      \setlength{\parskip}{1ex plus 0.4ex minus 0.2ex}%
      \normalsize\input{\example@name}%
    \end{minipage}%
  }%
  \endtrivlist
}
% 垂直模式：vexample环境
\newenvironment{vexample}%
{%
\renewcommand{\minted@FVB@VerbatimOut}[1]{%
  \@bsphack
  \begingroup
    \FV@DefineWhiteSpace
    \def\FV@Space{\space}%
    \FV@DefineTabOut
    \let\FV@ProcessLine\minted@write@detok
    \immediate\openout\FV@OutFile ##1\relax
    \let\FV@FontScanPrep\relax
    \let\@noligs\relax
    \FV@Scan}
\minted@FVB@VerbatimOut{\example@name}}%
{\minted@FVE@VerbatimOut%
  \trivlist\item\relax
  \setlength{\savefboxrule}{\fboxrule}%
  \setlength{\savefboxsep}{\fboxsep}%
  \setlength{\fboxsep}{0.015\textwidth}%
  \setlength{\fboxrule}{0.4pt}%
  \begin{minipage}[c]{\textwidth}
  \fcolorbox[gray]{0}{0.95}{%
    \begin{minipage}[c]{\textwidth-0.03\textwidth-0.8pt}%
      \setlength{\fboxrule}{\savefboxrule}%
      \setlength{\fboxsep}{\savefboxsep}%
      \small\inputminted[breakanywhere,breaklines=true,numbers=left]{latex}{\example@name}%
    \end{minipage}%
  }\\
  \fbox{%
    \begin{minipage}[c]{\textwidth-0.03\textwidth-0.8pt}%
      \setlength{\fboxrule}{\savefboxrule}%
      \setlength{\fboxsep}{\savefboxsep}%
      \setlength{\parskip}{1ex plus 0.4ex minus 0.2ex}%
      \normalsize\input{\example@name}%
    \end{minipage}%
  }%
  \end{minipage}
  \endtrivlist
}
% 浮动体模式：floatexample环境
\newenvironment{floatexample}%
{%
\renewcommand{\minted@FVB@VerbatimOut}[1]{%
  \@bsphack
  \begingroup
    \FV@DefineWhiteSpace
    \def\FV@Space{\space}%
    \FV@DefineTabOut
    \let\FV@ProcessLine\minted@write@detok
    \immediate\openout\FV@OutFile ##1\relax
    \let\FV@FontScanPrep\relax
    \let\@noligs\relax
    \FV@Scan}
\minted@FVB@VerbatimOut{\example@name}}%
{\minted@FVE@VerbatimOut%
  \trivlist\item\relax
  \setlength{\savefboxrule}{\fboxrule}%
  \setlength{\savefboxsep}{\fboxsep}%
  \setlength{\fboxsep}{0.015\textwidth}%
  \setlength{\fboxrule}{0.4pt}%
  \fcolorbox[gray]{0}{0.95}{%
    \begin{minipage}[c]{\textwidth-0.03\textwidth-0.8pt}%
      \setlength{\fboxrule}{\savefboxrule}%
      \setlength{\fboxsep}{\savefboxsep}%
      \small\inputminted[breakanywhere,breaklines=true,numbers=left]{latex}{\example@name}%
    \end{minipage}%
  }\par
  \input{\example@name}%
  \endtrivlist
}

%%%% 只显示代码 %%%%
% latexcode环境
% 如果要额外增加可选参数，使用latexcode*环境
% \begin{latexcode*}{<more options>}
% xxx
% \end{latexcode*}
\newminted{latex}{
  linenos,   % 显示行数
  % firstnumber = last,    % 行数接着上一个minted环境
  % gobble = 2,    % 吃掉开头的多少空格
  % showspaces,   % 显示空格
  breaklines,     % 断行，并显示换行符
  breakautoindent=false,
  breaksymbolindentleft=0pt,
  breaksymbolsepleft=0pt,
  breaksymbolindentright=0pt,
  breaksymbolsepright=0pt,
  bgcolor = codebg,
  % frame = lines,
  % framerule = 0.8pt,
  % framesep = 3mm
}

% bashcode环境
% 如果要额外增加可选参数，使用bashcode*环境
% \begin{bashcode*}{<more options>}
% xxx
% \end{bashcode*}
\newminted{bash}{
  linenos,   % 显示行数
  % firstnumber = last,    % 行数接着上一个minted环境
  % gobble = 2,    % 吃掉开头的多少空格
  % showspaces,   % 显示空格
  breaklines,     % 断行，并显示换行符
  breakautoindent=false,
  breaksymbolindentleft=0pt,
  breaksymbolsepleft=0pt,
  breaksymbolindentright=0pt,
  breaksymbolsepright=0pt,
  bgcolor = codebg,
  % frame = lines,
  % framerule = 0.8pt,
  % framesep = 3mm
}


% %%%% 不需要minted的listings环境 %%%%
% \lstnewenvironment{LaTeXdemo}[1][0.4]{
%   \lstset{
%     basicstyle         = \ttfamily\small,
%     basewidth          = 0.51em,
%     backgroundcolor    = \color{cyan!10},
%     % rulecolor          = \color{red!10},
%     frame              = shadowbox,
%     frameround         = tttt,
%     % framerule          = 0pt,
%     gobble             = 2,
%     tabsize            = 2,
%     numbers            = left,
%     language           = [LaTeX]TeX,
%     linewidth          = #1\linewidth
%   }
% }{}
% \ExplSyntaxOn
% \dim_new:N \g__LaTeXautodemo_width_dim
% \box_new:N \g__LaTeXautodemo_width_measure_box
% \lst@RequireAspects{writefile}
% \newsavebox\LaTeXautodemo@box
% \lstnewenvironment{LaTeXautodemo}[1][code and example]
%   {%
%     \global\let\lst@intname\@empty
%     \edef\LaTeXautodemo@end{%
%       \expandafter\noexpand\csname LaTeXautodemo@@#1@end\endcsname
%     }%
%     \@nameuse{LaTeXautodemo@@#1}%
%   }
%   {
%     \LaTeXautodemo@end
%   }
% \newcommand\LaTeXautodemo@new[3]{%
%   \@namedef{LaTeXautodemo@@#1}{#2}%
%   \@namedef{LaTeXautodemo@@#1@end}{#3}%
% }
% \newcommand*\LaTeXautodemo@common{%
%   \setkeys{lst}
%     {%
%       basicstyle         = \ttfamily\small,
%       basewidth          = 0.51em,
%       backgroundcolor    = \color{cyan!10},
%       % rulecolor          = \color{red!10},
%       frame              = shadowbox,
%       frameround         = tttt,
%       % framerule          = 0pt,
%       gobble             = 2,
%       tabsize            = 2,
%       numbers            = left,
%       language           = [LaTeX]TeX,
%       % linewidth          = 0.7\linewidth
%     }%
% }
% \newcount\LaTeXautodemo@count
% \newcommand*\LaTeXautodemo@input{%
%   \catcode`\^^M = 10\relax
%   \input{\jobname-\number\LaTeXautodemo@count.tmp}%
% }
% \LaTeXautodemo@new{code and example}{%
%   \setbox\LaTeXautodemo@box=\hbox\bgroup
%     \global\advance\LaTeXautodemo@count by 1 %
%     \lst@BeginAlsoWriteFile{\jobname-\number\LaTeXautodemo@count.tmp}   % 将内容存在中途文件里面
%     \LaTeXautodemo@common
% }{%
%     \lst@EndWriteFile
%   \egroup
%   \hbox_set:Nn \g__LaTeXautodemo_width_measure_box
%     {
%       \begin{varwidth}{\hsize}
%         \usebox\LaTeXautodemo@box
%       \end{varwidth}
%     }
%   \dim_set:Nn \g__LaTeXautodemo_width_dim { \box_wd:N \g__LaTeXautodemo_width_measure_box }
%   % \lstset
%   % 	{
%   % 		linewidth = \dim_use:N \l__LaTeXautodemo_width_dim
%   % 	}
%   \begin{center}
%     \dim_compare:nNnTF { \g__LaTeXautodemo_width_dim } > { 0.4\linewidth}
%       {
%         % \dim_use:N \g__LaTeXautodemo_width_dim
%         \begin{minipage}{\linewidth}
%           % \setkeys{lst}{ linewidth = \dim_use:N \l__LaTeXautodemo_width_dim }
%           \usebox\LaTeXautodemo@box
%         \end{minipage}%
%         \par
%         \begin{minipage}{\linewidth}
%           \LaTeXautodemo@input
%         \end{minipage}
%       }
%       {
%         \begin{minipage}{0.4\linewidth}
%           \usebox\LaTeXautodemo@box
%         \end{minipage}%
%         \hfil
%         \begin{minipage}{0.4\linewidth}
%           \LaTeXautodemo@input
%         \end{minipage}%
%       }
%     % \ifdim\wd\LaTeXautodemo@box > 0.48\linewidth
%     %   \begin{minipage}{\linewidth}
%     %     \usebox\LaTeXautodemo@box
%     %   \end{minipage}%
%     %   \par
%     %   \begin{minipage}{\linewidth}
%     %     \LaTeXautodemo@input
%     %   \end{minipage}
%     % \else
%     %   \begin{minipage}{0.48\linewidth}
%     %     \LaTeXautodemo@input
%     %   \end{minipage}%
%     %   \hfil
%     %   \begin{minipage}{0.48\linewidth}
%     %     \usebox\LaTeXautodemo@box
%     %   \end{minipage}%
%     % \fi
%   \end{center}
% }
% \LaTeXautodemo@new{code and float}{%
%   \global\advance\LaTeXautodemo@count by 1 %
%   \lst@BeginAlsoWriteFile{\jobname-\number\LaTeXautodemo@count.tmp}%
%   \LaTeXautodemo@common
% }{%
%   \lst@EndWriteFile
%   \LaTeXautodemo@input
% }
% \LaTeXautodemo@new{code only}{\LaTeXautodemo@common}{}
% \ExplSyntaxOff