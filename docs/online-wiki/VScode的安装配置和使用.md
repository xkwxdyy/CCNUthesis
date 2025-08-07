# 如何安装、配置和使用 VS Code?

## 目录
<!-- vscode-markdown-toc -->
* 1. [为什么推荐 VS Code 作为编辑器？](#VSCode)
	* 1.1. [为什么要使用编辑器？](#why-editor)
	* 1.2. [为什么不使用其它的编辑器？](#why-not-other-editor)
	* 1.3. [一些说明](#some-instructions)
* 2. [如何安装 VS Code？](#how-to-install-VSCode)
	* 2.1. [macOS](#macOS)
		* 2.1.1. [手动下载安装](#macOS-manually)
		* 2.1.2. [使用 Homebrew (没有进行测试, 欢迎反馈效果)](#Homebrew)
	* 2.2. [Windows](#Windows)
		* 2.2.1. [手动下载安装](#win-manually)
		* 2.2.2. [使用 Chocolatey (没有进行测试, 欢迎反馈效果)](#Chocolatey)
	* 2.3. [Linux](#Linux)
		* 2.3.1. [手动下载安装](#linux-manually)
		* 2.3.2. [通过软件源安装](#linux-from-source)
* 3. [如何配置 VS Code？](#config-VSCode)
	* 3.1. [配置中文语言](#lang-chinese)
	* 3.2. [安装`LaTeX-Workshop`插件](#LaTeX-Workshop)
	* 3.3. [进行`LaTeX-Workshop`的配置](#config-LW)
* 4. [如何使用 VS Code 编辑 LaTeX 文件并编译](#VSCodeLaTeX)
	* 4.1. [基础使用](#basic-usage)
	* 4.2. [正向和反向搜索](#synctex)
		* 4.2.1. [如何实现正向和反向搜索](#how-synctex)
		* 4.2.2. [Mac如何实现正向和反向搜索](#how-synctex-mac)
	* 4.3. [在一个目录中进行文本编辑和操作](#working-in-a-folder)
		* 4.3.1. [如何在 VS Code 中打开目录](#open-a-folder-in-VSCode)
* 5. [参考资料](#VScode-reference)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->
---


##  1. <a name='VSCode'></a>为什么推荐 VS Code 作为编辑器？

VS Code，全称 `Visual Studio Code`，是一款优秀的代码编辑器。

###  1.1. <a name='why-editor'></a>为什么要使用编辑器？

事实上，要使用 LaTeX 只需要一个文本编辑器和终端即可，但是一个好的编辑器某个程度上可以减少初学者的成本、提高使用效率，比如有自动补全、语法高亮等功能。对于 LaTeX 这种括号使用频繁的语言来说，语法高亮一定程度上可以帮助避免一些代码错误。

###  1.2. <a name='why-not-other-editor'></a>为什么不使用其它的编辑器？

TeXstudio 也是一款优秀的 LaTeX 编辑器，如果能配置好，使用起来也是十分高效，具体的配置在 [install-latex-guide-zh-cn.pdf](http://mirrors.ctan.org/info/install-latex-guide-zh-cn/install-latex-guide-zh-cn.pdf) 的第五章有介绍，如果感兴趣的用户可以自行查看。

但是作为一个模版开发者，我必须要考虑到用户的学习成本和配置上手难易程度，相比于 TeXstudio 的一条条配置，我觉得 VS Code 通过 `setting.json` 的统一配置更适合初学者或是对代码接触很少的用户，更容易通过教程进行安装配置。

VS Code 可以内部打开终端，特别是用 VS Code 打开目录后，“新建终端”会直接到对应的目录下，对于很少接触命令行的用户很友好。

虽然使用 VS Code 偶尔会出现界面不出现报错信息的情况，但是能通过内部打开终端通过命令行查报错，所以问题也不大。


###  1.3. <a name='some-instructions'></a>一些说明

考虑到每个人的喜好不同，如果你跟着我这个教程安装完 VS Code，使用一段时间后觉得不喜欢，完全可以使用 TeXstudio 等其它优秀的编辑器，比如 [install-latex-guide-zh-cn.pdf](http://mirrors.ctan.org/info/install-latex-guide-zh-cn/install-latex-guide-zh-cn.pdf) 的第五章或是知乎等都有介绍。VS Code 只是我的推荐，并不强求。

##  2. <a name='how-to-install-VSCode'></a>如何安装 VS Code？

###  2.1. <a name='macOS'></a>macOS

####  2.1.1. <a name='macOS-manually'></a>手动下载安装

到官网: <https://code.visualstudio.com/>，一眼就能看到下载的 UI，点击 “Download” 右边的箭头，找到 macOS，并下载，建议选择 “stable” 版本
![VS Code下载](https://images.gitee.com/uploads/images/2022/0301/215236_3dca6f83_7693572.png "屏幕截图.png")

####  2.1.2. <a name='Homebrew'></a>使用 Homebrew (没有进行测试, 欢迎反馈效果)

直接在终端运行

```bash
brew install --cask visual-studio-code
```

<!-- 可以通过[超级右键](https://apps.apple.com/cn/app/%E8%B6%85%E7%BA%A7%E5%8F%B3%E9%94%AE-irightmouse/id1497428978?mt=12) 软件来获得右键点击时的`进入 VSCode` 的选项。 -->

###  2.2. <a name='Windows'></a>Windows

####  2.2.1. <a name='win-manually'></a>手动下载安装

同 macOS 部分, 选择 Windwos x64，并下载，同样建议 “stable” 版本. 

在 Windows 版本安装的时候，可以选择安装路径，以及配置一些右键菜单的内容：

![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/203810_ffec354c_5424722.png "屏幕截图.png")

其中 1, 2 点是右键点击文件或文件夹时可以有 `通过 Code 打开` 的选项。`添加到 PATH` 可以让我们在终端/命令行中通过 `code <文件/文件夹>` 来通过 VS Code 打开文件/文件夹。

####  2.2.2. <a name='Chocolatey'></a>使用 Chocolatey (没有进行测试, 欢迎反馈效果)

使用管理员权限打开命令行, 并运行

```bash
choco install vscode
```

或者安装了 `sudo` 后, 运行 

```bash
sudo choco install vscode
```

###  2.3. <a name='Linux'></a>Linux

（Linux 使用者应该有自动查看文档/Google的能力）

####  2.3.1. <a name='linux-manually'></a>手动下载安装

其中 Debian 系与 Redhat 系可以在官网下载对应的 `.deb` 或 `.rpm` 版本的安装文件自行安装

####  2.3.2. <a name='linux-from-source'></a>通过软件源安装

查看官方文档：<https://code.visualstudio.com/docs/setup/linux> 或者在网上搜索 `发行版 vscode`， 如 `archlinux vscode` 通常都可以获得安装方法。

**注意**在 Arch Linux 上，`visual-studio-code-bin` 是在 AUR 仓库中，需要提前安装 `yay`，其他 Linux 发行版我不了解，欢迎补充。

##  3. <a name='config-VSCode'></a>如何配置 VS Code？

###  3.1. <a name='lang-chinese'></a>配置中文语言

安装完成打开，等待数秒会出现中文语言设置的，点击“安装并重启”。

![VS Code-中文](https://images.gitee.com/uploads/images/2022/0302/105410_5fd7dbef_7693572.png "VS Code-中文.png")

如果没来得及点，发现提示消失了，点击右下角的铃铛即可出现

![VS Code-中文-铃铛](https://images.gitee.com/uploads/images/2022/0302/105643_3c851f6e_7693572.png "VS Code-中文-铃铛.png")

点击之后**什么也不用做**，即使它页面有变化，等待它自己安装完成重启即可，出现下图的效果说明语言设置成功：

![VS Code-中文-成功](https://images.gitee.com/uploads/images/2022/0302/105822_775f6e16_7693572.png "VS Code-中文-成功.png")

###  3.2. <a name='LaTeX-Workshop'></a>安装`LaTeX-Workshop`插件

点击左侧工具栏的最下方的“拓展”

![VS Code-拓展](https://images.gitee.com/uploads/images/2022/0302/110121_32ac1e3f_7693572.png "VS Code-拓展.png")

输入`latex`

![VS Code-latexworkshop](https://images.gitee.com/uploads/images/2022/0302/110356_4cdd81e6_7693572.png "屏幕截图.png")

出来的第一个`LaTeX-Workshop`就是我们要的，点击安装

![VS Code-latexworkshop](https://images.gitee.com/uploads/images/2022/0302/110433_3dabfd96_7693572.png "屏幕截图.png")

等待一会，当左侧的“安装”消失了或者右侧的“安装”变成了“禁用”“卸载”就说明安装成功了

![VS Code-latexworkshop](https://images.gitee.com/uploads/images/2022/0302/110519_c6e4e584_7693572.png "屏幕截图.png")

可能你会发现左侧图标没有什么变化，但是当你用 VS Code 打开一个`.tex`文件后，你会发现左侧多了一个“TEX”图标，点击后出现一些英文：

![VS Code-latexworkshop-图标](https://images.gitee.com/uploads/images/2022/0302/143004_59bbf57b_7693572.png "屏幕截图.png")

下面来解释一下几个常用的，没介绍到的平时较少使用，：

- `Build LaTeX project`
  - 作用：编译
  - 点击`>`右边，则会用配置好的第一个编译方式进行编译
  - 点击`>`，则会出现所有配置好的编译方式或编译链
  ![Build LaTeX project](https://images.gitee.com/uploads/images/2022/0302/144322_e219d467_7693572.png "屏幕截图.png")
    - `Clean up auxiliary files`：清除部分中途文件
    - `Terminate current compilation`：终止编译，在代码出错导致编译停不下来时使用
    - `Recipe:xelatex`：使用`xelatex`方式编译一次
    - `Recipe:latexmk`：使用`latexmk`方式编译一次
    - `Recipe:xelatex*2`：使用`xelatex`方式编译两次
    - `Recipe:xelatex->bibtex->xelatex*2`：bibtex编译链，用于bibtex方式编译参考文献
    - `Recipe:xelatex->biber->xelatex*2`：biber编译链，用于biber方式编译参考文献
- `View LaTeX PDF`
  - 作用：查看编译出的PDF
  - 点击`>`右边，则会用配置好的默认查看方式进行，如根据上述VS Code配置，Windows用户是用VS Code内部阅读器打开，而Mac用户取决于是否配置Skim阅读器
  - 点击`>`，则会出现一些查看方式
  ![View LaTeX PDF](https://images.gitee.com/uploads/images/2022/0302/144610_97dbdf52_7693572.png "屏幕截图.png")
    - `View in VS Code tab`：在VS Code内部的阅读器中打开PDF
    - `View in web browser`：在默认浏览器中打开PDF
    - `View in external viewer`：在配置的外接阅读器中打开PDF，如果没有配置则点击无效
- `Navigate,select,and edit`
  - 作用：正向搜索以及一些环境的操作
  - 点击`>`或点击`>`右边都是出现子选项
  ![Navigate,select,and edit](https://images.gitee.com/uploads/images/2022/0302/145847_a6a7cd26_7693572.png "屏幕截图.png")
    - `SyncTeX from cursor`：正向搜索。将鼠标的光标点击在想要定位的`.tex`代码处，然后点击`SyncTeX from cursor`则会定位到PDF相应的部分。

  <!-- 最后一个 `Insert %!TeX root magic comment` 用于快速在子 `.tex` 文件中注明主 `.tex` 文件，这样就可以在子文件中直接运行 recipe 中的命令，VS Code 会自动去找到主文件并进行编译，而不需要点到主文件再编译 -->

###  3.3. <a name='config-LW'></a>进行`LaTeX-Workshop`的配置

**首先**，建议稍微有折腾精神的同学先尝试使用命令行编译，了解一下 `latexmk`, `pdflatex` 与 `xelatex` 的不同，了解一下各种参数的作用，如：`-syncetx=1`, `-interaction=nonstopmode`, `-shell-escape` 等等，对这些有了稍微的了解以后，再看这个 recipe, 就可以明白它在做什么了，也更容易配置出适合自己的 recipe.
但如果你觉得看的头疼，那就只需要跟着一步步做就行。 

按键盘的“F1”键（或是 `fn` + `F1`），会出现一个输入框，输入“setting”，然后选择“首选项：打开设置(json)”

![VS Code-setting](https://images.gitee.com/uploads/images/2022/0302/110856_7ef9d578_7693572.png "屏幕截图.png")

然后会打开一个`json`文件，里面只有两个花括号`{}`:

![VS Code-setting-花括号](https://images.gitee.com/uploads/images/2022/0302/111038_0dbcf2b2_7693572.png "屏幕截图.png")

它的主要格式为

```json
{
  "key1": val1,
  "key2": val2,
  ...
}
```

首先将下列代码复制到两个花括号中间并**保存！保存！保存！**（鼠标悬浮在下面的代码上，会发现代码框右上角出现一个复制按钮，点击即可复制）：

```json
"latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": [
        "-pvc-",
        "%DOCFILE%"
      ]
    },
    {
      "name": "latexmk-xelatex",
      "command": "latexmk",
      "args": [
        "-xelatex",
        "-synctex=1",
        "-interaction=nonstopmode",
        "-halt-on-error",
        "-file-line-error",
        "-pv",
        "%DOCFILE%"
      ]
    },
    {
      "name": "xelatex",
      "command": "xelatex",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    },   
    {
      "name": "pdflatex",
      "command": "pdflatex",
      "args": [
        "-synctex=1",
        "-interaction=nonstopmode",
        "-file-line-error",
        "%DOC%"
      ]
    },
    {
      "name": "bibtex",
      "command": "bibtex",
      "args": [
        "%DOCFILE%"
      ]
    },
    {
      "name": "biber",
      "command": "biber",
      "args": [
        "%DOCFILE%"
      ]
    }
  ],
  "latex-workshop.latex.recipes": [
    {
      "name": "xelatex",
      "tools": [
        "xelatex"
      ]
    },
    {
      "name": "latexmk-xelatex",
      "tools": [
        "latexmk-xelatex"
      ]
    },
    {
      "name": "xelatex*2",
      "tools": [
        "xelatex",
        "xelatex"
      ]
    },
    {
      "name": "xelatex -> biber -> xelatex*2",
      "tools": [
        "xelatex",
        "biber",
        "xelatex",
        "xelatex"
      ]
    },
    // // 如果不只为了 CCNUthesis 模板而使用 VS Code 编辑 LaTeX，可以取消注释以下配置以适用更多的文档，
    // // 如果需要使用 -shell-escape 选项，可以自行仿照上面的做法进行添加
    // {
    //   "name": "pdflatex",
    //   "tools": [
    //     "pdflatex"
    //   ]
    // },
    // {
    //   "name": "pdflatex -> bibtex -> pdflatex*2",
    //   "tools": [
    //     "pdflatex",
    //     "bibtex",
    //     "pdflatex",
    //     "pdflatex"
    //   ]
    // },
    // {
    //   "name": "pdflatex -> biber -> pdflatex*2",
    //   "tools": [
    //     "pdflatex",
    //     "biber",
    //     "pdflatex",
    //     "pdflatex"
    //   ]
    // },
    // {
    //   "name": "bibtex",
    //   "tools": [
    //     "bibtex"
    //   ]
    // },
    // {
    //   "name": "biber",
    //   "tools": [
    //     "biber"
    //   ]
    // },
  ],
    "latex-workshop.latex.clean.fileTypes": [
      "*.aux",
      "*.bbl",
      "*.blg",
      "*.idx",
      "*.ind",
      "*.lof",
      "*.lot",
      "*.out",
      "*.toc",
      "*.acn",
      "*.acr",
      "*.alg",
      "*.glg",
      "*.glo",
      "*.gls",
      "*.ist",
      "*.fls",
      "*.log",
      "*.fdb_latexmk"
  ],
  // 编译出错时是否通过弹窗显示
  "latex-workshop.message.error.show": false,
  "latex-workshop.message.warning.show": false,  
  "latex-workshop.synctex.afterBuild.enabled": true,
  // // 保存时就启动 Build 编译，Build 默认调用 recipe 中的第一条命令，这里默认注释掉，如果需要可以取消注释
  "latex-workshop.latex.autoBuild.run": "never",
  "editor.tabSize": 2,
  "editor.wordWrap": "bounded",
  // 取当前窗口大小和 wordWrapColumn 的最小值来决定 VS Code 中一行的换行位置
  "editor.wordWrapColumn": 120,
  // 编辑器字体大小设置
  "editor.fontSize": 16,
  // 当 VS Code 失去焦点时自动保存文件
  "files.autoSave": "onWindowChange",
  // 终端字体大小设置
  "terminal.integrated.fontSize": 17,
  // 对不同后缀的文件进行格式关联
  "files.associations": {
    "*.sty": "latex-expl3",
    "*.def": "latex-expl3",
    "*.tex": "latex",
    "*.cls": "latex-expl3"
  },
  // 更加醒目的括号配对
  "editor.guides.bracketPairs":"active",
  // 如何选择自动补全
  "editor.suggestSelection": "first",
```

耐心一点看看后半部分的注释，里面有一些我们经常用的配置，可以自行调整，鼠标放在 `key` 上的时候会有该设置的解释，当然，把 `key` 复制到左下角的齿轮里的`设置`（或者使用快捷键 `ctrl`+`,` 打开设置）中的搜索框中也可以看到对应的 `val` 的选项，比如，

![鼠标查看`key`的说明](https://images.gitee.com/uploads/images/2022/0303/200317_8e05b4c4_5424722.png "屏幕截图.png")

![设置中查看`val`的值](https://images.gitee.com/uploads/images/2022/0303/200416_1b3ad421_5424722.png "屏幕截图.png")

但是 VS Code 的配置远不止此，比如调节窗口的整体缩放，配置编辑器和终端的字体，可以在`设置`中查看其他的设置选项。

<!-- #### Windows用户

复制下面的代码

```json
{
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.view.pdf.internal.synctex.keybinding": "ctrl-click",
  "diffEditor.ignoreTrimWhitespace": false,

}
```

然后粘贴到打开的`json`文件中，保存，然后重启VS Code即可使用「注意：**原来的花括号要删除，因为上面的代码中有一样的花括号了，这样做是为了防止出现代码缩进问题**」

注意

```json
"latex-workshop.latex.autoBuild.run": "onSave",
```

设置效果是“ctrl+s”（win）或“command+s”（mac）保存后自动编译，也就是不用手动点击编译按钮，如果不想要这个功能的用户把`onSave`改为`never`即可，这样的话编译需要自己手动点击编译按钮。 -->

##  4. <a name='VSCodeLaTeX'></a>如何使用 VS Code 编辑 LaTeX 文件并编译


**注意**：这里不是来介绍“如何使用（学习）LaTeX”，相应的内容可以看 「[如何入门 LaTeX 的学习](./如何入门LaTeX的学习)」

###  4.1. <a name='basic-usage'></a>基础使用

在任意你喜欢的位置（尽管说是任意，也不要建在奇怪的位置）建立一个文件夹，名为 `testlatex`，然后用 VS Code 打开这个文件夹

- 如果在安装的时候选择了“将‘通过 Code 打开’添加到上下文菜单”的话，或者使用了mac系统的超级右键，那么可以`在文件夹上右键 -> 选择“进入 VScode”`
- 如果没有上面的这个东西，可以用命令行进入 `testlatex` 文件夹，然后运行 `code .`
- 如果也不会用命令行，那可以先打开 VS Code，在左上角的文件处，点击`打开文件夹`来打开 `testlatex`。

如果这还不会，那我们建议先进行一些计算机基础的学习（

打开后应该如下图

![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/205948_66158df4_5424722.png "屏幕截图.png")

为什么我们要在一个文件夹中操作呢？见「[在一个目录中进行文本编辑和操作](#working-in-a-folder)」

先新建一个文件，名为 `main.tex`，我们可以

- 使用快捷键 `ctrl`+`n` (Windows, Linux) 或 `⌘command`+`n` (mac) 新建一个文件，再使用 `ctrl`+`s` (Windows, Linux) 或 `⌘command`+`s` (mac) 保存，名为 `main.tex`
- 点击 ![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/210650_c2b79768_5424722.png "屏幕截图.png") 来新建一个文件，改名为 `main.tex`.

然后在这个文件中写入如下内容

```tex
\documentclass{article}
\begin{document}
    Hello \LaTeX
\end{document}
```

我们可以注意到当输入 `\documentclass`, `\begin{document}` 以及 `\LaTeX` 的过程中都有自动补全的出现，可以使用回车或者`Tab`来进行补全。

![自动补全](https://images.gitee.com/uploads/images/2022/0303/212145_25fa372c_5424722.gif "动画.gif")

然后点击左侧的 ![TEX](https://images.gitee.com/uploads/images/2022/0303/212556_920cee06_5424722.png "屏幕截图.png") 中的 `Build LaTeX Project` 中的 `Recipe: xelatex`，等待左下角转完变成`√`

![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/213253_7e24a805_5424722.png "屏幕截图.png")

然后点击右上角的 ![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/213931_520eb5dd_5424722.png "屏幕截图.png") 来打开 PDF 文件，在第一次打开的时候会要求选择默认的阅读器，我们这里先选择使用内部阅读器 `VSCode tab`，然后会看到右侧打开了一个 PDF 文件：

![输入图片说明](https://images.gitee.com/uploads/images/2022/0303/214340_f01c45ad_5424722.gif "编译.gif")

至此我们完成了第一个 TeX 文档的编写与编译。

###  4.2. <a name='synctex'></a>正向和反向搜索

- **正向搜索**指：根据`.tex`文件的代码定位PDF的对应位置

- **反向搜索**指：根据PDF的位置反向找到源代码的位置

注意：正向和反向搜索前，需要用 VS Code 编译一次，也就是定位的 PDF 需要是 VS Code 编译产生的才行

*准确地说，正反向搜索需要 `.synctex.gz` 文件，如果在命令行/终端编译的话，需要加 `-synctex=1` 选项，而我们刚为 VS Code 配置的 recipe 中包含了这个选项*

####  4.2.1. <a name='how-synctex'></a>如何实现正向和反向搜索

首先按照上一步在 VSCode tab 中打开 PDF 文件。

- 正向搜索，这里有三种方法
  - 将鼠标的光标点击在想要定位的`.tex`代码处，然后点击左侧 ![TEX](https://images.gitee.com/uploads/images/2022/0303/212556_920cee06_5424722.png "屏幕截图.png") 图标的 `Navigate,select,and edit` 中的 `SyncTeX from cursor`，则会定位到 PDF 相应的部分。
  - 将在想进行正向搜索的位置点击右键，选择 `Synctex from cursor`。
  - 使用快捷键 `ctrl`+`alt`+`j` (Windows, Linix) 或 `⌘command` + `⌥option` + `j` (mac)

![windows 示例](https://images.gitee.com/uploads/images/2022/0303/221001_725e5a9a_5424722.gif "synctex-forward.gif")

- 反向搜索：`ctrl`+ click。找到 VS Code 的内置阅读器打开的PDF中你想定位的部分，按住 `ctrl` 键，鼠标点击一下，然后`.tex`文件就会跳转到相应代码附近，并将该处代码高亮

![windows 示例](https://images.gitee.com/uploads/images/2022/0303/221714_ee7372da_5424722.gif "synctex-backward.gif")

#### 4.2.2. <a name='how-synctex-mac'></a> Mac如何实现正向和反向搜索

- 正向搜索：除了和上述Windows相同的方式外，还有有两种方式
  - 可以点击鼠标右键，有一个`SyncTeX from cursor`，点一下即可。（相当于有两种方式点击`SyncTeX from cursor`）
    ![mac-正向搜索](https://images.gitee.com/uploads/images/2022/0302/150732_6208a702_7693572.png "屏幕截图.png")
  - 将鼠标的光标点击在想要定位的`.tex`代码处，然后键盘快捷键：`⌘command` + `⌥option` + `j`
- 反向搜索
  - 没有配置Skim：`⌘command`+ click。找到VS Code的内置阅读器打开的PDF中你想定位的部分，按住`⌘command`键，鼠标点击一下，然后`.tex`文件就会跳转到相应代码附近
  - 配置了Skim：`⌘command` + `⇧shift` + click。找到VS Code的内置阅读器打开的PDF中你想定位的部分，按住`⌘command`键和`⇧shift`键，鼠标点击一下，然后`.tex`文件就会跳转到相应代码附近

###  4.3. <a name='working-in-a-folder'></a>在一个目录中进行文本编辑和操作

![VS Code](https://images.gitee.com/uploads/images/2022/0302/160021_2e94105e_7693572.png "屏幕截图.png")

这个特别适合处理一些比较大的项目，比如

- 学位论文，需要编辑主文件、分文件和`bib`文件等
- 宏包或文类开发，需要编辑`README`、`CHANGELOG`、主文件、测试文件等等

如果每次都要去打开某个目录再去双击打开文件，会比较麻烦。这个在VS Code内就有文件接口的特性可以让项目更加“沉浸”和高效地完成（因为几乎只需要打开这一个软件（除非是外置阅读器等等）就可以完成几乎所有代码工作），我个人非常喜欢这个特性。

####  4.3.1. <a name='open-a-folder-in-VSCode'></a>如何在 VS Code 中打开目录

1. 在刚打开VS Code后点击`打开`
  ![](https://images.gitee.com/uploads/images/2022/0302/170755_28f5b6c2_7693572.png "屏幕截图.png")

2. 或者在左上角点击`文件`然后点击`打开文件夹`
  ![](https://images.gitee.com/uploads/images/2022/0302/171338_9c9a3dfb_7693572.png "屏幕截图.png")
  ![](https://images.gitee.com/uploads/images/2022/0302/171421_22811208_7693572.png "屏幕截图.png")

然后选择所需的目录（注意不是目录的某个子目录，否则左侧只有子目录会显示）点击打开即可
![](https://images.gitee.com/uploads/images/2022/0302/170930_6491dd62_7693572.png "屏幕截图.png")

然后就可以开始使用了

![](https://images.gitee.com/uploads/images/2022/0302/171733_cf1aacc6_7693572.png "屏幕截图.png")


# 5. <a name='VScode-reference'></a>参考资料

- [ LaTeX 编译环境配置：Visual Studio Code配置简介](https://github.com/EthanDeng/vscode-latex/blob/master/main.pdf)