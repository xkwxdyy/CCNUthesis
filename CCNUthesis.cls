\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {CCNUthesis} {2023-04-16} {v1.2.14}
  {Thesis template for Central China Normal University}
\RequirePackage { l3keys2e, xparse }


% 宏包报错信息
\msg_new:nnn { ccnuthesis } { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
% 检测 l3keys2e 的版本
\clist_map_inline:nn { l3keys2e }
  {
    \@ifpackagelater {#1} { 2020/07/17 }
      { } { \msg_error:nnn { ccnuthesis } { l3-too-old } {#1} }
  }
% 编译方式的报错信息
\msg_new:nnn { ccnuthesis } { unsupported-engine }
  {
    The~ ccnuthesis~ class~ requires~ either~ XeTeX~ or~ LuaTeX. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex"~ or~ "lualatex".
  }
% 仅支持 xelatex 和 luatex 的编译方式
\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \msg_fatal:nnx { ccnuthesis } { unsupported-engine }
          { \c_sys_engine_str }
      }
  }


% 用户设置命令
\NewDocumentCommand \ccnusetup { m }
  { \keys_set:nn { ccnu } {#1} }

\keys_define:nn { ccnu }
  {
    info  .meta:nn = { ccnu / info  } {#1},
    style .meta:nn = { ccnu / style } {#1},
    choices .meta:nn = { ccnu / choices } {#1},
  }

% 变量声明
\box_new:N        \l__ccnu_tmpa_box
\clist_new:N      \l__ccnu_tmpa_clist
\clist_new:N      \l__ccnu_tmpb_clist
\dim_new:N        \l__ccnu_tmpa_dim   % 用于 \__ccnu_vspace:n 函数的临时长度变量
\dim_new:N        \l__ccnu_tmpb_dim
\skip_new:N       \l__ccnu_tmpa_skip  % 用于 \__ccnu_vspace:n 函数的临时长度变量
\tl_new:N         \l__ccnu_tmpa_tl
\tl_new:N         \l__ccnu_tmpb_tl
\int_new:N        \g__ccnu_thesis_type_int             % 学位论文类型
\clist_new:N      \g__ccnu_to_ctexbook_clist
\clist_new:N      \g__ccnu_to_hyperref_clist
\bool_new:N       \g__ccnu_cover_word_version_bool     % word 版本控制
\bool_new:N       \g__ccnu_twoside_bool
\bool_new:N       \g__ccnu_draft_bool
\bool_new:N       \g__ccnu_showhead_bool           % 页眉控制
\bool_new:N       \g__ccnu_showheadlogo_bool        % 页眉 logo 控制
\bool_new:N       \g__ccnu_chapter_newpage_bool    % chapter 是否新起一页
\str_new:N        \g__ccnu_headline_str                % 页眉 阴阳线
\str_new:N        \g__ccnu_type_version_str      % 打印、电子版本控制
\fp_new:N         \g__ccnu_doctor_linespread_ration_fp
\fp_set:Nn        \g__ccnu_doctor_linespread_ration_fp
  { 25 / 24 }

% 下划线
\dim_new:N \l__ccnu_title_tmp_height_dim
\dim_new:N \l__ccnu_title_tmp_width_dim        % 储存单行的宽度
\dim_new:N \l__ccnu_title_tmp_max_width_dim

\dim_new:N \g__ccnu_title_single_line_max_width_dim
\dim_new:N \g__ccnu_title_multiline_max_width_dim

\dim_new:N \l__ccnu_title_left_right_extra_width_dim
\dim_new:N \l__ccnu_title_sep_width


\keys_define:nn { ccnu / style }
  {
    chapter-breakstyle .choice:,
    chapter-breakstyle / continuous .code:n = 
      {
        \bool_gset_false:N \g__ccnu_chapter_newpage_bool
      },
    chapter-breakstyle / newpage .code:n = 
      {
        \bool_gset_true:N \g__ccnu_chapter_newpage_bool
      },
    chapter-breakstyle .value_required:n = true,
  }

% 生成新变体
\cs_generate_variant:Nn \file_input:n     { V  }
\cs_generate_variant:Nn \int_to_arabic:n  { v  }
\cs_generate_variant:Nn \keys_define:nn   { nx }
\cs_generate_variant:Nn \tl_map_inline:nn { xn }
% 生成新的判断语句
\prg_generate_conditional_variant:Nnn \tl_if_eq:nn { Vn } { T, TF }



% 间距命令

% 水平 quad 和 qquad
\cs_new:Npn \__ccnu_quad:  { \skip_horizontal:n { 1 em } }
\cs_new:Npn \__ccnu_qquad: { \skip_horizontal:n { 2 em } }

% 垂直间距 \vspace 的 LaTeX3 版本
\cs_new_protected:Npn \__ccnu_vspace:N #1
  {
    \dim_set_eq:NN \l__ccnu_tmpa_dim \prevdepth
    \hrule height \c_zero_dim
    \nobreak
    \skip_vertical:N #1
    \skip_vertical:N \c_zero_skip
    \dim_set_eq:NN \prevdepth \l__ccnu_tmpa_dim
  }
\cs_new_protected:Npn \__ccnu_vspace:n #1
  {
    \skip_set:Nn \l__ccnu_tmpa_skip {#1}
    \__ccnu_vspace:N \l__ccnu_tmpa_skip
  }
\cs_generate_variant:Nn \__ccnu_vspace:N { c }

% 行距
\fp_const:Nn \c__ccnu_line_spread_fp
  { \dim_ratio:nn { 20 pt } { 12 bp } / 1.2 }
\cs_new:Npn \__ccnu_line_spread:N #1
  { \linespread { \fp_use:N #1 } \selectfont }
\cs_new:Npn \__ccnu_line_spread:n #1
  { \linespread {#1} \selectfont }

% 符号
\cs_new:Npn \__ccnu_symbol:n #1 { \tex_char:D #1 \scan_stop: }

% 将计数器的值转化为数字 arabic
\cs_new:Npn \__ccnu_arabic:n #1
  { \int_to_arabic:v { c@ #1 } }



% hook 类型的函数

% TODO
\cs_new_protected:Npn \__ccnu_gadd_ltxhook:nn #1#2
  { \hook_gput_code:nnn {#1} { . } {#2} }
% TODO
\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }
% ctex 的 patch
\cs_new_protected:Npn \__ccnu_patch_cmd:Nnn #1#2#3
  {
    \ctex_patch_cmd_once:NnnnTF #1 { } {#2} {#3}
      { } { \ctex_patch_failure:N #1 }
  }
% ctex 的 appto
\cs_new_protected:Npn \__ccnu_appto_cmd:Nn #1#2
  {
    \ctex_appto_cmd:NnnTF #1 { } {#2}
      { } { \ctex_patch_failure:N #1 }
  }
% ctex 的 preto
\cs_new_protected:Npn \__ccnu_preto_cmd:Nn #1#2
  {
    \ctex_preto_cmd:NnnTF #1 { } {#2}
      { } { \ctex_patch_failure:N #1 }
  }


% tl 统一格式定义类函数

% 定义字体风格
\cs_new_protected:Npn \__ccnu_define_fn_style:nn #1#2
  { \tl_const:cn { c__ccnu_fn_style_ #1 _tl } {#2} }
% 定义标点
\cs_new_protected:Npn \__ccnu_define_punct:nn #1#2
  { \tl_const:cn { c__ccnu_ #1 _tl } {#2} }
% 定义「仅有中文版本的」
\cs_new_protected:Npn \__ccnu_define_name:nn #1#2
  { \tl_const:cn { c__ccnu_name_ #1 _tl } {#2} }
% 定义「有中文和英文版本的」
\cs_new_protected:Npn \__ccnu_define_name:nnn #1#2#3
  {
    \tl_const:cn { c__ccnu_name_ #1    _tl } {#2}
    \tl_const:cn { c__ccnu_name_ #1 _en_tl } {#3}
  }



% 简化 msg 模块的函数
\cs_new:Npn \__ccnu_msg_new:nn  { \msg_new:nnn      { ccnuthesis } }
\cs_new:Npn \__ccnu_error:n     { \msg_error:nn     { ccnuthesis } }
\cs_new:Npn \__ccnu_error:nn    { \msg_error:nnn    { ccnuthesis } }
\cs_new:Npn \__ccnu_error:nx    { \msg_error:nnx    { ccnuthesis } }
\cs_new:Npn \__ccnu_error:nnn   { \msg_error:nnnn   { ccnuthesis } }
\cs_new:Npn \__ccnu_error:nnnn  { \msg_error:nnnnn  { ccnuthesis } }
\cs_new:Npn \__ccnu_warning:n   { \msg_warning:nn   { ccnuthesis } }
\cs_new:Npn \__ccnu_warning:nn  { \msg_warning:nnn  { ccnuthesis } }
\cs_new:Npn \__ccnu_warning:nxx { \msg_warning:nnxx { ccnuthesis } }
\cs_new:Npn \__ccnu_info:nx     { \msg_info:nnx     { ccnuthesis } }



% 处理文类的选项
\keys_define:nn { ccnu / option }
  {
    type .choice:,
    type .value_required:n = true,
    type .choices:nn =
      { doctor, master, bachelor }
      { \int_set_eq:NN \g__ccnu_thesis_type_int \l_keys_choice_int },
    type .initial:n = bachelor,
    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n =
      {
        \clist_gput_right:Nn \g__ccnu_to_ctexbook_clist { oneside }
        \bool_set_false:N    \g__ccnu_twoside_bool
      },
    twoside .code:n =
      {
        \clist_gput_right:Nn \g__ccnu_to_ctexbook_clist { twoside }
        \bool_set_true:N     \g__ccnu_twoside_bool
      },
    draft .choice:,
    draft / true  .code:n =
      {
        \bool_set_true:N     \g__ccnu_draft_bool
        \clist_gput_right:Nn \g__ccnu_to_ctexbook_clist { draft }
      },
    draft / false .code:n =
      { \bool_set_false:N    \g__ccnu_draft_bool },
    draft .default:n = true,
    draft .initial:n = false,
    % version .str_gset:N = \g__ccnu_type_version_str,
    version .code:n = 
      {
        \str_gset:Nn \g__ccnu_type_version_str {#1}
      },
    version .value_required:n = true,
    version .initial:n = electronic,
    blind-version .bool_set:N = \g__ccnu_blind_version_bool,
    blind-version .initial:n = false,
    blind-version .default:n = true,
    unknown .code:n = { \__ccnu_error:n { unknown-option } }
  }
\__ccnu_msg_new:nn { unknown-option }
  { Class~ option~ "\l_keys_key_str"~ is~ unknown. }
\ProcessKeysOptions { ccnu / option }


\AtBeginDocument
  {
    \bool_if:NT \g__ccnu_blind_version_bool
      {
        \keys_set:nn { ccnu / style }
          { show-head = false }
      }
  }


% ctexbook 选项处理

% 正文字号
\int_compare:nNnTF { \g__ccnu_thesis_type_int } = {1}
  {
    \PassOptionsToClass { zihao  = 5, twoside } { ctexbook }
  }
  {
    \PassOptionsToClass { zihao  = -4, oneside } { ctexbook }
  }
\str_if_eq:VnT \g__ccnu_type_version_str { print-master-twoside }
  {
    \PassOptionsToClass { twoside } { ctexbook }
  }
\PassOptionsToClass
  {
    UTF8,
    heading    = true,
    fontset    = none,
    openany,
    \g__ccnu_to_ctexbook_clist
  }
  { ctexbook }
% 行距
\int_case:nn { \g__ccnu_thesis_type_int }
  {
    % 本科 1.5 倍行距
    {3}
      {
        % \PassOptionsToPackage  { restoremathleading } { zhlineskip }
        \PassOptionsToPackage 
          {
            restoremathleading,
            UseMSWordMultipleLineSpacing,
            MSWordLineSpacingMultiple   = 1.5
          }
          { zhlineskip }
      }
    %   { \PassOptionsToClass { linespread = \c__ccnu_line_spread_fp } { ctexbook } }
    % 硕士行距：多倍 1.25 倍
    {2} 
      {
        % \PassOptionsToClass { linespread = \g__ccnu_doctor_linespread_ration_fp\c__ccnu_line_spread_fp } { ctexbook } 
        \PassOptionsToPackage 
          {
            restoremathleading,
            UseMSWordMultipleLineSpacing,
            MSWordLineSpacingMultiple   = 1.25
          }
          { zhlineskip }

      }
    % 博士行距 19 磅
    {1} 
      { 
        \PassOptionsToPackage  { restoremathleading } { zhlineskip }
        \PassOptionsToClass { linespread = 1 } { ctexbook } 
      }
  }
\clist_map_inline:nn
  {
    { no-math           } { fontspec },
    { perpage           } { footmisc },
  }
  { \PassOptionsToPackage #1 }
% 加载 ctexbook 文类
\LoadClass { ctexbook }


% 加载宏包

\RequirePackage
  {
    geometry,          % 页面设置
    fancyhdr,          % 页眉页脚
    fontspec,          % 字体
    footmisc,          % 脚注
    graphicx,          % 插图
    caption,           % 图表标题
    tikzpagenodes,     % tikz 定位
    tabularray,        % 表格
    calc,              % settototalheight 等命令
    etoolbox,          % 补丁
    amsthm,            % 定理类环境
    thmtools,          % 定理类环境
    xeCJKfntef,        % 下划线
    zhlineskip         % 行距
  }
\RequirePackage[shortlabels]{enumitem}   % 列表环境
\RequirePackage[titles]{tocloft}         % 目录修改


% 宏包版本检测
\cs_new_protected:Npn \__ccnu_check_package:nnn #1#2#3
  {
    \@ifpackagelater {#1} {#2}
      { } { \__ccnu_error:nnnn { package-too-old } { Package } {#1} {#3} }
  }
% 文类版本检测
\cs_new_protected:Npn \__ccnu_check_class:nnn #1#2#3
  {
    \@ifclasslater {#1} {#2}
      { } { \__ccnu_error:nnnn { package-too-old } { Class } {#1} {#3} }
  }
\__ccnu_msg_new:nn { package-too-old }
  {
    #1~ "#2"~ is~ too~ old. \\
    The~ ccnuthesis~ class~ only~ supports~ "#2" \\
    with~ a~ version~ higher~ than~ v#3. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ it \\
    using~ your~ TeX~ package~ manager~ or~ from~ CTAN.
  }
\__ccnu_check_class:nnn { ctexbook } { 2021/03/14 } { 2.5.6 }
\__ccnu_check_package:nnn { expl3 } { 2021/08/27 } { }
% 编译方式检测
\sys_if_engine_xetex:T
  { \__ccnu_check_package:nnn { xeCJK } { 2020/05/01 } { 3.8.3 } }



% 定义一些常量
\clist_map_inline:nn
  {
    { fwid_full_stop   } { ^^^^ff0e }
  }
  { \__ccnu_define_punct:nn #1 }
\clist_map_inline:nn
  {
    { student_id         } { 学号                      },
    { department         } { 学院                      },
    { major              } { 专业                      },
    { level              } { 年级                      },
    { author             } { 学生姓名                   },
    { supervisor         } { 指导教师                   },
    { toc                } { 目 \__ccnu_quad: 录  },
    { pdf_creator        } { LaTeX~ with~ ccnuthesis~ class  },
    { notation           } { 符号表  },
  }
  { \__ccnu_define_name:nn #1 }
\clist_map_inline:nn
  {
    { abstract } { 内容摘要    } { Abstract        },
    { keywords } { 关键词      } { Keywords        },
  }
  { \__ccnu_define_name:nnn #1 }


% 博士字号和行距
\int_compare:nNnT { \g__ccnu_thesis_type_int } = {1}
  {
    \AtBeginDocument 
      { \linespread{1} \fontsize{10.5pt}{19bp} \selectfont }
  }

% 字体设置
\tl_new:N \g__ccnu_fontset_tl
\tl_new:N \g__ccnu_cjk_fontset_tl

% 西文字体
\keys_define:nn { ccnu / style }
  {
    font .choices:nn =
      { newtx, times, stixtwo, xits, tg, none }
      { 
        \tl_set_eq:NN \g__ccnu_fontset_tl \l_keys_choice_tl 
        \int_compare:nTF { 1 <= \l_keys_choice_int <= 2 }
          {
            \cs_set_eq:NN \oldencodingdefault \encodingdefault
            \cs_set_eq:NN \oldrmdefault \rmdefault
            \cs_set_eq:NN \oldsfdefault \sfdefault
            \cs_set_eq:NN \oldttdefault \ttdefault
            % \RequirePackage [T1] { fontenc }
            \cs_set:Nn \defaultencoding: { T1 }
            \cs_set_eq:NN \defaultencoding \defaultencoding:
            \RenewDocumentCommand { \rmdefault } { } { ntxtlf }
            \RenewDocumentCommand { \sfdefault } { } { qhv }
            \RenewDocumentCommand { \ttdefault } { } { ntxtt }
            \RequirePackage { newtxmath }
            \cs_set_eq:NN \encodingdefault \oldencodingdefault
            \cs_set_eq:NN \rmdefault \oldrmdefault
            \cs_set_eq:NN \sfdefault \oldsfdefault
            \cs_set_eq:NN \ttdefault \oldttdefault
          }
          {
            \RequirePackage { unicode-math }
            \keys_set:nn { unicode-math }
              {
                math-style = ISO,
                bold-style = ISO,
              }
            \__ccnu_set_font_helper:n { math }
          }
      },
  }

% 中文字体
\keys_define:nn { ccnu / style }
  {
    cjk-font .choices:nn =
      { adobe, fandol, founder, mac, sinotype, sourcehan, windows, none }
      { \tl_set_eq:NN \g__ccnu_cjk_fontset_tl \l_keys_choice_tl }
  }
\keys_set:nn { ccnu / style }
  {
    font = times,
    cjk-font = fandol
  }
\cs_new_protected:Npn \__ccnu_setmainfont:nn #1#2
  { \__fontspec_main_setmainfont:nn {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setsansfont:nn #1#2
  { \__fontspec_main_setsansfont:nn {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setmonofont:nn #1#2
  { \__fontspec_main_setmonofont:nn {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setmathfont:nn #1#2
  { \__um_setmathfont:nn {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setCJKmainfont:nn #1#2
  { \__ccnu_set_family:xnn { \CJKrmdefault } {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setCJKsansfont:nn #1#2
  { \__ccnu_set_family:xnn { \CJKsfdefault } {#2} {#1} }
\cs_new_protected:Npn \__ccnu_setCJKmonofont:nn #1#2
  { \__ccnu_set_family:xnn { \CJKttdefault } {#2} {#1} }
\cs_new_protected:Npn \__ccnu_set_cjk_font_kai:nn #1#2
  { \__ccnu_set_family:nnn { ccnu@kai } {#2} {#1} }
\cs_new_protected:Npn \ccnu@kai
  { \__ccnu_switch_family:n { ccnu@kai } }
\tl_const:Nn \__ccnu_cjk_font_options:
  { UprightFont = *, ItalicFont = *, AutoFakeBold = true }
\cs_new_protected:Npx \__ccnu_setCJKmainfont:n #1
  { \__ccnu_setCJKmainfont:nn {#1} { \__ccnu_cjk_font_options: } }
\cs_new_protected:Npx \__ccnu_setCJKsansfont:n #1
  { \__ccnu_setCJKsansfont:nn {#1} { \__ccnu_cjk_font_options: } }
\cs_new_protected:Npx \__ccnu_setCJKmonofont:n #1
  { \__ccnu_setCJKmonofont:nn {#1} { \__ccnu_cjk_font_options: } }
\cs_new_protected:Npx \__ccnu_set_cjk_font_kai:n #1
  { \__ccnu_set_cjk_font_kai:nn {#1} { \__ccnu_cjk_font_options: } }
\sys_if_engine_xetex:TF
  {
    \cs_new_eq:NN \__ccnu_set_family:nnn  \xeCJK_set_family:nnn
    \cs_new_eq:NN \__ccnu_switch_family:n \xeCJK_switch_family:n
  }
  {
    \cs_new_eq:NN \__ccnu_set_family:nnn  \ctex_ltj_set_family:nnn
    \cs_new_eq:NN \__ccnu_switch_family:n \ctex_ltj_switch_family:n
  }
\cs_generate_variant:Nn \__ccnu_set_family:nnn { x }
\cs_new_protected:Npn \__ccnu_set_font_helper:n #1
  {
    \exp_args:Nc \RenewDocumentCommand { set #1 font } { O { } m O { } }
      {
        \ctex_at_end_preamble:n
          { \use:c { __ccnu_set #1 font:nn } {##2} { ##1, ##3 } }
      }
  }
\clist_map_inline:nn { main, sans, mono } { \__ccnu_set_font_helper:n {#1} }
\clist_map_inline:nn { CJKmain, CJKsans, CJKmono } { \__ccnu_set_font_helper:n {#1} }


\tl_new:N \g__ccnu_font_style_libertinus_bfsl_tl
\fontspec_font_if_exist:nTF { LibertinusSans-BoldOblique.otf }
  { \tl_set:Nn \g__ccnu_font_style_libertinus_bfsl_tl { BoldOblique } }
  { \tl_set:Nn \g__ccnu_font_style_libertinus_bfsl_tl { Bold        } }


% 目前的字体配置为: (TG = TeX Gyre, 默认值为 times)
%   选项名  : serif,            sans,     mono,         math
%   stixtwo : STIX Two Text,    TG Heros, TG Cursor,    STIX Two Math
%   xits    : XITS,             TG Heros, TG Cursor,    XITS Math
%   times   : Times New Roman,  Arial,    Courier New,  newtxmath
%   newtx   : TG Termes,        TG Heros, TG Cursor,    newtxmath
%   tg      : TG Termes,        TG Heros, TG Cursor,    TG Termes Math

\cs_new_protected:Npn \__ccnu_load_font_stixtwo:
  {
    \__ccnu_setmainfont:nn { STIXTwoText }
      {
        Extension          = .otf,
        UprightFont        = *-Regular,
        BoldFont           = *-Bold,
        ItalicFont         = *-Italic,
        BoldItalicFont     = *-BoldItalic
      }
    \__ccnu_setsansfont:nn { texgyreheros }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__ccnu_setmonofont:nn { texgyrecursor }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic,
        Ligatures      = CommonOff
      }
    \__ccnu_setmathfont:nn {STIXTwoMath-Regular.otf} { }
    \__ccnu_setmathfont:nn {STIXTwoMath-Regular.otf} 
      { range = {scr, bfscr}, StylisticSet = 01 }
  }
\cs_new_protected:Npn \__ccnu_load_font_xits:
  {
    \__ccnu_setmainfont:nn { XITS }
      {
        Extension          = .otf,
        UprightFont        = *-Regular,
        BoldFont           = *-Bold,
        ItalicFont         = *-Italic,
        BoldItalicFont     = *-BoldItalic
      }
    \__ccnu_setsansfont:nn { texgyreheros }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__ccnu_setmonofont:nn { texgyrecursor }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic,
        Ligatures      = CommonOff
      }
    \__ccnu_setmathfont:nn { XITSMath-Regular.otf } 
      { BoldFont = XITSMath-Bold.otf }
    \__ccnu_setmathfont:nn{ XITSMath-Regular.otf } 
      { range = {cal, bfcal}, StylisticSet = 01 }
  }
\cs_new_protected:Npn \__ccnu_load_font_times:
  {
    \__ccnu_setmainfont:nn { Times~ New~ Roman    } { }
    \__ccnu_setsansfont:nn { Arial                } { }
    \__ccnu_setmonofont:nn { Courier~ New         } { }
  }
\cs_new_protected:Npn \__ccnu_load_font_newtx:
  {
    \__ccnu_setmainfont:nn { TeXGyreTermesX }
      {
        Extension          = .otf,
        UprightFont        = *-Regular,
        BoldFont           = *-Bold,
        ItalicFont         = *-Italic,
        BoldItalicFont     = *-BoldItalic
      }
    \__ccnu_setsansfont:nn { texgyreheros }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__ccnu_setmonofont:nn { texgyrecursor }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic,
        Ligatures      = CommonOff
      }
  }
  \cs_new_protected:Npn \__ccnu_load_font_tg:
  {
    \__ccnu_setmainfont:nn { texgyretermes }
      {
        Extension          = .otf,
        UprightFont        = *-regular,
        BoldFont           = *-bold,
        ItalicFont         = *-italic,
        BoldItalicFont     = *-bolditalic
      }
    \__ccnu_setsansfont:nn { texgyreheros }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__ccnu_setmonofont:nn { texgyrecursor }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic,
        Ligatures      = CommonOff
      }
      \__ccnu_setmathfont:nn { texgyretermes-math.otf } { }
      \__ccnu_setmathfont:nn{ XITSMath-Regular.otf } 
        { range = {cal, bfcal}, StylisticSet = 01 }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_adobe:
  {
    \__ccnu_setCJKmainfont:n   { AdobeSongStd-Light       }
    \__ccnu_setCJKsansfont:n   { AdobeHeitiStd-Regular    }
    \__ccnu_setCJKmonofont:n   { AdobeFangsongStd-Regular }
    \__ccnu_set_cjk_font_kai:n { AdobeKaitiStd-Regular    }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_fandol:
  {
    \__ccnu_setCJKmainfont:nn   { FandolSong }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__ccnu_setCJKsansfont:nn   { FandolHei  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__ccnu_setCJKmonofont:nn   { FandolFang }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
    \__ccnu_set_cjk_font_kai:nn { FandolKai  }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Regular,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Regular
      }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_founder:
  {
    \__ccnu_setCJKmainfont:n   { FZShuSong-Z01  }
    \__ccnu_setCJKsansfont:n   { FZHei-B01      }
    \__ccnu_setCJKmonofont:n   { FZFangSong-Z02 }
    \__ccnu_set_cjk_font_kai:n { FZKai-Z03      }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_mac:
  {
    \__ccnu_setCJKmainfont:nn   { STSongti-SC }
      {
        UprightFont    = *-Light,
        BoldFont       = *-Bold,
        ItalicFont     = *-Light,
        BoldItalicFont = *-Bold
      }
    \__ccnu_setCJKsansfont:nn   { STHeitiSC   }
      {
        UprightFont    = *-Medium,
        BoldFont       = *-Medium,
        ItalicFont     = *-Medium,
        BoldItalicFont = *-Medium
      }
    \__ccnu_setCJKmonofont:n    { STFangsong  }
    \__ccnu_set_cjk_font_kai:nn { STKaitiSC   }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_sinotype:
  {
    \__ccnu_setCJKmainfont:n   { STSong     }
    \__ccnu_setCJKsansfont:n   { STHeiti    }
    \__ccnu_setCJKmonofont:n   { STFangsong }
    \__ccnu_set_cjk_font_kai:n { STKaiti    }
  }
\cs_new_protected:Npn \__ccnu_load_cjk_font_sourcehan:
  {
    \__ccnu_setCJKmainfont:nn { SourceHanSerifSC }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__ccnu_setCJKsansfont:nn { SourceHanSansSC  }
      {
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Regular,
        BoldItalicFont = *-Bold
      }
    \__ccnu_warning:n { source-han }
  }
\__ccnu_msg_new:nn { source-han }
  { Font~ set~ `sourcehan'~ does~ not~ contain~ kaiti~ and~ fangsong. }
\cs_new_protected:Npn \__ccnu_load_cjk_font_windows:
  {
    \__ccnu_setCJKmainfont:n   { SimSun   }
    \__ccnu_setCJKsansfont:n   { SimHei   }
    \__ccnu_setCJKmonofont:n   { FangSong }
    \__ccnu_set_cjk_font_kai:n { KaiTi    }
  }
\cs_new_protected:Npn \__ccnu_load_font:
  {
    \use:c { __ccnu_load_font_     \g__ccnu_fontset_tl     : }
    \use:c { __ccnu_load_cjk_font_ \g__ccnu_cjk_fontset_tl : }
  }
\ctex_at_end_preamble:n { \__ccnu_load_font: }


% 华文新魏字体处理
\sys_if_platform_windows:TF
  {
    % Windows
    \newCJKfontfamily \ccnutitlefont { STXinwei }
  }
  {
    \ctex_if_platform_macos:TF
      {
        % Mac
        \fontspec_font_if_exist:nTF { STXinwei }
          {
            \newCJKfontfamily \ccnutitlefont { STXinwei }
          }
          {
            % 没有华文新魏的话就用黑体
            \newCJKfontfamily \ccnutitlefont { Heiti~SC~Light }
          }
      }
      {
        % Linux
        \fontspec_font_if_exist:nTF { STXinwei }
          {
            \newCJKfontfamily \ccnutitlefont { STXinwei }
          }
          {
            \newCJKfontfamily \ccnutitlefont { FandolHei-Regular }
          }

      }
  }


% 标点处理
\keys_define:nn { ccnu / style }
  {
    fullwidth-stop .choice:,
    fullwidth-stop .value_required:n = true,
    fullwidth-stop / catcode .code:n =
      { 
        \__ccnu_set_fullwidth_stop_catcode:
        % 设置标点为 kaiming 式
        \keys_set:nn { ctex } { punct = kaiming }
      },
    fullwidth-stop / mapping .code:n =
      {
        \clist_gset:Nn \g__xeCJK_default_features_clist
          { Mapping = fullwidth-stop }
        \keys_set:nn { ctex } { punct = kaiming }
      },
    fullwidth-stop / false .code:n = { }
  }
\cs_new:Npn \__ccnu_set_fullwidth_stop_catcode:
  {
    \char_set_active_eq:NN ^^^^3002 \c__ccnu_fwid_full_stop_tl
    \char_set_catcode_active:N ^^^^3002
  }

\keys_set:nn { ccnu / style }
  {
    fullwidth-stop = false
  }

% 脚注

\clist_map_inline:nn
  {
    { plain           } { plain           },
    { libertinus      } { libertinus      },
    { libertinus_neg  } { libertinus*     },
    { libertinus_sans } { libertinus-sans },
    { pifont          } { pifont          },
    { pifont_neg      } { pifont*         },
    { pifont_sans     } { pifont-sans     },
    { pifont_sans_neg } { pifont-sans*    },
    { xits            } { xits            },
    { xits_sans       } { xits-sans       },
    { xits_sans_neg   } { xits-sans*      }
  }
  { \__ccnu_define_fn_style:nn #1 }
\tl_new:N \l__ccnu_fn_style_tl
\keys_define:nn { ccnu / style }
  {
    footnote-style .choices:nn =
      {
        plain,
        libertinus, libertinus*, libertinus-sans,
        pifont,     pifont*,     pifont-sans,     pifont-sans*,
        xits,                    xits-sans,       xits-sans*
      }
      {
        \tl_gset_eq:NN \l__ccnu_fn_style_tl \l_keys_choice_tl
        \int_compare:nT { 5 <= \l_keys_choice_int <= 8 }
          { \RequirePackage { pifont } }
      },
    footnote-style .value_required:n = true
  }
\keys_set:nn { ccnu / style }
  {
    footnote-style = xits
  }
\cs_new:Npn \__ccnu_fn_symbol_libertinus:n #1
  {
    \int_compare:nTF { #1 >= 21 }
      {
        \int_compare:nTF { #1 >= 47 }
          { \__ccnu_symbol:n { \int_eval:n { "24B6 - 47 + #1 } } }
          { \__ccnu_symbol:n { \int_eval:n { "24D0 - 21 + #1 } } }
      }
      { \__ccnu_symbol:n { \int_eval:n { "2460 - 1 + #1 } } }
  }
\cs_new:Npn \__ccnu_fn_symbol_libertinus_neg:n #1
  {
    \int_compare:nTF { #1 >= 11 }
      { \__ccnu_symbol:n { \int_eval:n { "24EB - 11 + #1 } } }
      { \__ccnu_symbol:n { \int_eval:n { "2776 -  1 + #1 } } }
  }
\cs_new_eq:NN \__ccnu_fn_symbol_libertinus_sans:n \__ccnu_fn_symbol_libertinus:n
\cs_new:Npn \__ccnu_fn_symbol_pifont:n #1
  { \ding { \int_eval:n { 171 + #1 } } }
\cs_new:Npn \__ccnu_fn_symbol_pifont_neg:n #1
  { \ding { \int_eval:n { 181 + #1 } } }
\cs_new:Npn \__ccnu_fn_symbol_pifont_sans:n #1
  { \ding { \int_eval:n { 191 + #1 } } }
\cs_new:Npn \__ccnu_fn_symbol_pifont_sans_neg:n #1
  { \ding { \int_eval:n { 201 + #1 } } }
\cs_new:Npn \__ccnu_fn_symbol_xits:n #1
  {
    \int_compare:nTF { #1 >= 10 }
      {
        \int_compare:nTF { #1 >= 36 }
          { \__ccnu_symbol:n { \int_eval:n { "24B6 - 36 + #1 } } }
          { \__ccnu_symbol:n { \int_eval:n { "24D0 - 10 + #1 } } }
      }
      { \__ccnu_symbol:n { \int_eval:n { "2460 - 1 + #1 } } }
  }
\cs_new:Npn \__ccnu_fn_symbol_xits_sans:n #1
  { \__ccnu_symbol:n { \int_eval:n { "2780 - 1 + #1 } } }
\cs_new:Npn \__ccnu_fn_symbol_xits_sans_neg:n #1
  { \__ccnu_symbol:n { \int_eval:n { "278A - 1 + #1 } } }
\cs_set:Npn \thefootnote { \ccnu_footnote_number:N \c@footnote }
\cs_new:Npn \ccnu_footnote_number:N #1
  {
    \tl_case:NnF \l__ccnu_fn_style_tl
      {
        \c__ccnu_fn_style_plain_tl
          { \int_use:N #1 }
        \c__ccnu_fn_style_libertinus_tl
          {
            \fontspec { LibertinusSerif-Regular .otf }
            \__ccnu_fn_symbol_libertinus:n {#1}
          }
        \c__ccnu_fn_style_libertinus_neg_tl
          {
            \fontspec { LibertinusSerif-Regular .otf }
            \__ccnu_fn_symbol_libertinus_neg:n {#1}
          }
        \c__ccnu_fn_style_libertinus_sans_tl
          {
            \fontspec { LibertinusSans-Regular .otf }
            \__ccnu_fn_symbol_libertinus_sans:n {#1}
          }
        \c__ccnu_fn_style_pifont_tl
          { \__ccnu_fn_symbol_pifont:n {#1} }
        \c__ccnu_fn_style_pifont_neg_tl
          { \__ccnu_fn_symbol_pifont_neg:n {#1} }
        \c__ccnu_fn_style_pifont_sans_tl
          { \__ccnu_fn_symbol_pifont_sans:n {#1} }
        \c__ccnu_fn_style_pifont_sans_neg_tl
          { \__ccnu_fn_symbol_pifont_sans_neg:n {#1} }
        \c__ccnu_fn_style_xits_tl
          {
            \fontspec { XITS-Regular .otf }
            \__ccnu_fn_symbol_xits:n {#1}
          }
        \c__ccnu_fn_style_xits_sans_tl
          {
            \fontspec { XITS-Regular .otf }
            \__ccnu_fn_symbol_xits_sans:n {#1}
          }
        \c__ccnu_fn_style_xits_sans_neg_tl
          {
            \fontspec { XITS-Regular .otf }
            \__ccnu_fn_symbol_xits_sans_neg:n {#1}
          }
      }
      { \int_use:N #1 }
  }
\cs_set:Npn \@makefntext #1
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn { 1.5 em } { \@thefnmark \hfil }
    #1
  }



% 页面设置
\int_case:nn { \g__ccnu_thesis_type_int }
  {
    % 本科
    {3}
    {
      \geometry
        {
          paper    = a4paper,
          left     = 3cm,
          right    = 2.5cm,
          top      = 3cm,
          bottom   = 2.5cm
        }
    }
    % 硕士
    {2}
    {
      \geometry
        {
          paper      = a4paper,
          left       = 2.8cm,
          right      = 3cm,
          top        = 3.9cm,
          headheight = 2.0cm,
          headsep    = 4mm,
          bottom     = 3.5cm,
          footskip   = 0.8cm
        }
    }
    % 博士
    {1}
    {
      \geometry
        {
          paper      = a4paper,
          left       = 2.9cm,
          right      = 2.9cm,
          top        = 3.9cm,
          headheight = 2.1cm,
          headsep    = 3mm,
          bottom     = 3.5cm,
          footskip   = 0.8cm
        }
    }
  }

\bool_if:NT \g__ccnu_draft_bool { \geometry { showframe } }

% 图片路径
\graphicspath{{figures/}{logo/}{copyright/}}


% 列表环境设置
\setlist{nosep}


% enumerate
\setenumerate[1]
  {
    labelindent    = \parindent,
    leftmargin     = 0pt,
    widest         = 0,
    itemindent     = *,
    listparindent  = \parindent,
  }
\setenumerate[2]
  {
    labelindent    = \parindent,
    leftmargin     = 0em,
    widest         = 0,
    itemindent     = *,
    listparindent  = \parindent,
  }

% itemize
\setitemize[1]
  {
    labelindent    = \parindent,
    leftmargin     = 2em,
    widest         = 0,
    itemindent     = \parindent,
    listparindent  = \parindent,
  }
\setitemize[2]
  {
    labelindent    = \parindent,
    leftmargin     = 0em,
    widest         = 0,
    itemindent     = *,
    listparindent  = \parindent,
  }


% 攻读学位期间取得的研究成果（博士）
\NewDocumentCommand { \publication } { }
  {
    \newpage
    \RenewDocumentCommand{ \chapter }{ s o m }
      {
        \IfBooleanTF {##1}
          { \__ccnu_chapter_star:n {##3} }
          {
            \IfNoValueTF {##2}
              { \__cchu_chapter:nn {##3} }
              { \__cchu_chapter:nn [##2] {##3} }
          }
      }
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              numbering = false,
              indent = 0em,
              format = \zihao{3} \sffamily \bfseries \centering
            }
        }
      \chapter{攻读学位期间发表的学术论文}
      % \addcontentsline{toc}{chapter}{\zihao{5} \bfseries 攻读学位期间发表的学术论文}
    \group_end:
    \keys_set:nn { ctex }
      {
        punct = banjiao,
      }
  }
\newlist{publications}{enumerate}{1}
\setlist[publications]
  {
    label      = [\arabic*],
    align      = right,
    leftmargin = 10mm,
    topsep     = 6bp,
    parsep     = 0bp,
    partopsep  = 0bp,
    itemsep    = 6bp,
    labelsep   = !,
    resume     = publications,
  }



% 设置公式最小垂直间距
\dim_set:Nn \lineskiplimit { 2.5pt }
\dim_set:Nn \lineskip { \baselineskip-1.1\ccwd }


% 处理孤行和寡行
\int_set:Nn \clubpenalty { 350 }
\int_set:Nn \widowpenalty { 350 }


% 页眉页脚设置
% \chapter 要 patch 「\pagestyle { plain }」
% \patchcmd
%   { \chapter }
%   { \pagestyle { plain } }
%   { \thispagestyle { plain } }
%   {} { \fail }
% 见：https://github.com/CTeX-org/forum/issues/82#issuecomment-569498876


\cs_new:Npn \__ccnu_pagestyle_bachelor_plain:
  {
    \fancypagestyle { plain }
      {
        \fancyhf { }
        \RenewDocumentCommand { \headrulewidth } { } { 0pt }
        \fancyfoot [ C ] { \small \thepage }
      }
  }
\cs_new:Npn \__ccnu_pagestyle_bachelor_plain_nopage:
  {
    \fancypagestyle { plain }
      {
        \fancyhf { }
        \RenewDocumentCommand { \headrulewidth } { } { 0pt }
      }
  }
% 目录的 pagestyle 设置
\cs_new:Npn \__ccnu_pagestyle_tableofcontents_bachelor:
  {
    \fancypagestyle { plain }
      {
        \fancyhf { }
        \RenewDocumentCommand { \headrulewidth } { } { 0pt }
      }
  }
\cs_new:Npn \__ccnu_pagestyle_tableofcontents_master_doctor:
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        % 有页眉，无页码
        \__ccnu_pagestyle_master_doctor_plain_withhead_nopage:
      }
      {
        % 无页眉，无页码
        \__ccnu_pagestyle_master_doctor_plain_withouthead_nopage:
      }
  }

% 目录前的 pagestyle 设置
% \cs_new:Npn \__ccnu_pagestyle_setting_before_tableofcontents:
%   {
%     \bool_lazy_and:nnTF
%       { \bool_if_p:N \g__ccnu_head_scope_all_bool }
%       { \bool_if_p:N \g__ccnu_showhead_bool }
%       {
%         % 有页眉，无页码
%         \__ccnu_pagestyle_master_doctor_plain_withhead_nopage:
%       }
%       {
%         % 无页眉，无页码
%         \__ccnu_pagestyle_master_doctor_plain_withouthead_nopage:
%       }
%   }
\cs_new:Npn \__ccnu_pagestyle_setting_before_tableofcontents:
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        % 有页眉，无页码
        \__ccnu_pagestyle_master_doctor_plain_withhead:
      }
      {
        % 无页眉，无页码
        \__ccnu_pagestyle_master_doctor_plain_withouthead:
      }
  }

\cs_new:Npn \__ccnu_pagestyle_setting_after_tableofcontents:
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        % 有页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withhead:
      }
      {
        % 无页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withouthead:
      }
  }

% 摘要的 pagestyle 设置
\cs_new:Npn \__ccnu_pagestyle_setting_before_abstract:
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        % 有页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withhead:
      }
      {
        % 无页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withouthead:
      }
  }
\cs_new:Npn \__ccnu_pagestyle_setting_abstract_lastpage:
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        % 有页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withhead:
      }
      {
        % 无页眉，有页码
        \__ccnu_pagestyle_master_doctor_plain_withouthead:
      }
  }

\AtEndPreamble
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      {
        \__ccnu_pagestyle_bachelor_plain:
      }
      { 
        % 对硕博目录最后一页进行 pagestyle 的处理
        \__ccnu_pagestyle_setting_before_tableofcontents: 
      }
    % 改变 chapter 的首页的 pagestyle
    % \patchcmd { \chapter }
    %   { \thispagestyle { \CTEX@chapter@pagestyle } }
    %   { \pagestyle{plain} }
    %   {}
    %   {\fail}
    % \pagestyle{plain}
    \AddToHook { cmd / chapter / before } { \pagestyle{plain} }
  }

\cs_new:Npn \__ccnu_pagestyle_master_doctor_plain_withouthead:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \fancyfoot [ C ] { \zihao{5} \thepage }
          }
      }
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \fancyfoot [ OR, EL ] { \zihao{5} \thepage }
          }
      }
  }
\cs_new:Npn \__ccnu_pagestyle_master_doctor_plain_withouthead_nopage:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
          }
      }
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
          }
      }
  }
\cs_new:Npn \__ccnu_pagestyle_master_doctor_plain_withhead:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \bool_if:NT \g__ccnu_showheadlogo_bool
              {
                % logo
                \fancyhead [ L ] 
                  { \includegraphics[width = 5cm]{ masterlogo.png } }
              }
            % 页眉线
            \__ccnu_headline:
            \fancyfoot [ C ] { \zihao{5} \thepage }
          }
      }
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \bool_if:NT \g__ccnu_showheadlogo_bool
              {
                % logo
                \fancyhead [ L ] 
                  { \includegraphics[width = 7cm]{ doctorlogo.png } }
              }
            % 页眉线
            \__ccnu_headline:
            \fancyfoot [ OR, EL ] { \zihao{5} \thepage }
          }
      }
  }

\cs_new:Npn \__ccnu_pagestyle_master_doctor_plain_withhead_nopage:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \bool_if:NT \g__ccnu_showheadlogo_bool
              {
                % logo
                \fancyhead [ L ] 
                  { \includegraphics[width = 5cm]{ masterlogo.png } }
              }
            % 页眉线
            \__ccnu_headline:
          }
      }
      {
        \fancypagestyle { plain }
          {
            \fancyhf { }
            \RenewDocumentCommand { \headrulewidth } { } { 0pt }
            \bool_if:NT \g__ccnu_showheadlogo_bool
              {
                % logo
                \fancyhead [ L ] 
                  { \includegraphics[width = 7cm]{ doctorlogo.png } }                
              }
            % 页眉线
            \__ccnu_headline:
          }
      }
  }
\fancypagestyle { masterplain }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \fancyfoot [ C ] { \zihao{5} \thepage }
  }
\fancypagestyle { masterplain-head }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \bool_if:NT \g__ccnu_showheadlogo_bool
      {
        % logo
        \fancyhead [ L ] 
          { \includegraphics[width = 5cm]{ masterlogo.png } }        
      }
    % 页眉线
    \__ccnu_headline:
    \fancyfoot [ C ] { \zihao{5} \thepage }
  }
\fancypagestyle { masterplain-head-nopage }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \bool_if:NT \g__ccnu_showheadlogo_bool
      {
        % logo
        \fancyhead [ L ] 
          { \includegraphics[width = 5cm]{ masterlogo.png } }
      }
    % 页眉线
    \__ccnu_headline:
  }
\fancypagestyle { doctorplain }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \fancyfoot [ OR, EL ] { \zihao{5} \thepage }
  }
\fancypagestyle { doctorplain-head }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \bool_if:NT \g__ccnu_showheadlogo_bool
      {
        % logo
        \fancyhead [ L ] 
          { \includegraphics[width = 7cm]{ doctorlogo.png } }
      }
    % 页眉线
    \__ccnu_headline:
    \fancyfoot [ OR, EL ] { \zihao{5} \thepage }
  }
\fancypagestyle { doctorplain-head-nopage }
  {
    \fancyhf { }
    \RenewDocumentCommand { \headrulewidth } { } { 0pt }
    \bool_if:NT \g__ccnu_showheadlogo_bool
      {
        % logo
        \fancyhead [ L ] 
          { \includegraphics[width = 7cm]{ doctorlogo.png } }
      }
    % 页眉线
    \__ccnu_headline:
  }

\cs_new:Npn \__ccnu_headline:
  {
    \str_case:VnTF \g__ccnu_headline_str
      {
        {single}
          {
            \fancyhead [ C ]
              {
                \rule [ -4pt ] { \textwidth } { 0.6pt }
              }
          }
        {double}
          {
            \fancyhead [ C ]
              {
                \makebox [ 0pt ] [ l ]
                  {
                    \rule [ -4pt ] { \textwidth } { 0.6pt }
                  }
                \rule [ -6.5pt ] { \textwidth } { 0.6pt }
              }
          }
        {thin-thick}
          {
            \fancyhead [ C ]
              {
                \makebox [ 0pt ] [ l ]
                  {
                    \rule [ -4pt ] { \textwidth } { 0.6pt }
                  }
                \rule [ -7pt ] { \textwidth } { 1.5pt }
              }
          }
        {thick-thin}
          {
            \fancyhead [ C ]
              {
                \makebox [ 0pt ] [ l ]
                  {
                    \rule [ -4pt ] { \textwidth } { 1.5pt }
                  }
                \rule [ -6.5pt ] { \textwidth } { 0.6pt }
              }
          }
        {none}{}
      }
      {}{}
  }
\RenewDocumentCommand { \backmatter } { } {}

% \patchcmd { \frontmatter }
%   { \cleardoublepage }
%   {}
%   {} {\fail}


\AtEndPreamble
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      {
        % 重新设置 frontmatter 的计数器的样式
        \patchcmd { \frontmatter }
        { \pagenumbering { roman } }
        { \pagenumbering { arabic } }
        {}{ \fail }
        % 重新设置 mainmatter 的计数器，使得页码接着前面的(本科)
        \patchcmd { \mainmatter }
          { \pagenumbering { arabic } }
          { \renewcommand { \thepage }{ \arabic{ page } } }
          {}{ \fail }
      }
      {
        % 处理正文的页眉
        \apptocmd { \mainmatter }
          {
            \bool_if:NTF \g__ccnu_showhead_bool
              {
                % 有页眉，有页码
                \__ccnu_pagestyle_master_doctor_plain_withhead:
              }
              {
                % 无页眉，有页码
                \__ccnu_pagestyle_master_doctor_plain_withouthead:
              }
          }
          {}{\fail}
      }
  }

% 控制页眉的全局与否
\bool_new:N \g__ccnu_head_scope_all_bool

\keys_define:nn { ccnu / style }
  {
    show-head .bool_gset:N = \g__ccnu_showhead_bool,
    show-head .default:n = true,
    show-headlogo .bool_gset:N = \g__ccnu_showheadlogo_bool,
    show-headlogo .default:n = true,
    % headline .str_gset:N = \g__ccnu_headline_str,
    headline .code:n = 
      {
        \str_gset:Nn \g__ccnu_headline_str {#1}
      },
    headline .value_required:n = true,
    head-scope .choice:,
    head-scope / all .code:n = 
      {
        \bool_gset_true:N \g__ccnu_head_scope_all_bool
      },
    head-scope / main .code:n = 
      {
        \bool_gset_false:N \g__ccnu_head_scope_all_bool
      }
  }
\keys_set:nn { ccnu / style }
  {
    show-head = true,
    show-headlogo = true,
    headline = thick-thin,
    head-scope = main
  }
% 定理类环境

% 去掉.号，但只能通过新定义 style 的方式进行
\declaretheoremstyle
  [
    headpunct     = {},
    postheadspace = { 0.5em },
    headindent    = 2\ccwd
  ]
  { ccnustyle }
\cs_new:Npn \__xdyymath_declare_theorem_with_counter_within:n #1
  {
    \declaretheorem
      [
        style = ccnustyle,
        name =  \clist_item:nn {#1} {1} ,
        refname = \clist_item:nn {#1} {2} ,
        within = \clist_item:nn {#1} {3} ,
      ]
      { \clist_item:nn {#1} {4} }
  }
\cs_new:Npn \__xdyymath_declare_theorem_with_counter_sibling:n #1
  {
    \declaretheorem
      [
        style   = ccnustyle ,
        name    = \clist_item:nn {#1} {1} ,
        refname = \clist_item:nn {#1} {2} ,
        sibling = \clist_item:nn {#1} {3} ,
      ]
      { \clist_item:nn {#1} {4} }
  }


% 和旧模版一样的计数器依赖

\clist_map_function:nN
  {
    { 定理, 定理, chapter, theorem },
    { 例, 例, chapter, example },
    { 问题, 问题, chapter, question },
  }
  \__xdyymath_declare_theorem_with_counter_within:n

\clist_map_function:nN
  {
    { 定义, 定义, theorem, definition },
    { 性质, 性质, theorem, property },
    { 命题, 命题, theorem, proposition },
    { 推论, 推论, theorem, corollary },
    { 引理, 引理, theorem, lemma },
    { 公理, 公理, theorem, axiom },
    { 反例, 反例, theorem, counterexample },
    { 猜想, 猜想, theorem, conjecture },
    { 断言, 断言, theorem, claim },
    { 注, 注, theorem, remark },
  }\__xdyymath_declare_theorem_with_counter_sibling:n

\NewDocumentCommand { \ccnunewtheorem } { s O{} m m }
  {
    \IfBooleanTF {#1}
      {
        % 有*
        \declaretheorem
          [
            style = ccnustyle,
            name =  #3 ,
            refname = #3 ,
            numbered = no,
            #2
          ]
          { #4 }
      }
      {
        % 无*
        \declaretheorem
          [
            style = ccnustyle,
            name =  #3 ,
            refname = #3 ,
            #2
          ]
          { #4 }
      }
  }

% 重定义 proof 环境的样式
\RenewDocumentEnvironment { proof } { O{\proofname} +b }
  {
    \par
    \pushQED { \qed }
    \normalfont \topsep6 \p@ \@plus6 \p@ \relax
    \trivlist
    \item \relax
    \group_begin:
      \hspace*{2\ccwd}
      \bfseries #1 \@addpunct{:}
    \group_end:
    \hspace \labelsep \ignorespaces
    #2
  }
  {
    \popQED \endtrivlist \@endpefalse
  }


% 命令环境的补丁和重定义

% 定义 \ccnukaishu 命令
\setCJKfamilyfont { zhkai }
  { FandolKai-Regular.otf } [ AutoFakeBold ]
\NewDocumentCommand { \ccnukaishu }{ } 
  { \CJKfamily { zhkai } }

% 重定义\emph命令
\RenewDocumentCommand{ \emph }{ m  }
  {
    \group_begin:
      \itshape \bfseries #1
    \group_end:
  }


% 取消 \nocite{} 的作用，防止用户自己使用
\RenewDocumentCommand { \nocite } { m } {}



% 把致谢和附录的标题设置代码封装

% 致谢
\NewDocumentCommand { \acknowledgements } { }
  {
    \RenewDocumentCommand{ \chapter }{ s o m }
      {
        \IfBooleanTF {##1}
          { \__ccnu_chapter_star:n {##3} }
          {
            \IfNoValueTF {##2}
              { \__cchu_chapter:nn {##3} }
              { \__cchu_chapter:nn [##2] {##3} }
          }
      }
    \int_case:nn { \g__ccnu_thesis_type_int }
      {
        {3} { \__ccnu_acknowlegements_bachelor: }
        {2} { \__ccnu_acknowlegements_master: }
        {1} { \__ccnu_acknowlegements_doctor: }
      }
  }

\cs_new:Npn \__ccnu_acknowlegements_bachelor:
  {
    \newpage
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              indent = 0pt,
              format = \zihao{-2} \normalfont \bfseries \centering
            }
        }
      \patchcmd { \chapter }
        {
          \int_gincr:N \g__ccnu_appendix_index_aux_int
        }
        {}{}{}
      \chapter*{致 \quad 谢}
      \addcontentsline{toc}{chapter}{\normalfont 致谢}
    \group_end:
    % 致谢采用全角标点
    \keys_set:nn { ctex }
      {
        punct = quanjiao,
      }
  }

\cs_new:Npn \__ccnu_acknowlegements_master:
  {
    \newpage
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              numbering = false,
              indent = 0em,
              format = \zihao{3} \sffamily \bfseries \centering
            }
        }
      \patchcmd { \chapter }
        {
          \int_gincr:N \g__ccnu_appendix_index_aux_int
        }
        {}{}{}
      \chapter {致 \quad 谢}
      % \addcontentsline{toc}{chapter}{\zihao{-4} \bfseries 致谢}
    \group_end:
    % 致谢采用全角标点
    \keys_set:nn { ctex }
      {
        punct = quanjiao,
      }
  }

\cs_new:Npn \__ccnu_acknowlegements_doctor:
  {
    \newpage
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              numbering = false,
              indent = 0em,
              format = \zihao{3} \sffamily \bfseries \centering
            }
        }
      \chapter {致 \quad 谢}
      % \addcontentsline{toc}{chapter}{\zihao{5} \bfseries 致谢}
    \group_end:
    % 致谢采用全角标点
    \keys_set:nn { ctex }
      {
        punct = quanjiao,
      }
  }

% 落款
\NewDocumentEnvironment { signature } { +b }
  {
    \vfil
    \begin{flushright}
      \begin{tabular}{c}
        #1
      \end{tabular}
    \end{flushright}
    \vfil
  }
  {}

% 附录
\int_new:N \g__ccnu_appendix_index_int
\int_gzero_new:N \g__ccnu_appendix_index_aux_int

\cs_set_eq:NN \__cchu_chapter:nn \chapter
\cs_new:Npn \__ccnu_chapter_star:n #1
  {
    \__cchu_chapter:nn * {#1}
  }


\cs_gset_protected:Npn \appendix
  {
    \newpage
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      {
        \keys_set:nn { ctex }
          {
            punct = quanjiao,
            chapter / indent = 0pt,
            section / indent = 0pt,
            subsection / indent = 0pt
          }
      }
      {
        \keys_set:nn { ctex }
          {
            punct = quanjiao,
            chapter / indent = 0pt
          }
      }
    % 调整附录的目录层级为 1 层
    \addtocontents { toc } { \protect \value{tocdepth} = 0 }
    \RenewDocumentCommand{ \chapter }{ s o m }
      {
        \IfBooleanTF {##1}
          { \__ccnu_chapter_star:n {##3} }
          {
            \IfNoValueTF {##2}
              { \__cchu_chapter:nn {##3} }
              { \__cchu_chapter:nn [##2] {##3} }
          }
        \int_gincr:N \g__ccnu_appendix_index_aux_int
      }
    % ctexbook.cls, line 1077
    \CTEX@save@appendix
    \gdef \CTEX@prechapter { \CTEX@preappendix }
    \int_compare:nNnTF { \g__ccnu_appendix_index_int } = {1}
      {
        \gdef \CTEX@thechapter { \@gobble \CTEX@appendix@number }
      }
      {
        \gdef \CTEX@thechapter { \CTEX@appendix@number }
      }
    \gdef \CTEX@postchapter { \CTEX@postappendix }
    \gdef \CTEX@chapter@numbering { \CTEX@appendix@numbering }
  }

\AtEndDocument
  {
    \iow_now:cx { @auxout }
      {
        \token_to_str:N \ExplSyntaxOn   % 要加一个token_to_str
        ^^J
        \int_gset:Nn \exp_not:N \g__ccnu_appendix_index_int { \int_use:N \g__ccnu_appendix_index_aux_int }
        ^^J
        \token_to_str:N \ExplSyntaxOff  % 要加一个token_to_str
      }
  }



% 章节标题样式

\cs_new:Npn \__ccnu_ctex_format_bachelor:
  {
    \bool_if:NTF \g__ccnu_chapter_newpage_bool
      {
        \keys_set:nn { ctex }
          {
            chapter =
              {
                format      = \zihao{-3} \normalfont \bfseries,
                name        = {},
                indent      = 2\ccwd,
                number      = \__ccnu_arabic:n { chapter },
                beforeskip  = 5 ex plus 0.5 ex,
                afterskip   = 2.7 ex plus 0.5 ex,
                break       = { \newpage },
                fixskip     = true
              }
          }
      }
      {
        \keys_set:nn { ctex }
          {
            chapter =
              {
                format      = \zihao{-3} \normalfont \bfseries,
                name        = {},
                indent      = 2\ccwd,
                number      = \__ccnu_arabic:n { chapter },
                beforeskip  = 5 ex plus 0.5 ex,
                afterskip   = 2.7 ex plus 0.5 ex,
                % break       = { \needspace { 4em } },
                break       = { \addpenalty { \@secpenalty } },
                fixskip     = true
              }
          }
      }
    \keys_set:nn { ctex }
      {
        % 编号的章节深度：到 subsubsection
        secnumdepth = 3,
        section =
          {
            format      = \zihao{4} \normalfont \bfseries \raggedright,
            beforeskip  = 4.5 ex plus 1.0 ex minus 0.2 ex,
            afterskip   = 2.7 ex plus 0.5 ex,
            fixskip     = true,
            indent      = 2\ccwd
          },
        subsection =
          {
            format      = \zihao{-4} \normalfont \bfseries \raggedright,
            beforeskip  = 4 ex plus 1.0 ex minus 0.2 ex,
            afterskip   = 2.5 ex plus 0.3 ex,
            fixskip     = true,
            indent      = 2\ccwd
          },
        subsubsection =
          {
            format      = \zihao{-4} \normalfont \bfseries \raggedright,
            beforeskip  = 1.5 ex plus 0.5 ex minus 0.2 ex,
            afterskip   = 1.5 ex plus 0.3 ex,
            fixskip     = true,
            indent      = 2\ccwd
          }
      }
  }
\cs_new:Npn \__ccnu_ctex_format_master_doctor:
  {
    \keys_set:nn { ctex }
      {
        % 编号的章节深度：到 subsubsection
        secnumdepth = 3,
        chapter =
          {
            format      = \zihao{3} \sffamily \bfseries \centering,
            name        = {},
            number      = \__ccnu_arabic:n { chapter },
            beforeskip  = 5 ex plus 0.5 ex,
            afterskip   = 2.7 ex plus 0.5 ex,
            break       = { \newpage },
            fixskip     = true
          },
        section =
          {
            format      = \zihao{4} \sffamily \bfseries \raggedright,
            beforeskip  = 4.5 ex plus 1.0 ex minus 0.2 ex,
            afterskip   = 2.7 ex plus 0.5 ex,
            fixskip     = true,
            indent      = 2\ccwd
          },
        subsection =
          {
            format      = \zihao{-4} \sffamily \bfseries \raggedright,
            beforeskip  = 4 ex plus 1.0 ex minus 0.2 ex,
            afterskip   = 2.5 ex plus 0.3 ex,
            fixskip     = true,
            indent      = 2\ccwd
          },
        subsubsection =
          {
            format      = \zihao{-4} \normalfont \bfseries \raggedright,
            beforeskip  = 1.5 ex plus 0.5 ex minus 0.2 ex,
            afterskip   = 1.5 ex plus 0.3 ex,
            fixskip     = true,
            indent      = 2\ccwd
          }
      }
  }

% 要放在导言区后，否则 chapter-breakstyle 键值设置之前就设置完了 chapter 的样式，就会使得控制失效
\AtEndPreamble
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      { \__ccnu_ctex_format_bachelor: }
      { \__ccnu_ctex_format_master_doctor: }
  }

\cs_new_protected:Npn \__ccnu_chapter_without_number_bachelor:n #1
  {
    \group_begin:
      \keys_set:nn { ctex } { chapter / numbering = false }
      \chapter {#1}
    \group_end:
  }
\cs_generate_variant:Nn \__ccnu_chapter_without_number_bachelor:n { V }
\cs_new_protected:Npn \__ccnu_chapter_master_doctor:n #1
  {
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              numbering = false,
              format = \zihao{3} \sffamily \bfseries \centering,
              indent = 0pt
            }
        }
      \chapter {#1}
    \group_end:
  }
\cs_generate_variant:Nn \__ccnu_chapter_master_doctor:n { V }
\cs_new_protected:Npn \__ccnu_chapter_master_doctor_en:n #1
  {
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              numbering = false,
              format = \zihao{3} \bfseries \centering,
              indent = 0pt
            }
        }
      \chapter {#1}
    \group_end:
  }
\cs_new_protected:Npn \__ccnu_chapter_no_toc:n #1
  {
    \chapter * {#1}
    \pdfbookmark [0] {#1} { toc }
  }
\cs_generate_variant:Nn \__ccnu_chapter_no_toc:n { V }



% 处理图表标题样式

\tl_new:N \l__ccnu_caption_label_seperator_tl

\keys_define:nn { ccnu /style }
  {
    caption-labelseperator .choice:,
    caption-labelseperator / space .code:n =
      {
        \tl_set:Nn \l__ccnu_caption_label_seperator_tl
          { ccnuspace }
      },
    caption-labelseperator / colon .code:n =
      {
        \tl_set:Nn \l__ccnu_caption_label_seperator_tl
          { colon }
      },
    caption-labelseperator .initial:n = colon
  }

% 图表 caption 字体
\DeclareCaptionFont { ccnufigurecap }
  { \normalfont \zihao { -5 } }
\DeclareCaptionFont { ccnutablecap }
  { \normalfont \zihao { -5 } }

% 图表 label 和标题之间的分割符
\DeclareCaptionLabelSeparator
  { ccnuspace } { \space \space }
\captionsetup [ figure ]
  {
    font     = ccnufigurecap,
    position = bottom,
    labelsep = \tl_use:N \l__ccnu_caption_label_seperator_tl
  }
\captionsetup [ table  ]
  {
    % font     = { small, sf },
    font     = ccnutablecap,
    position = top,
    labelsep = \tl_use:N \l__ccnu_caption_label_seperator_tl
  }
% 图表的标题 label 样式
\keys_define:nn { ccnu / style }
  {
    caption-labelstyle .choice:,
    caption-labelstyle / arabic .code:n = 
      {
        \cs_set:Npn \thefigure
          { \__ccnu_arabic:n { figure } }
        \cs_set:Npn \thetable
          { \__ccnu_arabic:n { table  } }
        \counterwithout{figure}{chapter}
        \counterwithout{table}{chapter}
      },
    caption-labelstyle / hyphen .code:n = 
      {
        \cs_set:Npn \thefigure
          { \thechapter - \__ccnu_arabic:n { figure } }
        \cs_set:Npn \thetable
          { \thechapter - \__ccnu_arabic:n { table  } }
      },
    caption-labelstyle / dot .code:n = 
      {
        \cs_set:Npn \thefigure
          { \thechapter . \__ccnu_arabic:n { figure } }
        \cs_set:Npn \thetable
          { \thechapter . \__ccnu_arabic:n { table  } }
      },
    caption-labelstyle .initial:n = hyphen,
  }



% 用户个人信息

% 信息变量
\clist_map_inline:nn
  {
    title, date, author, supervisor, department, major, student_id, degree_type, research_area
  }
  { \tl_new:c { l__ccnu_info_ #1 _tl } }
\clist_map_inline:nn
  { title, department, major, degree_type, author, supervisor_name, supervisor_academic_title, date, research_area}
  { \tl_new:c { l__ccnu_info_ #1 _en_tl } }

% 关键词
\clist_new:N \l__ccnu_info_keywords_clist
\clist_new:N \l__ccnu_info_keywords_en_clist

% 信息接口
\keys_define:nn { ccnu / info }
  {
    cover-type  .choice:,
    cover-type / word .code:n = 
      {
        \bool_gset_true:N \g__ccnu_cover_word_version_bool
        \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
          {
            \dim_gset:Nn \g__ccnu_title_single_line_max_width_dim
              { 0.6 \textwidth }
            \dim_gset:Nn \g__ccnu_title_multiline_max_width_dim
              { 0.6 \textwidth }
          }
          {
            \dim_set:Nn \g__ccnu_title_single_line_max_width_dim
              { 0.8 \textwidth }
            \dim_set:Nn \g__ccnu_title_multiline_max_width_dim
              { 0.9 \textwidth }
          }
      },
    cover-type / math .code:n = 
      {
        \bool_gset_false:N \g__ccnu_cover_word_version_bool
        \dim_set:Nn \g__ccnu_title_single_line_max_width_dim
          { 0.8 \textwidth }
        \dim_set:Nn \g__ccnu_title_multiline_max_width_dim
          { 0.9 \textwidth }
      },
    title       .tl_set:N    = \l__ccnu_info_title_tl,
    title*      .tl_set:N    = \l__ccnu_info_title_en_tl,
    year        .int_set:N   = \l__ccnu_info_year_int,
    month       .int_set:N   = \l__ccnu_info_month_int,
    level       .tl_set:N    = \l__ccnu_info_level_tl,
    author      .tl_set:N    = \l__ccnu_info_author_tl,
    author*      .tl_set:N    = \l__ccnu_info_author_en_tl,
    supervisor  .tl_set:N    = \l__ccnu_info_supervisor_tl,
    supervisor*-name  .tl_set:N    = \l__ccnu_info_supervisor_name_en_tl,
    supervisor*-academic-title  .tl_set:N   = \l__ccnu_info_supervisor_academic_title_name_en_tl,
    department  .tl_set:N    = \l__ccnu_info_department_tl,
    department*  .tl_set:N    = \l__ccnu_info_department_en_tl,
    major       .tl_set:N    = \l__ccnu_info_major_tl,
    major*       .tl_set:N    = \l__ccnu_info_major_en_tl,
    degree-type    .tl_set:N    = \l__ccnu_info_degree_type_tl,
    degree-type*    .tl_set:N    = \l__ccnu_info_degree_type_en_tl,
    research-area    .tl_set:N    = \l__ccnu_info_research_area_tl,
    research-area*    .tl_set:N    = \l__ccnu_info_research_area_en_tl,
    student-id  .tl_set:N    = \l__ccnu_info_student_id_tl,
    keywords    .clist_set:N = \l__ccnu_info_keywords_clist,
    keywords*   .clist_set:N = \l__ccnu_info_keywords_en_clist,
  }

\keys_set:nn { ccnu / info }
  {
    cover-type = math,
    title = { 华中师范大学学位论文 \LaTeX{} 模版 },
    title* = { CCNU thesis \LaTeX{} template }, 
    author = {你的姓名},
    author* = {Xing Ming},
    supervisor = {教师姓名 \quad 职称},
    supervisor*-name = {Jiao shi},
    supervisor*-academic-title = {Professor},
    level = {2018级},
    student-id = {学号},
    department = {数学与统计学学院},
    department* = {School of Mathematics and Statistics},
    major = {应用统计},
    major* = {Mathematics},
    research-area = {教育大数据},
    research-area* = {Education big data},
    degree-type = {应用统计硕士},
    degree-type* = {M.S.},
    keywords = 
      {
        关键词1,
        关键词2,
        关键词3
      },
    keywords* = 
      {
        keyword1,
        keyword2,
        keyword3
      },
    year  = { \int_use:N \c_sys_year_int },
    month = { \int_use:N \c_sys_month_int }
  }

% 标题下划线是否恒定长度
\bool_new:N \g__ccnu_title_line_type_constant_bool

\keys_define:nn { ccnu / info }
  {
    title-line-type .choice:,
    title-line-type / constant .code:n = 
      { \bool_gset_true:N \g__ccnu_title_line_type_constant_bool },
    title-line-type / variable .code:n = 
      { \bool_gset_false:N \g__ccnu_title_line_type_constant_bool },
    title-line-type .initial:n = constant
  }


% 处理封面


% 慕子标题的下划线 LaTeX3 重写版本


\dim_set:Nn \l__ccnu_title_left_right_extra_width_dim
  { .8em }
\dim_set:Nn \l__ccnu_title_sep_width { 1.5em }

\cs_set_eq:NN \__ccnu_set_to_totalheight:Nn \settototalheight
\cs_set_eq:NN \__ccnu_set_to_width:Nn \settowidth
% 下划线
\cs_new:Npn \__ccnu_title_underline_single:
  {
    \rule [ -.3em ]
      {
        \g__ccnu_title_single_line_max_width_dim
        + 2 \l__ccnu_title_left_right_extra_width_dim
      }
      { 1pt }
  }
\cs_new:Npn \__ccnu_title_underline_multiline:
  {
    \rule [ -.3em ]
      {
        \g__ccnu_title_multiline_max_width_dim
        + 2 \l__ccnu_title_left_right_extra_width_dim
      }
      { 1pt }
  }
% 标题盒子
\cs_new:Npn \__ccnu_title_box_aux:n #1
  {
    \parbox [t] { \l__ccnu_title_tmp_max_width_dim } {#1}
  }
\cs_new:Npn \__ccnu_title_box:n #1
  {
    \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \g__ccnu_title_single_line_max_width_dim
    % 储存标题盒子的高度
    \__ccnu_set_to_totalheight:Nn \l__ccnu_title_tmp_height_dim 
      { \__ccnu_title_box_aux:n {#1} }
    % 根据高度判断下划线情况
    \dim_compare:nNnTF
      { \l__ccnu_title_tmp_height_dim } = { 0pt }
      { \__ccnu_title_underline_single: }
      {
        \mode_leave_vertical:
        \dim_compare:nNnTF 
          { \l__ccnu_title_tmp_height_dim } > { \normalbaselineskip }
          {
            % 如果超过了 \normalbaselineskip 说明是多行
            % 重新设置最长的宽度为开始设置的「多行的 max 宽度」
            \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \g__ccnu_title_multiline_max_width_dim
            \__ccnu_set_to_totalheight:Nn \l__ccnu_title_tmp_height_dim 
              { \__ccnu_title_box_aux:n {#1} }
            % 一行一行排版
            \rlap
              {
                \smash
                  {
                    \__ccnu_title_box_aux:n
                      {
                        \dim_while_do:nNnn { \l__ccnu_title_tmp_height_dim } > { 0pt }
                          {
                            \mode_leave_vertical:
                            \rlap { \__ccnu_title_underline_multiline: }\\
                            \dim_sub:Nn \l__ccnu_title_tmp_height_dim { \normalbaselineskip }
                            % 手动居中下划线
                          }
                      }
                  }
              }
            \hspace
              {
                  \l__ccnu_title_left_right_extra_width_dim
                % + .5 \g__ccnu_title_single_line_max_width_dim
                % - .5 \g__ccnu_title_multiline_max_width_dim
              }
            % 排版文本
            \parbox [t] 
              { \l__ccnu_title_tmp_max_width_dim }
              { \linespread{1.6}\selectfont \centering #1 }
          }
          {
            % 排版一行
            \__ccnu_set_to_width:Nn \l__ccnu_title_tmp_width_dim {#1}
            \dim_compare:nNnTF { \l__ccnu_title_tmp_width_dim } < { 5em }
              {
                \rlap
                  {
                    \hspace { \l__ccnu_title_tmp_width_dim / 4 }
                    \rule [ -.3em ]
                      {
                        15em
                        + 4 \l__ccnu_title_left_right_extra_width_dim
                      }
                      { 1pt }
                  }
                \hspace
                  { 
                    - \l__ccnu_title_tmp_width_dim / 4
                    + 3 \l__ccnu_title_left_right_extra_width_dim 
                  }
              }
              {
                \rlap { \__ccnu_title_underline_single: }
                \hspace
                  { 
                    % - \l__ccnu_title_tmp_width_dim / 4
                    + \l__ccnu_title_left_right_extra_width_dim 
                  }
              }
            \__ccnu_title_box_aux:n { \centering #1 }
          }
      }
  }

\cs_new:Npn \__ccnu_title_box_master_doctor:n #1
  {
    \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \g__ccnu_title_single_line_max_width_dim
    % 储存标题盒子的高度
    \__ccnu_set_to_totalheight:Nn \l__ccnu_title_tmp_height_dim 
      { \__ccnu_title_box_aux:n {#1} }
    % 根据高度判断下划线情况
    \dim_compare:nNnTF
      { \l__ccnu_title_tmp_height_dim } = { 0pt }
      { \__ccnu_title_underline_single: }
      {
        \mode_leave_vertical:
        \dim_compare:nNnTF 
          { \l__ccnu_title_tmp_height_dim } > { \normalbaselineskip }
          {
            % 如果超过了 \normalbaselineskip 说明是多行
            % 重新设置最长的宽度为开始设置的「多行的 max 宽度」
            \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \g__ccnu_title_multiline_max_width_dim
            \__ccnu_set_to_totalheight:Nn \l__ccnu_title_tmp_height_dim 
              { \__ccnu_title_box_aux:n {#1} }
            % 一行一行排版
            \rlap
              {
                \smash
                  {
                    \__ccnu_title_box_aux:n
                      {
                        \dim_while_do:nNnn { \l__ccnu_title_tmp_height_dim } > { 0pt }
                          {
                            \mode_leave_vertical:
                            \rlap { \__ccnu_title_underline_multiline: }\\
                            \dim_sub:Nn \l__ccnu_title_tmp_height_dim { \normalbaselineskip }
                            % 手动居中下划线
                          }
                      }
                  }
              }
            \hspace
              {
                  \l__ccnu_title_left_right_extra_width_dim
                % + .5 \g__ccnu_title_single_line_max_width_dim
                % - .5 \g__ccnu_title_multiline_max_width_dim
              }
            % 排版文本
            \parbox [t] 
              { \l__ccnu_title_tmp_max_width_dim }
              { \centering #1 }
          }
          {
            % 排版一行
            \__ccnu_set_to_width:Nn \l__ccnu_title_tmp_width_dim {#1}
            \dim_compare:nNnTF { \l__ccnu_title_tmp_width_dim } < { 5em }
              {
                \rlap
                  {
                    \hspace { \l__ccnu_title_tmp_width_dim / 4 }
                    \rule [ -.3em ]
                      {
                        15em
                        + 4 \l__ccnu_title_left_right_extra_width_dim
                      }
                      { 1pt }
                  }
                \hspace
                  { 
                    - \l__ccnu_title_tmp_width_dim / 4
                    + 3 \l__ccnu_title_left_right_extra_width_dim 
                  }
              }
              {
                \rlap { \__ccnu_title_underline_single: }
                \hspace
                  { 
                    % - \l__ccnu_title_tmp_width_dim / 4
                    + \l__ccnu_title_left_right_extra_width_dim 
                  }
              }
            \__ccnu_title_box_aux:n { \centering #1 }
          }
      }
  }
\cs_new:Npn \__ccnu_get_text_width:Nn #1#2
  {
    \hbox_set:Nn \l__ccnu_tmpa_box {#2}
    \dim_set:Nn #1 { \box_wd:N \l__ccnu_tmpa_box }
  }
\cs_generate_variant:Nn \__ccnu_get_text_width:Nn { NV }
\cs_new:Npn \__ccnu_get_max_text_width:NN #1#2
  {
    \group_begin:
      \clist_set_eq:NN \l__ccnu_tmpa_clist #2
      \bool_until_do:nn { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
        {
          \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
          \__ccnu_get_text_width:NV \l__ccnu_tmpa_dim \l__ccnu_tmpa_tl
          \dim_gset:Nn #1 { \dim_max:nn {#1} { \l__ccnu_tmpa_dim } }
        }
    \group_end:
  }
\cs_new:Npn \__ccnu_get_text_width_master_doctor:Nn #1#2
  {
    \hbox_set:Nn \l__ccnu_tmpa_box { \zihao{2} #2 }
    \dim_set:Nn #1 { \box_wd:N \l__ccnu_tmpa_box }
  }
\cs_generate_variant:Nn \__ccnu_get_text_width_master_doctor:Nn { NV }
\cs_new:Npn \__ccnu_get_max_text_width_master_doctor:NN #1#2
  {
    \group_begin:
      \clist_set_eq:NN \l__ccnu_tmpa_clist #2
      \bool_until_do:nn { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
        {
          \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
          \__ccnu_get_text_width_master_doctor:NV \l__ccnu_tmpa_dim \l__ccnu_tmpa_tl
          \dim_gset:Nn #1 { \dim_max:nn {#1} { \l__ccnu_tmpa_dim } }
        }
    \group_end:
  }


% 封面
\cs_new_protected:Npn \__ccnu_cover_bachelor:
  {
    \begin{tikzpicture} [ remember~picture, overlay ]
      % 顶部的四项
      \__ccnu_cover_bachelor_topmatter:
      % logo
      \__ccnu_cover_bachelor_logo:
      % 论文类型
      \__ccnu_cover_bachelor_degree_type:
      % 标题
      \__ccnu_cover_bachelor_title:
      % 个人信息
      \__ccnu_cover_bachelor_infomation:
      % 时间
      \__ccnu_cover_bachelor_time:
    \end{tikzpicture}
  }

% 硕博封面
\cs_new_protected:Npn \__ccnu_cover_i_master_doctor:
  {
    \begin{tikzpicture} [ remember~picture, overlay ]
      % 顶部的四项
      \__ccnu_cover_i_master_doctor_topmatter:
      % logo
      \__ccnu_cover_i_master_doctor_logo:
      % 论文类型
      \__ccnu_cover_i_master_doctor_degree_type:
      % 标题
      \__ccnu_cover_i_master_doctor_title:
      % 个人信息
      \__ccnu_cover_i_master_doctor_infomation:
    \end{tikzpicture}
  }

% 硕博中文扉页
\cs_new_protected:Npn \__ccnu_cover_ii_master_doctor:
  {
    \begin{tikzpicture} [ remember~picture, overlay ]
      % 论文类型
      \__ccnu_cover_ii_master_doctor_degree_type:
      % 标题
      \__ccnu_cover_ii_master_doctor_title:
      % 个人信息
      \__ccnu_cover_ii_master_doctor_infomation:
      % 学院
      \__ccnu_cover_ii_master_doctor_department:
      % 时间
      \__ccnu_cover_ii_master_doctor_time:
    \end{tikzpicture}
  }

% 硕博英文扉页
\cs_new_protected:Npn \__ccnu_cover_iii_master_doctor:
  {
    \begin{tikzpicture} [ remember~picture, overlay ]
      % 标题
      \__ccnu_cover_iii_master_doctor_title:
      % 学位申请
      \__ccnu_cover_iii_master_doctor_degree_application:
      % 个人信息
      \__ccnu_cover_iii_master_doctor_author_infomation:
      % 学院信息
      \__ccnu_cover_iii_master_doctor_department_infomation:
      % 导师信息
      \__ccnu_cover_iii_master_doctor_supervisor_infomation:
      % 签名
      \__ccnu_cover_iii_master_doctor_signature:
      % 时间
      \__ccnu_cover_iii_master_doctor_time:
    \end{tikzpicture}
  }

% 封面顶部的四项
\cs_new:Npn \__ccnu_cover_bachelor_topmatter:
  {
    \node [ anchor = north ] ( top ) at 
      ( [ shift = { (1.5em, 0em) } ] current~page~text~area.north ) 
      {
          \begin{tblr}
            {
              row{2} = {abovesep += 0.5em},
              column{1} = { 0.5\textwidth, l},
              column{2} = { 0.5\textwidth, l},
            }
            \textbf{\zihao{-3} 分类号 \underline{\hspace*{8em}}} 
              & \textbf{\zihao{-3} 论文选题类型 \underline{\hspace*{6em}}} \\
            \textbf{\zihao{-3} U\,\,D\,\,C \underline{\hspace*{8em}} } 
              & \textbf{\zihao{-3} 编号 \underline{\hspace*{10em}}}
          \end{tblr}
      };
  }

% logo
\cs_new:Npn \__ccnu_cover_bachelor_logo:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \dim_set:Nn \l__ccnu_tmpa_dim { -0.25\paperheight }
      }
      {
        \dim_set:Nn \l__ccnu_tmpa_dim { -0.29\paperheight }
      }
    \bool_if:NF \g__ccnu_blind_version_bool
      {
        \node ( logo ) at 
          (
            [ shift = { ( 0em , \l__ccnu_tmpa_dim ) } ]
              current~page.north
          )
          {
            \includegraphics
              [ height = 3.5em, width = 0.4\textwidth ]
              { ccnulogo.png } 
          };
      }
  }

% 论文类型
\cs_new:Npn \__ccnu_cover_bachelor_degree_type:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \node ( type ) at 
          (
            [ shift = { (0em , - 0.36\paperheight) } ] 
              current~page.north
          )
          { \zihao{-0} \sffamily 本科毕业论文（设计）};
      }
      {
        \node ( type ) at 
          (
            [ shift = { (0em , - 0.39\paperheight) } ] 
              current~page.north
          )
          { \zihao{-1} \sffamily 本科毕业论文（设计）};
      }
  }



% 标题
\cs_new:Npn \__ccnu_cover_bachelor_title:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \node[] ( titlelabel ) at
          (
            [ shift = { ( -4.5cm, 0em ) } ] current~page.center
          ) 
          {
            \zihao{-1} \bfseries
            题 \hspace*{0.6em} 目
          };
        \node[] ( titlecontent ) at 
          (
            [ shift = { ( 2.5cm, -1.2em ) } ] current~page.center
          ) 
          {
            \zihao{-2} \bfseries
            \bool_if:NTF \g__ccnu_title_line_type_constant_bool
              {
                % 下划线恒定长度
                \__ccnu_title_box:n { \tl_use:N \l__ccnu_info_title_tl }
              }
              {
                % 文字下方才有下划线
                \begin{minipage}{16em}
                  \begin{center}
                    \CJKunderline*{ \tl_use:N \l__ccnu_info_title_tl }
                  \end{center}
                \end{minipage}
              }
          };
      }
      {
        \node[] ( titlecontent ) at 
          (
            [ shift = { ( 0, -1.5em ) } ] current~page.center
          ) 
          {
            \zihao{-2} \bfseries
            \bool_if:NTF \g__ccnu_title_line_type_constant_bool
              {
                % 下划线恒定长度
                \__ccnu_title_box:n { \tl_use:N \l__ccnu_info_title_tl }
              }
              {
                % 文字下方才有下划线
                \begin{minipage}{20em}
                  \begin{center}
                    \CJKunderline*{\tl_use:N \l__ccnu_info_title_tl}
                    % \tl_use:N \l__ccnu_info_title_tl
                  \end{center}
                \end{minipage}
              }
          };
      }
  }


% 个人信息
\cs_new:Npn \__ccnu_cover_bachelor_infomation:
  {
    \node[] (information) at
        (
          [shift = {(0, -0.27\textheight)}]
          current~page.center
        )
        {
          \begin{minipage} [ c ] { \textwidth }
            \centering \zihao {-3}  \bfseries
            \clist_set:Nx \l__ccnu_tmpa_clist
              {
                \c__ccnu_name_department_tl,
                \c__ccnu_name_major_tl,
                \c__ccnu_name_level_tl,
                \c__ccnu_name_author_tl,
                \c__ccnu_name_student_id_tl,
                \c__ccnu_name_supervisor_tl,
              }
            \clist_set:Nx \l__ccnu_tmpb_clist
              {
                \l__ccnu_info_department_tl ,
                \l__ccnu_info_major_tl      ,
                \l__ccnu_info_level_tl      ,
                \l__ccnu_info_author_tl     ,
                \l__ccnu_info_student_id_tl ,
                \l__ccnu_info_supervisor_tl ,
              }
            % 获得个人信息的内容最大宽度
            \__ccnu_get_max_text_width:NN 
              \l__ccnu_tmpb_dim \l__ccnu_tmpb_clist
            \bool_until_do:nn
              { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
              {
                \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
                \clist_pop:NN \l__ccnu_tmpb_clist \l__ccnu_tmpb_tl
                \__ccnu_cover_infomation_spread_box:nn
                  { 4em }
                  { \l__ccnu_tmpa_tl }
                \hspace*{1em}
                \__ccnu_cover_infomation_center_underline_box:Vn 
                  \l__ccnu_tmpb_dim 
                  { \l__ccnu_tmpb_tl }
                \skip_vertical:n { 1.3 ex }
              }
          \end{minipage}
        };
  }


% 封面顶部的四项
\cs_new:Npn \__ccnu_cover_i_master_doctor_topmatter:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \node [ anchor = north ] ( top ) at 
          ( 
            [ shift = { (0em, 3em) } ] 
            current~page~text~area.north 
          ) 
          {
            \begin{tblr}
              {
                % hlines,vlines,
                width = \textwidth,
                row{2} = {abovesep += 0.5em},
                colspec = {X[1,c]X[1,c]X[1,c]}
              }
              \textbf{\zihao{-4} 分类号 \underline{\hspace*{3em}}}
                & &\textbf{\zihao{-4} 密级 \underline{\hspace*{3em}}} \\
              \textbf{\zihao{-4} U\,\,D\,\,C \underline{\hspace*{3em}} } 
                & &\textbf{\zihao{-4} 编号 \underline{\hspace*{3em}}}
            \end{tblr}
          };
      }
      {
        \node [ anchor = north ] ( top ) at 
          ( 
            [ shift = { (0em, 3em) } ] 
            current~page~text~area.north 
          ) 
          {
            \begin{tblr}
              {
                % hlines,vlines,
                width = \textwidth,
                row{2} = {abovesep += 0.5em},
                colspec = {X[1,c]X[1,c]X[1,c]}
              }
              \textbf{\zihao{-4} 分类号 \underline{\hspace*{3em}}}
                & &\textbf{\zihao{-4} 密级 \underline{\hspace*{3em}}} \\
              \textbf{\zihao{-4} U\,\,D\,\,C \underline{\hspace*{3em}} } 
                & &\textbf{\zihao{-4} 编号 \underline{\hspace*{3em}}}
            \end{tblr}
          };
      }
  }

% logo
\cs_new:Npn \__ccnu_cover_i_master_doctor_logo:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \dim_set:Nn \l__ccnu_tmpa_dim 
          { -0.25\paperheight }
      }
      {
        \dim_set:Nn \l__ccnu_tmpa_dim 
          { -0.25\paperheight }
      }
    \bool_if:NF \g__ccnu_blind_version_bool
      {
        \node ( logo ) at 
          (
            [ shift = { ( 0em , \l__ccnu_tmpa_dim ) } ]
              current~page.north
          )
          {
            \includegraphics
              [ height = 3.5em, width = 0.4\textwidth ]
              { logo / ccnulogo.png } 
          };
      }
    
  }

% 论文类型
\dim_const:Nn \c__ccnu_cover_i_master_doctor_type_sep_dim { 2em }

\cs_new:Npn \__ccnu_cover_i_master_doctor_degree_type:
  {
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \dim_set:Nn \l__ccnu_tmpa_dim 
          { -0.35\paperheight }
      }
      {
        \dim_set:Nn \l__ccnu_tmpa_dim 
          { -0.35\paperheight }
      }
    \int_case:nn { \g__ccnu_thesis_type_int }
      {
        {2} 
        {
          \node ( type ) at 
            (
              [ shift = { (0em , \l__ccnu_tmpa_dim) } ] 
                current~page.north
            )
            {
              \scalebox{1}[1.7]
                {
                  \zihao{1}
                  \normalfont \bfseries 
                  \tl_map_inline:nn { 硕士学位论文 }
                    {
                      ##1 \hspace{ \c__ccnu_cover_i_master_doctor_type_sep_dim }
                    } \unskip
                  % 硕 \hspace*{0.5em} 士 \hspace*{0.5em} 学 \hspace*{0.5em} 位 \hspace*{0.5em} 论 \hspace*{0.5em} 文
                }
            };
        }
        {1}
        {
          \node ( type ) at 
            (
              [ shift = { (0em , \l__ccnu_tmpa_dim) } ] 
                current~page.north
            )
            {
              \scalebox{1}[1.7]
                {
                  \zihao{1}
                  \normalfont \bfseries 
                  \tl_map_inline:nn { 博士学位论文 }
                    {
                      ##1 \hspace{ \c__ccnu_cover_i_master_doctor_type_sep_dim }
                    } \unskip
                  % \zihao{1} \normalfont \bfseries 
                  % 博 \hspace*{0.5em} 士 \hspace*{0.5em} 学 \hspace*{0.5em} 位 \hspace*{0.5em} 论 \hspace*{0.5em} 文
                }
            };
        }
      }
  }



% 标题
\cs_new:Npn \__ccnu_cover_i_master_doctor_title:
  {
    \group_begin:
    \keys_set:nn { ctex }
      { punct = quanjiao }
    \bool_if:NTF \g__ccnu_cover_word_version_bool
      {
        \node[] ( titlecontent ) at 
          (
            [ shift = { ( 0cm, -2em ) } ] current~page.center
          ) 
          {
            \linespread{1} \fontsize{26pt}{40bp} \selectfont \bfseries \ccnutitlefont
            \bool_if:NTF \g__ccnu_title_line_type_constant_bool
              {
                % 下划线恒定长度
                \__ccnu_title_box_master_doctor:n 
                  { 
                    % \fontsize{30bp}{28pt} \selectfont
                    题目：\tl_use:N \l__ccnu_info_title_tl 
                  }
              }
              {
                % 文字下方才有下划线
                \begin{minipage}{16em}
                  \begin{center}
                    \CJKunderline*{ \tl_use:N \l__ccnu_info_title_tl }
                  \end{center}
                \end{minipage}
              }
          };
      }
      {
        \node[] ( titlecontent ) at 
          (
            [ shift = { ( 0, -1em ) } ] current~page.center
          ) 
          {
            \bfseries \sffamily
            \linespread{1} \fontsize{26pt}{40bp} \selectfont 
            % \__ccnu_title_box_master_doctor:n 
            %   { \sffamily \tl_use:N \l__ccnu_info_title_tl }
            \bool_if:NTF \g__ccnu_title_line_type_constant_bool
              {
                % 下划线恒定长度
                \__ccnu_title_box_master_doctor:n 
                  { 
                    \tl_use:N \l__ccnu_info_title_tl
                  }
              }
              {
                % 文字下方才有下划线
                \begin{minipage}{16em}
                  \begin{center}
                    \CJKunderline*{ \tl_use:N \l__ccnu_info_title_tl }
                  \end{center}
                \end{minipage}
              }
          };
      }
    \group_end:
  }


% 个人信息
\cs_new:Npn \__ccnu_cover_i_master_doctor_infomation:
  {
    \node[anchor = south] (information) at
        (
          [shift = {(0, 0.08\textheight)}]
          current~page~text~area.south
        )
        {
          % \tl_set:Nx \l__ccnu_tmpa_tl { \hphantom{\l__ccnu_info_author_tl} }
          % \tl_set:Nx \l__ccnu_tmpb_tl { \hphantom{\l__ccnu_info_supervisor_tl} }
          \bool_if:NT \g__ccnu_blind_version_bool
            {
              \tl_set:Nn \l__ccnu_info_author_tl {\mbox{}}
              \tl_set:Nn \l__ccnu_info_supervisor_tl {\mbox{}}
            }
          \begin{minipage} [ c ] { \textwidth }
            \centering \zihao {3}  \bfseries
            \clist_set:Nx \l__ccnu_tmpa_clist
              {
                学位申请人姓名,
                申请学位学生类别,
                申请学位学科专业,
                指导教师姓名,
              }
            \clist_set:Nx \l__ccnu_tmpb_clist
              {
                \l__ccnu_info_author_tl     ,
                \l__ccnu_info_degree_type_tl ,
                \l__ccnu_info_major_tl      ,
                \l__ccnu_info_supervisor_tl      ,
              }
            % 获得个人信息的内容最大宽度
            \__ccnu_get_max_text_width_master_doctor:NN 
              \l__ccnu_tmpb_dim \l__ccnu_tmpb_clist
            \bool_until_do:nn
              { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
              {
                \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
                \clist_pop:NN \l__ccnu_tmpb_clist \l__ccnu_tmpb_tl
                \__ccnu_cover_infomation_spread_box_master_doctor:nn
                  { 9em }
                  { \l__ccnu_tmpa_tl }
                \hspace*{2pt}
                \bool_if:NTF \g__ccnu_cover_word_version_bool
                  {
                    \__ccnu_cover_infomation_center_underline_box:Vn 
                      \l__ccnu_tmpb_dim 
                      { \zihao{2} \ccnutitlefont \l__ccnu_tmpb_tl }
                  }
                  {
                    \__ccnu_cover_infomation_center_underline_box:Vn 
                      \l__ccnu_tmpb_dim 
                      { \l__ccnu_tmpb_tl }
                  }
                \skip_vertical:n { 2 ex }
              }
              \unskip
          \end{minipage}
        };
  }

% 论文类型
\cs_new:Npn \__ccnu_cover_ii_master_doctor_degree_type:
  {
    \bool_if:NTF \g__ccnu_head_scope_all_bool
      {
        \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
          {
            \node [ anchor = north ] at 
              ( [ shift = { (0em, -3em) } ] current~page~text~area.north ) 
              { \zihao{1} \sffamily \bfseries 硕士学位论文 };
          }
          {
            \node [ anchor = north ] at 
              ( [ shift = { (0em, -5em) } ] current~page~text~area.north ) 
              { \zihao{1} \sffamily \bfseries 博士学位论文 };
          }
      }
      {
        \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
          {
            \node [ anchor = north ] at 
              ( [ shift = { (0em, -1em) } ] current~page~text~area.north ) 
              { \zihao{1} \sffamily \bfseries 硕士学位论文 };
          }
          {
            \node [ anchor = north ] at 
              ( [ shift = { (0em, -1em) } ] current~page~text~area.north ) 
              { \zihao{1} \sffamily \bfseries 博士学位论文 };
          }
      }
  }
% 标题
\cs_new:Npn \__ccnu_cover_ii_master_doctor_title:
  {
    \bool_if:NTF \g__ccnu_head_scope_all_bool
      {
        \node at ([ shift = { (0em, 0.15\paperheight) } ]current~page~text~area.center)
          {
            \linespread{1} \fontsize{22pt}{35bp}
            \sffamily \bfseries 
            \parbox [c] { \textwidth }
              {
                \centering
                论文题目：\parbox[t]{15em}{ \l__ccnu_info_title_tl }
              }
          };
      }
      {
        \node at ([ shift = { (0em, 0.18\paperheight) } ]current~page~text~area.center)
          {
            \linespread{1} \fontsize{22pt}{35bp}
            \sffamily \bfseries 
            \parbox [c] { \textwidth }
              {
                \centering
                论文题目：\parbox[t]{15em}{ \l__ccnu_info_title_tl }
              }
          };
      }
    
  }
% 个人信息
\cs_new:Npn \__ccnu_cover_ii_master_doctor_infomation:
  {
    \node [] at ([ shift = { (3em, -5em) } ]current~page~text~area.center)
      {
        \bool_if:NT \g__ccnu_blind_version_bool
          {
            \tl_set:Nn \l__ccnu_info_author_tl {\mbox{}}
            \tl_set:Nn \l__ccnu_info_supervisor_tl {\mbox{}}
          }
        \begin{minipage} [ c ] { \textwidth }
          \centering \zihao {-2} \sffamily \bfseries
          \clist_set:Nx \l__ccnu_tmpa_clist
            {
              论文作者,
              指导教师,
              学科专业,
              研究方向,
            }
          \clist_set:Nx \l__ccnu_tmpb_clist
            {
              \l__ccnu_info_author_tl     ,
              \l__ccnu_info_supervisor_tl      ,
              \l__ccnu_info_major_tl      ,
              \l__ccnu_info_research_area_tl ,
            }
          % 获得个人信息的内容最大宽度
          \__ccnu_get_max_text_width_master_doctor:NN 
            \l__ccnu_tmpb_dim \l__ccnu_tmpb_clist
          \bool_until_do:nn
            { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
            {
              \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
              \clist_pop:NN \l__ccnu_tmpb_clist \l__ccnu_tmpb_tl
              \__ccnu_cover_infomation_spread_box_master_doctor:nn
                { 4em }
                { \l__ccnu_tmpa_tl }
              \hspace*{15pt}
              \__ccnu_cover_infomation_center_nounderline_box:Vn 
                \l__ccnu_tmpb_dim 
                { \normalfont \l__ccnu_tmpb_tl }
              \skip_vertical:n { 0.3 ex }
            }
        \end{minipage}
      };
  }

% 学院
\cs_new:Npn \__ccnu_cover_ii_master_doctor_department:
  {
    \bool_if:NF \g__ccnu_blind_version_bool
      {
        \node [anchor = south] (department) at
          (
            [ shift = { (0em, 4em) } ]
            current~page~text~area.south
          )
          {
            \sffamily \bfseries \zihao{-2}
            华中师范大学 \l__ccnu_info_department_tl
          };
      }
    
  }
% 时间
\cs_new:Npn \__ccnu_cover_ii_master_doctor_time:
  {
    \node [anchor = south]  at
      (
        [ shift = { (0em, 1em) } ]
        current~page~text~area.south
      )
      {
        \bfseries \zihao{-2}
        \int_use:N \l__ccnu_info_year_int
        \textsf{年}
        \int_use:N \l__ccnu_info_month_int
        \textsf{月}
      };
  }

% 标题
\cs_new:Npn \__ccnu_cover_iii_master_doctor_title:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \bool_if:NTF \g__ccnu_head_scope_all_bool
          {
            \node [anchor = north] (title) at
              (
                [ shift = { (0em, -4em) } ]
                current~page~text~area.north
              )
              {
                \parbox { \textwidth }
                  {
                    \bfseries \centering
                    \fontsize{30bp}{35pt}\selectfont
                    \l__ccnu_info_title_en_tl
                  }
              };
          }
          {
            \node [anchor = north] (title) at
              (
                [ shift = { (0em, -2em) } ]
                current~page~text~area.north
              )
              {
                \parbox { \textwidth }
                  {
                    \bfseries \centering
                    \fontsize{30bp}{35pt}\selectfont
                    \l__ccnu_info_title_en_tl
                  }
              };
          }
      }
      {
        \bool_if:NTF \g__ccnu_head_scope_all_bool
          {
            \node [anchor = north] (dissertation) at
              (
                [ shift = { (0em, -4em) } ]
                current~page~text~area.north
              )
              {
                \bfseries \zihao{-0}
                Dissertation
              };
            \node [anchor = north] (title) at
              (
                [ shift = { (0em, -0.1\paperheight) } ]
                dissertation.north
              )
              {
                \parbox { \textwidth }
                  {
                    \bfseries \centering
                    \fontsize{30bp}{35pt}\selectfont
                    \l__ccnu_info_title_en_tl
                  }
              };
          }
          {
            \node [anchor = north] (dissertation) at
              (
                [ shift = { (0em, -2em) } ]
                current~page~text~area.north
              )
              {
                \bfseries \zihao{-0}
                Dissertation
              };
            \node [anchor = north] (title) at
              (
                [ shift = { (0em, -0.1\paperheight) } ]
                dissertation.north
              )
              {
                \parbox { \textwidth }
                  {
                    \bfseries \centering
                    \fontsize{30bp}{35pt}\selectfont
                    \l__ccnu_info_title_en_tl
                  }
              };
          }
        
      }
  }
% 学位申请
\cs_new:Npn \__ccnu_cover_iii_master_doctor_degree_application:
  {
    \int_compare:nNnT { \g__ccnu_thesis_type_int } = {2}
      {
        \node [anchor = north] (application)
          at ([shift = {(0em, -4em)}]title.south)
          {
            \parbox { \textwidth }
              {
                \centering \zihao{3} \itshape
                A~Thesis \\
                \group_begin:
                  \normalfont
                  Submitted~in~Partial~Fulfillment~of~the~Requirement \\
                \group_end:
                For~the~\l__ccnu_info_degree_type_en_tl \c_space_tl Degree~in~\l__ccnu_info_major_en_tl
              }
          };
      }
  }
% 个人信息
\cs_new:Npn \__ccnu_cover_iii_master_doctor_author_infomation:
  {
    \bool_if:NT \g__ccnu_blind_version_bool
      {
        \tl_set:Nn \l__ccnu_info_author_en_tl {\mbox{}}
        \tl_set:Nn \l__ccnu_info_supervisor_name_en_tl {\mbox{}}
        \tl_set:Nn \l__ccnu_info_supervisor_academic_title_name_en_tl {\mbox{}}
      }
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \node [anchor = north] (author_infomation)  
          at ([shift = {(0em, -4em)}]application.south)
          {
            \parbox { \textwidth }
              {
                \centering \zihao{3} \bfseries
                By \\
                \l__ccnu_info_author_en_tl \\
                Postgraduate~Program \\
                \bool_if:NF \g__ccnu_blind_version_bool
                  {
                    \l__ccnu_info_department_en_tl \\
                    Central~China~Normal~University
                  }
                
              }
          };
      }
      {
        \node [anchor = north] 
          at ([shift = {(0em, -5em)}]title.south)
          {
            \parbox { \textwidth }
              {
                \centering \zihao{3} \bfseries
                By \\
                \l__ccnu_info_author_en_tl \\
                Supervisor:~\l__ccnu_info_supervisor_name_en_tl \\
                Specialty:~\l__ccnu_info_major_en_tl \\
                Research~Area:~\l__ccnu_info_research_area_en_tl
              }
          };
      }
  }
% 学院信息
\cs_new:Npn \__ccnu_cover_iii_master_doctor_department_infomation:
  {
    \int_compare:nNnT { \g__ccnu_thesis_type_int } = {1}
      {
        \bool_if:NF \g__ccnu_blind_version_bool
          {
            \node [anchor = south]  at
              (
                [ shift = { (0em, 0.1\paperheight) } ]
                current~page~text~area.south
              )
              {
                \parbox { \textwidth }
                  {
                    \centering \zihao{3} \bfseries
                    \l__ccnu_info_department_en_tl \\
                    Central~China~Normal~University
                  }
              };
          }
      }
  }
% 导师信息
\cs_new:Npn \__ccnu_cover_iii_master_doctor_supervisor_infomation:
  {
    \int_compare:nNnT { \g__ccnu_thesis_type_int } = {2}
      {
        \node [anchor = north~east] (supervisor_infomation)  
          at ([shift = {(2em, -4em)}]author_infomation.south)
          {
            \parbox { 0.5\textwidth }
              {
                \zihao{4}
                Supervisor:~\l__ccnu_info_supervisor_name_en_tl \\
                Academic~Title:~\l__ccnu_info_supervisor_academic_title_name_en_tl
              }
          };
      }
  }
% 签名
\cs_new:Npn \__ccnu_cover_iii_master_doctor_signature:
  {
    \int_compare:nNnT { \g__ccnu_thesis_type_int } = {2}
      {
        \node [ anchor = north~west ] (signature)  
          at ([shift = {(3em, 4.5ex)}]supervisor_infomation.south~east)
          {
            \zihao{4}
            \begin{tabular}{r}
              Signature \underline{\hspace*{5em}} \\[1.5ex]
              Approved 
            \end{tabular}
          };
      }
  }
% 时间
\cs_new:Npn \__ccnu_cover_iii_master_doctor_time:
  {
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      {
        \node [anchor = north~east] (time)  
          at ([shift = {(-0.4em, -1ex)}]signature.south~east)
          {
            \zihao{4}
            \__ccnu_month_cover_to_english_version:V \l__ccnu_info_month_int
            \space
            \int_use:N \l__ccnu_info_year_int
          };
      }
      {
        \node [anchor = south]  at
          (
            [ shift = { (0em, 0.073\paperheight) } ]
            current~page~text~area.south
          )
          {
            \zihao{3} \bfseries
            \__ccnu_month_cover_to_english_version:V \l__ccnu_info_month_int
            \space
            \int_use:N \l__ccnu_info_year_int
          };
      }
  }

\prop_const_from_keyval:Nn \l__ccnu_month_prop
  {
    1  = Jan.,
    2  = Feb.,
    3  = Mar.,
    4  = Apr.,
    5  = May.,
    6  = Jun.,
    7  = Jul.,
    8  = Aug.,
    9  = Sept.,
    10 = Oct.,
    11 = Nov.,
    12 = Dec.,
  }
\cs_new:Npn \__ccnu_month_cover_to_english_version:n #1
  {
    \prop_get:NnN \l__ccnu_month_prop {#1} \l__ccnu_tmpa_tl
    \l__ccnu_tmpa_tl
  }
\cs_generate_variant:Nn \__ccnu_month_cover_to_english_version:n { V }
\cs_new_protected:Npn \__ccnu_cover_infomation_spread_box:nn #1#2
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \tl_map_inline:xn {#2} { ##1 \hfil } \unskip }
  }
\cs_new_protected:Npn \__ccnu_cover_infomation_spread_box_master_doctor:nn #1#2
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \tl_map_inline:xn {#2} { ##1 \hfil } \unskip ：}
  }
\cs_new_protected:Npn \__ccnu_cover_infomation_center_underline_box:nn #1#2
  {
    \mode_leave_vertical:
    \CJKunderline*
      [
        thickness = 1pt
      ]
      {
        \hbox_to_wd:nn { #1 + 5mm } 
          { 
            \hfil 
              #2
            \hfil
          }
      }
  }
\cs_generate_variant:Nn \__ccnu_cover_infomation_center_underline_box:nn  { Vn }
\cs_new_protected:Npn \__ccnu_cover_infomation_center_nounderline_box:nn #1#2
  {
    \mode_leave_vertical:
    \CJKunderline*
      [
        thickness = 0pt
      ]
      {
        \box_move_up:nn { 0.5pt }
          {
            \hbox_to_wd:nn { #1 }
              { 
                  #2
                \hfil
              }
          }
      }
  }
\cs_generate_variant:Nn \__ccnu_cover_infomation_center_nounderline_box:nn  { Vn }

% 时间
\cs_new:Npn \__ccnu_cover_bachelor_time:
  {
    \node [ anchor = south ] ( date ) at ( current~page~text~area.south ) 
      {
        \zihao{3} \bfseries
        \zhdigits { \int_use:N \l__ccnu_info_year_int}
        \, 年 \,
        \zhnumber { \int_use:N \l__ccnu_info_month_int }
        \, 月
      };
  }


% 输出封面和版权页
\ctex_after_end_preamble:n
  {
    \begin{titlepage}
      \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
        {
          \__ccnu_cover_bachelor:
          \newpage
          \pagestyle { empty }
          % 版权页
          \begin{tikzpicture} [remember~picture, overlay]
            \node at (current~page.center) 
              {
                \includegraphics
                  [ width = \Gm@layoutwidth, height = \Gm@layoutheight ]
                    { Originality_Copyright.pdf }
              };
          \end{tikzpicture}
        }
        {
          \bool_lazy_and:nnTF
            { \bool_if_p:N \g__ccnu_head_scope_all_bool }
            { \bool_if_p:N \g__ccnu_showhead_bool }
            {
              \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
                { \pagestyle { masterplain-head-nopage } }
                { \pagestyle { doctorplain-head-nopage } }
            }
            {
              \pagestyle { empty }
            }
          \__ccnu_cover_i_master_doctor:
          \str_case:VnTF \g__ccnu_type_version_str
            {
              { print-master-twoside } {}
              { print-doctor-twoside } {}
            }
            { \__ccnu_new_blank_page: }
            % {}
            { \newpage }
          \__ccnu_cover_ii_master_doctor:
          \newpage
          \__ccnu_cover_iii_master_doctor:
          \bool_if:NF \g__ccnu_blind_version_bool
            {
              \newpage
              % 版权页
              \begin{tikzpicture} [remember~picture, overlay]
                \node at (current~page.center) 
                  {
                    \includegraphics
                      [ width = \Gm@layoutwidth, height = \Gm@layoutheight ]
                        { Originality_Copyright_master_doctor.pdf }
                  };
              \end{tikzpicture}
            }
          \str_case:VnTF \g__ccnu_type_version_str
            {
              { print-master-twoside } {}
              { print-doctor-twoside } {}
            }
            { \__ccnu_new_blank_page: }
            { \newpage \thispagestyle{empty} }
            % {}
        }
    \end{titlepage}
  }

\cs_new:Npn \__ccnu_new_blank_page:
  {
    \newpage \null \thispagestyle{empty} \newpage
  }


% 目录处理

\cs_new:Npn \__ccnu_tocline_bachelor:
  {
    \keys_set:nn { ctex }
      {
        % 目录深度：到 section
        tocdepth = 1 ,
        % 目录标题
        contentsname   = \c__ccnu_name_toc_tl,
        chapter / tocline =
          {
            \normalfont 
            \CTEXnumberline {##1} ##2
          },
        section / tocline =
          {
            \normalfont
            \CTEXnumberline {##1} ##2
          }
      }
  }
\cs_new:Npn \__ccnu_tocline_master:
  {
    \keys_set:nn { ctex }
      {
        % 目录深度：到 section
        tocdepth = 2 ,
        % 目录标题
        contentsname   = \c__ccnu_name_toc_tl,
      }
  }
\cs_new:Npn \__ccnu_tocline_doctor:
  {
    \keys_set:nn { ctex }
      {
        % 目录深度：到 section
        tocdepth = 2 ,
        % 目录标题
        contentsname   = \c__ccnu_name_toc_tl,
      }
  }
\int_case:nn { \g__ccnu_thesis_type_int }
  {
    {3}{ \__ccnu_tocline_bachelor: }
    {2} { \__ccnu_tocline_master: }
    {1} { \__ccnu_tocline_doctor: }
  }



% 去掉目录的页码
% https://tex.stackexchange.com/questions/38847/clear-tableofcontents-page-in-book-or-report

\AtEndPreamble
  {
    \bool_lazy_and:nnTF
      { \bool_if_p:N \g__ccnu_head_scope_all_bool }
      { \bool_if_p:N \g__ccnu_showhead_bool }
      {
        \int_case:nn { \g__ccnu_thesis_type_int }
          {
            {2}
              {
                \patchcmd { \tableofcontents }
                  { \@starttoc{toc} }
                  {
                    \thispagestyle { plain } 
                    \pagestyle { plain }
                    \@starttoc{toc} 
                  }
                  {}{\fail}
              }
            {1}
              {
                \patchcmd { \tableofcontents }
                  { \@starttoc{toc} }
                  {
                    \thispagestyle { doctorplain-head-nopage } 
                    \pagestyle { doctorplain-head-nopage }
                    \@starttoc{toc} 
                  }
                  {}{\fail}
              }
          }
      }
      {
        \patchcmd { \tableofcontents }
          { \@starttoc{toc} }
          { \thispagestyle{empty} \pagestyle{empty} \@starttoc{toc} }
          {}{}
      }
    \cs_set_eq:NN \t@bleofcontents \tableofcontents
    \RenewDocumentCommand { \tableofcontents } { }
    % \def\tableofcontents
      {
        \newpage
        \group_begin:
          \keys_set:nn { ctex }
            { chapter / indent = 0pt }
          \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
            {
              \keys_set:nn { ctex }
                {
                  chapter = 
                    {
                      format = \zihao{-2} \normalfont \bfseries \centering,
                    }
                }
              \__ccnu_line_spread:n { 1.25 }
            }
            {
              \__ccnu_line_spread:n { 1 }
            }
          \t@bleofcontents
          \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
            {
              \thispagestyle { empty } 
            }
            {
              \bool_lazy_and:nnTF
                { \bool_if_p:N \g__ccnu_head_scope_all_bool }
                { \bool_if_p:N \g__ccnu_showhead_bool }
                { \thispagestyle { plain } }
                { \thispagestyle { empty } }
            }
        \group_end:
        \newpage
      }
  }


% 设置目录样式

% 设置引导线
% 引导线的“点”的样式
\RenewDocumentCommand { \cftdot } { } { $\cdot$ }  
\RenewDocumentCommand { \cftdotsep } { } { 1.2 }
% 设置章目录的引导线（默认是没有的）
\RenewDocumentCommand { \cftchapdotsep } { } { \cftdotsep }   


\cs_new:Npn \__ccnu_tableofcontents_format_bachelor:
  {
    % chapter前的额外垂直间距
    \dim_set:Nn \cftbeforechapskip { 0.3\baselineskip }
    % section前的额外垂直间距
    \dim_set:Nn \cftbeforesecskip { 0.1\baselineskip }
    % 页码样式，设置为无样式
    \RenewDocumentCommand { \cftchappagefont } { } {}
    % 计数器宽度
    \dim_set:Nn \cftchapnumwidth { 1.5em }
    \dim_set:Nn \cftsecnumwidth { 2em }
    \dim_set:Nn \cftsubsecnumwidth { 2em }
  }
\cs_new:Npn \__ccnu_tableofcontents_format_master:
  {
    % chapter前的额外垂直间距
    \dim_set:Nn \cftbeforechapskip { 0.4\baselineskip }
    % section前的额外垂直间距
    \dim_set:Nn \cftbeforesecskip { 0.3\baselineskip }
    % subsection前的额外垂直间距
    \dim_set:Nn \cftbeforesubsecskip { 0.2\baselineskip }
    % 缩进
    \dim_set:Nn \cftchapindent { 0em }
    \dim_set:Nn \cftsecindent  { 1em }
    \dim_set:Nn \cftsubsecindent { 2em }
    % 计数器宽度
    \dim_set:Nn \cftchapnumwidth { 1em }
    \dim_set:Nn \cftsecnumwidth { 1em }
    \dim_set:Nn \cftsubsecnumwidth { 1em }
    \RenewDocumentCommand { \cftchapfont } { }
      { \zihao{-4} \normalfont \bfseries }
    \RenewDocumentCommand { \cftsecfont } { }
      { \zihao{-4} \normalfont }
    \RenewDocumentCommand { \cftsubsecfont } { }
      { \zihao{-4} \normalfont }
    \RenewDocumentCommand { \cftchappagefont } { }
      { \zihao{5} \normalfont }
    \RenewDocumentCommand { \cftsecpagefont } { }
      { \zihao{5} \normalfont }
    \RenewDocumentCommand { \cftsubsecpagefont } { }
      { \zihao{5} \normalfont }
    % 页码宽度
    \cftsetpnumwidth { 1.3em }
  }
\cs_new:Npn \__ccnu_tableofcontents_format_doctor:
  {
    % chapter前的额外垂直间距
    \dim_set:Nn \cftbeforechapskip { 0.3\baselineskip }
    % section前的额外垂直间距
    \dim_set:Nn \cftbeforesecskip { 0.1\baselineskip }
    % subsection前的额外垂直间距
    \dim_set:Nn \cftbeforesubsecskip { 0.05\baselineskip }
    % 缩进
    \dim_set:Nn \cftchapindent { 0em }
    \dim_set:Nn \cftsecindent  { 1em }
    \dim_set:Nn \cftsubsecindent { 2em }
    % 计数器宽度
    \dim_set:Nn \cftchapnumwidth { 1em }
    \dim_set:Nn \cftsecnumwidth { 1em }
    \dim_set:Nn \cftsubsecnumwidth { 1em }
    \RenewDocumentCommand { \cftchapfont } { }
      { \zihao{5} \normalfont \bfseries }
    \RenewDocumentCommand { \cftsecfont } { }
      { \zihao{5} \normalfont }
    \RenewDocumentCommand { \cftsubsecfont } { }
      { \zihao{5} \normalfont }
    % 页码字体
    \RenewDocumentCommand { \cftchappagefont } { }
      { \zihao{5} \normalfont }
    \RenewDocumentCommand { \cftsecpagefont } { }
      { \zihao{5} \normalfont }
    \RenewDocumentCommand { \cftsubsecpagefont } { }
      { \zihao{5} \normalfont }
    % 页码宽度
    \cftsetpnumwidth { 1.4em }
  }
\int_case:nn { \g__ccnu_thesis_type_int }
  {
    {3}{ \__ccnu_tableofcontents_format_bachelor: }
    {2} { \__ccnu_tableofcontents_format_master: }
    {1} { \__ccnu_tableofcontents_format_doctor: }
  }

% 摘要

% 控制关键词是否要空一行
\bool_new:N \g__ccnu_keywords_newline_bool


\int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
  {
    % 中文摘要
      \NewDocumentEnvironment { abstract  } { }
      { \__ccnu_abstract_begin_bachelor: }
      { \__ccnu_abstract_end_bachelor:   }
    % 英文摘要
    \NewDocumentEnvironment { abstract* } { }
      { \__ccnu_abstract_en_begin_bachelor: } 
      { \__ccnu_abstract_en_end_bachelor:   }
  }
  {
    % 中文摘要
    \NewDocumentEnvironment { abstract  } { }
      { \__ccnu_abstract_begin_master_doctor: }
      { \__ccnu_abstract_end_master_doctor:   }
    % 英文摘要
    \NewDocumentEnvironment { abstract* } { }
      { \__ccnu_abstract_en_begin_master_doctor: } 
      { \__ccnu_abstract_en_end_master_doctor:   }
  }
% 本科的摘要
\cs_new:Npn \__ccnu_abstract_begin_bachelor:
  { 
    \newpage
    \__ccnu_pagestyle_bachelor_plain:
    % 实现超链接
    \chapter*{}
    \vskip-3.2em
    \phantomsection
    % 把 内容摘要 写进目录
    \addcontentsline { toc } { chapter }
      { \normalfont \tl_use:N \c__ccnu_name_abstract_tl }
    % 「内容摘要：」
    { \bfseries \c__ccnu_name_abstract_tl : }
    % 教务处要求缩进两格
    \c_space_tl \c_space_tl
  }
\cs_new:Npn \__ccnu_abstract_end_bachelor:
  {
    \phantomsection
    % 把 关键词 写进目录
    \addcontentsline { toc } { chapter }
      { \normalfont  \c__ccnu_name_keywords_tl }
    \bool_if:NTF \g__ccnu_keywords_newline_bool
      {
        \par \vskip \baselineskip
      }
      {
        \par
      }
    \textbf { \c__ccnu_name_keywords_tl : }
    \c_space_tl \c_space_tl
    \clist_use:Nn \l__ccnu_info_keywords_clist 
      { \qquad }
    \par
  }
\cs_new:Npn \__ccnu_abstract_en_begin_bachelor:
  { 
    \bigskip
    \keys_set:nn { ctex }
      { chapter/break = { \addpenalty { \@secpenalty } } }
    % 超链接 Title
    \chapter*{}
    \vskip-1.5em
    \phantomsection
    % 把 Title 写进目录
    \addcontentsline { toc } { chapter }
      { \normalfont Title }
    \textbf{ Title: } \c_space_tl \l__ccnu_info_title_en_tl \par
    % \medskip
    \phantomsection
    \textbf { \c__ccnu_name_abstract_en_tl : }
    % \c_space_tl \c_space_tl
    % 把 abstract 写进目录
    \addcontentsline { toc } { chapter }
      { \normalfont \tl_use:N \c__ccnu_name_abstract_en_tl}
  }
\cs_new:Npn \__ccnu_abstract_en_end_bachelor:
  {
    % 把 keywords 写进目录
    \phantomsection
    \addcontentsline { toc } { chapter }
      { \normalfont  \c__ccnu_name_keywords_en_tl }
    \bool_if:NTF \g__ccnu_keywords_newline_bool
      {
        \par \vskip \baselineskip
      }
      {
        \par
      }
    \textbf { \c__ccnu_name_keywords_en_tl : }
    \c_space_tl \c_space_tl
    \clist_use:Nn \l__ccnu_info_keywords_en_clist 
      { \qquad }
    \newpage
  }
% 硕博的摘要
\cs_new:Npn \__ccnu_abstract_begin_master_doctor:
  { 
    % \newpage
    \pagenumbering { Roman }
    \keys_set:nn { ctex }
      {
        chapter = 
          {
            numbering = false,
            format = \zihao{3} \sffamily \bfseries \centering,
            indent = 0pt
          }
      }
    \__ccnu_pagestyle_setting_before_abstract:
    % \show\chapter
    \chapter {摘 \quad 要}
    % \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
    %   {
    %     \addcontentsline { toc } { chapter }
    %       { \bfseries \zihao{-4} 摘要 }
    %   }
    %   {
    %     \addcontentsline { toc } { chapter }
    %       { \bfseries \zihao{5} 摘要 }
    %   }
    \group_begin:
      \keys_set:nn { ctex }
        { punct = quanjiao }
      % \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      %   { \zihao{-4} }
      %   { \linespread{1}\fontsize{10.5pt}{19bp} \selectfont }
  }
\cs_new:Npn \__ccnu_abstract_end_master_doctor:
  {
      \bool_if:NTF \g__ccnu_keywords_newline_bool
        {
          \par \vskip \baselineskip
        }
        {
          \par
        }
      \textbf { \c__ccnu_name_keywords_tl }：
      \clist_use:Nn \l__ccnu_info_keywords_clist 
        { ； }
    \group_end:
    % newpage 是摘要最后一页产生正确页眉的关键
    \newpage
  }
\cs_new:Npn \__ccnu_abstract_en_begin_master_doctor:
  { 
    % \pagenumbering{ Roman }
    \keys_set:nn { ctex }
      {
        chapter = 
          {
            numbering = false,
            format = \zihao{3} \bfseries \centering,
            indent = 0pt
          }
      }
    \__ccnu_pagestyle_setting_before_abstract:
    \chapter { Abstract }
    \group_begin:
      \keys_set:nn { ctex }
        { punct = banjiao }
      % \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {2}
      %   { \zihao{-4} }
      %   { \linespread{1}\fontsize{10.5pt}{19bp} \selectfont }
  }
\cs_new:Npn \__ccnu_abstract_en_end_master_doctor:
  {
      \bool_if:NTF \g__ccnu_keywords_newline_bool
        {
          \par \vskip \baselineskip
        }
        {
          \par
        }
      \textbf { \c__ccnu_name_keywords_en_tl }: \space
      \clist_use:Nn \l__ccnu_info_keywords_en_clist 
        { ;~ }
    \group_end:
    % newpage 是摘要最后一页产生正确页眉的关键
    \newpage
  }

\bool_new:N \g__ccnu_listoftables_show_bool
\bool_new:N \g__ccnu_listoffigures_show_bool

% 摘要和目录的顺序调整
\int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
  {
    \BeforeBeginEnvironment { abstract }
      {
        % 目录
        \group_begin:
          \__ccnu_pagestyle_tableofcontents_bachelor:
          \tableofcontents
        \group_end:
        \__ccnu_pagestyle_bachelor_plain:
        \int_set:Nn { \c@page } { 1 }
        \group_begin:
          \keys_set:nn { ctex }
            {
              chapter = 
                {
                  indent = 0pt,
                  format = \zihao{-2} \normalfont \bfseries \centering
                }
            }
          % \patchcmd
          %   { \chapter }
          %   { \pagestyle { plain } }
          %   { \thispagestyle { plain } }
          %   {} { \fail }
          \bool_if:NT \g__ccnu_listoffigures_show_bool
            { 
              \listoffigures 
            }
          \bool_if:NT \g__ccnu_listoftables_show_bool
            { 
              \listoftables
            }
        \group_end:
        \newpage
      }
  }
  {
    % 硕博摘要在目录前
    \AfterEndEnvironment { abstract* }
      {
        % 目录
        \group_begin:
          \__ccnu_pagestyle_tableofcontents_master_doctor:
          \tableofcontents
        \group_end:
        % 防止 \__ccnu_pagestyle_setting_before_tableofcontents: 对后面页面的干扰，需要还原设置
        \__ccnu_pagestyle_setting_after_tableofcontents:
        \bool_if:NT \g__ccnu_listoffigures_show_bool
          { \listoffigures }
        \bool_if:NT \g__ccnu_listoftables_show_bool
          { \listoftables }
      }
  }


\keys_define:nn { ccnu / style }
  {
    % 控制关键词是否空一行
    keywords-newline .bool_gset:N = \g__ccnu_keywords_newline_bool,
    % 控制图表目录
    listoffigures-show .bool_gset:N = \g__ccnu_listoffigures_show_bool,
    listoftables-show .bool_gset:N = \g__ccnu_listoftables_show_bool,
    % 图表目录的标题名称
    listoffigures-name .tl_set:N = \g__ccnu_listoffigures_name_tl,
    listoftables-name .tl_set:N = \g__ccnu_listoftables_name_tl,
  }

\keys_set:nn { ccnu /style }
  {
    listoffigures-name = {插 \quad 图},
    listoftables-name = {表 \quad 格}
  }

\keys_set:nn { ctex }
  {
    listfigurename = { \g__ccnu_listoffigures_name_tl },
    listtablename = { \g__ccnu_listoftables_name_tl }
  }
\int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
  {
    \keys_set:nn { ccnu / style }
      {
        keywords-newline   = false,
        listoffigures-show = false,
        listoftables-show  = false,
      }
  }
  {
    \keys_set:nn { ccnu / style }
      {
        keywords-newline   = true,
        listoffigures-show = true,
        listoftables-show  = true,
      }
  }

% 符号表
\NewDocumentEnvironment { notation } 
  {
    O 
    {
      width = 0.3\textwidth,
      colspec = {X[1,c]X[1,c]}
    } 
  }
  {
    \newpage
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      { \__ccnu_notation_begin_bachelor: }
      { \__ccnu_notation_begin_master_doctor: }
    \group_begin:
      \SetTblrTemplate { head, foot } { empty }
      \longtblr {#1}
  }
  {
      \endlongtblr
      \setcounter{table}{0}
    \group_end:
  }
\cs_new_protected:Npn \__ccnu_notation_begin_bachelor:
  {
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = 
            {
              format = \zihao{-2} \normalfont \bfseries \centering,
              indent = 0pt,
              numbering = false
            }
        }
      \chapter { 符号表 }
    \group_end:
  }
\cs_new_protected:Npn \__ccnu_notation_begin_master_doctor:
  {
    \group_begin:
      \__ccnu_chapter_master_doctor:V \c__ccnu_name_notation_tl
    \group_end:
  }

% 参考文献

\bool_new:N \l__ccnu_bibtex_bool
\tl_new:N \l__ccnu_bib_style_tl
\tl_new:N \l__ccnu_biblatex_bibstyle_tl
\tl_new:N \l__ccnu_bib_gb_style_tl
\tl_new:N \l__ccnu_cite_style_tl
\clist_new:N \l__ccnu_bib_resource_clist

\AtBeginEnvironment { document }
  {
    \__ccnu_biblatex_pre_setup:
    \RequirePackage { biblatex }
    \__ccnu_biblatex_post_setup:
  }

\cs_new_protected:Npn \__ccnu_biblatex_pre_setup:
  {
    \cs_undefine:N \addbibresource
    \clist_if_exist:NF \l__ccnu_biblatex_options_clist
      {
        \clist_new:N \l__ccnu_biblatex_options_clist
      }
    \clist_put_right:Nn \l__ccnu_biblatex_options_clist 
      { hyperref = manual }
    \clist_put_right:Nn \l__ccnu_biblatex_options_clist
      {
        backend      = biber,
        bibstyle     = \tl_use:N \l__ccnu_biblatex_bibstyle_tl,
        citestyle    = gb7714-CCNU
      }
    \tl_if_in:NnT \l__ccnu_biblatex_bibstyle_tl { gb7714-CCNU }
      {
        \clist_put_right:Nn \l__ccnu_biblatex_options_clist
          {  CCNUpunctcn  = false }
      }
    \exp_args:NV \PassOptionsToPackage \l__ccnu_biblatex_options_clist
      { biblatex }
  }

\cs_new_protected:Npn \__ccnu_biblatex_post_setup:
  {
    \clist_map_function:NN \l__ccnu_bib_resource_clist \addbibresource
    \__ccnu_biblatex_allow_url_break:
    \__ccnu_biblatex_use_en_dash:
    % 参考文献标题
    \int_compare:nNnTF { \g__ccnu_thesis_type_int } = {3}
      {
        \defbibheading { bibliography } [ \bibname ] 
          { \__ccnu_chapter_without_number_bachelor:n {##1} }
      }
      {
        \defbibheading { bibliography } [ \bibname ] 
          { \__ccnu_chapter_master_doctor:n {##1} }
      }
    % 修改 \printbibliography
    \cs_set_eq:NN \__ccnu_printbibliography_old \printbibliography
    \cs_new:Npn \__ccnu_printbibliography:n ##1 
      {
        \__ccnu_printbibliography_old [ ##1 ] 
      }
    \RenewDocumentCommand { \printbibliography } { O{} } 
      {
        \newpage
        \group_begin:
          \sloppy
          \keys_set:nn { ctex }
            { punct = plain }
          \__ccnu_printbibliography:n { ##1 }
        \group_end:
      }
  }


\keys_define:nn { ccnu / style }
  {
    bib-style .choice:,
    bib-style .value_required:n = true,
    bib-style / ccnu-bachelor-numerical .code:n =
      {
        \tl_set:Nn \l__ccnu_biblatex_bibstyle_tl
          { gb7714-CCNU }
      },
    bib-style / ccnu-bachelor-author-year .code:n =
      {
        \tl_set:Nn \l__ccnu_biblatex_bibstyle_tl
          { gb7714-CCNUay }
      },
    bib-style / ccnu-master .code:n =
      {
        \tl_set:Nn \l__ccnu_biblatex_bibstyle_tl
          { gb7714-2015 }
      },
    bib-style / ccnu-doctor .code:n =
      {
        \tl_set:Nn \l__ccnu_biblatex_bibstyle_tl
          { gb7714-2015 }
      },
    bib-style / gb7714-2015 .code:n =
      {
        \tl_set:Nn \l__ccnu_biblatex_bibstyle_tl
          { gb7714-2015 }
      },
    bib-style / unknown     .code:n =
      {
        \tl_set_eq:NN \l__ccnu_biblatex_bibstyle_tl \l_keys_value_tl
      },
    bib-resource .clist_set:N = \l__ccnu_bib_resource_clist
  }
\keys_set:nn { ccnu / style }
  {
    bib-style = ccnu-bachelor-numerical,
    bib-resource = {CCNUthesis-main.bib}
  }
\cs_new:Npn \__ccnu_biblatex_allow_url_break:
  {
    \int_set_eq:NN \c@biburlucpenalty  \c_one_int
    \int_set_eq:NN \c@biburlnumpenalty \c_one_int
    \int_set_eq:NN \c@biburllcpenalty  \c_one_int
  }
\cs_new:Npn \__ccnu_biblatex_use_en_dash:
  {
    \DefineBibliographyExtras { english }
      {
        \cs_set_nopar:Npn \bibrangedash
          { \textendash \penalty \hyphenpenalty }
      }
    \DefineBibliographyExtras { russian }
      {
        \cs_set_nopar:Npn \bibrangedash
          { \textendash \penalty \hyphenpenalty }
      }
  }


% hyperref 配置
\NewDocumentCommand \hypersetup { m }
  { \ccnu_hyperref_setup:n {#1} }
\cs_new_protected:Npn \ccnu_hyperref_setup:n #1
  { \clist_gput_right:Nn \g__ccnu_to_hyperref_clist {#1} }
\cs_new:Npn \__ccnu_set_hyperlink_color_key:n #1
  {
    hyperlink-color / \clist_item:nn {#1} {1} .code:n =
      {
        \__ccnu_define_hyperlink_color:nnn
          { \clist_item:nn {#1} {2} }
          { \clist_item:nn {#1} {3} }
          { \clist_item:nn {#1} {4} }
        \ccnu_hyperref_setup:n
          {
            linkcolor = ccnu@link, linkbordercolor = ccnu@link,
            urlcolor  = ccnu@url,  urlbordercolor  = ccnu@url,
            citecolor = ccnu@cite, citebordercolor = ccnu@cite
          }
      },
  }
\cs_new_protected:Npn \__ccnu_define_hyperlink_color:nnn #1#2#3
  {
    \definecolorset { HTML } { ccnu@ } { }
      { link, #1; url, #2; cite, #3 }
  }
\keys_define:nx { ccnu / style }
  {
    hyperlink .choice:,
    hyperlink .value_required:n = true,
    hyperlink / color  .code:n =
      { \ccnu_hyperref_setup:n { colorlinks = true  } },
    hyperlink / none   .code:n =
      { \ccnu_hyperref_setup:n { hidelinks } },
    hyperlink-color .choice:,
    hyperlink-color .value_required:n = true,
    \clist_map_function:nN
      {
        { classic,   FF0000, 0000FF, 00FF00 },
        { default,   990000, 0000B2, 007F00 },
        { material,  E91E63, 009688, 4CAF50 },
        { graylevel, 616161, 616161, 616161 },
        { prl,       2D3092, 2D3092, 2D3092 }
      }
      \__ccnu_set_hyperlink_color_key:n
  }
\keys_set:nn { ccnu / style }
  {
    hyperlink = none,
    hyperlink-color = default
  }
\cs_new:Npn \ccnu_allow_url_break:
  {
    \cs_new:Npn \__ccnu_add_url_break_points:
      { \tl_map_function:NN \c__ccnu_url_break_points_tl \do }
    \__ccnu_appto_cmd:Nn \UrlBreaks
      { \UrlOrds \__ccnu_add_url_break_points: }
  }
\tl_const:Nn \c__ccnu_url_break_points_tl
  {
    abcdefghijklmnopqrstuvwxyz
    ABCDEFGHIJKLMNOPQRSTUVWXYZ
    0123456789
  }
\ctex_at_end_preamble:n
  {
    \RequirePackage { hyperref }
    \hypersetup
      {
        bookmarksnumbered = true,
        psdextra          = true,
        unicode           = true,
        pdftitle    = \l__ccnu_info_title_tl,
        pdfauthor   = \l__ccnu_info_author_tl,
        pdfkeywords = \l__ccnu_info_keywords_clist,
        pdfcreator  = \c__ccnu_name_pdf_creator_tl
      }
    \exp_args:NV \hypersetup \g__ccnu_to_hyperref_clist
    \ccnu_allow_url_break:
    \bool_if:NF \l__ccnu_bibtex_bool { \BiblatexManualHyperrefOn }
  }
\ctex_at_end_package:nn { hyperref }
  {
    \pdfstringdefDisableCommands
      {
        \cs_set_eq:NN \ccnu@kai \prg_do_nothing:
        \cs_set_eq:NN \quad    \c_space_tl
        \cs_set_eq:NN \qquad   \c_space_tl
      }
  }



% 添加 ccnu 项目的 choices 环境
% https://gitee.com/zepinglee/exam-zh/blob/main/exam-zh-choices.sty
\dim_new:N \l__ccnu_choices_column_sep_dim
\int_new:N \l__ccnu_choices_columns_int
\tl_new:N \l__ccnu_choices_label_tl
\tl_new:N \l__ccnu_choices_label_pos_tl
\dim_new:N \l__ccnu_choices_label_sep_dim
\dim_new:N \l__ccnu_choices_label_width_dim
\int_new:N \l__ccnu_choices_max_columns_int


\keys_define:nn { ccnu / choices }
  {
    column-sep  .dim_set:N = \l__ccnu_choices_column_sep_dim ,
    columns     .int_set:N = \l__ccnu_choices_columns_int ,
    label       .tl_set:N  = \l__ccnu_choices_label_tl ,
    label-pos   .choices:nn =
      { auto , top-left , left , bottom }
      { \tl_set_eq:NN \l__ccnu_choices_label_pos_tl \l_keys_choice_tl } ,
    label-sep   .dim_set:N = \l__ccnu_choices_label_sep_dim ,
    label-width .dim_set:N = \l__ccnu_choices_label_width_dim ,
    max-columns .int_set:N = \l__ccnu_choices_max_columns_int ,
  }

\keys_set:nn { ccnu / choices }
  {
    column-sep  = 1em ,
    columns     = 0 ,
    label       = \Alph*. ,
    label-pos   = auto ,
    label-sep   = .5em ,
    label-width = 0pt ,
    max-columns = 4 ,
  }


\tl_new:N \l__ccnu_choices_counters_tl

\NewDocumentCommand \AddChoicesCounter { m m m }
  {
    \tl_put_right:Nn \l__ccnu_choices_counters_tl
      { \l__ccnu_process_counter:NN #1 #2 }
    \cs_set_eq:cN { __ccnu_chioces_save_ \cs_to_str:N #1 : } #2
    \cs_set_eq:cN { __ccnu_chioces_save_ \cs_to_str:N #2 : } #2
  }

\AddChoicesCounter \arabic \@arabic { 0 }
\AddChoicesCounter \alph   \@alph   { m }
\AddChoicesCounter \Alph   \@Alph   { M }
\AddChoicesCounter \roman  \@roman  { viii }
\AddChoicesCounter \Roman  \@Roman  { VIII }


\dim_new:N \l__ccnu_choices_total_width_dim
\seq_new:N \l__ccnu_choices_seq

\NewDocumentEnvironment { choices } { O { } +b }
  {
    \par \nopagebreak
    % 严格禁止孤行和寡行
    \int_set:Nn \clubpenalty { 10000 }
    \int_set:Nn \widowpenalty { 10000 }
    % 尽量避免在选项中间换行
    \int_set:Nn \interlinepenalty { 301 }
    \noindent
    \dim_set_eq:NN \l__ccnu_choices_total_width_dim \linewidth
    \int_zero:N \l__ccnu_choices_columns_int
    \dim_zero:N \l__ccnu_choices_label_width_dim
    \keys_set:nn { ccnu / choices } {#1}
  }
  {
    \seq_set_split:Nnn \l__ccnu_choices_seq { \item } {#2}
    \seq_if_empty:NF \l__ccnu_choices_seq
      { \seq_pop_left:NN \l__ccnu_choices_seq \l_tmpa_tl }
    % 计算标签和选项内容的最大自然宽度
    \__ccnu_choices_calc_max_width:N \l__ccnu_choices_seq
    % label-pos = auto 时自动选择标签位置
    \__ccnu_choices_set_auto_label_pos:
    % 如果用户没有声明列数，计算合适的列数
    \int_compare:nNnT { \l__ccnu_choices_columns_int } < {1}
      { \__ccnu_choices_calc_columns: }
    % 计算每个选项内容的宽度 \l__ccnu_choices_item_width_dim
    \__ccnu_choices_calc_item_width:
    % 输出选项
    \indent
    \__ccnu_print_choices:N \l__ccnu_choices_seq
  }


\dim_new:N \l__ccnu_choices_item_width_dim
\dim_new:N \l__ccnu_choices_item_min_height_dim

% 计算标签和选项内容的最大宽度，
% 分别保存到 \l__ccnu_choices_label_width_dim 和 \l__ccnu_choices_item_width_dim
% #1: \l__ccnu_choices_seq
\cs_new:Npn \__ccnu_choices_calc_max_width:N #1
  {
    \dim_zero:N \l__ccnu_choices_item_width_dim
    \dim_set_eq:NN \l__ccnu_choices_item_min_height_dim \c_max_dim
    \seq_map_indexed_inline:Nn #1
      {
        % 标签
        \hbox_set:Nn \l_tmpa_box { \__ccnu_choices_make_label:n {##1} }
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpa_dim } > { \l__ccnu_choices_label_width_dim }
          { \dim_set_eq:NN \l__ccnu_choices_label_width_dim \l_tmpa_dim }
        % 选项内容
        \hbox_set:Nn \l_tmpa_box {##2}
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpa_dim } > { \l__ccnu_choices_item_width_dim }
          {
            \dim_set_eq:NN \l__ccnu_choices_item_width_dim
              \l_tmpa_dim
          }
        % 找到最小高度
        \dim_set:Nn \l_tmpb_dim { \box_ht:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpb_dim } < { \l__ccnu_choices_item_min_height_dim }
          { \dim_set_eq:NN \l__ccnu_choices_item_min_height_dim \l_tmpb_dim }
        \box_clear:N \l_tmpa_box
      }
  }


\int_new:N \l__ccnu_choices_index_int

% \Alph* 生成正确的标签
\cs_new:Npn \__ccnu_choices_make_label:n #1
  {
    \group_begin:
      \int_set:Nn \l__ccnu_choices_index_int {#1}
      \l__ccnu_choices_counters_tl
      \l__ccnu_choices_label_tl
    \group_end:
  }

\cs_new:Npn \l__ccnu_process_counter:NN #1#2
  {
    \cs_set:Npn #1 { \l__ccnu_process_counter_aux:Nn #2 }
    \cs_set:Npn #2 { \l__ccnu_process_counter_aux:Nn #2 }
  }

\cs_new:Npn \l__ccnu_process_counter_aux:Nn #1#2
  {
    \tl_if_eq:nnTF {#2} { * }
      {
        \use:c { __ccnu_chioces_save_ \cs_to_str:N #1 : }
          { \l__ccnu_choices_index_int }
      }
      {
        \use:c { __ccnu_chioces_save_ \cs_to_str:N #1 : } {#2}
      }
  }


% 超过这一高度阈值的选项视为插图模式
% 注意使用 tl
\tl_new:N \l__ccnu_choices_figure_mode_threshold_tl
\tl_set:Nn \l__ccnu_choices_figure_mode_threshold_tl { 2 \baselineskip }

\cs_new:Npn \__ccnu_choices_set_auto_label_pos:
  {
    \tl_if_eq:NnT \l__ccnu_choices_label_pos_tl { auto }
      {
        % 若最小高度超过阈值，推测其中包含插图，将标签位置改为左居中
        \dim_compare:nNnTF
          { \l__ccnu_choices_item_min_height_dim } >
            { \l__ccnu_choices_figure_mode_threshold_tl }
          { \tl_set:Nn \l__ccnu_choices_label_pos_tl { left } }
          { \tl_set:Nn \l__ccnu_choices_label_pos_tl { top-left } }
      }
  }


\int_new:N \l__ccnu_tmp_int

% 计算选项的合适列数，存到 \l__ccnu_choices_columns_int
\cs_new:Npn \__ccnu_choices_calc_columns:
  {
    % 若标签不在底部，将 label-width 和 label-sep 算进来
    \tl_if_eq:NnF \l__ccnu_choices_label_pos_tl { bottom }
      {
        \dim_add:Nn \l__ccnu_choices_item_width_dim
          { \l__ccnu_choices_label_width_dim + \l__ccnu_choices_label_sep_dim }
      }
    \int_set:Nn \l__ccnu_choices_columns_int
      {
        \int_div_truncate:nn
          { \l__ccnu_choices_total_width_dim + \l__ccnu_choices_column_sep_dim }
          { \l__ccnu_choices_item_width_dim + \l__ccnu_choices_column_sep_dim }
      }
    \int_compare:nNnTF { \l__ccnu_choices_columns_int } = {0}
      { \int_set:Nn \l__ccnu_choices_columns_int {1} }
    % 从允许的最大列数开始，每次除以 2，直到行宽允许排下
    \int_set_eq:NN \l__ccnu_tmp_int \l__ccnu_choices_max_columns_int
    \int_while_do:nNnn
      { \l__ccnu_tmp_int } > { \l__ccnu_choices_columns_int }
      {
        \int_set:Nn \l__ccnu_tmp_int
          { \int_div_truncate:nn { \l__ccnu_tmp_int } {2} }
      }
    \int_set_eq:NN \l__ccnu_choices_columns_int \l__ccnu_tmp_int
  }


% 计算选项的最终宽度，保存到 \l__ccnu_choices_item_width_dim
\cs_new:Npn \__ccnu_choices_calc_item_width:
  {
    \dim_set:Nn \l__ccnu_choices_item_width_dim
      {
        ( \l__ccnu_choices_total_width_dim
          - \l__ccnu_choices_columns_int \l__ccnu_choices_column_sep_dim
          + \l__ccnu_choices_column_sep_dim
        ) / \l__ccnu_choices_columns_int
      }
    % 若标签不在底部，将 label-width 和 label-sep 算进来
    \tl_if_eq:NnF \l__ccnu_choices_label_pos_tl { bottom }
      {
        \dim_sub:Nn \l__ccnu_choices_item_width_dim
          { \l__ccnu_choices_label_width_dim + \l__ccnu_choices_label_sep_dim }
      }
  }


\int_new:N \l__ccnu_choices_current_col_int

% #1: \l__ccnu_choices_seq
\cs_new:Npn \__ccnu_print_choices:N #1
  {
    \int_zero:N \l__ccnu_choices_current_col_int
    \seq_map_indexed_inline:Nn \l__ccnu_choices_seq
      {
        \int_incr:N \l__ccnu_choices_current_col_int
        % 当前列号重置为 1
        \int_compare:nNnT
          { \l__ccnu_choices_current_col_int } > { \l__ccnu_choices_columns_int }
          {
            % \par \noindent
            \newline
            \int_set:Nn \l__ccnu_choices_current_col_int {1}
          }
        \int_compare:nNnT { \l__ccnu_choices_current_col_int } > {1}
          {
            \skip_horizontal:N \l__ccnu_choices_column_sep_dim
            % 增加一点弹性
            \skip_horizontal:n {0pt plus 1pt minus 1pt}
          }
        \__ccnu_print_single_choice:nn {##1} {##2}
      }
    \par
  }


\coffin_new:N \l__ccnu_choices_item_coffin
\coffin_new:N \l__ccnu_choices_label_coffin

\cs_new:Npn \__ccnu_print_single_choice:nn #1#2
  {
    % 选项标签
    \__ccnu_choices_make_label_coffin:n {#1}
    % 选项内容
    \__ccnu_choices_make_item_coffin:n {#2}
    % 合并选项的标签和内容
    \str_case:Vn \l__ccnu_choices_label_pos_tl
      {
        { top-left }
          {
            \coffin_join:NnnNnnnn
              \l__ccnu_choices_item_coffin  {l} {H}
              \l__ccnu_choices_label_coffin {r} {H}
              { - \l__ccnu_choices_label_sep_dim }
              { 0pt }
          }
        { left }
          {
            \coffin_join:NnnNnnnn
              \l__ccnu_choices_item_coffin  {l} {vc}
              \l__ccnu_choices_label_coffin {r} {vc}
              { - \l__ccnu_choices_label_sep_dim }
              { 0pt }
          }
        { bottom }
          {
            \coffin_join:NnnNnnnn
              \l__ccnu_choices_item_coffin  {hc} {b}
              \l__ccnu_choices_label_coffin {hc} {t}
              { 0pt }
              % { - \l__ccnu_choices_label_sep_dim }
              { 0pt }
          }
      }
    % 输出合并后
    \coffin_typeset:Nnnnn \l__ccnu_choices_item_coffin {l} {H} {0pt} {0pt}
    \coffin_clear:N \l__ccnu_choices_item_coffin
    \coffin_clear:N \l__ccnu_choices_label_coffin
  }

% 将标签内容存入 coffin
\cs_new:Npn \__ccnu_choices_make_label_coffin:n #1
  {
    \hcoffin_set:Nn \l__ccnu_choices_label_coffin
      {
        \vcoffin_set:Nnn \l_tmpa_coffin
          { \l__ccnu_choices_label_width_dim }
          { \noindent \hfill \__ccnu_choices_make_label:n {#1} \strut }
        \coffin_typeset:Nnnnn \l_tmpa_coffin {l} {T} {0pt} {0pt}
        \coffin_clear:N \l_tmpa_coffin
      }
  }

\bool_new:N \l__ccnu_choices_figure_mode_bool

% 将选项内容存入 coffin
\cs_new:Npn \__ccnu_choices_make_item_coffin:n #1
  {
    \hcoffin_set:Nn \l__ccnu_choices_item_coffin
      {
        % 优先尝试使用 bbox，这是因为在 \vcoffin_set 外部能保留原来的 \linewidth 和
        % \textwidth，方便用户在 \includegraphics 中使用
        \hbox_set:Nn \l_tmpa_box {#1}
        % 若盒子的自然高度大于 2 行，且深度为 0pt，设置为插图模式
        \bool_lazy_and:nnT
          {
            \dim_compare_p:nNn { \box_ht:N \l_tmpa_box } >
            { \l__ccnu_choices_figure_mode_threshold_tl }
          }
          { \dim_compare_p:nNn { \box_dp:N \l_tmpa_box } < { 1pt } }
          { \bool_set_true:N \l__ccnu_choices_figure_mode_bool }
        \vcoffin_set:Nnn \l_tmpa_coffin
          { \l__ccnu_choices_item_width_dim }
          {
            \dim_set_eq:NN \parskip \c_zero_dim
            \dim_set_eq:NN \parindent \listparindent
            \noindent
            % \strut
            % 若标签在底部，将图片居中对齐。
            \tl_if_eq:NnT \l__ccnu_choices_label_pos_tl { bottom }
              { \centering }
            \dim_compare:nNnTF
              { \box_wd:N \l_tmpa_box } > { \l__ccnu_choices_item_width_dim }
              { #1 }
              { \box_use_drop:N \l_tmpa_box }
            % 使用 \strut 将行距撑开，防止跟下一行选项的间距过小
            \mode_if_horizontal:T { \strut }
          }
        \dim_set:Nn \l_tmpa_dim { \coffin_ht:N \l_tmpa_coffin }
        \bool_if:NT \l__ccnu_choices_figure_mode_bool
          {
            \coffin_set_horizontal_pole:Nnn \l_tmpa_coffin {T}
              { \l_tmpa_dim - 0.7 \baselineskip }
          }
        \coffin_typeset:Nnnnn \l_tmpa_coffin {l} {T} {0pt} {0pt}
        \coffin_clear:N \l_tmpa_coffin
      }
  }


% 使用中文字体直接输出 unicode 带圈数字
% \circlednumber 的参数既可以接受 LaTeX2e 的 <counter>，也可以直接接受 <intexpr>。
\NewDocumentCommand \circlednumber { m }
  {
    \int_if_exist:cTF { c@ #1 }
      { \int_set_eq:Nc \l_tmpa_int { c@#1 } }
      { \int_set:Nn \l_tmpa_int { #1 } }
    \exp_args:Nx \__ccnu_choices_circled_number:n { \int_use:N \l_tmpa_int }
  }

\cs_new:Npn \__ccnu_choices_circled_number:n #1
  {
    \int_set:Nn \l_tmpa_int {#1}
    \int_compare:nNnTF { \l_tmpa_int } = { 0 }
      { \int_set:Nn \l_tmpa_int { "24EA } }
      {
        \int_compare:nNnTF { \l_tmpa_int } < { 21 }
          { \int_add:Nn \l_tmpa_int { "245F } }
          {
            \int_compare:nNnTF { \l_tmpa_int } < { 36 }
              { \int_add:Nn \l_tmpa_int { "3250 } }
              {
                \int_compare:nNnTF { \l_tmpa_int } < { 51 }
                  { \int_add:Nn \l_tmpa_int { "32B0 } }
                  {
                    \msg_error:nnn { ccnu / choices }
                      { invalid-circled-number } { \int_use:N \l_tmpa_int }
                  }
              }
          }
      }
    \group_begin:
      \CJKfamily+ { }
      \symbol { \l_tmpa_int }
    \group_end:
  }

\msg_new:nnn { ccnu / choices } { invalid-circled-number }
  { Invalid~ circled~ number~ #1. }

\AddChoicesCounter \circlednumber \__ccnu_choices_circled_number:n {1}