\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{CCNUthesis}
  {2022-04-07}{v1.1.7}
  {Thesis template for Central China Normal University}
\RequirePackage { xtemplate, l3keys2e }

\msg_new:nnn { ccnuthesis } { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
\clist_map_inline:nn { xtemplate, l3keys2e }
  {
    \@ifpackagelater {#1} { 2020/07/17 }
      { } { \msg_error:nnn { ccnuthesis } { l3-too-old } {#1} }
  }
\msg_new:nnn { ccnuthesis } { unsupported-engine }
  {
    The~ ccnuthesis~ class~ requires~ either~ XeTeX~ or~ LuaTeX. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex"~ or~ "lualatex".
  }
\sys_if_engine_xetex:F
  {
    \sys_if_engine_luatex:F
      {
        \msg_fatal:nnx { ccnuthesis } { unsupported-engine }
          { \c_sys_engine_str }
      }
  }

\NewDocumentCommand \ccnusetup { m }
  { \keys_set:nn { ccnu } {#1} }

\box_new:N   \l__ccnu_tmpa_box
\clist_new:N \l__ccnu_tmpa_clist
\clist_new:N \l__ccnu_tmpb_clist
\dim_new:N   \l__ccnu_tmpa_dim
\dim_new:N   \l__ccnu_tmpb_dim
\skip_new:N  \l__ccnu_tmpa_skip
\tl_new:N    \l__ccnu_tmpa_tl
\tl_new:N    \l__ccnu_tmpb_tl
\int_new:N \g__ccnu_thesis_type_int
\clist_new:N \g__ccnu_to_ctexbook_clist
\clist_new:N \g__ccnu_to_hyperref_clist
\bool_new:N \g__ccnu_twoside_bool
\bool_set_true:N \g__ccnu_twoside_bool
\bool_new:N \g__ccnu_draft_bool
\tl_new:N \g__ccnu_config_tl
\cs_generate_variant:Nn \file_input:n     { V  }
\cs_generate_variant:Nn \int_to_arabic:n  { v  }
\cs_generate_variant:Nn \keys_define:nn   { nx }
\cs_generate_variant:Nn \tl_map_inline:nn { xn }
\prg_generate_conditional_variant:Nnn \tl_if_eq:nn { Vn } { T, TF }
\tl_new:N \l__coloruline_line_color_tl
\tl_new:N \l__coloruline_text_color_tl
\dim_new:N \l__coloruline_line_width_dim

\keys_define:nn { coloruline }
  {
    textcolor .tl_set:N = \l__coloruline_text_color_tl,
    textcolor .initial:n = black,
    linecolor .tl_set:N = \l__coloruline_line_color_tl,
    linecolor .initial:n = black,
    line-width .dim_set:N = \l__coloruline_line_width_dim,
    line-width .initial:n = 0.4pt,
    thickness .dim_set:N = \l__coloruline_line_width_dim,
    thickness .initial:n = 0.4pt,
  }
\NewDocumentCommand{ \coloruline } { O{} m }
  {
    \group_begin:
      \keys_set:nn { coloruline } {#1}
      \bgroup
        \color{ \tl_use:N \l__coloruline_text_color_tl }
        \markoverwith
        {
          \textcolor
            { \tl_use:N \l__coloruline_line_color_tl }
            { \rule[-0.5ex]{2pt}{ \l__coloruline_line_width_dim } }
        }
        \ULon{#2}
    \group_end:
  }
\cs_new:Npn \__ccnu_quad:  { \skip_horizontal:n { 1 em } }
\cs_new:Npn \__ccnu_qquad: { \skip_horizontal:n { 2 em } }
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
\cs_new:Npn \__ccnu_symbol:n #1 { \tex_char:D #1 \scan_stop: }
\cs_new:Npn \__ccnu_arabic:n #1
  { \int_to_arabic:v { c@ #1 } }
\cs_new_protected:Npn \__ccnu_gadd_ltxhook:nn #1#2
  { \hook_gput_code:nnn {#1} { . } {#2} }
\hook_gset_rule:nnnn { begindocument/before } { . } { < } { xeCJK }
\cs_new_protected:Npn \__ccnu_patch_cmd:Nnn #1#2#3
  {
    \ctex_patch_cmd_once:NnnnTF #1 { } {#2} {#3}
      { } { \ctex_patch_failure:N #1 }
  }
\cs_new_protected:Npn \__ccnu_appto_cmd:Nn #1#2
  {
    \ctex_appto_cmd:NnnTF #1 { } {#2}
      { } { \ctex_patch_failure:N #1 }
  }
\cs_new_protected:Npn \__ccnu_define_fn_style:nn #1#2
  { \tl_const:cn { c__ccnu_fn_style_ #1 _tl } {#2} }
\cs_new_protected:Npn \__ccnu_define_punct:nn #1#2
  { \tl_const:cn { c__ccnu_ #1 _tl } {#2} }
\cs_new_protected:Npn \__ccnu_define_name:nn #1#2
  { \tl_const:cn { c__ccnu_name_ #1 _tl } {#2} }
\cs_new_protected:Npn \__ccnu_define_name:nnn #1#2#3
  {
    \tl_const:cn { c__ccnu_name_ #1    _tl } {#2}
    \tl_const:cn { c__ccnu_name_ #1 _en_tl } {#3}
  }
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
    config .tl_set:N = \g__ccnu_config_tl,
    unknown .code:n = { \__ccnu_error:n { unknown-option } }
  }
\__ccnu_msg_new:nn { unknown-option }
  { Class~ option~ "\l_keys_key_str"~ is~ unknown. }
\ProcessKeysOptions { ccnu / option }
% \file_input:n { CCNUthesis.def }
\tl_const:Nn \c__ccnu_name_simp_tl { 华中师范大学         }
\tl_const:Nn \c__ccnu_name_trad_tl { 華中師範大學         }
\tl_const:Nn \c__ccnu_name_en_tl   { Central~ China~ Normal~ University }
\clist_map_inline:nn
  {
    { ideo_comma       } { ^^^^3001 },
    { ideo_full_stop   } { ^^^^3002 },
    { fwid_comma       } { ^^^^ff0c },
    { fwid_full_stop   } { ^^^^ff0e },
    { fwid_colon       } { ^^^^ff1a },
    { fwid_semicolon   } { ^^^^ff1b },
    { fwid_left_paren  } { ^^^^ff08 },
    { fwid_right_paren } { ^^^^ff09 }
  }
  { \__ccnu_define_punct:nn #1 }
\fp_const:Nn \c__ccnu_line_spread_fp
  { \dim_ratio:nn { 20 pt } { 12 bp } / 1.2 }
\tl_const:Nn \c__ccnu_orig_decl_text_tl
  {
    本人郑重声明：所呈交的学位论文是本人在导师指导下独立进行研究工作所取得的研究成果。除了文中特别加以标注引用的内容外，本论文不包含任何其他个人或集体已经发表或撰写的成果作品。本人完全意识到本声明的法律后果由本人承担。
  }
\tl_const:Nn \c__ccnu_auth_decl_text_tl
  {
    本学位论文作者完全了解学校有关保障、使用学位论文的规定，同意学校保留并向有关学位论文管理部门或机构送交论文的复印件和电子版，允许论文被查阅和借阅。本人授权省级优秀学士学位论文评选机构将本学位论文的全部或部分内容编入有关数据库进行检索，可以采用影印、缩印或扫描等复制手段保存和汇编本学位论文。
  }
\clist_const:Nn \c__ccnu_orig_decl_sign_clist
  { 作者签名, 日期 }
\clist_const:Nn \c__ccnu_auth_decl_sign_clist
  { 作者签名, 导师签名, 日期 }
\clist_const:Nn \c__ccnu_thesis_type_clist
  { 博士学位论文, 硕士学位论文, {本科毕业论文（设计）} }
\clist_const:Nn \c__ccnu_degree_type_clist
  { 学术学位, 专业学位 }
\clist_const:Nn \c__ccnu_secret_clist { 秘密, 机密, 绝密 }
\clist_map_inline:nn
  {
    { secret_level       } { 密 \qquad 级                  },
    { secret_star        } { \textrm { \bigstar }          },
    { school_id          } { 学校代码                      },
    { student_id         } { 学号                  },
    { department         } { 学院                          },
    { major              } { 专业                          },
    { major_professional } { 专业学位类别（领域）          },
    { level              } { 年级                        },
    { author             } { 学生姓名                        },
    { supervisor         } { 指导教师                      },
    { date               } { 完成日期                      },
    { instructors        } { 指导小组成员                  },
    { author_sign        } { 学位论文作者签名               },
    { supervisor_sign    } { 导师签名                      },
    { sign_date          } { 日期                         },
    { toc                } { \zihao{-2}  目 \quad 录                   },
    { lof                } { 插图目录                      },
    { lot                } { 表格目录                      },
    { bib_en             } { Bibliography                  },
    { pdf_creator        } { LaTeX~ with~ ccnuthesis~ class },
    { orig_decl          } { \c__ccnu_name_simp_tl \\[15pt] 学位论文原创性声明   },
    { auth_decl          } { 学位论文版权使用授权书 }
  }
  { \__ccnu_define_name:nn #1 }
\clist_map_inline:nn
  {
    { abstract } { 内容摘要 } { Abstract          },
    { keywords } { 关键词      } { Keywords        },
    { clc      } { 中图分类号  } { CLC~ code:        },
    { jel      } { JEL 分类号  } { JEL~ code:        },
    { notation } { 符号表      } { List~ of~ Symbols }
  }
  { \__ccnu_define_name:nnn #1 }
\tl_if_empty:NF \g__ccnu_config_tl
  {
    \file_input:V \g__ccnu_config_tl
    \__ccnu_info:nx { load-config-file } { \g__ccnu_config_tl }
  }
\__ccnu_msg_new:nn { load-config-file }
  { You~ are~ loading~ config~ file~ '#1'. }
\PassOptionsToClass
  {
    UTF8,
    heading    = true,
    fontset    = none,
    zihao      = -4,
    linespread = \c__ccnu_line_spread_fp,
    oneside,
    \g__ccnu_to_ctexbook_clist
  }
  { ctexbook }
\clist_map_inline:nn
  {
    { no-math           } { fontspec },
    { perpage           } { footmisc },
    % { amsmath, thmmarks } { ntheorem }
  }
  { \PassOptionsToPackage #1 }
\LoadClass { ctexbook }
\RequirePackage
  {
    mathtools,    
    amssymb,
    extarrows,
    unicode-math,
    geometry,
    fancyhdr,
    footmisc,
    graphicx,
    longtable,
    caption,
    xcolor,
    tikz,
    tikzpagenodes,
    tabularray,
    varwidth,
    calc,    % 标题下划线需要
    ulem,
    adjustbox,
    etoolbox,
    amsthm,
    thmtools
  }
\RequirePackage[shortlabels]{enumitem}
\RequirePackage[physics]{physicx}
% \RequirePackage{physics}
% 修复\vu的上标偏移问题
% \DeclareDocumentCommand\vectorunit{ s m }{\IfBooleanTF{#1}{\boldsymbol{\hat{#2}}}{\mathbf{\hat{#2}}}}
\RequirePackage[titles]{tocloft}
\graphicspath{{figures/}{logo/}}
\cs_new_protected:Npn \__ccnu_check_package:nnn #1#2#3
  {
    \@ifpackagelater {#1} {#2}
      { } { \__ccnu_error:nnnn { package-too-old } { Package } {#1} {#3} }
  }
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
\sys_if_engine_xetex:T
  { \__ccnu_check_package:nnn { xeCJK } { 2020/05/01 } { 3.8.3 } }
\geometry
  {
    paper      = a4paper,
    twoside,
    left = 3cm,
    right = 2.5cm,
    top = 3cm,
    bottom = 2.5cm
  }
\bool_if:NT \g__ccnu_draft_bool { \geometry { showframe } }
\setenumerate[1]{
  itemindent    = \parindent,
  leftmargin    = 0pt,
  widest        = 0,
  listparindent = \parindent
}
\tl_new:N \g__ccnu_fontset_tl
\tl_new:N \g__ccnu_cjk_fontset_tl
\keys_define:nn { ccnu / style }
  {
    font .choices:nn =
      { garamond, libertinus, lm, palatino, times, times*, none }
      { \tl_set_eq:NN \g__ccnu_fontset_tl \l_keys_choice_tl }
  }
\keys_define:nn { ccnu / style }
  {
    cjk-font .choices:nn =
      { adobe, fandol, founder, mac, sinotype, sourcehan, windows, none }
      { \tl_set_eq:NN \g__ccnu_cjk_fontset_tl \l_keys_choice_tl }
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
\cs_new_protected:Npx \__ccnu_setCJKmainfont:n   #1
  { \__ccnu_setCJKmainfont:nn   {#1} { \__ccnu_cjk_font_options: } }
\cs_new_protected:Npx \__ccnu_setCJKsansfont:n   #1
  { \__ccnu_setCJKsansfont:nn   {#1} { \__ccnu_cjk_font_options: } }
\cs_new_protected:Npx \__ccnu_setCJKmonofont:n   #1
  { \__ccnu_setCJKmonofont:nn   {#1} { \__ccnu_cjk_font_options: } }
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
\clist_map_inline:nn { main, sans, mono, math    } { \__ccnu_set_font_helper:n {#1} }
\clist_map_inline:nn { CJKmain, CJKsans, CJKmono } { \__ccnu_set_font_helper:n {#1} }
\tl_new:N \g__ccnu_font_family_libertinus_serif_tl
\tl_new:N \g__ccnu_font_family_libertinus_sans_tl
\tl_new:N \g__ccnu_font_style_libertinus_rm_tl
\tl_new:N \g__ccnu_font_style_libertinus_bf_tl
\tl_new:N \g__ccnu_font_style_libertinus_it_tl
\tl_new:N \g__ccnu_font_style_libertinus_bfit_tl
\tl_new:N \g__ccnu_font_style_libertinus_bfsl_tl
\tl_new:N \g__ccnu_font_family_xits_tl
\tl_new:N \g__ccnu_font_style_xits_rm_tl
\tl_new:N \g__ccnu_font_style_xits_bf_tl
\tl_new:N \g__ccnu_font_style_xits_it_tl
\tl_new:N \g__ccnu_font_style_xits_bfit_tl
\tl_new:N \g__ccnu_font_name_libertinus_serif_tl
\tl_new:N \g__ccnu_font_name_libertinus_sans_tl
\tl_new:N \g__ccnu_font_name_libertinus_math_tl
\tl_new:N \g__ccnu_font_name_xits_tl
\tl_new:N \g__ccnu_font_name_xits_math_rm_tl
\tl_new:N \g__ccnu_font_name_xits_math_bf_tl
\fontspec_font_if_exist:nTF { LibertinusSerif-Regular.otf }
  {
    \tl_set:Nn \g__ccnu_font_family_libertinus_serif_tl { LibertinusSerif }
    \tl_set:Nn \g__ccnu_font_family_libertinus_sans_tl  { LibertinusSans  }
    \tl_set:Nn \g__ccnu_font_family_libertinus_math_tl  { LibertinusMath  }
    \tl_set:Nn \g__ccnu_font_style_libertinus_rm_tl     { Regular         }
    \tl_set:Nn \g__ccnu_font_style_libertinus_bf_tl     { Bold            }
    \tl_set:Nn \g__ccnu_font_style_libertinus_it_tl     { Italic          }
    \tl_set:Nn \g__ccnu_font_style_libertinus_bfit_tl   { BoldItalic      }
    \fontspec_font_if_exist:nTF { LibertinusSans-BoldOblique.otf }
      { \tl_set:Nn \g__ccnu_font_style_libertinus_bfsl_tl { BoldOblique } }
      { \tl_set:Nn \g__ccnu_font_style_libertinus_bfsl_tl { Bold        } }
  }
  {
    \tl_set:Nn \g__ccnu_font_family_libertinus_serif_tl { libertinusserif }
    \tl_set:Nn \g__ccnu_font_family_libertinus_sans_tl  { libertinussans  }
    \tl_set:Nn \g__ccnu_font_family_libertinus_math_tl  { libertinusmath  }
    \tl_set:Nn \g__ccnu_font_style_libertinus_rm_tl     { regular         }
    \tl_set:Nn \g__ccnu_font_style_libertinus_bf_tl     { bold            }
    \tl_set:Nn \g__ccnu_font_style_libertinus_it_tl     { italic          }
    \tl_set:Nn \g__ccnu_font_style_libertinus_bfit_tl   { bolditalic      }
    \tl_set:Nn \g__ccnu_font_style_libertinus_bfsl_tl   { bolditalic      }
  }
\fontspec_font_if_exist:nTF { XITS-Regular.otf }
  {
    \tl_set:Nn \g__ccnu_font_family_xits_tl        { XITS             }
    \tl_set:Nn \g__ccnu_font_style_xits_rm_tl      { Regular          }
    \tl_set:Nn \g__ccnu_font_style_xits_bf_tl      { Bold             }
    \tl_set:Nn \g__ccnu_font_style_xits_it_tl      { Italic           }
    \tl_set:Nn \g__ccnu_font_style_xits_bfit_tl    { BoldItalic       }
    \tl_set:Nn \g__ccnu_font_name_xits_math_rm_tl  { XITSMath-Regular }
    \tl_set:Nn \g__ccnu_font_name_xits_math_bf_tl  { XITSMath-Bold    }
  }
  {
    \tl_set:Nn \g__ccnu_font_family_xits_tl        { xits          }
    \tl_set:Nn \g__ccnu_font_style_xits_rm_tl      { regular       }
    \tl_set:Nn \g__ccnu_font_style_xits_bf_tl      { bold          }
    \tl_set:Nn \g__ccnu_font_style_xits_it_tl      { italic        }
    \tl_set:Nn \g__ccnu_font_style_xits_bfit_tl    { bolditalic    }
    \tl_set:Nn \g__ccnu_font_name_xits_math_rm_tl  { xits-math     }
    \tl_set:Nn \g__ccnu_font_name_xits_math_bf_tl  { xits-mathbold }
  }
\tl_set:Nx \g__ccnu_font_name_libertinus_serif_tl
  { \g__ccnu_font_family_libertinus_serif_tl - \g__ccnu_font_style_libertinus_rm_tl }
\tl_set:Nx \g__ccnu_font_name_libertinus_sans_tl
  { \g__ccnu_font_family_libertinus_sans_tl  - \g__ccnu_font_style_libertinus_rm_tl }
\tl_set:Nx \g__ccnu_font_name_libertinus_math_tl
  { \g__ccnu_font_family_libertinus_math_tl  - \g__ccnu_font_style_libertinus_rm_tl }
\tl_set:Nx \g__ccnu_font_name_xits_tl
  { \g__ccnu_font_family_xits_tl - \g__ccnu_font_style_xits_rm_tl }
\cs_new_protected:Npn \__ccnu_load_font_garamond:
  {
    \__ccnu_setmainfont:nn { EBGaramond }
      {
        Extension      = .otf,
        UprightFont    = *-Regular,
        BoldFont       = *-Bold,
        ItalicFont     = *-Italic,
        BoldItalicFont = *-BoldItalic
      }
    \__ccnu_setsansfont:nn { \g__ccnu_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__ccnu_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__ccnu_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__ccnu_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__ccnu_font_style_libertinus_bfsl_tl
      }
    \__ccnu_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
    \__ccnu_setmathfont:nn { Garamond-Math.otf } { }
  }
\cs_new_protected:Npn \__ccnu_load_font_libertinus:
  {
    \__ccnu_setmainfont:nn { \g__ccnu_font_family_libertinus_serif_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__ccnu_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__ccnu_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__ccnu_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__ccnu_font_style_libertinus_bfit_tl
      }
    \__ccnu_setsansfont:nn { \g__ccnu_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__ccnu_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__ccnu_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__ccnu_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__ccnu_font_style_libertinus_bfsl_tl
      }
    \__ccnu_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
    \__ccnu_setmathfont:nn { \g__ccnu_font_name_libertinus_math_tl .otf } { }
  }
\cs_new_protected:Npn \__ccnu_load_font_lm:
  { \__ccnu_setmathfont:nn { latinmodern-math.otf } { } }
\cs_new_protected:Npn \__ccnu_load_font_palatino:
  {
    \__ccnu_setmainfont:nn { texgyrepagella }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-italic,
        BoldItalicFont = *-bolditalic
      }
    \__ccnu_setsansfont:nn { \g__ccnu_font_family_libertinus_sans_tl }
      {
        Extension      = .otf,
        UprightFont    = *-\g__ccnu_font_style_libertinus_rm_tl,
        BoldFont       = *-\g__ccnu_font_style_libertinus_bf_tl,
        ItalicFont     = *-\g__ccnu_font_style_libertinus_it_tl,
        BoldItalicFont = *-\g__ccnu_font_style_libertinus_bfsl_tl,
        Scale          = MatchUppercase
      }
    \__ccnu_setmonofont:nn { lmmonolt10 }
      {
        Extension      = .otf,
        UprightFont    = *-regular,
        BoldFont       = *-bold,
        ItalicFont     = *-oblique,
        BoldItalicFont = *-boldoblique
      }
    \__ccnu_setmathfont:nn { texgyrepagella-math.otf } { }
  }
\cs_new_protected:Npn \__ccnu_load_font_times:
  {
    \__ccnu_setmainfont:nn { \g__ccnu_font_family_xits_tl }
      {
        Extension          = .otf,
        UprightFont        = *-\g__ccnu_font_style_xits_rm_tl,
        BoldFont           = *-\g__ccnu_font_style_xits_bf_tl,
        ItalicFont         = *-\g__ccnu_font_style_xits_it_tl,
        BoldItalicFont     = *-\g__ccnu_font_style_xits_bfit_tl
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
    % TODO 考虑数学字体
    % \__ccnu_setmathfont:nn { \g__ccnu_font_name_xits_math_rm_tl .otf }
    %   { BoldFont = \g__ccnu_font_name_xits_math_bf_tl .otf }
    % \setmainfont{STIXTwoText}
    %   [
    %     Extension      = .otf,
    %     UprightFont    = *-Regular,
    %     BoldFont       = *-Bold,
    %     ItalicFont     = *-Italic,
    %     BoldItalicFont = *-Bolditalic,
    %   ]
    \setmathfont{STIXTwoMath-Regular.otf}
    \setmathfont{STIXTwoMath-Regular.otf}[range={scr,bfscr},StylisticSet=01]
  }
\cs_new_protected:cpn { __ccnu_load_font_ times* : }
  {
    \__ccnu_setmainfont:nn { Times~ New~ Roman    } { }
    \__ccnu_setsansfont:nn { Arial                } { }
    \__ccnu_setmonofont:nn { Courier~ New         } { }
    % \__ccnu_setmathfont:nn { \g__ccnu_font_name_xits_math_rm_tl .otf }
      % { BoldFont = \g__ccnu_font_name_xits_math_bf_tl .otf }
    \__ccnu_setmathfont:nn { STIXTwoMath-Regular.otf }
      { BoldFont = STIXTwoMath-Regular.otf }
    % \setmathfont{STIXTwoMath-Regular.otf}
    \setmathfont{STIXTwoMath-Regular.otf}[range={scr,bfscr},StylisticSet=01]
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
\keys_set:nn { unicode-math }
  {
    math-style = ISO,
    bold-style = ISO,
  }
\keys_define:nn { ccnu / style }
  {
    font-size .choice:,
    font-size .value_required:n = true,
    font-size / -4 .code:n = { },
    font-size /  5 .code:n =
      {
        \RenewDocumentCommand \tiny         { } { \zihao {  7 } }
        \RenewDocumentCommand \scriptsize   { } { \zihao { -6 } }
        \RenewDocumentCommand \footnotesize { } { \zihao {  6 } }
        \RenewDocumentCommand \small        { } { \zihao { -5 } }
        \RenewDocumentCommand \normalsize   { } { \zihao {  5 } }
        \RenewDocumentCommand \large        { } { \zihao { -4 } }
        \RenewDocumentCommand \Large        { } { \zihao { -3 } }
        \RenewDocumentCommand \LARGE        { } { \zihao { -2 } }
        \RenewDocumentCommand \huge         { } { \zihao {  2 } }
        \RenewDocumentCommand \Huge         { } { \zihao {  1 } }
      },
    fullwidth-stop .choice:,
    fullwidth-stop .value_required:n = true,
    fullwidth-stop / catcode .code:n =
      { \__ccnu_set_fullwidth_stop_catcode: },
    fullwidth-stop / mapping .code:n =
      {
        \sys_if_engine_xetex:TF
          {
            \clist_gset:Nn \g__xeCJK_default_features_clist
              { Mapping = fullwidth-stop }
          }
          {
            \sys_if_engine_luatex:T
              {
                \__ccnu_warning:n { mapping-not-available }
                \__ccnu_set_fullwidth_stop_catcode:
              }
          }
      },
    fullwidth-stop / false .code:n = { }
  }
\__ccnu_msg_new:nn { mapping-not-available }
  {
    Option~ "fullwidth-stop = mapping"~ is~ not~ available~ in~ LuaTeX. \\
    "fullwidth-stop = catcode"~ will~ be~ set~ instead.
  }
\cs_new:Npn \__ccnu_set_fullwidth_stop_catcode:
  {
    \char_set_active_eq:NN ^^^^3002 \c__ccnu_fwid_full_stop_tl
    \char_set_catcode_active:N ^^^^3002
    \clist_map_inline:nn
      { \c__ccnu_orig_decl_text_tl, \c__ccnu_auth_decl_text_tl }
      { \tl_set_rescan:Nno ##1 { } {##1} }
  }
\DeclareEmphSequence
  {
    \itshape \ccnu@kai,
    \upshape \CJKfamily { \CJKfamilydefault },
  }
\fancyhf { }
\renewcommand{\headrulewidth}{0pt}
% \cs_new_protected:Npn \__ccnu_fancy_head:nn #1#2
%   {
%     \fancyhead [#1]
%       { \small \ccnu@kai \nouppercase {#2} }
%   }
% \bool_if:NTF \g__ccnu_twoside_bool
%   {
%     \__ccnu_fancy_head:nn { L } { \leftmark  }
%     \__ccnu_fancy_head:nn { R } { \rightmark }
%   }
%   {
%     \__ccnu_fancy_head:nn { L  } { \leftmark  }
%     \__ccnu_fancy_head:nn { R  } { \rightmark }
%   }
\fancyfoot [ C ] { \small \thepage }
\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \bool_if:NT \g__ccnu_twoside_bool
      {
        \int_if_odd:nF \c@page
          { \hbox:n { } \thispagestyle { empty } \newpage }
      }
  }
\pagestyle { fancy }
\keys_set:nn { ctex }
  {
    tocdepth = 1 ,
    secnumdepth = 3,
    chapter =
      {
        format      = \zihao{3} \normalfont \bfseries,
        % format      = \huge \normalfont \sffamily \centering,
        % beforeskip  = 50 pt,
        beforeskip  = 10pt,
        % afterskip   = 40 pt,
        afterskip   = 2.7  ex plus 0.5 ex,
        % afterskip   = 15pt,
        number      = \__ccnu_arabic:n { chapter },
        fixskip     = true,
        name        = {},
        % pagestyle   = empty,
      },
    section =
      {
        format      = \zihao{-3} \normalfont \bfseries \raggedright,
        % format      = \Large \normalfont \sffamily \raggedright,
        beforeskip  = 4.5 ex plus 1.0 ex minus 0.2 ex,
        afterskip   = 2.7 ex plus 0.5 ex,
        fixskip     = true
      },
    subsection =
      {
        format      = \zihao{4} \normalfont \bfseries \raggedright,
        % format      = \large \normalfont \sffamily \raggedright,
        beforeskip  = 4.25 ex plus 1.0 ex minus 0.2 ex,
        afterskip   = 2.5  ex plus 0.3 ex,
        fixskip     = true
      },
    % chapter =
    %   {
    %     format      = \zihao{-2}
    %   }
  }
\cs_new_protected:Npn \__ccnu_chapter:n #1
  {
    \group_begin:
      \ctexset { chapter / numbering = false }
      \chapter {#1}
      \__ccnu_chapter_header:n {#1}
    \group_end:
  }
\cs_generate_variant:Nn \__ccnu_chapter:n { V }
\cs_new_protected:Npn \__ccnu_chapter_no_toc:n #1
  {
    \chapter *           {#1}
    \__ccnu_chapter_header:n {#1}
    \pdfbookmark [0] {#1} { toc }
  }
\cs_generate_variant:Nn \__ccnu_chapter_no_toc:n { V }
\cs_new_protected:Npn \__ccnu_chapter_header:n #1
  {
    \bool_if:NTF \g__ccnu_twoside_bool
      { \markboth {#1} {#1} }
      { \markboth { \hfill #1 \hfill } { } }
  }
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
            \fontspec { \g__ccnu_font_name_libertinus_serif_tl .otf }
            \__ccnu_fn_symbol_libertinus:n {#1}
          }
        \c__ccnu_fn_style_libertinus_neg_tl
          {
            \fontspec { \g__ccnu_font_name_libertinus_serif_tl .otf }
            \__ccnu_fn_symbol_libertinus_neg:n {#1}
          }
        \c__ccnu_fn_style_libertinus_sans_tl
          {
            \fontspec { \g__ccnu_font_name_libertinus_sans_tl .otf }
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
            \fontspec { \g__ccnu_font_name_xits_tl .otf }
            \__ccnu_fn_symbol_xits:n {#1}
          }
        \c__ccnu_fn_style_xits_sans_tl
          {
            \fontspec { \g__ccnu_font_name_xits_tl .otf }
            \__ccnu_fn_symbol_xits_sans:n {#1}
          }
        \c__ccnu_fn_style_xits_sans_neg_tl
          {
            \fontspec { \g__ccnu_font_name_xits_tl .otf }
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
% \clist_const:Nn \c__ccnu_thm_style_plain_clist
%   { plain, margin, change }
% \clist_const:Nn \c__ccnu_thm_style_break_clist
%   { break, marginbreak, changebreak }
% \tl_new:N \l__ccnu_thm_style_tl
% \tl_new:N \l__ccnu_thm_header_font_tl
% \tl_new:N \l__ccnu_thm_body_font_tl
% \tl_new:N \l__ccnu_thm_qed_tl
% \tl_new:N \l__ccnu_thm_counter_tl
% \keys_define:nn { ccnu / theorem }
%   {
%     style       .tl_set:N  = \l__ccnu_thm_style_tl,
%     header-font .tl_set:N  = \l__ccnu_thm_header_font_tl,
%     body-font   .tl_set:N  = \l__ccnu_thm_body_font_tl,
%     qed         .tl_set:N  = \l__ccnu_thm_qed_tl,
%     counter     .tl_set:N  = \l__ccnu_thm_counter_tl
%   }
% \cs_new_eq:NN \__ccnu_thm_ntheorem_style:n \theoremstyle
% \cs_new_eq:NN \__ccnu_thm_ntheorem_new:w   \newtheorem
% \RenewDocumentCommand \newtheorem { s o m m }
%   {
%     \IfBooleanTF {#1}
%       { \tl_set:Nn \l__ccnu_thm_qed_tl { \ensuremath { \square } } }
%       { \tl_set:Nn \l__ccnu_thm_qed_tl { } }
%     \tl_set:Nn \l__ccnu_thm_style_tl { plain }
%     \IfValueT {#2} { \keys_set:nn { ccnu / theorem } {#2} }
%     \ccnu_thm_set_header_font:V \l__ccnu_thm_header_font_tl
%     \ccnu_thm_set_body_font:V   \l__ccnu_thm_body_font_tl
%     \ccnu_thm_set_qed:V         \l__ccnu_thm_qed_tl
%     \IfBooleanTF {#1}
%       {
%         \clist_if_in:nVF { plain, break } \l__ccnu_thm_style_tl
%           {
%             \clist_if_in:NVTF
%               \c__ccnu_thm_style_plain_clist \l__ccnu_thm_style_tl
%               { \__ccnu_thm_redefine_style:n { plain } }
%               {
%                 \clist_if_in:NVTF
%                   \c__ccnu_thm_style_break_clist \l__ccnu_thm_style_tl
%                   { \__ccnu_thm_redefine_style:n { break } }
%                   {
%                     \__ccnu_error:nx { unknown-theorem-style }
%                       { \l__ccnu_thm_style_tl }
%                   }
%               }
%           }
%         \tl_put_left:Nn \l__ccnu_thm_style_tl { nonumber }
%         \ccnu_thm_new_no_number:Vxx \l__ccnu_thm_style_tl {#3} {#4}
%       }
%       {
%         \clist_clear:N \l__ccnu_tmpa_clist
%         \clist_concat:NNN \l__ccnu_tmpa_clist
%           \c__ccnu_thm_style_plain_clist \c__ccnu_thm_style_break_clist
%         \clist_if_in:NVF \l__ccnu_tmpa_clist \l__ccnu_thm_style_tl
%           {
%             \__ccnu_error:nx { unknown-theorem-style }
%               { \l__ccnu_thm_style_tl }
%           }
%         \ccnu_thm_new:VVxx \l__ccnu_thm_style_tl \l__ccnu_thm_counter_tl
%           {#3} {#4}
%       }
%   }
% \cs_new:Npn \__ccnu_thm_redefine_style:n #1
%   {
%     \__ccnu_warning:nxx { redefine-theorem-style }
%       {#1} { \l__ccnu_thm_style_tl }
%     \tl_set:Nn \l__ccnu_thm_style_tl {#1}
%   }
% \__ccnu_msg_new:nn { redefine-theorem-style }
%   { Theorem~ style~ "#2"~ will~ be~ redefined~ as~ "#1". }
% \__ccnu_msg_new:nn { unknown-theorem-style }
%   { Theorem~ style~ "#1"~ is~ unknown. }
% \cs_new:Npn \ccnu_thm_new:nnnn #1#2#3#4
%   {
%     \__ccnu_thm_ntheorem_style:n {#1}
%     \__ccnu_thm_ntheorem_new:w   {#3} {#4} [#2]
%   }
% \cs_generate_variant:Nn \ccnu_thm_new:nnnn { VVxx }
% \cs_new:Npn \ccnu_thm_new_no_number:nnn #1#2#3
%   {
%     \__ccnu_thm_ntheorem_style:n {#1}
%     \__ccnu_thm_ntheorem_new:w   {#2} {#3}
%   }
% \cs_generate_variant:Nn \ccnu_thm_new_no_number:nnn { Vxx }
% \cs_new:Npn \ccnu_thm_set_qed:n         #1 { \theoremsymbol     {#1} }
% \cs_new:Npn \ccnu_thm_set_header_font:n #1 { \theoremheaderfont {#1} }
% \cs_new:Npn \ccnu_thm_set_body_font:n   #1 { \theorembodyfont   {#1} }
% \cs_generate_variant:Nn \ccnu_thm_set_qed:n         { V }
% \cs_generate_variant:Nn \ccnu_thm_set_header_font:n { V }
% \cs_generate_variant:Nn \ccnu_thm_set_body_font:n   { V }
\captionsetup [ figure ]
  {
    font     = small,
    labelsep = colon
  }
\captionsetup [ table  ]
  {
    % font     = { small, sf },
    font     = small,
    labelsep = colon
  }
\cs_set:Npn \thefigure
  { \__ccnu_arabic:n { figure } }
  % { \thechapter - \__ccnu_arabic:n { figure } }
\cs_set:Npn \thetable
  % { \thechapter - \__ccnu_arabic:n { table  } }
  { \__ccnu_arabic:n { table  } }
\clist_map_inline:nn
  {
    title, date, author, supervisor, department, major, student_id,
    school_id, clc, jel
  }
  { \tl_new:c { l__ccnu_info_ #1 _tl } }
\clist_new:N \l__ccnu_info_instructors_clist
\clist_new:N \l__ccnu_info_keywords_clist
\clist_map_inline:nn
  { title, author, supervisor, department, major }
  { \tl_new:c { l__ccnu_info_ #1 _en_tl } }
\clist_new:N \l__ccnu_info_keywords_en_clist
\int_new:N \l__ccnu_info_degree_type_int
\keys_define:nn { ccnu / info }
  {
    degree      .choices:nn  =
      { academic, professional }
      { \int_set_eq:NN \l__ccnu_info_degree_type_int \l_keys_choice_int },
    title       .tl_set:N    = \l__ccnu_info_title_tl,
    title*      .tl_set:N    = \l__ccnu_info_title_en_tl,
    subtitle    .tl_set:N    = \l__ccnu_info_subtitle_tl,
    year        .int_set:N   = \l__ccnu_info_year_int,
    month       .int_set:N   = \l__ccnu_info_month_int,
    level       .tl_set:N    = \l__ccnu_info_level_tl,
    author      .tl_set:N    = \l__ccnu_info_author_tl,
    author*     .tl_set:N    = \l__ccnu_info_author_en_tl,
    supervisor  .tl_set:N    = \l__ccnu_info_supervisor_tl,
    instructors .clist_set:N = \l__ccnu_info_instructors_clist,
    department  .tl_set:N    = \l__ccnu_info_department_tl,
    major       .tl_set:N    = \l__ccnu_info_major_tl,
    student-id  .tl_set:N    = \l__ccnu_info_student_id_tl,
    school-id   .tl_set:N    = \l__ccnu_info_school_id_tl,
    keywords    .clist_set:N = \l__ccnu_info_keywords_clist,
    keywords*   .clist_set:N = \l__ccnu_info_keywords_en_clist,
    clc         .tl_set:N    = \l__ccnu_info_clc_tl,
    jel         .tl_set:N    = \l__ccnu_info_jel_tl
  }
\tl_new:N    \l__ccnu_cover_logo_tl
\clist_new:N \l__ccnu_cover_logo_size_clist
\keys_define:nn { ccnu / style }
  {
    logo      .tl_set:N    = \l__ccnu_cover_logo_tl,
    logo-size .clist_set:N = \l__ccnu_cover_logo_size_clist
  }
\bool_new:N \l__ccnu_secret_bool
\tl_new:N \l__ccnu_info_secret_level_tl
\keys_define:nn { ccnu / info }
  {
    secret-level .choices:nn  =
      { none, i, ii, iii }
      {
        \int_compare:nTF { \l_keys_choice_int >= 2 }
          {
            \bool_set_true:N \l__ccnu_secret_bool
            \tl_set:Nn \l__ccnu_info_secret_level_tl
              {
                \clist_item:Nn \c__ccnu_secret_clist
                  { \l_keys_choice_int - 1 }
              }
          }
          { \bool_set_false:N \l__ccnu_secret_bool }
      },
    secret-level .value_required:n = true,
    secret-year  .tl_set:N = \l__ccnu_info_secret_year_tl
  }
\cs_new_protected:Npn \__ccnu_spread_box:nn #1#2
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \tl_map_inline:xn {#2} { ##1 \hfil } \unskip }
  }
\cs_new_protected:Npn \__ccnu_center_box:nn #1#2
  {
    \mode_leave_vertical:
    % \hbox_to_wd:nn {#1} { \hfil #2 \hfil }
    \hbox_to_wd:nn {#1} { \hfil \UnderlineCentered{6cm}{2mm}{#2} \hfil }
  }
\cs_generate_variant:Nn \__ccnu_center_box:nn  { Vn }
\cs_new:Npn \__ccnu_fixed_width_box:nn #1#2
  { \parbox {#1} {#2} }
\cs_new:Npn \__ccnu_fixed_width_center_box:nn #1#2
  { \parbox {#1} { \centering #2 } }
% 制作标题的下划线命令
% https://syvshc.github.io/2021-08-04-thesis-title/
\newlength\myheight
\newcommand\Mysavedprevdepth{}%
\newcommand\UnderlineCentered[3]{%
  \begin{adjustbox}{minipage=[t]{\dimexpr#1\relax},gstore~totalheight=\myheight, margin=0pt}%
    \centering\leavevmode#3\par\xdef\Mysavedprevdepth{\the\prevdepth}%
  \end{adjustbox}%
  \hspace*{-\dimexpr#1\relax}%
  \begin{adjustbox}{minipage=[t][\myheight]{\dimexpr#1\relax},margin=0pt}%
    \vphantom{Eg}\lower\dimexpr#2\relax\hbox to\hsize{\leaders\hrule height1pt\hfill\kern0pt}\par
    \kern-\dimexpr#2\relax
    \xleaders\vbox to\baselineskip {\vfill\hbox{\lower\dimexpr#2\relax\hbox to\hsize{\leaders\hrule height1pt\hfill\kern0pt}}\kern-\dimexpr#2\relax}\vfill
    \kern\Mysavedprevdepth
  \end{adjustbox}%
}%

% 慕子标题的下划线 LaTeX3 重写版本
\dim_new:N \l__ccnu_title_tmp_height_dim
\dim_new:N \l__ccnu_title_tmp_width_dim      % 储存单行的宽度
\dim_new:N \l__ccnu_title_tmp_max_width_dim

\dim_new:N \l__ccnu_title_single_line_max_width_dim
\dim_new:N \l__ccnu_title_multiline_max_width_dim
% \dim_new:N \l__ccnu_title_underline_max_width_dim
\dim_new:N \l__ccnu_title_left_right_extra_width_dim
\dim_new:N \l__ccnu_title_sep_width

\dim_set:Nn \l__ccnu_title_single_line_max_width_dim
  { 0.8 \textwidth }
\dim_set:Nn \l__ccnu_title_multiline_max_width_dim
  { 0.9 \textwidth }
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
        \l__ccnu_title_single_line_max_width_dim
        + 2 \l__ccnu_title_left_right_extra_width_dim
      }
      { 1pt }
  }
\cs_new:Npn \__ccnu_title_underline_multiline:
  {
    \rule [ -.3em ]
      {
        \l__ccnu_title_multiline_max_width_dim
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
    \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \l__ccnu_title_single_line_max_width_dim
    % 储存标题盒子的高度
    \__ccnu_set_to_totalheight:Nn \l__ccnu_title_tmp_height_dim 
      { \__ccnu_title_box_aux:n {#1} }
      % {
        % \parbox [t] { \l__ccnu_title_tmp_max_width_dim - 3em } { \centering #1 }
      % }
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
            \dim_set_eq:NN \l__ccnu_title_tmp_max_width_dim \l__ccnu_title_multiline_max_width_dim
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
                            \rlap { \__ccnu_title_underline_multiline: }\\[0.5em]
                            \dim_sub:Nn \l__ccnu_title_tmp_height_dim { \normalbaselineskip }
                            % 手动居中下划线
                          }
                      }
                  }
              }
            \hspace
              {
                  \l__ccnu_title_left_right_extra_width_dim
                % + .5 \l__ccnu_title_single_line_max_width_dim
                % - .5 \l__ccnu_title_multiline_max_width_dim
              }
            % 排版文本
            \parbox [t] 
              { \l__ccnu_title_tmp_max_width_dim }
              { \linespread{1.8}\selectfont \centering #1 }
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

% 处理副标题
\bool_new:N \l__ccnu_title_whether_subtitle_bool   % 是否开启副标题

% 检测是否有副标题
\cs_new:Npn \__ccnu_title_if_subtitle:
  {
    \tl_if_blank:VTF \l__ccnu_info_subtitle_tl
      { \bool_set_false:N \l__ccnu_title_whether_subtitle_bool }
      { \bool_set_true:N \l__ccnu_title_whether_subtitle_bool }
  }
\cs_new:Npn \__ccnu_type_title:
  {
    \bool_if:NTF \l__ccnu_title_whether_subtitle_bool
      {
        \begin{tblr}{
          colspec = {c},
          rows = {f, abovesep += 3pt},
        }
          \__ccnu_title_box:n { \tl_use:N \l__ccnu_info_title_tl }\\
          \__ccnu_title_box:n { —— \tl_use:N \l__ccnu_info_subtitle_tl }
        \end{tblr}
      }
      {
        \__ccnu_title_box:n { \tl_use:N \l__ccnu_info_title_tl }
      }
  }

%%%%%%%%%%%%%
\cs_new:Npn \__ccnu_fixed_width_center_underline_box:nn #1#2
  % { \parbox {#1} { \centering \uline{#2} } }
  { \parbox {#1} { \centering \UnderlineCentered{8cm}{1.4mm}{#2} } }
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
\cs_new:Npn \__ccnu_blank_underline:n #1
  { \rule [ -0.5 ex ] {#1} { 0.4 pt } }
\cs_new:Npn \__ccnu_line_spread:N #1
  { \linespread { \fp_use:N #1 } \selectfont }
\cs_new:Npn \__ccnu_line_spread:n #1
  { \linespread {#1} \selectfont }
\cs_new_protected:Npn \__ccnu_cover_id:
  {
    \__ccnu_fixed_width_box:nn { 120 pt }
      {
        \bool_if:NT \l__ccnu_secret_bool
          {
            \group_begin:
              \sffamily
              \__ccnu_cover_id_aux:n { secret_level }
              \c__ccnu_name_secret_star_tl
              \l__ccnu_info_secret_year_tl
            \group_end:
            \par
          }
        \__ccnu_cover_id_aux:n { school_id  } \par
        \__ccnu_cover_id_aux:n { student_id }
      }
    \hbox_to_wd:nn { -24 pt } { }
  }
\cs_new:Npn \__ccnu_cover_id_aux:n #1
  {
    \tl_use:c { c__ccnu_name_ #1 _tl }
    \c__ccnu_fwid_colon_tl
    \tl_use:c { l__ccnu_info_ #1 _tl }
  }
\cs_new_protected:Npn \__ccnu_cover_logo:
  {
    \clist_pop:NN   \l__ccnu_cover_logo_size_clist \l__ccnu_tmpa_tl
    \clist_pop:NNTF \l__ccnu_cover_logo_size_clist \l__ccnu_tmpb_tl
      {
        \tl_if_empty:NTF \l__ccnu_tmpa_tl
          { \includegraphics [ height = \l__ccnu_tmpb_tl ] }
          {
            \includegraphics
              [ width  = \l__ccnu_tmpa_tl, height = \l__ccnu_tmpb_tl ]
          }
      }
      { \includegraphics [ width = \l__ccnu_tmpa_tl ] }
    { \l__ccnu_cover_logo_tl }
  }
\cs_new_protected:Npn \__ccnu_cover_type:
  {
    \tl_set:Nx \l__ccnu_tmpa_tl
      {
        \clist_item:Nn \c__ccnu_thesis_type_clist
          { \g__ccnu_thesis_type_int }
      }
    \__ccnu_spread_box:nn { 0.45 \textwidth } { \l__ccnu_tmpa_tl }
  }
\cs_new_protected:Npn \__ccnu_cover_degree:
  {
    \int_compare:nT { \g__ccnu_thesis_type_int != 3 }
      {
        \c__ccnu_fwid_left_paren_tl
        \clist_item:Nn \c__ccnu_degree_type_clist
          { \l__ccnu_info_degree_type_int }
        \c__ccnu_fwid_right_paren_tl
      }
  }
% 复制settowidth命令
\cs_set_eq:NN \ccnu_set_to_width:Nn \settowidth
\dim_new:N \l__ccnu_date_zero_radius_dim
% \ccnu_set_to_width:Nn \l__ccnu_date_zero_radius_dim {二}

% 将输入的年份转化为封面底下的年份
\int_new:N \l__ccnu_info_year_single_digit_int
\int_new:N \l__ccnu_info_year_ten_digit_int

\cs_new:Npn \__ccnu_info_year_set:
  {
    % 将数字减去2000
    \int_set:Nn \l_tmpa_int { \l__ccnu_info_year_int - 2000}
    % 取十位数
    \int_set:Nn \l__ccnu_info_year_ten_digit_int
      {
        \int_div_truncate:nn { \l_tmpa_int } { 10 }
      }
    % 取个位数
    \int_set:Nn \l__ccnu_info_year_single_digit_int
      {
        \l_tmpa_int - 10 * \l__ccnu_info_year_ten_digit_int
      }
    % 将两个数字转化为中文
    \zhnumber { \int_use:N \l__ccnu_info_year_ten_digit_int }
    \,
    \zhnumber { \int_use:N \l__ccnu_info_year_single_digit_int }
  }

\cs_new_protected:Npn \__ccnu_cover_info:
  {
    \tl_set:Nx \l__ccnu_cover_info_left_width_tl
      {
        \int_case:nn { \l__ccnu_info_degree_type_int }
          {
            { 1 } { 4 em }
            { 2 } { 9 em }
          }
      }
    % 检测是否有副标题
    \__ccnu_title_if_subtitle:
    \begin{tikzpicture}[remember~picture, overlay]
      \node[anchor = north] (upperinfo) at 
        ([shift={(0, -3em)}]current~page~text~area.north) 
        {
          \begin{varwidth}{\hsize}
            \begin{tblr}
              {
                row{2} = {abovesep += 1em},
                column{1} = { 0.5\textwidth, l},
                column{2} = { 0.5\textwidth, l},
              }
              \textbf{\zihao{-3} 分类号 \underline{\hspace*{8em}}} & \textbf{\zihao{-3} 论文选题类型 \underline{\hspace*{6em}}} \\
              \textbf{\zihao{-3} U\,\,D\,\,C \underline{\hspace*{8em}} } & \textbf{\zihao{-3} 编号 \underline{\hspace*{10em}}}
            \end{tblr}
          \end{varwidth}
        };
      \node[anchor = south] (date) at (current~page~text~area.south) 
        {
          \zihao{3} \bfseries
          \zhdigits
            { \int_use:N \l__ccnu_info_year_int}
          \, 年 \,
          \zhnumber
            { \int_use:N \l__ccnu_info_month_int }
          \,
          月
        };
      \node (logo) at 
        (
          [shift = {(0 , -0.3\paperheight)}]current~page.north
        )
        { \includegraphics[height = 3.3em, width = 0.4\textwidth]{logo/ccnulogo.png} };
      \node (type) at 
        (
          [shift = {(0 , -0.3em-0.39\paperheight)}]current~page.north
        )
        { \zihao{-1} \sffamily 本科毕业论文（设计）};
      \node[] (titlecontent) at 
        (
          [shift = {(0, -1.5em)}]
          current~page.center
        ) 
        {
          \zihao{-2} \bfseries 
          \__ccnu_type_title:
        };
      % \node[] (titlelabel) at ([shift = {(-0.15\paperheight, 0)}]current~page.center) { \zihao{-1} \textbf{题\,\,\,目}};
    \end{tikzpicture}

    \begin{minipage} [ c ] { \textwidth }
      \centering \zihao { -3 }  \bfseries
      \clist_set:Nx \l__ccnu_tmpa_clist
        {
          \c__ccnu_name_department_tl,
          \int_case:nn { \l__ccnu_info_degree_type_int }
            {
              { 1 } { \c__ccnu_name_major_tl              }
              { 2 } { \c__ccnu_name_major_professional_tl }
            },
          \c__ccnu_name_level_tl,
          \c__ccnu_name_author_tl,
          \c__ccnu_name_student_id_tl,
          \c__ccnu_name_supervisor_tl,
          % \c__ccnu_name_date_tl,
        }
      \clist_set:Nx \l__ccnu_tmpb_clist
        {
          { \l__ccnu_info_department_tl },
          { \l__ccnu_info_major_tl      },
          { \l__ccnu_info_level_tl      },
          { \l__ccnu_info_author_tl     },
          { \l__ccnu_info_student_id_tl },
          { \l__ccnu_info_supervisor_tl },
          % { \l__ccnu_info_date_tl       }
        }
      \__ccnu_get_max_text_width:NN \l__ccnu_tmpb_dim \l__ccnu_tmpb_clist
      \bool_until_do:nn
        { \clist_if_empty_p:N \l__ccnu_tmpa_clist }
        {
          \clist_pop:NN \l__ccnu_tmpa_clist \l__ccnu_tmpa_tl
          \clist_pop:NN \l__ccnu_tmpb_clist \l__ccnu_tmpb_tl
          \__ccnu_spread_box:nn
            { \l__ccnu_cover_info_left_width_tl }
            { \l__ccnu_tmpa_tl }
          % \c__ccnu_fwid_colon_tl
          \hspace*{1em}
          \__ccnu_center_box:Vn \l__ccnu_tmpb_dim { \l__ccnu_tmpb_tl }
          \skip_vertical:n { 1 ex }
        }
    \end{minipage}
  }
\tl_new:N \l__ccnu_cover_info_left_width_tl
\cs_new_protected:Npn \__ccnu_cover_signature:N #1
  {
    \clist_map_inline:Nn #1
      {
        ##1 \c__ccnu_fwid_colon_tl
        % \__ccnu_blank_underline:n { 6 em }
        \__ccnu_quad:
      }
  }
\DeclareObjectType { ccnu / cover } { \c_zero_int }
\NewDocumentCommand \DeclareCoverTemplate { m m }
  { \ccnu_cover_declare_template:nn {#1} {#2} }
\cs_new_protected:Npn \ccnu_cover_declare_template:nn #1#2
  {
    \tl_set:Nn \l__ccnu_cover_template_tl {#1}
    \__ccnu_cover_declare_template_interface:nx {#1}
      {
        format      : tokenlist,
        top-skip    : skip,
        bottom-skip : skip,
        \clist_map_function:nN {#2} \__ccnu_cover_key_type:n
      }
    \tl_new:c   { l__ccnu_cover / #1 / format_tl   }
    \skip_new:c { l__ccnu_cover / #1 / top_skip    }
    \skip_new:c { l__ccnu_cover / #1 / bottom_skip }
    \clist_map_inline:nn {#2}
      {
        \tl_new:c   { l__ccnu_cover / #1 / ##1 / content_tl  }
        \tl_new:c   { l__ccnu_cover / #1 / ##1 / format_tl   }
        \skip_new:c { l__ccnu_cover / #1 / ##1 / bottom_skip }
      }
    \__ccnu_cover_declare_template_code:nxn {#1}
      {
        format      = \exp_not:c { l__ccnu_cover / #1 / format_tl   },
        top-skip    = \use:c     { l__ccnu_cover / #1 / top_skip    },
        bottom-skip = \use:c     { l__ccnu_cover / #1 / bottom_skip },
        \clist_map_function:nN {#2} \__ccnu_cover_key_binding:n
      }
      {
        \AssignTemplateKeys
        \tl_use:c       { l__ccnu_cover / #1 / format_tl }
        \__ccnu_vspace:c { l__ccnu_cover / #1 / top_skip  }
        \clist_map_inline:nn {#2}
          {
            \use:c { __ccnu_cover / #1 / ####1 / align:n }
              {
                \tl_use:c { l__ccnu_cover / #1 / ####1 / format_tl  }
                \tl_use:c { l__ccnu_cover / #1 / ####1 / content_tl }
                \par
              }
            \__ccnu_vspace:c { l__ccnu_cover / #1 / ####1 / bottom_skip }
          }
        \__ccnu_vspace:c { l__ccnu_cover / #1 / bottom_skip }
      }
  }
\tl_new:N \l__ccnu_cover_template_tl
\cs_new_protected:Npn \__ccnu_cover_declare_template_interface:nn #1#2
  { \DeclareTemplateInterface { ccnu / cover } {#1} { \c_zero_int } {#2} }
\cs_new_protected:Npn \__ccnu_cover_declare_template_code:nnn #1#2#3
  { \DeclareTemplateCode { ccnu / cover } {#1} { \c_zero_int } {#2} {#3} }
\cs_generate_variant:Nn \__ccnu_cover_declare_template_interface:nn { nx  }
\cs_generate_variant:Nn \__ccnu_cover_declare_template_code:nnn     { nxn }
\cs_new:Npn \__ccnu_cover_key_type:n #1
  {
    #1 / content     : tokenlist,
    #1 / format      : tokenlist,
    #1 / bottom-skip : skip,
    #1 / align       : choice { left, right, center, normal } = normal,
  }
\cs_new:Npn \__ccnu_cover_key_binding:n #1
  {
    #1 / content     =
      \exp_not:c
        { l__ccnu_cover / \l__ccnu_cover_template_tl / #1 / content_tl  },
    #1 / format      =
      \exp_not:c
        { l__ccnu_cover / \l__ccnu_cover_template_tl / #1 / format_tl   },
    #1 / bottom-skip =
      \exp_not:c
        { l__ccnu_cover / \l__ccnu_cover_template_tl / #1 / bottom_skip },
    #1 / align       =
      {
        left   =
          \exp_not:N \cs_set_protected:cpn
            { __ccnu_cover / \l__ccnu_cover_template_tl / #1 / align:n }
            \exp_not:n {##1}
            {
              \exp_not:n
                {
                  \group_begin:
                    \flushleft ##1 \endflushleft
                  \group_end:
                }
            },
        right  =
          \exp_not:N \cs_set_protected:cpn
            { __ccnu_cover / \l__ccnu_cover_template_tl / #1 / align:n }
            \exp_not:n {##1}
            {
              \exp_not:n
                {
                  \group_begin:
                    \flushright ##1 \endflushright
                  \group_end:
                }
            },
        center =
          \exp_not:N \cs_set_protected:cpn
            { __ccnu_cover / \l__ccnu_cover_template_tl / #1 / align:n }
            \exp_not:n {##1}
            {
              \exp_not:n
                {
                  \group_begin:
                    \center ##1 \endcenter
                  \group_end:
                }
            },
        normal =
          \exp_not:N \cs_set_protected:cpn
            { __ccnu_cover / \l__ccnu_cover_template_tl / #1 / align:n }
            \exp_not:n {##1}
            { \exp_not:n { \group_begin: ##1 \group_end: } }
      },
  }
\NewDocumentCommand \makecoveri { }
  {
    \thispagestyle { empty }
    \UseInstance { ccnu / cover } { cover-i-default }
  }
\NewDocumentCommand \makecoverii { }
  {
    \thispagestyle { empty }
    \clist_if_empty:NF \l__ccnu_info_instructors_clist
      { \UseInstance { ccnu / cover } { cover-ii-default } }
  }
% \NewDocumentCommand \makecoveriii { }
  {
    % \group_begin:
    % \cleardoublepage
    % \tl_if_empty:NTF \l__ccnu_declaration_page_tl
    %   {
    %     \thispagestyle { empty }
    %     % \keys_set:nn { ccnu / style }{ fullwidth-stop = false }
    %     \newgeometry
    %       { 
    %         left   = 2.85cm,
    %         right  = 2.45cm,
    %         top    = 3cm,
    %         bottom = 2.5cm
    %       }
    %     \UseInstance { ccnu / cover } { cover-iii-default }
    %     \restoregeometry
    %   }
    %   { \includepdf { \l__ccnu_declaration_page_tl } }
    % % \group_end:
    
  % }
\DeclareCoverTemplate { cover-i   }
  { id, logo, type, degree, title, title-en, info }
\DeclareCoverTemplate { cover-ii  } { title, name-list }
\DeclareCoverTemplate { cover-iii }
  {
    originality-decl-name,
    originality-decl-text,
    originality-decl-sig,
    authorization-decl-name,
    authorization-decl-text,
    authorization-decl-sig
  }
\DeclareInstance { ccnu / cover } { cover-i-default } { cover-i }
  {
    bottom-skip            = 0 pt plus 1.5 fill,
    % id       / content     = \__ccnu_cover_id:,
    % logo     / content     = \__ccnu_cover_logo:,
    % type     / content     = \__ccnu_cover_type:,
    degree   / content     = \__ccnu_cover_degree:,
    % title    / content     =
      % \__ccnu_fixed_width_center_box:nn
      % \__ccnu_fixed_width_center_underline_box:nn
        % { 0.9 \textwidth } { \l__ccnu_info_title_tl },
    % title-en / content     =
      % \__ccnu_fixed_width_center_box:nn
        % { 0.9 \textwidth } { \l__ccnu_info_title_en_tl },
    info     / content     = \__ccnu_cover_info:,
    % id       / format      = \zihao { -5 },
    % type     / format      = \zihao {  -1 }\sffamily ,
    degree   / format      = \zihao {  4 },
    % title    / format      = \zihao { -2 } \bfseries,
    % title-en / format      = \__ccnu_line_spread:n { 1.2 } \zihao { 4 } \bfseries,
    id       / bottom-skip = 0 pt plus 1.6 fill,
    logo     / bottom-skip = 0 pt plus 0.3 fill,
    type     / bottom-skip = -18 pt,
    degree   / bottom-skip = 0 pt plus 0.8 fill,
    title-en / bottom-skip = 0 pt plus 2.5 fill,
    id       / align       = right,
    logo     / align       = center,
    type     / align       = center,
    degree   / align       = center,
    title    / align       = center,
    title-en / align       = center,
    info     / align       = center,
  }
\DeclareInstance { ccnu / cover } { cover-ii-default } { cover-ii }
  {
    title     / content =
      \__ccnu_spread_box:nn { 7 em } { \c__ccnu_name_instructors_tl },
    name-list / content =
      \clist_use:Nn \l__ccnu_info_instructors_clist { \par },
    title     / format  = \zihao { 2 } \sffamily,
    name-list / format  = \large,
    title     / align   = center,
    name-list / align   = center,
  }
\DeclareInstance { ccnu / cover } { cover-iii-default } { cover-iii }
  {
    format                                =
      \__ccnu_line_spread:n { 1.8 },
    top-skip                              = 0 pt plus 0.2 fill,
    bottom-skip                           = 0 pt plus 2.5 fill,
    originality-decl-name   / content     = \c__ccnu_name_orig_decl_tl,
    originality-decl-text   / content     = 
      {
        \c__ccnu_orig_decl_text_tl
      },
    originality-decl-sig    / content     =
      % { \__ccnu_cover_signature:N \c__ccnu_orig_decl_sign_clist \hspace*{3em}年\hspace*{1.5em}月\hspace*{1.5em}日},
      { \ttfamily 学位论文作者签名\c__ccnu_fwid_colon_tl \hspace*{7em} 日期\c__ccnu_fwid_colon_tl \hspace*{3em}年\hspace*{1.5em}月\hspace*{1.5em}日 },
    authorization-decl-name / content     = 
      {
        \c__ccnu_name_auth_decl_tl
      },
    authorization-decl-text / content     = \c__ccnu_auth_decl_text_tl,
    originality-decl-sig    / format     =
      \zihao{ -4 },
    authorization-decl-sig  / content     =
      % \__ccnu_cover_signature:N \c__ccnu_auth_decl_sign_clist,
      {
        \vspace*{1.9cm}
        本学位论文属于 \par

        1、保密 \quad $\square$，在 \underline{\hspace*{2.5em}}年解密后适用本授权书。\par

        2、不保密 \quad $\square$。\par

        （请在以上相应方框内打“√”）\par

        \ttfamily 学位论文作者签名\c__ccnu_fwid_colon_tl \hspace*{7em} 日期\c__ccnu_fwid_colon_tl \hspace*{3em}年\hspace*{1.5em}月\hspace*{1.5em}日 \par
        导师签名\c__ccnu_fwid_colon_tl \hspace*{11em} 日期\c__ccnu_fwid_colon_tl \hspace*{3em}年\hspace*{1.5em}月\hspace*{1.5em}日 
      },
    originality-decl-name   / format      =
      \__ccnu_line_spread:n { 1.2 } \zihao { -2 } \bfseries \ccnukaishu ,
    authorization-decl-name / format      =
      \__ccnu_line_spread:n { 1.2 } \zihao { -2 } \bfseries \ccnukaishu,
    originality-decl-name   / bottom-skip = 0.9 cm,
    originality-decl-text   / bottom-skip = 0.5\baselineskip,
    originality-decl-sig    / bottom-skip = 0 pt plus 2.5 fill,
    % authorization-decl-name / bottom-skip = 0.4 cm,
    % authorization-decl-text / bottom-skip = 0.2 cm,
    originality-decl-name   / align       = center,
    originality-decl-sig    / align       = normal,
    authorization-decl-name / align       = center,
    authorization-decl-sig  / align       = normal,
  }
\bool_new:N \l__ccnu_auto_make_cover_bool
\tl_new:N   \l__ccnu_declaration_page_tl
\keys_define:nn { ccnu / style }
  {
    auto-make-cover  .bool_set:N = \l__ccnu_auto_make_cover_bool,
    auto-make-cover  .default:n  = true,
    declaration-page .code:n     =
      {
        \tl_set_eq:NN \l__ccnu_declaration_page_tl \l_keys_value_tl
        \RequirePackage { pdfpages }
      },
  }
\ctex_after_end_preamble:n
  {
    \bool_if:NT \l__ccnu_auto_make_cover_bool
      {
        \begin{titlepage}
          \makecoveri
          \newpage 
          % \makecoveriii
          \pagestyle { empty }
          \begin{tikzpicture}[remember~picture, overlay]
            \node at (current~page.center) 
              {
                \includegraphics
                  [ width = \Gm@layoutwidth, height = \Gm@layoutheight ]
                    { figures / Originality_Copyright.pdf }
              };
          \end{tikzpicture}
        \end{titlepage}
      }
  }
% \__ccnu_gadd_ltxhook:nn { enddocument }
%   { \bool_if:NT \l__ccnu_auto_make_cover_bool { \makecoveriii } }
\keys_set:nn { ctex }
  {
    contentsname   = \c__ccnu_name_toc_tl,
    listfigurename = \c__ccnu_name_lof_tl,
    listtablename  = \c__ccnu_name_lot_tl,
    chapter / tocline =
      {
        \normalfont 
        % \sffamily
        \CTEXnumberline {#1} #2
      },
    section / tocline =
      {
        \normalfont
        \CTEXnumberline {#1} #2
      },
    subsection / tocline =
      {
        % \ccnu@kai
        \normalfont
        \CTEXnumberline {#1} #2
      }
  }
\__ccnu_patch_cmd:Nnn \tableofcontents
  {
    \chapter*{\contentsname
      \@mkboth{\MakeUppercase\contentsname}
              {\MakeUppercase\contentsname}}
  }
  { \__ccnu_chapter_no_toc:V \contentsname }
\__ccnu_patch_cmd:Nnn \listoffigures
  {
    \chapter*{\listfigurename}
    \@mkboth{\MakeUppercase\listfigurename}
            {\MakeUppercase\listfigurename}
  }
  { \__ccnu_chapter:V \listfigurename }
\__ccnu_patch_cmd:Nnn \listoftables
  {
    \chapter*{\listtablename}
    \@mkboth{\MakeUppercase\listtablename}
            {\MakeUppercase\listtablename}
  }
  { \__ccnu_chapter:V \listtablename }
% 单独调整摘要页
\cs_new_protected:Npn \__ccnu_abstract_env:n #1
  {
    \group_begin:
      \ctexset { chapter / numbering = false }
      % \chapter {#1}
      \addcontentsline{toc}{chapter}{ \normalfont #1}
      \__ccnu_chapter_header:n {#1}
    \group_end:
  }
\cs_generate_variant:Nn \__ccnu_abstract_env:n { V }
\NewDocumentEnvironment { abstract  } { }
  { 
    \__ccnu_abstract_begin: 
    \addcontentsline{toc}{chapter}{\normalfont  \c__ccnu_name_keywords_tl  }   
  } { \__ccnu_abstract_end:      }
\NewDocumentEnvironment { abstract* } { }
  { 
    \__ccnu_abstract_en_begin: 
    \addcontentsline{toc}{chapter}{\normalfont  \c__ccnu_name_keywords_en_tl  }
  } { \__ccnu_abstract_en_end:   }
\cs_new_protected:Npn \__ccnu_abstract_begin:
  { 
    \newpage
    \setcounter{page}{1}
    \__ccnu_abstract_env:V \c__ccnu_name_abstract_tl
    { \bfseries \c__ccnu_name_abstract_tl : } \c_space_tl  
  }
\cs_new_protected:Npn \__ccnu_abstract_en_begin:
  { 
    \bigskip
    \textbf{ Title: } \c_space_tl \l__ccnu_info_title_en_tl \par
    \medskip
    \__ccnu_abstract_env:V \c__ccnu_name_abstract_en_tl 
    { \bfseries \c__ccnu_name_abstract_en_tl : \c_space_tl} 
  }
\cs_new_protected:Npn \__ccnu_abstract_end:
  {
    \__ccnu_keywords:nNn
      { \bfseries \c__ccnu_name_keywords_tl :
      \c_space_tl
      }
      \l__ccnu_info_keywords_clist 
      % { \c__ccnu_fwid_semicolon_tl }
      { \qquad }
    % \tl_if_empty:NF \l__ccnu_info_clc_tl
    %   {
    %     \__ccnu_clc_jel:nn
    %       { \sffamily \c__ccnu_name_clc_tl \c__ccnu_fwid_colon_tl }
    %       { \l__ccnu_info_clc_tl }
    %   }
  }
\cs_new_protected:Npn \__ccnu_abstract_en_end:
  {
    \__ccnu_keywords:nNn
      { \bfseries \c__ccnu_name_keywords_en_tl :
      % \__ccnu_quad: 
      \c_space_tl
      }
      \l__ccnu_info_keywords_en_clist { \qquad }
    \tl_if_empty:NTF \l__ccnu_info_jel_tl
      {
        \tl_if_empty:NF \l__ccnu_info_clc_tl
          {
            \__ccnu_clc_jel:nn
              { \bfseries \c__ccnu_name_clc_en_tl \__ccnu_quad: }
              { \l__ccnu_info_clc_tl }
          }
      }
      {
        \__ccnu_clc_jel:nn
          { \bfseries \c__ccnu_name_jel_en_tl \__ccnu_quad: }
          { \l__ccnu_info_jel_tl }
      }
  }
\cs_new_protected:Npn \__ccnu_keywords:nNn #1#2#3
  {
    % \par \mode_leave_vertical: 
    \par 
    % \noindent
    \__ccnu_get_text_width:Nn \l__ccnu_tmpa_dim {#1}
    \group_begin: #1 \group_end:
    % \parbox [t] { \dim_eval:n { \textwidth - \parindent - \l__ccnu_tmpa_dim }  }
    %   {
    %     \clist_use:Nn #2 {#3} \par
    %     \cs_gset:Npx \__ccnu_keywords_prevdepth: { \dim_use:N \tex_prevdepth:D }
    %   }
    \parbox [t] { \dim_eval:n { \textwidth - \l__ccnu_tmpa_dim }  }
      {
        \begin{varwidth}[t]{\hsize}
          \clist_use:Nn #2 {#3} \par
          \cs_gset:Npx \__ccnu_keywords_prevdepth: { \dim_use:N \tex_prevdepth:D }
        \end{varwidth}
      }
    % \raisebox{-.5\baselineskip}
    %   {
    %     \begin{varwidth}
    %       { \dim_eval:n { \textwidth - \l__ccnu_tmpa_dim } }
    %       \clist_use:Nn #2 {#3} \par
    %       \cs_gset:Npx \__ccnu_keywords_prevdepth: { \dim_use:N \tex_prevdepth:D }
    %     \end{varwidth}
    %   }
  }
\cs_new_protected:Npn \__ccnu_clc_jel:nn #1#2
  {
    \par \tex_prevdepth:D \__ccnu_keywords_prevdepth: \noindent
    \group_begin: #1 \group_end:
    #2
  }
\NewDocumentEnvironment { notation } { O { l p { 7.5 cm } } }
  {
    \keys_set:nn { ctex }
      {
        chapter = {
              format = \zihao{-2} \normalfont \bfseries \centering
            }
      }
    \__ccnu_notation_begin:
    \group_begin:
      \__ccnu_notation_long_table_setup:
      \longtable {#1}
  }
  {
      \endlongtable
    \group_end:
  }
\cs_new_protected:Npn \__ccnu_notation_begin:
  {
    \__ccnu_chapter:V \c__ccnu_name_notation_tl
  }
\cs_new_protected:Npn \__ccnu_notation_long_table_setup:
  {
    \dim_set_eq:NN \LTpre  \c_zero_dim
    \dim_set_eq:NN \LTpost \c_zero_dim
  }
\bool_new:N \l__ccnu_bibtex_bool
\tl_new:N \l__ccnu_bib_style_tl
\tl_new:N \l__ccnu_bib_gb_style_tl
\tl_new:N \l__ccnu_cite_style_tl
\clist_new:N \l__ccnu_bib_resource_clist
\keys_define:nn { ccnu / style }
  {
    bib-backend .choice:,
    bib-backend .value_required:n = true,
    bib-backend / bibtex   .code:n =
      { \bool_set_true:N  \l__ccnu_bibtex_bool },
    bib-backend / biblatex .code:n =
      { \bool_set_false:N \l__ccnu_bibtex_bool },
    bib-style .choice:,
    bib-style .value_required:n = true,
    bib-style / numerical    .code:n =
      {
        \tl_set:Nn  \l__ccnu_bib_gb_style_tl { numerical  }
        \tl_clear:N \l__ccnu_bib_style_tl
      },
    bib-style / author-year .code:n =
      {
        \tl_set:Nn  \l__ccnu_bib_gb_style_tl { author-year }
        \tl_clear:N \l__ccnu_bib_style_tl
      },
    bib-style / unknown     .code:n =
      {
        \tl_set_eq:NN \l__ccnu_bib_style_tl \l_keys_value_tl
        \tl_clear:N   \l__ccnu_bib_gb_style_tl
      },
    cite-style .tl_set:N = \l__ccnu_cite_style_tl,
    bib-resource .clist_set:N = \l__ccnu_bib_resource_clist
  }
\ctex_at_end_preamble:n
  {
    \bool_if:NT \l__ccnu_bibtex_bool
      {
        \tl_if_empty:NTF \l__ccnu_bib_style_tl
          {
            \RequirePackage [ sort & compress ] { gbt7714 }
            \exp_args:No \bibliographystyle { gbt7714- \l__ccnu_bib_gb_style_tl }
          }
          {
            \RequirePackage [ sort & compress ] { natbib }
            \exp_args:NV \bibliographystyle \l__ccnu_bib_style_tl
          }
        \__ccnu_bibtex_setup:
      }
  }
\__ccnu_gadd_ltxhook:nn { env/document/begin }
  {
    \bool_if:NF \l__ccnu_bibtex_bool
      {
        \__ccnu_biblatex_pre_setup:
        \RequirePackage { biblatex }
        \__ccnu_biblatex_post_setup:
      }
  }
\cs_new_protected:Npn \__ccnu_bibtex_setup:
  {
    \tl_if_eq:VnTF \l__ccnu_bib_gb_style_tl { numerical }
      {
        \exp_args:NNx \DeclareRobustCommand \parencite
          { \exp_args:No \exp_not:o { \cs:w cite ~ \cs_end: } }
        \exp_args:Nc \ctex_patch_cmd:Nnn { parencite ~ }
          { \begingroup }
          { \begingroup \bibstyle@numbers }
      }
      { \cs_set_eq:NN \parencite \cite }
    \tl_if_empty:NF \l__ccnu_cite_style_tl
      { \exp_args:NV \citestyle \l__ccnu_cite_style_tl }
    \ctex_patch_cmd:Nnn \NAT@citexnum
      { - \NAT@penalty }
      { \textendash \NAT@penalty }
    \cs_set:Npn \bibchapter { \__ccnu_chapter:V \bibname }
    \NewDocumentCommand \printbibliography { o }
      {
        \exp_args:NV \bibliography \l__ccnu_bib_resource_clist
        \IfValueT {##1}
          { \__ccnu_warning:nn { invalid-option-in-bibtex } {##1} }
      }
  }
\__ccnu_msg_new:nn { invalid-option-in-bibtex }
  { Option(s)~ "#1"~ are~ invalid~ in~ BibTeX. }
\bool_if:NF \l__ccnu_bibtex_bool
  {
    \NewDocumentCommand \addbibresource { m }
      { \clist_gput_right:Nn \l__ccnu_bib_resource_clist {#1} }
  }
\cs_new_protected:Npn \__ccnu_biblatex_pre_setup:
  {
    \cs_undefine:N \addbibresource
    \clist_new:N \l__ccnu_biblatex_options_clist
    \clist_put_right:Nn \l__ccnu_biblatex_options_clist { hyperref = manual }
    \clist_put_right:Nx \l__ccnu_biblatex_options_clist
      {
        style =
        \tl_if_empty:NTF \l__ccnu_bib_style_tl
          {
            \str_if_eq:VnTF \l__ccnu_bib_gb_style_tl { numerical }
              { gb7714-2015 } { gb7714-2015ay }
          }
          { \l__ccnu_bib_style_tl }
      }
    % \tl_if_empty:NF \l__ccnu_cite_style_tl
    %   {
    %     \clist_put_right:Nx \l__ccnu_biblatex_options_clist
    %       { citestyle = \l__ccnu_cite_style_tl }
    %   }
    \clist_put_right:Nn \l__ccnu_biblatex_options_clist
      {
        backend      = biber,
        style        = CCNUthesis
      }
    \exp_args:NV \PassOptionsToPackage \l__ccnu_biblatex_options_clist
      { biblatex }
  }
\cs_new_protected:Npn \__ccnu_biblatex_post_setup:
  {
    \clist_map_function:NN \l__ccnu_bib_resource_clist \addbibresource
    \__ccnu_biblatex_allow_url_break:
    \__ccnu_biblatex_use_en_dash:
    \defbibheading { bibliography } [ \bibname ] { \__ccnu_chapter:n {##1} }
    % 修改\parencite，使得\parencite[foo]{label}的效果为 [x, foo]
    % https://github.com/hushidong/biblatex-gb7714-2015/issues/120#issuecomment-1063764782
    \DeclareCiteCommand{\parencite}
      {
        \mkbibleftborder\usebibmacro{cite:init}
        \usebibmacro{prenote}
      }
      {
        \usebibmacro{citeindex}
        \usebibmacro{cite:comp}
      }
      {}
      {
        \usebibmacro{cite:dump}\setunit{\addcomma\addspace}\printfield{postnote}\mkbibrightborder
      }
    \DeclareCiteCommand{\cite}[\mkbibsuperscript]  % 利用mkbibsuperbracket添加方括号
      {
        \mkbibleftborder\usebibmacro{cite:init}
        \usebibmacro{prenote}
      }
      {
        \usebibmacro{citeindex}
        \usebibmacro{cite:comp}
      }
      {}
      {
        \usebibmacro{cite:dump}\setunit{\addcomma\addspace}
        \printfield{postnote}\mkbibrightborder
      }
    % 修改 \printbibliography
    \cs_set_eq:NN \__ccnu_printbibliography_old \printbibliography
    \cs_new:Npn \__ccnu_printbibliography:n ##1 
      {
        \__ccnu_printbibliography_old [ ##1 ] 
      }
    \RenewDocumentCommand { \printbibliography } { O{} } 
      {
        \group_begin:
          \ctexset{ chapter / afterskip = 2.7em }
          \sloppy
          \__ccnu_printbibliography:n { ##1 }
        \group_end:
      }
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
    hyperlink / border .code:n =
      { \ccnu_hyperref_setup:n { colorlinks = false } },
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
\keys_define:nn { ccnu }
  {
    info  .meta:nn = { ccnu / info  } {#1},
    style .meta:nn = { ccnu / style } {#1}
  }
\keys_set:nn { ccnu }
  {
    style   / font            = times,
    style   / cjk-font        = fandol,
    style   / font-size       = -4,
    style   / fullwidth-stop  = false,
    style   / auto-make-cover = true,
    style   / logo            = { ccnulogo.png },
    style   / logo-size       = { 0.43 \textwidth , 4em},
    style   / hyperlink       = color,
    style   / hyperlink-color = default,
    style   / bib-style       = numerical,
    info    / degree          = academic,
    info    / secret-level    = none,
    info    / school-id       = { 10246 },
    info    / year            = { \int_use:N \c_sys_year_int },
    info    / month           = { \int_use:N \c_sys_month_int },
  }

% \newtheorem* { proof       } { \c__ccnu_name_proof_tl      }
% \newtheorem  { axiom       } { \c__ccnu_name_axiom_tl      }
% \newtheorem  { corollary   } { \c__ccnu_name_corollary_tl  }
% \newtheorem  { definition  } { \c__ccnu_name_definition_tl }
% \newtheorem  { example     } { \c__ccnu_name_example_tl    }
% \newtheorem  { lemma       } { \c__ccnu_name_lemma_tl      }
% \newtheorem  { theorem     } { \c__ccnu_name_theorem_tl    }

% 去掉.号，但只能通过新定义style的方式进行
\declaretheoremstyle
  [
    headpunct = {},
    postheadspace = { 0.5em },
  ]{ccnustyle}
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
        style = ccnustyle ,
        name =  \clist_item:nn {#1} {1} ,
        refname = \clist_item:nn {#1} {2} ,
        sibling = \clist_item:nn {#1} {3} ,
      ]
      { \clist_item:nn {#1} {4} }
  }
\clist_map_function:nN
  {
    { 定理, 定理, chapter, theorem },
    { 例, 例, chapter, example },
    { 问题, 问题, chapter, question },
  }\__xdyymath_declare_theorem_with_counter_within:n

\clist_map_function:nN
  {
    { 定义, 定义, theorem, definition },
    { 性质, 性质, theorem, property },
    { 命题, 命题, theorem, proposition },
    { 推论, 推论, theorem, corollary },
    { 引理, 引理, theorem, lemma },
    { 公理, 公理, theorem, axiom },
    { 反例, 反例, theorem, antiexample },
    { 猜想, 猜想, theorem, conjecture },
    { 断言, 断言, theorem, claim },
    { 注, 注, theorem, remark },
  }\__xdyymath_declare_theorem_with_counter_sibling:n


\RenewDocumentEnvironment { proof } { O{\proofname} +b }
  {
    \par
    \pushQED { \qed }
    \normalfont \topsep6 \p@ \@plus6 \p@ \relax
    \trivlist
    \item \relax
    \group_begin:
      \bfseries #1\@addpunct{:}
    \group_end:
    \hspace \labelsep \ignorespaces
    #2
  }
  {
    \popQED \endtrivlist \@endpefalse
  }


% 去掉目录的页码
% https://tex.stackexchange.com/questions/38847/clear-tableofcontents-page-in-book-or-report
\patchcmd{\tableofcontents}{\@starttoc{toc}}{\thispagestyle{empty}\pagestyle{empty}\@starttoc{toc}}{}{}
\let\t@bleofcontents\tableofcontents
\def\tableofcontents
  {
    \group_begin:
      \keys_set:nn { ctex }
        {
          chapter = {
                format = \zihao{-2} \normalfont \bfseries \centering
              }
        }
      \t@bleofcontents
      \thispagestyle{empty}
      \newpage
    \group_end:
  }

% 定义\ccnukaishu命令
\setCJKfamilyfont{zhkai}{FandolKai-Regular.otf}[AutoFakeBold]
\NewDocumentCommand \ccnukaishu   { } 
  { \CJKfamily { zhkai   } }
% 重定义\emph命令
\RenewDocumentCommand{ \emph }{ m  }
  {
    \group_begin:
      \ccnukaishu \bfseries #1
    \group_end:
  }
%% 下面重新设置目录样式
% 设置引导线
\renewcommand{\cftdot}{$\cdot$}  % 引导线的“点”的样式
\renewcommand{\cftdotsep}{1.2}
\renewcommand{\cftchapdotsep}{\cftdotsep}   % 设置章目录的引导线（默认是没有的）
% section前的额外垂直间距
\setlength{\cftbeforesecskip}{0.5\baselineskip}
% chapter前的额外垂直间距
\setlength{\cftbeforechapskip}{0.5\baselineskip}
% 页码样式，设置为无样式
\renewcommand{\cftchappagefont}{}

% 重新设置mainmatter的计数器，不让它重新计数
\patchcmd{\frontmatter}{\pagenumbering{roman}}{\pagenumbering{arabic}}{}{\fail}

% 重新设置mainmatter的计数器，不让它重新计数
\patchcmd{\mainmatter}{\pagenumbering{arabic}}{\renewcommand{\thepage}{\arabic{page}}}{}{\fail}


% 添加 exam-zh 项目的 choices 环境
% https://gitee.com/zepinglee/exam-zh/blob/main/exam-zh-choices.sty
\dim_new:N \l__examzh_choices_column_sep_dim
\int_new:N \l__examzh_choices_columns_int
\tl_new:N \l__examzh_choices_label_tl
\tl_new:N \l__examzh_choices_label_pos_tl
\dim_new:N \l__examzh_choices_label_sep_dim
\dim_new:N \l__examzh_choices_label_width_dim
\int_new:N \l__examzh_choices_max_columns_int

\keys_define:nn { exam-zh }
  { choices .meta:nn = { exam-zh / choices } {#1} }

\keys_define:nn { exam-zh / choices }
  {
    column-sep  .dim_set:N = \l__examzh_choices_column_sep_dim ,
    columns     .int_set:N = \l__examzh_choices_columns_int ,
    label       .tl_set:N  = \l__examzh_choices_label_tl ,
    label-pos   .choices:nn =
      { auto , top-left , left , bottom }
      { \tl_set_eq:NN \l__examzh_choices_label_pos_tl \l_keys_choice_tl } ,
    label-sep   .dim_set:N = \l__examzh_choices_label_sep_dim ,
    label-width .dim_set:N = \l__examzh_choices_label_width_dim ,
    max-columns .int_set:N = \l__examzh_choices_max_columns_int ,
  }

\keys_set:nn { exam-zh / choices }
  {
    column-sep  = 1em ,
    columns     = 0 ,
    label       = \Alph*. ,
    label-pos   = auto ,
    label-sep   = .5em ,
    label-width = 0pt ,
    max-columns = 4 ,
  }

\NewDocumentCommand \setchoices { m }
  { \keys_set:nn { exam-zh / choices } {#1} }


\tl_new:N \l__examzh_choices_counters_tl

\NewDocumentCommand \AddChoicesCounter { m m m }
  {
    \tl_put_right:Nn \l__examzh_choices_counters_tl
      { \l__examzh_process_counter:NN #1 #2 }
    \cs_set_eq:cN { __examzh_chioces_save_ \cs_to_str:N #1 : } #2
    \cs_set_eq:cN { __examzh_chioces_save_ \cs_to_str:N #2 : } #2
  }

\AddChoicesCounter \arabic \@arabic { 0 }
\AddChoicesCounter \alph   \@alph   { m }
\AddChoicesCounter \Alph   \@Alph   { M }
\AddChoicesCounter \roman  \@roman  { viii }
\AddChoicesCounter \Roman  \@Roman  { VIII }


\dim_new:N \l__examzh_choices_total_width_dim
\seq_new:N \l__examzh_choices_seq

\NewDocumentEnvironment { choices } { O { } +b }
  {
    \par \nopagebreak
    % 严格禁止孤行和寡行
    \int_set:Nn \clubpenalty { 10000 }
    \int_set:Nn \widowpenalty { 10000 }
    % 尽量避免在选项中间换行
    \int_set:Nn \interlinepenalty { 301 }
    \noindent
    \dim_set_eq:NN \l__examzh_choices_total_width_dim \linewidth
    \int_zero:N \l__examzh_choices_columns_int
    \dim_zero:N \l__examzh_choices_label_width_dim
    \keys_set:nn { exam-zh / choices } {#1}
  }
  {
    \seq_set_split:Nnn \l__examzh_choices_seq { \item } {#2}
    \seq_if_empty:NF \l__examzh_choices_seq
      { \seq_pop_left:NN \l__examzh_choices_seq \l_tmpa_tl }
    % 计算标签和选项内容的最大自然宽度
    \__examzh_choices_calc_max_width:N \l__examzh_choices_seq
    % label-pos = auto 时自动选择标签位置
    \__examzh_choices_set_auto_label_pos:
    % 如果用户没有声明列数，计算合适的列数
    \int_compare:nNnT { \l__examzh_choices_columns_int } < {1}
      { \__examzh_choices_calc_columns: }
    % 计算每个选项内容的宽度 \l__examzh_choices_item_width_dim
    \__examzh_choices_calc_item_width:
    % 输出选项
    \__examzh_print_choices:N \l__examzh_choices_seq
  }


\dim_new:N \l__examzh_choices_item_width_dim
\dim_new:N \l__examzh_choices_item_min_height_dim

% 计算标签和选项内容的最大宽度，
% 分别保存到 \l__examzh_choices_label_width_dim 和 \l__examzh_choices_item_width_dim
% #1: \l__examzh_choices_seq
\cs_new:Npn \__examzh_choices_calc_max_width:N #1
  {
    \dim_zero:N \l__examzh_choices_item_width_dim
    \dim_set_eq:NN \l__examzh_choices_item_min_height_dim \c_max_dim
    \seq_map_indexed_inline:Nn #1
      {
        % 标签
        \hbox_set:Nn \l_tmpa_box { \__examzh_choices_make_label:n {##1} }
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpa_dim } > { \l__examzh_choices_label_width_dim }
          { \dim_set_eq:NN \l__examzh_choices_label_width_dim \l_tmpa_dim }
        % 选项内容
        \hbox_set:Nn \l_tmpa_box {##2}
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpa_dim } > { \l__examzh_choices_item_width_dim }
          {
            \dim_set_eq:NN \l__examzh_choices_item_width_dim
              \l_tmpa_dim
          }
        % 找到最小高度
        \dim_set:Nn \l_tmpb_dim { \box_ht:N \l_tmpa_box }
        \dim_compare:nNnT
          { \l_tmpb_dim } < { \l__examzh_choices_item_min_height_dim }
          { \dim_set_eq:NN \l__examzh_choices_item_min_height_dim \l_tmpb_dim }
        \box_clear:N \l_tmpa_box
      }
  }


\int_new:N \l__examzh_choices_index_int

% \Alph* 生成正确的标签
\cs_new:Npn \__examzh_choices_make_label:n #1
  {
    \group_begin:
      \int_set:Nn \l__examzh_choices_index_int {#1}
      \l__examzh_choices_counters_tl
      \l__examzh_choices_label_tl
    \group_end:
  }

\cs_new:Npn \l__examzh_process_counter:NN #1#2
  {
    \cs_set:Npn #1 { \l__examzh_process_counter_aux:Nn #2 }
    \cs_set:Npn #2 { \l__examzh_process_counter_aux:Nn #2 }
  }

\cs_new:Npn \l__examzh_process_counter_aux:Nn #1#2
  {
    \tl_if_eq:nnTF {#2} { * }
      {
        \use:c { __examzh_chioces_save_ \cs_to_str:N #1 : }
          { \l__examzh_choices_index_int }
      }
      {
        \use:c { __examzh_chioces_save_ \cs_to_str:N #1 : } {#2}
      }
  }


% 超过这一高度阈值的选项视为插图模式
% 注意使用 tl
\tl_new:N \l__examzh_choices_figure_mode_threshold_tl
\tl_set:Nn \l__examzh_choices_figure_mode_threshold_tl { 2 \baselineskip }

\cs_new:Npn \__examzh_choices_set_auto_label_pos:
  {
    \tl_if_eq:NnT \l__examzh_choices_label_pos_tl { auto }
      {
        % 若最小高度超过阈值，推测其中包含插图，将标签位置改为左居中
        \dim_compare:nNnTF
          { \l__examzh_choices_item_min_height_dim } >
            { \l__examzh_choices_figure_mode_threshold_tl }
          { \tl_set:Nn \l__examzh_choices_label_pos_tl { left } }
          { \tl_set:Nn \l__examzh_choices_label_pos_tl { top-left } }
      }
  }


\int_new:N \l__examzh_tmp_int

% 计算选项的合适列数，存到 \l__examzh_choices_columns_int
\cs_new:Npn \__examzh_choices_calc_columns:
  {
    % 若标签不在底部，将 label-width 和 label-sep 算进来
    \tl_if_eq:NnF \l__examzh_choices_label_pos_tl { bottom }
      {
        \dim_add:Nn \l__examzh_choices_item_width_dim
          { \l__examzh_choices_label_width_dim + \l__examzh_choices_label_sep_dim }
      }
    \int_set:Nn \l__examzh_choices_columns_int
      {
        \int_div_truncate:nn
          { \l__examzh_choices_total_width_dim + \l__examzh_choices_column_sep_dim }
          { \l__examzh_choices_item_width_dim + \l__examzh_choices_column_sep_dim }
      }
    \int_compare:nNnTF { \l__examzh_choices_columns_int } = {0}
      { \int_set:Nn \l__examzh_choices_columns_int {1} }
    % 从允许的最大列数开始，每次除以 2，直到行宽允许排下
    \int_set_eq:NN \l__examzh_tmp_int \l__examzh_choices_max_columns_int
    \int_while_do:nNnn
      { \l__examzh_tmp_int } > { \l__examzh_choices_columns_int }
      {
        \int_set:Nn \l__examzh_tmp_int
          { \int_div_truncate:nn { \l__examzh_tmp_int } {2} }
      }
    \int_set_eq:NN \l__examzh_choices_columns_int \l__examzh_tmp_int
  }


% 计算选项的最终宽度，保存到 \l__examzh_choices_item_width_dim
\cs_new:Npn \__examzh_choices_calc_item_width:
  {
    \dim_set:Nn \l__examzh_choices_item_width_dim
      {
        ( \l__examzh_choices_total_width_dim
          - \l__examzh_choices_columns_int \l__examzh_choices_column_sep_dim
          + \l__examzh_choices_column_sep_dim
        ) / \l__examzh_choices_columns_int
      }
    % 若标签不在底部，将 label-width 和 label-sep 算进来
    \tl_if_eq:NnF \l__examzh_choices_label_pos_tl { bottom }
      {
        \dim_sub:Nn \l__examzh_choices_item_width_dim
          { \l__examzh_choices_label_width_dim + \l__examzh_choices_label_sep_dim }
      }
  }


\int_new:N \l__examzh_choices_current_col_int

% #1: \l__examzh_choices_seq
\cs_new:Npn \__examzh_print_choices:N #1
  {
    \int_zero:N \l__examzh_choices_current_col_int
    \seq_map_indexed_inline:Nn \l__examzh_choices_seq
      {
        \int_incr:N \l__examzh_choices_current_col_int
        % 当前列号重置为 1
        \int_compare:nNnT
          { \l__examzh_choices_current_col_int } > { \l__examzh_choices_columns_int }
          {
            % \par \noindent
            \newline
            \int_set:Nn \l__examzh_choices_current_col_int {1}
          }
        \int_compare:nNnT { \l__examzh_choices_current_col_int } > {1}
          {
            \skip_horizontal:N \l__examzh_choices_column_sep_dim
            % 增加一点弹性
            \skip_horizontal:n {0pt plus 1pt minus 1pt}
          }
        \__examzh_print_single_choice:nn {##1} {##2}
      }
    \par
  }


\coffin_new:N \l__examzh_choices_item_coffin
\coffin_new:N \l__examzh_choices_label_coffin

\cs_new:Npn \__examzh_print_single_choice:nn #1#2
  {
    % 选项标签
    \__examzh_choices_make_label_coffin:n {#1}
    % 选项内容
    \__examzh_choices_make_item_coffin:n {#2}
    % 合并选项的标签和内容
    \str_case:Vn \l__examzh_choices_label_pos_tl
      {
        { top-left }
          {
            \coffin_join:NnnNnnnn
              \l__examzh_choices_item_coffin  {l} {H}
              \l__examzh_choices_label_coffin {r} {H}
              { - \l__examzh_choices_label_sep_dim }
              { 0pt }
          }
        { left }
          {
            \coffin_join:NnnNnnnn
              \l__examzh_choices_item_coffin  {l} {vc}
              \l__examzh_choices_label_coffin {r} {vc}
              { - \l__examzh_choices_label_sep_dim }
              { 0pt }
          }
        { bottom }
          {
            \coffin_join:NnnNnnnn
              \l__examzh_choices_item_coffin  {hc} {b}
              \l__examzh_choices_label_coffin {hc} {t}
              { 0pt }
              % { - \l__examzh_choices_label_sep_dim }
              { 0pt }
          }
      }
    % 输出合并后
    \coffin_typeset:Nnnnn \l__examzh_choices_item_coffin {l} {H} {0pt} {0pt}
    \coffin_clear:N \l__examzh_choices_item_coffin
    \coffin_clear:N \l__examzh_choices_label_coffin
  }

% 将标签内容存入 coffin
\cs_new:Npn \__examzh_choices_make_label_coffin:n #1
  {
    \hcoffin_set:Nn \l__examzh_choices_label_coffin
      {
        \vcoffin_set:Nnn \l_tmpa_coffin
          { \l__examzh_choices_label_width_dim }
          { \noindent \hfill \__examzh_choices_make_label:n {#1} \strut }
        \coffin_typeset:Nnnnn \l_tmpa_coffin {l} {T} {0pt} {0pt}
        \coffin_clear:N \l_tmpa_coffin
      }
  }

\bool_new:N \l__examzh_choices_figure_mode_bool

% 将选项内容存入 coffin
\cs_new:Npn \__examzh_choices_make_item_coffin:n #1
  {
    \hcoffin_set:Nn \l__examzh_choices_item_coffin
      {
        % 优先尝试使用 bbox，这是因为在 \vcoffin_set 外部能保留原来的 \linewidth 和
        % \textwidth，方便用户在 \includegraphics 中使用
        \hbox_set:Nn \l_tmpa_box {#1}
        % 若盒子的自然高度大于 2 行，且深度为 0pt，设置为插图模式
        \bool_lazy_and:nnT
          {
            \dim_compare_p:nNn { \box_ht:N \l_tmpa_box } >
            { \l__examzh_choices_figure_mode_threshold_tl }
          }
          { \dim_compare_p:nNn { \box_dp:N \l_tmpa_box } < { 1pt } }
          { \bool_set_true:N \l__examzh_choices_figure_mode_bool }
        \vcoffin_set:Nnn \l_tmpa_coffin
          { \l__examzh_choices_item_width_dim }
          {
            \dim_set_eq:NN \parskip \c_zero_dim
            \dim_set_eq:NN \parindent \listparindent
            \noindent
            % \strut
            % 若标签在底部，将图片居中对齐。
            \tl_if_eq:NnT \l__examzh_choices_label_pos_tl { bottom }
              { \centering }
            \dim_compare:nNnTF
              { \box_wd:N \l_tmpa_box } > { \l__examzh_choices_item_width_dim }
              { #1 }
              { \box_use_drop:N \l_tmpa_box }
            % 使用 \strut 将行距撑开，防止跟下一行选项的间距过小
            \mode_if_horizontal:T { \strut }
          }
        \dim_set:Nn \l_tmpa_dim { \coffin_ht:N \l_tmpa_coffin }
        \bool_if:NT \l__examzh_choices_figure_mode_bool
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
    \exp_args:Nx \__examzh_choices_circled_number:n { \int_use:N \l_tmpa_int }
  }

\cs_new:Npn \__examzh_choices_circled_number:n #1
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
                    \msg_error:nnn { exam-zh / choices }
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

\msg_new:nnn { exam-zh / choices } { invalid-circled-number }
  { Invalid~ circled~ number~ #1. }

\AddChoicesCounter \circlednumber \__examzh_choices_circled_number:n {1}


% 把致谢和附录的标题代码封装
\NewDocumentCommand { \Appendix } { }
  {
    \chapter*{附录}
    \addcontentsline{toc}{chapter}{\normalfont 附录}   % 根据旧模版样式，如果有写附录，则需要把附录放进目录
  }
\NewDocumentCommand { \Acknowledgements } { }
  {
    \chapter*{\centerline{致 \quad 谢}}
    \addcontentsline{toc}{chapter}{\normalfont 致谢}   % 根据旧模版样式，如果有写致谢，则需要把致谢放进目录
  }
\ccnusetup
  {
    option / oneside ,
    style = 
      {
        font = times,
        % 西文字体（包括数学字体）
        % 允许选项：
        %   font = garamond|libertinus|lm|palatino|times|times*|none
        footnote-style = xits,
        % 脚注编号样式
        % 允许选项：
        %   footnote-style = plain|libertinus|libertinus*|libertinus-sans|
        %                    pifont|pifont*|pifont-sans|pifont-sans*|
        %                    xits|xits-sans|xits-sans*
        % 默认与西文字体保持一致
        hyperlink = none,
        % 超链接样式
        % 允许选项：
        %   hyperlink = border|color|none
        %
        hyperlink-color = default,
        % 超链接颜色
        % 允许选项：
        %   hyperlink-color = default|classic|material|graylevel|prl
        %
        bib-backend = biblatex,
        % 参考文献支持方式
        % 允许选项：
        %   bib-backend = bibtex|biblatex
        %
        bib-style = author-year,
        % 参考文献样式
        % 允许选项：
        %   bib-style = author-year|numerical|<其他样式>
        % 说明：
        %   author-year  著者—出版年制
        %   numerical    顺序编码制
        %   <其他样式>   使用其他 .bst（bibtex）或 .bbx（biblatex）格式文件
        %
        % cite-style = {},
        % 引用样式
        % 默认为空，即与参考文献样式保持一致
        % 仅适用于 biblatex；如要填写，需保证相应的 .cbx 格式文件能被调用
        %
      }
  }