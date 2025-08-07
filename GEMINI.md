# Gemini 代码助手上下文: CCNUthesis

## 目录概览

该目录包含 `CCNUthesis` 项目，这是一个为华中师范大学（CCNU）撰写学士、硕士和博士学位论文的 LaTeX 模板。它被设计为高度可定制的，允许用户配置个人信息、格式样式和参考文献偏好。

该模板的结构旨在将内容与表现形式分开。核心逻辑在 `CCNUthesis.cls` 类文件中定义，而用户特定的内容则被组织在 `body/`、`front/` 和 `back/` 目录下的独立 `.tex` 文件中。

## 关键文件

*   `main.tex`: 编译论文的主要入口文件。它加载 `CCNUthesis` 类，从 `ccnu-setup.tex` 引入用户配置，并组装文档的不同部分（摘要、章节、参考文献等）。
*   `ccnu-setup.tex`: 主要的配置文件。用户必须编辑此文件以提供他们的个人信息（姓名、标题、导师等），并自定义论文的外观（字体、页面布局、参考文献样式等）。
*   `CCNUthesis.cls`: 定义论文模板结构、布局和命令的 LaTeX 类文件。它包含了根据华中师范大学的要求格式化文档的核心逻辑。
*   `CCNUthesis-main.bib`: BibTeX 数据库，用户应在此处添加他们的文献条目。
*   `latexmkrc`: `latexmk` 构建工具的配置文件。它指定文档应使用 `xelatex` 进行编译。
*   `script/build.py`: 一个 Python 脚本，用于自动更新版本号、编译文档以及将模板打包成可分发的 `.zip` 文件。

## 使用方法

要使用此模板，请按照以下步骤操作：

1.  **配置您的论文：** 打开 `ccnu-setup.tex` 并在 `info` 部分填写您的个人和论文信息。您还可以在 `style` 部分自定义文档的样式。
2.  **撰写您的内容：**
    *   编辑 `front/` 目录中的文件以撰写摘要 (`abstract.tex`) 和符号表 (`notation.tex`)。
    *   在 `body/` 目录下的章节文件（`chapter1.tex`、`chapter2.tex` 等）中撰写论文的主体部分。
    *   在 `back/` 目录中为附录 (`appendix.tex`) 和致谢 (`acknowledgements.tex`) 添加内容。
3.  **添加您的参考文献：** 打开 `CCNUthesis-main.bib` 并以 BibTeX 格式添加您的文献条目。
4.  **编译您的论文：** 使用 `latexmk` 生成最终的 PDF 文档。

## 构建论文

要将论文编译成 PDF，您可以使用 `latexmk` 工具，该工具可以自动化 LaTeX 的编译过程。根目录中的 `latexmkrc` 文件已预先配置为使用 `xelatex` 作为编译器。

要构建项目，请在您的终端中运行以下命令：

```bash
latexmk
```

要清理编译过程中生成的辅助文件，请运行：

```bash
latexmk -c
```